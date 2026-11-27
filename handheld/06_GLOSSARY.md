# 06 · 术语表

| 术语 | 含义 | 备注 |
|---|---|---|
| **T1 / qd1_t2d0 / qd1_t1d5** | 启元 T1 Pro 及其两个配置版本 | `qd1_t2d0` 是当前主配置；`t1d5` 是旧机型，用于对比字段漂移 |
| **四足形态 / 双足形态** | 前腿当腿（四足）或前腿当手臂（双足） | 变形动作 10/11/12（Q→B）、20/21/22（B→Q） |
| **300 / `BIPED_LOCOMOTION_WBC`** | 双足全身控制动作 | 100 Hz 策略 + 250 Hz 上肢动画组 |
| **执行组（runner group）** | 一个周期线程 + 一个 runner 配置 | `action_setting.yaml` 定义 |
| **Runner** | 一个策略实例（模型 + 前后处理 + 增益 + 退出判据） | 配置在 `rl/*.yaml` |
| **Action** | 对外可请求的动作（`SetMcAction`） | 与 runner 不是一一对应 |
| **`action_ruler.yaml`** | 动作迁移图：谁能到谁 | 含"全局出口"与 `skip_actions` |
| **`action_setting.yaml`** | 动作 → 执行组/周期/优先级 | 一个动作可挂多组 |
| **`action_state.yaml`** | 状态分组、安全动作、估算器 | `estimator.secure_action` |
| **`arm_drag` / `ArmDragLocomotion`** | 手臂拖拽检测与速度生成 | 只有配置，没有源码 |
| **`arm_compliance`** | gimbal 的牵引手柔顺段 | 把牵引手设为"重力补偿浮动" |
| **MIT 五元组** | 关节指令 `(p, v, t_ff, kp, kd)` | 驱动器端 `τ = t_ff + kp·Δp + kd·Δv` |
| **`kp` / `kd`** | 关节刚度 / 阻尼 | 单位 N·m/rad、N·m·s/rad |
| **重力补偿 `gravity_scale`** | 重力前馈的缩放（0.6 = 只补 60%） | `<1` 是"略欠补，避免上飘" |
| **`clip_tau`** | 只限 PD 项的力矩上限 | 重力前馈不受限 |
| **`BASELINK`** | T1 躯干坐标系 | **x 向上、z 向前后** |
| **FK** | 正运动学：由关节角算末端位姿 | 手端位移需要它 |
| **`held_state`** | 牵手态：5 态 + `is_held` | 50 Hz 广播；未知≠没牵 |
| **`drag_active`** | （假设名）runner 内部"拖拽生效" | 与 `held_state` 是否同源未知 |
| **`REASON_HELD`** | `AmRequest` 拒绝原因 41 | "机器人被牵手中" |
| **`DAMPING_DEFAULT`(2)** | 全身 `kp=0` 的阻尼急停 | 终端态，只能回 PASSIVE |
| **`PASSIVE_DEFAULT`(1)** | 零力矩 | 阻尼的唯一出口 |
| **死区 / deadzone** | 小于阈值不响应 | roll 0.17 rad |
| **确认帧 / confirm frames** | 连续满足 N 帧才动作 | 100 Hz 下 100 帧 = 1 s |
| **滞回 / hysteresis** | 进入与保持用不同阈值 | 是否有，需验证 |
| **钳位 / clamp** | 输出上下限 | `drag_x`、`drag_yaw` |
| **斜坡 / rate limit** | 加速度限幅 | `acc_x`、`acc_yaw` |
| **TTL / `cmd_guard`** | 指令过期清零 | 200 ms |
| **导纳 / admittance** | 力 → 运动（此处是力 → 速度） | 与阻抗（运动 → 力）相对 |
| **阻抗 / impedance** | 位移 → 力 | 手臂软弹簧即阻抗 |
| **推背** | 从背后推机器人 | `push_*` 通道 |
| **视觉跟随** | 感知 → `velocity` → 输入源仲裁 | 与力导引并行 |
| **力导引** | 人通过手带动机器人 | 本文主题 |
| **obs / `command`** | 49 维观测 / 其中 46..48 是速度命令 | ONNX 输入 |
| **`SetMcAction` / `SetMcInputSource`** | 切动作 / 注册速度源 | 两个不同通道 |
