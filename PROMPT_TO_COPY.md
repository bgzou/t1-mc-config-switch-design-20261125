## 任务

你是一名资深机器人运控软件架构师（15 年以上，做过四足/轮足/双足、硬实时控制、功能安全、量产交付），同时是**配置 schema 设计者**。现在为 **Collie 轮足机器人**的运控（MC）软件框架，产出两份设计：

1. **框架的 YAML 配置体系**：框架应该加载哪些 YAML、每个文件包含什么、字段怎么设计、怎么校验、怎么版本化、怎么迁移；
2. **模型与模型之间的切换/过渡架构**：传统控制与 RL、同形态与跨形态、一次性技能与连续运动、安全接管，如何用**一套统一架构**表达；什么时候必须过渡、怎么实现、怎么和框架协同。

这不是文档润色，也不是写原则清单。你要产出**可评审、可落地、可验收**的设计：框架团队能据此写加载器/Registry/Graph/TransitionController，运控团队能据此交付策略资产，测试能据此做回放/故障注入/HIL，非软件背景决策者能看懂代价与待拍板项。

**最重要的一句话**：

> Collie 的运控框架由另一个团队基于 Roboparty 的 `roboparty_deploy` 实现；**你不设计框架代码，你设计框架必须遵守的配置契约与切换/过渡行为**。凡是需要框架改代码的地方，写成"框架需提供的 hook / 最小改动"，不要写成"重新设计一个框架"。

---

## 1. 输入仓库与阅读要求

仓库（公开）：

**https://github.com/bgzou/t1-mc-config-switch-design-20261125**

### 1.1 先读这 7 份"元文档"

1. `00_READ_ME_FIRST.md` — 阅读顺序、证据规则、两套候选抽象的张力。
2. `02_CONTEXT_BRIEF.md` — T1 事实、`roboparty_deploy` 能力/缺口、Collie 约束。
3. `03_YAML_DESIGN_REQUIREMENTS.md` — YAML 的 R1–R15、至少覆盖的 15 类概念、验收标准。
4. `04_SWITCHING_DESIGN_REQUIREMENTS.md` — 切换类型、统一状态机、TransitionSpec、策略库、12+ 案例。
5. `06_OPEN_QUESTIONS.md` — 15 个必须裁决的问题。
6. `05_EVIDENCE_MAP.md` — 论断→证据→强度。
7. `08_DELIVERABLE_SPEC.md` — 最终 HTML 的章节/图表/评分/输出协议。

### 1.2 再按优先级读 packs（带 FILE 头的拼接版）

| 优先级 | 文件 | 读什么 |
|---|---|---|
| P0 | `packs/03_T1_SWITCHING_EVIDENCE.md` | 变身全流程、6 条过渡策略、相位表、重力包络、落位、退出判据、T1 踩坑 |
| P0 | `packs/05_ROBOPARTY_DEPLOY.md` | `robot.yaml`、7 份策略配置、`inference_node`/`ros_interface`/`obs_manager`/`robot_interface` 源码、`motion_player.py`、launch/start |
| P0 | `packs/01_T1_SYSTEM_CONFIGS.md` | `mc_T1`、`action_setting`、`action_state`、`action_ruler`、`security_guard`、`robot_model`、`motion_list`、设备/系统模式/进程配置 |
| P1 | `packs/02_T1_POLICY_CONFIGS.md` | 代表性 RL/经典配置（**raw 有全量 48 份 RL + 13 份 classic**）；重点看 `quad_walk`、`quad_step`、`bi_wbc_run`、`quad_to_bi_run`、`bi_to_quad_run`、`classic/quad_stand_default`、`classic/damping_default` |
| P1 | `packs/04_T1_SAFETY_AND_INPUTS.md` | 安全八层、三通道跌倒、速度源仲裁、超时族、恢复 |
| P1 | `packs/06_MODELS_AND_OBS.md` | 42 个 RL 条目、34 份权重、obs 布局、网络统计、动作→执行组→runner |
| P1 | `packs/07_INTERFACES_AND_UPSTREAM.md` | MC 接口目录、任务引擎配置、需求原文 |
| P2 | `packs/08_ANALYSIS_AND_BASELINE.md` | 当前 Collie Runner 主文档、接口/数据链路、ADR-25 50 Hz、外部接口、需求；**先读 `current_runner_master` + `adr25_50hz` + `t1_mc_decomposition`，`t1_4plus1_design` 只在需要时读** |

**原始文件**在 `raw/` 下；packs 是便于一次读多份的拼接版，引用行号/上下文时回到 raw。

### 1.3 最低必读（如果上下文/浏览受限）

至少读：

1. `00_READ_ME_FIRST.md`
2. `02_CONTEXT_BRIEF.md`
3. `03_YAML_DESIGN_REQUIREMENTS.md`
4. `04_SWITCHING_DESIGN_REQUIREMENTS.md`
5. `packs/03_T1_SWITCHING_EVIDENCE.md`
6. `packs/05_ROBOPARTY_DEPLOY.md`

再至少读 `packs/01`、`packs/02`、`packs/06`、`packs/08` 的关键节。

在正文 **Part 1 开头**列出：你实际读了哪些文件、没读哪些、对设计结论有什么影响。**不要假装读过**。读不到就写 `UNKNOWN` 并给解决路径，不要编数字。

---

## 2. 背景压缩版（细节以仓库为准）

### 2.1 分工边界

- **运控团队（我们）**：策略资产、观测/动作规格、进入/退出/完成判据、切换语义、安全包络、验收向量。
- **框架团队（另一团队）**：基于 `roboparty_deploy` 实现 `motion_runtime`：配置加载、Registry、Graph、PolicyManager、TransitionController、JointMux、OutputGuard、状态发布。
- **本体/驱动**：关节拓扑、零点/方向/限位、CAN/IMU、URDF。
- **你**：配置契约 + 切换/过渡架构；不写框架代码，不设计训练算法，不设计导航/感知/业务。

### 2.2 T1 证据（可复用结构，不可复制数值）

- T1 有 52 个换乘节点 / 197 条边 / 3 个全局出口 / 24 个 skip；58 个动作 / 62 个执行组 / 62 个 runner；42 个 RL 条目 / 34 份权重 / 48 份 RL 配置。
- 配置即策略：`action_ruler.yaml`（谁能到谁）、`action_setting.yaml`（动作挂哪些组/周期/优先级/runner）、`action_state.yaml`（状态分组/安全动作/恢复）、`rl/*.yaml`（模型/观测/增益/尺度/退出）。
- 加新动作要改 4 处；配置重复、字符串枚举、无 schema 校验；Runner 缓存键 `name|cfg_path|period`；冷启动有 1.7 s 级资源加载。
- 变身不是模型插值：6 条独立 RL 过渡策略（常规/旋转/前空翻 × 2 方向），phase/q_ref 驱动，不接速度；3.0–4.8 s；`gravity_guard` 用成功录制曲线，30°/40°、连续 2 帧；`exit_timeout`/`auto_switch_timeout`。
- 落位不是同一个策略：Q2B→WBC，B2Q→四足行走；靠末态对齐 + 目标侧 0.15–0.2 s 平滑 + 1 s 里程计静默；PD 增益硬跳变。
- 旧策略退出判据分散：WBC 等速度归零 20–100 步；四足行走冻步态/等脚落稳；位控位置差+超时。
- 安全八层；`cmd_guard` 200 ms、反馈 10 ms、跌倒 50 ms 检查、60°/3 帧、6 rad/s+48°/3 帧、脚 FK 20 帧；跌倒→阻尼实测 11 ms；急停是系统层杀进程，不是换动作。
- 速度源 7 个 + 1 硬编码；优先级 70–100；TTL 1000 ms；零速不能抢（安全源除外）。
- 状态：`status=100` 运行 / `200` 切换；`switch_ready` 才是接新动作的权威；状态 50 Hz 广播。

### 2.3 `roboparty_deploy` 基线（必须尊重）

- ROS2 Humble + C++17 + yaml-cpp + ONNX Runtime；`inference_node` 单节点；`robot.yaml` 硬件配置（RPO 的 23 电机、4 路 CAN、IMU、kp/kd、方向、零偏、闭环映射、URDF→电机顺序；**T1 是 14 个 RL 动作关节，别把 RPO 的 23 混进来**）。
- `configs/*.yaml` 是 ROS2 参数：`model_names`（可多个）、`motion_names`、`obs_layouts`、`frame_stacks`、`obs_stack_orders`、`act_alpha`、`joint_num`、`decimation`、`dt`、观测尺度/裁剪、`action_scale`、`clip_actions`、`usd2urdf`、`clip_cmd`、`joint_default_angle`、`joint_limits`、`gravity_z_upper`。
- 观测源：`cmd_vel / ang_vel / gravity_b / dof_pos / dof_vel / last_action / interrupt / perception / motion_pos / motion_vel / latent`；支持 `name:size@tap|tap` 稀疏历史。
- 运行时：`inference` 50 Hz 级 + `control` 250 Hz 级；`act_alpha` 低通；手柄 X/A/B/Y/LB/RB；`/start_inference`、`/stop_inference`、`/init_motors` 等服务。
- 运行时"切策略"是暂停推理→换 `active_policy_idx_`→`reset_policy_runtime`→恢复；**无过渡、无图、无切换服务**。
- `setup_model` 只支持单输入 ONNX；输出缓冲按 `joint_num`。
- 经典动作播放是独立进程 `motion_player.py`，200 Hz，直接 `apply_action(positions)`，不带增益，不与 `inference_node` 共享所有权。
- 缺：配置分层、参数隔离、运行时切换服务、过渡、图/准入、安全出口、状态/事件、schema 校验、多输入 ONNX、经典控制器统一编排。

### 2.4 Collie 约束与未冻结项

- 需求：**四轮滑行 + 后双轮自平衡直立**；"双足站立"是对外话术，工程上是**后轮动态平衡**，不是静态锁止。
- 典型链路：`QuadStand → QuadWheelDrive → QuadStop → Q2B → BipedBalance → B2Q → QuadWheelDrive`；站立讲解/合影保持平衡，手势叠加。
- 当前设计基线（ADR-25）：策略 50 Hz / Worker 50 Hz / RT 200 Hz / ZOH / 15–20 ms 预算 / 25 ms TTL/hold；`mc_safety` 100 Hz；HAL/PD 1 kHz。
- **未冻结**：Collie 关节拓扑/关节数/顺序；双足是动态平衡还是静态锁止；Q2B/B2Q 自研权重/轨迹；轮的控制模式；计算平台/推理后端；头/臂/云台自由度；框架是否允许改 `inference_node`；配置是否热加载。
- **示例用"16 关节（12 腿 + 4 轮）"只是演示假设，不是事实**。设计必须与拓扑解耦；所有示例数值标 `[假设]`。

### 2.5 两套候选抽象的张力

当前主文档用 `ActionBundle + IRunner`；早期交付方案用 `Behavior + CONTINUOUS/ONE_SHOT + ALL/LEGS/UPPER`。你的任务不是简单选一个，而是给出**统一模型**：用一套最小概念同时表达连续、一次性、过渡、叠加、安全五类行为，并说明如何裁剪/迁移。YAML 必须能承载这套模型；如果承载不了，明确说哪一层放弃、为什么。

---

## 3. 任务 A：YAML 配置体系设计

### 3.1 必须回答

- 分几个文件？每个文件回答什么问题？谁读、什么时候读、失败怎么办？
- 哪些是机器人级、策略级、动作级、系统级、站点级？边界判据？
- 如何表达：关节拓扑/硬件映射/标定、策略 manifest、tensor IO、obs 配方、动作解码、增益/尺度/限幅、所有权/作用域、周期、进入/退出/完成/失败、动作图、过渡、安全、速度源、调度、日志/回放、站点覆盖？
- 如何避免 T1 的"四份 YAML 联动、重复数组、字符串枚举、无校验"？
- 如何兼容 `roboparty_deploy` 的 `robot.yaml` 与 ROS2 参数？迁移路径、适配器、弃用？
- 如何让"加一个新策略/新动作/新过渡"主要是加文件 + 校验，而不是改代码？
- 如何做 schema 版本、资产 SHA、兼容矩阵、灰度、回滚、站点标定、仿真/HIL 覆盖？
- 每个字段的 owner/consumer/失败语义是什么？

### 3.2 必须覆盖的概念

至少 15 类（文件如何拆分由你裁决，但信息不能丢）：

1. **RobotProfile**：机器人 ID/版本、关节表（name/index/role/parent/axis/limits/velocity/effort/gear/zero/sign）、轮半径/传动、闭环关节、URDF、形态/能力、传感器外参。
2. **HardwareIO / Calibration**：CAN/IMU/总线、电机 ID/型号/零点/方向、采样率、超时、设备版本、单机标定覆盖。
3. **PolicyManifest**：id/kind（RL/classical/hybrid/playback/transition/safety）、资产路径+SHA、runtime、tensor 名称/shape/dtype、obs/action spec 引用、period/decimation、default pose、gains、scale/clip、history/first-frame、lifecycle、ownership/scope、兼容的 robot/form、entry/exit/complete/fail、训练来源。
4. **ObsSpec**：逐块/逐维：index、name、source、size、unit、frame、scale、clip、filter、history/tap、dtype、required、freshness、missing policy。
5. **ActionSpec**：逐关节：index、name、mode（position/velocity/mit/torque）、scale、default、kp/kd（或增益集引用）、tau limit、clip、activation/ownership、解码公式。
6. **ActionBundle**：action_id、显示名、form、执行组（role primary/overlay、policy 引用、rate、scope/owns、priority）、参数、允许的过渡、默认返回、超时、事件。
7. **ActionGraph / TransitionGraph**：节点、边（from/to/guard/transition kind/params/cost/auto）、全局安全出口、默认落位、`switch_ready`、禁止边。
8. **TransitionSpec**：transition_id、kind、阶段/时长/曲线、起点/终点锚定、增益插值、所有权、进入/完成/中止/回滚守卫、超时、观测历史策略、命令处理、日志。
9. **SafetyLimits / Guards**：位置/速度/力矩/变化率/增益限值；跌倒/超时/NaN/越界/急停；形态专属守卫（重力包络等）；安全动作与锁存/复位。
10. **InputArbitration**：速度源 ID/优先级/TTL/零速规则/允许动作/坐标系/单位；租约/epoch；断流行为。
11. **Runtime/Scheduling**：策略/RT/安全/发布的周期、预算、线程/核、队列、WCET、启动/关闭顺序、过载策略。
12. **Observability/Replay**：日志/指标/trace/黑匣子字段、采样率、体积、隐私；回放输入。
13. **SiteOverlay**：单机序列号、标定、覆盖字段、合并优先级、生效条件。
14. **Schema/Validation**：JSON Schema、语义校验、错误码、CI。
15. **Migration/Compat**：旧 `robot.yaml`/ROS2 参数 → 新文件的映射、生成器、弃用计划。

### 3.3 硬性要求（R1–R15，详见 `03_YAML_DESIGN_REQUIREMENTS.md`）

单一事实源、分层无环、稳定 ID、显式单位/frame、必填/默认值、严格枚举、schema+语义校验、加载顺序/不可变、版本/SHA/兼容、站点覆盖、可迁移、可观测、无逻辑、安全默认拒绝、示例可校验。

### 3.4 必须给出的示例

- 一套完整示例（Collie 假设拓扑，16 关节仅演示）：robot profile + hardware/calibration + 1 个 RL 行走 manifest + obs/action spec + 1 个经典站立 manifest + 1 个 Q2B 过渡 manifest + ActionBundle + graph 片段 + 3 条 transition 边 + safety + inputs + runtime。
- "新增策略/动作/过渡"checklist（改哪些文件、跑哪些校验、谁签收）。
- 至少 8 个坏配置（缺关节、tensor 维度不匹配、所有权冲突、非法边、缺 SHA、周期不整除、未知枚举、安全字段默认值）与预期错误。
- 把 `roboparty_deploy` 的 `default.yaml` + `robot.yaml` 映射到新文件的示例。

---

## 4. 任务 B：模型切换与过渡架构

### 4.1 必须回答

- 切换有哪些类型？各自契约差异、物理风险、是否必须过渡？
- 什么情况下必须独立过渡策略、什么情况下框架混合就够、什么情况下禁止切换？给决策树。
- 统一状态机、TransitionSpec、策略库是什么？经典↔RL、RL↔RL、同形态↔跨形态、一次性↔连续、安全接管如何映射到同一架构？
- 过渡期间谁拥有时钟/关节/命令/观测历史？50 Hz 策略与 200 Hz 发布怎么协同（ZOH/斜坡/超时）？
- 目标策略首拍失败/推理超时/NaN 怎么办？过渡中急停/跌倒/失稳/断流怎么办？失败/中止/回滚目标是什么？
- `switch_ready` 怎么定义、何时发布？
- 如何保证无隐式中转、无双写、无越权？
- 如何测试/回放/验收？指标与门槛？

### 4.2 必须覆盖的切换类型（至少）

| # | 类型 | 例子 | 关键 |
|---|---|---|---|
| T1 | 同 Action 模型换版 | walk_v1 → walk_v2 | 契约近似；可选短斜坡 |
| T2 | 同形态不同 Policy | stand ↔ walk、walk ↔ run | 观测/增益/门控 |
| T3 | 经典 ↔ RL | 位控站立 → RL 行走 | 锚点+历史重置+斜坡 |
| T4 | 一次性技能 ↔ 连续 | walk → dance/mimic → walk | 起止锚点+完成/返回 |
| T5 | 跨形态 | 四足 ⇄ 双足 | **独立过渡策略，禁止插值** |
| T6 | 安全接管 | 任意 → damping/passive | **立即硬切，禁止过渡** |
| T7 | 速度源切换 | 导航 → 遥控 | 仲裁/epoch，不是模型切换 |
| T8 | Overlay 增删 | 平衡 + 手势/头 | 局部所有权/淡入淡出 |
| T9 | 多 Policy 并发 | primary + overlay | 所有权/周期/启动顺序 |
| T10 | 配置/参数变更 | 增益/限幅/模型路径 | 受控重载；安全字段不热更 |

### 4.3 必须给出的统一架构

- **状态机**：`IDLE → REQUESTED → ADMITTED → PREPARE_EXIT → WAIT_EXIT → HANDOFF → ENTER → STABILIZE → RUNNING` + `ABORT/ROLLBACK/FAULT/SAFE`；每状态的进入/退出/超时/取消/幂等。
- **TransitionSpec**：kind/phases/curves/anchor/ownership/history/command/timeouts/fallback/events/logging。
- **策略库（≥9 种）**：`hard_cut / output_blend / gain_ramp / pose_anchor / trajectory / dedicated_policy / gated_wait / pause_swap / sequential`；每种给适用/不适用/参数/保证/失败模式；一张"策略×场景"矩阵。
- **所有权/epoch/单写者**：过渡期间 source/target/transition 三方所有权；JointMux 合成；OutputGuard 唯一出口。
- **50/200 Hz 时序**：ZOH、斜坡、候选过期、超时；图+时序。
- **观测/历史/命令**：清空/保留/重建/冻结；last_action/phase/积分器/滤波器/里程计。
- **失败/回退矩阵**：准入、退出、加载、首拍、推理超时、NaN、失稳、急停、断流、落位失败、回滚失败。
- **状态/事件/switch_ready**：字段、频率、语义、上层编排。
- **过渡期安全**：跌倒/接触/重力/滑移判据切换；急停独立性。
- **12–14 个具体案例**：from→to、原因、契约差、风险、是否过渡、策略、守卫、最大时长、失败/回退、验收。
- **至少 5 条 transition 的 YAML 示例**：同契约换版、经典↔RL、走→停、Q2B、B2Q、安全接管。

### 4.4 统一性约束（防止又长成 T1）

- 一套状态机；一套描述符；一套策略接口；一套所有权；一套状态/事件；一套错误码；一套测试；一套配置。
- 差异用 `TransitionSpec` 数据表达；禁止 `if (from == ... && to == ...)` 的专门分支。
- 新增切换只改 YAML（边 + TransitionSpec + 可选新策略类），不改 PolicyManager 主流程。
- 禁止：每个控制器自己实现 ExitCheck/PreRunOnce；图寻路自动插中转；两份模型输出线性插值做形态切换；过渡期间两个 runner 都写关节；过渡没有超时/回退；安全接管等推理返回；`switch_ready` 只看动作名/定时器。

---

## 5. 必须裁决的问题（Q1–Q15）

逐条给**决策/理由/替代方案/代价/切换条件/验证方法**，不能只写"建议进一步确认"：

1. Collie 关节拓扑/关节数/顺序/左右定义？设计如何与拓扑解耦？
2. "双足"是后轮动态平衡还是静态锁止/腿足站立？
3. 首版是否开放 Q2B/B2Q？有无自研权重/轨迹？
4. 轮的控制模式：速度/力矩/位置/MIT？
5. 策略周期是否锁定 50 Hz（20 ms）？
6. 框架是否允许改 `inference_node`，还是只加适配层？
7. 运行时切换是服务/内部 API，还是只保留手柄？
8. 框架是否支持多输入/多输出 ONNX？
9. 经典控制器（位控/播放器）是独立进程还是纳入 Runner？
10. 安全权威：框架内 `OutputGuard`，还是独立安全节点？
11. 是否允许配置热加载？哪些字段？
12. 站点标定/单机差异如何管理？
13. 头/臂/云台自由度是否存在？Overlay 范围？
14. 首版开放哪些动作/边？哪些默认关闭？
15. 旧 `roboparty_deploy` 配置的兼容期多长？

默认建议见 `06_OPEN_QUESTIONS.md`；不同意必须说明理由与代价。

---

## 6. 交付物：单文件 HTML

**文件**：`T1_MC_YAML_SWITCH_DESIGN.html`

**硬要求**：

- 中文正文；UTF-8；`<html lang="zh-CN">`。
- 单文件：CSS 在 `<style>`；图用 inline SVG；不引用外部 CDN/字体/图片/JS。
- 浏览器直接打开、可打印 PDF；带目录；目标 150–300 KB，不超过 500 KB。
- 不允许 `TODO`/`待补充`/空章节；未知写 `UNKNOWN` + 解决路径。

**章节**（顺序可微调，不能缺）：

| 章节 | 必须包含 |
|---|---|
| 封面+阅读指南 | 标题/日期/版本/状态/读者/范围；10 分钟/1 小时/完整三条路径；证据标记说明 |
| Part 0 执行摘要与决策表 | 一段话；12–15 条决策表（决策/理由/替代/代价/状态）；给非软件决策者的 5 分钟版；交付物地图 |
| Part 1 范围、证据、假设 | 范围/非目标；T1 证据摘要；roboparty 基线/缺口；Collie 约束/未冻结项；实际阅读清单 |
| Part 2 配置体系总览 | 10–12 条原则；分层/依赖图；文件地图（owner/生命周期/消费者）；加载顺序+失败语义；所有权矩阵；版本/兼容/灰度/回滚；迁移路径 |
| Part 3 逐文件 Schema | 15 类概念，每类：目的/owner/字段表（字段/类型/必填/单位/默认/语义/校验/消费者）/完整示例/反模式/失败模式 |
| Part 4 完整示例 | 16 关节假设的完整 YAML 集；新增策略/动作/过渡 checklist；8 个坏配置+预期错误；roboparty 迁移示例 |
| Part 5 切换/过渡架构 | 类型表；决策树；状态机图+状态表；TransitionSpec；≥9 策略库+矩阵；所有权/epoch 图；50/200 Hz 时序；观测/历史/命令表；失败/回退矩阵；状态/事件/switch_ready；12–14 案例表；≥5 条 transition YAML；反模式 |
| Part 6 与框架协同 | 框架必须提供的 hook/API；映射到 roboparty 模块/文件；最小改动 vs 原生扩展；线程/周期/预算；IDL 草图；迁移阶段 M0–M5；工作量/风险 |
| Part 7 测试/验收/运维 | 测试矩阵（schema/图、单元、回放、SIL、HIL、真机）；golden trace；故障注入；指标/门槛；日志/黑匣子；发布门 |
| Part 8 决策/风险/开放问题 | Q1–Q15 裁决；风险登记；待拍板（谁/何时/证据）；路线图 |
| 附录 | 完整 YAML 索引；JSON Schema 摘录；证据索引；T1→Collie 映射；术语；自评 |

**必备图表**（inline SVG，至少 8 张）：配置分层/依赖、加载顺序、动作图示例、切换状态机、所有权/epoch 时序、50/200 Hz ZOH 时序、经典↔RL 锚点过渡、Q2B/B2Q phase+guard 时间轴、故障/回退决策树。

**必备表格**（至少 15 张）：决策表、文件地图、字段表、策略×场景矩阵、案例表、状态表、失败/回退矩阵、观测处理表、测试矩阵、指标表、迁移映射、T1 踩坑、风险、开放问题、评分表。

**示例要求**：至少 8 个完整 YAML、5 条 transition、8 个坏配置；数值标 `[假设]`；不得把 T1 数字写成 Collie 标定值。

> 详细规格见 `08_DELIVERABLE_SPEC.md`；以上是必须满足的最低集。

---

## 7. 证据与写作规则

1. 引用证据写 `[E-xx]`（见 `05_EVIDENCE_MAP.md`）+ 文件路径/字段；不要只写"根据配置"。
2. 区分 `[事实]/[实测]/[文档]/[假设]/[建议]/[待定]/[推断]`；未冻结的 Collie 参数必须标 `[假设]`。
3. T1 的 Action ID、关节顺序、阈值、增益、模型尺度**不能直接复制**到 Collie；只复用结构关系与工程约束。
4. 读不到的文件写 `UNKNOWN` + 解决路径；不要编数字。
5. 发现文档冲突（例如注释与数值不一致、两套抽象冲突），在正文指出，并以原始配置/源码为准。
6. 每个设计裁决必须给：决策、理由、替代方案、代价、切换条件、验证方法。
7. 不要写"应该考虑/建议进一步"的空话；每段至少一个可执行结论/字段/示例。
8. 不要用 Markdown 交付；最终必须是 HTML。正文可以用表格/图/代码块。
9. **写作密度**：不要大段复述仓库原文；用"结论 + 字段表 + 示例 + 失败路径"。每个 Part 开头给 3–5 行"本 Part 回答什么、结论是什么"。
10. **长度不够时的保底顺序**（不能省）：① 文件地图 + 6 个核心 schema（robot/policy/obs/action/transition/safety）；② 统一切换状态机 + TransitionSpec + 策略库；③ 10 个切换案例；④ 5 条 transition YAML；⑤ 8 张图。其余章节可以压缩，但不能删。

---

## 8. 输出协议

### 8.1 如果有 Canvas / 代码执行 / 文件下载

- 直接生成 `T1_MC_YAML_SWITCH_DESIGN.html` 并提供下载。
- 同时在对话里给：章节结构、字数/体积、自评分、未决问题。
- 不要只给片段。

### 8.2 如果只能文本输出

按三段输出，保证可拼接：

- **第 1 段**：`<!DOCTYPE html>` 到 Part 4 结束，最后一行 `<!-- PART1_END -->`。
- **第 2 段**：`<!-- PART2_START -->` 到 Part 6 结束，最后一行 `<!-- PART2_END -->`。
- **第 3 段**：`<!-- PART3_START -->` 到 `</html>`。

规则：

- 每段放在**一个** ```html 代码块里；代码块外只写"第 X/3 段，回复『继续』输出下一段"。
- 不要在第 1 段提前闭合 `</body></html>`；不要在第 2 段重复 `<html><head>`。
- 每段结尾必须是完整标签/完整章节，不能断在表格/代码块中间。
- 第 3 段末尾给自评分与"如何本地打开"。
- 如果一次能输出完整文件，直接给完整文件，并在开头写"完整版（1/1）"。

### 8.3 续写

- 用户回复"继续"时，从上次标记之后精确续写，不重复前文，不重新总结。
- 如果发现前文有错，在续写开头用 3 行"更正"说明，然后继续。
- 不要降低后续详细度；后续章节同样要有字段表/示例/图。

---

## 9. 自检与评分（在最后输出）

按 100 分自评：

| 维度 | 分值 |
|---|---:|
| YAML 体系完整性 | 20 |
| Schema 深度与字段语义 | 20 |
| 切换/过渡架构 | 25 |
| 框架协同/可落地 | 15 |
| 示例/校验/测试 | 10 |
| HTML 质量 | 5 |
| 证据纪律 | 5 |

通过线：≥80，且"切换/过渡架构"≥20、"YAML 体系"≥16。

自检清单：

- [ ] 单文件、无外部依赖、可打印。
- [ ] 目录锚点全部可用；无空章节。
- [ ] 15 类配置概念全部覆盖。
- [ ] 12+ 切换案例全部有"是否过渡/策略/守卫/时长/回退"。
- [ ] 至少 8 张 SVG、15 张表、8 个完整 YAML、5 条 transition。
- [ ] 所有 T1 数字有 `[E-xx]`；所有 Collie 示例标 `[假设]`。
- [ ] Q1–Q15 全部裁决。
- [ ] 自评分与未决问题。

---

## 10. 不要做的事

- 不要重新设计 `roboparty_deploy` 的驱动/推理/ROS2 基础设施；只给"必须提供的 hook"和"最小改动"。
- 不要设计训练算法、奖励、Sim2Real 流程。
- 不要设计导航/感知/语音/云台/业务编排。
- 不要把 T1 的动作 ID/关节顺序/阈值/增益当成 Collie 的事实。
- 不要用"每个切换写一段专门代码"；必须是一套统一架构 + 可配置策略。
- 不要用"两份模型输出线性插值"解决形态切换。
- 不要在 YAML 里写代码/表达式/脚本；不要有隐式默认值。
- 不要编造未在仓库中出现的数字；读不到写 `UNKNOWN`。
- 不要只给原则/清单；每个结论都要能落到字段、示例、时序、失败路径或验收。

---

**现在开始。** 先读 `00_READ_ME_FIRST.md` 与 `02`–`04`，再读 packs；在 Part 1 开头列实际阅读清单；然后按 Part 0→8 输出 HTML。不要先问问题；信息不足时做最合理假设并标注。
