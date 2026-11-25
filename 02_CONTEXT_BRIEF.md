# 02 · 背景综合（15 分钟读完）

**版本**：V1.0　**日期**：2026-11-25　**用途**：给网页版 GPT 的项目背景与证据边界；不是设计结论。
**读者**：GPT、运控/Runner 设计者、框架团队、评审。
**证据级别**：`[事实]` 原始配置/IDL/源码可核对；`[实测]` 真机日志/录制；`[文档]` 厂商或项目文档；`[假设]` 未冻结；`[建议]` 待评审；`[待定]` 需实验/标定/产品输入。

---

## 0. 一句话

Collie 的运控（MC）软件框架由另一个团队基于 Roboparty 开源的 `roboparty_deploy` 做设计与适配；我们这一轮不设计框架代码，而是定义**框架必须加载的 YAML 配置契约**，以及**模型与模型之间切换/过渡的统一架构**，让框架团队可以直接实现、让运控团队可以按契约交付策略资产。

---

## 1. 项目与分工

| 角色 | 负责 | 不负责 |
|---|---|---|
| 运控团队（我们） | 策略资产、观测/动作规格、进入/退出/完成判据、切换语义、安全包络、验收向量 | 框架的线程/进程/ROS2 实现 |
| 框架团队（另一团队） | 基于 `roboparty_deploy` 实现 `motion_runtime`：配置加载、Registry、Graph、PolicyManager、TransitionController、JointMux、OutputGuard、状态发布 | 策略训练、参数标定、动作编排 |
| 任务/导航/安全/产品 | 上游意图、速度参考、空间准入、业务编排 | 直接写关节 |
| 本体/驱动 | 关节拓扑、零点/方向/限位、CAN/IMU、URDF | 策略与切换逻辑 |

**边界判据**：任何"框架必须知道的事"（周期、所有权、观测来源、动作解码、切换阶段）都进 YAML；任何"策略内部的数学"（网络结构、训练奖励、控制律内部状态）不进 YAML，只通过 manifest 声明输入输出与生命周期。

---

## 2. T1 证据：一套成熟但耦合重的配置/切换体系

T1 Pro 是启元（PrimeBot）的四足⇄双足机器人：**14 个 RL 动作关节**（前肢 6 + 后肢 6 + 2 个主动轮），腰部舵机是第 15 自由度、不走 RL 动作链路。注意：`roboparty_deploy` 默认的 RPO 是 **23 个电机**，那是另一台机器人；不要把 RPO 的 23 与 T1 的 14 混为一谈。Collie 不是 T1，**T1 的数字、关节顺序、阈值不能直接复制**；能复用的是结构关系与工程约束。

### 2.1 配置即策略：四份 YAML + 一份动作表

| 文件 | 回答什么 | 规模 | 证据 |
|---|---|---|---|
| `action_ruler.yaml` | 谁能变成谁（换乘图） | 52 节点 / 197 边 / 3 个全局出口 / 24 个 skip | `raw/t1/config/action_ruler.yaml`、`raw/t1/model_lists/rule-graph-stats.md` |
| `action_setting.yaml` | 一个动作挂几个执行组、每组周期/优先级/跑哪个 runner | 58 动作 / 62 执行组 / 62 runner | `raw/t1/config/action_setting.yaml`、`raw/t1/model_lists/action-execution-runner.md` |
| `action_state.yaml` | 动作属于哪一类、出事往哪退 | 6 组状态 / 9 个恢复动作 | `raw/t1/config/action_state.yaml` |
| `rl/*.yaml` | 每组控制器用哪个模型、观测怎么排、增益/尺度/退出条件 | 48 份 RL 配置 / 42 个 RL 动作条目 / 34 份不同权重 | `raw/t1/config/rl/`、`raw/t1/model_lists/rl-runner-weights.csv` |
| `motion_list.yaml` | 动作名 → 模型 + 轨迹（mimic/表演） | 108 条 motion | `raw/t1/config/motion_list.yaml` |

**关键事实**：

- 加一个新动作要同时改**接口枚举、换乘图、执行组、runner 配置**四处；漏一处运行时才炸。`[事实]`（`raw/docs/t1_architecture_deep_dive.md` 第 9 章）
- 配置之间有重复与隐式约定：`action_setting` 与 `rl/*.yaml` 都可能写 `policy.path`；`motion_list` 又写一份；关节顺序在每份 RL 配置里重复 3 次（`joints_name` / `seq` / `action_seq`）。`[事实]`
- 同一个 runner 名在不同周期会创建两个实例，缓存键是 `name|cfg_path|period`。`[事实]`（`raw/docs/t1_mc_decomposition.md` §4.2）
- 启动时预建组件、预载 Session；78 个动画 CSV 一次性读入耗时 1.729 s，冷启动有代价。`[实测]`

### 2.2 切换：显式换乘图 + 每个控制器自己实现交接

- **不是模型插值**。四足⇄双足是独立的 RL 过渡策略（6 条路径：常规/旋转/前空翻 × 2 方向），phase/q_ref 驱动，不接速度指令。`[事实]`（`raw/docs/t1_morphing_and_switch.md`）
- 变身时长 3.0–4.8 s，相位表（`start_time/flip_time/rotate_time`）+ `exit_timeout` 可算出名义时长；前空翻用 `auto_switch_timeout` 硬超时。`[配置/实测]`
- 变身专用 `gravity_guard`：拿成功变身的重力方向录制曲线逐帧比对，偏 30°（前空翻 40°）连续 2 帧判失败。`[配置/实测]`
- 旧控制器用 `ExitCheck` 决定"能不能下课"：四足行走要冻步态/等脚落稳；双足 WBC 要速度归零 + 20~100 步等待；位控要位置差 + 超时。判据分散在各控制器里，没有统一契约。`[事实]`
- 落位不是同一个策略：Q2B 落到 `BIPED_LOCOMOTION_WBC`，B2Q 落到 `QUADRUPED_LOCOMOTION_DEFAULT`；靠"末态姿态对齐 + 目标侧 0.15~0.2 s 进入平滑 + 1 s 里程计静默"衔接，PD 增益是硬跳变。`[配置/实测]`
- 对外状态：`status=100` 运行 / `200` 切换中；`switch_ready` 才表示"可接新动作"；状态 50 Hz 广播。`[文档/实测]`（`raw/t1/interfaces/McCommonState.msg`、`raw/docs/t1_architecture_deep_dive.md` §9.4）
- 切换的"慢"99% 来自物理约束（等速度归零、等脚落地、变身本体），不是软件寻路/RPC。`[实测]`

### 2.3 安全：八层 + 旁路

| 层 | 机制 | 关键数值 |
|---|---|---|
| L0 电机/驱动 | 关节限位、MIT 范围、零偏/方向 | 来自 URDF/设备配置 |
| L1 命令/数据 | 命令过期清零、反馈超时 | `cmd_guard` 200 ms；IMU/关节 10 ms |
| L2 动作准入 | 拓扑、姿态、频率、业务黑白名单 | 姿态 ±0.12 rad；请求间隔 ≥500 ms |
| L3 姿态看护 | 三通道跌倒判定 | 60°/3 帧；6 rad/s + 48°/3 帧；脚 FK 20 帧 |
| L4 动作兜底 | 3 个全局出口、阻尼、恢复族 | `PASSIVE`/`DAMPING`/`QUAD_LIE_DOWN` |
| L5 感知安全 | 避障修正、空间检查 | priority 100，零速有效 |
| L6 系统模式 | 急停停进程、关机、OTA | EStop 只留 HAL + Diagnosis |
| L7 资源/进程 | 隔离核、cgroup、OOM 保护 | 运控独占 CPU3；cgroup 10000 |
| L8 电源 | 电量门槛、低电切四足 | 30/15/10% 提示，5% 趴下 |

**最容易混的两件事**：跌倒保护是"运控换个动作"（换阻尼，11 ms 完成）；急停是"系统层把运控杀了"。两者不同级别，不能互相替代。`[事实]`

### 2.4 速度控制权：7 个配置源 + 1 个硬编码

- 优先级 70–100；TTL 1000 ms；除安全源外"零速不能抢"；同优先级等窗口；避障 priority 100 可零速抢占。`[配置]`（`raw/t1/config/mc_T1.yaml`、`raw/docs/t1_architecture_deep_dive.md` 第 8 章）
- 这条链路不是"模型切换"，但和切换共用"谁在指挥"的仲裁；YAML 里必须单独建模。

### 2.5 T1 踩过的坑（迁移时直接避开）

| 坑 | 表现 | 根因 |
|---|---|---|
| 隐式插站 | 日志突然出现 121/115 | 图寻路自动插中转 |
| 交接判据分散 | 每个控制器自己判断"能不能走" | 无统一协议 |
| 双写冲突 | 两组写同一关节，后写生效 | 无所有权声明 |
| 缓存键陷阱 | 同名不同周期重复建实例 | 键含 period |
| 配置联动 | 4 份 YAML + motion_list，漏一处运行时才炸 | 无单一事实源 |
| 注释与数值不一致 | `transition_frames: 15` 注释写 1 s，实际 0.15 s | 无校验 |
| 命名不一致 | `BIPEDAL_STAND_DEFAULT` vs `BIPED_STAND_DEFAULT` | 字符串枚举无 schema |
| 落位残差 | B2Q 末态与行走默认位差 1.6°/5.3° | 没有"末态对齐"校验 |

---

## 3. `roboparty_deploy` 基线：能力与缺口

框架团队会参考 Roboparty 的开源实现：<https://github.com/Roboparty/roboto_origin/tree/main/modules/roboparty_deploy>。本包 `raw/roboparty/` 是本地快照（文本文件；ONNX/二进制未包含）。

### 3.1 它已经有什么

- ROS2 Humble + C++17 + yaml-cpp + ONNX Runtime；`inference_node` 单节点；`robot.yaml` 硬件配置（IMU、23 个电机、4 路 CAN、kp/kd、方向、零偏、闭环映射、URDF→电机顺序）。
- `configs/*.yaml` 是 ROS2 参数文件：`model_names`（可多个）、`motion_names`、`obs_layouts`、`frame_stacks`、`obs_stack_orders`、`act_alpha`、`joint_num`、`decimation`、`dt`、观测尺度/裁剪、`action_scale`、`clip_actions`、`usd2urdf`、`clip_cmd`、`joint_default_angle`、`joint_limits`、`gravity_z_upper`。
- 观测源注册表：`cmd_vel / ang_vel / gravity_b / dof_pos / dof_vel / last_action / interrupt / perception / motion_pos / motion_vel / latent`；支持 `name:size@tap|tap` 稀疏历史。
- 运行时：`inference_node` 有 `inference`（50 Hz 级）与 `control`（250 Hz 级）两个线程；`act_alpha` 对动作输出做低通；手柄 X/A/B/Y/LB/RB；`/start_inference`、`/stop_inference`、`/init_motors` 等服务。
- `beyondmimic.yaml` 展示了"一个配置多模型 + 多 motion"：LB 暂停推理、切 `active_policy_idx_`、`reset_policy_runtime`、恢复；RB 选 motion。**这是"暂停-换指针-重置-恢复"的硬切换，没有过渡、没有服务、没有图。** `[事实]`（`raw/roboparty/src/ros_interface.cpp` L355-408）
- 经典动作播放是**另一个进程**：`scripts/motion_player.py` 以 200 Hz 直接调 `robot_py.apply_action(positions)`，不带增益，不和 `inference_node` 共享所有权。`[事实]`

### 3.2 它缺什么（正是这轮要补的）

| 缺口 | 现状 | 影响 |
|---|---|---|
| 配置分层 | 一个动作/策略一份 ROS2 参数；机器人/策略/动作/图/安全混在一起 | 无法表达动作图、所有权、切换 |
| 参数隔离 | `joint_num`、`dt`、`action_scale`、`joint_default_angle`、`clip_cmd` 对同一配置内所有模型共享 | 不同观测/动作契约的模型无法共存 |
| 运行时切换 | 只有手柄 LB/RB；暂停-换指针-重置 | 不能服务化、不能过渡、不能回滚 |
| 过渡 | 无 | 落位/换模型有冲击风险 |
| 图与准入 | 无 | 非法切换、隐式中转、双写无法防 |
| 安全 | 仅电机层/超时 | 没有统一安全出口、跌倒/急停/NaN 旁路 |
| 状态/事件 | 只有 inference 日志 | 上层不知道"切换中/已稳定/失败" |
| 校验 | 只做数量/尺寸的零散检查 | 配置错配到运行时才炸 |
| 多输入 ONNX | `setup_model` 明确拒绝多输入 | 无法接 `observations + history` 双输入模型 |
| 经典控制器 | 独立 Python 进程 | 与 RL 不能统一编排、不能共享关节出口 |

**重要**：框架团队可以扩展这些能力，但不应被要求重写驱动、推理、ROS2 基础设施。设计要写成"框架需提供的 hook / 最小改动"，而不是"重新设计一个框架"。

---

## 4. Collie 的约束与未冻结假设

### 4.1 已确认的需求事实

- 形态：**四轮滑行 + 后双轮自平衡直立**；"双足站立"是对外话术，工程上是后轮支撑的动态平衡，不是静态锁止。`[文档]`（`raw/docs/requirements_scenarios.txt`、`raw/docs/mc_external_interfaces.md`）
- 典型链路：`QuadStand → QuadWheelDrive → QuadStop → Q2B → BipedBalance → B2Q → QuadWheelDrive`；站立讲解/合影时保持平衡，手势叠加。`[文档]`
- 性能/场景：领路 0.5–1.0 m/s、避障 30 cm、跟距 <5 m、5 kg 载物、展馆 IR-A/B/C。`[文档]`
- 当前设计基线（ADR-25）：策略 50 Hz（20 ms）、Worker 50 Hz、RT 200 Hz、ZOH 发布、15/20 ms 预算、25 ms TTL/hold；`mc_safety` 100 Hz；HAL/PD 1 kHz。`[建议]`（`raw/docs/adr25_50hz.md`）
- 当前设计基线：一个关节出口、`RunnerManifest`/`ActionBundle`、显式动作图、切换状态机、安全独立于推理。`[建议]`

### 4.2 未冻结、必须显式假设

| # | 未冻结项 | 为什么影响设计 | 本包的处理 |
|---|---|---|---|
| A1 | Collie 关节拓扑/关节数/顺序/左右定义 | 决定 `robot_profile`、obs/action 数组长度、所有权掩码 | **不假定 16 关节是事实**；示例用"16 关节（12 腿 + 4 轮）"仅作演示，必须标注 `[假设]` |
| A2 | "双足"是动态平衡还是静态锁止 | 决定是否需要 BalanceRunner、安全判据、切换过渡 | 按"后轮动态平衡"设计；静态锁止作为退化分支 |
| A3 | 是否有 Q2B/B2Q 自研权重/轨迹 | 决定过渡是"独立策略"还是"经典轨迹/位控" | 两种都支持；YAML 用 `transition.kind` 区分 |
| A4 | 轮的控制模式（速度/力矩/位置） | 决定 `action_spec` 的 mode、scale、kp/kd | 设计必须支持三种 mode，不写死 |
| A5 | 计算平台/推理后端/实时能力 | 决定周期、预算、是否可多进程 | 以 50/200 Hz + ZOH 为基线；后端可替换 |
| A6 | 头/臂/云台自由度与所有权 | 决定 Overlay 与 `owns_mask` | 设计支持 overlay；无自由度时退化为空 |
| A7 | 框架团队是否允许改 `inference_node` | 决定"最小改动"边界 | 设计给两种路径：适配层 / 原生扩展 |
| A8 | 配置是否允许热加载 | 决定版本/epoch/回滚 | 默认"启动加载 + 受控重载"，安全字段不热更 |

---

## 5. 当前 Collie 设计基线与张力

本包包含当前主文档（`raw/docs/current_runner_master.md`、`raw/docs/current_runner_interface.md`、`raw/docs/current_architecture_spec.md`），它们是**评审基线，不是最终结论**。GPT 可以修订，但必须显式说明"改了什么、为什么、代价"。

已知张力：

1. **Runner 中心 vs Behavior/Mode/Scope**：主文档用 `ActionBundle + IRunner`；早期交付方案用 `Behavior + CONTINUOUS/ONE_SHOT + ALL/LEGS/UPPER`。本轮的 YAML 必须能用一套最小概念同时表达连续、一次性、过渡、叠加、安全五类行为；如果做不到，要给出裁剪/迁移方案。
2. **Q2B/B2Q 是否是 Collie 的 P0**：主文档把 Q2B/BipedBalance/B2Q 列为 P0，但 Collie 的拓扑/权重/验收未冻结。设计要区分"架构必须支持"与"首版是否开放"。
3. **50 Hz vs 100 Hz**：T1 是 100 Hz（NPZ 50 Hz），Collie 训练是 50 Hz；不要把 T1 的 10 ms 预算直接搬过来。
4. **"过渡"与"插值"**：T1 证明形态切换不能靠两份行走权重插值；但同形态、同契约的模型切换可以用输出/增益斜坡。设计必须给出"何时必须独立过渡策略、何时可以框架混合"的判据，而不是一刀切。

---

## 6. 这轮只解决两个问题

### 问题 A：运控框架的 YAML 应该包含什么、怎么写、怎么设计

必须回答：

- 分几个文件？每个文件回答什么问题？谁读、什么时候读、失败怎么办？
- 哪些是机器人级、哪些是策略级、哪些是动作级、哪些是系统级、哪些是站点级？
- 如何表达关节拓扑、硬件映射、观测配方、动作解码、增益、所有权、周期、进入/退出/完成/失败、动作图、过渡、安全、速度源、日志/回放？
- 如何避免 T1 的"四份 YAML 联动、重复数组、字符串枚举、无校验"？
- 如何兼容 `roboparty_deploy` 现有 ROS2 参数与 `robot.yaml`？迁移路径是什么？
- 如何让"加一个新策略/新动作/新过渡"变成加文件 + 校验，而不是改代码？
- 如何做 schema 版本、SHA、灰度、回滚、站点标定、仿真/HIL 覆盖？

### 问题 B：模型与模型（传统或 RL）之间怎么切换、要不要过渡、怎么实现、怎么和框架协同

必须回答：

- 切换有哪些类型？各自的风险与契约差异是什么？
- 什么情况下必须过渡、什么情况下可以硬切、什么情况下禁止切换？
- 统一的切换状态机、过渡描述符、策略库是什么？不同策略（经典↔RL、RL↔RL、同形态↔跨形态、一次性↔连续、安全接管）如何映射到同一架构？
- 过渡期间谁拥有时钟/关节/命令？50 Hz 策略与 200 Hz 发布怎么协同？观测历史、last_action、phase、积分器、滤波器怎么处理？
- 失败/中止/回滚/急停怎么走？`switch_ready` 怎么定义？
- 怎么测试、怎么验收、怎么回放？指标与门槛是什么？

---

## 7. 不要做的事

- 不要把 T1 的动作 ID、关节顺序、阈值、增益当成 Collie 的事实。
- 不要设计训练算法、奖励、Sim2Real 流程。
- 不要重写 `roboparty_deploy` 的驱动/推理/ROS2 基础设施；只给"必须提供的 hook"和"最小改动"。
- 不要用"每个切换写一段专门代码"的方式；必须是一套统一架构 + 可配置策略。
- 不要用"两份模型输出线性插值"解决形态切换；物理上不成立。
- 不要在 YAML 里写代码/表达式/脚本；不要有隐式默认值。
- 不要编造未在仓库中出现的数字；读不到就写 `UNKNOWN`。

---

## 8. 证据索引（先读这些）

| 主题 | 文件 |
|---|---|
| T1 总体架构/配置/切换/安全 | `raw/docs/t1_architecture_deep_dive.md` |
| T1 变身全流程（最重要） | `raw/docs/t1_morphing_and_switch.md` |
| T1 三链路（安全/切换/整形） | `raw/docs/t1_three_links.md` |
| T1 安全专题 | `raw/docs/t1_safety_design.md` |
| T1 MC 拆解与自主设计 | `raw/docs/t1_mc_decomposition.md` |
| T1 配置原文 | `raw/t1/config/` |
| T1 策略配置原文 | `raw/t1/config/rl/`、`raw/t1/config/classic/` |
| T1 模型/动作清单 | `raw/t1/model_lists/` |
| T1 接口 | `raw/t1/interfaces/` |
| roboparty 部署说明 | `raw/roboparty/README_CN.md` |
| roboparty 配置/源码 | `raw/roboparty/` |
| 当前 Collie 基线 | `raw/docs/current_runner_master.md`、`raw/docs/current_runner_interface.md`、`raw/docs/adr25_50hz.md` |
| 需求 | `raw/docs/requirements_scenarios.txt`、`raw/docs/mc_external_interfaces.md` |

> 完整清单与 SHA256 见仓库根目录 `MANIFEST.csv` / `SHA256SUMS.txt`。
