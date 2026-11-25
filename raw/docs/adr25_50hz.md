# ADR-25：Collie 策略推理采用 50 Hz（20 ms）

**状态**：提议（Proposed），尚未替换 V1.2 正文  
**日期**：2026-11-23  
**影响**：Worker 调度、RunnerManifest、`can_exit` 时效、RT 保持、黑匣子采样、测试基线  
**不改变**：T1 的 100 Hz 事实；`mc_safety` 100 Hz；HAL/PD 1 kHz；RT 200 Hz

---

## 1. 背景

Collie 训练侧使用 **50 Hz**：`dt = 0.02 s`，一个策略步 20 ms。  
V1.1/V1.2 的“Worker 100 Hz + 7.6/10 ms”来自 T1 的部署基线；T1 大多数策略是 `dt=0.01` + 10 ms，只有 `BIPED_NPZ_MIMIC` 是 50 Hz。Collie 的训练频率与 T1 不同，不能直接沿用 100 Hz。

T1 的证据（保留，不改）：

- [T1 运控架构详解 §6.6 关键点四～六](../01_总体架构/T1运控架构详解.md#L497-L606)；
- T1 策略逻辑 100 Hz，WBC 单拍 ~10.5 ms，已贴近 10 ms；
- T1 的 ≈196 Hz 关节发布是**零阶保持**，不是 50→100 插值；
- 唯一 50 Hz 策略是 `BIPED_NPZ_MIMIC`（`dt=0.02` + 20 ms）。

---

## 2. 决策

### 2.1 基线

| 项 | 决策 | 说明 |
|---|---|---|
| 策略推理 | **50 Hz / 20 ms** | `RunnerManifest.period_ms = 20` |
| Worker | **50 Hz / 20 ms** | 每个 tick 调一次 `step()`；不跑 100 Hz 空转 |
| RT | **200 Hz / 5 ms** | 保持 200 Hz；只读最新有效候选 |
| RT 发布 | **零阶保持（ZOH）** | 每个策略目标保持 4 个 RT tick；不默认插值 |
| HAL / PD | 1 kHz | 不变 |
| `mc_safety` | 100 Hz | 不变 |
| `MotionStatus` | 50 Hz | 不变 |

**Worker = 50 Hz，不是 100 Hz。**  
如果未来出现 100 Hz 策略，再把 `period_ms` 改为 10、Worker 改为 100 Hz；架构按 `period_ms` 配置，不写死。

### 2.2 为什么不是“Worker 100 Hz + 每两拍推理一次”

可以这样做，但没有收益：

- 多出来的 10 ms tick 不产生新策略目标；
- 观测/历史如果按 10 ms 更新，会与训练侧 20 ms 的 `dt` 不一致；
- 容易让读者误以为策略是 100 Hz；
- 50 Hz 策略在 20 ms 内算完，CPU 余量更大。

只有多 Runner 混频（例如 50 Hz 行走 + 100 Hz 上肢/动画）才需要 100 Hz 基 tick + `due` 计数器；Collie 首版不需要。

### 2.3 RT 200 Hz 发布：默认是保持，不是插值

50 Hz 策略每 20 ms 出一个关节目标；RT 每 5 ms 运行一次，因此一个目标会被发布 **4 次**：

```text
策略 tick：  T0        T1(20ms)      T2(40ms)
目标：       q0        q1            q2
RT 发布：    q0 q0 q0 q0  q1 q1 q1 q1  q2 ...
             ↑ 4 个 5ms tick = 零阶保持
```

**这不是插值**，是把最新目标重复发。它与训练侧“一个 action 保持 20 ms（control_decimation）”一致。

如果要做插值/斜坡，必须：

1. 明确它是**输出整形**，不是“策略以 200 Hz 推理”；
2. 确认训练侧也用了同样的 hold/interp；否则闭环动力学变了；
3. 在 `ActionCodec`/`OutputGuard` 中实现，限幅/限速，并在 HIL 验证；
4. 不能把 200 Hz 插值当成“提高策略频率”。

对位置目标，50 Hz ZOH + 1 kHz PD 是常见组合；对力矩/速度目标，要保持/整形的安全性单独评估。

---

## 3. 参数修改

| 参数 | 旧（100 Hz 基线） | 新（50 Hz） | 原因 |
|---|---:|---:|---|
| `RunnerManifest.period_ms` | 10 | **20** | 训练 `dt=0.02` |
| `Worker` tick | 10 ms | **20 ms** | 与策略同步 |
| `worker_budget_ms` | 7.6 / 10 | **15 / 20** | 5 ms 裕量；模型 WCET 待测 |
| `candidate deadline` | tick+8 ms | **tick+15 ms** | 不超过 20 ms |
| `exit_decision` `valid_until` | 10 ms | **25 ms** | 20 ms 周期 + 5 ms 裕量 |
| `max_hold_ns` | 10 ms | **25 ms** | 允许跨一个策略周期；超时走安全路径 |
| `snapshot_seq` 允许差 | ≤2（200/100） | **≤4（200/50）** | 4 个 RT tick/策略 tick |
| 黑匣子 Worker 采样 | 100 Hz | **50 Hz** | 采样率随 Worker |
| `can_exit` 竞态窗口 | 10 ms | **20 ms（更危险）** | P0 必须先修 |

> `worker_budget_ms=15` 是初始目标，不是 Collie 实测 WCET。若模型 >15 ms，50 Hz 也不够，必须先优化/换模型，不能靠 100 Hz“解决”。

### 3.1 关键：`can_exit` 的 TTL 不能还是 10 ms

50 Hz 下，一个 `READY` 决策从 t=0 到下一次决策 t=20 ms 之间都可能是“最新”的。  
如果 TTL 仍是 10 ms，RT 在 10–20 ms 之间会误判过期；如果 TTL 改成 25 ms，又会把 P0 的“READY 在 step 前发布”窗口放大到 20 ms。

所以：

- 先修 P0：`READY` 只在 `step()` 成功返回后发布，并绑定 `last_completed_step_seq/phase_seq/fault_seq`；
- RT 只接受“最近成功 step”的 READY；
- 再把 TTL 设为 25 ms；
- 测试必须覆盖“READY → step 挂死 50 ms / NaN / phase 变更 → RT 0 次提交”。

**50 Hz 不会让 P0 变轻，反而让窗口翻倍。**

### 3.2 `snapshot_seq` 差值

RT 200 Hz、Worker 50 Hz：一个 Worker 周期内 RT 最多推进 4 个 snapshot。  
`snapshot_seq` 差 ≤4 是名义值；调度抖动时可允许 ≤5，但必须同时满足 `age ≤25 ms`。不要把“≤4”单独当安全判据。

---

## 4. 文档影响清单

| 文档/章节 | 要改什么 |
|---|---|
| `00_导读` | 五层图 100→50；三时钟 50/200/1k；Worker 例子 10→20 ms |
| Part1 D0 / ADR-05 | “100 Hz 策略”改为“50 Hz 策略 + 200 Hz 发布（ZOH）”；进程表/时序表 |
| Part2 D3.1/D3.4/D3.5 | `period_ms=20`、`worker_budget=15`；`can_exit` TTL 25 ms；`on_10ms_tick`→`on_20ms_tick` |
| Part3 D5.7 | 标题/预算/时间轴 10→20 ms、7.6→15 ms；`max_hold` 25 ms；保持而非插值 |
| Part4 D7.5/D8.1 | `snapshot_seq` ≤4；Worker 10 ms/100 Hz→20 ms/50 Hz；TTL/CPU 表 |
| Part5 D9.1/D10.2 | Manifest 示例；黑匣子 100→50 Hz、819200→409600 B/s |
| Part6 ADR-05 | 改为 50 Hz；新增“为什么不是 100 Hz/插值” |
| Appendix B | `ExitDecision` 的 `snapshot_seq` 差、`valid_until`；`period_ms` 示例 |
| Deck | 第 2/3/4/9/10 页的 100 Hz/10 ms/7.6 全部改为 50 Hz/20 ms/15；备注同步 |
| `DECK_GUIDE` | 5/15/30 分钟讲法中的 100 Hz/10 ms |

**T1 证据不要改**：T1 的 100 Hz、196 Hz 发布、10.5 ms WBC 是实测/配置事实，保留并注明“T1 vs Collie 差异”。

---

## 5. 测试基线

必须新增/修改：

1. **50 Hz 调度**：20 ms tick，`step` 每拍一次；无 10 ms 空转。
2. **4:1 保持**：一个策略目标在 RT 200 Hz 下连续发 4 次；第 5 次前必须有新候选或进入安全路径。
3. **候选过期**：`age >25 ms` → 不发布正常目标；`max_hold` 生效。
4. **`snapshot_seq` 差**：0–4 正常，5 在 age 允许时可接受，>5 拒绝。
5. **`can_exit` P0**：READY→step 挂死/NaN/phase 变更→RT 0 次提交。
6. **频率不匹配防护**：Manifest `period_ms=20` 的模型不得按 10 ms 调用；配置校验拒绝。
7. **黑匣子**：50 Hz 采样下 30+10 s 窗口完整。
8. **HIL**：真实 HAL watchdog、1 kHz PD、50 Hz 策略的端到端时延/抖动。

---

## 6. 不做什么

- 不把 T1 的 100 Hz 事实改成 50 Hz；
- 不把 `mc_safety` 100 Hz、HAL 1 kHz、RT 200 Hz 改掉；
- 不默认在 RT 做 50→200 插值；
- 不在 P0 未修时开放切换；
- 不用“100 Hz Worker + 50 Hz 策略”制造“更高频率”的假象。

---

## 7. 结论

**Collie 首版：50 Hz 策略、50 Hz Worker、200 Hz RT、ZOH 发布、15/20 ms 预算、25 ms TTL/hold。**  
这不是降级，而是与训练 `dt=0.02` 对齐；T1 的 100 Hz 是 T1 的选择，不是 Collie 的默认。
