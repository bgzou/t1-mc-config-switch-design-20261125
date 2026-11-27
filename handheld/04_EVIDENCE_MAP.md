# 04 · 证据地图（论断 → 证据 → 强度）

**强度定义**

- **S（强）**：配置字段/接口定义/ONNX shape 可直接核对，语义由字段名或注释明确。
- **M（中）**：字段存在且数值可核对，但语义靠命名/上下文推断。
- **W（弱）**：来自二手文档/现象记录，只能作背景。

| # | 论断 | 证据（文件 · 字段/行） | 强度 |
|---|---|---|---|
| E1 | 拖拽能力只挂在 WBC 与 GIMBAL 两个 biped 配置上 | `raw/t1/qd1_t2d0/rl/bi_wbc_run.yaml` · `arm_drag:`；`raw/t1/qd1_t2d0/rl/bi_gimbal.yaml` · `arm_drag:`；全目录 grep 仅此两处（t1d5 同名两份） | S |
| E2 | 四足行走、普通双足行走都没有拖拽 | `raw/t1/qd1_t2d0/rl/quad_walk.yaml`、`bi_walk.yaml`：**无** `arm_drag` 字段 | S |
| E3 | 普通双足行走上肢是硬臂 | `bi_walk.yaml` · `ACConfig.robot.kps` 前 6 关节 = `30.0` | S |
| E4 | WBC 上肢策略输出很软，但被动画组覆盖 | `bi_wbc_run.yaml` · `kps` 前 6 = `1.0/0.5/0.5`；`action_setting.yaml` · 300 挂 `animation_player` 4 ms；`animation_player.yaml` · `idle.kp = 4/2/4` | S（数值）/ M（覆盖优先级） |
| E5 | 手臂"软"是分档配置，且重力补偿按档开关 | `animation_player.yaml` · `idle/animation/planner/hold/rigid` 五档 + `gravity_comp` | S |
| E6 | `DAMPING_DEFAULT` 是终端安全态 | `action_ruler.yaml` · `DAMPING_DEFAULT.next_actions: [PASSIVE_DEFAULT]`；`action_state.yaml` · `estimator.secure_action` | S |
| E7 | 300 = 策略 100 Hz + 动画 250 Hz | `action_setting.yaml` · `BIPED_LOCOMOTION_WBC` 两个 `runners`，`period_ms 10 / 4` | S |
| E8 | 策略输入只有 49 维观测 + 10 帧历史，输出 14 维 | `raw/t1/qd1_t2d0/model_io.txt`（`observations[1,49]`、`observation_history[1,490]`、`action[1,14]`） | S |
| E9 | 观测里命令是 46..48 三维 | `bi_wbc_run.yaml` · `WalkConfig.obs_index.command: 46` | S |
| E10 | 四足行走不能直接到 300 | `action_ruler.yaml` · `QUADRUPED_LOCOMOTION_DEFAULT.next_actions` 不含 300；只含 10/11 | S |
| E11 | 10/11 变形后允许落位 300 | `action_ruler.yaml` · `QUADRUPED_TO_BIPED(_ROTATE).next_actions: [BIPED_LOCOMOTION_WBC, ...]` | S |
| E12 | 300 没有"回站立"直连边 | `action_ruler.yaml` · `BIPED_LOCOMOTION_WBC.next_actions` 中 `BIPED_STAND_DEFAULT` 被注释 | S |
| E13 | 牵手态是 5 态 + `is_held` | `raw/t1/interfaces/msg/McHandHeldState.idl`（另有 `common/McHandHeldState.msg`） | S |
| E14 | 未知时 `is_held=false` | 同 E13 注释："False when neither hand is held or the combined state is unknown" | S |
| E15 | 9 条任务规则被 held 门控 | `raw/t1/task_engine/rule/*.yaml` · `allow_held_state: false`（posture/whole_body/upper_body/rc_joystick/rc_gyro/motion_teach/motion_record/motion_playback/factory_reset） | S |
| E16 | 跟随任务不被 held 门控 | `raw/t1/task_engine/rule/follow.yaml`：**无** `allow_held_state`；有 battery 6%、odom require_trusted、目标丢失防抖 | S |
| E17 | 被牵时拒绝动作有专用原因码 | `raw/t1/interfaces/srv/AmRequest.srv` · `REASON_HELD = 41` | S |
| E18 | roll 死区 0.17 rad；转向 PD 增益 10/20、kd 0.4/0.8 | `arm_drag.deadzone_roll_threshold`、`yaw_vel_scale_kp/kd` | S（数值）/ M（公式） |
| E19 | 前进确认 100 帧、推背确认 50 帧、转圈确认 5 帧 | `forward_confirm_frames`、`push_confirm_frames`、`yaw_spin_confirm_frames` | S |
| E20 | 手端前向位移阈值以 **BASELINK z / m** 计 | `bi_gimbal.yaml` 注释："手端前向位移阈值（BASELINK z, m）"；`forward_pos_threshold` | S |
| E21 | 拖拽通道有独立钳位，且 gimbal 比正常速度更窄 | `command_scales.drag_x/drag_yaw` vs `cmd_x/cmd_y` | S |
| E22 | held 上报有计数门槛（10 帧） | `qd1_t1d5/rl/bi_wbc_run.yaml` · `drag_count_threshold: 10` 注释"计数大于该值才上报" | S（数值）/ M（上报链路） |
| E23 | 推背/轮端有一整套回路 | `wheel_*`、`push_*` 字段（值见 02） | M（语义） |
| E24 | 拖拽指令最终只是速度指令，策略不知道手 | E8 + E9 + `command_scales` | S（结构性） |
| E25 | gimbal 复用 WBC 的 `ArmDragLocomotion`，牵引手柔顺、相机手刚性 | `bi_gimbal.yaml` 两段注释 + `arm_compliance:` | S（文字）/ M（实现） |
| E26 | 视觉失败时身体接管（现象） | `t1-pro-orin-rk-analysis.md` UC3 时间线（二手） | W |
| E27 | 牵手时仍在跌倒监控名单里 | `security_guard.yaml` · `monitored_actions_biped` 含 `BIPED_LOCOMOTION_WBC`、`BIPED_GIMBAL` | S |
| E28 | 跌倒兜底目标是阻尼（实测 11 ms） | 同 E6 + 安全文档实测记录 | S（配置）/ W（11 ms 为文档实测） |
| E29 | 真机进 300 的路径：14:35:13.982 11 → 14:35:18.822 300 | `raw/logs/uc3_state_timeline.csv` / `uc3_enter_biped.log` | S（实测） |
| E30 | held 首次 true 在 14:37:24.205，动作仍为 300 | 同上 | S（实测） |
| E31 | held 在 300 内多次 on/off（24.4/15.2/38.5 s…），动作始终不变 | 同上 | S（实测） |
| E32 | 牵手期间 `hand_held=3`（RIGHT_HELD_ONLY）、`form=2` | 同上 | S（实测） |
| E33 | `[FLW] state` 在 held 置位时从 0→1（目标丢失） | `raw/logs/uc3_follow_window.log` | S（实测） |
| E34 | Q2B/变身 runner 有重力包络、`max_cycle_time`、`stand_actions` | `raw/t1/qd1_t2d0/rl/quad_to_bi_rotate_run.yaml`、`bi_to_quad_run.yaml` | S |

---

## 反证清单（什么会推翻我们的假设）

| 假设 | 反证条件 | 怎么查 |
|---|---|---|
| H1：`arm_drag` 是 runner 内部能力 | 若在 `action_ruler` 或 `McAction` 中找到"牵手"枚举/动作 | 全文搜 `HELD/DRAG`；`McAction` 枚举清单 |
| H2：检测只用关节角/位移 | 若配置或日志中出现力矩/电流阈值字段（非 `push_*`） | 搜 `torque/current/force`；看 `arm_drag` 全字段 |
| H3：速度是解算出来的（非外部速度源） | 若 UC3 日志显示 `input_source=interaction/pnc` 且 `velocity` 非零 | 查 `/aima/mc/locomotion/velocity` 与 `input_source` 日志 |
| H4：拖拽覆盖外部速度 | 若同拍 `command` 等于外部速度而非拖拽解算值 | 同拍对比日志（E1 实验） |
| H5：`DAMPING` 不参与 | 若牵手时 `action_info.current_action=2` | 状态流日志 |
| H6：`held_state` 与拖拽同源 | 若出现"held=true 但 vx=0 很久"或"vx>0 但 held=false" | 同拍对比（E6 实验） |

> 以上任一条被证实，都要在报告里明确写"原假设被推翻/修正"，并给出新解释。
