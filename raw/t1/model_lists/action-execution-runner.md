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
