# 02_T1_POLICY_CONFIGS · T1 代表性 RL/经典策略配置（raw 有全量 48+13）

> 自动生成的阅读包：把多个原始文件按主题拼接，便于一次读多份。
> 引用行号/上下文时请回到 `raw/` 下的同名文件；`FILE:` 行给出原始路径。
> 文件数：29

> 注：本包是代表性节选；全量 48 份 RL + 13 份 classic 配置在 `raw/t1/config/rl/` 与 `raw/t1/config/classic/`。

---

## FILE: raw/t1/config/rl/quad_walk.yaml

- bytes: 4237

```yaml
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
```


---

## FILE: raw/t1/config/rl/quad_step.yaml

- bytes: 4418

```yaml
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
    path: "./rl_models/t2_quad_walk_lite_0713.onnx" 
    
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
  max_cycle_time: 0.9 # t_set
  min_cycle_time: 0.25
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
    map_y: 0.3
    map_yaw: 0.6
    cmd_x_min: -1.0
    cmd_x_max: 1.0

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]

  custom:
    wheel_stiffness_increase_time: 5.0
    transition_duration: 0.3   # 进入时起点姿态平滑时长(秒)

  step_gate:
    omega_thr:    0.3 
    # cmd_thr:      0.05
    # min_steps:    50
    front_diff_thr: 0.05   # 左前/右前足端 z 差值
    back_diff_thr:  0.05   # 左后/右后足端 z 差值
    pos_diff_thr:   0.05   # 足端 vs 默认足位的 xy 水平偏差阈值(不含 z, z 受坡度/地形适应影响)
    pos_diff_thr_quad_stand:   0.08   # 四足站立，特殊设置，避免开箱踏步
    min_stable_hold: 0.1
    settle_timeout:  5.0
    min_step_time:  0.9   # 最小踏步时间硬下限(秒); = 一个 TROT 周期(cmd=0 时 cpg_.t_=0.9), 防止踏步不足一个步态周期就退出

  # STEP 本身也加入 stand_actions：作为闸门时强制原地踏步、忽略速度指令
  stand_actions: [ 'QUADRUPED_STAND_DEFAULT', 'QUADRUPED_LOCOMOTION_STEP']
  acc_x: 0.5
  acc_y: 2.0
  acc_yaw: 2.0
  # 力矩限幅(N·m)
  tau_limit: [15, 30, 30,
              15, 30, 30,
              30, 30, 30, 15,
              30, 30, 30, 15]
```


---

## FILE: raw/t1/config/rl/quad_run.yaml

- bytes: 5060

```yaml
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
    # path: "./rl_models/t15_quad_run_v1.3_test.onnx"
    # path: "./rl_models/t15_quad_walk_run_v1.9_0418.onnx"
    path: "./rl_models/t2_quad_run_new_cpg.onnx"
    
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
                    1.0, 1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 1.0 ]
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
  max_cycle_time: 0.7 # t_set
  min_cycle_time: 0.25
  step_length: 0.6

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
    cmd_x_min: -1.0
    cmd_x_max: 2.7
    cmd_y_min: -0.4
    cmd_y_max: 0.4
    cmd_yaw_min: -0.78
    cmd_yaw_max: 0.78

    cpg_cmd_y: 2.0 # vel_all
    cpg_cmd_yaw: 1.5 # vel_all
    xlim_with_yaw: 1.0

  odom:
    enable: true
    min_forward_cmd: 0.2         # m/s，水平合速度 hypot(cmd_x,cmd_y) 超过此值才启用
    user_y_deadband: 0.05        # 已不参与门控(侧向运动不再关闭矫正), 保留以兼容 yaml/reflectcpp 结构
    user_yaw_deadband: 0.05      # rad/s，|转向指令|低于此值才介入; 过小易频繁启停，过大会干扰用户小转向
    kp_yaw: 1.0                  # 航向误差比例增益；调大纠偏更快但更易走弧线/蛇形
    kd_yaw: 0.1                  # yaw 角速度阻尼；调大可抑制过冲，但会放大 IMU/步态角速度噪声
    max_cmd_yaw: 0.25            # rad/s，自动 yaw 补偿上限(对齐 quad_loco/terrain)
    max_yaw_comp_rate: 5.0       # rad/s^2，补偿每秒最大变化(对齐 quad_loco/terrain)
    max_yaw_err: 0.5             # rad，参与计算的航向误差上限；主要用于异常保护
    low_speed_thresh: 0.0        # 已在 C++ 移除 v_scale 逻辑, 此字段仅保留兼容; 0=不生效
    low_speed_scale: 1.0         # 已失效, 保留兼容
    yaw_comp_decimation: 2       # 每 N 个控制周期更新目标: 2=50Hz
    log_decimation: 50           # 每 N 个控制周期打印日志：50约2Hz

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]

  custom:
    wheel_stiffness_increase_time: 5.0

  stand_actions: [ 'QUADRUPED_STAND_DEFAULT']
  acc_x: 1.2
  acc_y: 2.0
  acc_yaw: 2.0
  acc_step_x: 2.0
  acc_step_y: 1.0
  acc_step_yaw: 1.0
  dec_x: 4.0      
  dec_y: 2.0
  dec_yaw: 2.0
  exit_step: 150
```


---

## FILE: raw/t1/config/rl/quad_walk_terrain.yaml

- bytes: 5390

```yaml
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
    # path: "./rl_models/t2_quad_terrain_0911.onnx"
    path: "./rl_models/t2_quad_terrain_push_0926.onnx"
    
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
                  0.1, 0.25, 0.25, 1.0, 
                  0.1, 0.25, 0.25, 1.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 50.0
    action_clip: 50.0

  reduction:   
    wheel_reduction: 1.0
    hip_reduction: 0.5
  
  action:
    activation: [   1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 1.0 ]
  # planner:
  #   enable: false
  #   velocity: 10
  #   acceleration: 10
  #   dt: 1   # ms

  robot:
    # seq same as action_seq
    # real params
    kps: [ 
      30.0, 32.0, 30.0, 
      30.0, 32.0, 30.0, 
      30.0, 30.0, 30.0, 0.0, 
      30.0, 30.0, 30.0, 0.0 ]
    kds: [ 
      0.5, 0.5, 0.5,
      0.5, 0.5, 0.5, 
      0.5, 0.5, 0.5, 0.5, 
      0.5, 0.5, 0.5, 0.5 ]
    default_dof_pos: [ 
      0.0, 0.60, -1.3533, 
      0.0, 0.60, -1.3533, 
      0.0, 1.0624, -1.8321, 0.0, 
      0.0, 1.0624, -1.8321, 0.0 ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  max_cycle_time: 0.6 # t_set
  step_length: 0.55
  min_cycle_time: 0.15
  
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
    cmd_x_min: -1.0
    cmd_x_max: 1.0
    cmd_x_pnc_max: 1.2
    cmd_y_min: -0.4
    cmd_y_max: 0.4
    cmd_yaw_min: -0.78
    cmd_yaw_max: 0.78
    cpg_cmd_y: 2.2
    cpg_cmd_yaw: 1.0 # vel_all
    cmd_x_deadband: 0.1
    cmd_x_forward_bias_scale: 1.15
    cmd_x_backward_bias_scale: 1.0


  odom:
    enable: true
    min_forward_cmd: 0.2         # m/s，水平合速度 hypot(cmd_x,cmd_y) 超过此值才启用; 原仅门控 cmd_x
    user_y_deadband: 0.05        # 已不参与门控(侧向运动不再关闭矫正), 保留以兼容 yaml/reflectcpp 结构
    user_yaw_deadband: 0.05      # rad/s，|转向指令|低于此值才介入; 过小易频繁启停，过大会干扰用户小转向
    kp_yaw: 1.0                  # 航向误差比例增益；调大纠偏更快但更易走弧线/蛇形。当前低速侧移明显时优先调小（可从 0.1 起试）
    kd_yaw: 0.1                 # yaw 角速度阻尼；调大可抑制过冲，但会放大 IMU/步态角速度噪声。建议先设 0，再按 0.02~0.05 小幅增加
    max_cmd_yaw: 0.25            # rad/s，自动 yaw 补偿上限(对齐 quad_loco)
    max_yaw_comp_rate: 5.0       # rad/s^2，补偿每秒最大变化(对齐 quad_loco)
    max_yaw_err: 0.5             # rad，参与计算的航向误差上限；主要用于异常保护，不建议靠调大它增强日常纠偏
    low_speed_thresh: 0.0        # 已在 C++ 移除 v_scale 逻辑, 此字段仅保留兼容; 0=不生效
    low_speed_scale: 1.0         # 已失效, 保留兼容
    yaw_comp_decimation: 2       # 每 N 个控制周期更新目标(对齐 quad_loco): 2=50Hz
    log_decimation: 50           # 每 N 个控制周期打印日志：50约2Hz；调参可设10约10Hz，设1为100Hz但日志量大

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]

  custom:
    wheel_stiffness_increase_time: 3.0

  # 原地踏步地形保护
  stop_step:
    max_tilt: 0.15  # rad, 机身倾角超此值跳过踏步

  stand_actions: [ 'QUADRUPED_STAND_DEFAULT']
  acc: 1.5
  exit_step: 100
  tau_limit: [15, 30, 30,
              15, 30, 30,
              30, 30, 30, 15,
              30, 30, 30, 15]
```


---

## FILE: raw/t1/config/rl/quad_walk_twist.yaml

- bytes: 3469

```yaml
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
    path: "./rl_models/t2_quad_twist_0803.onnx"

  # obs-action nums will be obtained by urdf
  obs_nums: 50
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
  action_scale: [ 0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 0.0, 
                  0.25, 0.25, 0.25, 0.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 100.0
    action_clip: 100.0

  reduction:   
    wheel_reduction: 0.0
    hip_reduction: 1.0

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
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0 ]

    default_dof_pos: [ 
      0.0, 0.6781, -1.3533, 
      0.0, 0.6781, -1.3533, 
      0.0, 1.0624, -1.8321, 0.0, 
      0.0, 1.0624, -1.8321, 0.0 ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  max_cycle_time: 0.9

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
    roll: 1.5
    pitch: 1.5
    yaw: 1.5
    height: 1.5

  command_scales:
    rpy: 0.24
    height_min: -0.12
    height_max: 0.06
    acc_height: 0.3    

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 100,
      100, 100, 100, 100]

  stand_actions: [ 'QUADRUPED_STAND_DEFAULT']
  acc: 5.0
  # roll_scale: 1.5
  # pitch_scale: 1.5
  # yaw_scale: 1.5
  # height_scale: 1.5
  # rpy_scale: 0.24
  # height_a: -1.0
  # height_b: 1.0
  # height_c: -0.15
  # height_d: 0.06
```


---

## FILE: raw/t1/config/rl/quad_walk_dance.yaml

- bytes: 3608

```yaml
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
    path: "./rl_models/t2_quad_twist_xy_v1.0_0708.onnx"
    # path: "./rl_models/actor_critic_20251103.onnx"

  # obs-action nums will be obtained by urdf
  obs_nums: 52
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
  action_scale: [ 0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 0.0, 
                  0.25, 0.25, 0.25, 0.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 100.0
    action_clip: 100.0

  reduction:   
    wheel_reduction: 0.0
    hip_reduction: 1.0

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
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0 ]

    default_dof_pos: [ 
      0.0, 0.6781, -1.3533, 
      0.0, 0.6781, -1.3533, 
      0.0, 1.0624, -1.8321, 0.0, 
      0.0, 1.0624, -1.8321, 0.0  ]
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
    roll: 1.5
    pitch: 1.5
    yaw: 1.5
    height: 1.5
    x: 1.5
    y: 1.5
    repetition: 1.5

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]

  custom:
    wait_time: 0.5
    beat_duration: 0.67
    dpitch0: -0.25
    dpitch1: 0.25
    dyaw0: -0.25
    dyaw1: 0.25

  auto_next_actions: true
  default_next_action: QUADRUPED_LOCOMOTION_DEFAULT

  # 被外部打断时归位插值配置
  homing:
    duration: 1.0   # 插值时长（秒）
    dt_ms: 10       # 每拍间隔（ms），与控制频率 100Hz 对齐
```


---

## FILE: raw/t1/config/rl/quad_pushup.yaml

- bytes: 3420

```yaml
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
    path: "./rl_models/t2_quad_twist_xy_v1.0_0708.onnx"
    # path: "./rl_models/actor_critic_20251103.onnx"

  # obs-action nums will be obtained by urdf
  obs_nums: 52
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
  action_scale: [ 0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 0.0, 
                  0.25, 0.25, 0.25, 0.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 100.0
    action_clip: 100.0

  reduction:   
    wheel_reduction: 0.0
    hip_reduction: 1.0

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
      1.0, 1.0, 1.0,
      1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0, 
      1.0, 1.0, 1.0, 1.0 ]

    default_dof_pos: [ 
      0.0, 0.6781, -1.3533, 
      0.0, 0.6781, -1.3533, 
      0.0, 1.0624, -1.8321, 0.0, 
      0.0, 1.0624, -1.8321, 0.0 ]
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
    roll: 1.5
    pitch: 1.5
    yaw: 1.5
    height: 1.5
    x: 1.5
    y: 1.5
    repetition: 1.5

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 
      100, 100, 100, 
      100, 100, 100, 10, 
      100, 100, 100, 10]

  custom:
    wait_time: 0.5
    beat_duration: 1.0
    dpitch: 0.4
    dx: 0.3
    dheight: -0.2
    pushup_repetition_: 4
    pushup_T_set_: 3.0
    pushup_dx_: 0.05
    alpha: 0.927
```


---

## FILE: raw/t1/config/rl/quad_mimic.yaml

- bytes: 3472

```yaml
# t1::QuadMimicRLController：MotionManager + QuadMotionRLController；policy.path 为空时由 motion_list 下发模型与 CSV
BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  policy:
    type: "onnx"
    device: "cpu"
    path: "./rl_models/t2_quad_twist_xy_0725.onnx"

  obs_nums: 52
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
  action_scale: [ 0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 
                  0.25, 0.25, 0.25, 0.0, 
                  0.25, 0.25, 0.25, 0.0 ]
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 100.0
    action_clip: 100.0

  reduction:
    wheel_reduction: 0.0
    hip_reduction: 1.0

  action:
    activation: [   1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 
                    1.0, 1.0, 1.0, 0.0, 
                    1.0, 1.0, 1.0, 0.0 ]

  robot:
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
      0.0, 0.6781, -1.3533, 
      0.0, 0.6781, -1.3533, 
      0.0, 1.0624, -1.8321, 0.0, 
      0.0, 1.0624, -1.8321, 0.0  ]
    default_kp: 30
    default_kd: 1.0


WalkConfig:
  csv_path: './res/qd1_quad_test_100fps_10s.csv'
  max_cycle_time: 0.9

  mimic_csv_cols:
    time: 0
    body_x: 16
    body_y: 17
    body_z: 18
    roll: 19
    pitch: 20
    yaw: 21
  mimic_csv_names_cols:
    time: "timeCNT"
    body_x: "base_pos_body_x"
    body_y: "base_pos_body_y"
    body_z: "base_pos_body_z"
    roll: "base_roll"
    pitch: "base_pitch"
    yaw: "base_yaw"

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
    roll: 1.5
    pitch: 1.5
    yaw: 1.5
    height: 1.5
    x: 1.5
    y: 1.5

  command_scales:
    rpy: 0.24
    height_min: -0.12
    height_max: 0.06

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100,
      100, 100, 100,
      100, 100, 100, 100,
      100, 100, 100, 100]

  transition_window_duration: 0.8
  auto_next_actions: true
  default_next_action: QUADRUPED_LOCOMOTION_DEFAULT
  acc: 5.0
  acc_z_cmd: 0.5
```


---

## FILE: raw/t1/config/rl/quad_recovery.yaml

- bytes: 3708

```yaml
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
    # path: "./rl_models/rec1021_4900.onnx"
    # path: "./rl_models/t1_quad_recovery_v1.0_1021.onnx"
    # path: "./rl_models/t1_quad_recovery_v1.5_0405.onnx"
    #path: "./rl_models/t1_quad_recovery_v2.0_0725.onnx"
    path: "./rl_models/t1_quad_recovery_v2.0_0814.onnx"
  # obs-action nums will be obtained by urdf
  obs_nums: 47
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

  action_scale: [ 0.1, 0.2, 0.2,
                  0.1, 0.2, 0.2, 
                  0.1, 0.2, 0.2, 0.2,
                  0.1, 0.2, 0.2, 0.2]
                  
  imu_pitch_offset: 0.0


ACConfig:
  infer:
    frame_stack: 10

  clips:
    obs_clip: 20.0
    action_clip: 20.0

  reduction:   
    wheel_reduction: 0.0
    hip_reduction: 1.0

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
      1.0, 1.0, 1.0, 0.5, 
      1.0, 1.0, 1.0, 0.5 ]
    default_dof_pos: [
      0.0, 0.678,-1.353,
      0.0, 0.678,-1.353,
      0.0, 1.062,-1.832, 0.0,
      0.0, 1.062,-1.832, 0.0 ]
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
    phase: 46

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
  recovery_time: 10
  auto_switch_timeout: 8
  start_time: 0.0
  action_transition_time: 1.5
  auto_next_actions: true
  # after_recovery_action 为空时兜底; RECOVERY 出边仅 STEP, 故必经踏步: RECOVERY -> STEP -> 此目标
  default_next_action: QUADRUPED_LOCOMOTION_DEFAULT
  exit_pos_threshold: 0.5
  exit_stable_duration: 1.0
  stand_success_gz_thr: -0.8    # 站起判定阈值: 竖直时 g_body.z()≈-1, z<=此阈值视为已站起
  imu_stale_timeout_ms: 100.0   # IMU 数据停更超过此时长(ms)视为不可信

  custom:
    pre_step: 50
    joint_pos_clip: true
    joint_vel_clip: true
```


---

## FILE: raw/t1/config/rl/bi_walk.yaml

- bytes: 3658

```yaml
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
```


---

## FILE: raw/t1/config/rl/bi_wbc_run.yaml

- bytes: 7507

```yaml
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
```


---

## FILE: raw/t1/config/rl/bi_mimic.yaml

- bytes: 5323

```yaml
# t1::BiMimicRLController：MotionManager + animation_player WBC 参考；policy.path 为空时由 motion_list 下发
BaseConfig:
  model_type: "Walk"

  use_debug: true
  dt: 0.01  # 100Hz

  policy:
    type: "onnx"
    device: "cpu"
    path: "./rl_models/t1_bi_wbc_pitch0522.onnx"

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
  obs_index:
    imu_omega: 0
    imu_euler: 3
    pos: 6
    vel: 18
    action: 32
    command: 46
    z: 47
    yaw: 48
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

  odom:
    wheel_radius: 0.07
    odom_enable_x: 0.3
    odom_kp_x: 0.5
    odom_kd_x: 0.02
    max_vel_x: 0.3
    max_vel_yaw: 0.5
    odom_enable_yaw: 0.2
    odom_kp_yaw: 0.1
    max_delta_yaw: 20.0
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

  bias_vx: 0.0
  bias_h: 0.0
  bias_dyaw: 0.0
  default_z: 0.0

  auto_next_actions: true
  default_next_action: BIPED_LOCOMOTION_WBC

  # 前肢轨迹跟踪 PD（与 animation_player animation 段一致；低刚度需重力补偿）
  arm_default_kp: 4.0
  arm_default_kd: 0.2
  arm_joints:
    - name: "FL_HIP_ROLL_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 1.0
      friction: 0.0001
    - name: "FL_HIP_PITCH_Joint"
      kp: 2.0
      kd: 0.2
      gravity_scale: 1.0
      friction: 0.0001
    - name: "FL_KNEE_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 1.0
      friction: 0.2
    - name: "FR_HIP_ROLL_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 1.0
      friction: 0.0001
    - name: "FR_HIP_PITCH_Joint"
      kp: 2.0
      kd: 0.2
      gravity_scale: 1.0
      friction: 0.0001
    - name: "FR_KNEE_Joint"
      kp: 4.0
      kd: 0.2
      gravity_scale: 1.0
      friction: 0.2

  gravity_comp_enable: true
  gravity_comp_scale: 1.0

  # --- 打断退出（ExitCheck → ReadObservations 内非阻塞 StepExitHomingOnce）---
  # 手臂 smoothstep 回 default_dof_pos；Z/RPY 每拍写入 obs 供 RL 腿继续跑
  # T = clamp(T_min + (T_max-T_min)*|Δz|/z_abs_max, T_min, T_max)；N = ceil(T / (dt_ms/1000))
  # z_abs_max=0.203：animation 2029 (T1_bi_skating_30s) 相对 default_z 最大 |Δz|≈0.203m
  homing:
    duration: 0.4        # T_min 退场最短 (s)
    duration_max: 3.0    # T_max，|Δz| 达到 z_abs_max 时 (s)
    z_abs_max: 0.203     # 标定最大 |Δz| (m)
    dt_ms: 10            # 每拍间隔 (ms)，与 BaseConfig.dt=0.01 一致即 100Hz

  # tau = clip(kp·(q*-q) − kd·dq, ±clip_tau) + tau_g；clip_tau 仅约束 PD 项
  # 只限制跟踪误差产生的纠偏力矩 (N·m)；重力前馈 tau_g 不受此限、始终全额叠加
  clip_tau:
    FL_HIP_ROLL_Joint: 1.0
    FL_HIP_PITCH_Joint: 1.0
    FL_KNEE_Joint: 0.5
    FR_HIP_ROLL_Joint: 1.0
    FR_HIP_PITCH_Joint: 1.0
    FR_KNEE_Joint: 0.5
    default: 1.0
```


---

## FILE: raw/t1/config/rl/bi_npz_mimic.yaml

- bytes: 6067

```yaml
# t1::BiNpzMimicRLController：MotionManager 下发策略（onnx）+ 参考轨迹（npz）；policy.path 为空时由 motion_list 下发
# 腿部布局(command=31, obs=83, anchor_ori 6D)：与训练侧 mjlab robot_motion_command 对齐，供 BIPED_NPZ_MIMIC 使用。
BaseConfig:
  model_type: "Walk"
  use_debug: true
  dt: 0.02

  policy:
    type: "onnx"
    device: "cpu"
    path: ""

  # 单帧: num_obs = command(31) + motion_anchor_ori_b(6) + projected_gravity(3)
  #              + base_ang_vel(3) + joint_pos(12) + joint_vel(14) + actions(14) = 83
  # 注: command(31) = 腿部ref_qj(12) | 腿部ref_dqj(12) | anchor线速度(3) | anchor角速度(3) | anchor高度(1)
  #     motion_anchor_ori_b 为 6D 相对旋转(机器人anchor系->参考anchor系, 旋转矩阵前两列),
  #     与训练侧 matrix_from_quat(subtract_frame_transforms(...))[:, :2] 对齐。含绝对 yaw。
  obs_nums: 83
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

  action_scale: [
        0.15,  0.25,  0.25,
        0.15,  0.25,  0.25,
        0.15,  0.25,  0.25, 2.0,
        0.15,  0.25,  0.25, 2.0,
  ]

  imu_pitch_offset: 0.0

ACConfig:
  infer:
    frame_stack: 1

  clips:
    obs_clip: 100000000000.0
    action_clip: 100000000000.0

  robot:
    kps: [
          50.0, 30.0, 30.0,
          50.0, 30.0, 30.0,
          50.0, 30.0, 30.0, 0.0,
          50.0, 30.0, 30.0, 0.0
    ]
    kds: [
          1.2,  1.0,  1.0,
          1.2,  1.0,  1.0,
          1.2,  1.0,  1.0,  1.0,
          1.2,  1.0,  1.0,  1.0
    ]

    default_dof_pos: [
          0.0,1.57080,0.63023,
          0.0,1.57080,0.63023,
          0.0,1.91986,-0.65799,0.0,
          0.0,1.91986,-0.65799,0.0
    ]
    default_kp: 30.0
    default_kd: 1.0

WalkConfig:
  # NPZ mimic 两套 kp/kd
  kp_kd_sets:
    # set 0：默认kp/kd
    - kps: [
          30.0, 30.0, 30.0,
          30.0, 30.0, 30.0,
          50.0, 30.0, 30.0, 0.0,
          50.0, 30.0, 30.0, 0.0
      ]
      kds: [
          1.0,  1.0,  1.0,
          1.0,  1.0,  1.0,
          1.0,  1.0,  1.0,  0.5,
          1.0,  1.0,  1.0,  0.5
      ]
    # set 1：BIPED_NPZ_MIMIC_JOYOUS 1~3/BIPED_NPZ_MIMIC_FIGURE_SKATING 用如下kp/kd
    - kps: [
            50.0, 30.0, 30.0,
            50.0, 30.0, 30.0,
            50.0, 30.0, 30.0, 0.0,
            50.0, 30.0, 30.0, 0.0
      ]
      kds: [
            1.2,  1.0,  1.0,
            1.2,  1.0,  1.0,
            1.2,  1.0,  1.0,  1.0,
            1.2,  1.0,  1.0,  1.0
      ]

  # NPZ mimic 两套 action_scale（按 action_scale_set 下标选用）
  action_scale_sets:
    # set 0：默认 action_scale
    - [
        0.1,  0.1,  0.1,
        0.1,  0.1,  0.1,
        0.1,  0.2,  0.2, 2.0,
        0.1,  0.2,  0.2, 2.0,
      ]
    # set 1：之前模型 BIPED_NPZ_MIMIC_JOYOUS 1~3 / BIPED_NPZ_MIMIC_FIGURE_SKATING 用如下 action_scale
    - [
        0.15,  0.25,  0.25,
        0.15,  0.25,  0.25,
        0.15,  0.25,  0.25, 2.0,
        0.15,  0.25,  0.25, 2.0,
      ]

  # 每支 NPZ 舞蹈的运行参数（按 motion 名索引），取代 motion_list.yaml 中 custom 方式
  motion_params:
    BIPED_NPZ_MIMIC_JOYOUS:         { smooth_time: 0.5, kp_kd_set: 1, action_scale_set: 1 }
    BIPED_NPZ_MIMIC_JOYOUS2:        { smooth_time: 0.5, kp_kd_set: 0, action_scale_set: 0 }
    BIPED_NPZ_MIMIC_JOYOUS3:        { smooth_time: 0.5, kp_kd_set: 1, action_scale_set: 1 }
    BIPED_NPZ_MIMIC_FIGURE_SKATING: { smooth_time: 0.5, kp_kd_set: 0, action_scale_set: 0 }
    BIPED_NPZ_MIMIC_AABATTERY:      { smooth_time: 0.5, kp_kd_set: 0, action_scale_set: 0 }
    BIPED_NPZ_MIMIC_IWILLBETHERE:   { smooth_time: 0.5, kp_kd_set: 0, action_scale_set: 0 }
    BIPED_NPZ_APRIL_LIE:            { smooth_time: 0.5, kp_kd_set: 0, action_scale_set: 0 }

  # 6D 布局：motion_anchor_ori_b 占 6 维，其后各段较 80 布局整体 +3。
  obs_index:
    command: 0
    motion_anchor_ori_b: 31
    projected_gravity: 37
    base_ang_vel: 40
    joint_pos: 43
    joint_vel: 55
    actions: 69

  obs_scales:
    dof_pos: 1.0
    dof_vel: 1.0
    ang_vel: 1.0

  custom:
    use_motion_anchor_ori_b: true
    motion_anchor_body_name: "BASELINK"
    motion_anchor_idx: 0
    need_time_step: true

    action_clip: 16
    cmd_scale: [2.0, 2.0, 0.25]
    cmd_init: [0.0, 0.0, -0.0]

    obs_history_length: 5

    default_angles: [
          0.0, 1.57080, 0.63023,
          0.0, 1.57080, 0.63023,
          0.0, 1.91986, -0.65799, 0.0,
          0.0, 1.91986, -0.65799, 0.0
    ]

    default_velocities: [
      0.0, 0.0, 0.0,
      0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0
    ]

    pos_mask: [
          1, 1, 1,
          1, 1, 1,
          1, 1, 1, 0,
          1, 1, 1, 0
    ]

  auto_next_actions: true
  default_next_action: "BIPED_LOCOMOTION_WBC"

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 100,
      100, 100, 100, 100,
      100, 100, 100, 100,
      50, 50]
```


---

## FILE: raw/t1/config/rl/bi_lingchuang_mimic.yaml

- bytes: 3309

```yaml
# t1::BiLingchuangMimicRLController：MotionManager 下发策略（轨迹内嵌 onnx）；policy.path 为空时由 motion_list 下发
BaseConfig:
  model_type: "Walk"
  use_debug: true
  dt: 0.01

  policy:
    type: "onnx"
    device: "cpu"
    path: ""

  # Hist5: num_obs = command(28) + motion_anchor_ori_b(6) + (pg3+ang3+joint_pos12+limb_vel12+wheel_vel2+actions14)*5 = 264
  obs_nums: 264
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
      'FL_HIP_ROLL_Joint', 'FR_HIP_ROLL_Joint', 'RL_HIP_ROLL_Joint', 'RR_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint', 'FR_HIP_PITCH_Joint', 'RL_HIP_PITCH_Joint', 'RR_HIP_PITCH_Joint',
      'FL_KNEE_Joint', 'FR_KNEE_Joint', 'RL_KNEE_Joint', 'RR_KNEE_Joint',
      'RL_FOOT_Joint', 'RR_FOOT_Joint'
    ]

  action_seq:
    [
      'FL_HIP_ROLL_Joint', 'FR_HIP_ROLL_Joint', 'RL_HIP_ROLL_Joint', 'RR_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint', 'FR_HIP_PITCH_Joint', 'RL_HIP_PITCH_Joint', 'RR_HIP_PITCH_Joint',
      'FL_KNEE_Joint', 'FR_KNEE_Joint', 'RL_KNEE_Joint', 'RR_KNEE_Joint',
      'RL_FOOT_Joint', 'RR_FOOT_Joint'
    ]

  action_scale: [
        0.2,  0.2,  0.2,  0.2,
        0.2,  0.2,  0.2,  0.2,
        0.2,  0.2,  0.2,  0.2,
        2.5,  2.5
  ]

  imu_pitch_offset: 0.0

ACConfig:
  infer:
    frame_stack: 1

  clips:
    obs_clip: 100.0
    action_clip: 100.0

  robot:
    kps: [
          30.0, 30.0, 30.0, 30.0,
          30.0, 30.0, 30.0, 30.0,
          30.0, 30.0, 30.0, 30.0,
          0.0, 0.0
    ]

    kds: [
          1.008,  1.008,  1.008,  1.008,
          1.008,  1.008,  1.008,  1.008,
          1.008,  1.008,  1.008,  1.008,
          0.3,    0.3
    ]

    default_dof_pos: [
          0.0,     0.0,     0.0,      0.0,
          1.57080, 1.57080, 1.91986,  1.91986,
          0.63023, 0.63023, -0.65799, -0.65799,
          0.0,     0.0
    ]

    default_kp: 30.0
    default_kd: 1.0

WalkConfig:
  obs_index:
    ref_qj: 0
    ref_dqj: 14
    anchor_rot6d: 28
    obs_dim: 264

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    ang_vel: 0.25

  custom:
    use_motion_anchor_ori_b: true
    motion_anchor_body_name: "BASELINK"
    motion_anchor_idx: 0
    need_time_step: true

    action_clip: 16
    cmd_scale: [2.0, 2.0, 0.25]
    cmd_init: [0.0, 0.0, -0.0]

    obs_history_length: 5

    default_angles: [
          0.0,     0.0,     0.0,      0.0,
          1.57080, 1.57080, 1.91986,  1.91986,
          0.63023, 0.63023, -0.65799, -0.65799,
          0.0,     0.0
    ]

    default_velocities: [
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0
    ]

    pos_mask: [
          1, 1, 1, 1,
          1, 1, 1, 1,
          1, 1, 1, 1,
          0, 0
    ]

  auto_next_actions: true
  default_next_action: "BIPED_LOCOMOTION_WBC"

  filter:
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 100,
      100, 100, 100, 100,
      100, 100, 100, 100,
      50, 50]
```


---

## FILE: raw/t1/config/rl/bi_dance.yaml

- bytes: 4584

```yaml
BaseConfig:
  model_type: "Walk"

  use_debug: true
  # t1: simulation_dt * control_decimation = 0.005 * 4 -> 50Hz 策略
  # t1_qy: simulation_dt * control_decimation = 0.002 * 5 -> 100Hz 策略
  # dt: 0.02
  dt: 0.01

  policy:
    type: "onnx"
    device: "cpu"
    # path: "./rl_models/bi_dance_liuxingwu_model_3500.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_velocity_model_8250.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_model_9750.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_qy_model_15500.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_model_4500.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_model_18250.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_pd_model_17500.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_pd_model_19250.onnx"
    # path: "./rl_models/bi_dance_liuxingwu_pd_larger_acc_penalty_model_15750.onnx"
    path: "./rl_models/bi_dance_liuxingwu_acc_1_model_12750.onnx"

  #   14(ref_q)+14(ref_dq)+6(anchor rot6d)+3(gravity)+3(omega)+12(关节位置误差去双轮)+14(dq)+14(action)
  obs_nums: 80
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
      'FL_HIP_ROLL_Joint', 'FR_HIP_ROLL_Joint', 'RL_HIP_ROLL_Joint', 'RR_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint', 'FR_HIP_PITCH_Joint', 'RL_HIP_PITCH_Joint', 'RR_HIP_PITCH_Joint',
      'FL_KNEE_Joint', 'FR_KNEE_Joint', 'RL_KNEE_Joint', 'RR_KNEE_Joint',
      'RL_FOOT_Joint', 'RR_FOOT_Joint'
    ]

  action_seq:
    [
      'FL_HIP_ROLL_Joint', 'FR_HIP_ROLL_Joint', 'RL_HIP_ROLL_Joint', 'RR_HIP_ROLL_Joint',
      'FL_HIP_PITCH_Joint', 'FR_HIP_PITCH_Joint', 'RL_HIP_PITCH_Joint', 'RR_HIP_PITCH_Joint',
      'FL_KNEE_Joint', 'FR_KNEE_Joint', 'RL_KNEE_Joint', 'RR_KNEE_Joint',
      'RL_FOOT_Joint', 'RR_FOOT_Joint'
    ]

  action_scale: [
        0.2,  0.2,  0.2,  0.2,
        0.2,  0.2,  0.2,  0.2,
        0.2,  0.2,  0.2,  0.2,
        2.5,  2.5
  ]

  imu_pitch_offset: 0.0

ACConfig:
  # 单帧 80 维 obs
  infer:
    frame_stack: 1

  clips:
    obs_clip: 100.0
    action_clip: 100.0

  robot:
    kps: [
          30.0, 30.0, 30.0, 30.0,
          30.0, 30.0, 30.0, 30.0,
          30.0, 30.0, 30.0, 30.0,
          0.0,   0.0
    ]

    kds: [
          1.0,  1.0,  1.0,  1.0,
          1.0,  1.0,  1.0,  1.0,
          1.0,  1.0,  1.0,  1.0,
          0.1671, 0.1671
    ]
    default_dof_pos: [
          0.0,     0.0,     0.0,      0.0,
          1.57080, 1.57080, 1.91986,  1.91986,
          0.63023, 0.63023, -0.65799, -0.65799,
          0.0,     0.0
    ]

    default_kp: 30.0
    default_kd: 1.0

WalkConfig:
  obs_index:
    ref_qj: 0
    ref_dqj: 14
    anchor_rot6d: 28
    gravity: 34
    omega: 37
    qj_err_no_wheels: 40
    dqj: 52
    last_action: 66
    obs_dim: 80

  obs_scales:
    dof_pos: 1.0
    dof_vel: 0.05
    ang_vel: 0.25

  custom:
    # root_pos: [0.0, 0.0, 0.71]
    # root_quat: [0.70710678, 0.0, -0.70710678, 0.0]
    # init_from_first_inference: false
    # IMPORTANT: 默认必须为 true 才与 obs_nums=80 / 当前 ONNX 模型输入维度匹配（anchor_rot6d 会占 6 维）。
    use_motion_anchor_ori_b: true
    motion_anchor_body_name: "BASELINK"
    # motion_anchor_idx 在 Python 侧是运行时通过 body_names_for_eval.index(motion_anchor_body_name) 得到。
    # 该模型的常见情况 BASELINK 位于对齐列表第 0 个，因此这里固定写 0
    motion_anchor_idx: 0
    need_time_step: true

    action_clip: 16
    cmd_scale: [2.0, 2.0, 0.25]
    cmd_init: [0.0, 0.0, -0.0]
    num_actor_history: 6
    history_length: 6
    default_velocities: [
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0
    ]

    pos_mask: [
          1, 1, 1, 1,
          1, 1, 1, 1,
          1, 1, 1, 1,
          0, 0
    ]
  auto_next_actions: true
  next_actions: "BIPED_LOCOMOTION_WBC"

  filter:
    # ACRLController::PreRunOnce() 会按 q_nums(14) 逐项读取 q_vel_cutoff_freq[i] 初始化低通滤波器；
    imu_vel_cutoff_freq: 100
    q_vel_cutoff_freq: [
      100, 100, 100, 100,    # rolls   (FL, FR, RL, RR)
      100, 100, 100, 100,    # pitches (FL, FR, RL, RR)
      100, 100, 100, 100,    # knees   (FL, FR, RL, RR)
      50, 50]                # feet    (RL, RR)
```


---

## FILE: raw/t1/config/rl/bi_gimbal.yaml

- bytes: 5828

```yaml
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
```


---

## FILE: raw/t1/config/classic/quad_stand_default.yaml

- bytes: 1178

```yaml
step_time: 0.001
phase_duration_time: 2.0
exit_timeout: 2.0
exit_position_threshold: 0.2
transition_duration: 0.5
action_nums: 14

joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 0.6719
  - name: "FL_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -1.3579
  - name: "FR_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 0.6719
  - name: "FR_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -1.3579
  - name: "RL_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "RL_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.0624
  - name: "RL_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -1.8321
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 2.0
    position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "RR_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.0624
  - name: "RR_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -1.8321
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 2.0
    position: 0.0
```


---

## FILE: raw/t1/config/classic/ready_stand_default.yaml

- bytes: 1496

```yaml
step_time: 0.001
phase_duration_time: 1
exit_timeout: 1.2
exit_position_threshold: 0.2
joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
    # phase2_position: 0.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.1653
    # phase2_position: 0.69
  - name: "FL_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -2.330
    # phase2_position: -1.38
  - name: "FR_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
    # phase2_position: 0.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.1653
    # phase2_position: 0.69
  - name: "FR_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -2.330
    # phase2_position: -1.38
  - name: "RL_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
    # phase2_position: 0.0
  - name: "RL_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.8151
    # phase2_position: 1.16
  - name: "RL_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -2.5031
    # phase2_position: -1.85
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    position: 0.0
    # phase2_position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
    # phase2_position: 0.0
  - name: "RR_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.81514
    # phase2_position: 1.16
  - name: "RR_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -2.5031
    # phase2_position: -1.85
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    position: 0.0
```


---

## FILE: raw/t1/config/classic/damping_default.yaml

- bytes: 1506

```yaml
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
```


---

## FILE: raw/t1/config/classic/quad_get_down_default.yaml

- bytes: 1496

```yaml
step_time: 0.001
phase_duration_time: 2
exit_timeout: 3
exit_position_threshold: 0.2

joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
    position: 0.47
    # phase2_position: 0.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 100.0
    kd: 1.5
    position: 0.709
    # phase2_position: 0.69
  - name: "FL_KNEE_Joint"
    kp: 100.0
    kd: 1.5
    position: -2.623
    # phase2_position: -1.38
  - name: "FR_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
    position: -0.47
    # phase2_position: 0.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 100.0
    kd: 1.5
    position: 0.709
    # phase2_position: 0.69
  - name: "FR_KNEE_Joint"
    kp: 100.0
    kd: 1.5
    position: -2.623
    # phase2_position: -1.38
  - name: "RL_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
    position: 0.066
    # phase2_position: 0.0
  - name: "RL_HIP_PITCH_Joint"
    kp: 100.0
    kd: 1.5
    position: 0.531
    # phase2_position: 1.16
  - name: "RL_KNEE_Joint"
    kp: 100.0
    kd: 1.5
    position: -2.535
    # phase2_position: -1.85
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 2.0
    position: 0.0
    # phase2_position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
    position: -0.066
    # phase2_position: 0.0
  - name: "RR_HIP_PITCH_Joint"
    kp: 100.0
    kd: 1.5
    position: 0.531
    # phase2_position: 1.16
  - name: "RR_KNEE_Joint"
    kp: 100.0
    kd: 1.5
    position: -2.535
    # phase2_position: -1.85
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 2.0
    position: 0.0
```


---

## FILE: raw/t1/config/classic/quad_sit_down_default.yaml

- bytes: 1668

```yaml
step_time: 0.001
phase_duration_time: 2
exit_timeout: 3
exit_position_threshold: 0.2
kp_hold_ratio: 0.4            # 保持期 kp = kp * 0.4, 降低坐下后保持力矩 (1.0=与运动期相同)
kp_transition_duration: 0.5  # 高->低 kp smoothstep 缓变时长(秒)
joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 50.0
    kd: 1.0
    position: 0.0
    # phase2_position: 0.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 50.0
    kd: 1.0
    position: 1.0023
    # phase2_position: 0.69
  - name: "FL_KNEE_Joint"
    kp: 60.0
    kd: 1.0
    position: -1.3
    # phase2_position: -1.38
  - name: "FR_HIP_ROLL_Joint"
    kp: 50.0
    kd: 1.0
    position: 0.0
    # phase2_position: 0.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 50.0
    kd: 1.0
    position: 1.0023
    # phase2_position: 0.69
  - name: "FR_KNEE_Joint"
    kp: 60.0
    kd: 1.0
    position: -1.3
    # phase2_position: -1.38
  - name: "RL_HIP_ROLL_Joint"
    kp: 50.0
    kd: 1.0
    position: 0.086
    # phase2_position: 0.0
  - name: "RL_HIP_PITCH_Joint"
    kp: 100.0
    kd: 1.0
    position: 1.46325
    # phase2_position: 1.16
  - name: "RL_KNEE_Joint"
    kp: 100.0
    kd: 1.0
    position: -2.616
    # phase2_position: -1.85
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    position: 0.0
    # phase2_position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 50.0
    kd: 1.0
    position: -0.086
    # phase2_position: 0.0
  - name: "RR_HIP_PITCH_Joint"
    kp: 100.0
    kd: 1.0
    position: 1.46325
    # phase2_position: 1.16
  - name: "RR_KNEE_Joint"
    kp: 100.0
    kd: 1.0
    position: -2.616
    # phase2_position: -1.85
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    position: 0.0
```


---

## FILE: raw/t1/config/classic/quad_handshake_default.yaml

- bytes: 2062

```yaml
step_time: 0.001

# 1) 起身到站立（过渡 + 保持）
stand_transition_duration: 1.5
stand_hold_duration: 1.0
# 2) 站立到坐下（过渡 + 保持）
sit_transition_duration: 1.0
sit_hold_duration: 1.0
# 3) 抬手到握手位 + 握手保持
hand_raise_duration: 1.5
handshake_hold_duration: 2.0
# 4) 收手回坐姿（过渡 + 保持）
hand_recover_to_sit_duration: 1.5
recover_sit_hold_duration: 1.0
# 5) 回到站立
recover_to_stand_duration: 1.0

# false: 完成后切到 QUADRUPED_LOCOMOTION_DEFAULT
final_stand_infinite_hold: false

# 目标关节顺序：
# [FL_HIP_ROLL, FL_HIP_PITCH, FL_KNEE,
#  FR_HIP_ROLL, FR_HIP_PITCH, FR_KNEE,
#  RL_HIP_ROLL, RL_HIP_PITCH, RL_KNEE, RL_FOOT,
#  RR_HIP_ROLL, RR_HIP_PITCH, RR_KNEE, RR_FOOT]
target_stand: [0.0, 0.6781, -1.3533, 
               0.0, 0.6781, -1.3533, 
               0.0, 1.0624, -1.8321, 0.0, 
               0.0, 1.0624, -1.8321, 0.0]

target_sit: [0.04, 0.538, -0.855,
             0.04, 0.116, -0.3, 
             0.1, 1.2780, -2.35, 0.0, 
             0.0, 1.1079, -2.163, 0.0]

target_hand: [0.08, 0.5394, -0.75, 
              -0.106, -0.17, -1.57, 
              0.1, 1.2780, -2.35, 0.0, 
             0.0, 1.1079, -2.163, 0.0]

# 关节控制参数（位置控制）：kp 越大越“硬”，kd 越大阻尼越强
joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
  - name: "FL_HIP_PITCH_Joint"
    kp: 150.0
    kd: 1.5
  - name: "FL_KNEE_Joint"
    kp: 150.0
    kd: 1.5
  - name: "FR_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
  - name: "FR_HIP_PITCH_Joint"
    kp: 150.0
    kd: 1.5
  - name: "FR_KNEE_Joint"
    kp: 150.0
    kd: 1.5
  - name: "RL_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
  - name: "RL_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
  - name: "RL_KNEE_Joint"
    kp: 250.0
    kd: 1.5
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 1.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 100.0
    kd: 1.5
  - name: "RR_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
  - name: "RR_KNEE_Joint"
    kp: 250.0
    kd: 1.5
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 1.0
```


---

## FILE: raw/t1/config/classic/biped_stand_default.yaml

- bytes: 1152

```yaml
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
```


---

## FILE: raw/t1/config/classic/animation_player.yaml

- bytes: 23999

```yaml
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
```


---

## FILE: raw/t1/config/classic/custom_upper.yaml

- bytes: 217

```yaml
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
```


---

## FILE: raw/t1/config/classic/biped_record_upper.yaml

- bytes: 1041

```yaml
step_time: 10
duration_time_limit: 300
# START 时从 default_pos 线性插值到当前上肢姿态,过渡帧写入 CSV 但不计入录制时长
# tick = clamp(ceil(max_disp / padding_speed_rad), min_padding_tick, max_padding_tick)
padding_speed_rad: 0.015  # 每 tick 最大关节位移 (rad);0.015 * 100Hz = 1.5 rad/s ≈ 86 deg/s
padding_tick: 100          # padding_speed_rad <= 0 时的固定帧数
min_padding_tick: 30       # 自适应下限
max_padding_tick: 500      # 自适应上限
joints:
  -
    - UPPER_JOINT # upper-arm partition (cfg still carries upper/lower name lists)
    -
      upper_joint_num: 6
      lower_joint_num: 8
      upper: ["FL_HIP_ROLL_Joint", "FL_HIP_PITCH_Joint", "FL_KNEE_Joint", "FR_HIP_ROLL_Joint", "FR_HIP_PITCH_Joint", "FR_KNEE_Joint"]
      lower: ["RL_HIP_ROLL_Joint", "RL_HIP_PITCH_Joint", "RL_KNEE_Joint", "RL_FOOT_Joint", "RR_HIP_ROLL_Joint", "RR_HIP_PITCH_Joint", "RR_KNEE_Joint", "RR_FOOT_Joint"]
      upper_kp: [0.5, 0.0, 0.0, 0.5, 0.0, 0.0]
      upper_kd: [0.1, 0.0, 0.0, 0.1, 0.0, 0.0]
```


---

## FILE: raw/t1/config/classic/quad_lie_down.yaml

- bytes: 1532

```yaml
step_time: 0.002
phase_duration_time: 1.5
exit_timeout: 2.5
exit_position_threshold: 0.1
joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: 0.0475
  - name: "FL_HIP_PITCH_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: 0.709
  - name: "FL_KNEE_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: -2.623
  - name: "FR_HIP_ROLL_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: -0.0475
  - name: "FR_HIP_PITCH_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: 0.709
  - name: "FR_KNEE_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: -2.623
  - name: "RL_HIP_ROLL_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: 0.066
  - name: "RL_HIP_PITCH_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: 0.531
  - name: "RL_KNEE_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: -2.535
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 0.4
    kd_d: 0.4
    position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: -0.066
  - name: "RR_HIP_PITCH_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: 0.531
  - name: "RR_KNEE_Joint"
    kp: 100.0
    kp_d: 0.0
    kd: 1.0
    kd_d: 3.0
    position: -2.535
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kp_d: 0.0
    kd: 0.4
    kd_d: 0.4
    position: 0.0
```


---

## FILE: raw/t1/config/classic/quad_crouch.yaml

- bytes: 1114

```yaml
step_time: 0.001
phase_duration_time: 1.5
exit_timeout: 2.0
exit_position_threshold: 0.2
joints:
  - name: "FL_HIP_ROLL_Joint"
    kp: 50.0
    kd: 0.8
    position: 0.52
  - name: "FL_HIP_PITCH_Joint"
    kp: 50.0
    kd: 0.8
    position: 0.79
  - name: "FL_KNEE_Joint"
    kp: 50.0
    kd: 0.8
    position: -2.64
  - name: "FR_HIP_ROLL_Joint"
    kp: 50.0
    kd: 0.8
    position: -0.52
  - name: "FR_HIP_PITCH_Joint"
    kp: 50.0
    kd: 0.8
    position: 0.79
  - name: "FR_KNEE_Joint"
    kp: 50.0
    kd: 0.8
    position: -2.64
  - name: "RL_HIP_ROLL_Joint"
    kp: 50.0
    kd: 0.8
    position: 0.36
  - name: "RL_HIP_PITCH_Joint"
    kp: 50.0
    kd: 0.8
    position: 1.10
  - name: "RL_KNEE_Joint"
    kp: 50.0
    kd: 0.8
    position: -2.64
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 50.0
    kd: 0.8
    position: -0.36
  - name: "RR_HIP_PITCH_Joint"
    kp: 50.0
    kd: 0.8
    position: 1.10
  - name: "RR_KNEE_Joint"
    kp: 50.0
    kd: 0.8
    position: -2.64
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 0.4
    position: 0.0
```


---

## FILE: raw/t1/config/classic/quad_stand_reverse_default.yaml

- bytes: 1679

```yaml
# 前肢手臂反轴站立(QuadStandRe)
# 目标关节位姿: 前肢(FL/FR)手臂反轴撑起; 后肢(RL/RR)维持正常站立高度。
# 注意: 前肢手臂反轴的真实目标角度需按实机标定, 这里前肢(FL/FR)的 HIP_ROLL 标 TODO
#       暂沿用 quad_stand_default 的站立角度作占位, 由具身同学标定后替换。
step_time: 0.001
phase_duration_time: 2.0
exit_timeout: 2.0
exit_position_threshold: 0.2
transition_duration: 0.5
action_nums: 14

joints:
  - name: "FL_HIP_ROLL_Joint"      # TODO(arm-reverse): 前肢反轴角度, 实机标定后填入
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "FL_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: -0.6855
  - name: "FL_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.3786
  - name: "FR_HIP_ROLL_Joint"      # TODO(arm-reverse): 前肢反轴角度(与 FL 对称取负), 实机标定后填入
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "FR_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: -0.6855
  - name: "FR_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.3786
  - name: "RL_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "RL_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.1212
  - name: "RL_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -1.9050
  - name: "RL_FOOT_Joint"
    kp: 0.0
    kd: 2.0
    position: 0.0
  - name: "RR_HIP_ROLL_Joint"
    kp: 200.0
    kd: 1.5
    position: 0.0
  - name: "RR_HIP_PITCH_Joint"
    kp: 250.0
    kd: 1.5
    position: 1.1212
  - name: "RR_KNEE_Joint"
    kp: 250.0
    kd: 1.5
    position: -1.9050
  - name: "RR_FOOT_Joint"
    kp: 0.0
    kd: 2.0
    position: 0.0
```


---
