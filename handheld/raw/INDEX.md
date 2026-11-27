# raw 索引：每个文件是干什么的

> 先看 `packs/`；需要原文/行号时回到这里。
> 标记：**证据** = 配置/接口可直接核对；**二手** = 内部文档；**派生** = 由前两者生成。

## 策略/runner 配置（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/qd1_t1d5/rl/bi_gimbal.yaml` | 6 KB | 见下方“按问题查” |
| `raw/t1/qd1_t1d5/rl/bi_wbc_run.yaml` | 6 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/bi_gimbal.yaml` | 6 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/bi_loco_animation.yaml` | 4 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/bi_to_quad_rotate_run.yaml` | 4 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/bi_to_quad_run.yaml` | 4 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/bi_walk.yaml` | 4 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/bi_wbc_dance.yaml` | 5 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/bi_wbc_run.yaml` | 7 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/quad_to_bi_rotate_run.yaml` | 4 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/quad_to_bi_run.yaml` | 4 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/rl/quad_walk.yaml` | 4 KB | 见下方“按问题查” |

## 经典控制器配置（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/qd1_t2d0/classic/animation_player.yaml` | 23 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/classic/biped_record_upper.yaml` | 1 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/classic/biped_stand_default.yaml` | 1 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/classic/custom_upper.yaml` | 0 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/classic/damping_default.yaml` | 1 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/classic/quad_stand_default.yaml` | 1 KB | 见下方“按问题查” |

## 系统/动作图/安全/状态（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/qd1_t2d0/action_ruler.yaml` | 13 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/action_setting.yaml` | 13 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/action_state.yaml` | 5 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/mc_T1.yaml` | 8 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/mc_T1.yaml.dump` | 9 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/motion_list.yaml` | 39 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/remote_controller_config/operation_config.yaml` | 2 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/robot_model.yaml` | 6 KB | 见下方“按问题查” |
| `raw/t1/qd1_t2d0/security_guard.yaml` | 3 KB | 见下方“按问题查” |

## 设备/MIT 参数（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/hardware/device_manager_t1_v2d0.yaml` | 9 KB | 见下方“按问题查” |

## URDF（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/qd1_t2d0/urdf/qd1.urdf` | 20 KB | 见下方“按问题查” |

## 接口定义（IDL/msg/srv）（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/interfaces/AmRequest.srv` | 7 KB | 见下方“按问题查” |
| `raw/t1/interfaces/InteractionState.msg` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/JointCommand.idl` | 0 KB | 见下方“按问题查” |
| `raw/t1/interfaces/JointState.idl` | 0 KB | 见下方“按问题查” |
| `raw/t1/interfaces/MC_INTERFACE_CATALOG.md` | 27 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McAction.idl` | 10 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McActionInfo.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McActionStatus.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McCommonState.msg` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McControlArea.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McHandHeldState.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McHandHeldState.msg` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McInputSource.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McLocomotionVelocity.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McMotionStatus.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McMotionType.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McPlayerState.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/McPresetMotion.idl` | 4 KB | 见下方“按问题查” |
| `raw/t1/interfaces/SetMcAction.srv` | 0 KB | 见下方“按问题查” |
| `raw/t1/interfaces/SetMcInputSource.idl` | 1 KB | 见下方“按问题查” |
| `raw/t1/interfaces/SetMcInputSource.srv` | 0 KB | 见下方“按问题查” |
| `raw/t1/interfaces/SetMcInputSource_Request.msg` | 0 KB | 见下方“按问题查” |

## 任务规则（门控）（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/task_engine/rule/factory_reset.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/follow.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/idle.yaml` | 4 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/interaction.yaml` | 2 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/motion_playback.yaml` | 2 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/motion_record.yaml` | 2 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/motion_teach.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/move.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/navigation.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/posture.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/rc_gyro.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/rc_joystick.yaml` | 2 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/upper_body.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/rule/whole_body.yaml` | 3 KB | 见下方“按问题查” |

## 任务引擎映射/动作转移（证据）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/t1/task_engine/action_manager.yaml` | 3 KB | 见下方“按问题查” |
| `raw/t1/task_engine/actions_transfer.yaml` | 11 KB | 见下方“按问题查” |
| `raw/t1/task_engine/t1_cfg.yaml` | 9 KB | 见下方“按问题查” |
| `raw/t1/task_engine/t1_groups.yaml` | 29 KB | 见下方“按问题查” |
| `raw/t1/task_engine/task_rules.yaml` | 12 KB | 见下方“按问题查” |

## 派生的动作/模型/观测清单（派生）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/model_list/action_execution_runner.csv` | 8 KB | 见下方“按问题查” |
| `raw/model_list/model_network_stats.md` | 14 KB | 见下方“按问题查” |
| `raw/model_list/motion_list.md` | 2 KB | 见下方“按问题查” |
| `raw/model_list/obs_layout.csv` | 5 KB | 见下方“按问题查” |
| `raw/model_list/rl_runner_weights.csv` | 5 KB | 见下方“按问题查” |
| `raw/model_list/rule_graph_stats.md` | 2 KB | 见下方“按问题查” |

## 完整内部文档（二手，冲突时以配置为准）（二手）

| 文件 | 大小 | 用来回答 |
|---|---|---|
| `raw/docs_full/collie_arch_spec.md` | 33 KB | 见下方“按问题查” |
| `raw/docs_full/t1_4plus1.md` | 110 KB | 见下方“按问题查” |
| `raw/docs_full/t1_architecture.md` | 204 KB | 见下方“按问题查” |
| `raw/docs_full/t1_mc_decomposition.md` | 42 KB | 见下方“按问题查” |
| `raw/docs_full/t1_safety.md` | 24 KB | 见下方“按问题查” |
| `raw/docs_full/t1_three_links.md` | 47 KB | 见下方“按问题查” |
| `raw/docs_full/t1_transform.md` | 35 KB | 见下方“按问题查” |

## 按问题查

| 问题 | 先看 | 再看 |
|---|---|---|
| Q1 判定是不是新 runner/换 kp/kd | `packs/01`（arm_drag 全字段、bi_walk/quad_walk 对照） | `raw/t1/qd1_t2d0/rl/bi_wbc_run.yaml`、`bi_walk.yaml`、`quad_walk.yaml`、`model_io.txt`、`McAction.idl` |
| Q1 held 与拖拽是否同源 | `packs/07`（真机 held 时间线） | `raw/t1/interfaces/McHandHeldState.idl`、`bi_wbc_run.yaml · drag_count_threshold` |
| Q2 准入：怎么到 300 | `packs/02`（action_ruler/action_setting） | `raw/t1/qd1_t2d0/rl/quad_to_bi_rotate_run.yaml`、`packs/06` |
| Q2 进入/保持/准出 | `packs/07`（动作不变、held 多次 on/off） | `raw/t1/qd1_t2d0/classic/animation_player.yaml`、`security_guard.yaml` |
| Q2 仲裁 | `packs/03`（SetMcInputSource） | `raw/t1/qd1_t2d0/mc_T1.yaml`、`raw/t1/interfaces/McInputSource.idl` |
| Q3 解算 | `packs/01`（arm_drag 数值） | `packs/05`（obs 46..48、49 维）、`raw/model_list/obs_layout.csv` |
| Q3 关节限位/手感 | `packs/05`（robot_model/URDF） | `raw/t1/qd1_t2d0/robot_model.yaml`、`urdf/qd1.urdf` |

## 派生文件

| 文件 | 怎么来的 |
|---|---|
| `raw/model_io.txt` | 用 `onnx` 读 `wbcterrain2026092602.onnx` 的输入输出形状 |
| `raw/logs/uc3_state_timeline.csv` | 解析 `c2_events.log` 的 `[IST]/[MCA]/[FLW]` 行，按状态变化去重 |
| `raw/logs/*.log` | 按时间窗截取的原始日志行 |
| `raw/docs/*.md` | 从内部文档按章节摘录 |
| `raw/docs_full/*.md` | 内部文档全文（二手） |

