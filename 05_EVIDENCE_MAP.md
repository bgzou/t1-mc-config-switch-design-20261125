# 05 · 证据地图（论断 → 文件 → 强度）

**规则**：正文引用证据时用 `[E-xx]`；每个 `[E-xx]` 必须能在此表找到文件与位置。T1 数字只作对标，不作 Collie 标定值。

| ID | 论断 | 证据（仓库路径） | 位置/字段 | 强度 |
|---|---|---|---|---|
| E-01 | T1 有 52 个换乘节点、197 条有向边、3 个全局出口、24 个 skip | `raw/t1/config/action_ruler.yaml`；`raw/t1/model_lists/rule-graph-stats.md` | `common_rules` / `action_rules`；统计表 | 事实 |
| E-02 | T1 有 58 个动作、62 个执行组、62 个 runner；每组恒 1 runner | `raw/t1/config/action_setting.yaml`；`raw/t1/model_lists/action-execution-runner.md` | 全表 | 事实 |
| E-03 | T1 有 42 个 RL 动作条目、34 份不同 ONNX 权重、48 份 RL 配置 | `raw/t1/model_lists/rl-runner-weights.csv`；`raw/t1/config/rl/` | 行数/文件名 | 事实 |
| E-04 | T1 动作状态分 6 组：STARTING/STABLE/MOVING/SAFE/SPECIAL/TEST | `raw/t1/config/action_state.yaml` | `state_actions` | 事实 |
| E-05 | 默认安全动作是 `DAMPING_DEFAULT`；跌倒/腾空检查 | `raw/t1/config/action_state.yaml` | `estimator` | 事实 |
| E-06 | T1 变身是 6 条独立 RL 过渡策略，不是模型插值 | `raw/t1/config/action_setting.yaml`；`raw/t1/config/rl/quad_to_bi_*.yaml`、`bi_to_quad_*.yaml`；`raw/docs/t1_morphing_and_switch.md` | 动作 10/11/12/20/21/22 | 事实 |
| E-07 | Q2B/B2Q 观测含 phase/q_ref，不接 command；obs 51/54/47/52 | `raw/t1/config/rl/quad_to_bi_run.yaml`、`quad_to_bi_rotate_run.yaml`、`quad_to_bi_frontflip_run.yaml`、`bi_to_quad_run.yaml`；`raw/t1/model_lists/obs-layout.csv` | `obs_nums`/`obs_index` | 事实 |
| E-08 | 变身相位由 `start_time/flip_time/rotate_time` + `exit_timeout` 定义；前空翻用 `auto_switch_timeout` | `raw/t1/config/rl/quad_to_bi*.yaml`、`bi_to_quad*.yaml` | `WalkConfig.custom` / `exit_timeout` | 事实 |
| E-09 | 变身专用 `gravity_guard`：参考曲线、30°/40°、连续 2 帧 | `raw/t1/config/rl/quad_to_bi_run.yaml` 等；`raw/t1/transitions/gravity/*.csv` | `gravity_guard` | 事实 |
| E-10 | Q2B 落位到 WBC，B2Q 落位到四足行走；时长 3.0–4.8 s | `raw/docs/t1_morphing_and_switch.md` | §5.3/§6 | 实测/配置 |
| E-11 | 落位靠末态对齐 + 目标侧 0.15–0.2 s 平滑 + 1 s 里程计静默；PD 增益硬跳变 | `raw/t1/config/rl/bi_wbc_run.yaml`、`quad_walk.yaml`；`raw/docs/t1_morphing_and_switch.md` | `transition_frames`/`odom_disable_after_switch_s`/`transition_duration` | 配置/推断 |
| E-12 | 旧策略退出判据分散：WBC 等速度归零 20–100 步；四足行走冻步态/等脚落稳；位控位置差+超时 | `raw/t1/config/rl/bi_wbc_run.yaml`、`quad_step.yaml`、`raw/t1/config/classic/*.yaml`；`raw/docs/t1_three_links.md` E3 | `exit_wait_*`/`step_gate`/`exit_timeout` | 事实 |
| E-13 | T1 状态 `status=100` 运行 / `200` 切换；`switch_ready` 是接新动作的权威 | `raw/t1/interfaces/McCommonState.msg`、`McActionStatus.msg`；`raw/docs/t1_architecture_deep_dive.md` §9.4 | 字段/状态表 | 文档/实测 |
| E-14 | 安全八层；`cmd_guard` 200 ms、反馈 10 ms、跌倒 50 ms 检查、60°/3 帧、6 rad/s+48°/3 帧、脚 FK 20 帧 | `raw/t1/config/security_guard.yaml`；`raw/docs/t1_safety_design.md` | 全文件 | 事实 |
| E-15 | 跌倒判定到阻尼切换实测 11 ms；急停是系统层杀进程，不是换动作 | `raw/docs/t1_mc_decomposition.md` §5.3；`raw/docs/t1_architecture_deep_dive.md` §9.5 | 时延表/模式表 | 实测/文档 |
| E-16 | 速度源 7 个 + 1 硬编码；优先级 70–100；TTL 1000 ms；零速不能抢（安全源除外） | `raw/t1/config/mc_T1.yaml`；`raw/docs/t1_architecture_deep_dive.md` 第 8 章 | `InputManager` | 配置/推断 |
| E-17 | 关节发布 200 Hz；T1 策略 100 Hz（NPZ 50 Hz）；HAL/PD 1 kHz | `raw/t1/config/mc_T1.yaml`；`raw/t1/config/rl/*.yaml`；`raw/docs/adr25_50hz.md` | `frequency`/`dt` | 配置 |
| E-18 | T1 加新动作需改 4 处：枚举、换乘图、执行组、runner 配置 | `raw/docs/t1_architecture_deep_dive.md` §9.2 | 列表 | 事实 |
| E-19 | Runner 缓存键 `name|cfg_path|period`；同名不同周期会建两个实例 | `raw/docs/t1_mc_decomposition.md` §4.2 | 表 | 日志/推断 |
| E-20 | 动画资源预载 78 个 CSV 耗时 1.729 s | `raw/docs/t1_architecture_deep_dive.md` §9.3 | 表 | 实测 |
| E-21 | `roboparty_deploy` 是 ROS2 Humble + C++17 + yaml-cpp + ONNX Runtime | `raw/roboparty/README_CN.md` | 概述/环境 | 事实 |
| E-22 | `robot.yaml` 有 23 电机、4 路 CAN、IMU 921600、kp/kd/方向/零偏/闭环映射 | `raw/roboparty/robot.yaml` | 全文件 | 事实 |
| E-23 | `default.yaml`：23 关节、dt 0.004、decimation 5、frame_stack 10、单模型 | `raw/roboparty/configs/default.yaml` | 全文件 | 事实 |
| E-24 | `beyondmimic.yaml`：4 模型 + 4 motion；LB 切策略、RB 选 motion | `raw/roboparty/configs/beyondmimic.yaml`；`raw/roboparty/README_CN.md` | `model_names`/手柄说明 | 事实 |
| E-25 | 运行时切换是"暂停推理 → 换 active_policy_idx_ → reset → 恢复"，无过渡 | `raw/roboparty/src/ros_interface.cpp` L355-408 | `subs_joy_callback` | 事实 |
| E-26 | `setup_model` 只支持单输入 ONNX；输出缓冲按 joint_num | `raw/roboparty/src/inference_node.cpp` L72-139 | `setup_model` | 事实 |
| E-27 | 控制线程 dt=0.004（250 Hz），推理线程 dt*decimation=0.02（50 Hz）；`act_alpha` 低通 | `raw/roboparty/src/inference_node.cpp` L266-332、L252-264 | `control`/`inference`/`apply_action` | 事实 |
| E-28 | 经典动作播放是独立进程 `motion_player.py`，200 Hz，直接 `apply_action(positions)` | `raw/roboparty/scripts/motion_player.py` | 全文件 | 事实 |
| E-29 | `apply_action` 支持 p/v/kp/kd/tau，但控制路径主要用位置 | `raw/roboparty/include/robot_interface.hpp` L50-54；`raw/roboparty/src/inference_node.cpp` L252-264 | 签名/调用 | 事实 |
| E-30 | 观测源支持 cmd_vel/ang_vel/gravity_b/dof_pos/dof_vel/last_action/interrupt/perception/motion_pos/motion_vel/latent；支持稀疏 tap | `raw/roboparty/src/obs_manager.cpp`；`raw/roboparty/README_CN.md` | 注册表/稀疏历史节 | 事实 |
| E-31 | 当前 Collie 基线：50 Hz 策略 / 50 Hz Worker / 200 Hz RT / ZOH / 15/20 ms / 25 ms TTL | `raw/docs/adr25_50hz.md` | §2/§3 | 建议 |
| E-32 | 当前 Collie 基线：一个关节出口、RunnerManifest/ActionBundle、显式图、切换状态机、安全独立 | `raw/docs/current_runner_master.md`；`raw/docs/current_runner_interface.md` | 全文 | 建议 |
| E-33 | Collie 需求：四轮滑行 + 后双轮自平衡直立；Q→B/B→Q；站立讲解/合影 | `raw/docs/requirements_scenarios.txt`；`raw/docs/mc_external_interfaces.md` | UC-04/11/13/14、IR-A/C | 文档 |
| E-34 | Collie 拓扑/双足定义/权重/标定未冻结 | `raw/docs/current_runner_master.md` §12；`06_OPEN_QUESTIONS.md` | 未决表 | 待定 |
| E-35 | T1 的 `transition_frames: 15` 注释写 1 s，按 dt=0.01 实际 0.15 s；B2Q 末态残差 1.6°/5.3° | `raw/docs/t1_morphing_and_switch.md` §6.3/§8 | 表 | 事实/推断 |

---

## 使用规则

- 正文引用时写 `[E-07]`，并在括号里给文件路径；不要只写"根据 T1 配置"。
- 如果证据是推断，标 `[推断]`；如果是建议，标 `[建议]`；未冻结写 `[待定]`。
- 不要把 T1 的数字写成 Collie 的标定值；不要把 `roboparty_deploy` 的 RPO 23 关节与 T1 14 动作关节混为一谈。
- 如果 GPT 发现本表与原文冲突，以原文为准，并在正文指出冲突。
