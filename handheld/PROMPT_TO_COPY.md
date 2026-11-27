## 任务

你是一名资深机器人运控工程师（15 年以上，做过多足/轮足/双足的实时控制、阻抗/导纳控制、量产安全），现在要做一次**逆向机制分析**：只凭公开的配置、接口定义、模型输入输出，把 T1 的"牵手跟随"彻底拆开，回答三个具体问题，并产出一份可评审的 HTML 报告。

这不是让你"设计一个新框架"，也不是文档润色。你要做的是：

1. **从证据反推机制**：字段名、注释、数值关系、动作图、接口定义 → 判定链路、状态机、解算公式。
2. **明确区分证据与推断**：配置能证明什么、只能推测什么、完全不知道什么。
3. **回答用户真正问的三件事**（见下），每问先给一句话结论，再展开。
4. 最后给一份"如果要在 Collie 复刻"的最小实现集与验证实验。

**最重要的一句话**：

> 仓库里**没有运控源码**。`arm_drag` / `ArmDragLocomotion` 只有配置和注释。你必须把"配置能证明的"与"你推断的"严格分开；编造字段或日志视为失败。

---

## 1. 输入仓库

**https://github.com/bgzou/t1-mc-config-switch-design-20261125/tree/main/handheld**

> 仓库根目录下还有 2026-11-25 的旧输入包（YAML/切换设计），**与本任务无关，不要读**。只看 `handheld/` 子目录。

### 1.1 先读这 4 份

1. `handheld/00_READ_ME_FIRST.md` —— 证据规则、三层框架（Action / Runner / Command）、已确认事实与未知。
2. `handheld/02_CONTEXT_BRIEF.md` —— T1 构型、300 WBC、配置地图、`arm_drag` 全字段表。
3. `handheld/03_THREE_QUESTIONS.md` —— 三个问题的逐项展开与验收标准。
4. `handheld/07_DELIVERABLE_SPEC.md` —— HTML 章节、图、评分、输出协议。

### 1.2 再读这 5 个阅读包（带 FILE 头，便于一次读多份）

| 优先级 | 文件 | 读什么 |
|---|---|---|
| P0 | `handheld/packs/01_HANDHELD_CONFIGS.md` | `arm_drag` 全字段（t2d0/t1d5/gimbal）、`command_scales`、`animation_player` 五档、`damping_default`、`bi_walk`/`quad_walk` 对照 |
| P0 | `handheld/packs/02_ACTION_SAFETY_AND_GATING.md` | `action_ruler`（102→10/11→300；300 的出口；DAMPING 只回 PASSIVE）、`action_setting`、`action_state`、`security_guard` |
| P0 | `handheld/packs/05_MODEL_IO_AND_LIMITS.md` | ONNX 只有 `observations[1,49]` + `observation_history[1,490]`、输出 `action[1,14]`；关节限位；obs 布局 |
| P1 | `handheld/packs/03_INTERFACES_AND_RULES.md` | `McHandHeldState` 5 态、`is_held` 语义、`AmRequest REASON_HELD=41`、9 条 `allow_held_state:false`、`follow.yaml` |
| P1 | `handheld/packs/04_ANALYSIS_HYPOTHESIS.md` | 我们的假设稿 + T1 架构/接口文档摘录。**先自己下结论，再读它** |

原始文件在 `handheld/raw/`（UTF-8 副本，已去 BOM；`raw/ENCODING.md` 说明）。

### 1.3 如果浏览受限

按顺序至少读：`00_READ_ME_FIRST.md` → `02_CONTEXT_BRIEF.md` → `03_THREE_QUESTIONS.md` → `packs/01` → `packs/05`。
读不到就让用户粘贴对应文件；**不要凭空补全**。

### 1.4 阅读声明（必须写在正文最前面）

列出：实际读了哪些文件、没读哪些、对结论的影响。不要假装读过。

---

## 2. 背景（细节以仓库为准）

- T1 是可变形的轮足机器人：四足（前腿当腿）⇄ 双足（前腿当手臂）。14 关节；双足形态下 FL/FR 六个关节是两条手臂。
- 躯干系 `BASELINK`：**x 向上、z 向前后**。手往前伸 = +z。
- `BIPED_LOCOMOTION_WBC`(300)：100 Hz 策略（14 维动作）+ 250 Hz 上肢动画组。普通双足行走 `bi_walk` 手臂 `kp=30`（硬）；300 的手臂由 `animation_player` 的 `idle` 档（`kp=4/2/4`，重力补偿 0.6）覆盖。
- `arm_drag` 只出现在 `bi_wbc_run.yaml` 与 `bi_gimbal.yaml`；四足行走 `quad_walk`、普通双足 `bi_walk` 都没有。
- `bi_gimbal.yaml` 注释："手臂拖拽（牵手 + 推背）：复用 WBC 的 ArmDragLocomotion。"另有 `arm_compliance`：牵引手"重力补偿浮动"、相机手刚性。
- 300 的策略输入只有 49 维观测 + 10 帧历史，输出 14 维动作；观测里 `command` 在 46..48。**策略没有力的输入**。
- `DAMPING_DEFAULT`(2) 是 `kp=0` 的终端安全态，`next_actions` 只有 `PASSIVE_DEFAULT`，不能走路。
- `held_state`：5 态 + `is_held`，50 Hz 广播；9 条任务规则 `allow_held_state:false`；`follow.yaml` **不**拦 held。
- 动作图：102 不能直接到 300；必须先 10/11 变形，再由 10/11 落位 300。300 的出口里 `BIPED_STAND_DEFAULT` 被注释掉。

---

## 3. 必须回答的三个问题

> 每问开头先写 **「一句话结论」**（≤40 字），再展开。详细子问题见 `03_THREE_QUESTIONS.md`，以下是要点。

### Q1 · 怎么判定"进入牵手"？是不是"通用四足行走 + 另配一个换 kp/kd 的 runner"？

必须回答：

1. "牵手模式"存在于哪一层（Action / Runner / Command）？有没有一个动作/枚举/服务？
2. 判定用了哪些物理量（roll / pitch / 手端位移 / 轮端 / 电流）？逐手还是合并？
3. 每个判据的阈值、单位、连续帧数、折算时间；为什么转向 5 帧、前进 100 帧？
4. `held_state` 与 runner 内部"拖拽生效"是不是同一个判据？"计数大于该值才上报"说明什么？
5. **逐项检验用户的假设**：general 四足行走 + 新 runner 换 kp/kd。
   - 四足行走能不能被牵？普通双足 `bi_walk` 能不能？只改 kp/kd 缺什么？
   - `arm_drag` 是动作专属还是 runner 能力？gimbal 复用 WBC 说明什么？
6. 最小实现集：复刻"判定"需要哪些信号/配置/状态/接口？

### Q2 · 具体切换流程？要单独进"牵手模式"吗？待机牵一下会自动进入吗？准入准出怎么定？

必须回答：

1. 准入：形态、动作、配置、软臂档、手屏蔽、动作图路径（102→10/11→300）；从 102 能否直接牵？
2. 进入：有没有显式入口（`SetMcAction` / 服务）？没有的话是不是自动？"待机牵"与"行走中牵"是否等价？
3. 保持：死区、计数、轮端回馈、滞回；松手又抓住会不会抖？左右手交替怎么迁移？
4. 准出：松手判据、回位（`rest_return_rate`）、减速（`push_release_decel`/`acc_x`）、TTL；动作级退出（换动作/变形/跌倒/急停）；为什么 300 不能回 `BIPED_STAND_DEFAULT`？
5. 仲裁：拖拽 vs 视觉跟随（`SetMcInputSource` + `velocity`）vs 摇杆（`joystick_cooldown_frames`）；`cmd_guard 200 ms` 是否作用于拖拽？
6. 对外：`held_state` 何时置位/清零；9 条规则与 `REASON_HELD=41`；`follow.yaml` 为什么不拦。

### Q3 · 具体怎么解算速度？逐项拆开

必须回答：

1. 观测量与坐标系：哪些关节量、是否需要 FK、`BASELINK` 轴向；`forward_pos_threshold` 为什么是米。
2. 转向：roll → yaw 的公式、死区 0.17、增益 10/20、kd 0.4/0.8、"持续加速转圈"（0.2/0.3 + 5 帧 + 0.8/2.0）、钳位 1.5/3.0。
3. 前后：Δz → vx；`forward_confirm_frames 100`；`bx_qz_cmd_kp 3.14/3.56` 与 `ka/kb` 两种写法；钳位 1.0/1.4。
4. 推背：检测量、`push_wheel_threshold`、`push_accel/decel_kp 3.0`、`push_vel_max 1.4`、`push_release_decel 0.6`、`push_stop_threshold 0.05`、确认 50 帧。
5. 轮端：`wheel_pos_threshold 0.02`、`rise/reduce_kp`、`decel_reset_threshold` 组成前馈还是反馈？
6. 整形：`acc_x 1.0`、`acc_yaw 3.0`、`xlim_with_yaw 0.3`、`bias_vx −0.02`、`bias_dyaw −0.018`、`cmd_guard 200 ms` 的顺序与作用。
7. 编码：`obs[46..48]` 的语义与量纲；`dyaw 1.2`、`height 0.0`、`lin_vel 2.0`、`obs_clip 20`、堆 10 帧。
8. 等效导纳：把"手端力 → 速度"折成一个等效增益（含单位），给数量级估算。
9. 对 `ka/kb`、`push_wheel_threshold`、轮端回路、左右手合并、拖拽 vs 外部速度：各给 **两种解释 + 判别实验**。

---

## 4. 证据纪律（硬要求）

- 每个结论后给 `文件路径 · 字段名`；推断标 `[推断]`，未知标 `[未知]`。
- 配置优先于二手文档；文档与 YAML 冲突时以 YAML 为准。
- 仓库没有源码：不要写"代码里是……"；写"从字段/注释推断……"。
- 不要编造字段、单位、阈值、日志。
- 不要把 `raw/analysis/` 的假设稿当证据复述；先独立判断，再逐条裁决（同意/修正/反驳/证据不足）。
- 不要用"通常/一般来说"代替 T1 的具体证据；如果只能给通用做法，明确标 `[通用工程做法，非 T1 证据]`。

---

## 5. 交付物

按 `07_DELIVERABLE_SPEC.md` 输出**一个自包含 HTML**（inline CSS/SVG，无外部依赖），中文。必须含：

0. **答案卡**：三问各一句结论 + 三层归属小图 + 阅读声明。
1. **Q1**：判定矩阵、判定时序图、"新 runner + 换 kp/kd"逐项裁决表、最小实现集。
2. **Q2**：准入准出状态机、动作图 vs runner 子状态双层对照、时间线、异常退出表、仲裁。
3. **Q3**：信号流图、公式表、参数-语义表、数值例子、伪代码、等效导纳。
4. **证据/反证/未知**：S/M/W 证据表；每个未知两种解释 + 判别实验。
5. **Collie 映射**（≤1 页）：`interaction.hand_held` YAML 草案、三条硬契约、5 条验收用例。
6. **验证实验**：E1–E10（问题/操作/观测字段/判据）。
7. **附录**：参数总表、文件索引、自评分。

> 图表用 inline SVG（不要 mermaid 代码块）。图里的每个阈值都要能在正文表格找到出处。

---

## 6. 输出协议

- 先写阅读声明，再写答案卡，再按 Q1→Q2→Q3 展开。
- 结论先行；不要先铺陈"我将分析……"。
- 引用格式：`handheld/raw/... · 字段`。
- HTML 超长时按 PART 1/3、2/3、3/3 分段，每段自包含。
- 最后给自评分（按 07 的评分表）与"最不确定的三点"。

---

## 7. 开始

现在打开仓库，从 `handheld/00_READ_ME_FIRST.md` 开始。先确认你能读到文件，再动笔。
如果你发现证据与本文档集的描述冲突，**以仓库原始配置为准**，并在报告里明确指出冲突点。
