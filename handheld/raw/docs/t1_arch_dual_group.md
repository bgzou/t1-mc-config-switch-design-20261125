# 摘录 · 300 的双执行组（策略 100 Hz + 动画 250 Hz）

真机上有 **4 个动作**是"双执行组"的，全部是"RL 管下肢 + 经典控制管上肢"的组合：

| Action | 组 0（RL） | 组 1（经典） | 两个节拍 |
|---|---|---|---|
| **300 双足 WBC** | `rl_bi_loco_wbc` **10 ms** | `animation_player` **4 ms（250 Hz）** | 100 Hz + 250 Hz |
| **301 双足动画** | `rl_bi_loco_animation` 10 ms | `animation_player` **2 ms（500 Hz）** | 100 Hz + 500 Hz |
| **302 上肢录制** | `rl_bi_loco_wbc` 10 ms | `biped_record` 10 ms | 100 Hz + 100 Hz |
| **1014 二开上肢** | `rl_bi_loco_wbc` 10 ms | `custom_upper` 10 ms | 100 Hz + 100 Hz |

**核心机制：一个执行组 = 一条周期定时线程。**

```mermaid
sequenceDiagram
    autonumber
    participant L as 组0 线程<br/>rl_bi_loco_wbc · 10 ms
    participant A as 组1 线程<br/>animation_player · 4 ms
    participant J as 关节命令缓冲<br/>按关节名索引
    participant P as rt_joint_pub<br/>≈196 Hz
    participant D as device_manager<br/>1 kHz PD

    Note over L: SCHED_RR 80 · CPU3
    Note over A: SCHED_RR 80 · CPU3

    loop 每 10 ms
        L->>L: 推理（下肢 + 轮，14 维输出）
        L->>J: 写 RL/RR 腿 + 轮 + （软化的）FL/FR
    end
    loop 每 4 ms（比 loco 快 2.5 倍）
        A->>A: CSV 关键帧插值（上肢 6 关节）
        A->>J: 覆盖 FL/FR 六关节
    end
    J->>P: 最新合并结果
    P->>D: JointCommandArray（UPPER/LOWER/WHEEL）
    D->>D: 1 kHz 做 PD + CAN
```

#### 关键点一：两个线程，但**不并行在两个核上**

`action_setting.yaml` 里两个组的 `cpu_affinity` 都是 `[]`（空）——**继承进程绑定**，也就是都在 CPU3 上。
实测证据：两个组的日志分别打 `t0/TID5050` 和 `t1/TID5051`，两条不同的线程。

所以准确说法是：**并发（concurrent）但不是多核并行（parallel）**。
两个 SCHED_RR 80 的线程在同一个核上按时间片轮转；因为 4 ms 的动画线程工作量很小（查表 + 插值），不会把 10 ms 的推理线程挤掉。
