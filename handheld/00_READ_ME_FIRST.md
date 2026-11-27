# 00 · 先读这里

## 0.1 这份材料要解决什么

一条真实的 T1 使用场景：机器人已在**双足形态**、`BIPED_LOCOMOTION_WBC`(300) 行走/站立；人牵住它的一只手往前走；视觉跟随全程没锁定目标，但机器人跟着走了。
我们要搞清楚三件事：

1. **判定**：系统怎么知道"人牵上了"？是不是"通用四足行走 + 另配一个换 kp/kd 的 runner"？
2. **切换**：要不要单独进"牵手模式"？是显式切动作，还是行走/待机时牵一下就自动生效？准入、保持、准出分别是什么？
3. **解算**：从"手被拉"到"机器人给多大的 vx / yaw"，中间每一步是什么、参数多少、单位是什么？

## 0.2 先说清楚：没有源码

- T1 运控闭源。仓库里 **没有** `ArmDragLocomotion` 的实现代码。
- 能拿到的只有：**板端 YAML**（含大量中文注释）、**IDL/msg/srv**、**ONNX 的输入输出形状**、**任务规则 YAML**。
- 因此本文档集的证据结构是：
  - **直接证据**：字段存在、字段值、注释原文、接口定义、ONNX shape；
  - **推断**：字段名 + 数值关系 + 控制常识 → 算法结构；
  - **未知**：无法从配置判定的语义（如 `ka/kb` 的单位、`push_wheel_threshold` 的量纲）。

> 如果 GPT 把推断写成事实，就是失败。每一节都要标 `[证据] / [推断] / [未知]`。

## 0.3 三层框架（读的时候一直带着它）

```text
┌─────────────────────────────────────────────────────────────┐
│ L1 Action 层（action_ruler / action_setting / action_state） │
│   - 有哪些动作、谁能到谁、300 挂哪些执行组                    │
│   - 这里没有"牵手"这个动作；牵手不是 Action                   │
├─────────────────────────────────────────────────────────────┤
│ L2 Runner 内部（rl/bi_wbc_run.yaml 的 arm_drag 段）          │
│   - 检测、计数、解算 vx/yaw、轮端回馈、推背                   │
│   - 这是"模式"真正存在的地方：runner 内部子状态               │
├─────────────────────────────────────────────────────────────┤
│ L3 Command 层（command_scales / obs[46..48] / ONNX）         │
│   - 解算结果最终只是 3 维速度指令，进策略观测                  │
│   - 策略不知道"手"的存在                                      │
└─────────────────────────────────────────────────────────────┘
```

**核心待验证命题**：L2 的 `arm_drag` 是一个**runner 级能力**，而不是 L1 的动作/模式。若成立，则"牵手"= 在某个允许软臂的 biped runner 里，把物理形变翻译成 L3 的速度指令。

## 0.4 已确认事实（可直接引用）

| # | 事实 | 证据 |
|---|---|---|
| F1 | `arm_drag` 只出现在两份配置：`qd1_t2d0/rl/bi_wbc_run.yaml`、`qd1_t2d0/rl/bi_gimbal.yaml`（t1d5 同名文件也有） | `raw/t1/*/rl/*.yaml` |
| F2 | 四足行走 `quad_walk.yaml`、双足普通行走 `bi_walk.yaml` **没有** `arm_drag` | 同上 |
| F3 | `bi_walk.yaml` 前 6 关节 `kp=30`；`bi_wbc_run.yaml` 前 6 关节 `kp=1.0/0.5/0.5`，且 300 还挂了 `animation_player`（4 ms，`idle` 档 `kp=4/2/4`） | `bi_walk.yaml`、`bi_wbc_run.yaml`、`action_setting.yaml`、`animation_player.yaml` |
| F4 | 300 的 ONNX 输入是 `observations[1,49]` + `observation_history[1,490]`，输出 `action[1,14]`；**没有力的输入** | `raw/model_io.txt` |
| F5 | `DAMPING_DEFAULT`(2) 只能回 `PASSIVE_DEFAULT`，是终端安全态，不能走路 | `action_ruler.yaml` |
| F6 | `held_state` 是 5 态 + `is_held`，挂在 `McCommonState`/`InteractionState`；`AmRequest` 有 `REASON_HELD=41` | IDL/msg/srv |
| F7 | 9 份任务规则写 `allow_held_state: false`；`follow.yaml` **没有**该字段 | `raw/t1/task_engine/rule/*.yaml` |
| F8 | 102（四足行走）**不能**直接到 300；必须先 `QUADRUPED_TO_BIPED(_ROTATE)`(10/11)，再由 10/11 到 300 | `action_ruler.yaml` |
| F9 | 300 的出口不含 `BIPED_STAND_DEFAULT`（被注释），只能去其它动作/变形/安全态 | `action_ruler.yaml` |
| F10 | 手臂柔顺是**分档配置**：`idle/animation/planner` 开重力补偿 + 低 kp；`hold/rigid` 关补偿 + 高 kp | `animation_player.yaml` |

## 0.5 关键未知（不要编）

| # | 未知 | 为什么难 |
|---|---|---|
| U1 | `bx_qz_cmd_ka/kb` 的物理含义与单位 | 0.1/0.01（WBC）与 3.14/17.5（gimbal）差两个数量级；可能是 PD、也可能是一阶滤波 |
| U2 | `push_wheel_threshold` 量纲 | 0.03 / 0.5 / 5.0 三个值，rad / N·m / 其它均可能 |
| U3 | 拖拽指令与外部速度源是覆盖还是叠加 | `SetMcInputSource` 管外部源；`arm_drag` 在 runner 内部，二者关系无直接证据 |
| U4 | `held_state` 与内部 `drag_active` 是否同一个判据 | 注释说"计数大于该值才上报"，但上报链路在 runner 还是 MC 未证实 |
| U5 | `wheel_*` 回路是"轮角积分"还是"轮力矩" | 字段名像位置，阈值又像力矩 |
| U6 | 左手/右手同时牵时 roll 取谁、是否相加 | 5 态合并，但没有合并算法证据 |

## 0.6 怎么读（顺序很重要）

### 第一遍（先形成自己的判断，约 20 分钟）

1. `02_CONTEXT_BRIEF.md`
2. `03_THREE_QUESTIONS.md`
3. `packs/01_HANDHELD_CONFIGS.md`（重点：`arm_drag` 段、`command_scales`、`animation_player` 的 idle/animation/hold）
4. `packs/02_ACTION_SAFETY_AND_GATING.md`（重点：`action_ruler` 的 102→10/11→300、300 的出口、`DAMPING` 的出口）
5. `packs/05_MODEL_IO_AND_LIMITS.md`（重点：ONNX 只有 49+490 输入、14 输出；关节限位）

### 第二遍（补接口与门控）

6. `packs/03_INTERFACES_AND_RULES.md`（`held_state`、`AmRequest`、9 条 `allow_held_state`、`follow.yaml`）

### 第三遍（再对照我们的假设）

7. `packs/04_ANALYSIS_HYPOTHESIS.md`：**先自己写结论，再读它**；逐条标"同意/修正/反驳/证据不足"。

### 需要原始上下文时

- `raw/t1/qd1_t2d0/rl/bi_wbc_run.yaml`、`raw/t1/qd1_t2d0/rl/bi_gimbal.yaml`、`raw/t1/qd1_t1d5/rl/*`（版本对比）
- `raw/t1/qd1_t2d0/classic/animation_player.yaml`、`damping_default.yaml`
- `raw/t1/qd1_t2d0/action_ruler.yaml`、`action_setting.yaml`、`action_state.yaml`、`security_guard.yaml`
- `raw/t1/interfaces/*`
- `raw/t1/task_engine/rule/*`
- `raw/t1/qd1_t2d0/model_io.txt`、`robot_model.yaml`、`urdf/qd1.urdf`

## 0.7 交付时最低要求

- 每个结论后面给 `文件 + 字段`；推断标 `[推断]`，未知标 `[未知]`。
- 三个问题各自先给"一句话结论"，再展开；不要先铺垫后回答。
- 至少画三张图：**判定/计数时序图**、**准入准出状态机**、**速度解算信号流图**。
- 对 U1–U6 每个未知：给出**两种可能解释 + 判别实验**，不要二选一硬猜。
- 最后给"如果要在 Collie 复刻，最小实现集是什么"。
