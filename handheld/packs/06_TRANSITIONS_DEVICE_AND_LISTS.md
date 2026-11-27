# Pack 06 · 变身 runner / 设备 / 动作与模型清单

重点：102→10/11→300 的那两个 runner 的真实配置（Q2B 的策略、重力包络、`max_cycle_time`）；device_manager 的 MIT 参数与周期；motion_list 与派生的动作/权重/规则图统计。


===== FILE: raw/t1/qd1_t2d0/rl/quad_to_bi_run.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/quad_to_bi_run.yaml) =====

BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  # policy:
  #   type: "rknn"
  #   device: "rk3588"
  #   path: "./rl_models/model_run.rknn"
  policy:
    type: "onnx"
    device: "cpu"
    # path: "./rl_models/t15_quad2bi_norm_test_0418.onnx"
    # path: "./rl_models/t15_quad2bi_norm_v1.3_test.onnx"
    path: "./rl_models/t2.2_quad2bi_norm_0708.onnx"

  # obs-action nums will be obtained by urdf
  obs_nums: 51
  q_nums: 14
  action_nums: 14

  joints_name:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',
      
      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  #define the obs sequence
  seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',

      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  # define the action sequence
  action_seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',
      
      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  action_scale: [ 0.05, 0.05, 0.05, 
                  0.05, 0.05, 0.05, 
                  0.1, 0.25, 0.25, 2.0, 
                  0.1, 0.25, 0.25, 2.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 50.0
    action_clip: 50.0

  reduction:   
    wheel_reduction: 4.0
    hip_reduction: 0.0

  action:
    activation: [   0.0, 1.0, 1.0, 
                    0.0, 1.0, 1.0, 
                    0.0, 1.0, 1.0, 1.0, 
                    0.0, 1.0, 1.0, 1.0 ]

  # planner:
  #   enable: false
  #   velocity: 10
  #   acceleration: 10
  #   dt: 1   # ms

  robot:
    # seq same as action_seq
    # real params
    kps: [ 
      30.0, 30.0, 30.0, 
      30.0, 30.0, 30.0, 
      30.0, 30.0, 30.0, 0.0, 
      30.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0 ]
    default_dof_pos: [ 
      0.0, 0.7055, -1.3825, 
      0.0, 0.7055, -1.3825, 
      0.0, 1.1554, -1.8314, 0.0, 
      0.0, 1.1554, -1.8314, 0.0 ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  gravity_guard:
    enable: true
    path: "./res/transition_gravity_record/qd1_t2d0_QUADRUPED_TO_BIPED_20260910_212902.csv"
    threshold_deg: 30.0
    count_threshold: 2
  gravity_record:
    enable: false
    output_dir: "./transition_gravity_record"

  max_cycle_time: 0.9

  # define obs index
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    phase: 46
    q_ref: 47

  walk:
    switch_stand_walk: false
    walk_mode: true
    stand_cmd_threshold: 0.05

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]
  
  custom:
    stand_dof_pos: [
        0.0, 1.57080, 0.6302,
        0.0, 1.57080, 0.6302,
        0.0, 1.91986, -0.6579, 0.0,
        0.0, 1.91986, -0.6579, 0.0
      ]
    start_time: 0.5
    flip_time: 1.5
    # rotate_time: 3.5
    diff: 0.1
    stance_width_r: 0.278
    foot_rad_r: 0.07

  exit_timeout: 0.2
  stand_actions: [ 'QUADRUPED_TO_BIPED']


===== FILE: raw/t1/qd1_t2d0/rl/quad_to_bi_rotate_run.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/quad_to_bi_rotate_run.yaml) =====

BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  # policy:
  #   type: "rknn"
  #   device: "rk3588"
  #   path: "./rl_models/model_run.rknn"
  policy:
    type: "onnx"
    device: "cpu"
    # path: "./rl_models/t15_quad2bi_yaw_v1.2_test.onnx" 
    # path: "./rl_models/t15_quad2bi_rotate_v1.5_test.onnx"
    # path: "./rl_models/t2_quad2bi_yaw_v1.1_test.onnx" 
    # path: "./rl_models/t2_q2b_yaw_v1.1.2_1.8.onnx" 
    path: "./rl_models/t2_quad2bi_yaw_6837.onnx" 

  # obs-action nums will be obtained by urdf
  obs_nums: 54
  q_nums: 14
  action_nums: 14

  joints_name:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',
      
      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  #define the obs sequence
  seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',

      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  # define the action sequence
  action_seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',
      
      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  action_scale: [ 0.0, 0.05, 0.05, 
                  0.0, 0.05, 0.05, 
                  0.1, 0.25, 0.25, 2.0, 
                  0.1, 0.25, 0.25, 2.0 ]

  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 50.0
    action_clip: 50.0

  reduction:   
    wheel_reduction: 10.0
    hip_reduction: 0.0

  action:
    activation: [   0., 1.0, 1.0, 
                    0., 1.0, 1.0, 
                    0., 1.0, 1.0, 1.0, 
                    0., 1.0, 1.0, 1.0 ]
    policy_scale: 1.0 # 策略输出所占比例
    wheel_ref_scale: 0.0 # wheel ref 所占比例

  # planner:
  #   enable: false
  #   velocity: 10
  #   acceleration: 10
  #   dt: 1   # ms

  robot:
    # seq same as action_seq
    # real params
    kps: [ 
      50.0, 30.0, 30.0, 
      50.0, 30.0, 30.0, 
      100.0, 30.0, 30.0, 0.0, 
      100.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.5, 1.0, 1.0, 1.0, 
      1.5, 1.0, 1.0, 1.0 ]
    default_dof_pos: [ 
      0.0, 0.7055, -1.3825, 
      0.0, 0.7055, -1.3825, 
      0.0, 1.1554, -1.8314, 0.0, 
      0.0, 1.1554, -1.8314, 0.0 ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  gravity_guard:
    enable: true
    path: "./res/transition_gravity_record/qd1_t2d0_QUADRUPED_TO_BIPED_ROTATE_20260910_212646.csv"
    threshold_deg: 30.0
    count_threshold: 2
  gravity_record:
    enable: false
    output_dir: "./transition_gravity_record"

  max_cycle_time: 0.9

  # define obs index
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    imu_yaw_diff: 46
    phase: 48
    rotate_phase: 49
    q_ref: 50

  walk:
    switch_stand_walk: false
    walk_mode: true
    stand_cmd_threshold: 0.05

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]
  
  custom:
    stand_dof_pos: [
        0.0, 1.57080, 0.6302,
        0.0, 1.57080, 0.6302,
        0.0, 1.91986, -0.6579, 0.0,
        0.0, 1.91986, -0.6579, 0.0
      ]

    start_time: 1.0
    flip_time: 2.0
    rotate_time: 2.5
    diff: 0.1
    stance_width_r: 0.2634
    foot_rad_r: 0.07

  exit_timeout: 0.5
  stand_actions: [ 'QUADRUPED_TO_BIPED']


===== FILE: raw/t1/qd1_t2d0/rl/bi_to_quad_run.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/bi_to_quad_run.yaml) =====

BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  # policy:
  #   type: "rknn"
  #   device: "rk3588"
  #   path: "./rl_models/model_run.rknn"
  policy:
    type: "onnx"
    device: "cpu"
    # path: "./rl_models/t15_bi2quad_norm_v1.4.onnx"
    path: "./rl_models/t2_b2q_norm_v1.0_0601.onnx"
    # path: "./rl_models/t15_bi2quad_norm_0524.onnx"

  # obs-action nums will be obtained by urdf
  obs_nums: 51
  q_nums: 14
  action_nums: 14

  joints_name:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',
      
      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  #define the obs sequence
  seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',

      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  # define the action sequence
  action_seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',
      
      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  action_scale: [ 0.05, 0.05, 0.05,
                  0.05, 0.05, 0.05, 
                  0.1, 0.2, 0.2, 2.0, 
                  0.1, 0.2, 0.2, 2.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 50.0
    action_clip: 50.0

  reduction:   
    wheel_reduction: 4.0
    hip_reduction: 0.0
  
  action:
    activation: [   0.0, 1.0, 1.0, 
                    0.0, 1.0, 1.0, 
                    0.0, 1.0, 1.0, 1.0, 
                    0.0, 1.0, 1.0, 1.0 ]
  # planner:
  #   enable: false
  #   velocity: 10
  #   acceleration: 10
  #   dt: 1   # ms

  robot:
    # seq same as action_seq
    # real params
    kps: [ 
      30.0, 30.0, 30.0, 
      30.0, 30.0, 30.0, 
      30.0, 30.0, 30.0, 0.0, 
      30.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0 ]
    default_dof_pos: [ 
        0.0, 1.57080, 0.63024,
        0.0, 1.57080, 0.63024,
        0.0, 1.91986, -0.65798, 0.0,
        0.0, 1.91986, -0.65798, 0.0
      ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  gravity_guard:
    enable: true
    path: "./res/transition_gravity_record/qd1_t2d0_BIPED_TO_QUADRUPED_20260910_212658.csv"
    threshold_deg: 30.0
    count_threshold: 2
  gravity_record:
    enable: false
    output_dir: "./transition_gravity_record"

  max_cycle_time: 0.9

  # define obs index
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    phase: 46
    q_ref: 47

  walk:
    switch_stand_walk: false
    walk_mode: true
    stand_cmd_threshold: 0.05

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]
  
  custom:
    stand_dof_pos: [
      0.0, 0.7055, -1.3825, 
      0.0, 0.7055, -1.3825, 
      0.0, 1.1554, -1.8314, 0.0, 
      0.0, 1.1554, -1.8314, 0.0 ]

    start_time: 0.5
    flip_time: 2.0
    turn_ratio: 0.5
    diff: 0.1

  exit_timeout: 0.5
  stand_actions: [ 'QUADRUPED_TO_BIPED']


===== FILE: raw/t1/qd1_t2d0/rl/bi_to_quad_rotate_run.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/bi_to_quad_rotate_run.yaml) =====

BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  # policy:
  #   type: "rknn"
  #   device: "rk3588"
  #   path: "./rl_models/model_run.rknn"
  policy:
    type: "onnx"
    device: "cpu"

    # path: "./rl_models/bi2quad_speed_0128.onnx"
    path: "./rl_models/t15_bi2quad_rotate_v1.1_terrain.onnx" 
    # path: "./rl_models/t2_b2q_speed_0602_test.onnx"
    # path: "./rl_models/t2_b2q_speed_v1.0_0601.onnx"

  # obs-action nums will be obtained by urdf
  obs_nums: 54
  q_nums: 14
  action_nums: 14

  joints_name:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',

      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  #define the obs sequence
  seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',

      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  # define the action sequence
  action_seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',

      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  # action_scale: [ 0.35, 0.35, 0.35, 
  #                 0.35, 0.35, 0.35, 
  #                 0.35, 0.35, 0.35, 0.35, 
  #                 0.35, 0.35, 0.35, 0.35 ]

  action_scale: [ 0.05, 0.05, 0.05, 
                  0.05, 0.05, 0.05, 
                  0.1, 0.2, 0.2, 2.0, 
                  0.1, 0.2, 0.2, 2.0 ]

  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 200.0
    action_clip: 200.0

  reduction:   
    wheel_reduction: 4.0
    hip_reduction: 0.0

  action:
    activation: [   0., 1.0, 1.0, 
                    0., 1.0, 1.0, 
                    0., 1.0, 1.0, 1.0, 
                    0., 1.0, 1.0, 1.0 ]

  # planner:
  #   enable: false
  #   velocity: 10
  #   acceleration: 10
  #   dt: 1   # ms

  robot:
    # seq same as action_seq
    # real params
    kps: [ 
      30.0, 30.0, 30.0, 
      30.0, 30.0, 30.0, 
      80.0, 30.0, 30.0, 0.0, 
      80.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.5, 1.0, 1.0, 1.0, 
      1.5, 1.0, 1.0, 1.0 ]
    default_dof_pos: [ 
        0.0, 1.57080, 0.6302,
        0.0, 1.57080, 0.6302,
        0.0, 1.91986, -0.6579, 0.0,
        0.0, 1.91986, -0.6579, 0.0
      ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  gravity_guard:
    enable: true
    path: "./res/transition_gravity_record/qd1_t2d0_BIPED_TO_QUADRUPED_ROTATE_20260910_212957.csv"
    threshold_deg: 30.0
    count_threshold: 2
  gravity_record:
    enable: false
    output_dir: "./transition_gravity_record"

  max_cycle_time: 0.9

  # define obs index
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    imu_yaw_diff: 46
    phase: 48
    rotate_phase: 49
    q_ref: 50

  walk:
    switch_stand_walk: false
    walk_mode: true
    stand_cmd_threshold: 0.05

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 50, 
      100, 100, 100, 50]

  custom:
    stand_dof_pos: [
      0.0, 0.7055, -1.3825, 
      0.0, 0.7055, -1.3825, 
      0.0, 1.1554, -1.8314, 0.0, 
      0.0, 1.1554, -1.8314, 0.0  
      ]
    start_time: 0.0
    flip_time: 2.5
    rotate_time : 2.5
    transition_duration: 0.3  # RL接管平滑时长(秒)
    stance_width_r: 0.278
    foot_rad_r: 0.07
    phase_offset: 1.2


  exit_timeout: 0.5
  stand_actions: [ 'QUADRUPED_TO_BIPED']


===== FILE: raw/t1/qd1_t2d0/rl/bi_loco_animation.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/bi_loco_animation.yaml) =====

BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  # policy:
  #   type: "rknn"
  #   device: "rk3588"
  #   path: "./rl_models/model_run.rknn"
  policy:
    type: "onnx"
    device: "cpu"
    # path: "./rl_models/wbc_delay0110.onnx"
    # path: "./rl_models/t1_bi_wbc_v1.0_0110_delay.onnx"
    # path: "./rl_models/wbc_terrain_lift0515.onnx"
    # path: "./rl_models/wbc0517.onnx"
    path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    
    

  # obs-action nums will be obtained by urdf
  obs_nums: 51
  q_nums: 14
  action_nums: 14

  joints_name:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',
      
      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  #define the obs sequence
  seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',

      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',

      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  # define the action sequence
  action_seq:
    [
      'FL_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint',
      'FL_KNEE_Joint',

      'FR_HIP_ROLL_Joint',
      'FR_HIP_PITCH_Joint',
      'FR_KNEE_Joint',
      
      'RL_HIP_ROLL_Joint',
      'RL_HIP_PITCH_Joint',
      'RL_KNEE_Joint',
      'RL_FOOT_Joint',
      
      'RR_HIP_ROLL_Joint',
      'RR_HIP_PITCH_Joint',
      'RR_KNEE_Joint',
      'RR_FOOT_Joint',
    ]

  action_scale: [ 0.1, 0.1, 0.1,
                  0.1, 0.1, 0.1, 
                  0.1, 0.2, 0.2, 2.0, 
                  0.1, 0.2, 0.2, 2.0 ]
                  
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 20.0
    action_clip: 20.0

  reduction:   
    wheel_reduction: 1.0
    hip_reduction: 0.0

  # planner:
  #   enable: false
  #   velocity: 10
  #   acceleration: 10
  #   dt: 1   # ms

  robot:
    # seq same as action_seq
    # real params
    kps: [ 
      30.0, 30.0, 30.0, 
      30.0, 30.0, 30.0, 
      100.0, 30.0, 30.0, 0.0, 
      100.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.5, 1.0, 1.0, 0.5, 
      1.5, 1.0, 1.0, 0.5 ]

    default_dof_pos: [ 
      0.0, 1.57080, 0.6302,
      0.0, 1.57080, 0.6302,
      0.0, 1.91986, -0.6579, 0.0,
      0.0, 1.91986, -0.6579, 0.0 ]
    
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  # define obs index
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    command: 46
    z: 47
    yaw: 48
    # 无 ani 时 obs[49/50]=contact [1,1]；有 ani 时为 base_roll/base_pitch
    roll: 49
    pitch: 50

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    vx: 1.5
    height: 0.0
    dyaw: 1.0


  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 50, 
      100, 100, 100, 50]

  limits:
    lower_limit: [-0.43633, -1.1868, -2.5831, -0.43633, -1.1868, -2.5831 ]
    upper_limit: [0.43633,   4.3284,  2.5831,  0.43633,  4.3284,  2.5831 ]

  odom:
    wheel_radius: 0.07
    #odom_enable_x: 0.3
    odom_enable_x: 0.3
    odom_kp_x: 0.5
    odom_kd_x: 0.02
    max_vel_x: 0.3
    max_vel_yaw: 0.5
    odom_enable_yaw: 0.3
    odom_kp_yaw: 0.1
    max_delta_yaw: 2.0
    odom_log_decimation: 1
    # x方向累计位置误差限幅
    max_delta_x: 10
    # x方向补偿降采样：
    # 1 = 每步更新补偿
    # 2 = 每2步更新一次补偿
    # 5 = 每5步更新一次补偿
    # 注意：CalculateDelta() 仍然每步执行
    odom_comp_decimation: 1
    # 从其它模式/action切换过来后，前多少秒不启用里程计补偿
    odom_disable_after_switch_s: 0

  stand_actions: [ 'BIPEDAL_STAND_DEFAULT']
  acc_x: 3.0
  v_z: 0.2
  acc_yaw: 3.0
  exit_wait_step: 20
  bias_vx : -0
  bias_h : 0.0
  bias_dyaw : 0.0
  # obs[47] = (z - default_z) * lin_vel when ani CSV has base_pos_body_z
  default_z: 0.0

  yaw_acc:
    d_fast: 3.0        
    d_slow: 0.0        


===== FILE: raw/t1/hardware/device_manager_t1_v2d0.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/device_manager/cfg/t1_v2d0_config.yaml) =====

aimrt:
  main_thread:
    name: device_manager
    # thread_sched_policy: SCHED_RR:80 # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx ver = 0.2.2
    # thread_bind_cpu: [ 6 ]
  guard_thread:
    name: guard_thread
    thread_sched_policy: SCHED_OTHER
    thread_bind_cpu: []

  log:
    core_lvl: Error           # 内核日志等级 可选项:Trace/Debug/Info/Warn/Error/Fatal/Off (不区分大小写)
    default_module_lvl: Info  # 模块日志等级 可选项:Trace/Debug/Info/Warn/Error/Fatal/Off (不区分大小写)
    backends:
    - type: console # 控制台日志配置
      options:
        color: true
        pattern: "[%c.%f][%l][%t][%G:%R] %v"
        module_filter: "(.*)"
    - type: rotate_file # 文件日志
      options:
        path: ${LOG_PATH}  # 日志文件路径
        filename: device_manager.log   # 日志文件名称
        max_file_size_m: 10 # 日志文件最大尺寸，单位m
        max_file_num: 10    # 最大日志文件数量，0代表无限
        pattern: "[%c.%f][%l][%t][%G:%R] %v"

  plugin:
    plugins:
    - name: nsm_plugin
      path: libaimrt_nsm_plugin.so
      options:
        node_name: ${EM_APP_NAME}
        state_reporting_executor: nsm_state_reporting_executor
        state_reporting_period:
          value: 1
          unit: sec
        modules_processing_executor: nsm_modules_processing_executor
    - name: ros2_plugin
      path: ../lib/libaimrt_ros2_plugin.so
      options:
        node_name: device_manager_node
        executor_name: rt_topic_sub
        executor_type: StaticSingleThreaded # SingleThreaded/StaticSingleThreaded/MultiThreaded
        # TODO(caojin): AimRT v1.2.0 不支持当前字段配置
        # executor_sched_policy: SCHED_OTHER # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx ver = 0.2.2
        # executor_bind_cpus: []
    - name: iceoryx_plugin
      path: ../lib/libaimrt_iceoryx_plugin.so
      options:
        runtime_id: device_manager_node
        shm_init_size: 4096

  executor:
    executors:
    - type: asio_thread
      name: nsm_state_reporting_executor
    - type: asio_thread
      name: nsm_modules_processing_executor
    - name: rt_dev_ioctl
      type: asio_thread
      options:
        thread_num: 2
        thread_bind_cpu: [ 2 ]
        thread_sched_policy: SCHED_RR:80 # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx ver = 0.2.2
    - name: rt_dev_poll
      type: asio_thread
      options:
        thread_num: 1
        thread_bind_cpu: [ 2 ]
        thread_sched_policy: SCHED_RR:80 # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx ver = 0.2.2
    - name: rt_topic_pub
      type: asio_thread
      options:
        thread_num: 1
        thread_sched_policy: SCHED_RR:80 # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx ver = 0.2.2
        thread_bind_cpu: [ 2 ]
    - name: st_topic_pub
      type: asio_thread
      options:
        thread_num: 1
        thread_bind_cpu: [  ]
        thread_sched_policy: SCHED_OTHER # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx ver = 0.2.2
    - name: rpc_executor
      type: asio_thread
      options:
        thread_num: 1
        thread_bind_cpu: [  ]
        thread_sched_policy: SCHED_OTHER
    - name: rpc_handle
      type: time_wheel
      options:
        bind_executor: rpc_executor

  channel:
    backends:
    - type: local
    - type: ros2
      options:
        pub_topics_options:
        - topic_name: "/aima/hal/joint/info"
          qos:
            history: keep_last
            depth: 1
            reliability: reliable
            durability: transient_local        
        - topic_name: "(.*)"
          qos:
            reliability: best_effort
        sub_topics_options:
        - topic_name: "(.*)"
          qos:
            reliability: best_effort
    - type: iceoryx
      options:
        listener_thread_name: "rt_iceoryx_sub"
        listener_thread_sched_policy: SCHED_RR:85 # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx ver = 0.2.2
        listener_thread_bind_cpu: [ 2 ]

    sub_topics_options:
    # ros2数据类型 aimdk_msgs::msg::JointCommandArray
    - topic_name: /aima/hal/joint/command
      enable_backends: 
      - ${TOPIC_ENABLE_BACKENDS}
    # ros2数据类型 aimdk_msgs::msg::SmSystemState
    - topic_name: /aima/sm/system_state
      enable_backends:
      - ros2
    pub_topics_options:
    - topic_name: /aima/hal/imu/torso/state
      enable_backends:
      - ${TOPIC_ENABLE_BACKENDS}
    # ros2数据类型 aimdk_msgs::msg::JointInfoArray
    - topic_name: /aima/hal/joint/info
      enable_backends:
      - ros2
    # ros2数据类型 aimdk_msgs::msg::JointCommandArray
    - topic_name: /aima/hal/joint/mujoco/command
      enable_backends:
      - ros2
    # ros2数据类型 aimdk_msgs::msg::DiagnosticInfoArray
    - topic_name: /aima/hds/diagnostic_list
      enable_backends:
      - ros2
    # ros2数据类型 aimdk_msgs::msg::JointStateArray
    - topic_name: /aima/hal/joint/state
      enable_backends: 
      - ${TOPIC_ENABLE_BACKENDS}

  rpc:
    backends:
    - type: ros2
      options:
        timeout_executor: rpc_handle
    clients_options:
    - func_name: "(.*)"
      enable_backends: [ ros2 ]

  module:
    pkgs:
    - path: ../lib/libdevice_manager_pkg.so
      enable_modules: [ MotorModule ]

# CANFDModule模块自定义配置
MotorModule:
  manager:
    publish_interval_ms: 2
    upper_node:
      name: "upper_node"
      device:
        name: "can0"
        bitrate: 1000000
        sample_point: 80
        data_bitrate: 5000000
        data_sample_point: 75
      config:
        name: [ "(J1)左臂关节1", "(J2)左臂关节2", "(J3)左臂关节3", "(J1)右臂关节1", "(J2)右臂关节2", "(J3)右臂关节3" ]
        urdf_name: [ "FL_HIP_ROLL_Joint", "FL_HIP_PITCH_Joint", "FL_KNEE_Joint", "FR_HIP_ROLL_Joint", "FR_HIP_PITCH_Joint", "FR_KNEE_Joint" ]
        module_id: [ 0x34, 0x34, 0x34, 0x34, 0x34, 0x34 ]
        submodule_id: [ 0x11, 0x12, 0x13, 0x21, 0x22, 0x23 ]
        offset: [ -0.4712, -1.2217, -2.618, 0.4712, -1.2217, -2.618 ]
        direction: [ 1, 1, 1, 1, -1, -1 ]
        min_limits: [ -0.4712, -1.2217, -2.618, -0.4712, -1.2217, -2.618 ]
        max_limits: [ 0.4712, 4.3633, 2.6180, 0.4712, 4.3633, 2.6180 ]
        mit_params:
          [
            # pMin | pMax | vMin | vMax | tMin | tMax | kpMin | kpMax | kdMin | kdMax
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # FL_HIP_ROLL_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # FL_HIP_PITCH_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # FL_KNEE_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # FR_HIP_ROLL_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # FR_HIP_PITCH_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ] # FR_KNEE_Joint
          ]
    lower_node:
      name: "lower_node"
      device:
        name: "can1"
        bitrate: 1000000
        sample_point: 80
        data_bitrate: 5000000
        data_sample_point: 75
      config:
        name: [ "(J1)左腿关节1", "(J2)左腿关节2", "(J3)左腿关节3", "(J4)左腿关节4", "(J1)右腿关节1", "(J2)右腿关节2", "(J3)右腿关节3", "(J4)右腿关节4" ]
        urdf_name: [ "RL_HIP_ROLL_Joint", "RL_HIP_PITCH_Joint", "RL_KNEE_Joint", "RL_FOOT_Joint", "RR_HIP_ROLL_Joint", "RR_HIP_PITCH_Joint", "RR_KNEE_Joint", "RR_FOOT_Joint" ]
        module_id: [ 0x34, 0x34, 0x34, 0x34, 0x34, 0x34, 0x34, 0x34 ]
        submodule_id: [ 0x41, 0x42, 0x43, 0x44, 0x51, 0x52, 0x53, 0x54 ]
        offset: [ -1.5708, 3.1416, -2.5307, 0, 1.5708, 3.1416, -2.5307, 0 ]
        direction: [ -1, 1, 1, 1, -1, -1, -1, -1 ]
        min_limits: [ -1.5708, 0, -2.5307, -10, -1.5708, 0, -2.5307, -10 ]
        max_limits: [ 1.5708, 3.1416, -0.1745, 10.0, 1.5708, 3.1416, -0.1745, 10.0 ]
        mit_params:
          [
            # pMin | pMax | vMin | vMax | tMin | tMax | kpMin | kpMax | kdMin | kdMax
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # RL_HIP_ROLL_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # RL_HIP_PITCH_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # RL_KNEE_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # RL_FOOT_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # RR_HIP_PITCH_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # RR_HIP_ROLL_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ], # RR_KNEE_Joint
            [ -10, 10.0, -60, 60.0, -60, 60.0, 0.0, 500.0, 0.0, 10.0 ] # RR_FOOT_Joint
          ]

  # Standard Topic Manager Configuration
  st_topic_manager:
    enable: true
    executor: st_topic_pub
    basic_interval_ms: 2
    joint_info_node:
      enable: false
      topic: "/aima/hal/joint/info"
      tick_interval: 5000
    joint_mujoco_node:
      enable: false
      topic: "/aima/hal/joint/mujoco/command"
      tick_interval: 500
    hds_diagnostic_node:
      enable: true
      topic: "/aima/hds/diagnostic_list"
      tick_interval: 500

  # Read-Time Topic Manager Configuration
  rt_imu_topic_manager:
    enable: true
    executor: rt_topic_pub
    topic: "/aima/hal/imu/torso/state"
    publish_interval_ms: 2

  rt_joint_topic_manager:
    enable: true
    executor: rt_topic_pub
    topic: "/aima/hal/joint/state"
    publish_interval_ms: 1

  sub_topic_manager:
    joint_command_node:
      enable: true
      topic: "/aima/hal/joint/command"
    system_state_node:
      enable: false
      topic: "/aima/sm/system_state"


===== FILE: raw/t1/qd1_t2d0/remote_controller_config/operation_config.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/remote_controller_config/operation_config.yaml) =====

# 基础操控参数
deviceConfig:
  # 左侧手的类型：0：没有 1：灵巧手 2：夹爪
  left_hand_type: 1
  # 右侧手的类型：0：没有 1：灵巧手 2：夹爪
  right_hand_type: 1
  # 遥操作设备类型：0：picoVR 1:动捕服 2：  
  remote_device_type: 0
  # VR录入数据的坐标系类型：0:右手系 1：左手系
  input_msg_axis_type: 1

basicConfig:
  # 0:遥操作模式 1：关节单独测试模式 2：replay 3:力矩补偿状态 
  running_mode: 0
  # 等待时间，单位ms，等待系统准备完毕之后再进行运行,1000对应1s
  wait_time: 100
  # 关节测试时，单位ms，等待时间结束之后，用于进行位置初始化,1000对应1s
  initial_time: 2000
  # 关节单独测试时，测试的关节的ID
  jointTestConfig:
    test_joint: 0
    # 关节测试时关节活动范围的比例系数，避免转动过大角度或者碰撞限位
    maxAngle_index: 0.95
    minAngle_index: 0.95
    # 关节测试时的关节运转速度，0.002表示1弧度1s的角速度
    vel_dAngle: 0.001

# 打印信息配置
printBasicInfo:
  # 打印间隔，单位ms，1000对应1s钟，如果设置成0就是不打印，如果设置的间隔小于线程运行周期，则按照线程运行周期打印
  print_interval: 1000
  # VR输入数据打印
  vr_input: 1
  # 关节范围打印
  joint_range: 1
  # 关节规划角度打印
  joint_planning: 1
  # 关节当前角度打印
  joint_current: 1
  # 夹爪信息打印
  hand_info: 1
  # 奇异信息打印
  sigma_cond: 1
  # 位置跟踪信息打印
  position_track: 1

# ros2 topic debug out:
debugTopicSwitch: 0

vr_input_filter_length: 1
vr_filter_threshold: 0.2

===== FILE: raw/model_list/motion_list.md  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/清单/动作库-motion_list.md) =====

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


===== FILE: raw/model_list/rule_graph_stats.md  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/清单/规则图-统计.md) =====

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


===== FILE: raw/model_list/rl_runner_weights.csv  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/清单/RL-runner-权重.csv) =====

action,runner,cfg,period_ms,onnx,obs,act_dim,dt,stack,obs_clip,act_clip
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


===== FILE: raw/model_list/model_network_stats.md  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/清单/模型网络统计.md) =====

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
