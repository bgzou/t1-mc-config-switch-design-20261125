# Pack 07 · 真机日志（UC3 牵手跟随）

从 10.8 MB 的 `c2_events.log` 抽出的状态变化表与 4 个原始窗口。重点：held 在 300 内多次 on/off、动作不变、`hand_held=3`。


===== FILE: raw/logs/uc3_state_timeline.csv  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/05_GPT架构评审/20261127_handheld/input_bundle/raw/logs/uc3_state_timeline.csv) =====

time,action_desc,is_held,hand_held,form,follow_state
14:25:10.832,,,,,
14:25:13.848,QUADRUPED_LOCOMOTION_DEFAULT,,,,
14:25:18.185,QUADRUPED_LOCOMOTION_DEFAULT,,,1,
14:25:18.252,QUADRUPED_LOCOMOTION_DEFAULT,false,,1,
14:25:18.257,QUADRUPED_LOCOMOTION_DEFAULT,false,0,1,
14:25:44.553,QUADRUPED_GET_DOWN_DEFAULT,false,0,1,
14:30:38.449,QUADRUPED_READY_STAND_DEFAULT,false,0,1,
14:30:38.845,QUADRUPED_STAND_DEFAULT,false,0,1,
14:30:41.103,QUADRUPED_STAND_DEFAULT,false,0,1,0
14:30:42.034,QUADRUPED_LOCOMOTION_DEFAULT,false,0,1,0
14:30:42.747,QUADRUPED_LOCOMOTION_STEP,false,0,1,0
14:30:42.808,QUADRUPED_LOCOMOTION_DANCE,false,0,1,0
14:31:00.880,QUADRUPED_LOCOMOTION_DEFAULT,false,0,1,0
14:31:13.262,QUADRUPED_TO_BIPED_ROTATE,false,0,1,0
14:31:18.070,BIPED_LOCOMOTION_WBC,false,0,1,0
14:31:19.597,BIPED_LOCOMOTION_WBC,false,0,2,0
14:31:23.307,BIPED_LOCOMOTION_WBC,false,1,2,0
14:31:33.318,BIPED_LOCOMOTION_WBC,false,0,2,0
14:31:50.655,BIPED_LOCOMOTION_WBC,false,1,2,0
14:33:01.603,BIPED_TO_QUADRUPED_ROTATE,false,1,2,0
14:33:04.092,BIPED_TO_QUADRUPED_ROTATE,false,1,1,0
14:33:04.162,BIPED_TO_QUADRUPED_ROTATE,false,0,1,0
14:33:04.604,QUADRUPED_LOCOMOTION_DEFAULT,false,0,1,0
14:33:06.529,QUADRUPED_GET_DOWN_DEFAULT,false,0,1,0
14:34:47.445,QUADRUPED_READY_STAND_DEFAULT,false,0,1,0
14:34:49.009,QUADRUPED_STAND_DEFAULT,false,0,1,0
14:34:52.172,QUADRUPED_LOCOMOTION_DEFAULT,false,0,1,0
14:35:13.982,QUADRUPED_TO_BIPED_ROTATE,false,0,1,0
14:35:18.822,BIPED_LOCOMOTION_WBC,false,0,1,0
14:35:19.966,BIPED_LOCOMOTION_WBC,false,0,2,0
14:35:24.716,BIPED_LOCOMOTION_WBC,false,1,2,0
14:36:11.389,BIPED_LOCOMOTION_WBC,false,1,2,1
14:37:24.205,BIPED_LOCOMOTION_WBC,true,1,2,1
14:37:24.211,BIPED_LOCOMOTION_WBC,true,3,2,1
14:37:48.634,BIPED_LOCOMOTION_WBC,false,3,2,1
14:37:48.639,BIPED_LOCOMOTION_WBC,false,1,2,1
14:39:30.427,BIPED_LOCOMOTION_WBC,true,1,2,1
14:39:30.433,BIPED_LOCOMOTION_WBC,true,3,2,1
14:39:45.661,BIPED_LOCOMOTION_WBC,false,3,2,1
14:39:45.667,BIPED_LOCOMOTION_WBC,false,1,2,1
14:40:02.221,BIPED_LOCOMOTION_WBC,true,1,2,1
14:40:02.226,BIPED_LOCOMOTION_WBC,true,3,2,1
14:40:40.760,BIPED_LOCOMOTION_WBC,false,3,2,1
14:40:40.766,BIPED_LOCOMOTION_WBC,false,1,2,1
14:40:46.385,BIPED_LOCOMOTION_WBC,true,1,2,1
14:40:46.394,BIPED_LOCOMOTION_WBC,true,3,2,1


===== FILE: raw/logs/uc3_enter_biped.log  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/05_GPT架构评审/20261127_handheld/input_bundle/raw/logs/uc3_enter_biped.log) =====

# window 52513.5..52519.5 (seconds of day), raw lines from c2_events.log
14:35:13.500 [MCA] source: task_engine
14:35:13.504 [IST]   task_type: 0
14:35:13.505 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.511 [MCA] status:
14:35:13.511 [IST]   task_stage: 0
14:35:13.517 [IST]   token:
14:35:13.517 [MCA]   value: 100
14:35:13.522 [MCA] switch_ready: true
14:35:13.523 [IST]     source: ''
14:35:13.527 [MCA] ---
14:35:13.530 [IST]     token: ''
14:35:13.534 [MCA] current_action:
14:35:13.536 [IST] motion: ''
14:35:13.540 [MCA]   value: 102
14:35:13.543 [IST] percep_env_state: 0
14:35:13.546 [MCA] source: task_engine
14:35:13.550 [IST] ---
14:35:13.553 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.558 [IST] header:
14:35:13.560 [MCA] status:
14:35:13.566 [IST]   stamp:
14:35:13.566 [MCA]   value: 100
14:35:13.571 [MCA] switch_ready: true
14:35:13.572 [IST]     sec: 0
14:35:13.576 [MCA] ---
14:35:13.577 [IST]     nanosec: 0
14:35:13.586 [MCA] current_action:
14:35:13.588 [IST]   frame_id: ''
14:35:13.592 [MCA]   value: 102
14:35:13.594 [IST]   sequence: 0
14:35:13.599 [MCA] source: task_engine
14:35:13.602 [IST]   meas_stamp:
14:35:13.604 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.608 [IST]     sec: 0
14:35:13.613 [MCA] status:
14:35:13.615 [IST]     nanosec: 0
14:35:13.619 [MCA]   value: 100
14:35:13.620 [IST] interaction_id: 100
14:35:13.623 [MCA] switch_ready: true
14:35:13.625 [IST] mp_state:
14:35:13.629 [MCA] ---
14:35:13.630 [IST]   value: 0
14:35:13.635 [MCA] current_action:
14:35:13.635 [IST] form_state:
14:35:13.640 [MCA]   value: 102
14:35:13.641 [IST]   current_form: 1
14:35:13.644 [MCA] source: task_engine
14:35:13.645 [IST] action_info:
14:35:13.650 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.652 [IST]   current_action:
14:35:13.657 [MCA] status:
14:35:13.659 [IST]     value: 102
14:35:13.664 [MCA]   value: 100
14:35:13.665 [IST]   source: task_engine
14:35:13.671 [MCA] switch_ready: true
14:35:13.671 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.677 [IST]   status:
14:35:13.678 [MCA] ---
14:35:13.682 [IST]     value: 100
14:35:13.683 [MCA] current_action:
14:35:13.690 [IST]   switch_ready: true
14:35:13.691 [MCA]   value: 102
14:35:13.697 [IST] held_state:
14:35:13.699 [MCA] source: task_engine
14:35:13.702 [IST]   is_held: false
14:35:13.705 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.708 [IST]   hand_held: 0
14:35:13.710 [MCA] status:
14:35:13.713 [IST] mode: 1
14:35:13.716 [MCA]   value: 100
14:35:13.719 [IST] mode_speed: 0.5
14:35:13.721 [MCA] switch_ready: true
14:35:13.725 [IST] prohibition_broadcast_net: false
14:35:13.725 [MCA] ---
14:35:13.730 [IST] task_state:
14:35:13.730 [MCA] current_action:
14:35:13.735 [MCA]   value: 102
14:35:13.735 [IST]   task_type: 0
14:35:13.739 [MCA] source: task_engine
14:35:13.741 [IST]   task_stage: 0
14:35:13.744 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.746 [IST]   token:
14:35:13.751 [MCA] status:
14:35:13.752 [IST]     source: ''
14:35:13.757 [IST]     token: ''
14:35:13.756 [MCA]   value: 100
14:35:13.763 [IST] motion: ''
14:35:13.764 [MCA] switch_ready: true
14:35:13.769 [MCA] ---
14:35:13.769 [IST] percep_env_state: 0
14:35:13.775 [IST] ---
14:35:13.775 [MCA] current_action:
14:35:13.781 [MCA]   value: 102
14:35:13.781 [IST] header:
14:35:13.787 [MCA] source: task_engine
14:35:13.788 [IST]   stamp:
14:35:13.798 [IST]     sec: 0
14:35:13.801 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.804 [IST]     nanosec: 0
14:35:13.807 [MCA] status:
14:35:13.810 [IST]   frame_id: ''
14:35:13.812 [MCA]   value: 100
14:35:13.815 [IST]   sequence: 0
14:35:13.817 [MCA] switch_ready: true
14:35:13.820 [IST]   meas_stamp:
14:35:13.822 [MCA] ---
14:35:13.825 [IST]     sec: 0
14:35:13.826 [MCA] current_action:
14:35:13.829 [IST]     nanosec: 0
14:35:13.831 [MCA]   value: 102
14:35:13.834 [IST] interaction_id: 100
14:35:13.836 [MCA] source: task_engine
14:35:13.839 [IST] mp_state:
14:35:13.842 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.844 [IST]   value: 0
14:35:13.848 [MCA] status:
14:35:13.851 [IST] form_state:
14:35:13.854 [MCA]   value: 100
14:35:13.857 [IST]   current_form: 1
14:35:13.861 [MCA] switch_ready: true
14:35:13.864 [IST] action_info:
14:35:13.867 [MCA] ---
14:35:13.870 [IST]   current_action:
14:35:13.872 [MCA] current_action:
14:35:13.876 [IST]     value: 102
14:35:13.880 [MCA]   value: 102
14:35:13.885 [MCA] source: task_engine
14:35:13.882 [IST]   source: task_engine
14:35:13.892 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.892 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.899 [IST]   status:
14:35:13.901 [MCA] status:
14:35:13.905 [IST]     value: 100
14:35:13.906 [MCA]   value: 100
14:35:13.910 [IST]   switch_ready: true
14:35:13.911 [MCA] switch_ready: true
14:35:13.916 [MCA] ---
14:35:13.916 [IST] held_state:
14:35:13.921 [MCA] current_action:
14:35:13.921 [IST]   is_held: false
14:35:13.926 [IST]   hand_held: 0
14:35:13.927 [MCA]   value: 102
14:35:13.931 [IST] mode: 1
14:35:13.932 [MCA] source: task_engine
14:35:13.935 [IST] mode_speed: 0.5
14:35:13.937 [MCA] action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:13.940 [IST] prohibition_broadcast_net: false
14:35:13.941 [MCA] status:
14:35:13.947 [MCA]   value: 100
14:35:13.945 [IST] task_state:
14:35:13.953 [MCA] switch_ready: true
14:35:13.954 [IST]   task_type: 0
14:35:13.959 [MCA] ---
14:35:13.959 [IST]   task_stage: 0
14:35:13.965 [MCA] current_action:
14:35:13.965 [IST]   token:
14:35:13.971 [IST]     source: ''
14:35:13.971 [MCA]   value: 11
14:35:13.977 [IST]     token: ''
14:35:13.977 [MCA] source: task_engine
14:35:13.982 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:13.987 [IST] motion: ''
14:35:13.989 [MCA] status:
14:35:13.996 [IST] percep_env_state: 0
14:35:13.999 [MCA]   value: 100
14:35:14.003 [IST] ---
14:35:14.004 [MCA] switch_ready: false
14:35:14.010 [IST] header:
14:35:14.010 [MCA] ---
14:35:14.016 [IST]   stamp:
14:35:14.016 [MCA] current_action:
14:35:14.023 [IST]     sec: 0
14:35:14.024 [MCA]   value: 11
14:35:14.029 [MCA] source: task_engine
14:35:14.029 [IST]     nanosec: 0
14:35:14.035 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.035 [IST]   frame_id: ''
14:35:14.040 [MCA] status:
14:35:14.040 [IST]   sequence: 0
14:35:14.046 [MCA]   value: 100
14:35:14.047 [IST]   meas_stamp:
14:35:14.054 [IST]     sec: 0
14:35:14.055 [MCA] switch_ready: false
14:35:14.060 [IST]     nanosec: 0
14:35:14.062 [MCA] ---
14:35:14.066 [IST] interaction_id: 100
14:35:14.068 [MCA] current_action:
14:35:14.072 [IST] mp_state:
14:35:14.075 [MCA]   value: 11
14:35:14.078 [IST]   value: 0
14:35:14.080 [MCA] source: task_engine
14:35:14.084 [IST] form_state:
14:35:14.093 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.093 [IST]   current_form: 1
14:35:14.100 [MCA] status:
14:35:14.101 [IST] action_info:
14:35:14.106 [MCA]   value: 100
14:35:14.109 [IST]   current_action:
14:35:14.112 [MCA] switch_ready: false
14:35:14.116 [IST]     value: 102
14:35:14.118 [MCA] ---
14:35:14.121 [IST]   source: task_engine
14:35:14.124 [MCA] current_action:
14:35:14.126 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:14.130 [MCA]   value: 11
14:35:14.131 [IST]   status:
14:35:14.136 [IST]     value: 100
14:35:14.136 [MCA] source: task_engine
14:35:14.141 [IST]   switch_ready: true
14:35:14.142 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.145 [IST] held_state:
14:35:14.148 [MCA] status:
14:35:14.151 [IST]   is_held: false
14:35:14.153 [MCA]   value: 100
14:35:14.158 [IST]   hand_held: 0
14:35:14.160 [MCA] switch_ready: false
14:35:14.165 [IST] mode: 1
14:35:14.168 [MCA] ---
14:35:14.171 [IST] mode_speed: 0.5
14:35:14.175 [MCA] current_action:
14:35:14.180 [MCA]   value: 11
14:35:14.180 [IST] prohibition_broadcast_net: false
14:35:14.187 [MCA] source: task_engine
14:35:14.193 [IST] task_state:
14:35:14.198 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.201 [IST]   task_type: 0
14:35:14.207 [IST]   task_stage: 0
14:35:14.205 [MCA] status:
14:35:14.212 [IST]   token:
14:35:14.214 [MCA]   value: 100
14:35:14.220 [IST]     source: ''
14:35:14.221 [MCA] switch_ready: false
14:35:14.226 [MCA] ---
14:35:14.226 [IST]     token: ''
14:35:14.230 [MCA] current_action:
14:35:14.233 [IST] motion: ''
14:35:14.236 [MCA]   value: 11
14:35:14.238 [IST] percep_env_state: 0
14:35:14.241 [MCA] source: task_engine
14:35:14.243 [IST] ---
14:35:14.248 [IST] header:
14:35:14.250 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.257 [MCA] status:
14:35:14.257 [IST]   stamp:
14:35:14.262 [MCA]   value: 100
14:35:14.262 [IST]     sec: 0
14:35:14.269 [MCA] switch_ready: false
14:35:14.269 [IST]     nanosec: 0
14:35:14.274 [MCA] ---
14:35:14.275 [IST]   frame_id: ''
14:35:14.279 [MCA] current_action:
14:35:14.280 [IST]   sequence: 0
14:35:14.290 [IST]   meas_stamp:
14:35:14.291 [MCA]   value: 11
14:35:14.298 [MCA] source: task_engine
14:35:14.299 [IST]     sec: 0
14:35:14.303 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.305 [IST]     nanosec: 0
14:35:14.309 [MCA] status:
14:35:14.311 [IST] interaction_id: 100
14:35:14.317 [IST] mp_state:
14:35:14.317 [MCA]   value: 100
14:35:14.323 [MCA] switch_ready: false
14:35:14.323 [IST]   value: 0
14:35:14.327 [MCA] ---
14:35:14.329 [IST] form_state:
14:35:14.333 [MCA] current_action:
14:35:14.338 [IST]   current_form: 1
14:35:14.341 [MCA]   value: 11
14:35:14.343 [IST] action_info:
14:35:14.347 [MCA] source: task_engine
14:35:14.350 [IST]   current_action:
14:35:14.354 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.357 [IST]     value: 102
14:35:14.361 [MCA] status:
14:35:14.365 [IST]   source: task_engine
14:35:14.368 [MCA]   value: 100
14:35:14.373 [MCA] switch_ready: false
14:35:14.374 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:14.379 [IST]   status:
14:35:14.379 [MCA] ---
14:35:14.391 [MCA] current_action:
14:35:14.394 [IST]     value: 100
14:35:14.398 [MCA]   value: 11
14:35:14.400 [IST]   switch_ready: true
14:35:14.406 [IST] held_state:
14:35:14.406 [MCA] source: task_engine
14:35:14.413 [IST]   is_held: false
14:35:14.415 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.419 [IST]   hand_held: 0
14:35:14.420 [MCA] status:
14:35:14.423 [IST] mode: 1
14:35:14.424 [MCA]   value: 100
14:35:14.429 [IST] mode_speed: 0.5
14:35:14.429 [MCA] switch_ready: false
14:35:14.435 [MCA] ---
14:35:14.435 [IST] prohibition_broadcast_net: false
14:35:14.441 [MCA] current_action:
14:35:14.441 [IST] task_state:
14:35:14.446 [IST]   task_type: 0
14:35:14.447 [MCA]   value: 11
14:35:14.452 [IST]   task_stage: 0
14:35:14.454 [MCA] source: task_engine
14:35:14.460 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.462 [IST]   token:
14:35:14.467 [MCA] status:
14:35:14.470 [IST]     source: ''
14:35:14.473 [MCA]   value: 100
14:35:14.475 [IST]     token: ''
14:35:14.478 [MCA] switch_ready: false
14:35:14.483 [MCA] ---
14:35:14.489 [IST] motion: ''
14:35:14.495 [MCA] current_action:
14:35:14.498 [IST] percep_env_state: 0
14:35:14.501 [MCA]   value: 11
14:35:14.504 [IST] ---
14:35:14.509 [MCA] source: task_engine
14:35:14.510 [IST] header:
14:35:14.515 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.516 [IST]   stamp:
14:35:14.520 [MCA] status:
14:35:14.521 [IST]     sec: 0
14:35:14.525 [MCA]   value: 100
14:35:14.527 [IST]     nanosec: 0
14:35:14.530 [MCA] switch_ready: false
14:35:14.532 [IST]   frame_id: ''
14:35:14.536 [MCA] ---
14:35:14.538 [IST]   sequence: 0
14:35:14.540 [MCA] current_action:
14:35:14.543 [IST]   meas_stamp:
14:35:14.546 [MCA]   value: 11
14:35:14.549 [IST]     sec: 0
14:35:14.554 [MCA] source: task_engine
14:35:14.556 [IST]     nanosec: 0
14:35:14.564 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.565 [IST] interaction_id: 100
14:35:14.569 [MCA] status:
14:35:14.570 [IST] mp_state:
14:35:14.574 [MCA]   value: 100
14:35:14.576 [IST]   value: 0
14:35:14.580 [MCA] switch_ready: false
14:35:14.582 [IST] form_state:
14:35:14.589 [IST]   current_form: 1
14:35:14.590 [MCA] ---
14:35:14.596 [MCA] current_action:
14:35:14.598 [IST] action_info:
14:35:14.603 [IST]   current_action:
14:35:14.605 [MCA]   value: 11
14:35:14.610 [MCA] source: task_engine
14:35:14.610 [IST]     value: 102
14:35:14.616 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.617 [IST]   source: task_engine
14:35:14.621 [MCA] status:
14:35:14.623 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:14.625 [MCA]   value: 100
14:35:14.629 [IST]   status:
14:35:14.629 [MCA] switch_ready: false
14:35:14.635 [IST]     value: 100
14:35:14.635 [MCA] ---
14:35:14.640 [IST]   switch_ready: true
14:35:14.641 [MCA] current_action:
14:35:14.645 [IST] held_state:
14:35:14.649 [MCA]   value: 11
14:35:14.652 [IST]   is_held: false
14:35:14.656 [MCA] source: task_engine
14:35:14.660 [IST]   hand_held: 0
14:35:14.663 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.669 [MCA] status:
14:35:14.670 [IST] mode: 1
14:35:14.674 [MCA]   value: 100
14:35:14.676 [IST] mode_speed: 0.5
14:35:14.681 [IST] prohibition_broadcast_net: false
14:35:14.680 [MCA] switch_ready: false
14:35:14.692 [IST] task_state:
14:35:14.694 [MCA] ---
14:35:14.700 [MCA] current_action:
14:35:14.700 [IST]   task_type: 0
14:35:14.705 [MCA]   value: 11
14:35:14.705 [IST]   task_stage: 0
14:35:14.711 [IST]   token:
14:35:14.711 [MCA] source: task_engine
14:35:14.717 [IST]     source: ''
14:35:14.717 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.721 [MCA] status:
14:35:14.723 [IST]     token: ''
14:35:14.727 [MCA]   value: 100
14:35:14.728 [IST] motion: ''
14:35:14.732 [MCA] switch_ready: false
14:35:14.734 [IST] percep_env_state: 0
14:35:14.737 [MCA] ---
14:35:14.739 [IST] ---
14:35:14.742 [MCA] current_action:
14:35:14.743 [IST] header:
14:35:14.749 [IST]   stamp:
14:35:14.750 [MCA]   value: 11
14:35:14.757 [MCA] source: task_engine
14:35:14.757 [IST]     sec: 0
14:35:14.765 [IST]     nanosec: 0
14:35:14.765 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.771 [IST]   frame_id: ''
14:35:14.772 [MCA] status:
14:35:14.777 [IST]   sequence: 0
14:35:14.778 [MCA]   value: 100
14:35:14.782 [IST]   meas_stamp:
14:35:14.783 [MCA] switch_ready: false
14:35:14.796 [IST]     sec: 0
14:35:14.801 [MCA] ---
14:35:14.802 [IST]     nanosec: 0
14:35:14.806 [MCA] current_action:
14:35:14.809 [IST] interaction_id: 100
14:35:14.811 [MCA]   value: 11
14:35:14.816 [IST] mp_state:
14:35:14.817 [MCA] source: task_engine
14:35:14.821 [IST]   value: 0
14:35:14.822 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.827 [MCA] status:
14:35:14.828 [IST] form_state:
14:35:14.832 [MCA]   value: 100
14:35:14.835 [IST]   current_form: 1
14:35:14.838 [MCA] switch_ready: false
14:35:14.841 [IST] action_info:
14:35:14.843 [MCA] ---
14:35:14.847 [IST]   current_action:
14:35:14.851 [MCA] current_action:
14:35:14.854 [IST]     value: 102
14:35:14.860 [IST]   source: task_engine
14:35:14.861 [MCA]   value: 11
14:35:14.866 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:14.870 [MCA] source: task_engine
14:35:14.871 [IST]   status:
14:35:14.877 [IST]     value: 100
14:35:14.878 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.883 [MCA] status:
14:35:14.883 [IST]   switch_ready: true
14:35:14.894 [IST] held_state:
14:35:14.896 [MCA]   value: 100
14:35:14.901 [IST]   is_held: false
14:35:14.907 [MCA] switch_ready: false
14:35:14.907 [IST]   hand_held: 0
14:35:14.913 [IST] mode: 1
14:35:14.914 [MCA] ---
14:35:14.918 [IST] mode_speed: 0.5
14:35:14.921 [MCA] current_action:
14:35:14.923 [IST] prohibition_broadcast_net: false
14:35:14.925 [MCA]   value: 11
14:35:14.929 [IST] task_state:
14:35:14.932 [MCA] source: task_engine
14:35:14.934 [IST]   task_type: 0
14:35:14.937 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.939 [IST]   task_stage: 0
14:35:14.942 [MCA] status:
14:35:14.943 [IST]   token:
14:35:14.950 [IST]     source: ''
14:35:14.950 [MCA]   value: 100
14:35:14.959 [IST]     token: ''
14:35:14.959 [MCA] switch_ready: false
14:35:14.965 [MCA] ---
14:35:14.965 [IST] motion: ''
14:35:14.970 [MCA] current_action:
14:35:14.971 [IST] percep_env_state: 0
14:35:14.975 [MCA]   value: 11
14:35:14.976 [IST] ---
14:35:14.979 [MCA] source: task_engine
14:35:14.980 [IST] header:
14:35:14.993 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:14.995 [IST]   stamp:
14:35:14.999 [MCA] status:
14:35:14.999 [IST]     sec: 0
14:35:15.005 [MCA]   value: 100
14:35:15.007 [IST]     nanosec: 0
14:35:15.011 [MCA] switch_ready: false
14:35:15.014 [IST]   frame_id: ''
14:35:15.017 [MCA] ---
14:35:15.022 [IST]   sequence: 0
14:35:15.024 [MCA] current_action:
14:35:15.027 [IST]   meas_stamp:
14:35:15.030 [MCA]   value: 11
14:35:15.033 [IST]     sec: 0
14:35:15.037 [MCA] source: task_engine
14:35:15.038 [IST]     nanosec: 0
14:35:15.042 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.043 [IST] interaction_id: 100
14:35:15.047 [MCA] status:
14:35:15.053 [IST] mp_state:
14:35:15.053 [MCA]   value: 100
14:35:15.059 [MCA] switch_ready: false
14:35:15.064 [MCA] ---
14:35:15.065 [IST]   value: 0
14:35:15.071 [MCA] current_action:
14:35:15.073 [IST] form_state:
14:35:15.077 [MCA]   value: 11
14:35:15.080 [IST]   current_form: 1
14:35:15.083 [MCA] source: task_engine
14:35:15.095 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.098 [IST] action_info:
14:35:15.100 [MCA] status:
14:35:15.106 [MCA]   value: 100
14:35:15.107 [IST]   current_action:
14:35:15.111 [MCA] switch_ready: false
14:35:15.112 [IST]     value: 102
14:35:15.117 [MCA] ---
14:35:15.118 [IST]   source: task_engine
14:35:15.122 [MCA] current_action:
14:35:15.122 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:15.127 [MCA]   value: 11
14:35:15.128 [IST]   status:
14:35:15.133 [IST]     value: 100
14:35:15.135 [MCA] source: task_engine
14:35:15.139 [IST]   switch_ready: true
14:35:15.141 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.146 [MCA] status:
14:35:15.144 [IST] held_state:
14:35:15.152 [IST]   is_held: false
14:35:15.156 [MCA]   value: 100
14:35:15.160 [IST]   hand_held: 0
14:35:15.161 [MCA] switch_ready: false
14:35:15.166 [IST] mode: 1
14:35:15.168 [MCA] ---
14:35:15.172 [IST] mode_speed: 0.5
14:35:15.174 [MCA] current_action:
14:35:15.177 [IST] prohibition_broadcast_net: false
14:35:15.180 [MCA]   value: 11
14:35:15.183 [IST] task_state:
14:35:15.198 [IST]   task_type: 0
14:35:15.200 [MCA] source: task_engine
14:35:15.203 [IST]   task_stage: 0
14:35:15.207 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.208 [IST]   token:
14:35:15.214 [IST]     source: ''
14:35:15.216 [MCA] status:
14:35:15.219 [IST]     token: ''
14:35:15.221 [MCA]   value: 100
14:35:15.224 [IST] motion: ''
14:35:15.225 [MCA] switch_ready: false
14:35:15.230 [IST] percep_env_state: 0
14:35:15.230 [MCA] ---
14:35:15.236 [MCA] current_action:
14:35:15.236 [IST] ---
14:35:15.241 [MCA]   value: 11
14:35:15.242 [IST] header:
14:35:15.248 [MCA] source: task_engine
14:35:15.253 [IST]   stamp:
14:35:15.254 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.259 [IST]     sec: 0
14:35:15.261 [MCA] status:
14:35:15.265 [IST]     nanosec: 0
14:35:15.265 [MCA]   value: 100
14:35:15.271 [MCA] switch_ready: false
14:35:15.273 [IST]   frame_id: ''
14:35:15.276 [MCA] ---
14:35:15.278 [IST]   sequence: 0
14:35:15.281 [MCA] current_action:
14:35:15.283 [IST]   meas_stamp:
14:35:15.289 [MCA]   value: 11
14:35:15.295 [IST]     sec: 0
14:35:15.297 [MCA] source: task_engine
14:35:15.303 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.307 [IST]     nanosec: 0
14:35:15.310 [MCA] status:
14:35:15.313 [IST] interaction_id: 100
14:35:15.317 [MCA]   value: 100
14:35:15.322 [MCA] switch_ready: false
14:35:15.322 [IST] mp_state:
14:35:15.327 [MCA] ---
14:35:15.328 [IST]   value: 0
14:35:15.332 [MCA] current_action:
14:35:15.333 [IST] form_state:
14:35:15.338 [MCA]   value: 11
14:35:15.338 [IST]   current_form: 1
14:35:15.342 [MCA] source: task_engine
14:35:15.343 [IST] action_info:
14:35:15.348 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.348 [IST]   current_action:
14:35:15.354 [MCA] status:
14:35:15.354 [IST]     value: 102
14:35:15.360 [MCA]   value: 100
14:35:15.362 [IST]   source: task_engine
14:35:15.367 [MCA] switch_ready: false
14:35:15.369 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:15.373 [MCA] ---
14:35:15.374 [IST]   status:
14:35:15.379 [MCA] current_action:
14:35:15.381 [IST]     value: 100
14:35:15.385 [MCA]   value: 11
14:35:15.390 [IST]   switch_ready: true
14:35:15.398 [IST] held_state:
14:35:15.399 [MCA] source: task_engine
14:35:15.404 [IST]   is_held: false
14:35:15.404 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.410 [IST]   hand_held: 0
14:35:15.410 [MCA] status:
14:35:15.416 [MCA]   value: 100
14:35:15.418 [IST] mode: 1
14:35:15.421 [MCA] switch_ready: false
14:35:15.423 [IST] mode_speed: 0.5
14:35:15.425 [MCA] ---
14:35:15.429 [IST] prohibition_broadcast_net: false
14:35:15.431 [MCA] current_action:
14:35:15.434 [IST] task_state:
14:35:15.439 [MCA]   value: 11
14:35:15.439 [IST]   task_type: 0
14:35:15.445 [IST]   task_stage: 0
14:35:15.445 [MCA] source: task_engine
14:35:15.452 [IST]   token:
14:35:15.454 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.459 [IST]     source: ''
14:35:15.462 [MCA] status:
14:35:15.465 [IST]     token: ''
14:35:15.470 [MCA]   value: 100
14:35:15.473 [IST] motion: ''
14:35:15.476 [MCA] switch_ready: false
14:35:15.480 [IST] percep_env_state: 0
14:35:15.482 [MCA] ---
14:35:15.486 [IST] ---
14:35:15.489 [MCA] current_action:
14:35:15.498 [MCA]   value: 11
14:35:15.498 [IST] header:
14:35:15.503 [MCA] source: task_engine
14:35:15.504 [IST]   stamp:
14:35:15.508 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.512 [IST]     sec: 0
14:35:15.518 [MCA] status:
14:35:15.519 [IST]     nanosec: 0
14:35:15.523 [MCA]   value: 100
14:35:15.524 [IST]   frame_id: ''
14:35:15.528 [MCA] switch_ready: false
14:35:15.529 [IST]   sequence: 0
14:35:15.533 [MCA] ---
14:35:15.534 [IST]   meas_stamp:
14:35:15.540 [IST]     sec: 0
14:35:15.540 [MCA] current_action:
14:35:15.545 [MCA]   value: 11
14:35:15.545 [IST]     nanosec: 0
14:35:15.554 [MCA] source: task_engine
14:35:15.556 [IST] interaction_id: 100
14:35:15.560 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.561 [IST] mp_state:
14:35:15.567 [IST]   value: 0
14:35:15.568 [MCA] status:
14:35:15.572 [IST] form_state:
14:35:15.573 [MCA]   value: 100
14:35:15.579 [IST]   current_form: 1
14:35:15.579 [MCA] switch_ready: false
14:35:15.585 [IST] action_info:
14:35:15.590 [IST]   current_action:
14:35:15.589 [MCA] ---
14:35:15.598 [MCA] current_action:
14:35:15.597 [IST]     value: 102
14:35:15.604 [IST]   source: task_engine
14:35:15.604 [MCA]   value: 11
14:35:15.610 [MCA] source: task_engine
14:35:15.610 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:15.616 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.617 [IST]   status:
14:35:15.621 [MCA] status:
14:35:15.621 [IST]     value: 100
14:35:15.625 [MCA]   value: 100
14:35:15.626 [IST]   switch_ready: true
14:35:15.630 [MCA] switch_ready: false
14:35:15.633 [IST] held_state:
14:35:15.634 [MCA] ---
14:35:15.637 [IST]   is_held: false
14:35:15.639 [MCA] current_action:
14:35:15.643 [IST]   hand_held: 0
14:35:15.644 [MCA]   value: 11
14:35:15.650 [IST] mode: 1
14:35:15.655 [MCA] source: task_engine
14:35:15.660 [IST] mode_speed: 0.5
14:35:15.660 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.667 [IST] prohibition_broadcast_net: false
14:35:15.667 [MCA] status:
14:35:15.673 [MCA]   value: 100
14:35:15.673 [IST] task_state:
14:35:15.678 [IST]   task_type: 0
14:35:15.679 [MCA] switch_ready: false
14:35:15.684 [IST]   task_stage: 0
14:35:15.689 [MCA] ---
14:35:15.695 [IST]   token:
14:35:15.698 [MCA] current_action:
14:35:15.702 [IST]     source: ''
14:35:15.705 [MCA]   value: 11
14:35:15.709 [IST]     token: ''
14:35:15.710 [MCA] source: task_engine
14:35:15.715 [IST] motion: ''
14:35:15.717 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.721 [IST] percep_env_state: 0
14:35:15.722 [MCA] status:
14:35:15.727 [IST] ---
14:35:15.728 [MCA]   value: 100
14:35:15.733 [MCA] switch_ready: false
14:35:15.733 [IST] header:
14:35:15.739 [MCA] ---
14:35:15.740 [IST]   stamp:
14:35:15.743 [MCA] current_action:
14:35:15.746 [IST]     sec: 0
14:35:15.750 [MCA]   value: 11
14:35:15.753 [IST]     nanosec: 0
14:35:15.757 [MCA] source: task_engine
14:35:15.761 [IST]   frame_id: ''
14:35:15.762 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.767 [IST]   sequence: 0
14:35:15.769 [MCA] status:
14:35:15.773 [IST]   meas_stamp:
14:35:15.774 [MCA]   value: 100
14:35:15.779 [MCA] switch_ready: false
14:35:15.780 [IST]     sec: 0
14:35:15.784 [MCA] ---
14:35:15.789 [IST]     nanosec: 0
14:35:15.794 [MCA] current_action:
14:35:15.795 [IST] interaction_id: 100
14:35:15.801 [IST] mp_state:
14:35:15.802 [MCA]   value: 11
14:35:15.808 [MCA] source: task_engine
14:35:15.809 [IST]   value: 0
14:35:15.814 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.817 [IST] form_state:
14:35:15.819 [MCA] status:
14:35:15.824 [IST]   current_form: 1
14:35:15.824 [MCA]   value: 100
14:35:15.829 [IST] action_info:
14:35:15.833 [MCA] switch_ready: false
14:35:15.835 [IST]   current_action:
14:35:15.838 [MCA] ---
14:35:15.840 [IST]     value: 102
14:35:15.845 [IST]   source: task_engine
14:35:15.845 [MCA] current_action:
14:35:15.851 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:15.852 [MCA]   value: 11
14:35:15.857 [IST]   status:
14:35:15.858 [MCA] source: task_engine
14:35:15.863 [IST]     value: 100
14:35:15.867 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.870 [IST]   switch_ready: true
14:35:15.872 [MCA] status:
14:35:15.876 [IST] held_state:
14:35:15.877 [MCA]   value: 100
14:35:15.882 [IST]   is_held: false
14:35:15.882 [MCA] switch_ready: false
14:35:15.888 [MCA] ---
14:35:15.892 [IST]   hand_held: 0
14:35:15.902 [IST] mode: 1
14:35:15.906 [MCA] current_action:
14:35:15.911 [IST] mode_speed: 0.5
14:35:15.914 [MCA]   value: 11
14:35:15.917 [IST] prohibition_broadcast_net: false
14:35:15.920 [MCA] source: task_engine
14:35:15.922 [IST] task_state:
14:35:15.925 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.929 [IST]   task_type: 0
14:35:15.930 [MCA] status:
14:35:15.935 [IST]   task_stage: 0
14:35:15.938 [MCA]   value: 100
14:35:15.942 [IST]   token:
14:35:15.943 [MCA] switch_ready: false
14:35:15.950 [MCA] ---
14:35:15.955 [IST]     source: ''
14:35:15.956 [MCA] current_action:
14:35:15.961 [IST]     token: ''
14:35:15.962 [MCA]   value: 11
14:35:15.968 [IST] motion: ''
14:35:15.968 [MCA] source: task_engine
14:35:15.973 [IST] percep_env_state: 0
14:35:15.973 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:15.978 [MCA] status:
14:35:15.978 [IST] ---
14:35:15.985 [MCA]   value: 100
14:35:15.985 [IST] header:
14:35:15.995 [IST]   stamp:
14:35:15.997 [MCA] switch_ready: false
14:35:16.001 [IST]     sec: 0
14:35:16.001 [MCA] ---
14:35:16.006 [IST]     nanosec: 0
14:35:16.009 [MCA] current_action:
14:35:16.012 [IST]   frame_id: ''
14:35:16.016 [MCA]   value: 11
14:35:16.017 [IST]   sequence: 0
14:35:16.021 [MCA] source: task_engine
14:35:16.022 [IST]   meas_stamp:
14:35:16.027 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.027 [IST]     sec: 0
14:35:16.032 [MCA] status:
14:35:16.033 [IST]     nanosec: 0
14:35:16.037 [MCA]   value: 100
14:35:16.038 [IST] interaction_id: 100
14:35:16.041 [MCA] switch_ready: false
14:35:16.044 [IST] mp_state:
14:35:16.049 [MCA] ---
14:35:16.049 [IST]   value: 0
14:35:16.057 [IST] form_state:
14:35:16.061 [MCA] current_action:
14:35:16.063 [IST]   current_form: 1
14:35:16.067 [MCA]   value: 11
14:35:16.070 [IST] action_info:
14:35:16.073 [MCA] source: task_engine
14:35:16.075 [IST]   current_action:
14:35:16.080 [IST]     value: 102
14:35:16.079 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.088 [MCA] status:
14:35:16.092 [IST]   source: task_engine
14:35:16.097 [MCA]   value: 100
14:35:16.099 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:16.103 [MCA] switch_ready: false
14:35:16.104 [IST]   status:
14:35:16.109 [IST]     value: 100
14:35:16.109 [MCA] ---
14:35:16.115 [MCA] current_action:
14:35:16.115 [IST]   switch_ready: true
14:35:16.120 [MCA]   value: 11
14:35:16.120 [IST] held_state:
14:35:16.124 [MCA] source: task_engine
14:35:16.124 [IST]   is_held: false
14:35:16.130 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.130 [IST]   hand_held: 0
14:35:16.134 [MCA] status:
14:35:16.136 [IST] mode: 1
14:35:16.140 [MCA]   value: 100
14:35:16.141 [IST] mode_speed: 0.5
14:35:16.145 [MCA] switch_ready: false
14:35:16.146 [IST] prohibition_broadcast_net: false
14:35:16.153 [MCA] ---
14:35:16.155 [IST] task_state:
14:35:16.161 [MCA] current_action:
14:35:16.161 [IST]   task_type: 0
14:35:16.167 [MCA]   value: 11
14:35:16.169 [IST]   task_stage: 0
14:35:16.173 [MCA] source: task_engine
14:35:16.174 [IST]   token:
14:35:16.180 [IST]     source: ''
14:35:16.181 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.187 [MCA] status:
14:35:16.194 [IST]     token: ''
14:35:16.197 [MCA]   value: 100
14:35:16.202 [MCA] switch_ready: false
14:35:16.202 [IST] motion: ''
14:35:16.210 [MCA] ---
14:35:16.210 [IST] percep_env_state: 0
14:35:16.217 [IST] ---
14:35:16.217 [MCA] current_action:
14:35:16.222 [IST] header:
14:35:16.223 [MCA]   value: 11
14:35:16.228 [IST]   stamp:
14:35:16.229 [MCA] source: task_engine
14:35:16.234 [IST]     sec: 0
14:35:16.234 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.239 [IST]     nanosec: 0
14:35:16.239 [MCA] status:
14:35:16.246 [IST]   frame_id: ''
14:35:16.247 [MCA]   value: 100
14:35:16.254 [MCA] switch_ready: false
14:35:16.256 [IST]   sequence: 0
14:35:16.260 [MCA] ---
14:35:16.262 [IST]   meas_stamp:
14:35:16.266 [MCA] current_action:
14:35:16.268 [IST]     sec: 0
14:35:16.273 [IST]     nanosec: 0
14:35:16.273 [MCA]   value: 11
14:35:16.279 [IST] interaction_id: 100
14:35:16.279 [MCA] source: task_engine
14:35:16.285 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.285 [IST] mp_state:
14:35:16.291 [IST]   value: 0
14:35:16.297 [MCA] status:
14:35:16.302 [IST] form_state:
14:35:16.303 [MCA]   value: 100
14:35:16.308 [IST]   current_form: 1
14:35:16.310 [MCA] switch_ready: false
14:35:16.313 [IST] action_info:
14:35:16.318 [MCA] ---
14:35:16.319 [IST]   current_action:
14:35:16.322 [MCA] current_action:
14:35:16.324 [IST]     value: 102
14:35:16.328 [MCA]   value: 11
14:35:16.329 [IST]   source: task_engine
14:35:16.332 [MCA] source: task_engine
14:35:16.335 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:16.337 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.340 [IST]   status:
14:35:16.343 [MCA] status:
14:35:16.346 [IST]     value: 100
14:35:16.349 [MCA]   value: 100
14:35:16.355 [MCA] switch_ready: false
14:35:16.359 [IST]   switch_ready: true
14:35:16.361 [MCA] ---
14:35:16.367 [IST] held_state:
14:35:16.370 [MCA] current_action:
14:35:16.373 [IST]   is_held: false
14:35:16.377 [MCA]   value: 11
14:35:16.378 [IST]   hand_held: 0
14:35:16.383 [MCA] source: task_engine
14:35:16.393 [IST] mode: 1
14:35:16.398 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.400 [IST] mode_speed: 0.5
14:35:16.404 [MCA] status:
14:35:16.410 [MCA]   value: 100
14:35:16.414 [IST] prohibition_broadcast_net: false
14:35:16.417 [MCA] switch_ready: false
14:35:16.419 [IST] task_state:
14:35:16.422 [MCA] ---
14:35:16.424 [IST]   task_type: 0
14:35:16.427 [MCA] current_action:
14:35:16.429 [IST]   task_stage: 0
14:35:16.432 [MCA]   value: 11
14:35:16.434 [IST]   token:
14:35:16.439 [MCA] source: task_engine
14:35:16.439 [IST]     source: ''
14:35:16.444 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.445 [IST]     token: ''
14:35:16.449 [MCA] status:
14:35:16.451 [IST] motion: ''
14:35:16.456 [IST] percep_env_state: 0
14:35:16.457 [MCA]   value: 100
14:35:16.462 [MCA] switch_ready: false
14:35:16.463 [IST] ---
14:35:16.468 [MCA] ---
14:35:16.470 [IST] header:
14:35:16.474 [MCA] current_action:
14:35:16.476 [IST]   stamp:
14:35:16.479 [MCA]   value: 11
14:35:16.482 [IST]     sec: 0
14:35:16.485 [MCA] source: task_engine
14:35:16.500 [IST]     nanosec: 0
14:35:16.502 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.509 [IST]   frame_id: ''
14:35:16.511 [MCA] status:
14:35:16.514 [IST]   sequence: 0
14:35:16.519 [IST]   meas_stamp:
14:35:16.519 [MCA]   value: 100
14:35:16.524 [IST]     sec: 0
14:35:16.524 [MCA] switch_ready: false
14:35:16.528 [IST]     nanosec: 0
14:35:16.529 [MCA] ---
14:35:16.533 [IST] interaction_id: 100
14:35:16.534 [MCA] current_action:
14:35:16.540 [MCA]   value: 11
14:35:16.541 [IST] mp_state:
14:35:16.545 [MCA] source: task_engine
14:35:16.550 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.553 [IST]   value: 0
14:35:16.559 [IST] form_state:
14:35:16.561 [MCA] status:
14:35:16.565 [IST]   current_form: 1
14:35:16.569 [MCA]   value: 100
14:35:16.571 [IST] action_info:
14:35:16.574 [MCA] switch_ready: false
14:35:16.578 [IST]   current_action:
14:35:16.579 [MCA] ---
14:35:16.583 [IST]     value: 102
14:35:16.589 [IST]   source: task_engine
14:35:16.589 [MCA] current_action:
14:35:16.596 [MCA]   value: 11
14:35:16.601 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:16.607 [IST]   status:
14:35:16.603 [MCA] source: task_engine
14:35:16.612 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.612 [IST]     value: 100
14:35:16.618 [MCA] status:
14:35:16.618 [IST]   switch_ready: true
14:35:16.623 [MCA]   value: 100
14:35:16.623 [IST] held_state:
14:35:16.628 [MCA] switch_ready: false
14:35:16.629 [IST]   is_held: false
14:35:16.633 [IST]   hand_held: 0
14:35:16.634 [MCA] ---
14:35:16.638 [MCA] current_action:
14:35:16.638 [IST] mode: 1
14:35:16.643 [MCA]   value: 11
14:35:16.643 [IST] mode_speed: 0.5
14:35:16.648 [MCA] source: task_engine
14:35:16.651 [IST] prohibition_broadcast_net: false
14:35:16.657 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.659 [IST] task_state:
14:35:16.664 [IST]   task_type: 0
14:35:16.665 [MCA] status:
14:35:16.670 [MCA]   value: 100
14:35:16.671 [IST]   task_stage: 0
14:35:16.676 [MCA] switch_ready: false
14:35:16.677 [IST]   token:
14:35:16.681 [MCA] ---
14:35:16.682 [IST]     source: ''
14:35:16.694 [MCA] current_action:
14:35:16.699 [IST]     token: ''
14:35:16.700 [MCA]   value: 11
14:35:16.705 [MCA] source: task_engine
14:35:16.706 [IST] motion: ''
14:35:16.710 [IST] percep_env_state: 0
14:35:16.710 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.716 [IST] ---
14:35:16.718 [MCA] status:
14:35:16.721 [IST] header:
14:35:16.723 [MCA]   value: 100
14:35:16.726 [IST]   stamp:
14:35:16.727 [MCA] switch_ready: false
14:35:16.731 [IST]     sec: 0
14:35:16.733 [MCA] ---
14:35:16.738 [IST]     nanosec: 0
14:35:16.738 [MCA] current_action:
14:35:16.742 [IST]   frame_id: ''
14:35:16.743 [MCA]   value: 11
14:35:16.750 [IST]   sequence: 0
14:35:16.755 [MCA] source: task_engine
14:35:16.756 [IST]   meas_stamp:
14:35:16.761 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.762 [IST]     sec: 0
14:35:16.768 [IST]     nanosec: 0
14:35:16.768 [MCA] status:
14:35:16.775 [MCA]   value: 100
14:35:16.775 [IST] interaction_id: 100
14:35:16.780 [MCA] switch_ready: false
14:35:16.781 [IST] mp_state:
14:35:16.788 [IST]   value: 0
14:35:16.790 [MCA] ---
14:35:16.796 [IST] form_state:
14:35:16.796 [MCA] current_action:
14:35:16.802 [IST]   current_form: 1
14:35:16.803 [MCA]   value: 11
14:35:16.808 [IST] action_info:
14:35:16.809 [MCA] source: task_engine
14:35:16.814 [IST]   current_action:
14:35:16.814 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.819 [MCA] status:
14:35:16.819 [IST]     value: 102
14:35:16.823 [MCA]   value: 100
14:35:16.824 [IST]   source: task_engine
14:35:16.828 [MCA] switch_ready: false
14:35:16.830 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:16.834 [MCA] ---
14:35:16.836 [IST]   status:
14:35:16.840 [MCA] current_action:
14:35:16.842 [IST]     value: 100
14:35:16.844 [MCA]   value: 11
14:35:16.850 [IST]   switch_ready: true
14:35:16.850 [MCA] source: task_engine
14:35:16.858 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.859 [IST] held_state:
14:35:16.863 [MCA] status:
14:35:16.866 [IST]   is_held: false
14:35:16.868 [MCA]   value: 100
14:35:16.873 [IST]   hand_held: 0
14:35:16.873 [MCA] switch_ready: false
14:35:16.878 [IST] mode: 1
14:35:16.879 [MCA] ---
14:35:16.885 [MCA] current_action:
14:35:16.883 [IST] mode_speed: 0.5
14:35:16.894 [IST] prohibition_broadcast_net: false
14:35:16.897 [MCA]   value: 11
14:35:16.900 [IST] task_state:
14:35:16.905 [IST]   task_type: 0
14:35:16.908 [MCA] source: task_engine
14:35:16.910 [IST]   task_stage: 0
14:35:16.913 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.915 [IST]   token:
14:35:16.918 [MCA] status:
14:35:16.920 [IST]     source: ''
14:35:16.925 [IST]     token: ''
14:35:16.925 [MCA]   value: 100
14:35:16.929 [MCA] switch_ready: false
14:35:16.930 [IST] motion: ''
14:35:16.934 [MCA] ---
14:35:16.936 [IST] percep_env_state: 0
14:35:16.938 [MCA] current_action:
14:35:16.942 [IST] ---
14:35:16.943 [MCA]   value: 11
14:35:16.948 [IST] header:
14:35:16.950 [MCA] source: task_engine
14:35:16.955 [IST]   stamp:
14:35:16.958 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:16.962 [IST]     sec: 0
14:35:16.964 [MCA] status:
14:35:16.969 [IST]     nanosec: 0
14:35:16.970 [MCA]   value: 100
14:35:16.974 [IST]   frame_id: ''
14:35:16.977 [MCA] switch_ready: false
14:35:16.981 [IST]   sequence: 0
14:35:16.982 [MCA] ---
14:35:16.995 [MCA] current_action:
14:35:16.995 [IST]   meas_stamp:
14:35:17.001 [IST]     sec: 0
14:35:17.002 [MCA]   value: 11
14:35:17.008 [IST]     nanosec: 0
14:35:17.009 [MCA] source: task_engine
14:35:17.013 [IST] interaction_id: 100
14:35:17.014 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.018 [IST] mp_state:
14:35:17.019 [MCA] status:
14:35:17.025 [MCA]   value: 100
14:35:17.024 [IST]   value: 0
14:35:17.030 [MCA] switch_ready: false
14:35:17.030 [IST] form_state:
14:35:17.035 [IST]   current_form: 1
14:35:17.035 [MCA] ---
14:35:17.040 [IST] action_info:
14:35:17.040 [MCA] current_action:
14:35:17.045 [IST]   current_action:
14:35:17.045 [MCA]   value: 11
14:35:17.052 [IST]     value: 102
14:35:17.056 [MCA] source: task_engine
14:35:17.059 [IST]   source: task_engine
14:35:17.061 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.065 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:17.068 [MCA] status:
14:35:17.070 [IST]   status:
14:35:17.073 [MCA]   value: 100
14:35:17.076 [IST]     value: 100
14:35:17.078 [MCA] switch_ready: false
14:35:17.082 [IST]   switch_ready: true
14:35:17.083 [MCA] ---
14:35:17.089 [IST] held_state:
14:35:17.095 [IST]   is_held: false
14:35:17.096 [MCA] current_action:
14:35:17.104 [IST]   hand_held: 0
14:35:17.105 [MCA]   value: 11
14:35:17.110 [IST] mode: 1
14:35:17.111 [MCA] source: task_engine
14:35:17.115 [IST] mode_speed: 0.5
14:35:17.117 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.121 [MCA] status:
14:35:17.121 [IST] prohibition_broadcast_net: false
14:35:17.126 [MCA]   value: 100
14:35:17.127 [IST] task_state:
14:35:17.131 [MCA] switch_ready: false
14:35:17.133 [IST]   task_type: 0
14:35:17.136 [MCA] ---
14:35:17.138 [IST]   task_stage: 0
14:35:17.141 [MCA] current_action:
14:35:17.143 [IST]   token:
14:35:17.147 [MCA]   value: 11
14:35:17.150 [IST]     source: ''
14:35:17.153 [MCA] source: task_engine
14:35:17.157 [IST]     token: ''
14:35:17.160 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.163 [IST] motion: ''
14:35:17.166 [MCA] status:
14:35:17.170 [IST] percep_env_state: 0
14:35:17.172 [MCA]   value: 100
14:35:17.176 [IST] ---
14:35:17.177 [MCA] switch_ready: false
14:35:17.182 [IST] header:
14:35:17.182 [MCA] ---
14:35:17.193 [IST]   stamp:
14:35:17.197 [MCA] current_action:
14:35:17.201 [IST]     sec: 0
14:35:17.204 [MCA]   value: 11
14:35:17.208 [IST]     nanosec: 0
14:35:17.210 [MCA] source: task_engine
14:35:17.213 [IST]   frame_id: ''
14:35:17.216 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.220 [IST]   sequence: 0
14:35:17.221 [MCA] status:
14:35:17.226 [IST]   meas_stamp:
14:35:17.226 [MCA]   value: 100
14:35:17.233 [IST]     sec: 0
14:35:17.233 [MCA] switch_ready: false
14:35:17.238 [IST]     nanosec: 0
14:35:17.238 [MCA] ---
14:35:17.243 [MCA] current_action:
14:35:17.244 [IST] interaction_id: 100
14:35:17.250 [MCA]   value: 11
14:35:17.254 [IST] mp_state:
14:35:17.258 [MCA] source: task_engine
14:35:17.261 [IST]   value: 0
14:35:17.264 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.268 [IST] form_state:
14:35:17.270 [MCA] status:
14:35:17.274 [IST]   current_form: 1
14:35:17.275 [MCA]   value: 100
14:35:17.279 [IST] action_info:
14:35:17.281 [MCA] switch_ready: false
14:35:17.285 [IST]   current_action:
14:35:17.291 [MCA] ---
14:35:17.293 [IST]     value: 102
14:35:17.297 [MCA] current_action:
14:35:17.299 [IST]   source: task_engine
14:35:17.303 [MCA]   value: 11
14:35:17.306 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:17.309 [MCA] source: task_engine
14:35:17.311 [IST]   status:
14:35:17.315 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.319 [IST]     value: 100
14:35:17.320 [MCA] status:
14:35:17.324 [IST]   switch_ready: true
14:35:17.326 [MCA]   value: 100
14:35:17.330 [IST] held_state:
14:35:17.330 [MCA] switch_ready: false
14:35:17.337 [MCA] ---
14:35:17.339 [IST]   is_held: false
14:35:17.342 [MCA] current_action:
14:35:17.345 [IST]   hand_held: 0
14:35:17.349 [MCA]   value: 11
14:35:17.352 [IST] mode: 1
14:35:17.356 [MCA] source: task_engine
14:35:17.359 [IST] mode_speed: 0.5
14:35:17.361 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.366 [IST] prohibition_broadcast_net: false
14:35:17.366 [MCA] status:
14:35:17.374 [IST] task_state:
14:35:17.374 [MCA]   value: 100
14:35:17.379 [IST]   task_type: 0
14:35:17.382 [MCA] switch_ready: false
14:35:17.384 [IST]   task_stage: 0
14:35:17.391 [MCA] ---
14:35:17.393 [IST]   token:
14:35:17.397 [MCA] current_action:
14:35:17.398 [IST]     source: ''
14:35:17.404 [IST]     token: ''
14:35:17.404 [MCA]   value: 11
14:35:17.409 [IST] motion: ''
14:35:17.410 [MCA] source: task_engine
14:35:17.415 [IST] percep_env_state: 0
14:35:17.416 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.419 [IST] ---
14:35:17.421 [MCA] status:
14:35:17.424 [IST] header:
14:35:17.425 [MCA]   value: 100
14:35:17.429 [IST]   stamp:
14:35:17.430 [MCA] switch_ready: false
14:35:17.436 [IST]     sec: 0
14:35:17.436 [MCA] ---
14:35:17.441 [MCA] current_action:
14:35:17.442 [IST]     nanosec: 0
14:35:17.446 [MCA]   value: 11
14:35:17.448 [IST]   frame_id: ''
14:35:17.453 [MCA] source: task_engine
14:35:17.458 [IST]   sequence: 0
14:35:17.461 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.464 [IST]   meas_stamp:
14:35:17.467 [MCA] status:
14:35:17.470 [IST]     sec: 0
14:35:17.473 [MCA]   value: 100
14:35:17.475 [IST]     nanosec: 0
14:35:17.477 [MCA] switch_ready: false
14:35:17.480 [IST] interaction_id: 100
14:35:17.482 [MCA] ---
14:35:17.492 [IST] mp_state:
14:35:17.493 [MCA] current_action:
14:35:17.499 [IST]   value: 0
14:35:17.500 [MCA]   value: 11
14:35:17.505 [IST] form_state:
14:35:17.506 [MCA] source: task_engine
14:35:17.511 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.511 [IST]   current_form: 1
14:35:17.516 [MCA] status:
14:35:17.519 [IST] action_info:
14:35:17.521 [MCA]   value: 100
14:35:17.524 [IST]   current_action:
14:35:17.527 [MCA] switch_ready: false
14:35:17.530 [IST]     value: 102
14:35:17.533 [MCA] ---
14:35:17.537 [IST]   source: task_engine
14:35:17.538 [MCA] current_action:
14:35:17.542 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:17.542 [MCA]   value: 11
14:35:17.548 [IST]   status:
14:35:17.548 [MCA] source: task_engine
14:35:17.555 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.558 [IST]     value: 100
14:35:17.561 [MCA] status:
14:35:17.566 [MCA]   value: 100
14:35:17.566 [IST]   switch_ready: true
14:35:17.571 [MCA] switch_ready: false
14:35:17.571 [IST] held_state:
14:35:17.576 [MCA] ---
14:35:17.576 [IST]   is_held: false
14:35:17.582 [MCA] current_action:
14:35:17.583 [IST]   hand_held: 0
14:35:17.594 [MCA]   value: 11
14:35:17.599 [MCA] source: task_engine
14:35:17.601 [IST] mode: 1
14:35:17.606 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.608 [IST] mode_speed: 0.5
14:35:17.612 [MCA] status:
14:35:17.613 [IST] prohibition_broadcast_net: false
14:35:17.619 [IST] task_state:
14:35:17.619 [MCA]   value: 100
14:35:17.623 [MCA] switch_ready: false
14:35:17.624 [IST]   task_type: 0
14:35:17.629 [MCA] ---
14:35:17.629 [IST]   task_stage: 0
14:35:17.634 [MCA] current_action:
14:35:17.635 [IST]   token:
14:35:17.641 [IST]     source: ''
14:35:17.640 [MCA]   value: 11
14:35:17.646 [IST]     token: ''
14:35:17.650 [MCA] source: task_engine
14:35:17.653 [IST] motion: ''
14:35:17.657 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.661 [IST] percep_env_state: 0
14:35:17.662 [MCA] status:
14:35:17.670 [MCA]   value: 100
14:35:17.666 [IST] ---
14:35:17.675 [IST] header:
14:35:17.676 [MCA] switch_ready: false
14:35:17.681 [MCA] ---
14:35:17.682 [IST]   stamp:
14:35:17.693 [IST]     sec: 0
14:35:17.693 [MCA] current_action:
14:35:17.700 [IST]     nanosec: 0
14:35:17.701 [MCA]   value: 11
14:35:17.707 [IST]   frame_id: ''
14:35:17.707 [MCA] source: task_engine
14:35:17.713 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.718 [MCA] status:
14:35:17.718 [IST]   sequence: 0
14:35:17.724 [IST]   meas_stamp:
14:35:17.724 [MCA]   value: 100
14:35:17.729 [MCA] switch_ready: false
14:35:17.729 [IST]     sec: 0
14:35:17.734 [MCA] ---
14:35:17.735 [IST]     nanosec: 0
14:35:17.740 [MCA] current_action:
14:35:17.741 [IST] interaction_id: 100
14:35:17.745 [MCA]   value: 11
14:35:17.747 [IST] mp_state:
14:35:17.752 [MCA] source: task_engine
14:35:17.752 [IST]   value: 0
14:35:17.759 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.759 [IST] form_state:
14:35:17.767 [IST]   current_form: 1
14:35:17.768 [MCA] status:
14:35:17.772 [IST] action_info:
14:35:17.773 [MCA]   value: 100
14:35:17.778 [MCA] switch_ready: false
14:35:17.779 [IST]   current_action:
14:35:17.785 [IST]     value: 102
14:35:17.784 [MCA] ---
14:35:17.796 [MCA] current_action:
14:35:17.797 [IST]   source: task_engine
14:35:17.804 [MCA]   value: 11
14:35:17.806 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:17.809 [MCA] source: task_engine
14:35:17.812 [IST]   status:
14:35:17.816 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.819 [IST]     value: 100
14:35:17.822 [MCA] status:
14:35:17.825 [IST]   switch_ready: true
14:35:17.827 [MCA]   value: 100
14:35:17.832 [IST] held_state:
14:35:17.832 [MCA] switch_ready: false
14:35:17.837 [IST]   is_held: false
14:35:17.840 [MCA] ---
14:35:17.842 [IST]   hand_held: 0
14:35:17.849 [IST] mode: 1
14:35:17.854 [MCA] current_action:
14:35:17.856 [IST] mode_speed: 0.5
14:35:17.861 [MCA]   value: 11
14:35:17.862 [IST] prohibition_broadcast_net: false
14:35:17.868 [MCA] source: task_engine
14:35:17.868 [IST] task_state:
14:35:17.874 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.876 [IST]   task_type: 0
14:35:17.881 [IST]   task_stage: 0
14:35:17.882 [MCA] status:
14:35:17.891 [IST]   token:
14:35:17.891 [MCA]   value: 100
14:35:17.897 [MCA] switch_ready: false
14:35:17.897 [IST]     source: ''
14:35:17.902 [IST]     token: ''
14:35:17.904 [MCA] ---
14:35:17.910 [IST] motion: ''
14:35:17.910 [MCA] current_action:
14:35:17.916 [MCA]   value: 11
14:35:17.917 [IST] percep_env_state: 0
14:35:17.921 [MCA] source: task_engine
14:35:17.922 [IST] ---
14:35:17.925 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.927 [IST] header:
14:35:17.930 [MCA] status:
14:35:17.933 [IST]   stamp:
14:35:17.936 [MCA]   value: 100
14:35:17.938 [IST]     sec: 0
14:35:17.942 [IST]     nanosec: 0
14:35:17.943 [MCA] switch_ready: false
14:35:17.948 [IST]   frame_id: ''
14:35:17.952 [MCA] ---
14:35:17.955 [IST]   sequence: 0
14:35:17.959 [MCA] current_action:
14:35:17.961 [IST]   meas_stamp:
14:35:17.967 [MCA]   value: 11
14:35:17.968 [IST]     sec: 0
14:35:17.973 [MCA] source: task_engine
14:35:17.974 [IST]     nanosec: 0
14:35:17.979 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:17.980 [IST] interaction_id: 100
14:35:17.987 [IST] mp_state:
14:35:17.992 [MCA] status:
14:35:17.995 [IST]   value: 0
14:35:18.001 [MCA]   value: 100
14:35:18.002 [IST] form_state:
14:35:18.008 [IST]   current_form: 1
14:35:18.008 [MCA] switch_ready: false
14:35:18.014 [IST] action_info:
14:35:18.017 [MCA] ---
14:35:18.023 [IST]   current_action:
14:35:18.023 [MCA] current_action:
14:35:18.028 [MCA]   value: 11
14:35:18.030 [IST]     value: 102
14:35:18.033 [MCA] source: task_engine
14:35:18.035 [IST]   source: task_engine
14:35:18.038 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.041 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:18.043 [MCA] status:
14:35:18.046 [IST]   status:
14:35:18.047 [MCA]   value: 100
14:35:18.052 [IST]     value: 100
14:35:18.057 [MCA] switch_ready: false
14:35:18.059 [IST]   switch_ready: true
14:35:18.063 [MCA] ---
14:35:18.066 [IST] held_state:
14:35:18.070 [MCA] current_action:
14:35:18.073 [IST]   is_held: false
14:35:18.077 [MCA]   value: 11
14:35:18.078 [IST]   hand_held: 0
14:35:18.084 [IST] mode: 1
14:35:18.085 [MCA] source: task_engine
14:35:18.093 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.099 [MCA] status:
14:35:18.096 [IST] mode_speed: 0.5
14:35:18.104 [MCA]   value: 100
14:35:18.106 [IST] prohibition_broadcast_net: false
14:35:18.110 [MCA] switch_ready: false
14:35:18.115 [MCA] ---
14:35:18.114 [IST] task_state:
14:35:18.120 [MCA] current_action:
14:35:18.121 [IST]   task_type: 0
14:35:18.124 [MCA]   value: 11
14:35:18.126 [IST]   task_stage: 0
14:35:18.129 [MCA] source: task_engine
14:35:18.130 [IST]   token:
14:35:18.134 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.139 [IST]     source: ''
14:35:18.140 [MCA] status:
14:35:18.145 [MCA]   value: 100
14:35:18.145 [IST]     token: ''
14:35:18.151 [IST] motion: ''
14:35:18.151 [MCA] switch_ready: false
14:35:18.158 [IST] percep_env_state: 0
14:35:18.160 [MCA] ---
14:35:18.163 [IST] ---
14:35:18.166 [MCA] current_action:
14:35:18.169 [IST] header:
14:35:18.171 [MCA]   value: 11
14:35:18.176 [IST]   stamp:
14:35:18.177 [MCA] source: task_engine
14:35:18.182 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.183 [IST]     sec: 0
14:35:18.194 [IST]     nanosec: 0
14:35:18.197 [MCA] status:
14:35:18.202 [IST]   frame_id: ''
14:35:18.205 [MCA]   value: 100
14:35:18.209 [IST]   sequence: 0
14:35:18.211 [MCA] switch_ready: false
14:35:18.216 [IST]   meas_stamp:
14:35:18.218 [MCA] ---
14:35:18.221 [IST]     sec: 0
14:35:18.223 [MCA] current_action:
14:35:18.228 [IST]     nanosec: 0
14:35:18.228 [MCA]   value: 11
14:35:18.234 [IST] interaction_id: 100
14:35:18.235 [MCA] source: task_engine
14:35:18.239 [IST] mp_state:
14:35:18.241 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.249 [IST]   value: 0
14:35:18.252 [MCA] status:
14:35:18.260 [MCA]   value: 100
14:35:18.261 [IST] form_state:
14:35:18.265 [MCA] switch_ready: false
14:35:18.268 [IST]   current_form: 1
14:35:18.272 [MCA] ---
14:35:18.275 [IST] action_info:
14:35:18.278 [MCA] current_action:
14:35:18.281 [IST]   current_action:
14:35:18.283 [MCA]   value: 11
14:35:18.293 [IST]     value: 102
14:35:18.298 [MCA] source: task_engine
14:35:18.299 [IST]   source: task_engine
14:35:18.305 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:18.308 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.309 [IST]   status:
14:35:18.314 [MCA] status:
14:35:18.314 [IST]     value: 100
14:35:18.319 [IST]   switch_ready: true
14:35:18.319 [MCA]   value: 100
14:35:18.324 [IST] held_state:
14:35:18.325 [MCA] switch_ready: false
14:35:18.329 [IST]   is_held: false
14:35:18.329 [MCA] ---
14:35:18.334 [IST]   hand_held: 0
14:35:18.334 [MCA] current_action:
14:35:18.338 [IST] mode: 1
14:35:18.339 [MCA]   value: 11
14:35:18.343 [IST] mode_speed: 0.5
14:35:18.344 [MCA] source: task_engine
14:35:18.349 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.353 [IST] prohibition_broadcast_net: false
14:35:18.357 [MCA] status:
14:35:18.360 [IST] task_state:
14:35:18.364 [MCA]   value: 100
14:35:18.367 [IST]   task_type: 0
14:35:18.369 [MCA] switch_ready: false
14:35:18.372 [IST]   task_stage: 0
14:35:18.374 [MCA] ---
14:35:18.378 [IST]   token:
14:35:18.379 [MCA] current_action:
14:35:18.383 [IST]     source: ''
14:35:18.390 [MCA]   value: 11
14:35:18.391 [IST]     token: ''
14:35:18.396 [MCA] source: task_engine
14:35:18.398 [IST] motion: ''
14:35:18.406 [IST] percep_env_state: 0
14:35:18.406 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.412 [IST] ---
14:35:18.413 [MCA] status:
14:35:18.418 [IST] header:
14:35:18.419 [MCA]   value: 100
14:35:18.423 [IST]   stamp:
14:35:18.423 [MCA] switch_ready: false
14:35:18.428 [IST]     sec: 0
14:35:18.429 [MCA] ---
14:35:18.433 [IST]     nanosec: 0
14:35:18.434 [MCA] current_action:
14:35:18.438 [MCA]   value: 11
14:35:18.439 [IST]   frame_id: ''
14:35:18.443 [MCA] source: task_engine
14:35:18.444 [IST]   sequence: 0
14:35:18.448 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.451 [IST]   meas_stamp:
14:35:18.454 [MCA] status:
14:35:18.456 [IST]     sec: 0
14:35:18.462 [IST]     nanosec: 0
14:35:18.466 [MCA]   value: 100
14:35:18.471 [IST] interaction_id: 100
14:35:18.474 [MCA] switch_ready: false
14:35:18.478 [IST] mp_state:
14:35:18.479 [MCA] ---
14:35:18.487 [IST]   value: 0
14:35:18.489 [MCA] current_action:
14:35:18.494 [IST] form_state:
14:35:18.495 [MCA]   value: 11
14:35:18.502 [IST]   current_form: 1
14:35:18.506 [MCA] source: task_engine
14:35:18.508 [IST] action_info:
14:35:18.513 [IST]   current_action:
14:35:18.514 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.519 [MCA] status:
14:35:18.519 [IST]     value: 102
14:35:18.524 [MCA]   value: 100
14:35:18.524 [IST]   source: task_engine
14:35:18.529 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:18.531 [MCA] switch_ready: false
14:35:18.535 [IST]   status:
14:35:18.535 [MCA] ---
14:35:18.540 [MCA] current_action:
14:35:18.541 [IST]     value: 100
14:35:18.545 [MCA]   value: 11
14:35:18.546 [IST]   switch_ready: true
14:35:18.554 [MCA] source: task_engine
14:35:18.557 [IST] held_state:
14:35:18.563 [IST]   is_held: false
14:35:18.565 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.568 [IST]   hand_held: 0
14:35:18.570 [MCA] status:
14:35:18.573 [IST] mode: 1
14:35:18.576 [MCA]   value: 100
14:35:18.579 [IST] mode_speed: 0.5
14:35:18.583 [MCA] switch_ready: false
14:35:18.595 [IST] prohibition_broadcast_net: false
14:35:18.597 [MCA] ---
14:35:18.602 [IST] task_state:
14:35:18.603 [MCA] current_action:
14:35:18.607 [IST]   task_type: 0
14:35:18.609 [MCA]   value: 11
14:35:18.613 [IST]   task_stage: 0
14:35:18.616 [MCA] source: task_engine
14:35:18.620 [IST]   token:
14:35:18.622 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.625 [IST]     source: ''
14:35:18.629 [MCA] status:
14:35:18.631 [IST]     token: ''
14:35:18.633 [MCA]   value: 100
14:35:18.636 [IST] motion: ''
14:35:18.638 [MCA] switch_ready: false
14:35:18.643 [IST] percep_env_state: 0
14:35:18.643 [MCA] ---
14:35:18.651 [MCA] current_action:
14:35:18.657 [MCA]   value: 11
14:35:18.658 [IST] ---
14:35:18.662 [MCA] source: task_engine
14:35:18.665 [IST] header:
14:35:18.670 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.671 [IST]   stamp:
14:35:18.675 [MCA] status:
14:35:18.678 [IST]     sec: 0
14:35:18.680 [MCA]   value: 100
14:35:18.683 [IST]     nanosec: 0
14:35:18.694 [MCA] switch_ready: false
14:35:18.696 [IST]   frame_id: ''
14:35:18.701 [IST]   sequence: 0
14:35:18.702 [MCA] ---
14:35:18.707 [MCA] current_action:
14:35:18.707 [IST]   meas_stamp:
14:35:18.714 [MCA]   value: 11
14:35:18.714 [IST]     sec: 0
14:35:18.719 [MCA] source: task_engine
14:35:18.720 [IST]     nanosec: 0
14:35:18.724 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.725 [IST] interaction_id: 100
14:35:18.729 [MCA] status:
14:35:18.730 [IST] mp_state:
14:35:18.734 [MCA]   value: 100
14:35:18.739 [IST]   value: 0
14:35:18.740 [MCA] switch_ready: false
14:35:18.744 [MCA] ---
14:35:18.744 [IST] form_state:
14:35:18.750 [MCA] current_action:
14:35:18.756 [IST]   current_form: 1
14:35:18.758 [MCA]   value: 11
14:35:18.762 [IST] action_info:
14:35:18.763 [MCA] source: task_engine
14:35:18.769 [IST]   current_action:
14:35:18.769 [MCA] action_desc: QUADRUPED_TO_BIPED_ROTATE
14:35:18.774 [IST]     value: 102
14:35:18.775 [MCA] status:
14:35:18.780 [IST]   source: task_engine
14:35:18.786 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:18.782 [MCA]   value: 100
14:35:18.794 [IST]   status:
14:35:18.796 [MCA] switch_ready: false
14:35:18.799 [IST]     value: 100
14:35:18.801 [MCA] ---
14:35:18.806 [MCA] current_action:
14:35:18.807 [IST]   switch_ready: true
14:35:18.811 [MCA]   value: 300
14:35:18.813 [IST] held_state:
14:35:18.817 [MCA] source: task_engine
14:35:18.821 [IST]   is_held: false
14:35:18.822 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:18.826 [IST]   hand_held: 0
14:35:18.827 [MCA] status:
14:35:18.832 [IST] mode: 1
14:35:18.834 [MCA]   value: 100
14:35:18.838 [IST] mode_speed: 0.5
14:35:18.842 [MCA] switch_ready: true
14:35:18.843 [IST] prohibition_broadcast_net: false
14:35:18.848 [MCA] ---
14:35:18.849 [IST] task_state:
14:35:18.854 [MCA] current_action:
14:35:18.859 [IST]   task_type: 0
14:35:18.860 [MCA]   value: 300
14:35:18.865 [IST]   task_stage: 0
14:35:18.867 [MCA] source: task_engine
14:35:18.873 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:18.873 [IST]   token:
14:35:18.878 [IST]     source: ''
14:35:18.879 [MCA] status:
14:35:18.888 [IST]     token: ''
14:35:18.890 [MCA]   value: 100
14:35:18.894 [IST] motion: ''
14:35:18.898 [MCA] switch_ready: true
14:35:18.902 [IST] percep_env_state: 0
14:35:18.907 [MCA] ---
14:35:18.908 [IST] ---
14:35:18.913 [IST] header:
14:35:18.916 [MCA] current_action:
14:35:18.919 [IST]   stamp:
14:35:18.923 [MCA]   value: 300
14:35:18.926 [IST]     sec: 0
14:35:18.929 [MCA] source: task_engine
14:35:18.935 [IST]     nanosec: 0
14:35:18.935 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:18.940 [IST]   frame_id: ''
14:35:18.940 [MCA] status:
14:35:18.946 [IST]   sequence: 0
14:35:18.949 [MCA]   value: 100
14:35:18.953 [IST]   meas_stamp:
14:35:18.958 [MCA] switch_ready: true
14:35:18.961 [IST]     sec: 0
14:35:18.965 [MCA] ---
14:35:18.967 [IST]     nanosec: 0
14:35:18.971 [MCA] current_action:
14:35:18.973 [IST] interaction_id: 5
14:35:18.977 [MCA]   value: 300
14:35:18.980 [IST] mp_state:
14:35:18.982 [MCA] source: task_engine
14:35:18.990 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:18.995 [IST]   value: 0
14:35:19.000 [MCA] status:
14:35:19.003 [IST] form_state:
14:35:19.007 [MCA]   value: 100
14:35:19.009 [IST]   current_form: 1
14:35:19.012 [MCA] switch_ready: true
14:35:19.017 [MCA] ---
14:35:19.018 [IST] action_info:
14:35:19.022 [MCA] current_action:
14:35:19.023 [IST]   current_action:
14:35:19.028 [IST]     value: 102
14:35:19.028 [MCA]   value: 300
14:35:19.033 [MCA] source: task_engine
14:35:19.033 [IST]   source: task_engine
14:35:19.038 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.043 [MCA] status:
14:35:19.040 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:19.048 [MCA]   value: 100
14:35:19.051 [IST]   status:
14:35:19.054 [MCA] switch_ready: true
14:35:19.061 [IST]     value: 100
14:35:19.062 [MCA] ---
14:35:19.067 [IST]   switch_ready: true
14:35:19.067 [MCA] current_action:
14:35:19.073 [MCA]   value: 300
14:35:19.073 [IST] held_state:
14:35:19.079 [MCA] source: task_engine
14:35:19.079 [IST]   is_held: false
14:35:19.083 [IST]   hand_held: 0
14:35:19.089 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.091 [IST] mode: 1
14:35:19.097 [MCA] status:
14:35:19.098 [IST] mode_speed: 0.5
14:35:19.105 [MCA]   value: 100
14:35:19.105 [IST] prohibition_broadcast_net: false
14:35:19.110 [MCA] switch_ready: true
14:35:19.110 [IST] task_state:
14:35:19.116 [IST]   task_type: 0
14:35:19.117 [MCA] ---
14:35:19.121 [IST]   task_stage: 0
14:35:19.122 [MCA] current_action:
14:35:19.126 [MCA]   value: 300
14:35:19.127 [IST]   token:
14:35:19.131 [IST]     source: ''
14:35:19.133 [MCA] source: task_engine
14:35:19.138 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.138 [IST]     token: ''
14:35:19.143 [MCA] status:
14:35:19.143 [IST] motion: ''
14:35:19.148 [MCA]   value: 100
14:35:19.149 [IST] percep_env_state: 0
14:35:19.154 [MCA] switch_ready: true
14:35:19.157 [IST] ---
14:35:19.161 [MCA] ---
14:35:19.162 [IST] header:
14:35:19.166 [MCA] current_action:
14:35:19.167 [IST]   stamp:
14:35:19.172 [MCA]   value: 300
14:35:19.175 [IST]     sec: 0
14:35:19.177 [MCA] source: task_engine
14:35:19.184 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.191 [IST]     nanosec: 0
14:35:19.194 [MCA] status:
14:35:19.198 [IST]   frame_id: ''
14:35:19.200 [MCA]   value: 100
14:35:19.205 [IST]   sequence: 0
14:35:19.205 [MCA] switch_ready: true
14:35:19.211 [IST]   meas_stamp:
14:35:19.212 [MCA] ---
14:35:19.218 [MCA] current_action:
14:35:19.218 [IST]     sec: 0
14:35:19.222 [IST]     nanosec: 0
14:35:19.222 [MCA]   value: 300
14:35:19.228 [IST] interaction_id: 5
14:35:19.228 [MCA] source: task_engine
14:35:19.233 [IST] mp_state:
14:35:19.233 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.238 [MCA] status:
14:35:19.239 [IST]   value: 0
14:35:19.243 [MCA]   value: 100
14:35:19.244 [IST] form_state:
14:35:19.249 [MCA] switch_ready: true
14:35:19.249 [IST]   current_form: 1
14:35:19.256 [IST] action_info:
14:35:19.258 [MCA] ---
14:35:19.262 [IST]   current_action:
14:35:19.263 [MCA] current_action:
14:35:19.269 [MCA]   value: 300
14:35:19.269 [IST]     value: 102
14:35:19.274 [MCA] source: task_engine
14:35:19.274 [IST]   source: task_engine
14:35:19.280 [IST]   action_desc: QUADRUPED_LOCOMOTION_DEFAULT
14:35:19.287 [IST]   status:
14:35:19.288 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.295 [IST]     value: 100
14:35:19.298 [MCA] status:
14:35:19.300 [IST]   switch_ready: true
14:35:19.303 [MCA]   value: 100
14:35:19.306 [IST] held_state:
14:35:19.309 [MCA] switch_ready: true
14:35:19.311 [IST]   is_held: false
14:35:19.317 [IST]   hand_held: 0
14:35:19.317 [MCA] ---
14:35:19.322 [IST] mode: 1
14:35:19.322 [MCA] current_action:
14:35:19.326 [IST] mode_speed: 0.5
14:35:19.327 [MCA]   value: 300
14:35:19.332 [IST] prohibition_broadcast_net: false
14:35:19.332 [MCA] source: task_engine
14:35:19.337 [IST] task_state:
14:35:19.338 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.342 [IST]   task_type: 0
14:35:19.342 [MCA] status:
14:35:19.349 [IST]   task_stage: 0
14:35:19.356 [MCA]   value: 100
14:35:19.357 [IST]   token:
14:35:19.362 [MCA] switch_ready: true
14:35:19.363 [IST]     source: ''
14:35:19.367 [MCA] ---
14:35:19.370 [IST]     token: ''
14:35:19.373 [MCA] current_action:
14:35:19.375 [IST] motion: ''
14:35:19.379 [MCA]   value: 300
14:35:19.380 [IST] percep_env_state: 0
14:35:19.387 [MCA] source: task_engine
14:35:19.390 [IST] ---
14:35:19.396 [IST] header:
14:35:19.402 [IST]   stamp:
14:35:19.396 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.408 [IST]     sec: 0
14:35:19.411 [MCA] status:
14:35:19.413 [IST]     nanosec: 0
14:35:19.417 [MCA]   value: 100
14:35:19.421 [IST]   frame_id: ''
14:35:19.421 [MCA] switch_ready: true
14:35:19.426 [IST]   sequence: 0
14:35:19.426 [MCA] ---
14:35:19.431 [IST]   meas_stamp:
14:35:19.433 [MCA] current_action:
14:35:19.437 [IST]     sec: 0
14:35:19.438 [MCA]   value: 300
14:35:19.442 [IST]     nanosec: 0
14:35:19.443 [MCA] source: task_engine
14:35:19.451 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:35:19.452 [IST] interaction_id: 5
14:35:19.459 [IST] mp_state:
14:35:19.459 [MCA] status:
14:35:19.464 [MCA]   value: 100
14:35:19.465 [IST]   value: 0
14:35:19.470 [MCA] switch_ready: true
14:35:19.471 [IST] form_state:
14:35:19.476 [MCA] ---
14:35:19.477 [IST]   current_form: 1
14:35:19.482 [MCA] current_action:
14:35:19.482 [IST] action_info:
14:35:19.490 [IST]   current_action:
14:35:19.497 [IST]     value: 102


===== FILE: raw/logs/uc3_held_on.log  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/05_GPT架构评审/20261127_handheld/input_bundle/raw/logs/uc3_held_on.log) =====

# window 52643.8..52645.2 (seconds of day), raw lines from c2_events.log
14:37:23.802 [MCA]   value: 100
14:37:23.809 [MCA] switch_ready: true
14:37:23.809 [IST] ---
14:37:23.815 [MCA] ---
14:37:23.815 [IST] header:
14:37:23.820 [MCA] current_action:
14:37:23.820 [IST]   stamp:
14:37:23.825 [IST]     sec: 0
14:37:23.826 [MCA]   value: 300
14:37:23.830 [IST]     nanosec: 0
14:37:23.834 [MCA] source: task_engine
14:37:23.836 [IST]   frame_id: ''
14:37:23.840 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.845 [IST]   sequence: 0
14:37:23.847 [MCA] status:
14:37:23.852 [IST]   meas_stamp:
14:37:23.853 [MCA]   value: 100
14:37:23.859 [MCA] switch_ready: true
14:37:23.859 [IST]     sec: 0
14:37:23.866 [MCA] ---
14:37:23.867 [IST]     nanosec: 0
14:37:23.873 [MCA] current_action:
14:37:23.873 [IST] interaction_id: 0
14:37:23.879 [IST] mp_state:
14:37:23.883 [MCA]   value: 300
14:37:23.887 [IST]   value: 0
14:37:23.890 [MCA] source: task_engine
14:37:23.893 [IST] form_state:
14:37:23.896 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.902 [MCA] status:
14:37:23.908 [MCA]   value: 100
14:37:23.911 [IST]   current_form: 2
14:37:23.914 [MCA] switch_ready: true
14:37:23.918 [IST] action_info:
14:37:23.919 [MCA] ---
14:37:23.923 [IST]   current_action:
14:37:23.925 [MCA] current_action:
14:37:23.928 [IST]     value: 300
14:37:23.931 [MCA]   value: 300
14:37:23.933 [IST]   source: task_engine
14:37:23.937 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:23.937 [MCA] source: task_engine
14:37:23.942 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.942 [IST]   status:
14:37:23.946 [MCA] status:
14:37:23.947 [IST]     value: 100
14:37:23.953 [IST]   switch_ready: true
14:37:23.953 [MCA]   value: 100
14:37:23.959 [IST] held_state:
14:37:23.962 [MCA] switch_ready: true
14:37:23.966 [IST]   is_held: false
14:37:23.970 [MCA] ---
14:37:23.973 [IST]   hand_held: 1
14:37:23.976 [MCA] current_action:
14:37:23.978 [IST] mode: 1
14:37:23.984 [IST] mode_speed: 0.5
14:37:23.982 [MCA]   value: 300
14:37:23.992 [IST] prohibition_broadcast_net: false
14:37:23.993 [MCA] source: task_engine
14:37:24.001 [IST] task_state:
14:37:24.001 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.007 [IST]   task_type: 1
14:37:24.008 [MCA] status:
14:37:24.014 [IST]   task_stage: 2
14:37:24.015 [MCA]   value: 100
14:37:24.019 [IST]   token:
14:37:24.021 [MCA] switch_ready: true
14:37:24.026 [IST]     source: ''
14:37:24.027 [MCA] ---
14:37:24.033 [MCA] current_action:
14:37:24.034 [IST]     token: ''
14:37:24.039 [MCA]   value: 300
14:37:24.039 [IST] motion: ''
14:37:24.044 [MCA] source: task_engine
14:37:24.044 [IST] percep_env_state: 0
14:37:24.051 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.052 [IST] ---
14:37:24.058 [MCA] status:
14:37:24.065 [MCA]   value: 100
14:37:24.064 [IST] header:
14:37:24.071 [IST]   stamp:
14:37:24.071 [MCA] switch_ready: true
14:37:24.077 [IST]     sec: 0
14:37:24.077 [MCA] ---
14:37:24.087 [IST]     nanosec: 0
14:37:24.088 [MCA] current_action:
14:37:24.096 [MCA]   value: 300
14:37:24.097 [IST]   frame_id: ''
14:37:24.102 [IST]   sequence: 0
14:37:24.103 [MCA] source: task_engine
14:37:24.107 [IST]   meas_stamp:
14:37:24.111 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.112 [IST]     sec: 0
14:37:24.117 [MCA] status:
14:37:24.117 [IST]     nanosec: 0
14:37:24.122 [MCA]   value: 100
14:37:24.123 [IST] interaction_id: 0
14:37:24.127 [MCA] switch_ready: true
14:37:24.128 [IST] mp_state:
14:37:24.131 [MCA] ---
14:37:24.133 [IST]   value: 0
14:37:24.137 [MCA] current_action:
14:37:24.138 [IST] form_state:
14:37:24.144 [IST]   current_form: 2
14:37:24.143 [MCA]   value: 300
14:37:24.150 [MCA] source: task_engine
14:37:24.152 [IST] action_info:
14:37:24.158 [IST]   current_action:
14:37:24.158 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.164 [MCA] status:
14:37:24.164 [IST]     value: 300
14:37:24.169 [MCA]   value: 100
14:37:24.171 [IST]   source: task_engine
14:37:24.174 [MCA] switch_ready: true
14:37:24.176 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:24.182 [IST]   status:
14:37:24.184 [MCA] ---
14:37:24.188 [IST]     value: 100
14:37:24.194 [IST]   switch_ready: true
14:37:24.195 [MCA] current_action:
14:37:24.199 [IST] held_state:
14:37:24.200 [MCA]   value: 300
14:37:24.206 [MCA] source: task_engine
14:37:24.205 [IST]   is_held: true
14:37:24.211 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.211 [IST]   hand_held: 3
14:37:24.216 [MCA] status:
14:37:24.217 [IST] mode: 1
14:37:24.221 [IST] mode_speed: 0.5
14:37:24.222 [MCA]   value: 100
14:37:24.227 [IST] prohibition_broadcast_net: false
14:37:24.227 [MCA] switch_ready: true
14:37:24.232 [IST] task_state:
14:37:24.234 [MCA] ---
14:37:24.237 [IST]   task_type: 1
14:37:24.239 [MCA] current_action:
14:37:24.242 [IST]   task_stage: 2
14:37:24.247 [MCA]   value: 300
14:37:24.249 [IST]   token:
14:37:24.254 [MCA] source: task_engine
14:37:24.258 [IST]     source: ''
14:37:24.264 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.265 [IST]     token: ''
14:37:24.272 [MCA] status:
14:37:24.274 [IST] motion: ''
14:37:24.278 [MCA]   value: 100
14:37:24.285 [IST] percep_env_state: 0
14:37:24.285 [MCA] switch_ready: true
14:37:24.291 [MCA] ---
14:37:24.291 [IST] ---
14:37:24.298 [MCA] current_action:
14:37:24.298 [IST] header:
14:37:24.303 [IST]   stamp:
14:37:24.306 [MCA]   value: 300
14:37:24.309 [IST]     sec: 0
14:37:24.312 [MCA] source: task_engine
14:37:24.315 [IST]     nanosec: 0
14:37:24.317 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.320 [IST]   frame_id: ''
14:37:24.321 [MCA] status:
14:37:24.326 [IST]   sequence: 0
14:37:24.326 [MCA]   value: 100
14:37:24.331 [IST]   meas_stamp:
14:37:24.332 [MCA] switch_ready: true
14:37:24.335 [IST]     sec: 0
14:37:24.337 [MCA] ---
14:37:24.340 [IST]     nanosec: 0
14:37:24.343 [MCA] current_action:
14:37:24.345 [IST] interaction_id: 0
14:37:24.348 [MCA]   value: 300
14:37:24.354 [IST] mp_state:
14:37:24.355 [MCA] source: task_engine
14:37:24.360 [IST]   value: 0
14:37:24.361 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.366 [IST] form_state:
14:37:24.366 [MCA] status:
14:37:24.371 [IST]   current_form: 2
14:37:24.373 [MCA]   value: 100
14:37:24.376 [IST] action_info:
14:37:24.386 [IST]   current_action:
14:37:24.386 [MCA] switch_ready: true
14:37:24.393 [IST]     value: 300
14:37:24.396 [MCA] ---
14:37:24.399 [IST]   source: task_engine
14:37:24.402 [MCA] current_action:
14:37:24.404 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:24.409 [IST]   status:
14:37:24.410 [MCA]   value: 300
14:37:24.416 [MCA] source: task_engine
14:37:24.418 [IST]     value: 100
14:37:24.420 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.423 [IST]   switch_ready: true
14:37:24.426 [MCA] status:
14:37:24.428 [IST] held_state:
14:37:24.431 [MCA]   value: 100
14:37:24.435 [MCA] switch_ready: true
14:37:24.436 [IST]   is_held: true
14:37:24.440 [MCA] ---
14:37:24.441 [IST]   hand_held: 3
14:37:24.446 [MCA] current_action:
14:37:24.447 [IST] mode: 1
14:37:24.451 [MCA]   value: 300
14:37:24.455 [IST] mode_speed: 0.5
14:37:24.461 [IST] prohibition_broadcast_net: false
14:37:24.461 [MCA] source: task_engine
14:37:24.466 [IST] task_state:
14:37:24.467 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.472 [IST]   task_type: 1
14:37:24.472 [MCA] status:
14:37:24.478 [IST]   task_stage: 2
14:37:24.479 [MCA]   value: 100
14:37:24.485 [MCA] switch_ready: true
14:37:24.484 [IST]   token:
14:37:24.497 [MCA] ---
14:37:24.499 [IST]     source: ''
14:37:24.502 [MCA] current_action:
14:37:24.506 [IST]     token: ''
14:37:24.510 [MCA]   value: 300
14:37:24.515 [IST] motion: ''
14:37:24.518 [MCA] source: task_engine
14:37:24.520 [IST] percep_env_state: 0
14:37:24.522 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.525 [IST] ---
14:37:24.528 [MCA] status:
14:37:24.531 [IST] header:
14:37:24.535 [MCA]   value: 100
14:37:24.535 [IST]   stamp:
14:37:24.540 [MCA] switch_ready: true
14:37:24.541 [IST]     sec: 0
14:37:24.546 [IST]     nanosec: 0
14:37:24.545 [MCA] ---
14:37:24.552 [MCA] current_action:
14:37:24.552 [IST]   frame_id: ''
14:37:24.557 [IST]   sequence: 0
14:37:24.557 [MCA]   value: 300
14:37:24.562 [IST]   meas_stamp:
14:37:24.566 [MCA] source: task_engine
14:37:24.569 [IST]     sec: 0
14:37:24.572 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.574 [IST]     nanosec: 0
14:37:24.578 [MCA] status:
14:37:24.579 [IST] interaction_id: 0
14:37:24.584 [MCA]   value: 100
14:37:24.597 [MCA] switch_ready: true
14:37:24.600 [IST] mp_state:
14:37:24.604 [MCA] ---
14:37:24.605 [IST]   value: 0
14:37:24.610 [MCA] current_action:
14:37:24.610 [IST] form_state:
14:37:24.615 [MCA]   value: 300
14:37:24.616 [IST]   current_form: 2
14:37:24.620 [MCA] source: task_engine
14:37:24.620 [IST] action_info:
14:37:24.625 [IST]   current_action:
14:37:24.626 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.630 [IST]     value: 300
14:37:24.631 [MCA] status:
14:37:24.635 [IST]   source: task_engine
14:37:24.637 [MCA]   value: 100
14:37:24.641 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:24.642 [MCA] switch_ready: true
14:37:24.647 [IST]   status:
14:37:24.647 [MCA] ---
14:37:24.653 [IST]     value: 100
14:37:24.653 [MCA] current_action:
14:37:24.660 [IST]   switch_ready: true
14:37:24.665 [MCA]   value: 300
14:37:24.668 [IST] held_state:
14:37:24.672 [MCA] source: task_engine
14:37:24.673 [IST]   is_held: true
14:37:24.678 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.678 [IST]   hand_held: 3
14:37:24.685 [MCA] status:
14:37:24.693 [IST] mode: 1
14:37:24.695 [MCA]   value: 100
14:37:24.698 [IST] mode_speed: 0.5
14:37:24.700 [MCA] switch_ready: true
14:37:24.704 [IST] prohibition_broadcast_net: false
14:37:24.706 [MCA] ---
14:37:24.710 [IST] task_state:
14:37:24.712 [MCA] current_action:
14:37:24.717 [IST]   task_type: 1
14:37:24.719 [MCA]   value: 300
14:37:24.721 [IST]   task_stage: 2
14:37:24.724 [MCA] source: task_engine
14:37:24.727 [IST]   token:
14:37:24.729 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.733 [IST]     source: ''
14:37:24.733 [MCA] status:
14:37:24.737 [IST]     token: ''
14:37:24.738 [MCA]   value: 100
14:37:24.743 [IST] motion: ''
14:37:24.743 [MCA] switch_ready: true
14:37:24.749 [MCA] ---
14:37:24.752 [IST] percep_env_state: 0
14:37:24.757 [MCA] current_action:
14:37:24.759 [IST] ---
14:37:24.765 [IST] header:
14:37:24.764 [MCA]   value: 300
14:37:24.770 [IST]   stamp:
14:37:24.772 [MCA] source: task_engine
14:37:24.775 [IST]     sec: 0
14:37:24.781 [IST]     nanosec: 0
14:37:24.782 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.789 [IST]   frame_id: ''
14:37:24.792 [MCA] status:
14:37:24.798 [IST]   sequence: 0
14:37:24.799 [MCA]   value: 100
14:37:24.804 [IST]   meas_stamp:
14:37:24.805 [MCA] switch_ready: true
14:37:24.809 [IST]     sec: 0
14:37:24.810 [MCA] ---
14:37:24.815 [IST]     nanosec: 0
14:37:24.815 [MCA] current_action:
14:37:24.820 [IST] interaction_id: 0
14:37:24.820 [MCA]   value: 300
14:37:24.825 [IST] mp_state:
14:37:24.825 [MCA] source: task_engine
14:37:24.830 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.830 [IST]   value: 0
14:37:24.834 [MCA] status:
14:37:24.835 [IST] form_state:
14:37:24.841 [IST]   current_form: 2
14:37:24.841 [MCA]   value: 100
14:37:24.847 [MCA] switch_ready: true
14:37:24.848 [IST] action_info:
14:37:24.854 [IST]   current_action:
14:37:24.855 [MCA] ---
14:37:24.860 [IST]     value: 300
14:37:24.866 [MCA] current_action:
14:37:24.868 [IST]   source: task_engine
14:37:24.874 [MCA]   value: 300
14:37:24.876 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:24.879 [MCA] source: task_engine
14:37:24.888 [IST]   status:
14:37:24.889 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.894 [MCA] status:
14:37:24.895 [IST]     value: 100
14:37:24.900 [MCA]   value: 100
14:37:24.901 [IST]   switch_ready: true
14:37:24.906 [MCA] switch_ready: true
14:37:24.906 [IST] held_state:
14:37:24.911 [IST]   is_held: true
14:37:24.911 [MCA] ---
14:37:24.917 [MCA] current_action:
14:37:24.917 [IST]   hand_held: 3
14:37:24.921 [MCA]   value: 300
14:37:24.921 [IST] mode: 1
14:37:24.926 [MCA] source: task_engine
14:37:24.926 [IST] mode_speed: 0.5
14:37:24.932 [IST] prohibition_broadcast_net: false
14:37:24.932 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.938 [IST] task_state:
14:37:24.938 [MCA] status:
14:37:24.943 [IST]   task_type: 1
14:37:24.944 [MCA]   value: 100
14:37:24.951 [MCA] switch_ready: true
14:37:24.952 [IST]   task_stage: 2
14:37:24.959 [IST]   token:
14:37:24.958 [MCA] ---
14:37:24.965 [IST]     source: ''
14:37:24.967 [MCA] current_action:
14:37:24.970 [IST]     token: ''
14:37:24.971 [MCA]   value: 300
14:37:24.975 [IST] motion: ''
14:37:24.976 [MCA] source: task_engine
14:37:24.981 [IST] percep_env_state: 0
14:37:24.985 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.988 [IST] ---
14:37:24.993 [MCA] status:
14:37:24.994 [IST] header:
14:37:25.001 [MCA]   value: 100
14:37:25.001 [IST]   stamp:
14:37:25.007 [IST]     sec: 0
14:37:25.008 [MCA] switch_ready: true
14:37:25.014 [MCA] ---
14:37:25.015 [IST]     nanosec: 0
14:37:25.019 [MCA] current_action:
14:37:25.019 [IST]   frame_id: ''
14:37:25.024 [MCA]   value: 300
14:37:25.024 [IST]   sequence: 0
14:37:25.030 [MCA] source: task_engine
14:37:25.030 [IST]   meas_stamp:
14:37:25.035 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:25.036 [IST]     sec: 0
14:37:25.042 [IST]     nanosec: 0
14:37:25.040 [MCA] status:
14:37:25.047 [MCA]   value: 100
14:37:25.050 [IST] interaction_id: 0
14:37:25.057 [MCA] switch_ready: true
14:37:25.057 [IST] mp_state:
14:37:25.063 [IST]   value: 0
14:37:25.064 [MCA] ---
14:37:25.069 [MCA] current_action:
14:37:25.070 [IST] form_state:
14:37:25.075 [MCA]   value: 300
14:37:25.075 [IST]   current_form: 2
14:37:25.080 [IST] action_info:
14:37:25.080 [MCA] source: task_engine
14:37:25.089 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:25.093 [IST]   current_action:
14:37:25.095 [MCA] status:
14:37:25.102 [MCA]   value: 100
14:37:25.101 [IST]     value: 300
14:37:25.107 [MCA] switch_ready: true
14:37:25.107 [IST]   source: task_engine
14:37:25.113 [MCA] ---
14:37:25.113 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:25.118 [MCA] current_action:
14:37:25.119 [IST]   status:
14:37:25.123 [IST]     value: 100
14:37:25.123 [MCA]   value: 300
14:37:25.128 [IST]   switch_ready: true
14:37:25.129 [MCA] source: task_engine
14:37:25.133 [IST] held_state:
14:37:25.134 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:25.138 [IST]   is_held: true
14:37:25.138 [MCA] status:
14:37:25.143 [MCA]   value: 100
14:37:25.143 [IST]   hand_held: 3
14:37:25.148 [IST] mode: 1
14:37:25.148 [MCA] switch_ready: true
14:37:25.153 [MCA] ---
14:37:25.153 [IST] mode_speed: 0.5
14:37:25.159 [MCA] current_action:
14:37:25.159 [IST] prohibition_broadcast_net: false
14:37:25.165 [MCA]   value: 300
14:37:25.165 [IST] task_state:
14:37:25.171 [MCA] source: task_engine
14:37:25.171 [IST]   task_type: 1
14:37:25.176 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:25.176 [IST]   task_stage: 2
14:37:25.181 [MCA] status:
14:37:25.181 [IST]   token:
14:37:25.188 [MCA]   value: 100
14:37:25.194 [MCA] switch_ready: true
14:37:25.200 [MCA] ---


===== FILE: raw/logs/uc3_held_off.log  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/05_GPT架构评审/20261127_handheld/input_bundle/raw/logs/uc3_held_off.log) =====

# window 52667.8..52669.2 (seconds of day), raw lines from c2_events.log
14:37:47.802 [MCA] current_action:
14:37:47.804 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:47.810 [IST]   status:
14:37:47.810 [MCA]   value: 300
14:37:47.816 [MCA] source: task_engine
14:37:47.817 [IST]     value: 100
14:37:47.821 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:47.822 [IST]   switch_ready: true
14:37:47.826 [MCA] status:
14:37:47.828 [IST] held_state:
14:37:47.832 [MCA]   value: 100
14:37:47.834 [IST]   is_held: true
14:37:47.839 [MCA] switch_ready: true
14:37:47.840 [IST]   hand_held: 3
14:37:47.847 [IST] mode: 1
14:37:47.849 [MCA] ---
14:37:47.857 [IST] mode_speed: 0.5
14:37:47.859 [MCA] current_action:
14:37:47.864 [IST] prohibition_broadcast_net: false
14:37:47.869 [MCA]   value: 300
14:37:47.869 [IST] task_state:
14:37:47.874 [MCA] source: task_engine
14:37:47.876 [IST]   task_type: 0
14:37:47.880 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:47.882 [IST]   task_stage: 0
14:37:47.884 [MCA] status:
14:37:47.889 [IST]   token:
14:37:47.892 [MCA]   value: 100
14:37:47.897 [IST]     source: ''
14:37:47.899 [MCA] switch_ready: true
14:37:47.903 [IST]     token: ''
14:37:47.905 [MCA] ---
14:37:47.910 [MCA] current_action:
14:37:47.913 [IST] motion: ''
14:37:47.916 [MCA]   value: 300
14:37:47.917 [IST] percep_env_state: 0
14:37:47.921 [MCA] source: task_engine
14:37:47.922 [IST] ---
14:37:47.925 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:47.927 [IST] header:
14:37:47.930 [MCA] status:
14:37:47.934 [IST]   stamp:
14:37:47.935 [MCA]   value: 100
14:37:47.939 [IST]     sec: 0
14:37:47.941 [MCA] switch_ready: true
14:37:47.944 [IST]     nanosec: 0
14:37:47.947 [MCA] ---
14:37:47.951 [IST]   frame_id: ''
14:37:47.953 [MCA] current_action:
14:37:47.959 [IST]   sequence: 0
14:37:47.960 [MCA]   value: 300
14:37:47.966 [IST]   meas_stamp:
14:37:47.967 [MCA] source: task_engine
14:37:47.973 [IST]     sec: 0
14:37:47.973 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:47.979 [MCA] status:
14:37:47.986 [MCA]   value: 100
14:37:47.988 [IST]     nanosec: 0
14:37:47.992 [MCA] switch_ready: true
14:37:48.000 [IST] interaction_id: 0
14:37:48.000 [MCA] ---
14:37:48.004 [IST] mp_state:
14:37:48.005 [MCA] current_action:
14:37:48.011 [IST]   value: 0
14:37:48.016 [MCA]   value: 300
14:37:48.018 [IST] form_state:
14:37:48.021 [MCA] source: task_engine
14:37:48.026 [IST]   current_form: 2
14:37:48.029 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.031 [IST] action_info:
14:37:48.034 [MCA] status:
14:37:48.036 [IST]   current_action:
14:37:48.039 [MCA]   value: 100
14:37:48.041 [IST]     value: 300
14:37:48.046 [MCA] switch_ready: true
14:37:48.052 [IST]   source: task_engine
14:37:48.052 [MCA] ---
14:37:48.060 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:48.064 [MCA] current_action:
14:37:48.066 [IST]   status:
14:37:48.070 [MCA]   value: 300
14:37:48.071 [IST]     value: 100
14:37:48.077 [MCA] source: task_engine
14:37:48.079 [IST]   switch_ready: true
14:37:48.083 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.096 [IST] held_state:
14:37:48.096 [MCA] status:
14:37:48.101 [MCA]   value: 100
14:37:48.103 [IST]   is_held: true
14:37:48.106 [MCA] switch_ready: true
14:37:48.110 [IST]   hand_held: 3
14:37:48.111 [MCA] ---
14:37:48.116 [IST] mode: 1
14:37:48.116 [MCA] current_action:
14:37:48.122 [IST] mode_speed: 0.5
14:37:48.122 [MCA]   value: 300
14:37:48.127 [MCA] source: task_engine
14:37:48.127 [IST] prohibition_broadcast_net: false
14:37:48.132 [IST] task_state:
14:37:48.133 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.137 [IST]   task_type: 0
14:37:48.138 [MCA] status:
14:37:48.145 [MCA]   value: 100
14:37:48.148 [IST]   task_stage: 0
14:37:48.150 [MCA] switch_ready: true
14:37:48.156 [IST]   token:
14:37:48.160 [MCA] ---
14:37:48.163 [IST]     source: ''
14:37:48.166 [MCA] current_action:
14:37:48.171 [IST]     token: ''
14:37:48.171 [MCA]   value: 300
14:37:48.177 [MCA] source: task_engine
14:37:48.179 [IST] motion: ''
14:37:48.184 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.186 [IST] percep_env_state: 0
14:37:48.193 [MCA] status:
14:37:48.194 [IST] ---
14:37:48.200 [MCA]   value: 100
14:37:48.200 [IST] header:
14:37:48.206 [MCA] switch_ready: true
14:37:48.207 [IST]   stamp:
14:37:48.211 [MCA] ---
14:37:48.216 [IST]     sec: 0
14:37:48.217 [MCA] current_action:
14:37:48.221 [IST]     nanosec: 0
14:37:48.222 [MCA]   value: 300
14:37:48.227 [IST]   frame_id: ''
14:37:48.227 [MCA] source: task_engine
14:37:48.232 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.233 [IST]   sequence: 0
14:37:48.238 [MCA] status:
14:37:48.238 [IST]   meas_stamp:
14:37:48.243 [MCA]   value: 100
14:37:48.249 [MCA] switch_ready: true
14:37:48.249 [IST]     sec: 0
14:37:48.255 [MCA] ---
14:37:48.261 [IST]     nanosec: 0
14:37:48.261 [MCA] current_action:
14:37:48.268 [IST] interaction_id: 0
14:37:48.268 [MCA]   value: 300
14:37:48.273 [MCA] source: task_engine
14:37:48.276 [IST] mp_state:
14:37:48.279 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.286 [IST]   value: 0
14:37:48.294 [MCA] status:
14:37:48.294 [IST] form_state:
14:37:48.301 [IST]   current_form: 2
14:37:48.301 [MCA]   value: 100
14:37:48.306 [MCA] switch_ready: true
14:37:48.307 [IST] action_info:
14:37:48.313 [IST]   current_action:
14:37:48.313 [MCA] ---
14:37:48.318 [MCA] current_action:
14:37:48.319 [IST]     value: 300
14:37:48.323 [MCA]   value: 300
14:37:48.325 [IST]   source: task_engine
14:37:48.328 [MCA] source: task_engine
14:37:48.330 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:48.335 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.337 [IST]   status:
14:37:48.340 [MCA] status:
14:37:48.342 [IST]     value: 100
14:37:48.348 [MCA]   value: 100
14:37:48.349 [IST]   switch_ready: true
14:37:48.356 [MCA] switch_ready: true
14:37:48.359 [IST] held_state:
14:37:48.363 [MCA] ---
14:37:48.366 [IST]   is_held: true
14:37:48.369 [MCA] current_action:
14:37:48.372 [IST]   hand_held: 3
14:37:48.374 [MCA]   value: 300
14:37:48.380 [MCA] source: task_engine
14:37:48.379 [IST] mode: 1
14:37:48.388 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.398 [IST] mode_speed: 0.5
14:37:48.402 [MCA] status:
14:37:48.404 [IST] prohibition_broadcast_net: false
14:37:48.411 [MCA]   value: 100
14:37:48.413 [IST] task_state:
14:37:48.418 [IST]   task_type: 0
14:37:48.418 [MCA] switch_ready: true
14:37:48.423 [MCA] ---
14:37:48.424 [IST]   task_stage: 0
14:37:48.429 [MCA] current_action:
14:37:48.429 [IST]   token:
14:37:48.433 [MCA]   value: 300
14:37:48.436 [IST]     source: ''
14:37:48.438 [MCA] source: task_engine
14:37:48.442 [IST]     token: ''
14:37:48.442 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.449 [MCA] status:
14:37:48.449 [IST] motion: ''
14:37:48.456 [IST] percep_env_state: 0
14:37:48.455 [MCA]   value: 100
14:37:48.461 [IST] ---
14:37:48.465 [MCA] switch_ready: true
14:37:48.467 [IST] header:
14:37:48.472 [MCA] ---
14:37:48.473 [IST]   stamp:
14:37:48.478 [MCA] current_action:
14:37:48.481 [IST]     sec: 0
14:37:48.483 [MCA]   value: 300
14:37:48.497 [IST]     nanosec: 0
14:37:48.490 [MCA] source: task_engine
14:37:48.503 [IST]   frame_id: ''
14:37:48.507 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.509 [IST]   sequence: 0
14:37:48.515 [MCA] status:
14:37:48.516 [IST]   meas_stamp:
14:37:48.519 [MCA]   value: 100
14:37:48.522 [IST]     sec: 0
14:37:48.524 [MCA] switch_ready: true
14:37:48.528 [IST]     nanosec: 0
14:37:48.529 [MCA] ---
14:37:48.534 [MCA] current_action:
14:37:48.534 [IST] interaction_id: 0
14:37:48.539 [MCA]   value: 300
14:37:48.540 [IST] mp_state:
14:37:48.545 [MCA] source: task_engine
14:37:48.545 [IST]   value: 0
14:37:48.552 [IST] form_state:
14:37:48.552 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.558 [IST]   current_form: 2
14:37:48.558 [MCA] status:
14:37:48.565 [IST] action_info:
14:37:48.565 [MCA]   value: 100
14:37:48.571 [MCA] switch_ready: true
14:37:48.573 [IST]   current_action:
14:37:48.577 [MCA] ---
14:37:48.579 [IST]     value: 300
14:37:48.583 [MCA] current_action:
14:37:48.590 [IST]   source: task_engine
14:37:48.596 [MCA]   value: 300
14:37:48.602 [MCA] source: task_engine
14:37:48.603 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:48.609 [IST]   status:
14:37:48.610 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.615 [IST]     value: 100
14:37:48.617 [MCA] status:
14:37:48.622 [MCA]   value: 100
14:37:48.622 [IST]   switch_ready: true
14:37:48.627 [MCA] switch_ready: true
14:37:48.629 [IST] held_state:
14:37:48.632 [MCA] ---
14:37:48.634 [IST]   is_held: false
14:37:48.637 [MCA] current_action:
14:37:48.639 [IST]   hand_held: 1
14:37:48.643 [MCA]   value: 300
14:37:48.645 [IST] mode: 1
14:37:48.650 [MCA] source: task_engine
14:37:48.651 [IST] mode_speed: 0.5
14:37:48.658 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.659 [IST] prohibition_broadcast_net: false
14:37:48.667 [IST] task_state:
14:37:48.668 [MCA] status:
14:37:48.672 [IST]   task_type: 0
14:37:48.673 [MCA]   value: 100
14:37:48.681 [MCA] switch_ready: true
14:37:48.682 [IST]   task_stage: 0
14:37:48.687 [MCA] ---
14:37:48.693 [MCA] current_action:
14:37:48.695 [IST]   token:
14:37:48.699 [MCA]   value: 300
14:37:48.700 [IST]     source: ''
14:37:48.705 [IST]     token: ''
14:37:48.705 [MCA] source: task_engine
14:37:48.711 [IST] motion: ''
14:37:48.712 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.717 [IST] percep_env_state: 0
14:37:48.717 [MCA] status:
14:37:48.722 [MCA]   value: 100
14:37:48.723 [IST] ---
14:37:48.728 [IST] header:
14:37:48.728 [MCA] switch_ready: true
14:37:48.733 [IST]   stamp:
14:37:48.733 [MCA] ---
14:37:48.738 [MCA] current_action:
14:37:48.739 [IST]     sec: 0
14:37:48.747 [MCA]   value: 300
14:37:48.747 [IST]     nanosec: 0
14:37:48.754 [IST]   frame_id: ''
14:37:48.752 [MCA] source: task_engine
14:37:48.760 [IST]   sequence: 0
14:37:48.762 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.766 [IST]   meas_stamp:
14:37:48.768 [MCA] status:
14:37:48.773 [IST]     sec: 0
14:37:48.774 [MCA]   value: 100
14:37:48.779 [MCA] switch_ready: true
14:37:48.779 [IST]     nanosec: 0
14:37:48.793 [IST] interaction_id: 0
14:37:48.795 [MCA] ---
14:37:48.801 [IST] mp_state:
14:37:48.802 [MCA] current_action:
14:37:48.808 [MCA]   value: 300
14:37:48.814 [MCA] source: task_engine
14:37:48.814 [IST]   value: 0
14:37:48.819 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.819 [IST] form_state:
14:37:48.824 [MCA] status:
14:37:48.825 [IST]   current_form: 2
14:37:48.829 [MCA]   value: 100
14:37:48.832 [IST] action_info:
14:37:48.833 [MCA] switch_ready: true
14:37:48.838 [IST]   current_action:
14:37:48.840 [MCA] ---
14:37:48.843 [IST]     value: 300
14:37:48.854 [IST]   source: task_engine
14:37:48.860 [MCA] current_action:
14:37:48.860 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:48.866 [IST]   status:
14:37:48.866 [MCA]   value: 300
14:37:48.870 [IST]     value: 100
14:37:48.871 [MCA] source: task_engine
14:37:48.877 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.878 [IST]   switch_ready: true
14:37:48.882 [MCA] status:
14:37:48.888 [MCA]   value: 100
14:37:48.895 [IST] held_state:
14:37:48.899 [MCA] switch_ready: true
14:37:48.901 [IST]   is_held: false
14:37:48.903 [MCA] ---
14:37:48.907 [IST]   hand_held: 1
14:37:48.909 [MCA] current_action:
14:37:48.914 [IST] mode: 1
14:37:48.916 [MCA]   value: 300
14:37:48.919 [IST] mode_speed: 0.5
14:37:48.920 [MCA] source: task_engine
14:37:48.924 [IST] prohibition_broadcast_net: false
14:37:48.925 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.930 [MCA] status:
14:37:48.930 [IST] task_state:
14:37:48.934 [MCA]   value: 100
14:37:48.935 [IST]   task_type: 0
14:37:48.940 [MCA] switch_ready: true
14:37:48.941 [IST]   task_stage: 0
14:37:48.947 [IST]   token:
14:37:48.952 [IST]     source: ''
14:37:48.956 [MCA] ---
14:37:48.959 [IST]     token: ''
14:37:48.962 [MCA] current_action:
14:37:48.964 [IST] motion: ''
14:37:48.968 [MCA]   value: 300
14:37:48.970 [IST] percep_env_state: 0
14:37:48.974 [MCA] source: task_engine
14:37:48.979 [IST] ---
14:37:48.979 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:48.989 [MCA] status:
14:37:48.992 [IST] header:
14:37:48.997 [MCA]   value: 100
14:37:48.998 [IST]   stamp:
14:37:49.002 [MCA] switch_ready: true
14:37:49.003 [IST]     sec: 0
14:37:49.007 [MCA] ---
14:37:49.008 [IST]     nanosec: 0
14:37:49.012 [MCA] current_action:
14:37:49.014 [IST]   frame_id: ''
14:37:49.019 [MCA]   value: 300
14:37:49.019 [IST]   sequence: 0
14:37:49.023 [MCA] source: task_engine
14:37:49.025 [IST]   meas_stamp:
14:37:49.028 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:49.030 [IST]     sec: 0
14:37:49.034 [MCA] status:
14:37:49.036 [IST]     nanosec: 0
14:37:49.038 [MCA]   value: 100
14:37:49.042 [IST] interaction_id: 0
14:37:49.043 [MCA] switch_ready: true
14:37:49.050 [IST] mp_state:
14:37:49.053 [MCA] ---
14:37:49.057 [IST]   value: 0
14:37:49.063 [MCA] current_action:
14:37:49.064 [IST] form_state:
14:37:49.068 [MCA]   value: 300
14:37:49.070 [IST]   current_form: 2
14:37:49.075 [IST] action_info:
14:37:49.075 [MCA] source: task_engine
14:37:49.080 [IST]   current_action:
14:37:49.087 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:49.094 [MCA] status:
14:37:49.094 [IST]     value: 300
14:37:49.100 [IST]   source: task_engine
14:37:49.100 [MCA]   value: 100
14:37:49.105 [MCA] switch_ready: true
14:37:49.106 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:49.111 [MCA] ---
14:37:49.115 [IST]   status:
14:37:49.117 [MCA] current_action:
14:37:49.120 [IST]     value: 100
14:37:49.121 [MCA]   value: 300
14:37:49.125 [IST]   switch_ready: true
14:37:49.126 [MCA] source: task_engine
14:37:49.130 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:49.132 [IST] held_state:
14:37:49.136 [IST]   is_held: false
14:37:49.137 [MCA] status:
14:37:49.141 [MCA]   value: 100
14:37:49.141 [IST]   hand_held: 1
14:37:49.148 [IST] mode: 1
14:37:49.148 [MCA] switch_ready: true
14:37:49.156 [MCA] ---
14:37:49.156 [IST] mode_speed: 0.5
14:37:49.162 [MCA] current_action:
14:37:49.162 [IST] prohibition_broadcast_net: false
14:37:49.168 [MCA]   value: 300
14:37:49.169 [IST] task_state:
14:37:49.173 [MCA] source: task_engine
14:37:49.176 [IST]   task_type: 0
14:37:49.181 [IST]   task_stage: 0
14:37:49.182 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:49.192 [IST]   token:
14:37:49.197 [MCA] status:
14:37:49.199 [IST]     source: ''


===== FILE: raw/logs/uc3_follow_window.log  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/05_GPT架构评审/20261127_handheld/input_bundle/raw/logs/uc3_follow_window.log) =====

# window 52643.5..52644.8 (seconds of day), raw lines from c2_events.log
14:37:23.503 [MCA] ---
14:37:23.505 [IST]   hand_held: 1
14:37:23.509 [MCA] current_action:
14:37:23.511 [IST] mode: 1
14:37:23.517 [IST] mode_speed: 0.5
14:37:23.516 [MCA]   value: 300
14:37:23.522 [MCA] source: task_engine
14:37:23.522 [IST] prohibition_broadcast_net: false
14:37:23.527 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.527 [IST] task_state:
14:37:23.532 [IST]   task_type: 1
14:37:23.533 [MCA] status:
14:37:23.538 [MCA]   value: 100
14:37:23.538 [IST]   task_stage: 2
14:37:23.543 [MCA] switch_ready: true
14:37:23.543 [IST]   token:
14:37:23.549 [MCA] ---
14:37:23.549 [IST]     source: ''
14:37:23.556 [IST]     token: ''
14:37:23.558 [MCA] current_action:
14:37:23.562 [IST] motion: ''
14:37:23.565 [MCA]   value: 300
14:37:23.569 [IST] percep_env_state: 0
14:37:23.572 [MCA] source: task_engine
14:37:23.576 [IST] ---
14:37:23.578 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.586 [IST] header:
14:37:23.587 [MCA] status:
14:37:23.595 [MCA]   value: 100
14:37:23.596 [IST]   stamp:
14:37:23.600 [MCA] switch_ready: true
14:37:23.602 [IST]     sec: 0
14:37:23.606 [MCA] ---
14:37:23.607 [IST]     nanosec: 0
14:37:23.611 [MCA] current_action:
14:37:23.614 [IST]   frame_id: ''
14:37:23.616 [MCA]   value: 300
14:37:23.619 [IST]   sequence: 0
14:37:23.621 [MCA] source: task_engine
14:37:23.623 [IST]   meas_stamp:
14:37:23.627 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.628 [IST]     sec: 0
14:37:23.632 [MCA] status:
14:37:23.633 [IST]     nanosec: 0
14:37:23.638 [MCA]   value: 100
14:37:23.639 [IST] interaction_id: 0
14:37:23.643 [IST] mp_state:
14:37:23.643 [MCA] switch_ready: true
14:37:23.649 [MCA] ---
14:37:23.649 [IST]   value: 0
14:37:23.656 [MCA] current_action:
14:37:23.657 [IST] form_state:
14:37:23.662 [IST]   current_form: 2
14:37:23.663 [MCA]   value: 300
14:37:23.668 [IST] action_info:
14:37:23.669 [MCA] source: task_engine
14:37:23.675 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.675 [IST]   current_action:
14:37:23.680 [IST]     value: 300
14:37:23.680 [MCA] status:
14:37:23.687 [IST]   source: task_engine
14:37:23.691 [MCA]   value: 100
14:37:23.693 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:23.699 [MCA] switch_ready: true
14:37:23.704 [MCA] ---
14:37:23.705 [IST]   status:
14:37:23.711 [IST]     value: 100
14:37:23.711 [MCA] current_action:
14:37:23.716 [MCA]   value: 300
14:37:23.717 [IST]   switch_ready: true
14:37:23.721 [MCA] source: task_engine
14:37:23.722 [IST] held_state:
14:37:23.727 [IST]   is_held: false
14:37:23.729 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.733 [IST]   hand_held: 1
14:37:23.734 [MCA] status:
14:37:23.737 [IST] mode: 1
14:37:23.738 [MCA]   value: 100
14:37:23.742 [IST] mode_speed: 0.5
14:37:23.742 [MCA] switch_ready: true
14:37:23.747 [IST] prohibition_broadcast_net: false
14:37:23.748 [MCA] ---
14:37:23.754 [IST] task_state:
14:37:23.754 [MCA] current_action:
14:37:23.760 [IST]   task_type: 1
14:37:23.763 [MCA]   value: 300
14:37:23.767 [IST]   task_stage: 2
14:37:23.772 [MCA] source: task_engine
14:37:23.774 [IST]   token:
14:37:23.779 [IST]     source: ''
14:37:23.784 [IST]     token: ''
14:37:23.785 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.789 [IST] motion: ''
14:37:23.790 [MCA] status:
14:37:23.796 [IST] percep_env_state: 0
14:37:23.802 [MCA]   value: 100
14:37:23.809 [MCA] switch_ready: true
14:37:23.809 [IST] ---
14:37:23.815 [MCA] ---
14:37:23.815 [IST] header:
14:37:23.820 [MCA] current_action:
14:37:23.820 [IST]   stamp:
14:37:23.825 [IST]     sec: 0
14:37:23.826 [MCA]   value: 300
14:37:23.830 [IST]     nanosec: 0
14:37:23.834 [MCA] source: task_engine
14:37:23.836 [IST]   frame_id: ''
14:37:23.840 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.845 [IST]   sequence: 0
14:37:23.847 [MCA] status:
14:37:23.852 [IST]   meas_stamp:
14:37:23.853 [MCA]   value: 100
14:37:23.859 [MCA] switch_ready: true
14:37:23.859 [IST]     sec: 0
14:37:23.866 [MCA] ---
14:37:23.867 [IST]     nanosec: 0
14:37:23.873 [MCA] current_action:
14:37:23.873 [IST] interaction_id: 0
14:37:23.879 [IST] mp_state:
14:37:23.883 [MCA]   value: 300
14:37:23.887 [IST]   value: 0
14:37:23.890 [MCA] source: task_engine
14:37:23.893 [IST] form_state:
14:37:23.896 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.902 [MCA] status:
14:37:23.908 [MCA]   value: 100
14:37:23.911 [IST]   current_form: 2
14:37:23.914 [MCA] switch_ready: true
14:37:23.918 [IST] action_info:
14:37:23.919 [MCA] ---
14:37:23.923 [IST]   current_action:
14:37:23.925 [MCA] current_action:
14:37:23.928 [IST]     value: 300
14:37:23.931 [MCA]   value: 300
14:37:23.933 [IST]   source: task_engine
14:37:23.937 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:23.937 [MCA] source: task_engine
14:37:23.942 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:23.942 [IST]   status:
14:37:23.946 [MCA] status:
14:37:23.947 [IST]     value: 100
14:37:23.953 [IST]   switch_ready: true
14:37:23.953 [MCA]   value: 100
14:37:23.959 [IST] held_state:
14:37:23.962 [MCA] switch_ready: true
14:37:23.966 [IST]   is_held: false
14:37:23.970 [MCA] ---
14:37:23.973 [IST]   hand_held: 1
14:37:23.976 [MCA] current_action:
14:37:23.978 [IST] mode: 1
14:37:23.984 [IST] mode_speed: 0.5
14:37:23.982 [MCA]   value: 300
14:37:23.992 [IST] prohibition_broadcast_net: false
14:37:23.993 [MCA] source: task_engine
14:37:24.001 [IST] task_state:
14:37:24.001 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.007 [IST]   task_type: 1
14:37:24.008 [MCA] status:
14:37:24.014 [IST]   task_stage: 2
14:37:24.015 [MCA]   value: 100
14:37:24.019 [IST]   token:
14:37:24.021 [MCA] switch_ready: true
14:37:24.026 [IST]     source: ''
14:37:24.027 [MCA] ---
14:37:24.033 [MCA] current_action:
14:37:24.034 [IST]     token: ''
14:37:24.039 [MCA]   value: 300
14:37:24.039 [IST] motion: ''
14:37:24.044 [MCA] source: task_engine
14:37:24.044 [IST] percep_env_state: 0
14:37:24.051 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.052 [IST] ---
14:37:24.058 [MCA] status:
14:37:24.065 [MCA]   value: 100
14:37:24.064 [IST] header:
14:37:24.071 [IST]   stamp:
14:37:24.071 [MCA] switch_ready: true
14:37:24.077 [IST]     sec: 0
14:37:24.077 [MCA] ---
14:37:24.087 [IST]     nanosec: 0
14:37:24.088 [MCA] current_action:
14:37:24.096 [MCA]   value: 300
14:37:24.097 [IST]   frame_id: ''
14:37:24.102 [IST]   sequence: 0
14:37:24.103 [MCA] source: task_engine
14:37:24.107 [IST]   meas_stamp:
14:37:24.111 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.112 [IST]     sec: 0
14:37:24.117 [MCA] status:
14:37:24.117 [IST]     nanosec: 0
14:37:24.122 [MCA]   value: 100
14:37:24.123 [IST] interaction_id: 0
14:37:24.127 [MCA] switch_ready: true
14:37:24.128 [IST] mp_state:
14:37:24.131 [MCA] ---
14:37:24.133 [IST]   value: 0
14:37:24.137 [MCA] current_action:
14:37:24.138 [IST] form_state:
14:37:24.144 [IST]   current_form: 2
14:37:24.143 [MCA]   value: 300
14:37:24.150 [MCA] source: task_engine
14:37:24.152 [IST] action_info:
14:37:24.158 [IST]   current_action:
14:37:24.158 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.164 [MCA] status:
14:37:24.164 [IST]     value: 300
14:37:24.169 [MCA]   value: 100
14:37:24.171 [IST]   source: task_engine
14:37:24.174 [MCA] switch_ready: true
14:37:24.176 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:24.182 [IST]   status:
14:37:24.184 [MCA] ---
14:37:24.188 [IST]     value: 100
14:37:24.194 [IST]   switch_ready: true
14:37:24.195 [MCA] current_action:
14:37:24.199 [IST] held_state:
14:37:24.200 [MCA]   value: 300
14:37:24.206 [MCA] source: task_engine
14:37:24.205 [IST]   is_held: true
14:37:24.211 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.211 [IST]   hand_held: 3
14:37:24.216 [MCA] status:
14:37:24.217 [IST] mode: 1
14:37:24.221 [IST] mode_speed: 0.5
14:37:24.222 [MCA]   value: 100
14:37:24.227 [IST] prohibition_broadcast_net: false
14:37:24.227 [MCA] switch_ready: true
14:37:24.232 [IST] task_state:
14:37:24.234 [MCA] ---
14:37:24.237 [IST]   task_type: 1
14:37:24.239 [MCA] current_action:
14:37:24.242 [IST]   task_stage: 2
14:37:24.247 [MCA]   value: 300
14:37:24.249 [IST]   token:
14:37:24.254 [MCA] source: task_engine
14:37:24.258 [IST]     source: ''
14:37:24.264 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.265 [IST]     token: ''
14:37:24.272 [MCA] status:
14:37:24.274 [IST] motion: ''
14:37:24.278 [MCA]   value: 100
14:37:24.285 [IST] percep_env_state: 0
14:37:24.285 [MCA] switch_ready: true
14:37:24.291 [MCA] ---
14:37:24.291 [IST] ---
14:37:24.298 [MCA] current_action:
14:37:24.298 [IST] header:
14:37:24.303 [IST]   stamp:
14:37:24.306 [MCA]   value: 300
14:37:24.309 [IST]     sec: 0
14:37:24.312 [MCA] source: task_engine
14:37:24.315 [IST]     nanosec: 0
14:37:24.317 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.320 [IST]   frame_id: ''
14:37:24.321 [MCA] status:
14:37:24.326 [IST]   sequence: 0
14:37:24.326 [MCA]   value: 100
14:37:24.331 [IST]   meas_stamp:
14:37:24.332 [MCA] switch_ready: true
14:37:24.335 [IST]     sec: 0
14:37:24.337 [MCA] ---
14:37:24.340 [IST]     nanosec: 0
14:37:24.343 [MCA] current_action:
14:37:24.345 [IST] interaction_id: 0
14:37:24.348 [MCA]   value: 300
14:37:24.354 [IST] mp_state:
14:37:24.355 [MCA] source: task_engine
14:37:24.360 [IST]   value: 0
14:37:24.361 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.366 [IST] form_state:
14:37:24.366 [MCA] status:
14:37:24.371 [IST]   current_form: 2
14:37:24.373 [MCA]   value: 100
14:37:24.376 [IST] action_info:
14:37:24.386 [IST]   current_action:
14:37:24.386 [MCA] switch_ready: true
14:37:24.393 [IST]     value: 300
14:37:24.396 [MCA] ---
14:37:24.399 [IST]   source: task_engine
14:37:24.402 [MCA] current_action:
14:37:24.404 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:24.409 [IST]   status:
14:37:24.410 [MCA]   value: 300
14:37:24.416 [MCA] source: task_engine
14:37:24.418 [IST]     value: 100
14:37:24.420 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.423 [IST]   switch_ready: true
14:37:24.426 [MCA] status:
14:37:24.428 [IST] held_state:
14:37:24.431 [MCA]   value: 100
14:37:24.435 [MCA] switch_ready: true
14:37:24.436 [IST]   is_held: true
14:37:24.440 [MCA] ---
14:37:24.441 [IST]   hand_held: 3
14:37:24.446 [MCA] current_action:
14:37:24.447 [IST] mode: 1
14:37:24.451 [MCA]   value: 300
14:37:24.455 [IST] mode_speed: 0.5
14:37:24.461 [IST] prohibition_broadcast_net: false
14:37:24.461 [MCA] source: task_engine
14:37:24.466 [IST] task_state:
14:37:24.467 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.472 [IST]   task_type: 1
14:37:24.472 [MCA] status:
14:37:24.478 [IST]   task_stage: 2
14:37:24.479 [MCA]   value: 100
14:37:24.485 [MCA] switch_ready: true
14:37:24.484 [IST]   token:
14:37:24.497 [MCA] ---
14:37:24.499 [IST]     source: ''
14:37:24.502 [MCA] current_action:
14:37:24.506 [IST]     token: ''
14:37:24.510 [MCA]   value: 300
14:37:24.515 [IST] motion: ''
14:37:24.518 [MCA] source: task_engine
14:37:24.520 [IST] percep_env_state: 0
14:37:24.522 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.525 [IST] ---
14:37:24.528 [MCA] status:
14:37:24.531 [IST] header:
14:37:24.535 [MCA]   value: 100
14:37:24.535 [IST]   stamp:
14:37:24.540 [MCA] switch_ready: true
14:37:24.541 [IST]     sec: 0
14:37:24.546 [IST]     nanosec: 0
14:37:24.545 [MCA] ---
14:37:24.552 [MCA] current_action:
14:37:24.552 [IST]   frame_id: ''
14:37:24.557 [IST]   sequence: 0
14:37:24.557 [MCA]   value: 300
14:37:24.562 [IST]   meas_stamp:
14:37:24.566 [MCA] source: task_engine
14:37:24.569 [IST]     sec: 0
14:37:24.572 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.574 [IST]     nanosec: 0
14:37:24.578 [MCA] status:
14:37:24.579 [IST] interaction_id: 0
14:37:24.584 [MCA]   value: 100
14:37:24.597 [MCA] switch_ready: true
14:37:24.600 [IST] mp_state:
14:37:24.604 [MCA] ---
14:37:24.605 [IST]   value: 0
14:37:24.610 [MCA] current_action:
14:37:24.610 [IST] form_state:
14:37:24.615 [MCA]   value: 300
14:37:24.616 [IST]   current_form: 2
14:37:24.620 [MCA] source: task_engine
14:37:24.620 [IST] action_info:
14:37:24.625 [IST]   current_action:
14:37:24.626 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.630 [IST]     value: 300
14:37:24.631 [MCA] status:
14:37:24.635 [IST]   source: task_engine
14:37:24.637 [MCA]   value: 100
14:37:24.641 [IST]   action_desc: BIPED_LOCOMOTION_WBC
14:37:24.642 [MCA] switch_ready: true
14:37:24.647 [IST]   status:
14:37:24.647 [MCA] ---
14:37:24.653 [IST]     value: 100
14:37:24.653 [MCA] current_action:
14:37:24.660 [IST]   switch_ready: true
14:37:24.665 [MCA]   value: 300
14:37:24.668 [IST] held_state:
14:37:24.672 [MCA] source: task_engine
14:37:24.673 [IST]   is_held: true
14:37:24.678 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.678 [IST]   hand_held: 3
14:37:24.685 [MCA] status:
14:37:24.693 [IST] mode: 1
14:37:24.695 [MCA]   value: 100
14:37:24.698 [IST] mode_speed: 0.5
14:37:24.700 [MCA] switch_ready: true
14:37:24.704 [IST] prohibition_broadcast_net: false
14:37:24.706 [MCA] ---
14:37:24.710 [IST] task_state:
14:37:24.712 [MCA] current_action:
14:37:24.717 [IST]   task_type: 1
14:37:24.719 [MCA]   value: 300
14:37:24.721 [IST]   task_stage: 2
14:37:24.724 [MCA] source: task_engine
14:37:24.727 [IST]   token:
14:37:24.729 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.733 [IST]     source: ''
14:37:24.733 [MCA] status:
14:37:24.737 [IST]     token: ''
14:37:24.738 [MCA]   value: 100
14:37:24.743 [IST] motion: ''
14:37:24.743 [MCA] switch_ready: true
14:37:24.749 [MCA] ---
14:37:24.752 [IST] percep_env_state: 0
14:37:24.757 [MCA] current_action:
14:37:24.759 [IST] ---
14:37:24.765 [IST] header:
14:37:24.764 [MCA]   value: 300
14:37:24.770 [IST]   stamp:
14:37:24.772 [MCA] source: task_engine
14:37:24.775 [IST]     sec: 0
14:37:24.781 [IST]     nanosec: 0
14:37:24.782 [MCA] action_desc: BIPED_LOCOMOTION_WBC
14:37:24.789 [IST]   frame_id: ''
14:37:24.792 [MCA] status:
14:37:24.798 [IST]   sequence: 0
14:37:24.799 [MCA]   value: 100


===== FILE: raw/logs/README.md  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/05_GPT架构评审/20261127_handheld/input_bundle/raw/logs/README.md) =====

# UC3 真机日志摘录（c2_events.log）

## 来源
- 原始文件：`03_参考库/qiliang_T1Pro报告库/docs/primebot/on_device_measured_data/c2_events.log`（10.8 MB，**未打包**）
- 设备端 2026-10-28 会话，UC3「牵手跟随」；
- 本目录只保留：状态变化表 + 4 个原始窗口。

## 文件
| 文件 | 内容 |
|---|---|
| `uc3_state_timeline.csv` | 由日志解析出的状态变化（action / is_held / hand_held / form / follow），39 行 |
| `uc3_enter_biped.log` | 14:35:13.5–14:35:19.5，`QUADRUPED_TO_BIPED_ROTATE` → `BIPED_LOCOMOTION_WBC` |
| `uc3_held_on.log` | 14:37:23.8–14:37:25.2，`is_held` 首次变为 true |
| `uc3_held_off.log` | 14:37:47.8–14:37:49.2，第一次 `is_held` 变回 false |
| `uc3_follow_window.log` | 14:37:23.5–14:37:24.8，含 `[FLW] state` 变化 |

## 实测时间线（关键点）
| 时刻 | 事件 |
|---|---|
| 14:35:13.982 | `QUADRUPED_TO_BIPED_ROTATE`（11） |
| 14:35:18.822 | `BIPED_LOCOMOTION_WBC`（300） |
| 14:35:24.716 | `hand_held` 首次变为 1（BOTH_NOT_HELD） |
| 14:37:24.205 | **`is_held: true`**，随后 `hand_held: 3`（RIGHT_HELD_ONLY） |
| 14:37:48.634 | `is_held: false`（第一次松开） |
| 14:39:30.427 | 再次 `is_held: true`（hand_held=3） |
| 14:39:45.661 | `is_held: false` |
| 14:40:02.221 | 再次 `is_held: true` |
| 14:40:40.760 | `is_held: false` |
| 14:40:46.385 | 再次 `is_held: true` |

## held 区间
| 开始 | 结束 | 时长 |
|---|---|---|
| 14:37:24.205 | 14:37:48.634 | 24.4 s |
| 14:39:30.427 | 14:39:45.661 | 15.2 s |
| 14:40:02.221 | 14:40:40.760 | 38.5 s |
| 14:40:46.385 | 日志结束（未再清零） | 1.7 s |

> 说明：`is_held` 与 `hand_held` 是同一消息里的相邻字段，日志按字段逐行 dump，所以 `is_held=true` 的那一行后面 6 ms 才出现 `hand_held=3`。不要把 6 ms 的差当成真实状态机中间态。

## 能证明什么 / 不能证明什么
**能证明**
1. 整个牵手过程 `action_desc` 始终是 `BIPED_LOCOMOTION_WBC`，**动作没有切换**；
2. `held_state` 在 300 内多次 on/off，是 runner/MC 内部状态，不是 Action；
3. `hand_held` 稳定为 3（右手单牵）；`form=2`（双足）；
4. 进入 300 后约 2 分 5 秒才首次 held，说明不是"一进 300 就置位"，而是外力触发。

**不能证明**
- 速度指令、关节角、`arm_drag` 解算中间量（日志不含 `McCommonState` 的速度/命令字段）；
- `held_state` 与内部 `drag_active` 是否同一判据；
- 拖拽指令与视觉速度的仲裁关系。

> 完整日志未打包；需要更多窗口时让用户从工作区补齐，不要在报告里假装读过。
