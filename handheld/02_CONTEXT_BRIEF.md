# 02 · 背景压缩版（细节以仓库原始文件为准）

## 2.1 T1 的构型与"手臂"从哪来

T1 是**可变形的轮足机器人**：四足形态（前腿当腿、后腿带轮）⇄ 双足形态（前腿变成两条手臂、后腿变成双腿带轮）。

- 共 **14 个关节**，顺序固定：
  `FL_HIP_ROLL, FL_HIP_PITCH, FL_KNEE, FR_HIP_ROLL, FR_HIP_PITCH, FR_KNEE, RL_HIP_ROLL, RL_HIP_PITCH, RL_KNEE, RL_FOOT, RR_HIP_ROLL, RR_HIP_PITCH, RR_KNEE, RR_FOOT`
- 双足形态下，**FL/FR 六个关节 = 两条手臂**（roll/pitch/knee 三自由度），末端就是"手"；RL/RR 八个 = 双腿 + 两个轮。
- 躯干坐标系 `BASELINK`：**x 向上、z 向前后**（不是常见的 z 向上）。所以"手往前伸"是 **+z**。证据：`security_guard.yaml` 的 `foot_relative_guard` 注释、T1 架构文档 §10.8。
- 上肢关节限位（`robot_model.yaml`）：roll ±0.43633 rad；pitch −1.1868…4.3284 rad；knee ±2.5831 rad。

## 2.2 动作与执行组：300 是什么

`action_setting.yaml` 里每个动作挂一个或多个"执行组"，一个执行组 = 一条周期线程：

| 动作 | 执行组 | 周期 | 说明 |
|---|---|---|---|
| `BIPED_LOCOMOTION_WBC`（300） | `rl_bi_loco_wbc` + `animation_player` | **10 ms + 4 ms** | 策略 100 Hz 管下肢/轮，上肢 250 Hz 由动画组写 |
| `BIPED_GIMBAL` | `rl_bi_gimbal`（单组） | 10 ms | 一手持相机、一手牵引的变体 |
| `BIPED_LOCOMOTION_DEFAULT` | `rl_bi_loco`（`bi_walk.yaml`） | 10 ms | 普通双足行走，前 6 关节 `kp=30`，**无拖拽** |
| `QUADRUPED_LOCOMOTION_DEFAULT`（102） | `rl_quad_loco`（`quad_walk.yaml`） | 10 ms | 四足行走，**无拖拽** |
| `DAMPING_DEFAULT`（2） | `damping_default_t1` | **2 ms** | 全身 `kp=0` 的阻尼急停 |

**关键点**：300 有两个写者——策略写 14 维（前 6 关节增益很软：`1.0/0.5/0.5`），animation_player 以 250 Hz **覆盖**前 6 关节（`kp=4/2/4`，带重力补偿）。谁最终生效，配置只能证明"两个线程都在写"，精确优先级属实现，标 `[推断]`。

## 2.3 300 的策略接口（ONNX）

`raw/t1/qd1_t2d0/model_io.txt`：

```text
IN  observations        [1, 49]
IN  observation_history [1, 490]   # 10 帧 × 49
OUT action              [1, 14]
```

- 49 维观测的布局由 `bi_wbc_run.yaml` 的 `obs_index` 给出：
  `imu_omega 0..2`、`imu_euler 3..5`、`pos 6..17`、`vel 18..29`、`action 32..45`、**`command 46..48`**。
- **策略没有"力/拖拽/牵手"输入**。任何物理交互要影响它，只能编码进这 49 维——也就是 46..48 的三维速度指令。
- 这是回答"牵手是不是新 runner/新策略"的关键证据：**策略本身不需要、也无法知道手的存在**。

## 2.4 牵手相关配置：一份能力，两处使用

`arm_drag` 只出现在：

1. `qd1_t2d0/rl/bi_wbc_run.yaml`（300，双足 WBC）
2. `qd1_t2d0/rl/bi_gimbal.yaml`（BIPED_GIMBAL）
3. `qd1_t1d5/rl/bi_wbc_run.yaml`、`qd1_t1d5/rl/bi_gimbal.yaml`（旧机型，字段略有差异）

`bi_gimbal.yaml` 的注释直接点名机制：**"手臂拖拽（牵手 + 推背）：复用 WBC 的 ArmDragLocomotion。"**
`bi_gimbal.yaml` 还多一段 `arm_compliance`：**"拖拽生效时把牵引手（非相机手）设为『重力补偿浮动』，可被人轻松拉动；相机手保持刚性"**。

### 2.4.1 `arm_drag` 字段（t2d0 WBC / t1d5 WBC / gimbal）

| 参数 | t2d0 WBC | t1d5 WBC | gimbal | 单位/语义（配置注释） |
|---|---|---|---|---|
| `enable` | true | true | true | 总开关 |
| `deadzone_roll_threshold` | 0.17 | 0.17 | 0.17 | rad，约 10°，`abs(roll)` 低于此不转 |
| `w_deadzone_roll_threshold` | 0.17 | 0.17 | 0.17 | 疑似新旧字段并存 |
| `roll_threshold` | 0.2 | 0.17（后又被 0.3 覆盖，重复键） | 0.3 | rad，持续贴近后进入"持续加速转圈" |
| `yaw_spin_confirm_frames` | 5 | — | 5 | 帧 |
| `yaw_spin_accel` | 0.8 | — | 2.0 | rad/s² |
| `yaw_vel` | 1.2 | 1.2 | — | rad/s |
| `yaw_vel_scale_kp` | 20.0 | 10.0 | 10.0 | 1/s（比例） |
| `yaw_vel_scale_kd` | 0.4 | 0.8 | 0.8 | 微分 |
| `t` | `[1.0,0.5,1.0, 1.0,0.5,1.0]` | 同 | — | 上肢 6 关节前馈力矩（N·m，推断） |
| `kp` | `[4,2,4, 4,2,4]` | 同 | — | 上肢 6 关节刚度（N·m/rad） |
| `kd` | `[0.2]*6` | 同 | — | 上肢 6 关节阻尼 |
| `bx_qz_cmd_kp` | — | 3.14（注释掉 3.56，旁注「1.5m/s」） | — | 前后单增益 |
| `bx_qz_cmd_ka` / `kb` | 0.1 / 0.01 | — | 3.14 / 17.5 | 前后双增益（含义未知） |
| `forward_pos_threshold` | 0.24 | 0.30 | 0.30 | m，`BASELINK z`；`abs(z)` 低于此不触发前进/后退 |
| `forward_confirm_frames` | 100 | 100 | 100 | 帧（100 Hz ≈ 1 s） |
| `arm_above_default_pitch_threshold` | 0.15 | 0.15 | — | rad，约 8.6° |
| `arm_below_default_pitch_threshold` | 1.50 | 1.50 | — | rad，约 86° |
| `drag_count_threshold` | — | 10 | — | 帧；"某只手连续满足触发条件且计数大于该值才上报" |
| `wheel_default_x` | 0.0 | — | 0.0 | 轮角零位 |
| `wheel_pos_threshold` | 0.02 | — | 0.02 | rad |
| `wheel_cmd_reduce_kp` | 3.0 | — | 18.0 | 轮端"收"指令增益 |
| `wheel_cmd_rise_kp` | 3.0 | — | 10.0 | 轮端"加"指令增益 |
| `wheel_decel_reset_threshold` | 0.1 | — | 0.2 | 复位阈值 |
| `push_wheel_threshold` | 0.5 | — | 5.0（t2d0）/ 0.03（t1d5） | 推背阈值（量纲未知） |
| `push_accel_kp` / `push_decel_kp` | 3.0 / 3.0 | — | 3.0 / 3.0 | 推背增益 |
| `push_release_decel` | 0.6 | — | 0.6 | 释放减速度 |
| `push_vel_max` | 1.4 | — | 1.4 | m/s |
| `push_stop_threshold` | 0.05 | — | 0.05 | m/s |
| `push_confirm_frames` | 50 | — | 50 | 帧 |
| `joystick_cooldown_frames` | 250 | — | 250 | 帧；摇杆动过后禁止推背 |

### 2.4.2 速度钳位与后处理（`command_scales` / `WalkConfig`）

| 参数 | t2d0 WBC | t1d5 WBC | gimbal | 语义 |
|---|---|---|---|---|
| `cmd_x_min/max` | −1.4 / 1.4 | −0.3 / 1.0 | −1.2 / 1.2 | 正常速度钳位 |
| `cmd_yaw_min/max` | ±3.0 | ±3.0 | ±3.0 | 正常转向钳位 |
| `drag_x_min/max` | −1.4 / 1.4 | 未设 | −1.0 / 1.0 | 拖拽通道独立钳位 |
| `drag_yaw_min/max` | ±3.0 | 未设 | ±1.5 | 拖拽通道独立钳位 |
| `xlim_with_yaw` | 0.3 | 未设 | 0.0 | 转向压前进 |
| `x_acc_clip_scale` | 0.5 | 未设 | 未设 | 加速度钳位 |
| `acc_x` / `acc_x_accel` | 1.0 / 1.0 | 1.0 / 1.0 | 1.0 / 1.0 | m/s²，减速/加速 |
| `acc_yaw` | 3.0 | 3.0 | 3.0 | rad/s² |
| `bias_vx` / `bias_dyaw` | −0.02 / −0.018 | 0 / 0 | 0 / 0 | 偏置 |
| `transition_frames` | 15 | 15 | — | 进入过渡帧 |
| `cmd_guard.expiration_time_ms` | 200 | 200 | 200 | 指令过期（`security_guard.yaml`） |

## 2.5 三个"阻尼"必须分开

| | 名字 | 数值 | 范围 | 能否走路 |
|---|---|---|---|---|
| ① | `DAMPING_DEFAULT`(2) | `kp=0`、`kd=3.0`（`kd_d=1.5`），2 ms 周期，带躺姿 `position` | 全身 14 关节 | **不能**，只能回 PASSIVE |
| ② | animation_player `idle` 档 | `kp=[4,2,4]`、`kd=0.2`、`gravity_scale 0.6/0.75` | 6 上肢 | 300 的常态（推断） |
| ③ | `arm_drag` / `arm_compliance` | 同量级 + `clip_tau 1.0` + `rest_return_rate 0.5` | 牵引手 | 是 |

- ①的证据：`action_ruler.yaml` 中 `DAMPING_DEFAULT.next_actions` 只有 `PASSIVE_DEFAULT`；`action_state.yaml` 的 `estimator.secure_action: DAMPING_DEFAULT`。
- ②的证据：`animation_player.yaml` 的 `idle:` 与 `gravity_comp: idle: enable true`；`hold/rigid` 关补偿、kp 15–30。
- ③的证据：`bi_gimbal.yaml` 的 `arm_compliance` 注释与数值；`bi_wbc_run.yaml` 的 `arm_drag.kp/kd/t`。

## 2.6 动作图：怎么才能"到得了"300

`action_ruler.yaml`（节选）：

- `QUADRUPED_LOCOMOTION_DEFAULT`(102) 的 `next_actions`：`QUADRUPED_LOCOMOTION_STEP`、`STORE_DEFAULT`、`QUADRUPED_TO_BIPED`(10)、`QUADRUPED_TO_BIPED_ROTATE`(11)、`QUADRUPED_GET_DOWN_DEFAULT`。**没有 300。**
- `QUADRUPED_TO_BIPED` / `_ROTATE` 的 `next_actions`：**`BIPED_LOCOMOTION_WBC`(300)**（10 还允许 `BIPED_LOCOMOTION_TERRAIN`）。
- `BIPED_LOCOMOTION_WBC`(300) 的 `next_actions`：`BIPED_TO_QUADRUPED`、`BIPED_TO_QUADRUPED_ROTATE`、`BIPED_LOCOMOTION_TERRAIN/RUN/DEFAULT/ROTATE_LOCAL/BACKBEND`、`BIPED_YUZURU/SPLIT/MOONWALK/DANCE/ANIMATION`、`BIPED_MIMIC/LINGCHUANG_MIMIC/GIMBAL/NPZ_MIMIC`、`BIPED_RECORD_UPPER/CUSTOM_UPPER`。**`BIPED_STAND_DEFAULT` 被注释掉。**

**含义**：

1. 四足行走时**不可能**被牵手——检测器根本不在 102 里；必须先变形到双足、落位 300。
2. 300 里"牵手"不是一个动作，所以动作图上没有"进入/退出牵手"的边；动作图只管"要不要待在 300"。
3. 从 300 出来要么换动作/变形，要么安全接管；没有"回站立"的直连边。

## 2.7 `held_state` 与任务门控

- `McHandHeldState`：`UNKNOWN(0)`、`BOTH_NOT_HELD(1)`、`LEFT_HELD_ONLY(2)`、`RIGHT_HELD_ONLY(3)`、`BOTH_HELD(4)`，另有 `is_held`。
- `is_held` 注释：**"False when neither hand is held or the combined state is unknown"** ——**未知不等于没牵**。
- 挂在 `McCommonState`（50 Hz 全量状态）与 `InteractionState`；`AmRequest` 有 `REASON_HELD = 41`（"机器人被牵手中"）。
- 9 份任务规则 `allow_held_state: false`：`posture`、`whole_body`、`upper_body`、`rc_joystick`、`rc_gyro`、`motion_teach`、`motion_record`、`motion_playback`、`factory_reset`。
- `follow.yaml` **没有** `allow_held_state`，所以"跟随任务"可以与"被牵"共存——这是牵手跟随能成立的制度前提。

## 2.8 真机日志实证（UC3，`c2_events.log`）

> 这是**实测**，不是二手转述；原始日志 10.8 MB 未打包，摘录见 `raw/logs/`。

设备端 2026-10-28 会话，UC3「牵手跟随」：

| 时刻 | 事件 | 证据 |
|---|---|---|
| 14:35:13.982 | `QUADRUPED_TO_BIPED_ROTATE`(11) | `[MCA] action_desc` |
| 14:35:18.822 | `BIPED_LOCOMOTION_WBC`(300) | 同上 |
| 14:35:24.716 | `hand_held` 首次变为 1（BOTH_NOT_HELD），`form=2` | `[IST]` |
| **14:37:24.205** | **`is_held: true`，`hand_held: 3`（RIGHT_HELD_ONLY）** | `[IST]` |
| 14:37:48.634 | `is_held: false` | `[IST]` |
| 14:39:30.427 | 再次 `true`（hand=3） | `[IST]` |
| 14:39:45.661 | `false` | `[IST]` |
| 14:40:02.221 | 再次 `true` | `[IST]` |
| 14:40:40.760 | `false` | `[IST]` |
| 14:40:46.385 | 再次 `true` | `[IST]` |

**四个必须注意的实测事实**：

1. **动作没变**：整个过程 `action_desc` 始终是 `BIPED_LOCOMOTION_WBC`。held 的 on/off 是动作内部状态，不是 Action 切换。
2. **held 是多次 on/off**：24.4 s → 15.2 s → 38.5 s → …，不是"一牵就一直 true"。松手/换手会立刻反映到 `held_state`。
3. **单右手**：`hand_held` 恒为 3（RIGHT_HELD_ONLY）；进入 300 后约 2 分 5 秒才首次 held，说明是外力触发，不是进入动作即置位。
4. **视觉通路同时丢失**：`[FLW] state` 在 14:37:24 从 0 变 1（"未发现目标"），与"牵手遮挡相机"一致。

**日志不能证明**：vx/yaw 的数值、关节角、`arm_drag` 中间量（日志只有 IST/MCA/FLW，没有 `McCommonState` 的速度/关节字段）。所以"解算公式"仍需靠配置推断 + 实验。

## 2.9 我们的当前假设（**不是证据**）

完整假设稿在 `packs/04_ANALYSIS_HYPOTHESIS.md`，一句话：

> 手臂默认就软（idle 档，kp 4/2/4 + 重力补偿）；人手的力让手臂形变；`arm_drag` 用**关节角偏差/手端位移**做检测与计数，用 **PD + 死区 + 确认帧 + 限幅 + 加速度斜坡**把形变解算成 `(vx, yaw)`，写进 49 维观测的 `command[46..48]`；策略完全不知道手的存在。`DAMPING_DEFAULT` 不参与。

**GPT 的任务是独立验证/推翻它，而不是复述它。**
