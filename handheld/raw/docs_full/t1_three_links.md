# 运控三大核心链路设计分析：安全 · 切换 · 整形

> 目标：**不是复述 T1，而是提炼出可迁移到其他四足机器人的架构**。
> 每个结论都给"T1 怎么做"与"通用化怎么做"两层，并标注证据来源。
> 三源交叉：① 本地文档（`T1运控安全设计详解.md` 等）；② Z 盘原始配置/日志；③ 站点 `192.168.10.35:8081`、`192.168.10.200:8211`。

---

## 0. 阅读方式与证据分级

| 标记 | 含义 | 主要来源 |
|---|---|---|
| 【配置】 | 板端 YAML 原文 | Z 盘 `robot_rk/software/*/bin/cfg` |
| 【日志】 | 真机日志原文 | Z 盘 `persist/log/mc/mc.log` |
| 【实测】 | 由日志时间戳/计数算出 | 同上 |
| 【站点】 | 两台分析站的报告 | site35 / site200 |
| 【设计】 | 4+1 设计文档 | `Design_T1Pro...简版.md` |
| 【推断】 | 多证据推理，未直接验证 | — |

**可迁移性原则**：凡是被标为【配置】的数值，都是"某台机器标定出来的"，迁移时**必须重标**；
凡是被标为【设计】的结构（分层、时序、接口），才是可以整段搬走的。

---

## 1. 全景：三条链路的分工

```mermaid
flowchart TB
    subgraph UP["上游"]
        U1["平台/任务：动作请求"]
        U2["导航/跟随：速度"]
        U3["感知识别：避障覆写"]
        U4["平台/SM：急停"]
    end

    subgraph ADMIT["① 准入（Admission）"]
        A1["任务级前置条件"]
        A2["动作级：拓扑 / 姿态 / 频率"]
        A3["速度级：源 / 优先级 / TTL"]
        A4["安全级：看护状态 / lease"]
    end

    subgraph SHAPE["② 整形（Adapter）"]
        S1["输入：滤波 · 缩放 · 裁剪 · 历史"]
        S2["策略：推理 / 插值 / 位控"]
        S3["输出：尺度 · 增益 · 限幅 · 作用域"]
        S4["设备：MIT 量程 · 软限位 · 零偏"]
    end

    subgraph SWITCH["③ 切换（Switching）"]
        W1["形态：四足⇄双足"]
        W2["动作：mimic / 表演"]
        W3["速度源：谁在踩油门"]
        W4["交接：退出 → 混合 → 接管"]
    end

    subgraph SAFE["安全（横切）"]
        F1["看护 50 ms"]
        F2["超时与命令过期"]
        F3["降级阶梯"]
    end

    UP --> ADMIT --> SHAPE --> OUT["关节命令 200 Hz"]
    SWITCH --> SHAPE
    SAFE -.->|"否决 / 降级"| ADMIT
    SAFE -.->|"撤销许可"| SHAPE
```

**三条链路的职责边界**（这是迁移时最先要划清的）：

| 链路 | 回答的问题 | 谁可以改 | 典型失败 |
|---|---|---|---|
| 准入 | 这个请求**允不允许**发生 | 策略/配置 | 不该切的动作被切了、该停的没停 |
| 整形 | 允许之后，**怎么变成**关节目标 | 标定/参数 | 量纲错、超限、抖动、走偏 |
| 切换 | 从 A 到 B **怎么过渡** | 状态机 | 跳变、卡死、双写冲突 |
| 安全 | 出问题时**怎么兜底** | 独立模块 | 漏判、误判、降级不及时 |

---

# Part A　安全层设计

## A1 失效模型：先定义"怕什么"

| 编号 | 危险 | 触发条件 | 后果 |
|---|---|---|---|
| H1 | 跌倒 | 被推、打滑、台阶、步态失稳 | 摔机、撞人、关节撞地 |
| H2 | 失控运动 | 指令断流、源抢占、遥控丢包 | 冲撞、坠楼 |
| H3 | 过力过速 | 堵转、撞障、参数误改 | 烧电机、断结构 |
| H4 | 夹伤碰撞 | 变形时有人靠近、手臂挥动 | 人员受伤 |
| H5 | 卡死失联 | 进程崩溃、内存耗尽、CPU 被抢 | 僵住或乱动 |

**通用原则**：安全设计从**失效模型**出发，而不是从"加个急停"出发。每一条 H 都要能回答：谁检测、多久检测到、检测到之后做什么、如果检测失败还有谁。

## A2 分层结构：八层纵深

```mermaid
flowchart TB
    L0["L0 电机/机构<br/>MIT 量程 · 软限位 · 堵转曲线"]
    L1["L1 驱动/命令<br/>实时线程 · 命令过期 · 反馈超时"]
    L2["L2 动作准入<br/>任务前置 · 拓扑 · 姿态 · 频率"]
    L3["L3 姿态看护<br/>三通道跌倒 + 白名单"]
    L4["L4 动作兜底<br/>PASSIVE / DAMPING / 全局出口 / 恢复链"]
    L5["L5 感知安全<br/>避障覆写 · 禁行区"]
    L6["L6 系统状态<br/>模式机 · EStop · OTA"]
    L7["L7 资源/进程<br/>隔离核 · cgroup · OOM · 重启上限"]
    L8["L8 电源<br/>分级提示 · 低电趴下 · 充电门槛"]
    HW[("电机 / 人")]
    L0 --> HW
    L1 --> L0
    L2 --> L1
    L3 --> L2
    L4 --> L3
    L5 --> L4
    L6 --> L5
    L7 --> L6
    L8 --> L7
```

| 层 | T1 的实现 | 证据 | 迁移时是否照搬 |
|---|---|---|---|
| L0 | MIT p±10 / v±60 / t±60 / kp 0~500 / kd 0~10；关节软限位 | 【配置】`device_manager` | **参数重标**，机制照搬 |
| L1 | 实时线程 RR80/85；命令过期 200 ms；反馈超时 10 ms | 【配置】`mc_T1.yaml` | 照搬 |
| L2 | 任务 precondition（电量/姿态/连接）；动作拓扑；IMU 姿态门 ±0.12 rad | 【配置】`task_rules.yaml`、`action_state.yaml` | 照搬 |
| L3 | 三通道跌倒，50 ms 周期，白名单 | 【配置】`security_guard.yaml` | 算法照搬，阈值重标 |
| L4 | PASSIVE/DAMPING + 3 个全局出口 + 恢复链 | 【配置】`action_ruler.yaml` | 照搬 |
| L5 | `coreon_fusion` priority 100，零速可抢 | 【配置】 | 照搬 |
| L6 | SM 9 模式 × 10 功能组，EStop 只留 HAL+Diagnosis | 【配置】 | 按新系统裁剪 |
| L7 | `isolcpus=2,3`、cgroup、OOM 免杀、重启上限 | 【配置】 | 照搬 |
| L8 | 30/15/10% 提示，5% 趴下，变形 ≥5%，OTA ≥50% | 【配置】`low_battery_voice.yaml`、`extreme_action_progress.yaml` | 阈值按产品定 |

## A3 跌倒判定：三通道算法（可直接搬）

**核心思想**：单通道必然漏报或误报，所以用**三个正交信号**各自计数、任一触发。

```mermaid
flowchart TB
    T["每 50 ms"] --> W{"当前动作在监控名单？"}
    W -->|"否"| SKIP["跳过（不保护）"]
    W -->|"是"| C1["通道1：姿态角 delta > 60°<br/>连续 3 次"]
    W --> C2["通道2：|ω| > 6 rad/s 且 delta > 48°<br/>连续 3 次"]
    W --> C3["通道3（仅双足）：脚-躯干<br/>水平>0.8m 或 竖直<0.4m，连续 20 次"]
    C1 --> T1{"任一命中"}
    C2 --> T1
    C3 --> T1
    T1 -->|"是"| FALL["is_fallen → 切 DAMPING"]
    T1 -->|"否"| RESET["计数回落（45° 迟滞）"]
```

| 参数 | T1 值 | 含义 | 迁移建议 |
|---|---|---|---|
| `fall_delta_threshold` | **60°** | 角度阈值 | 按机身高度/腿长重标（越高越早判） |
| `fall_count_threshold` | **3** | 连续帧数 | 50 ms 周期下 = 150 ms 确认 |
| `gyro_norm_threshold_rad_s` | **6.0** | 角速度阈值 | 按最大角速度重标 |
| `fall_delta_soft_threshold` | **48°** | 角速度通道的软角度 | 保持"比主阈值低 12°"的比例 |
| `stand_arm_delta` | **45°** | 复位迟滞【推断】 | 与主阈值差 15° |
| 脚水平/竖直/次数 | **0.8 m / 0.4 m / 20** | 仅双足 | 双足才需要；四足可省 |
| 监控名单 | 双足 14 / 四足 19 | 只保护"该保护的动作" | 按动作表维护 |

**站点佐证**：`site200/t1-runtime` 记录的"跌倒切阻尼（S09）"样本与 11 ms 切换时延一致【站点】。

## A4 安全动作与恢复

```mermaid
stateDiagram-v2
    [*] --> NORMAL
    NORMAL --> DAMPED: 跌倒 / 命令断流 / 看护命中
    DAMPED --> PASSIVE: 人工急停
    PASSIVE --> CUT: 硬件急停
    DAMPED --> RECOVER: 显式恢复请求
    RECOVER --> NORMAL: 姿态达标且稳定 1 s
```

| 动作 | 语义 | 何时用 | 风险 |
|---|---|---|---|
| `PASSIVE` | 零力矩（瘫软） | 严重故障、人工急停 | 会直接倒下 |
| `DAMPING` | 阻尼（缓慢倒） | 跌倒、断流 | 需要时间 |
| `QUAD_LIE_DOWN` | 主动趴下 | 低电、关机前 | 需要空间 |
| 恢复链 | DAMPING→PASSIVE→RECOVERY→STEP→STAND | 跌倒后 | 需要足够空间 |

**恢复的两个硬条件**（T1 做法，可搬）：
1. 只有**白名单动作**允许在恢复态插入（9 个）；
2. 恢复完成判据 = 姿态误差达标 **且稳定 1 s**。

## A5 触发链路与时延（实测）

| 事件 | 检测 | 生效 | 证据 |
|---|---|---|---|
| 跌倒 → 阻尼 | 50 ms 周期 + 3 帧 | 判定后 **11 ms** 切完 | 【实测】`mc.log` 15:26:15 |
| 命令断流 → 速度清零 | 200 ms TTL | 下一拍 | 【配置】 |
| 反馈超时 → 告警 | 10 ms | 下一拍 | 【配置】 |
| 状态广播 → 上层可见 | 20 ms（50 Hz） | — | 【配置】 |
| 急停（SM） | 模式切换 | ≤100 ms | 【设计】 |

**通用结论**：安全链路的时延预算是"**检测周期 × 确认帧数 + 交接时间**"。50 ms × 3 + 11 ms ≈ 161 ms 是 T1 的最坏确认时间——迁移时这个数值必须重新算，并写进安全需求。

## A6 跨域安全：不是运控一家的事

| 机制 | 谁负责 | 与运控的接口 |
|---|---|---|
| 系统急停 | SM | 切 EStop 模式 → 停 mc 进程 |
| 故障兜底 | HDS | 故障码 → H1~H5 计划（如"力控站立或允许阻尼倒"） |
| 低电 | 平台 | 阈值触发 `SetMcAction(110)` |
| 避障 | 感知 | 覆写速度为 0（priority 100） |
| 被撞 | HAL/平台 | **当前无**，需新增 `IMPACT_DETECTED`【设计缺口】 |
| 跌倒告警（人） | 感知/大脑 | 与运控无关（运控只管自身） |

## A7 可迁移的安全设计（抽象版）

**把 T1 的"八层"抽象成四个可复用组件**：

```mermaid
flowchart LR
    G["Guard 集合<br/>纯函数：输入→判定"] --> K["SafetyKernel<br/>唯一权威：级别与许可"]
    K -->|"lease（有效 50 ms）"| C["Control<br/>每拍续租"]
    K -->|"降级指令"| S["StateMachine<br/>切安全行为"]
    C -->|"无 lease"| D["输出安全默认"]
```

| 组件 | 职责 | 接口（建议） | 迁移注意 |
|---|---|---|---|
| `Guard` | 单一判据（跌倒/超时/温度/负载） | `evaluate(Inputs) -> Verdict` | 纯函数、可单测、可组合 |
| `SafetyKernel` | 级别推进、许可发放 | `renew()`, `request(level)`, `snapshot()` | **单一写者**，其它模块只能请求 |
| `LeaseProvider` | 许可令牌 | `lease{id, expire_ns}` | 有效期 = 3~5 个控制周期 |
| `Fallback` | 级别 → 行为映射 | `action_for(level)` | 安全行为必须内置、不可被普通请求选中 |

**参数化清单（换机器必须重标）**：跌倒角度/角速度/脚阈值、确认帧数、反馈超时、命令 TTL、看护周期、恢复稳定时长、电量分级。


---

# Part B　切换设计

## B1 三类切换的统一模型

切换看似五花八门，本质都是同一个四阶段：

```mermaid
sequenceDiagram
    autonumber
    participant U as 上游
    participant R as 路由（准入）
    participant OLD as 旧行为
    participant NEW as 新行为
    participant X as 执行器

    U->>R: 请求切换（目标 + 约束）
    R->>R: ① 准入：拓扑 / 守卫 / 冲突
    R-->>U: 受理回执 + 计划路径
    R->>OLD: ② 交接：退出判据
    OLD-->>R: 允许 / 等待 / 拒绝
    R->>NEW: ③ 接管：装载 + 首拍
    NEW->>X: 持续输出
    R->>R: ④ 落位：完成后回默认
```

| 切换类型 | 触发 | 时间尺度 | 关键难点 |
|---|---|---|---|
| **形态**（四足⇄双足） | 平台请求 | **3.0~4.8 s** | 物理约束 + 多模块联动 |
| **动作**（mimic/表演） | 平台请求 + 资源 | 0.4 s ~ 18 s | 模型与轨迹绑定 |
| **速度源**（谁踩油门） | 上游持续发 | **毫秒级** | 优先级与抢占规则 |

## B2 形态切换（四足 ⇄ 双足）

### B2.1 拓扑：只有 6 个"门"

| 方向 | 动作 | ID | 实测时长 |
|---|---|---|---|
| 四足→双足 | `QUADRUPED_TO_BIPED` | 10 | 4.806 s（常规）【实测】 |
| 四足→双足 | `QUADRUPED_TO_BIPED_ROTATE` | 11 | 4.806 s（旋转变形） |
| 四足→双足 | `..._FRONTFLIP` | 12 | 特技 |
| 双足→四足 | `BIPED_TO_QUADRUPED` | 20 | 3.00 s【实测】 |
| 双足→四足 | `..._ROTATE` | 21 | 3.00 s |
| 双足→四足 | `..._FRONTFLIP` | 22 | 特技 |

**关键事实**：形态切换不是"随时可切"，而是**只能在特定动作下发起**（T1 要求从行走档位发起，且需先 WBC 站定）【配置+设计】。

### B2.2 时序：一次变形里发生了什么

```mermaid
sequenceDiagram
    autonumber
    participant P as 平台
    participant M as 运控
    participant H as HAL（腰部舵机）
    participant O as legged_odom
    participant N as 导航/避障

    P->>M: SetMcAction(11)
    M->>M: ① 准入：站立/速度0/电量/空间
    M->>M: ② 交接：旧策略退出
    M->>M: ③ 变形策略 100 Hz（4.8 s）
    par 并行联动
        M->>H: 腰部舵机 0°→90°（40% 力矩）
        M->>M: 重力包络守护（30°/40°，2 帧）
    end
    M->>O: 硬复位估计器（足式→轮式）
    O-->>N: /odom 短暂 UNTRUSTED
    N->>N: 避障布局 dog→human
    M->>M: ④ 落位 300（WBC）
    M-->>P: form_state=双足
```

### B2.3 三个必须做对的细节

| 细节 | T1 做法 | 为什么重要 |
|---|---|---|
| **腰部舵机联动** | 运动 40% 力矩、到位 25% 保持 | 与策略开环并发；力矩太大会顶坏 |
| **重力包络守护** | 偏离参考 30°/40°，连续 2 帧判失败 | 用"成功样本包络"而非建模，轻量有效【设计】 |
| **估计器切换** | 变形即运动学模型切换，旧状态作废 | 不切换会导致 odom 跳变/漂移 |

### B2.4 失败与回退

| 失败 | 处理 | 用户可见 |
|---|---|---|
| 准入不满足 | 拒绝，保持原形态 | 错误码 |
| 变形中失稳 | 重力包络判失败 → 回退姿态 | 事件 |
| 变形中急停 | 中止，进安全态 | 事件 |
| 落位失败 | 停在 `stand`，等重试 | 状态 |

## B3 模仿与表演切换

### B3.1 绑定关系：动作 → 模型 + 轨迹

```mermaid
flowchart LR
    A["动作（MIMIC）"] --> MM["MotionManager<br/>按 motion 名查表"]
    L["motion_list.yaml"] --> MM
    MM --> P["模型 onnx"]
    MM --> T["轨迹（csv/npz/mref）"]
    P --> C["控制器"]
    T --> C
```

**三种轨迹载体的本质区别**（迁移时必须选一种）：

| 载体 | 内容 | 谁在用 | 迁移建议 |
|---|---|---|---|
| 上肢 CSV | 只有 6 个上肢关节 | ANIMATION（304 条） | **不要用于全身** |
| 全身 CSV | 关节 + 基座位姿 | 四足 MIMIC（实际只用基座 6 列） | 需显式声明用哪些列 |
| NPZ | 14 关节 + 17 刚体，50 Hz | 双足 NPZ MIMIC | 完整但慢 |
| ONNX 内嵌 | 轨迹烘进模型 | 灵创 | 换动作=换模型，体积大 |

### B3.2 切换方式

| 切换 | 机制 | 注意 |
|---|---|---|
| 换一支舞 | 换 `motion` 名（同一模型） | 模型复用，只换轨迹 |
| 换一套模型 | 换 `policy.path` | 需重新加载 session |
| 中断当前表演 | `interrupt=true` | 走交接协议 |
| 播完 | `return_to`（自动回默认动作） | 必须有，否则会"停在那" |

## B4 速度源切换（"谁在踩油门"）

### B4.1 规则表

| 规则 | T1 实现 | 迁移建议 |
|---|---|---|
| 优先级 | 7 源 70~100 | 保留分层：安全(100) > 应用(90) > 交互/导航(80) > 遥控(70) |
| 占用窗口 | 1000 ms（避障 500） | 与优先级配合，防止高频抢占 |
| 零速不能抢 | 除安全源外 | **保留**：否则"松手"会误清别人的指令 |
| 同优先级 | 等窗口 | 保留 |
| TTL | 1000 ms 失权 | 按上游频率设（建议 3~5 个周期） |
| 避障特权 | priority 100，零速有效 | 保留，这是安全必需 |

### B4.2 仲裁流程

```mermaid
flowchart TD
    M["收到 velocity"] --> C1{"是安全源？"}
    C1 -->|"是"| A["直接接受（可零速）"]
    C1 -->|"否"| C2{"已注册且使能？"}
    C2 -->|"否"| R1["丢弃"]
    C2 -->|"是"| C3{"是当前源？"}
    C3 -->|"是"| A2["接受并刷新占用"]
    C3 -->|"否"| C4{"五分量全为 0？"}
    C4 -->|"是"| R2["拒绝（零速不抢）"]
    C4 -->|"否"| C5{"优先级更高？"}
    C5 -->|"是"| A3["接管"]
    C5 -->|"否"| C6{"当前源占用超时？"}
    C6 -->|"是"| A3
    C6 -->|"否"| R3["拒绝（等窗口）"]
```

## B5 切换的四个共性问题（T1 踩过的坑）

| 问题 | 表现 | 根因 | 通用解法 |
|---|---|---|---|
| **隐式插站** | 日志里突然出现 121/115 | 图寻路自动插中转 | 中转必须显式声明，响应返回 `plan[]` |
| **交接判据分散** | 每个控制器自己判断"能不能走" | 无统一协议 | `prepare_exit` 三态：ready/wait/refuse |
| **双写冲突** | 两组写同一关节，谁后写谁生效 | 无归属声明 | `scope` / `owns` 显式声明，冲突启动期报错 |
| **缓存键陷阱** | 同名不同周期重复建实例 | 键含 period | 键显式含 `kind / path / rate`，并在日志打印 |

## B6 可迁移的切换设计

```mermaid
flowchart TB
    subgraph DECL["声明层（配置）"]
        T1["transitions[]：显式边 + 守卫 + 混合时长"]
        T2["behaviors[]：模式 / 作用域 / 返回目标"]
    end
    subgraph RUN["运行层"]
        R1["路由：生成 plan[]（不自动插站）"]
        R2["准入：守卫 + 冲突 + 状态"]
        R3["交接：prepare → ramp → commit"]
        R4["落位：return_to / 安全默认"]
    end
    DECL --> RUN
```

**四条通用规则**：

1. **能切的边写在配置里**，代码不猜；
2. **一次请求返回完整计划**，调用方在执行前就知道要经过什么；
3. **交接四段固定**（准备/混合/提交/清理），控制器只实现 `on_enter/step/on_exit`；
4. **混合由框架做**（目标与增益同步插值），避免每个控制器自己写过渡。

---

# Part C　准入与 Adapter 整形

## C1 命令全链路：一条速度到一帧 CAN

```mermaid
flowchart LR
    U["上游消息<br/>velocity / action"] --> A["① 准入"]
    A --> B["② 输入整形<br/>滤波/缩放/裁剪/历史"]
    B --> C["③ 策略<br/>推理/插值/位控"]
    C --> D["④ 输出整形<br/>尺度/增益/限幅/作用域"]
    D --> E["⑤ 设备适配<br/>MIT 量程/软限位/零偏"]
    E --> F["CAN 帧"]
```

| 阶段 | 输入 | 输出 | 典型参数 |
|---|---|---|---|
| ① 准入 | 请求 | 允许/拒绝 | TTL、优先级、拓扑、姿态门 |
| ② 输入整形 | 原始反馈 + 指令 | 观测向量 | 截止频率 100 Hz、缩放 0.05/0.25/2.0、clip 20 |
| ③ 策略 | 观测 | 动作 | dt 0.01、历史 10 帧 |
| ④ 输出整形 | 动作 | 关节目标 + 增益 | action_scale、kp/kd、tau_limit、scope |
| ⑤ 设备适配 | 关节目标 | CAN 帧 | MIT 量程、软限位、零偏 |

## C2 准入：三层闸门

| 层 | 检查 | 失败码 | 谁实现 |
|---|---|---|---|
| 任务级 | 电量、姿态、连接、是否充电 | 任务层拒绝 | 平台 |
| 动作级 | 拓扑可达、IMU 姿态 ±0.12 rad、频率 | -1001 / -1004 / -10001 | 运控 |
| 速度级 | 源注册、优先级、TTL、零速规则 | 丢弃/拒绝 | 运控 |

**通用原则**：**准入越靠上游越便宜**（任务层拒绝不耗运控资源），但**安全相关准入必须放在运控**（不能依赖上游自觉）。

## C3 输入 Adapter：把异构反馈变成"策略能吃的观测"

### C3.1 五道处理

```mermaid
flowchart LR
    J["关节 1 kHz"] --> F1["低通 100 Hz（轮 50/10）"]
    I["IMU 500 Hz"] --> F2["低通 100 Hz"]
    C["速度指令"] --> S["缩放"]
    F1 --> S2["缩放 dof_vel×0.05"]
    F2 --> S2
    R["参考轨迹"] --> P["按需取帧"]
    S --> S2
    S2 --> CL["裁剪 ±20"]
    P --> CL
    CL --> H["堆历史 10 帧"]
    H --> O["观测向量"]
```

| 处理 | T1 值 | 作用 | 迁移注意 |
|---|---|---|---|
| IMU 低通 | 100 Hz | 抑制振动 | 按机身刚度重标 |
| 关节低通 | 100 Hz（轮 50/10） | 轮速噪声大，单独降 | 轮式必须单独设 |
| 缩放 | dof_vel 0.05、ang_vel 0.25、lin_vel 2.0 | 让输入落在 O(1) | **与训练时完全一致**，否则行为异常 |
| 裁剪 | obs_clip 20~200 | 防异常值 | 与缩放配套 |
| 历史 | 10 帧 | 提供速度/趋势信息 | 与训练帧数一致 |
| 缺失处理 | 超时→标记 stale | 让安全层决定降级 | 不要用 0 填充掩盖问题 |

### C3.2 一个反直觉的结论

**策略不吃"实测线速度"**（T1 46 份配置全是 0 份含 `lin_vel` 输入）【配置】。
原因：策略靠**关节速度（轮速是速度代理）+ 上一拍动作 + 历史**隐式推断运动状态。
迁移时如果强行加入线速度估计，必须重新训练，不能直接喂。

## C4 输出 Adapter：把动作变成关节目标

### C4.1 六道处理

```mermaid
flowchart LR
    A["动作 14 维"] --> C1["裁剪"]
    C1 --> S1["× action_scale"]
    S1 --> P1["+ default_dof_pos"]
    P1 --> G["装配 kp/kd"]
    G --> L["力矩/速度限幅"]
    L --> M["作用域合成（LEGS+UPPER）"]
    M --> R["过渡混合（切换时）"]
    R --> O["关节命令"]
```

| 处理 | T1 值 | 作用 | 迁移注意 |
|---|---|---|---|
| 动作裁剪 | 20/50/100/200（或 16） | 防单拍爆炸 | 与训练一致 |
| 尺度 | 腿 0.1~0.2、轮 2.0 | 网络输出→物理量 | **轮和腿语义不同**，必须逐维声明 |
| 默认位 | `default_dof_pos` | 动作是"增量" | 与训练初始姿态一致 |
| 增益 | 腿 30~100、上肢软 2~4 | 刚度 | 按负载重标 |
| 力矩限幅 | `tau_limit 15/30 N·m` | 保护机构 | 按电机/结构重标 |
| 作用域 | `owns` / `scope` | 决定谁写哪些关节 | **必须有**，否则双写冲突 |
| 过渡 | `transition_duration 0.1~0.3 s` | 切换平滑 | 与切换协议配合 |
| 里程计补偿 | `odom_kp/kd`、`disable_after_switch 1 s` | 修正长期漂移 | 可选，需实测 |

### C4.2 最容易出错的三处

| 错误 | 后果 | 检查方法 |
|---|---|---|
| 速度维用了位置增益 | 轮子被"锁"住或暴走 | 检查 `kps=0` 的维度是否就是速度维 |
| 缩放与训练不一致 | 步态变形、抖动 | 与训练配置逐项 diff |
| 作用域重叠 | 两个行为打架 | 启动期校验掩码互斥 |

## C5 设备 Adapter：最后一公里

| 项 | T1 值 | 迁移注意 |
|---|---|---|
| MIT 位置量程 | ±10 rad | 按关节行程重标 |
| 速度量程 | ±60 rad/s | 按电机重标 |
| 力矩量程 | ±60 N·m | 按电机/减速比重标 |
| kp/kd 量程 | 0~500 / 0~10 | 按驱动器重标 |
| 软限位 | 每关节 min/max | 必须来自 URDF 或标定 |
| 零偏/方向 | 每关节标定 | **换机器人必须重标** |
| 轮 vs 腿 | 轮速度控制、腿位置控制 | 逐维声明语义 |

## C6 参数迁移对照表（换机器人时按此重标）

| 参数 | T1 值 | 重标依据 |
|---|---|---|
| 跌倒角度/角速度 | 60° / 6 rad/s | 机身高度、腿长、最大角速度 |
| 关节低通 | 100 Hz（轮 50/10） | 采样率与噪声水平 |
| 观测缩放 | 0.05 / 0.25 / 2.0 | **训练配置**（不能改） |
| 动作尺度 | 0.1~2.0 | **训练配置** |
| 增益 | 腿 30~100 | 负载与结构刚度 |
| 力矩限幅 | 15/30 N·m | 电机与结构 |
| MIT 量程 | ±10/±60/±60 | 关节行程与电机 |
| 命令 TTL | 200 ms | 上游频率 |
| 看护周期 | 50 ms | CPU 预算 |
| 变形时长 | 4.8 s / 3.0 s | 策略相位时钟（非物理常数） |


---

# Part D　迁移到其他四足机器人

## D1 七个必须抽象的接口

迁移的本质不是"抄代码"，而是**先把接口定对**。下面七个接口定了，硬件/策略/上游都可以换。

```mermaid
flowchart TB
    API["① Policy 接口<br/>on_load/on_enter/step/on_exit"]
    ADP1["② InputAdapter<br/>原始信号 → 观测块"]
    ADP2["③ OutputAdapter<br/>动作 → 关节目标（含增益/限幅/作用域）"]
    ADP3["④ DeviceAdapter<br/>关节目标 → 设备帧（量程/限位/零偏）"]
    GRD["⑤ Guard 接口<br/>输入 → 判定（纯函数）"]
    KRN["⑥ SafetyKernel<br/>唯一权威 + 许可"]
    RTR["⑦ Router<br/>显式边 + 计划 + 交接"]
    API --> ADP1
    API --> ADP2
    ADP2 --> ADP3
    GRD --> KRN
    KRN --> ADP2
    RTR --> API
```

| # | 接口 | 方法（建议） | 迁移时谁实现 |
|---|---|---|---|
| ① | `Policy` | `on_load(spec) / on_enter(ctx) / step(obs, act) / on_exit()` | 算法团队（按契约） |
| ② | `InputAdapter` | `build(raw) -> ObsView` | 平台团队（按传感器） |
| ③ | `OutputAdapter` | `shape(act) -> JointCmd[]` | 平台团队（按机构） |
| ④ | `DeviceAdapter` | `encode(JointCmd) -> Frame` | 驱动团队 |
| ⑤ | `Guard` | `evaluate(inputs) -> Verdict` | 安全团队 |
| ⑥ | `SafetyKernel` | `renew() / request(level) / snapshot()` | 安全团队 |
| ⑦ | `Router` | `plan(from,to) -> Step[] / commit(step)` | 平台团队 |

**为什么是这七个**：它们正好对应三条链路 + 设备边界——换机器人时，①③④ 必改，② 视传感器改，⑤⑥⑦ 可原样复用。

## D2 必须重标的参数（12 项）

| # | 参数 | T1 值 | 重标依据 | 验证方法 |
|---|---|---|---|---|
| 1 | 跌倒角度阈值 | 60° | 机身高度/腿长 | 推倒试验（低速） |
| 2 | 跌倒角速度阈值 | 6 rad/s | 最大角速度 | 快速推倒 |
| 3 | 确认帧数 | 3（×50 ms） | 噪声水平 | 误报统计 |
| 4 | 脚部几何阈值 | 0.8/0.4 m | 腿长 | 双足专项 |
| 5 | 反馈超时 | 10 ms | 传感器频率 | 丢帧注入 |
| 6 | 命令 TTL | 200 ms | 上游频率 | 断流测试 |
| 7 | 观测缩放 | 0.05/0.25/2.0 | **训练配置** | 与训练 diff |
| 8 | 动作尺度 | 0.1~2.0 | **训练配置** | 与训练 diff |
| 9 | 增益 kp/kd | 腿 30~100 | 负载/刚度 | 阶跃响应 |
| 10 | 力矩限幅 | 15/30 N·m | 电机/结构 | 堵转试验 |
| 11 | MIT 量程 | ±10/±60/±60 | 关节/电机 | 驱动器确认 |
| 12 | 软限位 | 每关节 | URDF/标定 | 极限位置检查 |

**判定规则**：第 7、8 项**不能改**（属于训练分布）；其余必须重标。

## D3 最小可用架构（MVP，四步走）

```mermaid
flowchart LR
    S1["Step1<br/>单策略 + 速度<br/>（走起来）"] --> S2["Step2<br/>加安全内核<br/>（跌不倒）"]
    S2 --> S3["Step3<br/>加切换与交接<br/>（换得动）"]
    S3 --> S4["Step4<br/>Adapter 配置化<br/>（换机器不改码）"]
```

| 阶段 | 目标 | 交付 | 验收 |
|---|---|---|---|
| Step 1 | 一个行走策略 + 速度输入 + 关节输出 | 能按指令走 | 0.5 m/s 直线 10 m，偏差 <0.3 m |
| Step 2 | 看护 + 降级 | 推倒能切阻尼 | 推倒 → 阻尼 ≤200 ms |
| Step 3 | 显式转换图 + 四段交接 | 动作之间能切 | 切换无跳变（力矩尖峰 <1.5×） |
| Step 4 | 三个 Adapter 全部配置化 | 换机型只改配置 | 新机型 1 周内跑通 |

**经验**：Step 2 一定要在 Step 3 之前——先保证"摔不坏"，再谈"切得好"。

## D4 验收测试矩阵

| 类别 | 测试 | 通过标准 |
|---|---|---|
| 功能 | 速度跟踪 | 0.2/0.5/1.0 m/s 阶跃，超调 <10% |
| 功能 | 形态切换 | 四→双、双→四各 20 次，无失败 |
| 功能 | 动作切换 | 连续切 10 个动作，无卡死 |
| 性能 | 控制环 | 100 Hz，p99 ≤8 ms |
| 性能 | 命令发布 | 200 Hz，抖动 p99 ≤0.5 ms |
| 安全 | 推倒 | 3 通道各自可触发 |
| 安全 | 反馈冻结 | 10 ms 告警，200 ms 降级 |
| 安全 | 命令断流 | 200 ms 停车 |
| 安全 | 急停 | ≤100 ms 进安全态 |
| 迁移 | 换机型 | 改配置 + 重标 12 参数，1 周内跑通 |

## D5 T1 踩过的八个坑（迁移时直接避开）

| # | 坑 | 现象 | 对策 |
|---|---|---|---|
| 1 | 隐式中转 | 日志里突然出现 121/115 | 中转显式声明 + 返回 plan |
| 2 | 双写冲突 | 两组写同一关节 | `scope`/`owns` 声明 + 冲突校验 |
| 3 | 交接判据分散 | 每个控制器自己判断 | 统一 `prepare_exit` 三态 |
| 4 | 缓存键陷阱 | 同名不同周期重复实例 | 键含 `kind / path / rate` |
| 5 | 轨迹列不用还照抄 | 四足 CSV 12 关节列，实际只用 6 列基座 | 编译期声明 `use` 列 |
| 6 | 观测维度手工维护 | 46 份 obs_index 易错 | 块化 ObsSpec + 启动校验 |
| 7 | 错误码多套 | 3 套域，排障对不上 | 一套 5 段码 |
| 8 | 安全动作可被普通请求选中 | 一个 SetMcAction 就能退出阻尼 | 安全行为独占，普通请求拒绝 |

## D6 迁移检查清单（一页纸）

```text
□ 七个接口是否已定义并冻结？
□ 12 个参数是否逐项标定并记录？
□ 观测/动作缩放是否与训练配置 diff 过？
□ 速度源优先级是否定义（含安全源特权）？
□ 转换图是否显式（无自动插站）？
□ 交接四段是否统一实现？
□ 安全内核是否单一权威（只有它能降级）？
□ 故障注入矩阵是否全过？
□ 8h 长跑是否无泄漏/无许可丢失？
□ 换机型是否只改配置+重标参数？
```

---

# Part E　T1 实现细节（代码级）

> 这一部分回答"**它到底是怎么写出来的**"：有哪些运行期对象、每个控制器的算法步骤、日志里能反推出的真实常量。
> 数据全部来自真机 `mc.log`（2026-10-11 ~ 2026-10-21 多次启动）与板端配置。

## E1 运行期对象结构

### E1.1 五个核心对象

```mermaid
classDiagram
    class ActionDefinition {
      +string name
      +vector~Group~ groups
    }
    class Group {
      +vector~RunnerRef~ runners
      +int period_ms
      +int priority
      +vector~int~ cpu_affinity
    }
    class RunnerRef {
      +string name
      +string cfg_path
    }
    class RunnerInstance {
      +on_load()
      +pre_run_once()
      +step()
      +exit_check()
    }
    class RunnerFactory {
      -map~key,RunnerInstance~ cache
      +get_or_create(ref, period)
    }
    class SessionPool {
      -map~key,Session~ sessions
      +preload(models)
      +acquire(model)
    }
    ActionDefinition "1" --> "*" Group
    Group "1" --> "*" RunnerRef
    RunnerFactory --> RunnerInstance
    RunnerInstance --> SessionPool
```

**日志佐证**（`action_manager.cc` / `runner_factory.cc`）：

```text
Create transition action BIPED_LOCOMOTION_WBC, has 1 runners, period ms: 10, priority: 80, cpu affinity: []
Create transition action BIPED_LOCOMOTION_WBC, has 1 runners, period ms: 4,  priority: 80, cpu affinity: []
Runner [rl_bi_loco_wbc] (cfg: ./rl/bi_wbc_run.yaml, period: 10ms) is shared, skipping re-initialization
[RunnerFactory] Reusing cached runner instance: passive_default||1
```

**两个容易看错的点**：

1. `Create transition action` 打印的是**执行组**，不是 Action——同一个 Action 出现两条（period 10 与 4）就是这个原因；
2. **Runner 是共享的**：相同 `name|cfg|period` 不会重复初始化，直接复用（日志明确写 `is shared, skipping re-initialization`）。

### E1.2 会话池（SessionPool）

**初始化流程**（启动时一次性）：

```text
[SessionPool] Initializing...
[SessionPool] Found motion_list with 108 motions
[SessionPool] 5 unique models queued for preload (from 108 motions)
[SessionPool] Config: max_dynamic_sessions=10
[SessionPool] Loading 5 PRESET models from motion_list.yaml
[SessionPool] Preloaded PRESET session (new): t1_bi_wbc_pitch0522
   (key: t1_bi_wbc_pitch0522:onnx:cpu:PRESET:3934603435975883755)
[SessionPool] Initialized successfully with 5 preloaded sessions
```

**结构**：

| 项 | 实现 | 证据 |
|---|---|---|
| 预加载来源 | `motion_list.yaml` 去重后的模型 | 【日志】`5 unique models from 108 motions` |
| 缓存键 | `模型名:onnx:cpu:PRESET:哈希` | 【日志】 |
| 静态上限 | `max_dynamic_sessions = 10` | 【日志】 |
| 命中行为 | 已存在则复用（`Session already exists`） | 【日志】 |
| 预热收益 | 避免首次推理的图初始化开销（数十 ms） | 【推断】 |

**迁移含义**：会话池是"**用内存换切换时延**"的典型手段——预热 5 个模型 ≈ 几百 MB，换来"换动作不卡顿"。

## E2 安全看护的实现

### E2.1 它是一个 Runner，不是一段散落的代码

`security_guard_t1` 在 `action_setting.yaml` 里是一个**独立执行组**（period **50 ms**），
所以它有自己的线程、自己的节拍，与策略线程并行——这就是为什么它不会拖慢控制环。

**初始化日志（原文）**：

```text
T1 security_guard 已加载: delta软门槛=48  gyro|w|阈值=6 rad/s(<=0关闭通道2)  gyro_cnt=3
T1 security_guard monitored_actions_biped=[BIPED_STAND_DEFAULT, BIPED_LOCOMOTION_DEFAULT, BIPED_LOCOMOTION_RUN,
   BIPED_LOCOMOTION_TERRAIN, BIPED_LOCOMOTION_WBC, BIPED_CUSTOM_UPPER, BIPED_LOCOMOTION_ANIMATION, BIPED_MIMIC,
   BIPED_LINGCHUANG_MIMIC, BIPED_GIMBAL, BIPED_LOCOMOTION_MOONWALK, BIPED_RECORD_UPPER, BIPED_LOCOMOTION_WBCDANCE,
   BIPED_NPZ_MIMIC]
T1 security_guard monitored_actions_quadruped=[QUADRUPED_STAND_DEFAULT, QUADRUPED_LOCOMOTION_DEFAULT, ...（17 个）]
T1 foot_relative_guard enabled=true thresholds=(|z|>0.80, |x|<0.40) cnt>20
   urdf=qd1.urdf torso=BASELINK L=RL_FOOT_Link R=RR_FOOT_Link
T1 foot_relative_guard FK 就绪: nq=14 link_count=17 L_idx=12 R_idx=16（joint 映射将在首次 Run 时构建）
```

**从日志能确定的实现事实**：

| 项 | 值 | 说明 |
|---|---|---|
| 看护周期 | 50 ms | 执行组 period |
| 通道 2 软门槛 | **48°** | 与主阈值 60° 不同，是独立参数 |
| 通道 2 角速度 | **6 rad/s** | `<=0` 可关闭该通道 |
| 通道 2 次数 | **3** | 连续帧 |
| 双足监控动作 | **14 个** | 见上方列表 |
| 四足监控动作 | **17 个** | 去重后（含 STEP/SIT/CROUCH 等） |
| 脚部阈值 | z 偏移 > 0.80 m，或 x 偏移 < 0.40 m | 相对躯干（双足） |
| 脚部次数 | **20** | 连续帧 |
| FK 输入 | 14 个关节、17 个 link | URDF：`qd1.urdf` |
| 脚 link 索引 | L=12、R=16 | 由 URDF 得到，**首次 Run 时建立关节映射** |

### E2.2 三个通道的算法细节

```cpp
// 伪代码：与日志字段一一对应
void SecurityGuard::Run() {
  if (!monitored(current_action_, form_)) return;      // 名单门控

  // ---- 通道 1：姿态角 ----
  Vec3 up = R(quat_) * axis_up(form_);                 // 双足取 x，四足取 z
  double delta = degrees(acos(clamp(dot(up, up_stand_), -1.0, 1.0)));
  ch1_hit_ = (delta > 60.0);
  ch1_cnt_ = ch1_hit_ ? ch1_cnt_ + 1 : 0;

  // ---- 通道 2：角速度 + 软角度 ----
  double w = norm(gyro_);
  ch2_hit_ = (gyro_thr_ > 0) && (w > gyro_thr_) && (delta > soft_delta_);
  ch2_cnt_ = ch2_hit_ ? ch2_cnt_ + 1 : 0;

  // ---- 通道 3：脚相对躯干（仅双足、需 FK）----
  if (foot_guard_enabled_) {
    Vec3 L = fk_.footPos(link_idx_L_, q_);             // 躯干系
    Vec3 R = fk_.footPos(link_idx_R_, q_);
    ch3_hit_ = (fabs(L.z) > 0.80 || fabs(L.x) < 0.40 ||
                fabs(R.z) > 0.80 || fabs(R.x) < 0.40);
    ch3_cnt_ = ch3_hit_ ? ch3_cnt_ + 1 : 0;
  }

  if (ch1_cnt_ >= 3 || ch2_cnt_ >= 3 || ch3_cnt_ >= 20) {
    request_action(DAMPING_DEFAULT, "fall_detected");
  }
}
```

**四个实现层面的要点**：

1. **先过多重门控**：动作名单 + 形态（biped/quad），不在名单直接返回——这是"零成本保护"；
2. **通道 2 的 48° 是独立参数**（不是 60° 的比例），日志写死为"软门槛"；
3. **通道 3 依赖 FK**：nq=14、link_count=17，脚 link 固定为 RL/RR（**四足没有这一路**）；
4. **计数是"连续命中"**，一旦不命中清零——不是滑动窗口。

### E2.3 重力包络守护（变形专用）

```text
Loaded gravity guard: rows=300, cols=3
Gravity guard config loaded: threshold_deg=30.00, count_threshold=2
[BIPED_TO_QUADRUPED] transform fall check enabled: path=.../cfg/robot/qd1_t2d0/...
```

| 项 | 实现 | 含义 |
|---|---|---|
| 参考表 | **300 行 × 3 列** | 3 列是重力向量（gx, gy, gz）的采样 |
| 判定 | 偏离参考 **30°** | 当前重力方向与参考的夹角 |
| 确认 | **连续 2 帧** | 比跌倒判定更短（变形窗口短） |
| 触发 | 判失败 → 回退 | 不直接跌倒也保护 |

**为什么用"表"而不是"模型"**：录制一段成功变形中的重力向量作为基准，运行时查表比对——
轻量、无需建模、对机体差异不敏感。这是很值得抄的工程手法。

## E3 切换的实现

### E3.1 换乘图与路径

| 结构 | 实现 | 证据 |
|---|---|---|
| 节点 | 52 个（可停留的动作） | 【配置】`action_ruler.yaml` |
| 边 | 197 条 `next_actions` | 【配置】 |
| 全局出口 | 3 条（PASSIVE/DAMPING/LIE） | 【配置】`common_rules` |
| 禁跳 | 24 个（不能作为中转） | 【配置】`skip` |
| 寻路 | 图搜索，插入中转 | 【日志】`ActionManager` |
| 失败 | `-1001` 不可达 | 【日志】 |

**请求处理链**（与站点记录的流程图一致【站点】）：

```text
SetMcAction → 服务/状态管理（就绪检查） → 动作图可达性 → 当前 Runner 退出/阻挡条件
            → ActionManager 交接 → PreRunOnce → 周期运行 → 状态广播
```

### E3.2 三种控制器的退出判据（真实实现）

这是 T1 最"分散"的部分，也是迁移时最该统一的地方。三种控制器各有一套：

#### ① 步态桥（quad_step）：足端稳定性门控

```text
[2026-10-11 14:24:20.807904] IsStanceUnstable entry_frames=1 step=0
    front_diff=0.002 back_diff=0.000 max_pos_diff_xy=0.058(k=1)
    thr=(0.05/0.05/0.08) -> stable
```

**算法**（从日志字段反推）：

```text
每拍：
  front_diff = |前足当前xy - 前足默认xy|        # 前足两只
  back_diff  = |后足当前xy - 后足默认xy|
  max_pos_diff_xy = 四足中最大的 xy 偏移
  k = 连续满足阈值次数
  stable = (front_diff < 0.05 && back_diff < 0.05 && max_pos_diff_xy < 0.08) 连续 k 次
```

| 参数 | 值 | 含义 |
|---|---|---|
| `front_diff` 阈值 | **0.05 m** | 前足偏移 |
| `back_diff` 阈值 | **0.05 m** | 后足偏移 |
| `max_pos_diff_xy` 阈值 | **0.08 m** | 四足最大偏移 |
| `entry_frames` | 从进入算起 | 进入后至少等几拍 |
| `pos_diff_thr_quad_stand` | 从站立进入时用另一套阈值 | 站立→步态的特殊路径 |

**默认足端位置**（机器人常量，来自 URDF/FK）：

```text
default foot pos FL=(0.154, 0.166, -0.347)  FR=(0.154, -0.166, -0.347)
                 RL=(-0.208, 0.159, -0.290) RR=(-0.208, -0.159, -0.290)
```

#### ② 行走策略（WBC）：按速度插值等待步数

```text
QD1_BI_WBCRLController exit wait target steps=20 (vx=0.000, yaw=0.000, min=20, max=100)
```

**算法**：

```text
steps = clamp(min + (max - min) * max(|vx|/vx_max, |yaw|/yaw_max), min, max)
       = clamp(20 + 80 * r, 20, 100)        # vx=yaw=0 → r=0 → 20 步 = 0.2 s
```

| 参数 | 值 | 含义 |
|---|---|---|
| `exit_wait_stop_step_min` | **20** | 最低速度时的等待步数（0.2 s） |
| `exit_wait_stop_step` | **100** | 满速时的等待（1.0 s） |
| 插值依据 | vx 与 yaw 各自相对上限取较大者 | 速度越大，等待越久 |

#### ③ 位控（stand / sit / damping）：位置差 + 超时

```text
Timeout 9.076. current diff sum 0.22109080696105932
```

**算法**：

```text
每拍：diff_sum = Σ|q_current - q_target|
if (diff_sum < exit_position_threshold) 退出成功
if (elapsed > exit_timeout)             退出（打印 diff_sum 便于诊断）
```

| 参数 | 典型值 | 说明 |
|---|---|---|
| `phase_duration_time` | 1.0~1.5 s | 走到目标的时间 |
| `exit_position_threshold` | 0.1~0.2 rad | 到位判据（各关节和） |
| `exit_timeout` | 1.2~2.5 s | 兜底超时 |

### E3.3 模仿与表演的实现

**四足模仿（QuadMotionRLController）**：

```text
[ParseCsvTrajectory] Loading CSV trajectory: 602 rows, 28 cols from .../qd1_quad_scared.csv
[ParseCsvTrajectory] parsed 602 x 28, frame_nums=602
[PreloadCsvTrajectories] Preloaded 21 QUADRUPED_MIMIC trajectory CSV consumed time 130 ms
[LoadCsvMotionTrajectory] Trajectory cache hit: QUAD_MIMIC_TALK_FIVE (1400 frames)
```

| 实现点 | 细节 |
|---|---|
| 加载 | 解析 CSV → `frame_nums`；**21 条轨迹启动预加载，耗时 130 ms** |
| 缓存 | 按 motion 名缓存已解析轨迹（`Trajectory cache hit`） |
| 使用列 | 配置 `mimic_csv_cols` 只取 6 列（time + body xyz + rpy） |
| 播放 | 按 `timeCNT`（10 ms/帧）推进 → 写 command → 策略跟踪 |

**双足模仿（bi_mimic）**：

```text
# 手臂 smoothstep 回 default_dof_pos；Z/RPY 每拍写入 obs 供 RL 腿继续跑
```

**上肢播放（animation_player）**：

```text
Intr cycles: [50/1411] finished=false
AnimationPlayerController::Init: animation id=1001 animation_type=animation
AnimationPlayerController::Init: gravity_comp mode=planner enable=true
```

| 实现点 | 细节 |
|---|---|
| 播放进度 | `[已播帧/总帧]`，1411 帧 ≈ 14 s（100 Hz 采样） |
| 类型 | `animation`（柔性）/`hold`（保持末帧）/`rigid`（刚性） |
| 重力补偿 | **按模式独立开关**：planner/animation/idle 开，hold/rigid 关 |
| 增益档 | planner 4/2/4、animation 4/2/4、rigid 15、hold 30 |

**预设动作的白名单**：

```text
Current action: DAMPING_DEFAULT is not support preset motion
Current action: BIPED_MIMIC is not support preset motion
```

→ 预设动作（挥手等）**只能在特定动作下播放**，阻尼/模仿态会被拒。这是"防止上肢在最不该动的时候动"的保护。

## E4 Adapter 的实现细节

### E4.1 输入装配（obs）

```text
obs_index:
  imu_omega: 0   # 3
  imu_euler: 3   # 3
  pos:       6   # 12（14 - 2 轮）
  vel:      18   # 14
  action:   32   # 14
  command:  46   # 3 (或 1/4/6)
  [扩展段]  phase/cpg/ref/contact/...
```

**实现顺序**（与 obs_index 一一对应）：

```text
raw_joint[14] → 低通(100 Hz, 轮 50/10) → pos[12]/vel[14]
raw_imu       → 低通(100 Hz)           → omega[3]/euler[3]
velocity_cmd  → 缩放(lin_vel 2.0)      → command[N]
prev_action   → 直接                   → action[14]
扩展段        → phase/cpg/ref          → 追加
→ 逐段缩放 → clip(±20~200) → 堆 10 帧 → obs
```

**两个实现细节**：

1. **`pos` 只有 12 维**：两个轮没有绝对位置（连续旋转），所以只给 vel；
2. **滤波是一阶低通**：`alpha = 1 - exp(-2π·fc·dt)`【推断】；轮子单独设更低截止（50/10 Hz）。

### E4.2 输出整形（action → 关节）

```text
q_des[i] = action[i] * action_scale[i] + default_dof_pos[i]
q_des    = clip(q_des, joint_limit)
tau      = clip(kp*(q_des-q) - kd*dq, ±tau_limit) + tau_gravity
```

| 实现点 | 细节 | 证据 |
|---|---|---|
| 动作裁剪 | `action_clip 20~200`（或 16） | 【配置】 |
| 尺度 | 腿 0.1~0.2、轮 **2.0** | 【配置】`action_scale` |
| 默认位 | `default_dof_pos` | 【配置】 |
| 增益 | 腿 30~100、上肢软 2~4 | 【配置】`kps/kds` |
| 力矩裁剪 | `clip_tau`（只裁 PD 项，重力前馈不裁） | 【配置】注释 |
| reduction | `wheel_reduction 1.0/0.25`、`hip_reduction 0/0.5/1.0` | 【配置】 |
| 里程计补偿 | `yaw_comp_decimation: 2`（每 2 拍更新 = 50 Hz） | 【配置】 |
| 补偿禁用 | `odom_disable_after_switch_s: 1` | 【配置】 |

**轮子为什么是 2.0 的尺度**：轮子的动作直接是**速度目标**（不是位置增量），量纲不同，所以尺度大一个数量级。

### E4.3 设备编码（最后一步）

```text
MIT 帧：[p_des, v_des, kp, kd, tau_ff]
量程：  p ±10 rad, v ±60 rad/s, tau ±60 N·m, kp 0~500, kd 0~10
```

**每关节的零偏与方向**在 `device_manager` 配置里，不在 MC——这是"机构参数"与"算法参数"的分界。

## E5 从日志反推的关键常量（迁移时对照）

| 常量 | 值 | 出处 |
|---|---|---|
| 看护周期 | 50 ms | 执行组 |
| 跌倒角度/次数 | 60° / 3 | 配置 |
| 角速度/软角/次数 | 6 rad/s / 48° / 3 | 日志初始化 |
| 脚部阈值/次数 | 0.80 m / 0.40 m / 20 | 日志初始化 |
| 双足/四足监控数 | 14 / 17 | 日志初始化 |
| FK | nq=14, links=17, L=12, R=16 | 日志初始化 |
| 重力包络 | 300×3 表 / 30° / 2 帧 | 日志初始化 |
| 步态门限 | 0.05 / 0.05 / 0.08 m | 日志运行 |
| 退出等待步数 | min 20 / max 100（插值） | 日志运行 |
| 位控到位阈值 | 0.1~0.2 rad（和） | 配置 |
| 会话池 | 5 预加载 / 上限 10 | 日志初始化 |
| 轨迹预加载 | 21 条 / 130 ms | 日志初始化 |
| 命令整形 | acc_x=1.0、acc_x_accel=1.0、10 ms | 【站点】 |

## E6 结构总结：三条链路的调用关系

```mermaid
sequenceDiagram
    participant U as 上游
    participant AM as ActionManager
    participant RF as RunnerFactory
    participant SP as SessionPool
    participant RU as Runner 线程
    participant SG as security_guard
    participant IO as device_manager

    U->>AM: SetMcAction
    AM->>AM: 图寻路 + 准入
    AM->>RF: 取/建 Runner（缓存键 name|cfg|period）
    RF->>SP: 取 Session（预加载命中）
    AM->>RU: PreRunOnce
    loop 每 period
        RU->>RU: obs → step → 整形
        RU->>IO: 关节命令
        SG->>SG: 50 ms 看护
        SG-->>AM: 命中则请求 DAMPING
    end
    RU-->>AM: ExitCheck 通过 → 交接
```

**一句话总结实现**：**ActionManager 管"谁能跑"，RunnerFactory/SessionPool 管"跑什么"，Runner 线程管"怎么跑"，security_guard 管"该不该停"。**

---

## 附录 A　证据索引

| 结论 | 来源 |
|---|---|
| 八层安全、跌倒三通道参数 | 【配置】`security_guard.yaml` |
| 11 ms 跌倒切换 | 【实测】`mc.log` 2026-10-28 15:26:15 |
| 4.806 s / 3.00 s 变形时长 | 【实测】`mc.log` |
| 轨迹载体四种、四足只用 6 列 | 【配置】`motion_list.yaml`、`quad_mimic.yaml` |
| 速度源优先级、TTL、零速规则 | 【配置】`mc_T1.yaml` |
| 命令整形（acc_x、缩放、限幅、转向耦合） | 【站点】site35 `experiment_02_voice_motion` |
| 动作请求流程（服务→拓扑→退出判据→交接） | 【站点】site200 `t1-runtime` |
| 变形准入、重力包络、OTA 门槛 | 【设计】4+1 文档 §8 |
| 46 份配置无 `lin_vel` 输入 | 【配置】逐份扫描 |
| MIT 量程、软限位 | 【配置】`device_manager` |

## 附录 B　与 T1 的差异（一句话版）

| 维度 | T1 | 迁移版 |
|---|---|---|
| 安全 | 8 层分散 + 4 个守卫 | 内核 + 许可 + 阶梯（结构同，收敛） |
| 切换 | 自动寻路 + 隐式中转 | 显式边 + plan + 四段交接 |
| 整形 | 参数散在 4 份 YAML | 三个 Adapter 配置化 + 启动校验 |
| 轨迹 | 4 种格式 | 编译期统一为一种 |
| 迁移成本 | 改代码 | 改配置 + 重标 12 参数 |


---
