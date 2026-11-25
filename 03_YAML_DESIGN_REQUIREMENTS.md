# 03 · YAML 配置体系设计要求（框架契约）

**版本**：V1.0　**日期**：2026-11-25
**读者**：GPT、框架团队、运控策略集成、测试/运维。
**性质**：**要求**，不是答案。它规定"设计必须满足什么"，具体 schema、文件划分、字段名由 GPT 裁决。

---

## 0. 一句话

YAML 不是"参数堆"，而是**框架与运控之间的可执行契约**：框架按它加载、校验、调度、切换、限幅、发布；运控按它交付资产、复现训练、验收安全。它必须让"加一个策略/动作/过渡"主要是加文件与校验，而不是改代码。

---

## 1. 范围

### 1.1 在范围内

- 机器人级：拓扑、关节、硬件映射、标定、URDF 引用、形态/能力声明。
- 策略级：模型/轨迹资产、tensor IO、观测配方、动作解码、增益、周期、历史、生命周期、兼容性。
- 动作级：ActionBundle、执行组、作用域/所有权、参数、进入/退出/完成/失败。
- 系统级：动作图、过渡边/过渡描述、速度源仲裁、安全限值/守卫、调度/实时、日志/回放、版本/校验。
- 站点级：单机标定、覆盖/合并规则、仿真/HIL 覆盖。
- 迁移：与 `roboparty_deploy` 现有 `robot.yaml` + ROS2 参数文件的映射、兼容、弃用。

### 1.2 不在范围内

- 框架的 C++ 类设计、线程/进程实现、ROS2 节点拆分（只给"必须提供的 hook"）。
- 训练算法、奖励、Sim2Real 流程。
- 具体标定数值（Collie 未冻结；示例必须标注 `[假设]`）。
- 业务编排/语音/导航/云台。

---

## 2. 硬性要求（R1–R15）

| # | 要求 | 验收方式 |
|---|---|---|
| **R1 单一事实源** | 同一概念只在一个文件里定义；其他文件用 ID 引用，不复制数组/阈值 | 搜索重复数组；删除一个定义后校验器能报错 |
| **R2 分层与依赖方向** | 机器人 → 策略 → 动作 → 图/系统；禁止反向依赖；禁止循环 include | 依赖图无环；加载顺序可打印 |
| **R3 稳定 ID** | 策略、动作、过渡、守卫、速度源、关节都有稳定字符串 ID；ID 不含位置/版本噪音 | ID 唯一性校验；重命名有迁移规则 |
| **R4 显式单位/坐标系** | 所有物理量带单位（SI）与 frame；角度 rad、速度 m/s、力矩 N·m、时间 ms | schema 必填；缺单位拒绝启动 |
| **R5 必填/可选/默认值** | 安全相关字段必须显式；默认值只能用于非安全字段，且必须在文档列出 | 缺必填拒绝；默认值表可审计 |
| **R6 严格枚举** | 类型/模式/阶段/策略种类用枚举；未知值拒绝，不静默 fallback | 非法枚举测试 |
| **R7 Schema + 语义校验** | JSON Schema 管结构；语义校验管关节数、tensor 维度、图连通、所有权冲突、SHA、周期兼容、守卫可达 | 一组"坏配置"必须全部被拒，且错误码可定位 |
| **R8 加载顺序与不可变** | 启动按固定顺序加载；运行期不可变；受控重载只允许白名单字段，并带 epoch/version | 重载测试；安全字段热更必须拒绝 |
| **R9 版本与兼容** | 每个文件有 `schema_version`；资产有 SHA256；兼容矩阵/迁移脚本 | 旧版本加载行为明确；不兼容拒绝 |
| **R10 站点覆盖** | 仓库默认值 + 单机标定覆盖；合并规则显式；标定不进 git 或加密 | 覆盖优先级测试；缺失标定拒绝上机 |
| **R11 可迁移** | 与 `roboparty_deploy` 的 `robot.yaml`、ROS2 参数有字段映射；可生成兼容参数 | 迁移工具/对照表；旧配置可加载 |
| **R12 可观测** | 每个字段有 owner/consumer/加载日志；错误带文件/行/字段 | 加载日志可追；错误可定位 |
| **R13 无逻辑** | YAML 不写表达式、脚本、条件语言；复杂逻辑由框架代码或生成器完成 | 静态检查；无模板语言 |
| **R14 安全默认拒绝** | 未知策略/动作/边/守卫/资产不开放；缺资产不启动；冲突不"后者覆盖" | 负向测试 |
| **R15 示例可运行** | 至少一套完整示例（Collie 假设拓扑）能通过校验器；所有数值标注示例/假设 | 示例通过 schema + 语义校验 |

---

## 3. 至少必须覆盖的文件/概念

> 文件如何拆分由 GPT 裁决；以下是**概念清单**，不是强制文件名。可以合并，但不能丢信息。

| # | 概念 | 必须回答 | 典型消费者 |
|---|---|---|---|
| 1 | **RobotProfile** | 机器人 ID/版本、关节表（name/index/role/parent/axis/limits/velocity/effort/gear/zero/sign）、轮半径/传动、闭环关节、URDF、形态/能力、传感器外参 | 加载器、ObsBuilder、ActionCodec、OutputGuard、HAL 适配 |
| 2 | **HardwareIO / Calibration** | CAN/IMU/总线、电机 ID/型号/零点/方向、采样率、超时、设备版本；单机标定覆盖 | 设备适配、启动自检 |
| 3 | **PolicyManifest** | policy_id、kind（RL/classical/hybrid）、资产路径+SHA、runtime、tensor 名称/shape/dtype、obs/action spec 引用、周期/decimation、默认位、增益、scale/clip、历史、首帧填充、生命周期、所有权/作用域、兼容的 robot/form、进入/退出/完成/失败、训练来源 | Registry、PolicyManager、InferenceBackend、Runner |
| 4 | **ObsSpec** | 逐维/逐块：index、name、source、size、unit、frame、scale、clip、filter、history/tap、dtype、required、freshness、缺失策略 | ObsBuilder、回放 |
| 5 | **ActionSpec** | 逐关节：index、name、mode（position/velocity/mit/torque）、scale、default、kp/kd（或增益集引用）、tau limit、clip、activation/ownership、解码公式 | ActionCodec、JointMux、OutputGuard |
| 6 | **ActionBundle** | action_id、显示名、form、执行组（role primary/overlay、policy 引用、rate、scope/owns、priority）、参数、允许的过渡、默认返回、超时、事件 | PolicyManager、JointMux |
| 7 | **ActionGraph / TransitionGraph** | 节点、边（from/to/guard/transition kind/params/cost/auto）、全局安全出口、默认落位、`switch_ready` 语义、禁止边 | 路由、准入、状态机 |
| 8 | **TransitionSpec** | transition_id、kind、阶段/时长/曲线、起点/终点锚定、增益插值、所有权、进入/完成/中止/回滚守卫、超时、观测历史策略、日志 | TransitionController、Runner |
| 9 | **SafetyLimits / Guards** | 位置/速度/力矩/变化率/增益限值；跌倒/超时/NaN/越界/急停；形态专属守卫（重力包络等）；安全动作与锁存/复位 | OutputGuard、SafetySupervisor |
| 10 | **InputArbitration** | 速度源 ID/优先级/TTL/零速规则/允许动作/坐标系/单位；租约/epoch；断流行为 | VelocityArbiter |
| 11 | **Runtime/Scheduling** | 策略/RT/安全/发布的周期、预算、线程/核、队列、WCET、启动/关闭顺序、过载策略 | 框架运行时 |
| 12 | **Observability/Replay** | 日志/指标/trace/黑匣子字段、采样率、体积、隐私；回放输入 | 日志、测试 |
| 13 | **SiteOverlay** | 单机序列号、标定、覆盖字段、合并优先级、生效条件 | 现场部署 |
| 14 | **Schema/Validation** | JSON Schema 文件、语义校验清单、错误码、CI 命令 | CI、启动自检 |
| 15 | **Migration/Compat** | 旧 `robot.yaml`/ROS2 参数 → 新文件的映射；生成器；弃用计划 | 框架团队 |

---

## 4. 字段设计规则

1. **数组 vs 映射**：关节这类"有稳定名字、需要按名引用"的用映射/列表+name；纯向量用数组，但必须给顺序来源（引用 `joint_order`），不能在多处重复。
2. **不要重复"关节顺序"**：`joints_name`、`seq`、`action_seq`、`usd2urdf` 这类重复是 T1 的主要维护负担；新设计应只保留一份 `joint_order` + 可选的 `model_order`/`vendor_order` 映射。
3. **不要重复"默认位/增益/scale"**：按策略引用 `gain_profile` / `pose_profile`；动作级只写差异。
4. **周期/频率**：统一用 `period_ms` 或 `rate_hz`，不要混用；必须能被调度器整除/校验（例如 50 Hz 策略 + 200 Hz RT = 4:1）。
5. **时间**：统一 ms；超时/预算/TTL 分开命名，不要都叫 `timeout`。
6. **枚举**：`kind`、`mode`、`phase`、`guard`、`status` 用小写 snake_case；禁止字符串拼写变体。
7. **可选块**：用 `null`/缺省表达"没有"，不要用空字符串/0 代替。
8. **注释**：允许；但注释不能成为唯一文档；每个字段的语义进 schema description 或字段表。
9. **路径**：相对仓库根/包根；禁止绝对路径；资产用 `asset_id` + 相对路径 + SHA。
10. **安全字段**：不允许默认值；必须显式；修改需要版本/审批。

---

## 5. 加载、校验、失败语义

### 5.1 加载顺序（建议，待 GPT 裁决）

```text
schema 版本检查
  → robot_profile / hardware_io / calibration
  → policy manifests + obs/action specs（逐项校验 tensor/维度/SHA）
  → action bundles（引用解析、所有权冲突）
  → action graph / transition specs（连通性、守卫、默认落位）
  → safety limits / input arbitration / runtime
  → 交叉校验（周期、关节数、form、能力、资产）
  → 预分配/预热
  → 开放请求
```

### 5.2 失败语义

- 任何必填/安全/资产/维度/图错误 → **拒绝启动**，不能"带病启动"。
- 非安全可选功能（如某个 overlay）失败 → 可降级禁用，但必须发布 `DEGRADED` 状态与原因。
- 运行期配置不可变；受控重载失败 → 保持旧版本，记录 epoch，不半更新。
- 错误码必须包含：文件、字段路径、期望/实际、错误类别；不要只报"配置错误"。

### 5.3 版本/兼容

- `schema_version` 采用 `major.minor`；major 不兼容，minor 向后兼容。
- 资产 `sha256` 必填；模型/轨迹/URDF 都要。
- 兼容矩阵：robot_profile 版本 × policy manifest 版本 × 框架版本；不匹配拒绝。
- 迁移：提供旧→新生成器/对照表；旧字段保留一个发布周期的只读兼容。

---

## 6. 与 `roboparty_deploy` 的兼容要求

1. **不要求框架团队扔掉现有 `robot.yaml`**：新的 RobotProfile 应能由它生成/映射，或在其上加字段。
2. **不要求现有 `configs/*.yaml` 立即重写**：提供适配器，把旧 ROS2 参数转换为新的 PolicyManifest；旧文件可继续作为"兼容输入"，但新能力（图/过渡/安全）必须走新文件。
3. **全局参数变成 per-policy**：`joint_num`、`dt`、`action_scale`、`joint_default_angle`、`clip_cmd`、`usd2urdf` 目前在配置文件级共享；新设计要明确哪些是机器人级、哪些是策略级，并给出冲突处理。
4. **多输入 ONNX**：`setup_model` 现在拒绝多输入；新 manifest 必须能声明 `observations` + `observation_history` 两个输入，并给框架"最小改动"（例如扩展 `setup_model`/`InferenceBackend`）。
5. **经典控制器**：`motion_player.py` 是独立进程；新设计要把它变成一种 `PolicyKind=classical/playback`，共享关节出口与状态，或明确"首版仍独立、如何保证单写者"。
6. **运行时切换**：当前只有手柄暂停-换指针-重置；新设计要定义服务/内部 API、状态机、过渡；同时保留手柄作为调试入口。

---

## 7. 必须给出的示例

至少给出以下完整/半完整示例（数值标注 `[假设]`，不要冒充 Collie 标定）：

1. `robot_profile` + `hardware_io` + `calibration`（16 关节假设：12 腿 + 4 轮；或明确声明你的假设拓扑）。
2. 一个 RL 连续行走策略的 `manifest` + `obs_spec` + `action_spec`（含 `command`、`last_action`、历史 10 帧、50 Hz）。
3. 一个经典位控站立策略的 `manifest`（含 `kp/kd/default/exit`）。
4. 一个一次性过渡策略（Q2B 或 B2Q）的 `manifest`（phase/q_ref、完成判据、超时、回退）。
5. 一个 `ActionBundle`（primary + overlay，`owns_mask`，冲突检查）。
6. 一段 `action_graph`（含 3 个全局安全出口、默认落位、至少 2 条显式 via）。
7. 至少 3 条 `transition` 边（同形态模型换版、经典↔RL、形态切换）。
8. `safety_limits` / `input_arbitration` / `runtime` 的关键片段。
9. 一个"新增策略/动作/过渡"的 checklist（改哪些文件、跑哪些校验、谁签收）。

---

## 8. 交付时必须回答的设计问题

1. 文件怎么拆？为什么不是一个大 YAML？拆分的判据是什么？
2. 哪些字段是机器人级/策略级/动作级/系统级/站点级？边界判据？
3. 关节顺序、默认位、增益、scale、clip 如何只定义一次并被多处引用？
4. 经典控制、RL、混合、mimic/playback 如何用同一套 manifest 表达？
5. 观测配方用 YAML 数组、CSV 还是生成器？逐维字段怎么保证与训练一致？
6. 动作解码如何表达 position/velocity/torque/MIT 四种模式与 per-joint 覆盖？
7. 所有权/scope/overlay 如何声明与冲突检查？
8. 动作图/过渡图如何表达守卫、via、默认落位、全局安全出口、`switch_ready`？
9. `TransitionSpec` 如何用数据描述"混合/斜坡/轨迹/独立策略/门控/暂停换指针"？
10. 安全限值/守卫/安全动作/锁存复位如何配置？哪些字段禁止热更？
11. 速度源优先级/TTL/零速规则/租约如何配置？
12. 周期/预算/线程/核/队列如何配置？50/200 Hz 如何校验？
13. schema 版本、资产 SHA、兼容矩阵、灰度/回滚怎么做？
14. 站点标定/仿真/HIL 覆盖如何合并？优先级/冲突？
15. 旧 `roboparty_deploy` 配置如何迁移？哪些字段弃用？
16. 校验器要报哪些错？错误码/定位/负向测试清单？
17. 一个新人如何只看 YAML 就知道"现在能跑什么、不能跑什么、为什么"？

---

## 9. 验收标准（框架团队可执行）

- [ ] 一套完整示例能通过 schema + 语义校验，启动时打印加载摘要（文件/版本/SHA/周期/动作数/边数）。
- [ ] 故意构造的 20 个坏配置全部被拒，错误能定位到文件/字段。
- [ ] 新增一个策略：只加 manifest + 资产 + 可选 spec，不改 C++；通过校验后能被 Registry 发现。
- [ ] 新增一个动作：只加 ActionBundle + 图边 + 过渡（如需要），不改 C++。
- [ ] 新增一个过渡：只加 TransitionSpec + 边，复用已有策略库，不改 C++。
- [ ] 旧 `robot.yaml`/`configs/*.yaml` 能通过适配器加载，行为与迁移前一致（差分回放）。
- [ ] 运行期重载安全字段被拒绝；非安全字段重载失败保持旧版本。
- [ ] 站点标定缺失时拒绝上机；覆盖优先级可打印。
- [ ] 所有安全相关字段无默认值；所有枚举未知值被拒。
- [ ] 文档能回答 §8 的 17 个问题，且每个字段有 owner/consumer/失败语义。
