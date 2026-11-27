# Pack 01 · 牵手相关配置（WBC / GIMBAL / 动画 / 对照）

重点：`arm_drag` 全字段、`command_scales`、`animation_player` 五档、`damping_default`、以及 `bi_walk`/`quad_walk`/`bi_wbc_dance` 的对照。


===== FILE: raw/t1/qd1_t2d0/rl/bi_wbc_run.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/bi_wbc_run.yaml) =====

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
    # path: "./rl_models/wbc2026071201.onnx"
    # path: "./rl_models/wbcterrain2026081801.onnx"
    # path: "./rl_models/wbc_terrain20260807.onnx"
    # path: "./rl_models/wbcterrain2026083102.onnx"
    path: "./rl_models/wbcterrain2026092602.onnx"
    

  # obs-action nums will be obtained by urdf
  obs_nums: 49
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
      1.0, 0.5, 0.5, 
      1.0, 0.5, 0.5, 
      180.0, 30.0, 30.0, 0.0, 
      180.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      0.2, 0.2, 0.2,
      0.2, 0.2, 0.2, 
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

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    cmd_x_min: -1.4
    cmd_x_max: 1.4
    cmd_yaw_min: -3.0
    cmd_yaw_max: 3.0
    # vx: 1.5
    height: 0.0
    dyaw: 1.2
    xlim_with_yaw: 0.3
    x_acc_clip_scale: 0.5
    drag_x_min: -1.4
    drag_x_max: 1.4
    drag_yaw_min: -3.0
    drag_yaw_max: 3.0
    cmd_x_forward_bias_scale: 1.0
    cmd_x_backward_bias_scale: 1.0

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
    odom_enable_x: 0.3
    odom_kp_x: 0.05
    odom_kd_x: -0.00
    max_vel_x: 0.005
    max_vel_yaw: 0.5
    odom_enable_yaw: 0.2
    odom_kp_yaw: 0.05
    max_delta_yaw: 2.0
    coef: 0.5
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
    odom_disable_after_switch_s: 1

  stand_actions: [ 'BIPEDAL_STAND_DEFAULT']
  acc_x: 1.0        # x 方向减速/刹车加速度
  acc_x_accel: 1.0 # x 方向加速时加速度（原 acc_x * 0.25）
  v_z: 0.2
  acc_yaw: 3.0
  exit_wait_step: 20
  exit_wait_stop_step_min: 20   # 站立/低速最短退出等待（×dt=0.01 → 0.2s）
  exit_wait_stop_step: 100      # 满速最长退出等待（×dt=0.01 → 1.0s）；按 |vx|/|yaw| 相对 command_scales 上限插值
  bias_vx : -0.02
  bias_dyaw : -0.018

  transition_frames: 15 # 15帧 * 0.01 1s
  
  # 拖拽双臂 roll 触发转向（覆盖手柄角速度；右负左正）
  arm_drag:
    enable: true
    deadzone_roll_threshold: 0.17   # rad，约 10°
    w_deadzone_roll_threshold: 0.17   # rad，约 10°
    roll_threshold: 0.2   # rad，持续贴近该 roll 角阈值后进入持续加速
    yaw_spin_confirm_frames: 5
    yaw_spin_accel: 0.8

    yaw_vel: 1.2  
    log_decimation: 1
    # # 上肢 6 关节: FL_ROLL, FL_PITCH, FL_KNEE, FR_ROLL, FR_PITCH, FR_KNEE
    # t: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    # kp: [4.0, 4.0, 4.0, 4.0, 4.0, 4.0]
    # kd: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    # 上肢 6 关节: FL_ROLL, FL_PITCH, FL_KNEE, FR_ROLL, FR_PITCH, FR_KNEE
    t: [1.0, 0.5, 1.0, 1.0, 0.5, 1.0]
    kp: [4.0, 2.0, 4.0, 4.0, 2.0, 4.0]
    kd: [0.2, 0.2, 0.2, 0.2, 0.2, 0.2]

    # 3.5 rad/s
    # yaw_vel_scale_kp: 11.14
    yaw_vel_scale_kp: 20.0
    yaw_vel_scale_kd: 0.4
      #yaw_vel_scale_kd: 6.12
    # yaw_vel_scale_kp: 4.78
    # 1.5m/s
    # bx_qz_cmd_kp: 3.56
    bx_qz_cmd_ka: 0.1
    bx_qz_cmd_kb: 0.01
    # 双手末端前向位移阈值（m）；|z| 低于此不触发前进/后退
    forward_pos_threshold: 0.24
    # 连续满足前进条件的帧数后才下发 x_cmd（100Hz 下 300 帧约 3s）
    forward_confirm_frames: 100
    # 死区补充：手臂 pitch 偏离 default 超过阈值 -> 仍判为牵手。up 小(抬不起自己)；down 须卡在自垂量与反手举到顶量之间
    arm_above_default_pitch_threshold: 0.15
    arm_below_default_pitch_threshold: 1.50
    wheel_default_x: 0.0
    wheel_pos_threshold: 0.02
    wheel_cmd_reduce_kp: 3.0
    wheel_cmd_rise_kp: 3.0
    wheel_decel_reset_threshold: 0.1
    forward_base_accel: 0.0
    forward_base_decel: 0.0
    push_wheel_threshold: 0.5
    push_accel_kp: 3.0
    push_decel_kp: 3.0
    push_release_decel: 0.6
    push_vel_max: 1.4
    push_stop_threshold: 0.05
    push_confirm_frames: 50
  joystick_cooldown_frames: 250
  yaw_acc:
    d_fast: 3.0        
    d_slow: 0.0        

  # 静摩擦力矩补偿：按 joints_name 顺序（q_nums=14 个关节）配置每个关节的静摩擦力矩（N·m）。
  # 位置控制关节（kp>0）：target_pos += sign(tau)*min(fs,|tau|)/kp
  # 速度控制关节（kp=0,kd>0，即轮子）：target_vel += sign(tau)*min(fs,|tau|)/kd
  # 设为 0 表示该关节不补偿。
  # 顺序：FL_ROLL FL_PITCH FL_KNEE  FR_ROLL FR_PITCH FR_KNEE
  #        RL_ROLL RL_PITCH RL_KNEE RL_FOOT  RR_ROLL RR_PITCH RR_KNEE RR_FOOT
  friction_comp:
    static_friction: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.0, 0.0, 0.0, 0.8]

===== FILE: raw/t1/qd1_t2d0/rl/bi_gimbal.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/bi_gimbal.yaml) =====

BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  policy:
    type: "onnx"
    device: "cpu"
    #path: "./rl_models/wbc0517.onnx"
    path: "./rl_models/wbc2026071201.onnx"

  obs_nums: 49
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

  robot:
    kps: [
      50, 50, 50,
      50, 50, 50,
      100.0, 30.0, 30.0, 0.0,
      100.0, 30.0, 30.0, 0.0 ]
    kds: [
      1.5, 1.5, 1.5,
      1.5, 1.5, 1.5,
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
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    command: 46

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    cmd_x_min: -1.2
    cmd_x_max: 1.2
    cmd_yaw_min: -3.0
    cmd_yaw_max: 3.0
    height: 0.0
    dyaw: 1.2
    # 手臂拖拽（牵手/推背）速度限幅
    drag_x_min: -1.0
    drag_x_max: 1.0
    drag_yaw_min: -1.5
    drag_yaw_max: 1.5
    xlim_with_yaw: 0.0

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100,
      100, 100, 100,
      100, 100, 100, 50,
      100, 100, 100, 50]

  odom:
    wheel_radius: 0.07
    odom_enable_x: 0.3
    odom_kp_x: 0.5
    odom_kd_x: 0.02
    max_vel_x: 0.3
    max_vel_yaw: 0.5
    odom_enable_yaw: 0.2
    odom_kp_yaw: 0.1
    max_delta_yaw: 2.0
    odom_log_decimation: 1
    max_delta_x: 10
    odom_comp_decimation: 1
    odom_disable_after_switch_s: 1

  acc_x: 1.0
  acc_x_accel: 1.0
  v_z: 0.2
  acc_yaw: 3.0
  exit_wait_step: 20
  bias_vx: 0.0
  bias_h: 0.0
  bias_dyaw: 0.0

  auto_next_actions: true
  default_next_action: BIPED_LOCOMOTION_WBC

  yaw_acc:
    d_fast: 3.0
    d_slow: 0.0

  planner:
    duration: 2.0
    dt_ms: 10

  gimbal_table:
    - gimbal: 5000
      path: "./classic/gimbal/arm_lift_smooth.csv"  # 平滑抬臂
    - gimbal: 5001
      path: "./classic/gimbal/arm_trajectory_90.csv"  # 90度用户抬臂
    - gimbal: 5002
      path: "./classic/gimbal/arm_trajectory_120.csv"  # 120度用户抬臂

  # 默认使用90度用户抬臂轨迹
  gear_motion_path: "./classic/gimbal/arm_lift_smooth.csv"

  # 用户控臂：level 抬手；roll 摆臂；motion id=4(UseRight) Idle 切换左右手
  user_arm:
    level_max: 90.0
    level_speed_up: 15.0
    level_speed_down: 15.0
    roll_max_left: 45.0
    roll_max_right: 45.0
    roll_speed_left: 15.0
    roll_speed_right: 15.0
    release_confirm_frames: 40  # level≈0 且 roll≈0 连续帧数后退出控臂

  # 手臂拖拽（牵手 + 推背）：复用 WBC 的 ArmDragLocomotion。
  # gimbal 场景一只手持相机（intent_.use_left 控制手，从检测屏蔽），另一只手牵引。
  arm_drag:
    enable: true
    deadzone_roll_threshold: 0.17   # rad，约 10°，|roll| 低于此不转
    w_deadzone_roll_threshold: 0.17
    roll_threshold: 0.3             # rad，持续贴近该角后进入持续加速转圈
    yaw_spin_confirm_frames: 5
    yaw_spin_accel: 2.0
    yaw_vel_scale_kp: 10.0
    yaw_vel_scale_kd: 0.8
    bx_qz_cmd_ka: 3.14
    bx_qz_cmd_kb: 17.5
    forward_pos_threshold: 0.30     # 手端前向位移阈值（BASELINK z, m）
    forward_confirm_frames: 100     # 连续满足前进条件的帧数（100Hz 下约 1s）
    wheel_default_x: 0.0
    wheel_pos_threshold: 0.02
    wheel_cmd_reduce_kp: 18.0
    wheel_cmd_rise_kp: 10.0
    forward_base_accel: 0.0
    forward_base_decel: 0.0
    wheel_decel_reset_threshold: 0.2
    # 推背
    push_wheel_threshold: 5.0
    push_accel_kp: 3.0
    push_decel_kp: 3.0
    push_release_decel: 0.6
    push_vel_max: 1.4
    push_stop_threshold: 0.05
    push_confirm_frames: 50
    joystick_cooldown_frames: 250   # 摇杆活动后禁止推背的冷却帧数

  # 牵引手柔顺：拖拽生效时把牵引手（非相机手）设为「重力补偿浮动」，可被人轻松拉动；相机手保持刚性
  arm_compliance:
    kp: [4.0, 2.0, 4.0]   # roll / pitch / knee
    kd: 0.2
    gravity_scale: 0.6    # 重力矩缩放（<1 略欠补，避免上飘）
    clip_tau: 1.0         # 跟踪 PD 限幅 (N·m)，重力前馈不受限
    rest_return_rate: 0.5 # 静息目标回 default 限速 (rad/s)，越小回落越慢

===== FILE: raw/t1/qd1_t1d5/rl/bi_wbc_run.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/其他机型/qd1_t1d5/配置/rl/bi_wbc_run.yaml) =====

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
    path: "./rl_models/wbc0517.onnx"
    
    

  # obs-action nums will be obtained by urdf
  obs_nums: 49
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
      1.0, 0.5, 1.0, 
      1.0, 0.5, 1.0, 
      100.0, 30.0, 30.0, 0.0, 
      100.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      0.2, 0.2, 0.2,
      0.2, 0.2, 0.2, 
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

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    cmd_x_min: -0.3
    cmd_x_max: 1.0
    # cmd_x_max: 0.5
    cmd_yaw_min: -3.0
      #cmd_yaw_min: -0.78
    cmd_yaw_max: 3.0
      #cmd_yaw_max: 0.78
    # vx: 1.5
    height: 0.0
    dyaw: 1.2
    cmd_x_forward_bias_scale: 1.0
    cmd_x_backward_bias_scale: 1.0


  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 50, 
      100, 100, 100, 50]

  limits:
    lower_limit: [-0.4364, -1.2217, -2.618, -0.4364, -1.2217, -2.618 ]
    upper_limit: [0.4364,   4.3633,  2.618,  0.4364,  4.3633,  2.618 ]

  odom:
    wheel_radius: 0.07
    odom_enable_x: 0.3
    odom_kp_x: 0.5
    odom_kd_x: 0.02
    max_vel_x: 0.3
    max_vel_yaw: 0.5
    odom_enable_yaw: 0.2
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
    odom_disable_after_switch_s: 1

  stand_actions: [ 'BIPEDAL_STAND_DEFAULT']
  acc_x: 1.0        # x 方向减速/刹车加速度
  acc_x_accel: 1.0 # x 方向加速时加速度（原 acc_x * 0.25）
  v_z: 0.2
  acc_yaw: 3.0
  exit_wait_step: 20
  exit_wait_stop_step_min: 20   # 站立/低速最短退出等待（×dt=0.01 → 0.2s）
  exit_wait_stop_step: 100      # 满速最长退出等待（×dt=0.01 → 1.0s）；按 |vx|/|yaw| 相对 command_scales 上限插值
  bias_vx : -0
  bias_dyaw : 0.0

  transition_frames: 15 # 15帧 * 0.01 1s
  
  # 拖拽双臂 roll 触发转向（覆盖手柄角速度；右负左正）
  arm_drag:
    enable: true
    deadzone_roll_threshold: 0.17   # rad，约 10°
    w_deadzone_roll_threshold: 0.17   # rad，约 10°
    roll_threshold: 0.17   # rad，约 10°
    w_roll_threshold: 0.17   # rad，约 10°
    roll_threshold: 0.3   # rad，持续贴近该 roll 角阈值后进入持续加速

    yaw_vel: 1.2
    log_decimation: 1
    # # 上肢 6 关节: FL_ROLL, FL_PITCH, FL_KNEE, FR_ROLL, FR_PITCH, FR_KNEE
    # t: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    # kp: [4.0, 4.0, 4.0, 4.0, 4.0, 4.0]
    # kd: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    # 上肢 6 关节: FL_ROLL, FL_PITCH, FL_KNEE, FR_ROLL, FR_PITCH, FR_KNEE
    t: [1.0, 0.5, 1.0, 1.0, 0.5, 1.0]
    kp: [4.0, 2.0, 4.0, 4.0, 2.0, 4.0]
    kd: [0.2, 0.2, 0.2, 0.2, 0.2, 0.2]

    # 3.5 rad/s
    # yaw_vel_scale_kp: 11.14
    yaw_vel_scale_kp: 10.0
    yaw_vel_scale_kd: 0.8
      #yaw_vel_scale_kd: 6.12
    # yaw_vel_scale_kp: 4.78
    # 1.5m/s
    # bx_qz_cmd_kp: 3.56
    bx_qz_cmd_kp: 3.14
    # 双手末端前向位移阈值（m）；|z| 低于此不触发前进/后退
    forward_pos_threshold: 0.30
    # 连续满足前进条件的帧数后才下发 x_cmd（100Hz 下 300 帧约 3s）
    forward_confirm_frames: 100
    drag_count_threshold: 10  # 牵手判定计数阈值：某只手连续满足触发条件且计数大于该值才上报
    arm_above_default_pitch_threshold: 0.15
    arm_below_default_pitch_threshold: 1.50

  yaw_acc:
    d_fast: 3.0        
    d_slow: 0.0        


===== FILE: raw/t1/qd1_t1d5/rl/bi_gimbal.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/其他机型/qd1_t1d5/配置/rl/bi_gimbal.yaml) =====

BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  policy:
    type: "onnx"
    device: "cpu"
    path: "./rl_models/wbc0517.onnx"

  obs_nums: 49
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

  robot:
    kps: [
      50, 50, 50,
      50, 50, 50,
      100.0, 30.0, 30.0, 0.0,
      100.0, 30.0, 30.0, 0.0 ]
    kds: [
      1.5, 1.5, 1.5,
      1.5, 1.5, 1.5,
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
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    command: 46

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    cmd_x_min: -1.2
    cmd_x_max: 1.2
    cmd_yaw_min: -3.0
    cmd_yaw_max: 3.0
    height: 0.0
    dyaw: 1.2
    # 手臂拖拽（牵手/推背）速度限幅
    drag_x_min: -1.0
    drag_x_max: 1.0
    drag_yaw_min: -1.5
    drag_yaw_max: 1.5
    xlim_with_yaw: 0.0

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100,
      100, 100, 100,
      100, 100, 100, 50,
      100, 100, 100, 50]

  odom:
    wheel_radius: 0.07
    odom_enable_x: 0.3
    odom_kp_x: 0.5
    odom_kd_x: 0.02
    max_vel_x: 0.3
    max_vel_yaw: 0.5
    odom_enable_yaw: 0.2
    odom_kp_yaw: 0.1
    max_delta_yaw: 2.0
    odom_log_decimation: 1
    max_delta_x: 10
    odom_comp_decimation: 1
    odom_disable_after_switch_s: 1

  acc_x: 1.0
  acc_x_accel: 1.0
  v_z: 0.2
  acc_yaw: 3.0
  exit_wait_step: 20
  bias_vx: 0.0
  bias_h: 0.0
  bias_dyaw: 0.0

  auto_next_actions: true
  default_next_action: BIPED_LOCOMOTION_WBC

  yaw_acc:
    d_fast: 3.0
    d_slow: 0.0

  planner:
    duration: 2.0
    dt_ms: 10

  gimbal_table:
    - gimbal: 5000
      path: "./classic/gimbal/arm_lift_smooth.csv"  # 平滑抬臂
    - gimbal: 5001
      path: "./classic/gimbal/arm_trajectory_90.csv"  # 90度用户抬臂
    - gimbal: 5002
      path: "./classic/gimbal/arm_trajectory_120.csv"  # 120度用户抬臂

  # 默认使用90度用户抬臂轨迹
  gear_motion_path: "./classic/gimbal/arm_trajectory_90.csv"

  # 用户控臂：level 抬手；roll 摆臂；motion id=4(UseRight) Idle 切换左右手
  user_arm:
    level_max: 90.0
    level_speed_up: 15.0
    level_speed_down: 15.0
    roll_max_left: 45.0
    roll_max_right: 45.0
    roll_speed_left: 15.0
    roll_speed_right: 15.0
    release_confirm_frames: 40  # level≈0 且 roll≈0 连续帧数后退出控臂

  # 手臂拖拽（牵手 + 推背）：复用 WBC 的 ArmDragLocomotion。
  # gimbal 场景一只手持相机（intent_.use_left 控制手，从检测屏蔽），另一只手牵引。
  arm_drag:
    enable: true
    deadzone_roll_threshold: 0.17   # rad，约 10°，|roll| 低于此不转
    w_deadzone_roll_threshold: 0.17
    roll_threshold: 0.3             # rad，持续贴近该角后进入持续加速转圈
    yaw_spin_confirm_frames: 5
    yaw_spin_accel: 2.0
    yaw_vel_scale_kp: 10.0
    yaw_vel_scale_kd: 0.8
    bx_qz_cmd_ka: 3.14
    bx_qz_cmd_kb: 17.5
    forward_pos_threshold: 0.30     # 手端前向位移阈值（BASELINK z, m）
    forward_confirm_frames: 100     # 连续满足前进条件的帧数（100Hz 下约 1s）
    wheel_default_x: 0.0
    wheel_pos_threshold: 0.02
    wheel_cmd_reduce_kp: 18.0
    wheel_cmd_rise_kp: 10.0
    forward_base_accel: 0.0
    forward_base_decel: 0.0
    wheel_decel_reset_threshold: 0.2
    # 推背
    push_wheel_threshold: 0.03
    push_accel_kp: 3.0
    push_decel_kp: 3.0
    push_release_decel: 0.6
    push_vel_max: 1.4
    push_stop_threshold: 0.05
    push_confirm_frames: 50
    joystick_cooldown_frames: 250   # 摇杆活动后禁止推背的冷却帧数

  # 牵引手柔顺：拖拽生效时把牵引手（非相机手）设为「重力补偿浮动」，可被人轻松拉动；相机手保持刚性
  arm_compliance:
    kp: [4.0, 2.0, 4.0]   # roll / pitch / knee
    kd: 0.2
    gravity_scale: 0.6    # 重力矩缩放（<1 略欠补，避免上飘）
    clip_tau: 1.0         # 跟踪 PD 限幅 (N·m)，重力前馈不受限

===== FILE: raw/t1/qd1_t2d0/classic/animation_player.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/classic/animation_player.yaml) =====

animation_cfg:
  action_period_ms: 4   # 每次 Run 累加的伪时间 (ms)，建议与 AnimationPlayer 实际控制周期一致

  default_kp: 30
  default_kd: 1

  # 打断切新动画：只在前 X 比例帧里找与当前姿态最接近的起始帧（避免误匹配到后半段/末帧）
  switch_start_search_ratio: 0.25

planner:
  default_pos: [0.0, 1.57080, 0.52360, 0.0, 1.57080, 0.52360]
  # Idle 稳态下垂限幅（仅 FillIdleJointCommands；homing 规划不使用）
  tau: [0.5, 0.2, 0.5, 0.5, 0.2, 0.5]
  # tau: [1.0, 0.5, 1.0, 1.0, 0.5, 1.0]

  # enter / exit / putdown / preplaying / switch_motion 归位下发 PD（ArmProfile::Planner）
  joints:
    - name: "FL_HIP_ROLL_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 0.6
    - name: "FL_HIP_PITCH_Joint"
      kp: 2.0
      kd: 0.2
      gravity_scale: 0.6
    - name: "FL_KNEE_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 0.6
    - name: "FR_HIP_ROLL_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 0.6
    - name: "FR_HIP_PITCH_Joint"
      kp: 2.0
      kd: 0.2
      gravity_scale: 0.6
    - name: "FR_KNEE_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 0.6

  # 起播 PrePlaying：时长见本段；下发 PD 用 planner.joints（ArmProfile::Planner）
  preplaying:
    enabled: true       # false：ArmHomingPlanner Begin 直接拒绝，不规划
    speed_rad_s:
      roll: 1.0
      pitch: 1.0
      knee: 1.0
    acceleration: 1.0   # rad/s²；与旧 ArmPlanner 一致。<=0 则匀速
    duration_min_s: 0.1
    duration_max_s: 2.0
    dt_ms: 2
    epsilon: 1.0      # Σ(q_meas-setpoint)²，超过则本拍不推进 (rad²)
    tau_min: -3.0       # N·m，下发力矩裁剪下限
    tau_max: 3.0        # N·m，下发力矩裁剪上限
    settle_frames: 300  # 松手重规划后先稳住再推进

  # enter：PreRunOnce / 冷启动阻塞归位；下发 PD 用 planner.joints（ArmProfile::Planner）
  enter:
    enabled: true       # false：ArmHomingPlanner Begin 直接拒绝，不规划
    speed_rad_s:
      roll: 1.0
      pitch: 1.0
      knee: 1.0
    acceleration: 1.0   # rad/s²；抬起/归位，与旧 velocity=1,acceleration=1 对齐
    duration_min_s: 0.2
    duration_max_s: 8.0
    dt_ms: 2
    epsilon: 1.0      # Σ(q_meas-setpoint)²，超过则本拍不推进 (rad²)
    tau_min: -3.0       # N·m，下发力矩裁剪下限
    tau_max: 3.0        # N·m，下发力矩裁剪上限
    settle_frames: 300  # 松手重规划后先稳住再推进

  # putdown：播完/打断回 idle；下发 PD 用 planner.joints（ArmProfile::Planner）
  putdown:
    enabled: true       # false：ArmHomingPlanner Begin 直接拒绝，不规划
    speed_rad_s:
      roll: 1.0
      pitch: 0.8
      knee: 1.0
    acceleration: 0.6   # rad/s²；放下更柔，软 PD(kp≈2~4) 下建议 0.3~0.5
    duration_min_s: 0.1
    duration_max_s: 10.0
    dt_ms: 2
    epsilon: 1.0      # Σ(q_meas-setpoint)²，超过则本拍不推进 (rad²)
    tau_min: -3.0       # N·m，下发力矩裁剪下限
    tau_max: 3.0        # N·m，下发力矩裁剪上限
    settle_frames: 300  # 松手重规划后先稳住再推进

  # switch_motion：打断切新片段；下发 PD 用 planner.joints（ArmProfile::Planner）
  switch_motion:
    enabled: true       # false：ArmHomingPlanner Begin 直接拒绝，不规划
    speed_rad_s:
      roll: 0.8
      pitch: 0.8
      knee: 0.8
    acceleration: 1.0
    duration_min_s: 0.2
    duration_max_s: 4.0
    dt_ms: 2
    epsilon: 1.0      # Σ(q_meas-setpoint)²，超过则本拍不推进 (rad²)
    tau_min: -3.0       # N·m，下发力矩裁剪下限
    tau_max: 3.0        # N·m，下发力矩裁剪上限
    settle_frames: 300  # 松手重规划后先稳住再推进

  # exit：runner 退出归位；下发 PD 用 planner.joints（ArmProfile::Planner）
  exit:
    enabled: true       # false：ArmHomingPlanner Begin 直接拒绝，不规划
    speed_rad_s:
      roll: 1.0
      pitch: 1.0
      knee: 1.0
    acceleration: 1.0
    duration_min_s: 0.1
    duration_max_s: 5.0
    dt_ms: 2
    epsilon: 1.0      # Σ(q_meas-setpoint)²，超过则本拍不推进 (rad²)
    tau_min: -3.0       # N·m，下发力矩裁剪下限
    tau_max: 3.0        # N·m，下发力矩裁剪上限
    settle_frames: 300  # 松手重规划后先稳住再推进

# hold 播放/保持末帧（kp 较高；不做重力补偿）
hold:
  - name: "FL_HIP_ROLL_Joint"
    kp: 30
    kd: 1
    gravity_scale: 1.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 30
    kd: 1
    gravity_scale: 1.0
  - name: "FL_KNEE_Joint"
    kp: 30
    kd: 1
    gravity_scale: 1.0
  - name: "FR_HIP_ROLL_Joint"
    kp: 30
    kd: 1
    gravity_scale: 1.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 30
    kd: 1
    gravity_scale: 1.0
  - name: "FR_KNEE_Joint"
    kp: 30
    kd: 1
    gravity_scale: 1.0

# 柔性动画播放 + preplaying/switch_motion 过渡 PD（GetPlaybackProfile）
animation:
  - name: "FL_HIP_ROLL_Joint"
    kp: 4.0
    kd: 0.5
    gravity_scale: 0.9
  - name: "FL_HIP_PITCH_Joint"
    kp: 2.0
    kd: 0.5
    gravity_scale: 0.9
  - name: "FL_KNEE_Joint"
    kp: 4.0
    kd: 0.5
    gravity_scale: 0.7
  - name: "FR_HIP_ROLL_Joint"
    kp: 4.0
    kd: 0.5
    gravity_scale: 0.9
  - name: "FR_HIP_PITCH_Joint"
    kp: 2.0
    kd: 0.5
    gravity_scale: 0.9
  - name: "FR_KNEE_Joint"
    kp: 4.0
    kd: 0.5
    gravity_scale: 0.7

# 刚性动画播放 + preplaying/switch_motion 过渡 PD（GetPlaybackProfile）
rigid:
  - name: "FL_HIP_ROLL_Joint"
    kp: 15
    kd: 1
    gravity_scale: 1.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 15
    kd: 1
    gravity_scale: 1.0
  - name: "FL_KNEE_Joint"
    kp: 15
    kd: 1
    gravity_scale: 1.0
  - name: "FR_HIP_ROLL_Joint"
    kp: 15
    kd: 1
    gravity_scale: 1.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 15
    kd: 1
    gravity_scale: 1.0
  - name: "FR_KNEE_Joint"
    kp: 15
    kd: 1
    gravity_scale: 1.0

# idle 静止下垂；tau_g 缩放见各关节 gravity_scale
idle:
  - name: "FL_HIP_ROLL_Joint"
    kp: 4.0
    kd: 0.2
    gravity_scale: 0.6
  - name: "FL_HIP_PITCH_Joint"
    kp: 2.0
    kd: 0.2
    gravity_scale: 0.75
  - name: "FL_KNEE_Joint"
    kp: 4.0
    kd: 0.2
    gravity_scale: 0.6
  - name: "FR_HIP_ROLL_Joint"
    kp: 4.0
    kd: 0.2
    gravity_scale: 0.6
  - name: "FR_HIP_PITCH_Joint"
    kp: 2.0
    kd: 0.2
    gravity_scale: 0.75
  - name: "FR_KNEE_Joint"
    kp: 4.0
    kd: 0.2
    gravity_scale: 0.6

# 默认动画帧率（未在 ani_table 指定 fps 时使用）
default_fps: 100.0

# 重力补偿：按动作类型独立开关（不再使用全局 enable/scale）
gravity_comp:
  - mode: animation
    enable: true
  - mode: rigid
    enable: false
  - mode: hold
    enable: false
  - mode: idle
    enable: true
  - mode: planner
    enable: true   # 取消归位段开启重力补偿，避免大臂支撑力矩一拍掉到0导致顿挫

# tau = clip(kp·(q*-q) − kd·dq, ±clip_tau) + tau_g；clip_tau 仅约束 PD 项
# 只限制跟踪误差产生的纠偏力矩 (N·m)；重力前馈 tau_g 不受此限、始终全额叠加
# 关节摩擦力 用于补偿
gravity_friction:
  - name: "FL_HIP_ROLL_Joint"
    friction: 0.0001
  - name: "FL_HIP_PITCH_Joint"
    friction: 0.0001
  - name: "FL_KNEE_Joint"
    friction: 0.2
  - name: "FR_HIP_ROLL_Joint"
    friction: 0.0001
  - name: "FR_HIP_PITCH_Joint"
    friction: 0.0001
  - name: "FR_KNEE_Joint"
    friction: 0.2

# PD 跟踪力矩上限 (N·m)；重力项在限幅后叠加（与 Q1 一致）
clip_tau:
  FL_HIP_ROLL_Joint: 1.0
  FL_HIP_PITCH_Joint: 1.0
  FL_KNEE_Joint: 1.5
  FR_HIP_ROLL_Joint: 1.0
  FR_HIP_PITCH_Joint: 1.0
  FR_KNEE_Joint: 1.5
  default: 1.0

# 个别动作大臂 pitch 需更高刚度以举到位/复位到位
animation_overrides:
  - animation_id: 2017            # 骄傲：大臂 pitch 提刚度，消除顶点举不满 + 底端复位滞后
    joints:
      - name: "FL_HIP_PITCH_Joint"
        kp: 7.0
        kd: 1.0
        gravity_scale: 1.0
      - name: "FR_HIP_PITCH_Joint"
        kp: 7.0
        kd: 1.0
        gravity_scale: 1.0

# ani_table.animation_type: animation（柔性，默认）/ rigid（刚性）/ hold（播完保持末帧）
# ani_table:
#   - animation: 1001
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_right_waving_v2.csv"  # 右手挥手
#   - animation: 1002
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_right_handshake.csv"  # 右手握手
#   - animation: 1003
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_right_waving_for_1d5m_people.csv"  # 右手挥手，面对1.5m以上观众时
#   - animation: 1004
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_right_fist_bump.csv"  # 右手碰拳
#   - animation: 1005
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_right_cherring.csv"  # 右手加油欢呼
#   - animation: 1006
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_holding_camera_1.csv"  # 右手抬起(持摄像杆)
#   - animation: 1007
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_holding_camera_2.csv"  # 右手拍照抬起
#   - animation: 1011
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_left_waving_v2.csv"  # 左手挥手
#   - animation: 1012
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_left_handshake.csv"  # 左手握手
#   - animation: 1013
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_left_waving_for_1d5m_people.csv"  # 左手挥手，面对1.5m以上观众时
#   - animation: 1014
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_left_fist_bump.csv"  # 左手碰拳
#   - animation: 1015
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_left_cherring.csv"  # 左手加油欢呼
#   - animation: 1016
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Single_hand_left_holding_camera_1.csv"  # 左手抬起
#   - animation: 2001
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_making_heart_update_1.csv"  # 双手比心
#   - animation: 2002
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         path: "./classic/animation/Double_hand_happy.csv"  # 喜悦时双手挥动
#   - animation: 2003
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_talking.csv"  # 说话动作
#   - animation: 2004
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_talk1.csv"  # 说话动作1
#   - animation: 2005
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_talk2.csv"  # 说话动作2
#   - animation: 2006
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_talk3.csv"  # 说话动作3
#   - animation: 2007
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_talk4.csv"  # 说话动作4
#   - animation: 2008
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_talk5.csv"  # 说话动作5
#   - animation: 2009
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_talk6.csv"  # 说话动作6
#   - animation: 2011
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_Pose01_planner.csv"  # 拍照动作1
#   - animation: 2012
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_Pose02_planner.csv"  # 拍照动作2
#   - animation: 2013
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_Pose03_planner.csv"  # 拍照动作3
#   - animation: 2014
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_Pose04_planner.csv"  # 拍照动作4
#   - animation: 2015
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_raise_holding.csv"  # 双手抬起
#   - animation: 2016
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         # fps: 50
#         # path: "./classic/animation/Double_hand_cherring.csv"  # 双手加油欢呼
#         path: "./classic/animation/T1_bi_dance_one.csv"  # 双手加油欢呼 用刘开源设计的舞蹈动作1替换
#   - animation: 2017
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_proud_update.csv"  # 骄傲
#   - animation: 2020
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Double_hand_three_shot_1.csv"  # 三连拍
#   - animation: 2021
#     animation_type: animation
#     resources:
#       - area: 1
#         # fps: 60
#         fps: 100
#         # path: "./classic/animation/Double_hand_dance_update.csv"  # 跳舞动作
#         path: "./classic/animation/T1_bi_dance_one.csv"  # 跳舞动作
#   - animation: 2022
#     animation_type: animation
#     resources:
#       - area: 1
#         # fps: 150
#         fps: 100
#         # path: "./classic/animation/dance_part1.csv"  # 蛇形舞动1
#         path: "./classic/animation/T1_bi_dance_two.csv"  # 蛇形舞动1
#   - animation: 2023
#     animation_type: animation
#     resources:
#       - area: 1
#         # fps: 150
#         fps: 130
#         # path: "./classic/animation/dance_part2.csv"  # 蛇形舞动2
#         path: "./classic/animation/T1_bi_dance_two_three.csv"  # 使用刘开源设计的舞蹈动作2和3拼接 大概20s
#   - animation: 2024
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_talk_weak.csv"  # 小幅度说话动作
#   - animation: 2025
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_show_justarm.csv"  # 人形炫耀动作 只有上肢版本
#   - animation: 2026
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_hug.csv"  # 人形拥抱
#   - animation: 2027
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_show.csv"  # 人形炫耀 带腰部
#   - animation: 2028
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         # path: "./classic/animation/T1_bi_show_hugez.csv"  # 人形炫耀 腰部更明显
#         path: "./classic/animation/T1_bi_show_smallz.csv"  # 人形炫耀 腰部更明显
#   - animation: 2029
#     animation_type: animation
#     resources:
#       - area: 1
#         # fps: 100
#         fps: 110
#         # path: "./classic/animation/T1_bi_skating_pre.csv"  # 人形滑冰
#         # path: "./classic/animation/T1_bi_skating.csv"  # 人形滑冰
#         path: "./classic/animation/T1_bi_skating_30s.csv"  # 人形滑冰 30s 会下腰
#         # path: "./classic/animation/T1_bi_skating0525.csv"  # 人形滑冰
#         # path: "./classic/animation/T1_bi_skating_v2.csv"  # 人形滑冰
#         # path: "./classic/animation/T1_bi_skating_backup.csv"  # 人形滑冰
#         # path: "./classic/animation/T1_bi_skating_backup_neg.csv"  # 人形滑冰
#         # path: "./classic/animation/T1_bi_skating0525pass.csv"  # 人形滑冰
#   - animation: 2030
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_skating_backup_neg.csv"  # 人形滑冰
#   - animation: 2031
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_rhythm.csv"  # 人形律动
#   - animation: 2032
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_happy.csv"  # 人形喜悦
#   - animation: 2033
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_sad.csv"  # 人形难过
#   - animation: 2034
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_scared.csv"  # 人形害怕
#   - animation: 2035
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_ponder_one.csv"  # 人形思考1
#   - animation: 2036
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_ponder_two.csv"  # 人形思考2
#   - animation: 2037
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_ponder_three.csv"  # 人形思考3
#   - animation: 2038
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_ponder_four.csv"  # 人形思考4
#   - animation: 2039
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_spin_90.csv"  # 人形惯性转圈90度
#   - animation: 2040
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_spin_360.csv"  # 人形惯性转圈360度
#   - animation: 2041
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_heed.csv"  # 人形聆听
#   - animation: 2042
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/T1_bi_ice_breaking_dance.csv"  # 人形31s配合讲话的动作
#   - animation: 2043
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 150
#         # fps: 100
#         path: "./classic/animation/dance_part2.csv"  # 蛇形舞动2 重新修改后的导演剪辑版本
#   - animation: 2044
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 60
#         # fps: 100
#         path: "./classic/animation/Double_hand_dance_update.csv"  # 跳舞动作
#   - animation: 2045
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Single_hand_left_lift.csv"  # 左手高举起不放下
#   - animation: 2046
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/Single_hand_right_lift.csv"  # 右手高举起不放下
#   - animation: 3038
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3038.csv"  # 单臂击掌
#   - animation: 3040
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3040.csv"  # 双手欢呼
#   - animation: 3043
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3043.csv"  # 双手挥舞
#   - animation: 3045
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3045.csv"  # 双手挥舞2
#   - animation: 3046
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3046.csv"  # 双手挥舞3
#   - animation: 3047
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3047.csv"  # 左右手挥舞
#   - animation: 3048
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3048.csv"  # 双手欢呼1
#   - animation: 3052
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3052.csv"  # 打招呼
#   - animation: 3054
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3054.csv"  # 双手欢呼2
#   - animation: 3055
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3055.csv"  # 双手欢呼3
#   - animation: 3056
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3056.csv"  # 打招呼2
#   - animation: 3061
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 120
#         path: "./classic/animation/3061.csv"  # 全身跳舞2 by Leah 20260612
#   - animation: 3062
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3062.csv"  # 保持手臂动作1供点云采集 by Leah 20260616
#   - animation: 3064
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3064.csv"  # 保持手臂动作2供点云采集 by Leah 20260616
#   - animation: 3065
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3065.csv"  # 保持手臂动作3供点云采集 by Leah 20260616
#   - animation: 3069
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3069.csv"  # 双足摇篮舞
#   - animation: 3070
#     animation_type: animation
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/3070.csv"  # 双足球迷舞蹈
        
#   - animation: 5001
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/arm_holdpc2.csv"  # 放电脑用
#   - animation: 5002
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/photo.csv"  # 右手平举
#   - animation: 5003
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/photo2.csv"  # 左手平举
#   - animation: 5004
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/photo3.csv"  # 右手高举
#   - animation: 5005
#     animation_type: hold
#     resources:
#       - area: 1
#         fps: 100
#         path: "./classic/animation/photo4.csv"  # 左手高举


===== FILE: raw/t1/qd1_t2d0/classic/damping_default.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/classic/damping_default.yaml) =====

step_time: 0.002
phase_duration_time: 1.5
exit_timeout: 2.5
exit_position_threshold: 0.1
joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: 0.091
  - name: "FL_HIP_PITCH_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: 0.961
  - name: "FL_KNEE_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: -2.615
  - name: "FR_HIP_ROLL_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: -0.091
  - name: "FR_HIP_PITCH_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: 0.961
  - name: "FR_KNEE_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: -2.615
  - name: "RL_HIP_ROLL_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: 0.086
  - name: "RL_HIP_PITCH_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: 0.818
  - name: "RL_KNEE_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: -2.616
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 0.4
    position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: -0.086
  - name: "RR_HIP_PITCH_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: 0.818
  - name: "RR_KNEE_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 3.0
    kd_d: 1.5
    position: -2.616
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 0.4
    position: 0.0

===== FILE: raw/t1/qd1_t2d0/classic/custom_upper.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/classic/custom_upper.yaml) =====

CustomUpperConfig:
  upper_joints_name: [
    'FL_HIP_ROLL_Joint',
    'FL_HIP_PITCH_Joint',
    'FL_KNEE_Joint',
    'FR_HIP_ROLL_Joint',
    'FR_HIP_PITCH_Joint',
    'FR_KNEE_Joint',
  ]

  command_timeout_ms: 200


===== FILE: raw/t1/qd1_t2d0/classic/biped_stand_default.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/classic/biped_stand_default.yaml) =====

step_time: 0.001
duration_time: 3.0
hold_time: 1.0
joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 0.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 1.57
  - name: "FL_KNEE_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 0.52
  - name: "FR_HIP_ROLL_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 0.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 1.57
  - name: "FR_KNEE_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 0.52
  - name: "RL_HIP_ROLL_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 0.0
  - name: "RL_HIP_PITCH_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 1.92
  - name: "RL_KNEE_Joint"
    kp: 30.0
    kd: 0.8
    final_position: -0.66
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    final_position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 0.0
  - name: "RR_HIP_PITCH_Joint"
    kp: 30.0
    kd: 0.8
    final_position: 1.92
  - name: "RR_KNEE_Joint"
    kp: 30.0
    kd: 0.8
    final_position: -0.66
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    final_position: 0.0

===== FILE: raw/t1/qd1_t2d0/rl/bi_walk.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/bi_walk.yaml) =====

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
    # path: "./rl_models/t15_bi_walk_v1.2_0322.onnx"
    # path: "./rl_models/t1_bi_walk_v1.0_0307_t05.onnx"
    # path: "./rl_models/biped_lift0509_kd0.5.onnx"
    # path: "./rl_models/lift0511.onnx"
    # path: "./rl_models/lift0512.onnx"
    # path: "./rl_models/lift0513_no_ref.onnx"
    path: "./rl_models/lift0514_swing.onnx"
    
    

  # obs-action nums will be obtained by urdf
  obs_nums: 49
  # obs_nums: 49
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

  action_scale: [ 0.05, 0.1, 0.1,
                  0.05, 0.1, 0.1, 
                  0.05, 0.2, 0.2, 2.0, 
                  0.05, 0.2, 0.2, 2.0 ]
                  
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 20.0
    action_clip: 20.0

  action:
    activation: [   0.0, 0.0, 0.0, 
                    0.0, 0.0, 0.0, 
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
      50.0, 30.0, 30.0, 0.0, 
      50.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 0.5, 
      1.0, 1.0, 1.0, 0.5 ]

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

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    cmd_x_min: -0.8
    cmd_x_max: 1.0
    cmd_yaw_min: -1.5708
    cmd_yaw_max: 1.5708
    vx: 1.5
    dyaw: 1

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 50, 
      100, 100, 100, 50]

  odom:
    wheel_radius: 0.07
    odom_enable_x: 0.2
    odom_kp_x: 0.3
    odom_enable_yaw: 0.2
    odom_kp_yaw: 0.8
    max_vel_x: 0.3
    max_vel_yaw: 0.5

  stand_actions: [ 'BIPEDAL_STAND_DEFAULT']
  acc: 2.0

===== FILE: raw/t1/qd1_t2d0/rl/quad_walk.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/quad_walk.yaml) =====

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
    # path: "./rl_models/t2_quad_walk_new_0814.onnx" 
    path: "./rl_models/t2_quad_walk_0902.onnx"

  # obs-action nums will be obtained by urdf
  obs_nums: 57
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

  action_scale: [ 0.1, 0.25, 0.25, 
                  0.1, 0.25, 0.25, 
                  0.1, 0.25, 0.25, 0.0, 
                  0.1, 0.25, 0.25, 0.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 50.0
    action_clip: 50.0

  reduction:   
    wheel_reduction: 0.25
    hip_reduction: 0.5
  
  action:
    activation: [   1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 0.0, 
                    1.0, 1.0, 1.0, 0.0 ]
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
      0.5, 0.5, 0.5,
      0.5, 0.5, 0.5, 
      0.5, 0.5, 0.5, 1.0, 
      0.5, 0.5, 0.5, 1.0 ]
    default_dof_pos: [ 
      0.0, 0.6781, -1.3533, 
      0.0, 0.6781, -1.3533, 
      0.0, 1.0624, -1.8321, 0.0, 
      0.0, 1.0624, -1.8321, 0.0 ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  max_cycle_time: 0.8 # t_set
  min_cycle_time: 0.15
  step_length: 0.5
  

  # define obs index
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    command: 46
    cpg: 49

  walk:
    switch_stand_walk: false
    walk_mode: true
    stand_cmd_threshold: 0.05

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    cmd_x_min: -0.5
    cmd_x_max: 0.5
    # cmd_x_max: 0.5
    cmd_y_min: -0.3
    cmd_y_max: 0.3
    cmd_yaw_min: -0.78
    cmd_yaw_max: 0.78

    cpg_cmd_y: 2.0 # vel_all
    cpg_cmd_yaw: 1.0 # vel_all
    cmd_x_forward_bias_scale: 1.1   
    cmd_x_backward_bias_scale: 1.0  

  odom:
    enable: true
    min_forward_cmd: 0.2
    user_y_deadband: 0.05
    user_yaw_deadband: 0.05
    kp_yaw: 1.0
    kd_yaw: 0.1
    max_cmd_yaw: 0.4
    max_yaw_comp_rate: 5.0
    max_yaw_err: 0.5
    yaw_comp_decimation: 2
    log_decimation: 50

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]

  custom:
    wheel_stiffness_increase_time: 3.0
    transition_duration: 0.2  # 动作切换平滑时长(秒)
    joint_pos_clip: true

  stand_actions: [ 'QUADRUPED_STAND_DEFAULT']
  acc_x: 2.0
  acc_y: 2.0
  acc_yaw: 2.0
  acc_step_x: 2.0
  acc_step_y: 1.0
  acc_step_yaw: 1.0
  tau_limit: [15, 30, 30,
              15, 30, 30,
              30, 30, 30, 15,
              30, 30, 30, 15]


===== FILE: raw/t1/qd1_t2d0/rl/bi_wbc_dance.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/rl/bi_wbc_dance.yaml) =====

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
    path: "./rl_models/biped_rotation0711.onnx"
    
    

  # obs-action nums will be obtained by urdf
  obs_nums: 49
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
      50.0, 30.0, 30.0,
      50.0, 30.0, 30.0,
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

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    lin_vel: 2.0
    ang_vel: 0.25

  command_scales:
    cmd_x_min: -0.3
    cmd_x_max: 0.3
    cmd_yaw_min: -15.0
    cmd_yaw_max: 15.0
    height: 0.0


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
    odom_enable_x: 0.5
    odom_kp_x: 0.5
    odom_kd_x: 0.02
    max_vel_x: 0.3
    max_vel_yaw: 0.5
    odom_enable_yaw: 0.2
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
    odom_disable_after_switch_s: 1

  acc_x: 1.0        # x 方向减速/刹车加速度
  acc_x_accel: 1.0 # x 方向加速时加速度（原 acc_x * 0.25）
  v_z: 0.2
  acc_yaw: 7.0
  exit_wait_step: 20
  exit_wait_stop_step: 100
  bias_vx : -0
  bias_dyaw : 0.0

  # 总执行步数（100Hz 下 3000≈30s）；超过后自动切回 WBC。<=0 不按步数自动退出
  total_steps: 1300
  # 旋转时间窗（秒）与角速度
  # yaw_vel_random_range > 0 时每次启动随机采样：实际速度 ~ Uniform(yaw_vel, yaw_vel + yaw_vel_random_range)
  rotate:
    start_time: 2.0
    end_time: 8.0
    yaw_vel: 14.305
    yaw_vel_random_range: 0.0  # 随机区间：[13.0, 15.0] rad/s
  auto_next_actions: true
  default_next_action: "BIPED_LOCOMOTION_WBC"

  # CSV 手臂轨迹配置；path 为空时手臂保持默认位置
  arm_csv:
    path: "./res/biped_mimic_motion/Double_hand_cherring_6cycles_wait2s_no_point.csv" # no_point.csv为取消最后手臂指向的，没有no_point为保留最后手臂指向的
    loop: false
    time_scale: 1.0
    phase_offset: 0.0
    start_time: 0.0
