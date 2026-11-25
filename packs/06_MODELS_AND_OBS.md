# 06_MODELS_AND_OBS · T1 模型/动作/观测清单

> 自动生成的阅读包：把多个原始文件按主题拼接，便于一次读多份。
> 引用行号/上下文时请回到 `raw/` 下的同名文件；`FILE:` 行给出原始路径。
> 文件数：7

---

## FILE: raw/t1/model_lists/action-execution-runner.md

- bytes: 8789

```markdown
# 动作 → 执行组 → runner（真机全量 62 条）

> 来源：`Z:\primebot-t1\robot_rk\software\mc\bin\cfg\robot\qd1_t2d0\action_setting.yaml`
> 动作 58 个（含 1 个常驻安全任务）；执行组 62 个；runner 62 个。
> **每组恒为 1 个 runner**（62/62），格式上 `runners` 是列表，可挂多个。

| 动作 | 组 | runner | 类型 | 周期(ms) | 优先级 | 配置 | 权重 | obs | act |
|---|---|---|---|---|---|---|---|---|---|
| BIPED_CUSTOM_UPPER | 0 | `rl_bi_loco_wbc` | RL策略 | 10 | 80 | `./rl/bi_wbc_run.yaml` | wbcterrain2026092602.onnx | 49 | 14 |
| BIPED_CUSTOM_UPPER | 1 | `custom_upper` | 经典控制 | 10 | 80 | `./classic/custom_upper.yaml` | — | — | — |
| BIPED_GIMBAL | 0 | `rl_bi_gimbal` | RL策略 | 10 |  | `./rl/bi_gimbal.yaml` | wbc2026071201.onnx | 49 | 14 |
| BIPED_LINGCHUANG_MIMIC | 0 | `rl_bi_lingchuang_mimic` | RL策略 | 10 | 80 | `./rl/bi_lingchuang_mimic.yaml` | — | 264 | 14 |
| BIPED_LOCOMOTION_ANIMATION | 0 | `rl_bi_loco_animation` | RL策略 | 10 | 80 | `./rl/bi_loco_animation.yaml` | t1_bi_wbc_pitch0522.onnx | 51 | 14 |
| BIPED_LOCOMOTION_ANIMATION | 1 | `animation_player` | 经典控制 | 2 | 80 | `./classic/animation_player.yaml` | — | — | — |
| BIPED_LOCOMOTION_BACKBEND | 0 | `rl_bi_backbend` | RL策略 | 10 | 80 | `./rl/bi_backbend_run.yaml` | actor_critic_20251110.onnx | 50 | 14 |
| BIPED_LOCOMOTION_DANCE | 0 | `rl_bi_dance` | RL策略 | 10 | 80 | `./rl/bi_dance.yaml` | bi_dance_liuxingwu_acc_1_model_12750.onnx | 80 | 14 |
| BIPED_LOCOMOTION_DEFAULT | 0 | `rl_bi_loco` | RL策略 | 10 | 80 | `./rl/bi_walk.yaml` | lift0514_swing.onnx | 49 | 14 |
| BIPED_LOCOMOTION_MOONWALK | 0 | `rl_bi_moonwalk` | RL策略 | 10 | 80 | `./rl/bi_moonwalk.yaml` | t1_bi_moonwalk_v2_0807.onnx | 51 | 14 |
| BIPED_LOCOMOTION_ROTATE_LOCAL | 0 | `rl_bi_rotate_local` | RL策略 | 10 | 80 | `./rl/bi_rotate_local.yaml` | t1_bi_wbc_v1.0_1228.onnx | 57 | 14 |
| BIPED_LOCOMOTION_RUN | 0 | `rl_bi_loco_run` | RL策略 | 10 | 80 | `./rl/bi_run.yaml` | t2_bifast_0730.onnx | 49 | 14 |
| BIPED_LOCOMOTION_TERRAIN | 0 | `rl_bi_terrain` | RL策略 | 10 | 80 | `./rl/bi_walk_terrain.yaml` | terrain0313.onnx | 49 | 14 |
| BIPED_LOCOMOTION_WBC | 0 | `rl_bi_loco_wbc` | RL策略 | 10 | 80 | `./rl/bi_wbc_run.yaml` | wbcterrain2026092602.onnx | 49 | 14 |
| BIPED_LOCOMOTION_WBC | 1 | `animation_player` | 经典控制 | 4 | 80 | `./classic/animation_player.yaml` | — | — | — |
| BIPED_LOCOMOTION_WBCDANCE | 0 | `rl_bi_loco_wbcdance` | RL策略 | 10 | 80 | `./rl/bi_wbc_dance.yaml` | biped_rotation0711.onnx | 49 | 14 |
| BIPED_MIMIC | 0 | `rl_bi_mimic` | RL策略 | 10 | 80 | `./rl/bi_mimic.yaml` | t1_bi_wbc_pitch0522.onnx | 51 | 14 |
| BIPED_NPZ_MIMIC | 0 | `rl_bi_npz_mimic` | RL策略 | 20 | 80 | `./rl/bi_npz_mimic.yaml` | — | 83 | 14 |
| BIPED_RECORD_UPPER | 0 | `rl_bi_loco_wbc` | RL策略 | 10 | 80 | `./rl/bi_wbc_run.yaml` | wbcterrain2026092602.onnx | 49 | 14 |
| BIPED_RECORD_UPPER | 1 | `biped_record` | 经典控制 | 10 | 80 | `./classic/biped_record_upper.yaml` | — | — | — |
| BIPED_RECOVERY | 0 | `rl_bi_recovery` | RL策略 | 10 | 80 | `./rl/bi_recovery.yaml` | t15_bi_recovery_v1.2_0402.onnx | 47 | 14 |
| BIPED_SPLIT | 0 | `rl_bi_split` | RL策略 | 10 | 80 | `./rl/bi_split.yaml` | t1_bi_split_v1.0_0307_15mm.onnx | 50 | 14 |
| BIPED_STAND_DEFAULT | 0 | `biped_stand` | 经典控制 | 1 | 80 | `./classic/biped_stand_default.yaml` | — | — | — |
| BIPED_TO_QUADRUPED | 0 | `rl_bi_to_quad` | RL策略 | 10 | 80 | `./rl/bi_to_quad_run.yaml` | t2_b2q_norm_v1.0_0601.onnx | 51 | 14 |
| BIPED_TO_QUADRUPED_FRONTFLIP | 0 | `rl_bi_to_quad_frontflip` | RL策略 | 10 | 80 | `./rl/bi_to_quad_frontflip_run.yaml` | t1_flip2quad_v1.0_0307_40k.onnx | 52 | 14 |
| BIPED_TO_QUADRUPED_ROTATE | 0 | `rl_bi_to_quad_rotate` | RL策略 | 10 | 80 | `./rl/bi_to_quad_rotate_run.yaml` | t15_bi2quad_rotate_v1.1_terrain.onnx | 54 | 14 |
| BIPED_YUZURU | 0 | `rl_bi_yuzuru` | RL策略 | 10 | 80 | `./rl/bi_yuzuru.yaml` | t1_bi_yuzuru_v1.0_0123.onnx | 56 | 14 |
| DAMPING_DEFAULT | 0 | `damping_default_t1` | 经典控制 | 2 | 80 | `./classic/damping_default.yaml` | — | — | — |
| PASSIVE_DEFAULT | 0 | `passive_default` | 内置 | 10 | 80 | `` | — | — | — |
| QUADRUPED_BODY_ADJUST_DEFAULT | 0 | `rl_quad_body_adjust` | RL策略 | 10 | 80 | `./rl/quad_body_adjust.yaml` | t2_quad_twist_charge_pos_kp40.onnx | 52 | 14 |
| QUADRUPED_CROUCH_DEFAULT | 0 | `quad_crouch` | 经典控制 | 1 | 80 | `./classic/quad_crouch.yaml` | — | — | — |
| QUADRUPED_GET_DOWN_DEFAULT | 0 | `quad_get_down` | 经典控制 | 1 | 80 | `./classic/quad_get_down_default.yaml` | — | — | — |
| QUADRUPED_LOCOMOTION_BACKFLIP | 0 | `rl_quad_backflip` | RL策略 | 10 | 80 | `./rl/quad_backflip_run.yaml` | actor_critic_rightfirst_backflip.onnx | 52 | 14 |
| QUADRUPED_LOCOMOTION_BIONIC | 0 | `rl_quad_twist` | RL策略 | 10 | 80 | `./rl/quad_walk_twist.yaml` | t2_quad_twist_0803.onnx | 50 | 14 |
| QUADRUPED_LOCOMOTION_DANCE | 0 | `rl_quad_dance` | RL策略 | 10 | 80 | `./rl/quad_walk_dance.yaml` | t2_quad_twist_xy_v1.0_0708.onnx | 52 | 14 |
| QUADRUPED_LOCOMOTION_DEFAULT | 0 | `rl_quad_loco` | RL策略 | 10 | 80 | `./rl/quad_walk.yaml` | t2_quad_walk_0902.onnx | 57 | 14 |
| QUADRUPED_LOCOMOTION_FRONTFLIP | 0 | `rl_quad_frontflip` | RL策略 | 10 | 80 | `./rl/quad_frontflip_run.yaml` | t2_quad_frontflip_0703.onnx | 52 | 14 |
| QUADRUPED_LOCOMOTION_HANDSHAKE | 0 | `quad_handshake` | 经典控制 | 1 | 80 | `./classic/quad_handshake_default.yaml` | — | — | — |
| QUADRUPED_LOCOMOTION_JUMP | 0 | `rl_quad_jump` | RL策略 | 10 | 80 | `./rl/quad_jump_run.yaml` | t15_quad_jump_platform.onnx | 47 | 14 |
| QUADRUPED_LOCOMOTION_PLEASURE | 0 | `rl_quad_pleasure` | RL策略 | 10 | 80 | `./rl/quad_walk_pleasure.yaml` | t2_quad_twist_0803.onnx | 50 | 14 |
| QUADRUPED_LOCOMOTION_PRIDE | 0 | `rl_quad_pride` | RL策略 | 10 | 80 | `./rl/quad_walk_pride.yaml` | t2_quad_twist_0803.onnx | 50 | 14 |
| QUADRUPED_LOCOMOTION_REVERSE_DEFAULT | 0 | `rl_quad_loco_reverse` | RL策略 | 10 | 0 | `./rl/quad_walk_reverse.yaml` | t2_quad_walk_re_0907.onnx | 57 | 14 |
| QUADRUPED_LOCOMOTION_RUN | 0 | `rl_quad_loco_run` | RL策略 | 10 | 80 | `./rl/quad_run.yaml` | t2_quad_run_new_cpg.onnx | 57 | 14 |
| QUADRUPED_LOCOMOTION_STEP | 0 | `rl_quad_step` | RL策略 | 10 | 80 | `./rl/quad_step.yaml` | t2_quad_walk_lite_0713.onnx | 57 | 14 |
| QUADRUPED_LOCOMOTION_STRETCH | 0 | `rl_quad_stretch` | RL策略 | 10 | 80 | `./rl/quad_walk_stretch.yaml` | t2_quad_stretch_fix_hip_0911.onnx | 52 | 14 |
| QUADRUPED_LOCOMOTION_TERRAIN | 0 | `rl_quad_loco_terrain` | RL策略 | 10 | 80 | `./rl/quad_walk_terrain.yaml` | t2_quad_terrain_push_0926.onnx | 57 | 14 |
| QUADRUPED_MIMIC | 0 | `rl_quad_mimic` | RL策略 | 10 | 80 | `./rl/quad_mimic.yaml` | t2_quad_twist_xy_0725.onnx | 52 | 14 |
| QUADRUPED_PUSH_UP | 0 | `rl_quad_pushup` | RL策略 | 10 | 80 | `./rl/quad_pushup.yaml` | t2_quad_twist_xy_v1.0_0708.onnx | 52 | 14 |
| QUADRUPED_READY_STAND_DEFAULT | 0 | `ready_quad_stand` | 经典控制 | 1 | 80 | `./classic/ready_stand_default.yaml` | — | — | — |
| QUADRUPED_RECOVERY | 0 | `rl_quad_recovery` | RL策略 | 10 | 80 | `./rl/quad_recovery.yaml` | t1_quad_recovery_v2.0_0814.onnx | 47 | 14 |
| QUADRUPED_SIT_DOWN_DEFAULT | 0 | `quad_sit_down` | 经典控制 | 1 | 80 | `./classic/quad_sit_down_default.yaml` | — | — | — |
| QUADRUPED_STAND_DEFAULT | 0 | `quad_stand` | 经典控制 | 1 | 80 | `./classic/quad_stand_default.yaml` | — | — | — |
| QUADRUPED_STAND_REVERSE_DEFAULT | 0 | `quad_stand_reverse` | 经典控制 | 1 | 80 | `./classic/quad_stand_reverse_default.yaml` | — | — | — |
| QUADRUPED_TO_BIPED | 0 | `rl_quad_to_bi` | RL策略 | 10 | 80 | `./rl/quad_to_bi_run.yaml` | t2.2_quad2bi_norm_0708.onnx | 51 | 14 |
| QUADRUPED_TO_BIPED_FRONTFLIP | 0 | `rl_quad_to_bi_frontflip` | RL策略 | 10 | 80 | `./rl/quad_to_bi_frontflip_run.yaml` | t2_q2b_flip_0720.onnx | 47 | 14 |
| QUADRUPED_TO_BIPED_ROTATE | 0 | `rl_quad_to_bi_rotate` | RL策略 | 10 | 80 | `./rl/quad_to_bi_rotate_run.yaml` | t2_quad2bi_yaw_6837.onnx | 54 | 14 |
| QUAD_LIE_DOWN | 0 | `quad_lie_down` | 经典控制 | 2 | 80 | `./classic/quad_lie_down.yaml` | — | — | — |
| STORE_DEFAULT | 0 | `quad_get_down` | 经典控制 | 1 | 80 | `./classic/quad_get_down_default.yaml` | — | — | — |
| TEST_FOURIER | 0 | `passive_default` | 内置 | 10 | 80 | `` | — | — | — |
| TEST_PLATFORM | 0 | `passive_default` | 内置 | 10 | 80 | `` | — | — | — |
| TRAJECTORY_GENERATOR | 0 | `passive_default` | 内置 | 10 | 80 | `` | — | — | — |
| security_guard | 0 | `security_guard_t1` | 内置 | 50 | 0 | `` | — | — | — |
```


---

## FILE: raw/t1/model_lists/rl-runner-weights.csv

- bytes: 4729

```csv
﻿action,runner,cfg,period_ms,onnx,obs,act_dim,dt,stack,obs_clip,act_clip
QUADRUPED_LOCOMOTION_DEFAULT,rl_quad_loco,./rl/quad_walk.yaml,10,t2_quad_walk_0902.onnx,57,14,0.01,10,,
QUADRUPED_LOCOMOTION_REVERSE_DEFAULT,rl_quad_loco_reverse,./rl/quad_walk_reverse.yaml,10,t2_quad_walk_re_0907.onnx,57,14,0.01,10,,
QUADRUPED_LOCOMOTION_STEP,rl_quad_step,./rl/quad_step.yaml,10,t2_quad_walk_lite_0713.onnx,57,14,0.01,10,,
QUADRUPED_LOCOMOTION_RUN,rl_quad_loco_run,./rl/quad_run.yaml,10,t2_quad_run_new_cpg.onnx,57,14,0.01,10,,
QUADRUPED_LOCOMOTION_TERRAIN,rl_quad_loco_terrain,./rl/quad_walk_terrain.yaml,10,t2_quad_terrain_push_0926.onnx,57,14,0.01,10,,
QUADRUPED_LOCOMOTION_JUMP,rl_quad_jump,./rl/quad_jump_run.yaml,10,t15_quad_jump_platform.onnx,47,14,0.01,10,,
QUADRUPED_LOCOMOTION_FRONTFLIP,rl_quad_frontflip,./rl/quad_frontflip_run.yaml,10,t2_quad_frontflip_0703.onnx,52,14,0.01,10,,
QUADRUPED_LOCOMOTION_BACKFLIP,rl_quad_backflip,./rl/quad_backflip_run.yaml,10,actor_critic_rightfirst_backflip.onnx,52,14,0.01,10,,
QUADRUPED_RECOVERY,rl_quad_recovery,./rl/quad_recovery.yaml,10,t1_quad_recovery_v2.0_0814.onnx,47,14,0.01,10,,
QUADRUPED_LOCOMOTION_STRETCH,rl_quad_stretch,./rl/quad_walk_stretch.yaml,10,t2_quad_stretch_fix_hip_0911.onnx,52,14,0.01,10,,
QUADRUPED_BODY_ADJUST_DEFAULT,rl_quad_body_adjust,./rl/quad_body_adjust.yaml,10,t2_quad_twist_charge_pos_kp40.onnx,52,14,0.01,10,,
QUADRUPED_LOCOMOTION_DANCE,rl_quad_dance,./rl/quad_walk_dance.yaml,10,t2_quad_twist_xy_v1.0_0708.onnx,52,14,0.01,10,,
QUADRUPED_PUSH_UP,rl_quad_pushup,./rl/quad_pushup.yaml,10,t2_quad_twist_xy_v1.0_0708.onnx,52,14,0.01,10,,
BIPED_RECOVERY,rl_bi_recovery,./rl/bi_recovery.yaml,10,t15_bi_recovery_v1.2_0402.onnx,47,14,0.01,10,,
BIPED_LOCOMOTION_DEFAULT,rl_bi_loco,./rl/bi_walk.yaml,10,lift0514_swing.onnx,49,14,0.01,10,,
BIPED_LOCOMOTION_RUN,rl_bi_loco_run,./rl/bi_run.yaml,10,t2_bifast_0730.onnx,49,14,0.01,10,,
BIPED_LOCOMOTION_TERRAIN,rl_bi_terrain,./rl/bi_walk_terrain.yaml,10,terrain0313.onnx,49,14,0.01,10,,
BIPED_LOCOMOTION_WBC,rl_bi_loco_wbc,./rl/bi_wbc_run.yaml,10,wbcterrain2026092602.onnx,49,14,0.01,10,,
BIPED_LOCOMOTION_ANIMATION,rl_bi_loco_animation,./rl/bi_loco_animation.yaml,10,t1_bi_wbc_pitch0522.onnx,51,14,0.01,10,,
BIPED_LOCOMOTION_WBCDANCE,rl_bi_loco_wbcdance,./rl/bi_wbc_dance.yaml,10,biped_rotation0711.onnx,49,14,0.01,10,,
BIPED_MIMIC,rl_bi_mimic,./rl/bi_mimic.yaml,10,t1_bi_wbc_pitch0522.onnx,51,14,0.01,10,,
BIPED_LINGCHUANG_MIMIC,rl_bi_lingchuang_mimic,./rl/bi_lingchuang_mimic.yaml,10,,264,14,0.01,1,,
BIPED_GIMBAL,rl_bi_gimbal,./rl/bi_gimbal.yaml,10,wbc2026071201.onnx,49,14,0.01,10,,
BIPED_NPZ_MIMIC,rl_bi_npz_mimic,./rl/bi_npz_mimic.yaml,20,,83,14,0.02,1,,
QUADRUPED_TO_BIPED,rl_quad_to_bi,./rl/quad_to_bi_run.yaml,10,t2.2_quad2bi_norm_0708.onnx,51,14,0.01,10,,
QUADRUPED_TO_BIPED_ROTATE,rl_quad_to_bi_rotate,./rl/quad_to_bi_rotate_run.yaml,10,t2_quad2bi_yaw_6837.onnx,54,14,0.01,10,,
QUADRUPED_TO_BIPED_FRONTFLIP,rl_quad_to_bi_frontflip,./rl/quad_to_bi_frontflip_run.yaml,10,t2_q2b_flip_0720.onnx,47,14,0.01,10,,
QUADRUPED_LOCOMOTION_BIONIC,rl_quad_twist,./rl/quad_walk_twist.yaml,10,t2_quad_twist_0803.onnx,50,14,0.01,10,,
QUADRUPED_LOCOMOTION_PRIDE,rl_quad_pride,./rl/quad_walk_pride.yaml,10,t2_quad_twist_0803.onnx,50,14,0.01,10,,
QUADRUPED_MIMIC,rl_quad_mimic,./rl/quad_mimic.yaml,10,t2_quad_twist_xy_0725.onnx,52,14,0.01,10,,
QUADRUPED_LOCOMOTION_PLEASURE,rl_quad_pleasure,./rl/quad_walk_pleasure.yaml,10,t2_quad_twist_0803.onnx,50,14,0.01,10,,
BIPED_TO_QUADRUPED,rl_bi_to_quad,./rl/bi_to_quad_run.yaml,10,t2_b2q_norm_v1.0_0601.onnx,51,14,0.01,10,,
BIPED_YUZURU,rl_bi_yuzuru,./rl/bi_yuzuru.yaml,10,t1_bi_yuzuru_v1.0_0123.onnx,56,14,0.01,10,,
BIPED_SPLIT,rl_bi_split,./rl/bi_split.yaml,10,t1_bi_split_v1.0_0307_15mm.onnx,50,14,0.01,10,,
BIPED_TO_QUADRUPED_FRONTFLIP,rl_bi_to_quad_frontflip,./rl/bi_to_quad_frontflip_run.yaml,10,t1_flip2quad_v1.0_0307_40k.onnx,52,14,0.01,10,,
BIPED_TO_QUADRUPED_ROTATE,rl_bi_to_quad_rotate,./rl/bi_to_quad_rotate_run.yaml,10,t15_bi2quad_rotate_v1.1_terrain.onnx,54,14,0.01,10,,
BIPED_LOCOMOTION_ROTATE_LOCAL,rl_bi_rotate_local,./rl/bi_rotate_local.yaml,10,t1_bi_wbc_v1.0_1228.onnx,57,14,0.01,10,,
BIPED_LOCOMOTION_BACKBEND,rl_bi_backbend,./rl/bi_backbend_run.yaml,10,actor_critic_20251110.onnx,50,14,0.01,10,,
BIPED_LOCOMOTION_MOONWALK,rl_bi_moonwalk,./rl/bi_moonwalk.yaml,10,t1_bi_moonwalk_v2_0807.onnx,51,14,0.01,10,,
BIPED_LOCOMOTION_DANCE,rl_bi_dance,./rl/bi_dance.yaml,10,bi_dance_liuxingwu_acc_1_model_12750.onnx,80,14,0.01,1,,
BIPED_RECORD_UPPER,rl_bi_loco_wbc,./rl/bi_wbc_run.yaml,10,wbcterrain2026092602.onnx,49,14,0.01,10,,
BIPED_CUSTOM_UPPER,rl_bi_loco_wbc,./rl/bi_wbc_run.yaml,10,wbcterrain2026092602.onnx,49,14,0.01,10,,
```


---

## FILE: raw/t1/model_lists/obs-layout.csv

- bytes: 5403

```csv
﻿配置,obs维度,dt,frame_stack,输入构成
bi_backbend_run.yaml,50,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + phase(1)
bi_dance.yaml,80,0.01,1,ref_qj(14) + ref_dqj(14) + anchor_rot6d(6) + gravity(3) + omega(3) + qj_err_no_wheels(12) + dqj(14) + last_action(14)
bi_dance_30kp.yaml,80,0.01,1,ref_qj(14) + ref_dqj(14) + anchor_rot6d(6) + gravity(3) + omega(3) + qj_err_no_wheels(12) + dqj(14) + last_action(14)
bi_gimbal.yaml,49,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3)
bi_lingchuang_mimic.yaml,264,0.01,1,ref_qj(14) + ref_dqj(14) + anchor_rot6d(6) + hist5x46(230)
bi_loco_animation.yaml,51,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(1) + z(1) + yaw(1) + roll(1) + pitch(1)
bi_mimic.yaml,51,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(1) + z(1) + yaw(1) + roll(1) + pitch(1)
bi_moonwalk.yaml,51,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(4) + phase(1)
bi_npz_mimic.yaml,83,0.02,1,command(31) + motion_anchor_ori_b(6) + projected_gravity(3) + base_ang_vel(3) + joint_pos(12) + joint_vel(14) + actions(14)
bi_recovery.yaml,47,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(1)
bi_rotate_local.yaml,57,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + contact(2) + q_ref(6)
bi_run.yaml,49,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3)
bi_split.yaml,50,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + phase(1)
bi_to_quad_frontflip_run.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(6)
bi_to_quad_rotate_run.yaml,54,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + imu_yaw_diff(2) + phase(1) + rotate_phase(1) + q_ref(4)
bi_to_quad_run.yaml,51,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(1) + q_ref(4)
bi_walk.yaml,49,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3)
bi_walk_height_run.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + contact(2) + command(4)
bi_walk_terrain.yaml,49,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3)
bi_walk_terrain_old.yaml,51,0.01,10,imu_omega(3) + imu_euler(3) + command(3) + pos(12) + vel(14) + action(14) + contact(2)
bi_wbc_dance.yaml,49,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3)
bi_wbc_run.yaml,49,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3)
bi_yuzuru.yaml,56,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + phase(1) + q_ref(6)
bi_yuzuru0121.yaml,56,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + phase(1) + q_ref(6)
bi_yuzuru1224.yaml,56,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + phase(1) + q_ref(6)
quad_backflip_run.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(6)
quad_body_adjust.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(6)
quad_frontflip_run.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(6)
quad_handshake_run.yaml,47,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(1)
quad_jump_run.yaml,47,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(1)
quad_mimic.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(6)
quad_pushup.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(6)
quad_recovery.yaml,47,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(1)
quad_run.yaml,57,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + cpg(8)
quad_step.yaml,57,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + cpg(8)
quad_to_bi_frontflip_run.yaml,47,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(1)
quad_to_bi_rotate_run.yaml,54,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + imu_yaw_diff(2) + phase(1) + rotate_phase(1) + q_ref(4)
quad_to_bi_run.yaml,51,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + phase(1) + q_ref(4)
quad_walk.yaml,57,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + cpg(8)
quad_walk_dance.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(6)
quad_walk_pleasure.yaml,50,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(4)
quad_walk_pride.yaml,50,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(4)
quad_walk_reverse.yaml,57,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + cpg(8)
quad_walk_stretch.yaml,52,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(6)
quad_walk_terrain.yaml,57,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(3) + cpg(8)
quad_walk_twist.yaml,50,0.01,10,imu_omega(3) + imu_euler(3) + pos(12) + vel(14) + action(14) + command(4)
```


---

## FILE: raw/t1/model_lists/model-network-stats.md

- bytes: 14531

````markdown
# 运控模型网络统计（本地 640 个 ONNX 实测）

> 统计对象：`运控模型库/真机/` 下全部 **640 个 onnx**（6 套机型，847.6 MB）
> 统计方法：`onnx.load(load_external_data=False)` 逐个解析，读取 initializer 形状与输入输出签名；脚本 `tools/onnx_stats.py`。
> 统计时间：2026-11-11

## 一、总览

| 指标 | 数值 |
|---|---|
| 模型文件数 | **640** |
| 全部可解析 | 640 / 640（0 失败） |
| 参数总量 | **208.36 M**（约 208.4 百万） |
| 文件总量 | **847.6 MB** |
| 单个模型参数 | 149k ~ 3.30M |
| 单个模型体积 | 0.57 MB ~ 21.89 MB |
| 权重精度 | **全部 fp32，无 fp16 / 无 int8 量化**（见第三节） |
| opset | 11: 511 个, 18: 104 个, 12: 25 个 |

**一句话**：这不是"大模型"。**单个运控策略约 23 万参数 / 0.9 MB**，640 个全部加起来才 208M 参数——比一个 7B 大模型的 1% 还少。

## 二、按机型

| 机型目录 | 模型数 | 参数合计 | 体积 | 平均参数量 |
|---|---|---|---|---|
| `qd1_t2d0` | 183 | 51.65 M | 209.7 MB | 282k |
| `qd1_t1d5` | 146 | 43.43 M | 178.2 MB | 297k |
| `q1_t2d0` | 136 | 57.63 M | 240.9 MB | 424k |
| `qd1_t0d5` | 74 | 17.03 M | 65.2 MB | 230k |
| `q1_t0d0` | 71 | 31.68 M | 126.9 MB | 446k |
| `qd1_t0d0` | 30 | 6.95 M | 26.6 MB | 232k |
| **合计** | **640** | **208.36 M** | **847.6 MB** | 326k |

> `qd1_t2d0` 是本机激活机型（183 个）；其余 5 套是不同形态/代际的机型目录。

## 三、精度：全部 fp32，没有 fp16，也没有 int8 量化

这一条不是"看体积猜的"，是四种独立证据互相印证的：

| 证据 | 检查方法 | 结果 |
|---|---|---|
| **权重张量类型** | 读每个 `initializer.data_type` | 本机 183 个模型共 **3204 个权重张量，全部 `FLOAT`**（fp32） |
| **输入/输出类型** | 读 `graph.input/output.elem_type` | 本机 **352 个输入、349 个输出，全部 `FLOAT`** |
| **每参数字节数** | 文件大小 ÷ 参数量 | 640 个模型里 **571 个恰好 4.0 B/param**（fp32 = 4 字节），其余 4.1~4.3 是图结构开销 |
| **有没有量化算子** | 搜 `QuantizeLinear` / `DequantizeLinear` / `QLinear*` | **0 个模型**含量化算子 |

**只有 16 个 Q1 老模型带 INT64 张量**，但它们是 3 个 tiny 常量（形状 `[3]`、`[2]`、`[1]`），
用于 reshape/索引，**不是权重**。本机 183 个模型里一个非 FLOAT 张量都没有。

### 3.1 那 10 个"每个参数 >6 字节"的模型是怎么回事

不是低精度，是**文件里多存了东西**（训练态信息或权重副本），反而说明它们比 fp32 更"胖"：

| 模型 | B/param | 推测原因 |
|---|---|---|
| `bi_dance_liuxingwu_acc_1_model_12750.onnx` | 6.5 | 训练中间产物，带优化器状态 |
| `douyin_3500.onnx` | 7.0 | 同上 |
| `q1_cedeng_simple_collision_model_3750.onnx` | 8.0 | 同上 |

### 3.2 为什么是 fp32（而不是 fp16 / int8）

| 原因 | 说明 |
|---|---|
| **模型太小** | 0.9 MB / 23 万参数，fp16 只能省 0.45 MB，收益可以忽略 |
| **必须 CPU 同步推理** | 运控在 10 ms 周期内同步要结果，fp16 在 A53 上要靠软件模拟，反而更慢 |
| **实时性要求确定性** | int8 量化会引入数值偏差，步态策略对关节输出来很敏感 |
| **没有 NPU 路线** | 配置里每个 `rl/*.yaml` 都有一段**被注释掉的 `rknn` 配置**（`type: "rknn"`、`path: "./rl_models/model_run.rknn"`）——说明**试过 NPU/int8，但现役仍是 onnx/fp32** |

> **一句话**：**全部 fp32（4 字节/参数），没有混合精度、没有量化。**
> 运行时是 onnxruntime 1.19.2 在 CPU（RK3576 的 A53 核）上做 fp32 前向。

### 3.3 对你二次开发的含义

| 你想做的事 | 可行性 |
|---|---|
| 自己训一个新策略导出 fp32 ONNX | ✅ 和现有形态完全一致，直接换 `policy.path` |
| 用 fp16 导出省体积 | ⚠️ 能跑但要确认 onnxruntime 在 A53 上的 fp16 支持（大概率退化到 fp32，白折腾） |
| 转 RKNN int8 上 NPU | ⚠️ 配置里留了位置，但**没有被验证的现役样例**；量化误差对步态的影响需要你自己测 |
| 直接把现有模型转 int8 | ❌ 不建议：这些策略是闭环控制，输出偏差会累积成步态问题 |

## 四、三种网络骨架

| 骨架 | 输入签名 | 数量 | 典型参数 | 用在哪 |
|---|---|---|---|---|
| **甲** 双输入（历史编码器） | `observations[1,N]` + `observation_history[1,N×10]` | **424** | 226~240k | 绝大多数 RL 策略（走路/越野/变身/恢复/双足 WBC） |
| **乙** 单输入（扁平观测） | 单个 `[1, M]`（M=52~1380） | **198** | 149~784k | Q1 代模型、部分无历史编码器的策略 |
| **丙** 灵创（轨迹内嵌） | `obs[1,264]` + `time_step[1,1]` | **18** | 0.93~3.30M | `BIPED_LINGCHUANG_MIMIC` 系列跳舞 |

### 3.1 甲类：历史编码器 + 策略头（本机主力）

以双足走路 `wbcterrain2026092602.onnx`（本机 300 用）为例，**逐层就是这个结构**：

```
输入  observations          [1, 49]    ← 当前一帧观测
      observation_history   [1, 490]   ← 最近 10 帧（49×10）
        │
        ├─ encoder_module:  490 → 128 → 64 → 19      （3 层 Gemm + ELU）
        │     把 10 帧历史压成 19 维"隐状态"
        │
        └─ 拼接：49 + 19 = 68
               │
               └─ actor: 68 → 256 → 256 → 14        （3 层 Gemm + ELU）
                     │
                     └─ 输出 action [1, 14]          ← 14 个关节的目标
```

参数量拆开看（WBC）：

| 子模块 | 形状 | 参数 |
|---|---|---|
| encoder 第 1 层 | [128, 490] | 62,720 |
| encoder 第 2 层 | [64, 128] | 8,192 |
| encoder 第 3 层 | [19, 64] | 1,216 |
| actor 第 1 层 | [256, 68] | 17,408 |
| actor 第 2 层 | [256, 256] | 65,536 |
| actor 第 3 层 | [256, 256] | 65,536 |
| actor 第 4 层 | [14, 256] | 3,584 |
| **合计** | | **约 224k** |

**四足行走 `t2_quad_walk_0902.onnx` 的差别**：

- 输入变 `[1, 57]` + `[1, 570]`，encoder 第一层 [128, 570]
- actor 第一层是 **[256, 80]**（= 57 + 19 + **4**），多出来的 4 维来自模型**第二个输出** `[1, 4]`
- 这 4 维经过一个 Sigmoid，再和观测拼起来喂给 actor —— 对应配置里的 **cpg 相位**（`obs_index.cpg: 49`）

> 这就是"一个模型内部有两条信息流"的实证：**历史编码 + 步态相位**，最后都汇进 actor。

### 3.2 丙类：灵创 MIMIC 把轨迹"烘焙"进了网络

以 `bi_cluo_model_16500.onnx` 为例：

```
输入  obs        [1, 264]
      time_step  [1, 1]        ← 当前播放到第几帧
        │
        └─ policy.actor: 264 → 1024 → 512 → 256 → 14   （1.02M 参数）
              │
              └─ 12 组输出：
                 actions[1,14]  joint_pos[1,14]  joint_vel[1,14]
                 body_pos_w[1,11,3]     body_quat_w[1,11,4]
                 body_lin_vel_w[1,11,3] body_ang_vel_w[1,11,3]
                 motion_phase[1,2]  default_joint_pos[1,14]
                 action_scale[1,12] joint_stiffness[1,14] joint_damping[1,14]
```

**关键**：它输出 `body_pos_w` / `body_quat_w`（11 个刚体的世界位姿）和 `motion_phase`。
说明**参考轨迹被编码在模型权重里**，不再需要外部 CSV —— 与配置注释"灵创 mimic：轨迹内嵌 onnx"完全一致。

这也解释了为什么它参数大 10 倍（0.93~3.3M vs 0.23M）：**它同时承担"轨迹生成"和"跟踪控制"两件事**。

### 3.3 乙类：单输入老结构

198 个单输入模型，输入维度按大小排：

| 输入维度 | 数量 | 例子 | 猜测含义 |
|---|---|---|---|
| `[1, 1360]` | 66 | `q1_backflipSquat_v3.1_20260417.onnx` | 36 维 × 10 帧扁平成一条 |
| `[1, 750]` | 42 | `q1_boxing_v2.0_20260330.detector.onnx` | 75 维 × 10 帧扁平成一条 |
| `[1, 119]` | 25 | `q1_crawl_to_fold.onnx` |  |
| `[1, 1380]` | 17 | `q1_cluoSiuZhuanShou_v1.0_20260618.onnx` | 38 维 × 10 帧扁平成一条 |
| `[1, 83]` | 13 | `bi_npz_mimic_101_260917.onnx` |  |
| `[1, 1200]` | 11 | `q1_random_ground.onnx` | 20 维 × 10 帧扁平成一条 |
| `[1, 122]` | 10 | `fly_0422.onnx` |  |
| `[1, 730]` | 5 | `q1_wbc_v2.0_20260325.onnx` | 73 维 × 10 帧扁平成一条 |
| `[1, 52]` | 3 | `actor_critic_fllipstand_single_frame_1` |  |
| `[1, 500]` | 3 | `q1_blind_terrain_v2.0_20260819.onnx` | 50 维 × 10 帧扁平成一条 |
| `[1, 116]` | 2 | `motion_tracking.onnx` |  |
| `[1, 120]` | 1 | `q1_random_recovery.onnx` | 2 维 × 10 帧扁平成一条 |

> 这一类的共同点：**把"堆叠帧"在模型外拍平成一个长向量**，模型里不做历史编码。
> 新机型（qt1_t2d0）已经不用这种结构，但它还留在目录里（历史/兼容）。

## 五、输入维度 ↔ 动作族 对照（本机可用）

| 输入维度 | 模型数 | 对应观测族 | 典型动作 |
|---|---|---|---|
| `[1, 49];[1, 490]` | 35 | obs=49 · 双足 WBC | 300 |
| `[1, 57];[1, 570]` | 89 | obs=57 · 四足行走族 | 102 / 103 / 121 |
| `[1, 51];[1, 510]` | 73 | obs=51 · 双足 MIMIC | 208 |
| `[1, 54];[1, 540]` | 67 | obs=54 · 形态转换 | 10 / 11 / 20 / 21 / 22 |
| `[1, 52];[1, 520]` | 54 | obs=52 · 四足 MIMIC / 跳舞 | 109 / 118 / 119 |
| `[1, 47];[1, 470]` | 38 | obs=47 · 跌倒恢复 | 100 |
| `[1, 50];[1, 500]` | 22 | obs=50 · 其他四足变体 | — |
| `[1, 56];[1, 560]` | 17 | obs=56 · 其他四足变体 | — |

**规律**：第二个输入恒为第一个的 **10 倍**（除了灵创 264+1 和少数 5 帧变体），这正好对应配置里的 `frame_stack: 10`。看到 `[1, 520]` 就知道这是 obs=52、堆 10 帧的模型。

## 六、现役 34 份权重明细（本机在用的）

| # | 模型 | 参数量 | 体积 | nodes | 输入 |
|---|---|---|---|---|---|
| 1 | `bi_dance_liuxingwu_acc_1_model_12750.onnx` | 743k | 4.59 MB | 34 | `[1, 80];[1, 1]` |
| 2 | `t2_quad_terrain_push_0926.onnx` | 243k | 0.93 MB | 18 | `[1, 57];[1, 570]` |
| 3 | `t2_quad_walk_0902.onnx` | 239k | 0.92 MB | 18 | `[1, 57];[1, 570]` |
| 4 | `t2_quad_walk_re_0907.onnx` | 239k | 0.92 MB | 18 | `[1, 57];[1, 570]` |
| 5 | `t2_quad_run_new_cpg.onnx` | 239k | 0.92 MB | 18 | `[1, 57];[1, 570]` |
| 6 | `t2_quad_walk_lite_0713.onnx` | 238k | 0.91 MB | 16 | `[1, 57];[1, 570]` |
| 7 | `t1_bi_wbc_v1.0_1228.onnx` | 238k | 0.91 MB | 16 | `[1, 57];[1, 570]` |
| 8 | `t1_bi_yuzuru_v1.0_0123.onnx` | 236k | 0.91 MB | 16 | `[1, 56];[1, 560]` |
| 9 | `t15_bi2quad_rotate_v1.1_terrain.onnx` | 234k | 0.90 MB | 29 | `[1, 54];[1, 540]` |
| 10 | `t2_quad2bi_yaw_6837.onnx` | 233k | 0.89 MB | 16 | `[1, 54];[1, 540]` |
| 11 | `biped_rotation0711.onnx` | 231k | 0.89 MB | 16 | `[1, 49];[1, 490]` |
| 12 | `t2_quad_stretch_fix_hip_0911.onnx` | 231k | 0.89 MB | 18 | `[1, 52];[1, 520]` |
| 13 | `t2_quad_twist_charge_pos_kp40.onnx` | 231k | 0.89 MB | 18 | `[1, 52];[1, 520]` |
| 14 | `t2_quad_twist_xy_0725.onnx` | 231k | 0.89 MB | 18 | `[1, 52];[1, 520]` |
| 15 | `t2_quad_frontflip_0703.onnx` | 230k | 0.88 MB | 16 | `[1, 52];[1, 520]` |
| 16 | `actor_critic_rightfirst_backflip.onnx` | 230k | 0.88 MB | 16 | `[1, 52];[1, 520]` |
| 17 | `t2_quad_twist_xy_v1.0_0708.onnx` | 230k | 0.88 MB | 16 | `[1, 52];[1, 520]` |
| 18 | `t1_flip2quad_v1.0_0307_40k.onnx` | 230k | 0.88 MB | 16 | `[1, 52];[1, 520]` |
| 19 | `t1_bi_wbc_pitch0522.onnx` | 229k | 0.88 MB | 16 | `[1, 51];[1, 510]` |
| 20 | `t2.2_quad2bi_norm_0708.onnx` | 229k | 0.88 MB | 16 | `[1, 51];[1, 510]` |
| 21 | `t2_b2q_norm_v1.0_0601.onnx` | 229k | 0.88 MB | 16 | `[1, 51];[1, 510]` |
| 22 | `t1_bi_moonwalk_v2_0807.onnx` | 229k | 0.88 MB | 16 | `[1, 51];[1, 510]` |
| 23 | `t2_q2b_flip_0720.onnx` | 228k | 0.87 MB | 16 | `[1, 47];[1, 470]` |
| 24 | `t2_quad_twist_0803.onnx` | 227k | 0.87 MB | 16 | `[1, 50];[1, 500]` |
| 25 | `t1_bi_split_v1.0_0307_15mm.onnx` | 227k | 0.87 MB | 16 | `[1, 50];[1, 500]` |
| 26 | `actor_critic_20251110.onnx` | 227k | 0.87 MB | 16 | `[1, 50];[1, 500]` |
| 27 | `t1_quad_recovery_v2.0_0814.onnx` | 227k | 0.87 MB | 16 | `[1, 47];[1, 470]` |
| 28 | `lift0514_swing.onnx` | 226k | 0.86 MB | 16 | `[1, 49];[1, 490]` |
| 29 | `t2_bifast_0730.onnx` | 226k | 0.86 MB | 16 | `[1, 49];[1, 490]` |
| 30 | `terrain0313.onnx` | 226k | 0.86 MB | 16 | `[1, 49];[1, 490]` |
| 31 | `wbcterrain2026092602.onnx` | 226k | 0.86 MB | 16 | `[1, 49];[1, 490]` |
| 32 | `wbc2026071201.onnx` | 226k | 0.86 MB | 16 | `[1, 49];[1, 490]` |
| 33 | `t15_quad_jump_platform.onnx` | 222k | 0.85 MB | 16 | `[1, 47];[1, 470]` |
| 34 | `t15_bi_recovery_v1.2_0402.onnx` | 222k | 0.85 MB | 16 | `[1, 47];[1, 470]` |

## 七、几个异常值（值得留意）

- **10 个模型"每个参数占用 >6 字节"**（正常 fp32 是 4 字节）。可能原因：文件里同时存了训练态信息，或权重被复制了一份。
  - `bi_dance_liuxingwu_acc_1_model_12750.onnx`：6.5 B/param
  - `bi_dance_liuxingwu_pd_30kp_model_19500.onnx`：6.5 B/param
  - `bi_dance_liuxingwu_wheel_03kd_model_19000.onnx`：6.1 B/param
  - `q1_cedeng_simple_collision_model_3750.onnx`：8.0 B/param
  - `douyin_3500.onnx`：7.0 B/param
- 最大的模型是灵创系列 `bi_cluo_model_24500.onnx`（**3.30M 参数 / 13.28 MB**），是本机最小模型的 14 倍。
- 最小的模型约 149k 参数（0.6 MB），仍在正常范围。

## 八、对部署的含义

| 问题 | 结论 |
|---|---|
| 内存占用 | 现役 34 份权重合计约 33.7 MB；但运控预载的只是当前动作链用到的那几份（SessionPool 上限 10 个） |
| 单次推理量 | 一次前向约 22 万参数 × 2（乘加）≈ 0.45 MFLOP，RK3576 单核 10 ms 周期绰绰有余 |
| 为什么用 CPU 不用 NPU | 模型太小（<1 MB）、且必须在实时线程内同步出结果，NPU 的调度/搬运开销反而更大；配置里 `device: "cpu"` |
| 换模型的成本 | 复制一个 0.9 MB 文件 + 改一行 `policy.path`；但**obs 维度必须匹配**，跨族换模型会直接维度报错 |

## 九、怎么复算

```powershell
python tools\onnx_stats.py     # 逐个解析 → 清单/模型网络统计.csv
```

字段说明：`params`=initializer 元素总数；`in_dims`/`out_dims`=各输入输出的形状；`nodes`=计算节点数；`opset`=算子集版本。
````


---

## FILE: raw/t1/model_lists/model-network-stats-summary.json

- bytes: 82

```json
{
 "total_files": 640,
 "ok": 640,
 "failed": 0,
 "total_params": 208356703
}
```


---

## FILE: raw/t1/model_lists/action-library-motion_list.md

- bytes: 2103

```markdown
# 动作库（motion_list.yaml，真机 108 条）

来源：`真机/qd1_t2d0/配置/motion_list.yaml`。这是 **MIMIC / ANIMATION 的动作注册表**，
每条动作自带「模型（可为空）+ 参考轨迹」。

| motion 类型 | 条数 | 不同模型数 | 轨迹数 | body | 挂到哪个 Action |
|---|---|---|---|---|---|
| ANIMATION | 78 | 0 | 77 | upper | BIPED_LOCOMOTION_WBC |
| QUADRUPED_MIMIC | 19 | 1 | 19 | whole | QUADRUPED_MIMIC |
| BIPED_MIMIC | 8 | 1 | 8 | whole | BIPED_MIMIC |
| BIPED_NPZ_MIMIC | 3 | 3 | 3 | whole | BIPED_NPZ_MIMIC |

## 结论

- `QUADRUPED_MIMIC` 19 条共用 **1 个模型**，靠 19 条 CSV 区分
- `BIPED_MIMIC` 8 条共用 **1 个模型**，靠 8 条 CSV 区分
- `BIPED_NPZ_MIMIC` 3 条各一个模型 + 各一条 NPZ
- `ANIMATION` 78 条**没有模型**，纯 CSV 回放（fps 60），在 `BIPED_LOCOMOTION_WBC` 内叠加上肢
- `ANIMATION` 的 name 是数字（1001…），对应 `McPresetMotion` 枚举——所谓「预设动作」就是这 78 条

## 字段说明

| 字段 | 含义 |
|---|---|
| `policy_path` | 这条动作的模型；**可为空**（由 MotionManager 运行时下发） |
| `custom.trajectory_path` | 参考轨迹（CSV 或 NPZ） |
| `custom.fps` | 回放帧率（ANIMATION 为 60） |
| `custom.animation_type` | 柔性/刚性/保持末帧 |
| `interrupt_type` | 能否被别的动作打断 |
| `custom.start_count` / `end_count` | 轨迹截取的起止帧 |
| `motion_area` | 执行区域（细化语义未完全确证） |

> 明细见 `动作库-motion_list.csv`（108 行）。

## 本机的两个"看着有、其实没启用"

| 项 | 状态 |
|---|---|
| `BIPED_LINGCHUANG_MIMIC`（灵创） | **本机 0 条 active**（6 条全被注释）；`rl_models/` 里仍留着 6 个模型。灵创在 **qd1_t1d5** 上才启用（6 条） |
| `ANIMATION` 里的 78 条 | 本机启用，就是"预设动作"（数字名 1001…） |

**灵创 vs NPZ 的判据**：看模型输入——`[1,264]+[1,1]` 是灵创（轨迹烘在模型里）；`[1,83]` 是 NPZ（轨迹在外部 .npz）。
```


---

## FILE: raw/t1/model_lists/rule-graph-stats.md

- bytes: 2018

````markdown
# 换乘图（真机 action_ruler.yaml）

- 节点（有规则的 Action）：**52**
- 有向边：**197**
- 全局出口：**3** → PASSIVE_DEFAULT, DAMPING_DEFAULT, QUAD_LIE_DOWN
- 不许中转（skip）：**24**

## 出度前 10（能直接去多少个地方）

| Action | 出度 |
|---|---|
| QUADRUPED_LOCOMOTION_STEP | 19 |
| BIPED_LOCOMOTION_WBC | 18 |
| BIPED_MIMIC | 12 |
| BIPED_LINGCHUANG_MIMIC | 12 |
| BIPED_GIMBAL | 12 |
| BIPED_NPZ_MIMIC | 12 |
| BIPED_LOCOMOTION_ANIMATION | 11 |
| PASSIVE_DEFAULT | 8 |
| QUADRUPED_STAND_DEFAULT | 6 |
| QUADRUPED_LOCOMOTION_DEFAULT | 5 |

## 入度前 8（多少人能直接来）

| Action | 入度 |
|---|---|
| BIPED_LOCOMOTION_WBC | 21 |
| QUADRUPED_LOCOMOTION_DEFAULT | 17 |
| QUADRUPED_STAND_DEFAULT | 13 |
| BIPED_LOCOMOTION_TERRAIN | 9 |
| STORE_DEFAULT | 8 |
| BIPED_LOCOMOTION_RUN | 8 |
| BIPED_TO_QUADRUPED_ROTATE | 7 |
| QUADRUPED_GET_DOWN_DEFAULT | 6 |

## skip 集合（不许当普通中转站）

```
PASSIVE_DEFAULT
BIPED_LOCOMOTION_WBC
BIPED_LOCOMOTION_ANIMATION
BIPED_MIMIC
BIPED_LINGCHUANG_MIMIC
BIPED_GIMBAL
BIPED_NPZ_MIMIC
BIPED_STAND_DEFAULT
QUADRUPED_RECOVERY
QUADRUPED_LOCOMOTION_FRONTFLIP
QUADRUPED_LOCOMOTION_BACKFLIP
QUADRUPED_GET_DOWN_DEFAULT
STORE_DEFAULT
QUADRUPED_SIT_DOWN_DEFAULT
BIPED_TO_QUADRUPED
QUADRUPED_TO_BIPED
BIPED_RECOVERY
QUADRUPED_LOCOMOTION_DEFAULT
QUADRUPED_LOCOMOTION_TERRAIN
QUADRUPED_LOCOMOTION_RUN
QUADRUPED_LOCOMOTION_HANDSHAKE
QUADRUPED_LOCOMOTION_JUMP
QUADRUPED_STAND_REVERSE_DEFAULT
QUADRUPED_LOCOMOTION_REVERSE_DEFAULT
```

> 注意：skip ≠ 黑名单。作为**目标**时仍然可达；桥接动作（102/300）与自动后继另有例外。

## 与 SDK 客户端 helper 的差异

| 项 | SDK helper（旧） | 真机 action_ruler |
|---|---|---|
| 节点 | 35 | **52** |
| 边 | 130 | **197** |
| skip | 13 | **24** |

> 结论：**客户端 helper 是子集**，不能拿它当完整换乘表；排障必须用真机配置。
````


---
