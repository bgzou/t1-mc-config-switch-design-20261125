# 01_T1_SYSTEM_CONFIGS · T1 系统/动作/图/安全/设备配置

> 自动生成的阅读包：把多个原始文件按主题拼接，便于一次读多份。
> 引用行号/上下文时请回到 `raw/` 下的同名文件；`FILE:` 行给出原始路径。
> 文件数：13

---

## FILE: raw/t1/config/mc_T1.yaml

- bytes: 7850

```yaml
aimrt:
  main_thread:
    name: mc_main
    # thread_sched_policy: SCHED_RR:80 # SCHED_OTHER | SCHED_FIFO:xx | SCHED_RR:xx
    # thread_bind_cpu: [0]

  log:
    core_lvl: Info
    default_module_lvl: Info
    backends:
      - type: console
        options:
          pattern: "[%c.%f][%l][%t][%G:%R] %v" # 日志格式    
      - type: rotate_file # 文件日志
        options:
          path: ${LOG_PATH} # 日志文件路径
          filename: mc.log # 日志文件名称
          max_file_size_m: 50 # 日志文件最大尺寸，单位m
          max_file_num: 6 # 最大日志文件数量，0代表无限
          pattern: "[%c.%f][%l][%t][%G:%R] %v" # 日志格式

  plugin:
    plugins:
      - name: iceoryx_plugin
        path: libaimrt_iceoryx_plugin.so
        options:
          shm_init_size: 4096

      - name: sm_plugin
        path: libaimrt_sm_plugin.so
      - name: ros2_plugin
        path: libaimrt_ros2_plugin.so
        options:
          node_name: mc_ros2_node
          executor_type: MultiThreaded
          executor_thread_num: 2
          executor_name: ros2_executor
          executor_bind_cpus: [3]

  executor:
    executors:
      - name: rt_joint_pub
        type: asio_thread
        options:
          thread_num: 1
          thread_sched_policy: SCHED_RR:80
          thread_bind_cpu: [3]
      - name: mc_sm_thread
        type: asio_thread
        options:
          thread_num: 1
          thread_sched_policy: SCHED_OTHER
          thread_bind_cpu: [3]

      - name: com_data_pub
        type: asio_thread
        options:
          thread_bind_cpu: [3]
      - name: event_trace_pub
        type: asio_thread
        options:
          thread_num: 1
      - name: hds_pub
        type: asio_thread
        options:
          thread_num: 1

      - name: main_executor
        type: asio_thread

      - name: common_server
        type: asio_thread
        options:
          thread_num: 2

      - name: MotionControlModule/hds_executor
        type: asio_thread
      - name: MotionControlModule/event_executor
        type: asio_thread

  channel:
    backends:
    - type: iceoryx
      options:
        listener_thread_name: "rt_iceoryx_sub"
        listener_thread_sched_policy: SCHED_RR:80
        listener_thread_bind_cpu: [ 3 ]

    - type: sm
      options:
        sub_default_executor: mc_sm_thread
        sub_topic_options:
          - topic_name: "(.*)"

    pub_topics_options:
      - topic_name: /aima/hal/joint/command
        enable_backends:
        - ${TOPIC_ENABLE_BACKEND}
      - topic_name: /aima/mc/action/info
        enable_backends: [ros2]
      - topic_name: /aima/mc/common/state
        enable_backends: [ros2]
      - topic_name: /robot/trace/events
        enable_backends: [ros2]
      - topic_name: /aima/hds/diagnostic_list
        enable_backends: [ros2]

    sub_topics_options:
      - topic_name: /aima/hal/joint/state
        enable_backends:
        - ${TOPIC_ENABLE_BACKEND}
      - topic_name: /aima/hal/imu/torso/state
        enable_backends:
        - ${TOPIC_ENABLE_BACKEND}
      - topic_name: /aima/mc/locomotion/velocity
        enable_backends: [ros2]
      - topic_name: /aima/mc/body_pose
        enable_backends: [ros2]
      - topic_name: /aima/mc/custom/joint/command
        enable_backends: [ros2]
      - topic_name: /aima/teleop_bridge/vr_data
        enable_backends: [ros2]

  rpc:
    backends:
      - type: ros2
    servers_options:
      - func_name: "(.*)"
        enable_backends: [ros2]
    clients_options:
      - func_name: "(.*)"
        enable_backends: [ros2]

MotionControlModule:
  env_path: ${PWD}
  config_path: ./cfg/robot
  resource_path: ../res
  robot_name: ${ROBOT_CFG}
  main_executor_name: main_executor

  PublisherManager:
    publisher_cfg_list:
      - name: joint_command
        topic: /aima/hal/joint/command
        enable: true
        frequency: 200
        executor: rt_joint_pub
      # - name: mc_action_info
      #   topic: /aima/mc/action/info
      #   enable: true
      #   frequency: 5
      #   executor: com_data_pub
      #   print_interval: 0
      # - name: rl_debug
      #   topic: /aima/mc/rl/debug
      #   enable: true
      #   frequency: 10
      #   executor: com_data_pub
      #   print_interval: 0
      # - name: mc_debug_f64
      #   topic: /aima/mc_debug_f64
      #   enable: true
      #   frequency: 100
      #   executor: com_data_pub
      #   print_interval: 0
      # - name: rl_debug
      #   topic: /aima/mc/rl/debug
      #   enable: true
      #   frequency: 10
      #   executor: com_data_pub
      #   print_interval: 0
      # - name: mc_debug_f64
      #   topic: /aima/mc_debug_f64
      #   enable: true
      #   frequency: 100
      #   executor: com_data_pub
      #   print_interval: 0
      # - name: hand_joint_command
      #   topic: /aima/hal/joint/hand/command
      #   enable: true
      #   frequency: 50
      #   executor: com_data_pub
        print_interval: 0

      - name: mc_common_state
        topic: /aima/mc/common/state
        enable: true
        frequency: 50
        executor: com_data_pub
      # - name: vr_state
      #   topic: /aima/teleop_bridge/vr_data
      #   enable: true
      #   wait_ready: false
      #   print_interval: 0
      # - name: body_desire
      #   topic: /aima/mc/body_pose
      #   enable: true
      #   wait_ready: false
        print_interval: 0

      - name: event_trace
        topic: /robot/trace/events
        enable: true
        frequency: 1
        executor: event_trace_pub
        print_interval: 0

      - name: hds
        topic: /aima/hds/diagnostic_list
        enable: true
        frequency: 1
        executor: hds_pub
        print_interval: 0

  SubscriberManager:
    subscriber_cfg_list:
      - name: joint_state
        topic: /aima/hal/joint/state
        executor: rt_joint_sub
        enable: true
        wait_ready: true
        print_interval: 0
        pub_inter_frame_interval_ns: 10000000  # 8 ms
        recv_inter_frame_interval_ns: 10000000  # 10 ms
        pub_to_recv_delay_ns: 10000000  # 10 ms, 0 means no check
      - name: imu_state
        topic: /aima/hal/imu/torso/state
        executor: rt_imu_sub
        enable: true
        wait_ready: true
        print_interval: 0
        pub_inter_frame_interval_ns: 10000000  # 8 ms
        recv_inter_frame_interval_ns: 10000000  # 10 ms
        pub_to_recv_delay_ns: 10000000  # 10 ms, 0 means no check
      - name: locomotion_velocity
        topic: /aima/mc/locomotion/velocity
        enable: true
        wait_ready: false
        print_interval: 0
      - name: custom_joint_command
        topic: /aima/mc/custom/joint/command
        enable: true
        wait_ready: false
        print_interval: 0

  ServiceManager:
    service_cfg_list:
      - names:
          - mc_get_action_service
          - mc_set_action_service
          - mc_set_preset_motion_service
          - mc_get_preset_motion_state_service
          - mc_set_robot_runtime_model_service
          - mc_get_robot_runtime_model_service
          - mc_set_input_source_service
          - mc_get_current_input_source_service
          - mc_set_motion_service
          - mc_get_motion_service
          - mc_motion_record_service
        enable: true
        executor: common_server
        debug_print: false

  InputManager:
    input_sources:
      - name: rc
        priority: 80 # 0-100
        timeout: 1000 # ms
      - name: vr
        priority: 70
        timeout: 1000
      - name: app_proxy
        priority: 90
        timeout: 1000
      - name: interaction
        priority: 80
        timeout: 1000
      - name: pnc
        priority: 80
        timeout: 1000
      - name: app_proxy_t_mode
        priority: 90
        timeout: 1000
      - name: insta360
        priority: 90
        timeout: 1000
```


---

## FILE: raw/t1/config/action_setting.yaml

- bytes: 13451

```yaml
resident_actions:
  security_guard:
    runners:
      - name: security_guard_t1
    period_ms: 50
    priority: 0
    cpu_affinity: []
    start_delay_ms: 0

transition_actions:
  PASSIVE_DEFAULT: # 零力矩急停
    - runners:
        - name: passive_default
      period_ms: 10
      priority: 80
      cpu_affinity: []

  DAMPING_DEFAULT: # 阻尼急停
    - runners:
        - name: damping_default_t1
          cfg_path: "./classic/damping_default.yaml"
      period_ms: 2
      priority: 80
      cpu_affinity: []
  
  QUAD_LIE_DOWN: # 四足趴下
    - runners:
        - name: quad_lie_down
          cfg_path: "./classic/quad_lie_down.yaml"
      period_ms: 2
      priority: 80
      cpu_affinity: []
  
  QUADRUPED_CROUCH_DEFAULT: # 四足蜷缩，方便开机状态下搬运
    - runners:
        - name: quad_crouch
          cfg_path: "./classic/quad_crouch.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []

  QUADRUPED_GET_DOWN_DEFAULT: # 四足趴下
    - runners:
        - name: quad_get_down
          cfg_path: "./classic/quad_get_down_default.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []
  
  STORE_DEFAULT: # 四足趴下
    - runners:
        - name: quad_get_down
          cfg_path: "./classic/quad_get_down_default.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []
  
  QUADRUPED_SIT_DOWN_DEFAULT: # 四足坐下
    - runners:
        - name: quad_sit_down
          cfg_path: "./classic/quad_sit_down_default.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []

  QUADRUPED_READY_STAND_DEFAULT:  # 四足准备站立姿势(半蹲)
    - runners:
      - name: ready_quad_stand
        cfg_path: "./classic/ready_stand_default.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []

  QUADRUPED_STAND_DEFAULT: # 四足位控站立
    - runners:
        - name: quad_stand
          cfg_path: "./classic/quad_stand_default.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []

  QUADRUPED_STAND_REVERSE_DEFAULT: # 四足前肢手臂反轴站立
    - runners:
        - name: quad_stand_reverse
          cfg_path: "./classic/quad_stand_reverse_default.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_DEFAULT: # 四足行走模式
    - runners:
        - name: rl_quad_loco
          cfg_path: "./rl/quad_walk.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_REVERSE_DEFAULT: # 四足反向行走模式
    - runners:
        - name: rl_quad_loco_reverse
          cfg_path: "./rl/quad_walk_reverse.yaml"
      period_ms: 10
      priority: 0
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_STEP: # 四足踏步模式
    - runners:
        - name: rl_quad_step
          cfg_path: "./rl/quad_step.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_RUN: # 四足奔跑模式
    - runners:
        - name: rl_quad_loco_run
          cfg_path: "./rl/quad_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_TERRAIN: # 四足越野模式
    - runners:
        - name: rl_quad_loco_terrain
          cfg_path: "./rl/quad_walk_terrain.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_JUMP: # 四足跳跃模式
    - runners:
        - name: rl_quad_jump
          cfg_path: "./rl/quad_jump_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_HANDSHAKE: # 四足握手模式
    - runners:
      - name: quad_handshake
        cfg_path: ./classic/quad_handshake_default.yaml
      period_ms: 1
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_FRONTFLIP:  # 四足前空翻
    - runners:
      - name: rl_quad_frontflip
        cfg_path: "./rl/quad_frontflip_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_BACKFLIP: # 四足后空翻
    - runners:
      - name: rl_quad_backflip
        cfg_path: "./rl/quad_backflip_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_RECOVERY: # 任意姿态恢复四足
    - runners:
        - name: rl_quad_recovery
          cfg_path: "./rl/quad_recovery.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_STRETCH: # 四足伸展模式
    - runners:
        - name: rl_quad_stretch
          cfg_path: "./rl/quad_walk_stretch.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_BODY_ADJUST_DEFAULT: # 四足姿态调整
    - runners:
        - name: rl_quad_body_adjust
          cfg_path: "./rl/quad_body_adjust.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []      
  
  QUADRUPED_LOCOMOTION_DANCE: # 四足舞蹈模式
    - runners:
        - name: rl_quad_dance
          cfg_path: "./rl/quad_walk_dance.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
  
  QUADRUPED_PUSH_UP:
    - runners:
        - name: rl_quad_pushup
          cfg_path: "./rl/quad_pushup.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_RECOVERY: # 任意姿态恢复双足
    - runners:
      - name: rl_bi_recovery
        cfg_path: "./rl/bi_recovery.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_STAND_DEFAULT: # 双足位控站立
    - runners:
        - name: biped_stand
          cfg_path: "./classic/biped_stand_default.yaml"
      period_ms: 1
      priority: 80
      cpu_affinity: []

  BIPED_LOCOMOTION_DEFAULT:  # 双足行走模式
    - runners:
        - name: rl_bi_loco
          cfg_path: "./rl/bi_walk.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_LOCOMOTION_RUN:  # 双足奔跑模式
    - runners:
        - name: rl_bi_loco_run
          cfg_path: "./rl/bi_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_LOCOMOTION_TERRAIN:  # 双足越野模式
    - runners:
        - name: rl_bi_terrain
          cfg_path: "./rl/bi_walk_terrain.yaml"
        # - name: rl_bi_loco_wbc
        #   cfg_path: "./rl/bi_wbc_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
  
  BIPED_LOCOMOTION_WBC: # 双足全身控制模式
    - runners:
      - name: rl_bi_loco_wbc
        cfg_path: "./rl/bi_wbc_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
    # 非动画模式下不使用动画播放器
    - runners:
      - name: animation_player
        cfg_path: "./classic/animation_player.yaml"
      period_ms: 4
      priority: 80
      cpu_affinity: []

  # 之前给演示时使用，当前没用，先保留着
  BIPED_LOCOMOTION_ANIMATION: # 双足动画模式
    - runners:
      - name: rl_bi_loco_animation
        cfg_path: "./rl/bi_loco_animation.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
    - runners:
      - name: animation_player
        cfg_path: "./classic/animation_player.yaml"
      period_ms: 2
      priority: 80
      cpu_affinity: []

  BIPED_LOCOMOTION_WBCDANCE: # 双足 WBC+上肢舞蹈（仅从 WBC 切入/切出；可配置旋转与总步数自动退出）
    - runners:
      - name: rl_bi_loco_wbcdance
        cfg_path: "./rl/bi_wbc_dance.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
    # - runners:
    #   - name: animation_player
    #     cfg_path: "./classic/animation_player.yaml"
    #   period_ms: 2
    #   priority: 80
    #   cpu_affinity: []

  # SetMcMotion(type=MIMIC_QY) → SetNewAction("BIPED_MIMIC")；motion_list 选具体动作名
  BIPED_MIMIC: # 双足模仿（上肢+下肢由 rl_bi_mimic 统一控制）
    - runners:
      - name: rl_bi_mimic
        cfg_path: "./rl/bi_mimic.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  # SetMcMotion(type=BIPED_LINGCHUANG_MIMIC) → SetNewAction("BIPED_LINGCHUANG_MIMIC")；motion_list 选具体动作名
  BIPED_LINGCHUANG_MIMIC: # 双足灵创模仿（轨迹内嵌 onnx，由 rl_bi_lingchuang_mimic 统一控制）
    - runners:
      - name: rl_bi_lingchuang_mimic
        cfg_path: "./rl/bi_lingchuang_mimic.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  # SetMcAction("BIPED_GIMBAL") / SetMcMotion(type=BIPED_GIMBAL)；单 runner 下肢 RL + 上肢 gimbal
  BIPED_GIMBAL:
    - runners:
      - name: rl_bi_gimbal
        cfg_path: "./rl/bi_gimbal.yaml"
      period_ms: 10

  # SetMcMotion(type=BIPED_NPZ_MIMIC) → SetNewAction("BIPED_NPZ_MIMIC")；
  # 复用 rl_bi_npz_mimic 控制器，但使用 83-obs / motion_anchor_ori_b 6D 布局的 runner cfg
  BIPED_NPZ_MIMIC: # 双足 npz 模仿（腿部布局 command=31，obs=83，anchor_ori 6D）
    - runners:
      - name: rl_bi_npz_mimic
        cfg_path: "./rl/bi_npz_mimic.yaml"
      period_ms: 20
      priority: 80
      cpu_affinity: []

  QUADRUPED_TO_BIPED: # 四足变双足
    - runners:
      - name: rl_quad_to_bi
        cfg_path: "./rl/quad_to_bi_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_TO_BIPED_ROTATE: # 四足变双足旋转
    - runners:
      - name: rl_quad_to_bi_rotate
        cfg_path: "./rl/quad_to_bi_rotate_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_TO_BIPED_FRONTFLIP: # 四足空翻变人形
    - runners:
      - name: rl_quad_to_bi_frontflip
        cfg_path: "./rl/quad_to_bi_frontflip_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
  
  QUADRUPED_LOCOMOTION_BIONIC: # 四足仿生
    - runners:
      - name: rl_quad_twist
        cfg_path: "./rl/quad_walk_twist.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_PRIDE: # 四足仿生-傲娇
    - runners:
      - name: rl_quad_pride
        cfg_path: "./rl/quad_walk_pride.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  # SetMcMotion(type=MIMIC_QY) → SetNewAction("QUADRUPED_MIMIC")；motion_list 选具体动作名（如 QUAD_MIMIC）
  QUADRUPED_MIMIC:
    - runners:
      - name: rl_quad_mimic
        cfg_path: "./rl/quad_mimic.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  QUADRUPED_LOCOMOTION_PLEASURE: # 四足仿生-愉快
    - runners:
      - name: rl_quad_pleasure
        cfg_path: "./rl/quad_walk_pleasure.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_TO_QUADRUPED: # 双足变四足
    - runners:
      - name: rl_bi_to_quad
        cfg_path: "./rl/bi_to_quad_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_YUZURU: # 羽生结弦动作
    - runners:
      - name: rl_bi_yuzuru
        cfg_path: "./rl/bi_yuzuru.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_SPLIT: # 双足劈叉
    - runners:
      - name: rl_bi_split
        cfg_path: "./rl/bi_split.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
  
  BIPED_TO_QUADRUPED_FRONTFLIP: # 双足变四足-前空翻
    - runners:
      - name: rl_bi_to_quad_frontflip
        cfg_path: "./rl/bi_to_quad_frontflip_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
  
  BIPED_TO_QUADRUPED_ROTATE: # 双足变四足-旋转
    - runners:
      - name: rl_bi_to_quad_rotate
        cfg_path: "./rl/bi_to_quad_rotate_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
      
  BIPED_LOCOMOTION_ROTATE_LOCAL: # 双足旋转
    - runners:
      - name: rl_bi_rotate_local
        cfg_path: "./rl/bi_rotate_local.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_LOCOMOTION_BACKBEND: # 双足后弯
    - runners:
      - name: rl_bi_backbend
        cfg_path: "./rl/bi_backbend_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_LOCOMOTION_MOONWALK: # 双足太空漫步
    - runners:
      - name: rl_bi_moonwalk
        cfg_path: "./rl/bi_moonwalk.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_LOCOMOTION_DANCE: # 双足舞蹈
    - runners:
      - name: rl_bi_dance
        cfg_path: "./rl/bi_dance.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_RECORD_UPPER: # 双足位控站立动作录制模式开始
    - runners:
      - name: rl_bi_loco_wbc
        cfg_path: "./rl/bi_wbc_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
    - runners:
      - name: biped_record
        cfg_path: "./classic/biped_record_upper.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  BIPED_CUSTOM_UPPER: # 双足位控站立二开上肢控制
    - runners:
      - name: rl_bi_loco_wbc
        cfg_path: "./rl/bi_wbc_run.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []
    - runners:
      - name: custom_upper
        cfg_path: "./classic/custom_upper.yaml"
      period_ms: 10
      priority: 80
      cpu_affinity: []

  ###################################### test action ##################################################
  TEST_PLATFORM:
    - runners:
        - name: passive_default
      period_ms: 10
      priority: 80
      cpu_affinity: []

  TRAJECTORY_GENERATOR:
    - runners:
        - name: passive_default
      period_ms: 10
      priority: 80
      cpu_affinity: []

  TEST_FOURIER:
    - runners:
        - name: passive_default
      period_ms: 10
      priority: 80
      cpu_affinity: []
```


---

## FILE: raw/t1/config/action_state.yaml

- bytes: 5470

```yaml
state_actions:
  "STARTING":
    - name: JOINT_DEFAULT
      auto_transition: false
    - name: CROUCH_DOWN_DEFAULT
      auto_transition: false
    - name: SIT_UP_DEFAULT
      auto_transition: false
    - name: SIT_DOWN_DEFAULT
      auto_transition: false

  "STABLE":
    - name: STAND_DEFAULT
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_DEFAULT  # Note(chuan): 放这里的理由是action测试下来比较稳定
      auto_transition: false  
    - name: QUADRUPED_LOCOMOTION_STEP
      auto_transition: false  
    - name: BIPED_LOCOMOTION_WBC
      auto_transition: false
    - name: BIPED_LOCOMOTION_ANIMATION
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_STRETCH
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_DANCE
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_RUN
      auto_transition: false
    - name: BIPED_LOCOMOTION_TERRAIN
      auto_transition: false
    - name: BIPED_LOCOMOTION_RUN
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_TERRAIN
      auto_transition: false
    - name: BIPED_LOCOMOTION_DEFAULT
      auto_transition: false
    - name: QUADRUPED_PUSH_UP
      auto_transition: false
    - name: BIPED_RECORD_UPPER
      auto_transition: false
    - name: BIPED_CUSTOM_UPPER
      auto_transition: false

  "MOVING":
    - name: LOCOMOTION_DEFAULT
      auto_transition: false
    - name: LOCOMOTION_STEP
      auto_transition: false
    - name: SQUAT_DEFAULT
      auto_transition: false
    - name: QUADRUPED_READY_STAND_DEFAULT
      auto_transition: false
    - name: QUADRUPED_TO_BIPED
      auto_transition: false
    - name: QUADRUPED_TO_BIPED_ROTATE
      auto_transition: false
    - name: QUADRUPED_TO_BIPED_FRONTFLIP
      auto_transition: false
    - name: BIPED_TO_QUADRUPED
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_JUMP
      auto_transition: false
    - name: BIPED_TO_QUADRUPED_FRONTFLIP
      auto_transition: false
    - name: BIPED_TO_QUADRUPED_ROTATE
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_FRONTFLIP
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_BACKFLIP
      auto_transition: false
    - name: BIPED_LOCOMOTION_ROTATE_LOCAL
      auto_transition: false
    - name: BIPED_LOCOMOTION_BACKBEND
      auto_transition: false
    - name: BIPED_YUZURU 
      auto_transition: false
    - name: BIPED_SPLIT 
      auto_transition: false
    - name: BIPED_LOCOMOTION_MOONWALK
      auto_transition: false
    - name: BIPED_LOCOMOTION_DANCE
      auto_transition: false
    - name: BIPED_LOCOMOTION_WBCDANCE
      auto_transition: false
    - name: BIPED_RECOVERY
      auto_transition: false
    - name: BIPED_MIMIC
      auto_transition: false
    - name: BIPED_LINGCHUANG_MIMIC
      auto_transition: false
    - name: BIPED_GIMBAL
      auto_transition: false
    - name: BIPED_NPZ_MIMIC
      auto_transition: false

  "SAFE":
    - name: PASSIVE_DEFAULT
      auto_transition: false
    - name: DAMPING_DEFAULT
      auto_transition: false
    - name: QUADRUPED_RECOVERY
      auto_transition: false
    - name: QUADRUPED_STAND_DEFAULT
      auto_transition: false
    - name: QUADRUPED_STAND_REVERSE_DEFAULT  # 四足前肢手臂反轴站立
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_REVERSE_DEFAULT 
      auto_transition: false
    - name: QUADRUPED_BODY_ADJUST_DEFAULT  # 四足姿态调整
      auto_transition: false            
    # - name: BIPED_RECOVERY
    #   auto_transition: false
    - name: BIPED_STAND_DEFAULT
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_BIONIC
      auto_transition: false
    - name: QUADRUPED_GET_DOWN_DEFAULT
      auto_transition: false
    - name: STORE_DEFAULT
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_PRIDE
      auto_transition: false
    - name: QUADRUPED_MIMIC
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_PLEASURE
      auto_transition: false
    - name: QUADRUPED_SIT_DOWN_DEFAULT
      auto_transition: false
    - name: QUADRUPED_LOCOMOTION_HANDSHAKE
      auto_transition: false
    - name: QUAD_LIE_DOWN
      auto_transition: false
    - name: QUADRUPED_CROUCH_DEFAULT
      auto_transition: false


  "SPECIAL":
    - name: MANIPULATE_DEFAULT
      auto_transition: false
    - name: VR_REMOTE_CONTROLLER
      auto_transition: false
    - name: GROUNDUP
      auto_transition: false

  "TEST":
    - name: TEST_PLATFORM
      auto_transition: false
    - name: TRAJECTORY_GENERATOR
      auto_transition: false
    - name: TEST_FOURIER
      auto_transition: false

default_action:
  stable: STAND_DEFAULT
  moving: LOCOMOTION_DEFAULT

start_states:
  sit: SIT_UP_DEFAULT
  lie_down: CROUCH_DOWN_DEFAULT

estimator:
  check_fall: true
  check_soar: true
  secure_action: DAMPING_DEFAULT

elapse_time: 2000  # ms

# 切换 action 前 IMU 姿态校验，仅检查 roll/pitch（rad），不检查 yaw（机体朝向）
action_imu_check:
  QUADRUPED_LOCOMOTION_BIONIC:
    default_roll: 0.0
    default_pitch: 0.0
    roll_tolerance: 0.12    # ~7 deg
    pitch_tolerance: 0.12   # ~7 deg

# 特定action
recovery_behaviors:
  recovery_action: QUADRUPED_RECOVERY
  actions: 
    - QUADRUPED_READY_STAND_DEFAULT
    - QUADRUPED_SIT_DOWN_DEFAULT
    - QUADRUPED_GET_DOWN_DEFAULT
    - STORE_DEFAULT
    - QUADRUPED_CROUCH_DEFAULT
    - QUADRUPED_STAND_DEFAULT
    - QUADRUPED_LOCOMOTION_DEFAULT
    - QUADRUPED_LOCOMOTION_TERRAIN
    - QUADRUPED_LOCOMOTION_RUN
```


---

## FILE: raw/t1/config/action_ruler.yaml

- bytes: 13010

```yaml
common_rules:
  # 允许所有action切换到指定的action
  allow_all_switch_to:
    - PASSIVE_DEFAULT
    - DAMPING_DEFAULT
    - QUAD_LIE_DOWN
  allow_switch_to_all: []

  # 设置需要跳过的action
  skip_actions:
    - PASSIVE_DEFAULT
    - BIPED_LOCOMOTION_WBC
    - BIPED_LOCOMOTION_ANIMATION
    # - BIPED_LOCOMOTION_WBCDANCE
    - BIPED_MIMIC
    - BIPED_LINGCHUANG_MIMIC
    - BIPED_GIMBAL
    - BIPED_NPZ_MIMIC
    - BIPED_STAND_DEFAULT
    - QUADRUPED_RECOVERY
    # - QUADRUPED_TO_BIPED_FRONTFLIP
    # - BIPED_TO_QUADRUPED_FRONTFLIP
    - QUADRUPED_LOCOMOTION_FRONTFLIP
    - QUADRUPED_LOCOMOTION_BACKFLIP
    - QUADRUPED_GET_DOWN_DEFAULT
    - STORE_DEFAULT
    - QUADRUPED_SIT_DOWN_DEFAULT
    - BIPED_TO_QUADRUPED
    - QUADRUPED_TO_BIPED
    - BIPED_RECOVERY
    - QUADRUPED_LOCOMOTION_DEFAULT
    - QUADRUPED_LOCOMOTION_TERRAIN
    - QUADRUPED_LOCOMOTION_RUN
    - QUADRUPED_LOCOMOTION_HANDSHAKE
    - QUADRUPED_LOCOMOTION_JUMP
    - QUADRUPED_STAND_REVERSE_DEFAULT
    - QUADRUPED_LOCOMOTION_REVERSE_DEFAULT
    
action_rules:
  PASSIVE_DEFAULT:
    next_actions:
      - QUADRUPED_READY_STAND_DEFAULT  # mid action
      - QUADRUPED_SIT_DOWN_DEFAULT
      - QUADRUPED_GET_DOWN_DEFAULT
      - STORE_DEFAULT
      - QUADRUPED_RECOVERY
      - QUADRUPED_CROUCH_DEFAULT
      - BIPED_STAND_DEFAULT
      - BIPED_RECOVERY
  
  QUADRUPED_READY_STAND_DEFAULT:    # 四足准备站立
    next_actions:
      - QUADRUPED_STAND_DEFAULT

  QUADRUPED_STAND_REVERSE_DEFAULT:  # 四足前肢手臂反轴站立
    next_actions:
      - QUADRUPED_STAND_DEFAULT       # 回正常站立
      - QUADRUPED_LOCOMOTION_REVERSE_DEFAULT    # 四足反向行走模式

  QUADRUPED_LOCOMOTION_REVERSE_DEFAULT: # 四足反向行走模式
    next_actions:
      - QUADRUPED_STAND_DEFAULT
      - QUADRUPED_STAND_REVERSE_DEFAULT

  QUADRUPED_BODY_ADJUST_DEFAULT:   # 四肢身体调整
    next_actions:
      - QUADRUPED_STAND_DEFAULT
      - QUADRUPED_LOCOMOTION_DEFAULT  # 四足行走
      - QUADRUPED_LOCOMOTION_TERRAIN  # 四足越野
      - QUADRUPED_LOCOMOTION_RUN      # 四足奔跑

  QUADRUPED_CROUCH_DEFAULT: 
    next_actions:
      - PASSIVE_DEFAULT
      - QUADRUPED_READY_STAND_DEFAULT

  DAMPING_DEFAULT:
    next_actions:
      - PASSIVE_DEFAULT
  
  QUAD_LIE_DOWN:
    next_actions:
      - PASSIVE_DEFAULT

  QUADRUPED_STAND_DEFAULT:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT # 四足行走
      - QUADRUPED_LOCOMOTION_TERRAIN # 四足越野
      - QUADRUPED_LOCOMOTION_RUN     # 四足奔跑
      - STORE_DEFAULT                # 四足存储
      # - QUADRUPED_LOCOMOTION_PLEASURE # 四足愉快
      - QUADRUPED_LOCOMOTION_STEP    # 四足踏步(进入gated动作前的稳定闸门)
      - QUADRUPED_GET_DOWN_DEFAULT

  QUADRUPED_GET_DOWN_DEFAULT:  # 四足趴下
    next_actions:
      - QUADRUPED_READY_STAND_DEFAULT
      - QUADRUPED_SIT_DOWN_DEFAULT
      - QUADRUPED_LOCOMOTION_HANDSHAKE
  
  QUADRUPED_SIT_DOWN_DEFAULT:  # 四足坐下
    next_actions:
      - QUADRUPED_GET_DOWN_DEFAULT
      - STORE_DEFAULT
      - QUADRUPED_STAND_DEFAULT
      - QUADRUPED_LOCOMOTION_HANDSHAKE

  QUADRUPED_LOCOMOTION_DEFAULT:  # 四足行走
    next_actions:
      - QUADRUPED_LOCOMOTION_STEP
      - STORE_DEFAULT
      - QUADRUPED_TO_BIPED
      - QUADRUPED_TO_BIPED_ROTATE
      - QUADRUPED_GET_DOWN_DEFAULT
      # - QUADRUPED_TO_BIPED_FRONTFLIP      

# 四足步伐
  QUADRUPED_LOCOMOTION_STEP:
    next_actions:
      # gated 目标：踏步稳定(ExitCheck 放行)后才进入
      - QUADRUPED_LOCOMOTION_STRETCH
      - QUADRUPED_LOCOMOTION_DANCE
      - QUADRUPED_PUSH_UP
      - QUADRUPED_LOCOMOTION_PRIDE
      - QUADRUPED_LOCOMOTION_BIONIC
      # - QUADRUPED_GET_DOWN_DEFAULT
      - QUADRUPED_SIT_DOWN_DEFAULT
      - QUADRUPED_MIMIC
      # - QUADRUPED_TO_BIPED
      # - QUADRUPED_TO_BIPED_ROTATE
      # - QUADRUPED_TO_BIPED_FRONTFLIP
      - QUADRUPED_LOCOMOTION_FRONTFLIP
      - QUADRUPED_LOCOMOTION_BACKFLIP
      - QUADRUPED_LOCOMOTION_PLEASURE
      # 归宿态
      - QUADRUPED_STAND_DEFAULT
      - QUADRUPED_STAND_REVERSE_DEFAULT # 四足前肢手臂反轴站立
      - QUADRUPED_BODY_ADJUST_DEFAULT   # 四足姿态调整
      - STORE_DEFAULT
      - QUADRUPED_LOCOMOTION_HANDSHAKE
      - QUADRUPED_LOCOMOTION_JUMP # 四足跳跃
      - QUADRUPED_LOCOMOTION_TERRAIN
      - QUADRUPED_LOCOMOTION_RUN
      - QUADRUPED_LOCOMOTION_DEFAULT


# 四足室外模式
  QUADRUPED_LOCOMOTION_RUN:
    next_actions:
      - QUADRUPED_LOCOMOTION_STEP
      - STORE_DEFAULT
      - QUADRUPED_TO_BIPED
      - QUADRUPED_TO_BIPED_ROTATE
      - QUADRUPED_GET_DOWN_DEFAULT
      # - QUADRUPED_TO_BIPED_FRONTFLIP      

# 四足超能模式 越野模式
  QUADRUPED_LOCOMOTION_TERRAIN:
    next_actions:
      - QUADRUPED_LOCOMOTION_STEP
      - STORE_DEFAULT
      - QUADRUPED_TO_BIPED
      - QUADRUPED_TO_BIPED_ROTATE
      - QUADRUPED_GET_DOWN_DEFAULT
      # - QUADRUPED_TO_BIPED_FRONTFLIP

# 四足仿生
  QUADRUPED_LOCOMOTION_BIONIC:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_LOCOMOTION_TERRAIN
      - QUADRUPED_LOCOMOTION_RUN

# 四足骄傲
  QUADRUPED_LOCOMOTION_PRIDE:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      # - QUADRUPED_LOCOMOTION_PLEASURE

# 四足推胸
  QUADRUPED_PUSH_UP:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_STAND_DEFAULT

# 四足模仿
  QUADRUPED_MIMIC:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_LOCOMOTION_TERRAIN
      - QUADRUPED_LOCOMOTION_RUN
      - QUADRUPED_STAND_DEFAULT

# 四足愉快
  QUADRUPED_LOCOMOTION_PLEASURE:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_LOCOMOTION_STEP

# 四足跳跃
  QUADRUPED_LOCOMOTION_JUMP:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_STAND_DEFAULT
  
# 四足握手
  QUADRUPED_LOCOMOTION_HANDSHAKE:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_STAND_DEFAULT
      - QUADRUPED_SIT_DOWN_DEFAULT

# 四足恢复模式 腹部朝地
  QUADRUPED_RECOVERY:
    next_actions:
      - QUADRUPED_LOCOMOTION_STEP   # 退出后先踏步稳定，再由 STEP 路由到 STAND 等归宿
      - STORE_DEFAULT

# 四足伸展
  QUADRUPED_LOCOMOTION_STRETCH:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_STAND_DEFAULT
  
# 四足舞蹈
  QUADRUPED_LOCOMOTION_DANCE:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_STAND_DEFAULT
  
# 双足站立模式
  BIPED_STAND_DEFAULT:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION
      # - BIPED_LOCOMOTION_TERRAIN
      # - BIPED_TO_QUADRUPED

# 双足恢复模式
  BIPED_RECOVERY:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION
      # - BIPED_LOCOMOTION_TERRAIN
      # - BIPED_TO_QUADRUPED
# 双足全身控制模式 / 双足室内模式
  BIPED_LOCOMOTION_WBC:
    next_actions:
      # - BIPED_STAND_DEFAULT
      - BIPED_TO_QUADRUPED
      # - BIPED_TO_QUADRUPED_FRONTFLIP
      - BIPED_TO_QUADRUPED_ROTATE
      - BIPED_LOCOMOTION_TERRAIN
      - BIPED_LOCOMOTION_RUN 
      - BIPED_LOCOMOTION_DEFAULT
      - BIPED_LOCOMOTION_ROTATE_LOCAL
      - BIPED_LOCOMOTION_BACKBEND
      - BIPED_YUZURU
      - BIPED_SPLIT
      - BIPED_LOCOMOTION_MOONWALK
      - BIPED_LOCOMOTION_DANCE
      - BIPED_LOCOMOTION_ANIMATION
      # - BIPED_LOCOMOTION_WBCDANCE
      - BIPED_MIMIC
      - BIPED_LINGCHUANG_MIMIC
      - BIPED_GIMBAL
      - BIPED_NPZ_MIMIC
      - BIPED_RECORD_UPPER
      - BIPED_CUSTOM_UPPER


  # BIPED_LOCOMOTION_WBCDANCE:
  #   next_actions:
  #     - BIPED_LOCOMOTION_WBC

  BIPED_RECORD_UPPER:
    next_actions:
      # - BIPED_STAND_DEFAULT
      - BIPED_LOCOMOTION_WBC

# 双足上肢模仿（从 WBC 切入；可 SetMcAction 打断，出口与 ANIMATION 对齐）
  BIPED_MIMIC:
    next_actions:
      - BIPED_TO_QUADRUPED
      # - BIPED_TO_QUADRUPED_FRONTFLIP
      - BIPED_TO_QUADRUPED_ROTATE
      - BIPED_LOCOMOTION_TERRAIN
      - BIPED_LOCOMOTION_RUN
      - BIPED_LOCOMOTION_DEFAULT
      - BIPED_LOCOMOTION_ROTATE_LOCAL
      - BIPED_LOCOMOTION_BACKBEND
      - BIPED_YUZURU
      - BIPED_SPLIT
      - BIPED_LOCOMOTION_MOONWALK
      - BIPED_LOCOMOTION_WBC
      - BIPED_LOCOMOTION_ANIMATION

# 双足灵创模仿（轨迹内嵌 onnx；可 SetMcAction 打断）
  BIPED_LINGCHUANG_MIMIC:
    next_actions:
      - BIPED_TO_QUADRUPED
      # - BIPED_TO_QUADRUPED_FRONTFLIP
      - BIPED_TO_QUADRUPED_ROTATE
      - BIPED_LOCOMOTION_TERRAIN
      - BIPED_LOCOMOTION_RUN
      - BIPED_LOCOMOTION_DEFAULT
      - BIPED_LOCOMOTION_ROTATE_LOCAL
      - BIPED_LOCOMOTION_BACKBEND
      - BIPED_YUZURU
      - BIPED_SPLIT
      - BIPED_LOCOMOTION_MOONWALK
      - BIPED_LOCOMOTION_WBC
      - BIPED_LOCOMOTION_ANIMATION

# 双足 gimbal（从 WBC 切入；可 SetMcAction 打断，出口回 WBC）
  BIPED_GIMBAL:
    next_actions:
      - BIPED_TO_QUADRUPED
      # - BIPED_TO_QUADRUPED_FRONTFLIP
      - BIPED_TO_QUADRUPED_ROTATE
      - BIPED_LOCOMOTION_TERRAIN
      - BIPED_LOCOMOTION_RUN
      - BIPED_LOCOMOTION_DEFAULT
      - BIPED_LOCOMOTION_ROTATE_LOCAL
      - BIPED_LOCOMOTION_BACKBEND
      - BIPED_YUZURU
      - BIPED_SPLIT
      - BIPED_LOCOMOTION_MOONWALK
      - BIPED_LOCOMOTION_WBC
      - BIPED_LOCOMOTION_ANIMATION
        
# 双足 npz 模仿（onnx 策略 + npz 参考轨迹；可 SetMcAction 打断）
  BIPED_NPZ_MIMIC:
    next_actions:
      - BIPED_TO_QUADRUPED
      # - BIPED_TO_QUADRUPED_FRONTFLIP
      - BIPED_TO_QUADRUPED_ROTATE
      - BIPED_LOCOMOTION_TERRAIN
      - BIPED_LOCOMOTION_RUN
      - BIPED_LOCOMOTION_DEFAULT
      - BIPED_LOCOMOTION_ROTATE_LOCAL
      - BIPED_LOCOMOTION_BACKBEND
      - BIPED_YUZURU
      - BIPED_SPLIT
      - BIPED_LOCOMOTION_MOONWALK
      - BIPED_LOCOMOTION_WBC
      - BIPED_LOCOMOTION_ANIMATION

# 双足动画模式
  BIPED_LOCOMOTION_ANIMATION:
    next_actions:
      # - BIPED_STAND_DEFAULT
      - BIPED_TO_QUADRUPED
      # - BIPED_TO_QUADRUPED_FRONTFLIP
      - BIPED_TO_QUADRUPED_ROTATE
      - BIPED_LOCOMOTION_TERRAIN
      - BIPED_LOCOMOTION_RUN 
      - BIPED_LOCOMOTION_DEFAULT
      - BIPED_LOCOMOTION_ROTATE_LOCAL
      - BIPED_LOCOMOTION_BACKBEND
      - BIPED_YUZURU
      - BIPED_SPLIT
      - BIPED_LOCOMOTION_MOONWALK
      - BIPED_LOCOMOTION_WBC

# 双足超能模式
  BIPED_LOCOMOTION_RUN:
    next_actions:
      # - BIPED_STAND_DEFAULT
      - BIPED_LOCOMOTION_WBC
      - BIPED_TO_QUADRUPED_ROTATE
      # - BIPED_LOCOMOTION_ANIMATION

# 双足越野模式
  BIPED_LOCOMOTION_TERRAIN:
    next_actions:
      # - BIPED_STAND_DEFAULT
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION

# 双足羽生结弦
  BIPED_YUZURU:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION

# 双足批叉
  BIPED_SPLIT:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION

# 双足室外模式
  BIPED_LOCOMOTION_DEFAULT:
    next_actions:
      - BIPED_LOCOMOTION_TERRAIN
      - BIPED_LOCOMOTION_WBC
      - BIPED_LOCOMOTION_RUN

      # - BIPED_LOCOMOTION_ANIMATION
# 四足到双足
  QUADRUPED_TO_BIPED:
    next_actions:
      # - BIPED_STAND_DEFAULT
      - BIPED_LOCOMOTION_WBC
      - BIPED_LOCOMOTION_TERRAIN
      # - BIPED_LOCOMOTION_ANIMATION
      # - BIPED_TO_QUADRUPED
# 四足旋转变双足
  QUADRUPED_TO_BIPED_ROTATE:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION
      - BIPED_LOCOMOTION_TERRAIN

# 双足变四足
  BIPED_TO_QUADRUPED:
    next_actions:
      - QUADRUPED_STAND_DEFAULT
      - QUADRUPED_LOCOMOTION_DEFAULT
      - QUADRUPED_LOCOMOTION_TERRAIN
  
# 双足前空翻变四足
  BIPED_TO_QUADRUPED_FRONTFLIP:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT

# 双足旋转变四足
  BIPED_TO_QUADRUPED_ROTATE:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
  
# 四足前空翻
  QUADRUPED_LOCOMOTION_FRONTFLIP:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
  
# 四足后空翻
  QUADRUPED_LOCOMOTION_BACKFLIP:
    next_actions:
      - QUADRUPED_LOCOMOTION_DEFAULT
  
# 四足前空翻变双足
  QUADRUPED_TO_BIPED_FRONTFLIP:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION

# 双足旋转
  BIPED_LOCOMOTION_ROTATE_LOCAL:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION

# 双足后弯
  BIPED_LOCOMOTION_BACKBEND:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      # - BIPED_LOCOMOTION_ANIMATION

# 双足太空漫步
  BIPED_LOCOMOTION_MOONWALK:
    next_actions:
      - BIPED_LOCOMOTION_WBC
      - BIPED_LOCOMOTION_RUN
      # - BIPED_LOCOMOTION_ANIMATION

  BIPED_LOCOMOTION_DANCE:
    next_actions:
      - BIPED_LOCOMOTION_WBC


  BIPED_CUSTOM_UPPER:
    next_actions:
      - BIPED_LOCOMOTION_WBC
  # TEST ACTION
  # TEST_PLATFORM:
  #   next_actions:
  #     - PASSIVE_DEFAULT

  # TEST_FOURIER:
  #   next_actions:
  #     - PASSIVE_DEFAULT
```


---

## FILE: raw/t1/config/security_guard.yaml

- bytes: 2770

```yaml
cmd_guard:
  expiration_time_ms: 200 # unit: ms

body_posture_guard:
  # 通用兜底（当下面分形态参数未设置或<=0时生效）
  fall_count_threshold: 3
  fall_delta_threshold: 60.0
  stand_arm_delta: 45.0

  # T1双足（x为上）
  biped_fall_count_threshold: 3
  biped_fall_delta_threshold: 60.0
  biped_stand_arm_delta: 45.0
  monitored_actions_biped: # 位控站立、行走、奔跑、越野、wbc
    - BIPED_STAND_DEFAULT
    - BIPED_LOCOMOTION_DEFAULT
    - BIPED_LOCOMOTION_RUN
    - BIPED_LOCOMOTION_TERRAIN
    - BIPED_LOCOMOTION_WBC
    - BIPED_CUSTOM_UPPER
    - BIPED_LOCOMOTION_ANIMATION
    - BIPED_MIMIC
    - BIPED_LINGCHUANG_MIMIC
    - BIPED_GIMBAL
    - BIPED_LOCOMOTION_MOONWALK
    - BIPED_RECORD_UPPER
    - BIPED_LOCOMOTION_WBCDANCE
    - BIPED_NPZ_MIMIC


  # T1四足（z为上）
  quadruped_fall_count_threshold: 3
  quadruped_fall_delta_threshold: 60.0
  quadruped_stand_arm_delta: 45.0
  monitored_actions_quadruped: # 位控站立、行走、奔跑、越野、踏步、握手、伸展
    - QUADRUPED_STAND_DEFAULT
    - QUADRUPED_LOCOMOTION_DEFAULT
    - QUADRUPED_LOCOMOTION_RUN
    - QUADRUPED_LOCOMOTION_TERRAIN
    - QUADRUPED_LOCOMOTION_HANDSHAKE
    - QUADRUPED_LOCOMOTION_STEP
    - QUADRUPED_LOCOMOTION_STRETCH
    - QUADRUPED_PUSH_UP
    - QUADRUPED_MIMIC
    - QUADRUPED_LOCOMOTION_BIONIC
    - QUADRUPED_LOCOMOTION_PRIDE
    - QUADRUPED_LOCOMOTION_PLEASURE
    - QUADRUPED_LOCOMOTION_DANCE
    - QUADRUPED_SIT_DOWN_DEFAULT
    - QUADRUPED_LOCOMOTION_JUMP
    - QUADRUPED_CROUCH_DEFAULT
    - QUADRUPED_STAND_REVERSE_DEFAULT
    - QUADRUPED_LOCOMOTION_REVERSE_DEFAULT
    - QUADRUPED_BODY_ADJUST_DEFAULT

  # T1 通道2（与 Q1 相同参数）：gyro_norm_threshold_rad_s<=0 时仅通道1；启用通道2 时必须配置 fall_delta_soft_threshold>0
  gyro_norm_threshold_rad_s: 6.0
  fall_delta_soft_threshold: 48.0
  gyro_fall_count_threshold: 3

# 通道3：基于 URDF 正向运动学的"脚相对躯干位置"摔倒检测
# BIPED 时 BASELINK 系下：x 为上方向（脚标称 ~ -0.62）、z 为前后方向（脚标称 ~ 0）
# 命中条件：任一脚 |z| > biped_horizontal_abs_max 或 |x| < biped_vertical_abs_min
foot_relative_guard:
  enabled: true
  urdf_file_name: qd1.urdf
  torso_link: BASELINK
  biped_left_foot_link: RL_FOOT_Link
  biped_right_foot_link: RR_FOOT_Link
  biped_horizontal_abs_max: 0.8  # 前后方向阈值，超过即"摔出"
  biped_vertical_abs_min: 0.4    # 竖直方向阈值，小于即"塌缩"
  count_threshold: 20

data_timeout_guard:
  enabled: true
  imu_timeout_ms: 10    # IMU 数据接收超时阈值（ms）
  joint_timeout_ms: 10  # Joint 数据接收超时阈值（ms）
  hds_report_interval_ms: 1000  # 持续超时期间的 HDS 周期性上报间隔（ms）
```


---

## FILE: raw/t1/config/robot_model.yaml

- bytes: 6555

```yaml
joints:
  - # 上肢关节
    - UPPER_JOINT
    - # 左上肢
      - name: FL_HIP_ROLL_Joint
        limits:
          lower_position: -0.43633
          upper_position: 0.43633
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67  # TN 曲线堵转扭矩
          tn_k: 3.183   # TN 曲线斜率
      - name: FL_HIP_PITCH_Joint
        limits:
          lower_position: -1.1868
          upper_position: 4.3284
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67  # TN 曲线堵转扭矩
          tn_k: 3.183   # TN 曲线斜率
      - name: FL_KNEE_Joint
        limits:
          lower_position: -2.5831
          upper_position: 2.5831
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67  # TN 曲线堵转扭矩
          tn_k: 3.183   # TN 曲线斜率
      # 右上肢
      - name: FR_HIP_ROLL_Joint
        limits:
          lower_position: -0.43633
          upper_position: 0.43633
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67  # TN 曲线堵转扭矩
          tn_k: 3.183   # TN 曲线斜率
      - name: FR_HIP_PITCH_Joint
        limits:
          lower_position: -1.1868
          upper_position: 4.3284
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67  # TN 曲线堵转扭矩
          tn_k: 3.183   # TN 曲线斜率
      - name: FR_KNEE_Joint
        limits:
          lower_position: -2.5831
          upper_position: 2.5831
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67
          tn_k: 3.183
  - # 下肢关节
    - LOWER_JOINT
    - 
      - name: RL_HIP_ROLL_Joint
        limits:
          lower_position: -1.5359
          upper_position: 1.5359
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RL_HIP_PITCH_Joint
        limits:
          lower_position: 0.034907
          upper_position: 3.1067
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67
          tn_k: 3.183
      - name: RL_KNEE_Joint
        limits:
          lower_position: -2.4958
          upper_position: -0.20944
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67
          tn_k: 3.183
      # 右下肢
      - name: RR_HIP_ROLL_Joint
        limits:
          lower_position: -1.57202
          upper_position: 1.5359
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67
          tn_k: 3.183
      - name: RR_HIP_PITCH_Joint
        limits:
          lower_position: 0.034907
          upper_position: 3.1067
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67
          tn_k: 3.183
      - name: RR_KNEE_Joint
        limits:
          lower_position: -2.4958
          upper_position: -0.20944
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 56.67
          tn_k: 3.183
  - # 轮子关节
    - WHEEL_JOINT
    - 
      - name: RL_FOOT_Joint
        limits:
          # lower_position: -inf
          # upper_position: inf
          max_velocity: 38.746
          max_effort: 15.0
          tn_t0: 26.42  # TN 曲线堵转扭矩
          tn_k: 0.6821   # TN 曲线斜率
      - name: RR_FOOT_Joint
        limits:
          # lower_position: -inf
          # upper_position: inf
          max_velocity: 38.746
          max_effort: 15.0
          tn_t0: 26.42  # TN 曲线堵转扭矩
          tn_k: 0.6821   # TN 曲线斜率
  - # 全量关节，序号和hal层一致
    - JOINT
    -
      - name: FL_HIP_ROLL_Joint
        limits:
          lower_position: -0.43633
          upper_position: 0.43633
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 24.42
          tn_k: 0.6821
      - name: FL_HIP_PITCH_Joint
        limits:
          lower_position: -1.1868
          upper_position: 4.3284
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: FL_KNEE_Joint
        limits:
          lower_position: -2.5831
          upper_position: 2.5831
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: FR_HIP_ROLL_Joint
        limits:
          lower_position: -0.43633
          upper_position: 0.43633
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 24.42
          tn_k: 0.6821
      - name: FR_HIP_PITCH_Joint
        limits:
          lower_position: -1.1868
          upper_position: 4.3284
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: FR_KNEE_Joint
        limits:
          lower_position: -2.5831
          upper_position: 2.5831
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RL_HIP_ROLL_Joint
        limits:
          lower_position: -1.5359
          upper_position: 1.5359
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RL_HIP_PITCH_Joint
        limits:
          lower_position: 0.034907
          upper_position: 3.1067
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RL_KNEE_Joint
        limits:
          lower_position: -2.4958
          upper_position: -0.20944
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RL_FOOT_Joint
        limits:
          # lower_position: -inf
          # upper_position: inf
          max_velocity: 38.746
          max_effort: 15.0
      - name: RR_HIP_ROLL_Joint
        limits:
          lower_position: -1.57202
          upper_position: 1.5359
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RR_HIP_PITCH_Joint
        limits:
          lower_position: 0.034907
          upper_position: 3.1067
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RR_KNEE_Joint
        limits:
          lower_position: -2.4958
          upper_position: -0.20944
          max_velocity: 17.802
          max_effort: 30.0
          tn_t0: 52.67
          tn_k: 3.183
      - name: RR_FOOT_Joint
        limits:
          # lower_position: -inf
          # upper_position: inf
          max_velocity: 38.746
          max_effort: 15.0
```


---

## FILE: raw/t1/config/trajectory_generator.yaml

- bytes: 253

```yaml
dt: 0.001
effort: 1000.0
period: 5.0

joints:
  -
    - JOINT # 14 DOF
    -
      kp: [50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0]
      kd: [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
```


---

## FILE: raw/t1/config/motion_list.yaml

- bytes: 39652

```yaml
##################################################################
#
# 配置说明:
# name:            动作名称
# type:            动作类型
# motion_area:     动作执行的区域
# interrupt_type:  打断类型
# policy_path:     模型文件路径
# custom:          扩展的配置
#  start_count       动作开始帧
#  end_count         动作结束帧
#  trajectory_path   额外的依赖文件路径
#  interrupt_frames   打断帧
#  animation_type     动画类型，T项目需要依赖该值区分柔性动作、刚性动作、保持末帧等
#
##################################################################

motion_types:
  QUADRUPED_MIMIC:        {body: whole, action: QUADRUPED_MIMIC}
  BIPED_MIMIC:            {body: whole, action: BIPED_MIMIC}
  ANIMATION:              {body: upper, action: BIPED_LOCOMOTION_WBC}
  BIPED_LINGCHUANG_MIMIC: {body: whole, action: BIPED_LINGCHUANG_MIMIC}
  BIPED_NPZ_MIMIC: {body: whole, action: BIPED_NPZ_MIMIC}


# Session Pool 配置
session_pool:
  max_dynamic_sessions: 10      # DYNAMIC 类型最大缓存Session数

motion_configs:

  #############################################################################
  #
  # 双足全身动作
  #
  #############################################################################
  ###################### 双足灵创 mimic（轨迹内嵌 onnx，与 rl/bi_lingchuang_mimic.yaml 中 policy.path 对应）######################
  # SetMcMotion: type=BIPED_LINGCHUANG_MIMIC, motion=<name>, interrupt=true
  # 需 action BIPED_LINGCHUANG_MIMIC + runner policy.path 为空，策略由本表下发
  # 历史跳舞
  # - name: BIPED_LINGCHUANG_MIMIC_DANCE_HISTORY
  #   type: BIPED_LINGCHUANG_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_dance_liuxingwu_wheel_03kd_model_19000.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: ""
  #     gravity_guard_path: ""

  # 海草舞
  # - name: BIPED_LINGCHUANG_MIMIC_HAICAO
  #   type: BIPED_LINGCHUANG_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_haicao_model_10500.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: ""
  #     gravity_guard_path: ""

  # 梅西动作
  # - name: BIPED_LINGCHUANG_MIMIC_MEIXI
  #   type: BIPED_LINGCHUANG_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_meixi_model_10500.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: ""
  #     gravity_guard_path: ""

  # 球迷舞
  # - name: BIPED_LINGCHUANG_MIMIC_QIUMI
  #   type: BIPED_LINGCHUANG_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_qiumi_model_10500.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: ""
  #     gravity_guard_path: ""

  # C罗动作 只有上肢而已
  # - name: BIPED_LINGCHUANG_MIMIC_CLUO
  #   type: BIPED_LINGCHUANG_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_cluo_model_16500.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: ""
  #     gravity_guard_path: ""
      
  # C罗动作跳起来 PASS
  # - name: BIPED_LINGCHUANG_MIMIC_CLUO_JUMP
  #   type: BIPED_LINGCHUANG_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_cluo_model_24500.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: ""
  #     gravity_guard_path: ""

  ###################### 双足 npz mimic 83obs（onnx 策略 + npz 参考轨迹）######################
  - name: BIPED_NPZ_MIMIC_JOYOUS
    type: BIPED_NPZ_MIMIC
    motion_area: 0
    interrupt_type: 0
    policy_path: "./rl_models/bi_npz_mimic_joyous_260827.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_npz_mimic/bi_npz_mimic_joyous_260827_10s.npz"
      gravity_guard_path: ""

  - name: BIPED_NPZ_MIMIC_JOYOUS2
    type: BIPED_NPZ_MIMIC
    motion_area: 0
    interrupt_type: 0
    policy_path: "./rl_models/bi_npz_mimic_joyous2_260908.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_npz_mimic/bi_npz_mimic_joyous2_260908.npz"
      gravity_guard_path: ""

  - name: BIPED_NPZ_MIMIC_JOYOUS3
    type: BIPED_NPZ_MIMIC
    motion_area: 0
    interrupt_type: 0
    policy_path: "./rl_models/bi_npz_mimic_joyous3_260828.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_npz_mimic/bi_npz_mimic_joyous3_260828_10s.npz"
      gravity_guard_path: ""

  # - name: BIPED_NPZ_MIMIC_FIGURE_SKATING
  #   type: BIPED_NPZ_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_npz_mimic_figure_skating_260923.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: "./res/biped_npz_mimic/bi_npz_mimic_figure_skating_260923_40s.npz"
  #     gravity_guard_path: ""

  # - name: BIPED_NPZ_MIMIC_AABATTERY
  #   type: BIPED_NPZ_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_npz_mimic_aabattery_jy_260917.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: "./res/biped_npz_mimic/pin_2609017.npz"
  #     gravity_guard_path: ""

  # - name: BIPED_NPZ_MIMIC_IWILLBETHERE
  #   type: BIPED_NPZ_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_npz_mimic_iwllbethere_wuqitiao_260915.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: "./res/biped_npz_mimic/I_will_be_there_260915.npz"
  #     gravity_guard_path: ""

  # - name: BIPED_NPZ_MIMIC_101
  #   type: BIPED_NPZ_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_npz_mimic_101_61_260919.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: "./res/biped_npz_mimic/101_61_260910.npz"
  #     gravity_guard_path: ""

  # - name: BIPED_NPZ_APRIL_LIE
  #   type: BIPED_NPZ_MIMIC
  #   motion_area: 0
  #   interrupt_type: 0
  #   policy_path: "./rl_models/bi_npz_mimic_april_lie_260923.onnx"
  #   custom:
  #     start_count: 0
  #     end_count: 0
  #     trajectory_path: "./res/biped_npz_mimic/april_lie_260923_100s.npz"
  #     gravity_guard_path: ""

  ###################### 双足 mimic ######################
  # 策略模型在 rl/bi_mimic.yaml 的 BaseConfig.policy.path 写死（Init 时加载，EnterCheck 不读本表 policy_path）
  # 以下动作共用同一模型：./rl_models/t1_bi_wbc_pitch0522.onnx；本表 policy_path 仅作记录
  # 各动作差异在 custom.trajectory_path（WBC 参考轨迹 CSV）
  - name: BIPED_MIMIC_SKATING
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/T1_bi_skating_30s.csv"  # ani_table id=2029
      gravity_guard_path: ""

  - name: BIPED_MIMIC_SHOW
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/T1_bi_show.csv"  # ani_table id=2027
      gravity_guard_path: ""

  # 3061 全身跳舞2 by Leah 20260612
  - name: BIPED_MIMIC_DANCE_WORLDCUP_ONE
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/3061.csv"  # ani_table id=3061
      gravity_guard_path: ""

  # 双足摇篮舞
  - name: BIPED_MIMIC_YAOLAWU
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/3069.csv"  # ani_table id=3069
      gravity_guard_path: ""
  # 双足球迷舞蹈
  - name: BIPED_MIMIC_QIUMI
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/3070.csv"  # ani_table id=3070
      gravity_guard_path: ""
  # 双足挠痒痒
  - name: BIPED_MIMIC_NAOYANGYANG
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/T1_bi_dance_two_three.csv"
      gravity_guard_path: ""
   # 双足泼水舞
  - name: BIPED_MIMIC_POSHUIWU
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/dance_part2.csv"
      gravity_guard_path: ""
  # 双足POPPING舞
  - name: BIPED_MIMIC_POPPING
    type: BIPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t1_bi_wbc_pitch0522.onnx"
    custom:
      start_count: 0
      end_count: 0
      trajectory_path: "./res/biped_mimic_motion/Double_hand_dance_update.csv"
      gravity_guard_path: ""
  ###################### 四足 mimic ######################
  # 策略模型在 rl/quad_mimic.yaml 的 BaseConfig.policy.path 写死（Init 时加载，EnterCheck 不读本表 policy_path）
  # 以下动作共用同一模型：./rl_models/t15_quad_twist_xy_v1.0.onnx；本表 policy_path 仅作记录
  # 各动作差异在 custom.trajectory_path（参考轨迹 CSV）
  # SetMcMotion: type=MIMIC_QY(1), motion=<name>, interrupt=true

  #############################################################################
  #
  # 四足动作
  #
  #############################################################################

  # 四足扭腰
  - name: QUAD_MIMIC
    type: QUADRUPED_MIMIC
    motion_area: 0
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    interrupt_type: 1
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_test_100fps_10s.csv"
      gravity_guard_path: ""
  # 四足骄傲
  - name: QUAD_MIMIC_PRIDE
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_pride.csv"
      gravity_guard_path: ""
  # 四足思考
  - name: QUAD_MIMIC_PONDER
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_ponder.csv"
      gravity_guard_path: ""
  # 四足聆听
  - name: QUAD_MIMIC_HEED
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_heed.csv"
      gravity_guard_path: ""
  # 四足四处看 用于亮相动作展示
  - name: QUAD_MIMIC_GLANCE
    type: QUADRUPED_MIMIC
    motion_area: 0
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    interrupt_type: 1
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_glance.csv"
      gravity_guard_path: ""
  # 四足跳舞动作2
  - name: QUAD_MIMIC_DANCE_TWO
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_dance_two.csv"
      gravity_guard_path: ""
  # 四足跳舞动作3
  - name: QUAD_MIMIC_DANCE_THREE
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_dance_three.csv"
      gravity_guard_path: ""
  # 四足讲话1 动作幅度小
  - name: QUAD_MIMIC_TALK_ONE
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_talk_one.csv"
      gravity_guard_path: ""
  # 四足讲话2 幅度同样小
  - name: QUAD_MIMIC_TALK_TWO
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_talk_two.csv"
      gravity_guard_path: ""
  # 四足讲话3
  - name: QUAD_MIMIC_TALK_THREE
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_talk_three.csv"
      gravity_guard_path: ""
  # 四足讲话4
  - name: QUAD_MIMIC_TALK_FOUR
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_talk_four.csv"
      gravity_guard_path: ""
  # 四足动作5 基于四足动作2放大得来
  - name: QUAD_MIMIC_TALK_FIVE
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_talk_five.csv"
      gravity_guard_path: ""
  # 四足害怕
  - name: QUAD_MIMIC_SCARED
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_scared.csv"
      gravity_guard_path: ""
  # 四足律动2
  - name: QUAD_MIMIC_RHYTHM_TWO
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_rhythm_two.csv"
      gravity_guard_path: ""
  # 四足律动
  - name: QUAD_MIMIC_RHYTHM
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_rhythm_eleven.csv"
      gravity_guard_path: ""
  # 四足难过
  - name: QUAD_MIMIC_SAD
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_sad.csv"
      gravity_guard_path: ""
  # 四足握手
  - name: QUAD_MIMIC_HANDSHAKE
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_handshake.csv"
      gravity_guard_path: ""
  # 四足打招呼
  - name: QUAD_MIMIC_GREET
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_greet.csv"
      gravity_guard_path: ""
  # 四足呼吸
  - name: QUAD_MIMIC_BREATH
    type: QUADRUPED_MIMIC
    motion_area: 0
    interrupt_type: 1
    policy_path: "./rl_models/t15_quad_twist_xy_v1.0.onnx"
    custom:
      start_count: 0
      end_count: 10
      trajectory_path: "./res/quad_mimic_motion/qd1_quad_breath.csv"
      gravity_guard_path: ""
  
  #############################################################################
  #
  # 上肢动作
  #
  #############################################################################

  ###################### 恢复到初始姿态 ######################
  # - name: 100
  #   type: ANIMATION
  #   motion_area: 1
  #   interrupt_type: 1
  #   policy_path: ""
  #   custom:
  #     fps: 60
  #     animation_type: animation
  #     trajectory_path: "./res/biped_upper_motion/Double_hand_default_pos.csv"

  ###################### 右手挥手 ######################
  - name: 1001
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_right_waving_v2.csv"

  ###################### 右手握手 ######################
  - name: 1002
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_right_handshake.csv"

  ###################### 右手挥手，面对1.5m以上观众时 ######################
  - name: 1003
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_right_waving_for_1d5m_people.csv"

  ###################### 右手碰拳 ######################
  - name: 1004
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_right_fist_bump.csv"

  ###################### 右手加油欢呼 ######################
  - name: 1005
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_right_cherring.csv"

  ###################### 右手抬起(持摄像杆) ######################
  - name: 1006
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/Single_hand_holding_camera_1.csv"

  ###################### 右手拍照抬起 ######################
  - name: 1007
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/Single_hand_holding_camera_2.csv"

  ###################### 左手挥手 ######################
  - name: 1011
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_left_waving_v2.csv"

  ###################### 左手握手 ######################
  - name: 1012
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_left_handshake.csv"

  ###################### 左手挥手，面对1.5m以上观众时 ######################
  - name: 1013
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_left_waving_for_1d5m_people.csv"

  ###################### 左手碰拳 ######################
  - name: 1014
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_left_fist_bump.csv"

  ###################### 左手加油欢呼 ######################
  - name: 1015
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Single_hand_left_cherring.csv"

  ###################### 左手抬起 ######################
  - name: 1016
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/Single_hand_left_holding_camera_1.csv"

  ###################### 双手比心 ######################
  - name: 2001
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_making_heart_update_1.csv"

  ###################### 喜悦时双手挥动 ######################
  - name: 2002
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_happy.csv"

  ###################### 说话动作 ######################
  - name: 2003
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_talking.csv"

  ###################### 说话动作1 ######################
  - name: 2004
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_talk1.csv"

  ###################### 说话动作2 ######################
  - name: 2005
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_talk2.csv"

  ###################### 说话动作3 ######################
  - name: 2006
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_talk3.csv"

  ###################### 说话动作4 ######################
  - name: 2007
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_talk4.csv"

  ###################### 说话动作5 ######################
  - name: 2008
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_talk5.csv"

  ###################### 说话动作6 ######################
  - name: 2009
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_talk6.csv"

  ###################### 拍照动作1 ######################
  - name: 2011
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_Pose01_planner.csv"

  ###################### 拍照动作2 ######################
  - name: 2012
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_Pose02_planner.csv"

  ###################### 拍照动作3 ######################
  - name: 2013
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_Pose03_planner.csv"

  ###################### 拍照动作4 ######################
  - name: 2014
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_Pose04_planner.csv"

  ###################### 双手抬起 ######################
  - name: 2015
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/Double_hand_raise_holding.csv"

  ###################### 双手加油欢呼 用刘开源设计的舞蹈动作1替换 ######################
  - name: 2016
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_dance_one.csv"

  ###################### 骄傲 ######################
  - name: 2017
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_proud_update.csv"

  ###################### 三连拍 ######################
  - name: 2020
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_three_shot_1.csv"

  ###################### 跳舞动作 ######################
  - name: 2021
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_dance_one.csv"

  ###################### 蛇形舞动1 ######################
  - name: 2022
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_dance_two.csv"

  ###################### 使用刘开源设计的舞蹈动作2和3拼接 大概20s ######################
  - name: 2023
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 130
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_dance_two_three.csv"

  ###################### 小幅度说话动作 ######################
  - name: 2024
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_talk_weak.csv"

  ###################### 人形炫耀动作 只有上肢版本 ######################
  - name: 2025
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_show_justarm.csv"

  ###################### 人形拥抱 ######################
  - name: 2026
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_hug.csv"

  ###################### 人形炫耀 带腰部 ######################
  - name: 2027
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_show.csv"

  ###################### 人形炫耀 腰部更明显 ######################
  - name: 2028
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_show_smallz.csv"

  ###################### 人形滑冰 30s 会下腰 ######################
  - name: 2029
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 110
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_skating_30s.csv"

  ###################### 人形滑冰 ######################
  - name: 2030
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_skating_backup_neg.csv"

  ###################### 人形律动 ######################
  - name: 2031
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_rhythm.csv"

  ###################### 人形喜悦 ######################
  - name: 2032
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_happy.csv"

  ###################### 人形难过 ######################
  - name: 2033
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_sad.csv"

  ###################### 人形害怕 ######################
  - name: 2034
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_scared.csv"

  ###################### 人形思考1 ######################
  - name: 2035
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_ponder_one.csv"

  ###################### 人形思考2 ######################
  - name: 2036
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_ponder_two.csv"

  ###################### 人形思考3 ######################
  - name: 2037
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_ponder_three.csv"

  ###################### 人形思考4 ######################
  - name: 2038
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_ponder_four.csv"

  ###################### 人形惯性转圈90度 ######################
  - name: 2039
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_spin_90.csv"

  ###################### 人形惯性转圈360度 ######################
  - name: 2040
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_spin_360.csv"

  ###################### 人形聆听 ######################
  - name: 2041
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_heed.csv"

  ###################### 人形31s配合讲话的动作 ######################
  - name: 2042
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/T1_bi_ice_breaking_dance.csv"

  ###################### 蛇形舞动2 重新修改后的导演剪辑版本 ######################
  - name: 2043
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 150
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/dance_part2.csv"

  ###################### 跳舞动作 ######################
  - name: 2044
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 60
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/Double_hand_dance_update.csv"

  ###################### 左手高举起不放下 ######################
  - name: 2045
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/Single_hand_left_lift.csv"

  ###################### 右手高举起不放下 ######################
  - name: 2046
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/Single_hand_right_lift.csv"

  ###################### 单臂击掌 ######################
  - name: 3038
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3038.csv"

  ###################### 双手欢呼 ######################
  - name: 3040
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3040.csv"

  ###################### 双手挥舞 ######################
  - name: 3043
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3043.csv"

  ###################### 双手挥舞2 ######################
  - name: 3045
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3045.csv"

  ###################### 双手挥舞3 ######################
  - name: 3046
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3046.csv"

  ###################### 左右手挥舞 ######################
  - name: 3047
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3047.csv"

  ###################### 双手欢呼1 ######################
  - name: 3048
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3048.csv"

  ###################### 打招呼 ######################
  - name: 3052
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3052.csv"

  ###################### 双手欢呼2 ######################
  - name: 3054
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3054.csv"

  ###################### 双手欢呼3 ######################
  - name: 3055
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3055.csv"

  ###################### 打招呼2 ######################
  - name: 3056
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3056.csv"

  ###################### 全身跳舞2 by Leah 20260612 ######################
  - name: 3061
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 120
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3061.csv"

  ###################### 保持手臂动作1供点云采集 by Leah 20260616 ######################
  - name: 3062
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/3062.csv"

  ###################### 保持手臂动作2供点云采集 by Leah 20260616 ######################
  - name: 3064
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/3064.csv"

  ###################### 保持手臂动作3供点云采集 by Leah 20260616 ######################
  - name: 3065
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/3065.csv"

  ###################### 双足摇篮舞 ######################
  - name: 3069
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3069.csv"

  ###################### 双足球迷舞蹈 ######################
  - name: 3070
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: animation
      trajectory_path: "./res/biped_upper_motion/3070.csv"

  ###################### 放电脑用 ######################
  - name: 5001
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/arm_holdpc2.csv"

  ###################### 右手平举 ######################
  - name: 5002
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/photo.csv"

  ###################### 左手平举 ######################
  - name: 5003
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/photo2.csv"

  ###################### 右手高举 ######################
  - name: 5004
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/photo3.csv"

  ###################### 左手高举 ######################
  - name: 5005
    type: ANIMATION
    motion_area: 1
    interrupt_type: 1
    policy_path: ""
    custom:
      fps: 100
      animation_type: hold
      trajectory_path: "./res/biped_upper_motion/photo4.csv"
```


---

## FILE: raw/t1/hardware/device_manager_t1_v2d0.yaml

- bytes: 9648

```yaml
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
```


---

## FILE: raw/t1/hardware/system_mode_t1.yaml

- bytes: 5845

```yaml
aimrt:
  log:
    core_lvl: Info # 内核日志等级，可选项：Trace/Debug/Info/Warn/Error/Fatal/Off，不区分大小写
    default_module_lvl: Info # 模块默认日志等级
    backends:
      - type: rotate_file # 文件日志
        options:
          path: ${LOG_PATH} # 日志文件路径
          filename: sm.log # 日志文件名称
          max_file_size_m: 10 # 日志文件最大尺寸，单位m
          max_file_num: 5 # 最大日志文件数量，0代表无限

# 模块的相关配置
SystemManagerModule:
  project: "T1"    # 项目名
  version: "2.2.1"  # 版本号
  # 连续回滚最大次数，达到后停止自动重试
  max_rollback_count: 10

  # 底层运控二开模式下不由 SM 拉起或看护的模块
  low_level_dev_excluded_modules: [mc]

  # 关机时等待 Orin 下电的最大时长(ms)与轮询间隔(ms)
  shutdown_wait_ms: 3000
  shutdown_poll_interval_ms: 500

  # BMS 异常下电：收到 power_request=5 后发送 MCU 下电信号
  enable_bms_power_down: true
  bms_power_down_debounce_ms: 5000

  # 启用 HAL 资源功耗控制（tof/鱼眼/关节）；非本机型请保持 false 或不配置。
  enable_resource_power: true

  # 关节电源设置/查询失败后的重试次数（不含首次）；间隔单位 ms。
  joint_power_set_retry_count: 2
  joint_power_set_retry_interval_ms: 1500
  joint_power_get_retry_count: 2
  joint_power_get_retry_interval_ms: 1500
  # 上电设置成功后等待，再查询确认状态；单位 ms，0 表示不等待。
  joint_power_on_wait_ms: 5000

  # TOF/相机起停流失败后的重试次数（不含首次）；间隔单位 ms。
  stream_retry_count: 2
  stream_retry_interval_ms: 1500
  # 静默忽略 TOF/相机流 SET 重试耗尽及后续查询确认失败；false 恢复原失败处理，修改后需重启 SM。
  ignore_stream_set_failure: true
  # 鱼眼起停流 SET 成功后查询切换完成的超时上限；单位 ms，0 表示仅接受 SET 返回已完成。
  fisheye_stream_off_wait_ms: 30000

  # SM 低功耗自测：开启后按下方列表分流；修改后需重启 SM。
  enable_resource_power_mock: false
  # 仅列出的 key 走 mock（true 成功 / false 失败）；未列出的设备走真实 HAL / 关节 RPC。
  # 例：只 mock tof/鱼眼、电机真机时，删掉 joint/power/* 两项即可。
  # 如需测试流失败回退，先关闭 ignore_stream_set_failure，再将对应 off 设为 false、on 设为 true。
  resource_power_mock_results:
    tof/stream/off: true
    tof/stream/on: true
    fisheye/stream/off: true
    fisheye/stream/on: true
    joint/power/off: true
    joint/power/on: true

  # 模块分组
  em_modules:
    master: # soc0 / RK3576 主控板 (T1-2X, T1_v2d1)
      group: [hds, mc, task_engine, hal_camera, audio_manager]
      url: "http://${QY_MASTER_IP}:50081"
    slave0: # soc1 从控板 (Orin-Nano)
      group: [hal_rgbd, coreon_fusion]
      url: "http://${QY_SLAVE0_IP}:50081"

  # 功能组
  function_groups:
    "Diagnosis":
      [ "hds" ]
    "OTA":
      [ ]
    "HAL":
      [ "audio_manager" ]
    "EStop":
      []
    "Motion":
      [ "mc" ]
    "Business":
      [ "task_engine" ]
    "Perception":
      []
    "ProductionTest":
      []
    "Gateway":
      []
    "Poweroff":
      []
  # 模块依赖关系
  module_depends:
  #   "mc": [ "hal_ethercat" ]

  # 系统状态
  system_modes:
    "Startup":
      next_mode_list: [ "Ready", "OpenBox" ]
      active_FG_list: [ "HAL", "Business", "Diagnosis", "Motion", "OTA"]
      action_list:
        - [ DIFF ]

    # 开箱状态仅标记当前阶段，保留 Startup 的活跃模块，不执行应用操作
    "OpenBox":
      next_mode_list: [ "Ready", "Shutdown", "Business", "EStop" ]
      active_FG_list: [ "HAL", "Business", "Diagnosis", "Motion", "OTA"]
      action_list: []

    # 系统的就绪状态，会启动业务管理模块以及HAL
    "Ready":
      next_mode_list: [ "Business", "EStop", "OTA", "Shutdown", "StandbyPowerSave", "IdlePowerSave", "OpenBox" ]
      active_FG_list: [ "HAL", "Business", "Diagnosis", "Motion", "OTA"]
      action_list:
        # PowerSave 匹配待机/闲时退出，以及资源操作失败后的 Ready 恢复。
        - [ "resource_stream_on tof PowerSave" ]
        - [ DIFF ]

    # 业务运行状态，与 Ready 保持相同的活跃模块集，状态切换时 DiffAction 为空操作
    "Business":
      next_mode_list: [ "Ready", "EStop", "OTA", "Shutdown"]
      active_FG_list: [ "HAL", "Business", "Diagnosis", "Motion", "OTA", "Perception" ]
      action_list:
        - [ DIFF ]

    # 待机低功耗：四路侧向 TOF 停流，关节保持上电。
    "StandbyPowerSave":
      next_mode_list: [ "Ready", "IdlePowerSave", "Shutdown", "OTA" ]
      active_FG_list: [ "HAL", "Business", "Diagnosis", "Motion", "OTA"]
      action_list:
        - [ "resource_stream_off tof" ]
        - [ DIFF ]

    "IdlePowerSave":
      next_mode_list: [ "Ready", "StandbyPowerSave", "Shutdown", "OTA" ]
      active_FG_list: [ "HAL", "Business", "Diagnosis", "Motion", "OTA"]
      action_list:
        - [ "resource_stream_off tof" ]
        - [ DIFF ]

    # OTA状态，会启动OTA功能组，完成OTA相关功能
    "OTA":
      next_mode_list: [ "Ready", "EStop", "Shutdown"]
      active_FG_list: [ "OTA" ]
      action_list:
        - [ DIFF ]

    # 紧急停止状态，用于紧急停止
    "EStop":
      next_mode_list: [ "Ready", "OTA" ]
      active_FG_list: [ "HAL", "Diagnosis" ]
      action_list:
        - [ DIFF ]

    "Shutdown":
      next_mode_list: [ ]
      active_FG_list: [ "HAL", "Business", "Poweroff" ]
      action_list:
        - [ DIFF ]

  decision: # 系统决策层
    Auto_transToReady: false # 如果为false需要在一定时机下调用一键激活脚本
    Auto_transToManual: false
```


---

## FILE: raw/t1/hardware/process_soc0.yaml

- bytes: 11062

```yaml
worker_info:
  aima_req_worker:
    thread_num: 2
    listen_ip: "127.0.0.1"
    listen_port: 50080

  node_control_worker:
    thread_num: 1
    master_node: true
    listen_ip: "127.0.0.1"
    listen_port: 56999

process_manager:
  work_dir: "/robot/sys/proc"
  env_file: "/robot/software/process_manager/bin/cfg/env"
  agi_user_uid: 1000
  agi_user_gid: 1000
  sudo_preserve_env: "PYTHONPATH"
  # 二开模式启用有线网口，标准模式按标定配置禁用。仅 soc0(RK3576) 需要
  wired_port_control:
    enable: true
    sysfs: /sys/bus/mdio_bus/devices/stmmac-1:00/port0_disable
  startup_stages:
    - apps: [
        "sys_guard",
        "mc",
        "hal_rgbd",
        "audio_manager",
        "device_manager",
        "hal_sensor",

        # 系统状态监控
        "sm",
        "hds",

        # 用户感知应用
        "agent",
        "display_ui"
      ]
      delay_after_ms: 1500
    - apps: [
        # 用户感知应用
        "task_engine",

        "housekeeper",
        "app_proxy",
        "rc",

        # 数据导出
        "data_exporter",

        # 交互应用
        "hal_camera",
        "rtsp_server",

        # 数据录制
        "drp",

        # ota
        "ota",

        # 跟随算法节点
        "odom",
        # "move_camera",
        # "follow",
        # "face",
        # "tracking",
        # "yolov8",

        "lumina",
        "scene_engine",
        "insta360",
        "connx",
        "resource_manager",
        # "nova_agent",
        "abox",
      ]
      delay_after_ms: 5000
    - apps: [
        "conduit_router",
      ]
      delay_after_ms: 5000
    - apps: [
        # 云端代理
        "cloud_proxy",
      ]
      delay_after_ms: 8000


  cgroup:
    - name: "robot_realtime.slice"
      apps: ["mc", "device_manager"]
    - name: "robot_interaction.slice"
      apps: ["agent", "display_ui", "audio_manager", "task_engine"]
    - name: "robot_auxiliary.slice"
      apps: ["data_exporter"]

  apps:
    "face": # 人脸识别节点
      path: "/robot/software/algorithm/face/bin/start_face"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/face.log"
      stderr: "/tmp/face.err"
      env:
        LOG_PATH: /robot/persist/log/face

    "tracking":
      path: "/robot/software/algorithm/tracking/bin/start_tracking"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/track.log"
      stderr: "/tmp/track.err"
      env:
        LOG_PATH: /robot/persist/log/tracking

    "yolov8":
      path: "/robot/software/algorithm/yolov8_detection/bin/start_yolov8"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/yolo.log"
      stderr: "/tmp/yolo.err"
      env:
        LOG_PATH: /robot/persist/log/yolo

    "follow":
      path: "/robot/software/algorithm/follow/bin/start_follow"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/follow.log"
      stderr: "/tmp/follow.err"
      env:
        LOG_PATH: /robot/persist/log/follow

    "odom":
      path: "/robot/software/legged_odom/bin/em_run.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/odom.log"
      stderr: "/tmp/odom.err"
      env:
        LOG_PATH: /robot/persist/log/odom

    "move_camera":
      path: "/robot/software/algorithm/move_camera/bin/start_move_camera"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/move_camera.log"
      stderr: "/tmp/move_camera.err"
      env:
        LOG_PATH: /robot/persist/log/move_camera

    "hal_sensor":
      path: "/robot/software/hal_sensor/bin/em_run.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/hal_sensor.log"
      stderr: "/tmp/hal_sensor.err"
      env:
        LOG_PATH: /robot/persist/log/hal_sensor

    "hal_rgbd":
      path: "/robot/software/hal_rgbd/bin/em_run.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/hal_rgbd.log"
      stderr: "/tmp/hal_rgbd.err"
      env:
        LOG_PATH: /robot/persist/log/hal_rgbd

    "device_manager":
      path: "/robot/software/device_manager/bin/em_run.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/device_manager.log"
      stderr: "/tmp/device_manager.err"
      env:
        LOG_PATH: /robot/persist/log/device_manager

    # "hal_imu":
    #   path: "/robot/software/hal_imu/bin/em_run.sh"
    #   sudo: false
    #   # stdout: "/tmp/hal_imu.log"
    #   stderr: "/tmp/hal_imu.err"
    #   env:
    #     LOG_PATH: /robot/persist/log/hal_imu

    "drp":
      path: "/robot/software/drp/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/drp.log"
      stderr: "/tmp/drp.err"
      env:
        LOG_PATH: /robot/persist/log/drp

    "rc":
      path: "/robot/software/rc/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/rc.log"
      stderr: "/tmp/rc.err"
      env:
        LOG_PATH: /robot/persist/log/rc

    "mc":
      path: "/robot/software/mc/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/mc.log"
      stderr: "/tmp/mc.err"
      env:
        LOG_PATH: /robot/persist/log/mc

    "agent":
      path: "/robot/software/aimrt_agent/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/agent.log"
      stderr: "/tmp/agent.err"
      restart:
        max_retries: 500
      env:
        LOG_PATH: /robot/persist/log/agent
        FASTRTPS_DEFAULT_PROFILES_FILE: ${DDS_CFG_PREFIX}/ros_dds_configuration_all.xml

    "audio_manager":
      path: "/robot/software/audio_manager/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/audio_manager.log"
      stderr: "/tmp/audio_manager.err"
      env:
        LOG_PATH: /robot/persist/log/audio_manager

    "hal_camera":
      path: "/robot/software/hal_camera/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/hal_camera.log"
      stderr: "/tmp/hal_camera.err"
      env:
        LOG_PATH: /robot/persist/log/hal_camera
        FASTRTPS_DEFAULT_PROFILES_FILE: ${DDS_CFG_PREFIX}/ros_dds_configuration_all.xml

    "rtsp_server":
      path: "/robot/software/rtsp_server/em_run.sh"
      sudo: false
      # stdout: "/tmp/rtsp_server.log"
      stderr: "/tmp/rtsp_server.err"
      env:
        LOG_PATH: /robot/persist/log/rtsp_server

    "app_proxy":
      path: "/robot/software/app_proxy/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/app_proxy.log"
      stderr: "/tmp/app_proxy.err"
      env:
        LOG_PATH: /robot/persist/log/app_proxy

    "housekeeper":
      path: "/robot/software/housekeeper/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/housekeeper.log"
      stderr: "/tmp/housekeeper.err"
      env:
        LOG_PATH: /robot/persist/log/housekeeper

    "task_engine":
      path: "/robot/software/task_engine/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/task_engine.log"
      stderr: "/tmp/task_engine.err"
      env:
        LOG_PATH: /robot/persist/log/task_engine

    "display_ui":
      path: "/robot/software/display_ui/em_run.sh"
      sudo: false
      # stdout: "/tmp/display_ui.log"
      stderr: "/tmp/display_ui.err"
      restart:
        max_retries: 500
      env:
        LOG_PATH: /robot/persist/log/display_ui

    "sm":
      path: "/robot/software/sm/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/sm.log"
      stderr: "/tmp/sm.err"
      restart:
        max_retries: 5
      env:
        LOG_PATH: /robot/persist/log/sm

    "hds":
      path: "/robot/software/hds/bin/em_run.sh"
      sudo: false
      args: ["hds"] #
      # stdout: "/tmp/hds.log"
      stderr: "/tmp/hds.err"
      env:
        LOG_PATH: /robot/persist/log/hds

    "sys_guard":
      path: "/robot/software/sys_guard/bin/start_sys_guard.sh"
      sudo: true
      # stdout: "/tmp/sys_guard.log"
      stderr: "/tmp/sys_guard.err"
      env:
        LOG_PATH: /robot/persist/log/sys_guard

    "cloud_proxy":
      path: "/robot/software/cloud_proxy/bin/em_run.sh"
      sudo: true
      # stdout: "/tmp/cloud_proxy.log"
      stderr: "/tmp/cloud_proxy.err"
      env:
        LOG_PATH: /robot/persist/log/cloud_proxy

    "data_exporter":
      path: "/robot/software/data_exporter/bin/em_run.sh"
      sudo: true
      # stdout: "/tmp/data_exporter.log"
      stderr: "/tmp/data_exporter.err"
      env:
        LOG_PATH: /robot/persist/log/data_exporter


    "ota":
      path: "/robot/software/ota/bin/em_run.sh"
      sudo: true
      # stdout: "/tmp/ota.log"
      stderr: "/tmp/ota.err"
      env:
        LOG_PATH: /robot/persist/log/ota


    "poweroff":
      oneshot: true
      path: "/robot/software/entry/cfg/pm/poweroff.sh"
      sudo: true
      # stdout: "/tmp/poweroff.log"
      stderr: "/tmp/poweroff.err"
      env:
        LOG_PATH: /robot/persist/log/poweroff

    "insta360":
      path: "/robot/software/insta360/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/insta360.log"
      stderr: "/tmp/insta360.err"
      env:
        LOG_PATH: /robot/persist/log/insta360

    "connx":
      path: "/robot/software/connx/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/connx.log"
      stderr: "/tmp/connx.err"
      env:
        LOG_PATH: /robot/persist/log/connx

    "resource_manager":
      path: "/robot/software/resource_manager/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/resource_manager.log"
      stderr: "/tmp/resource_manager.err"
      env:
        LOG_PATH: /robot/persist/log/resource_manager

    "conduit_router":
      path: "/robot/software/conduit_router/bin/em_run.sh"
      sudo: true
      # stdout: "/tmp/conduit_router.log"
      stderr: "/tmp/conduit_router.err"
      env:
        LOG_PATH: /robot/persist/log/conduit_router

    "abox":
      path: "/robot/software/abox/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/abox.log"
      stderr: "/tmp/abox.err"
      env:
        LOG_PATH: /robot/persist/log/abox

    "lumina":
      path: "/robot/software/lumina/em_run.sh"
      sudo: false
      # stdout: "/tmp/lumina.log"
      stderr: "/tmp/lumina.err"
      env:
        LOG_PATH: /robot/persist/log/lumina

    "scene_engine":
      path: "/robot/software/scene_engine/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/scene_engine.log"
      stderr: "/tmp/scene_engine.err"
      env:
        LOG_PATH: /robot/persist/log/scene_engine

    "nova_agent":
      path: "/robot/software/nova_agent/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/nova_agent.log"
      stderr: "/tmp/nova_agent.err"
      env:
        LOG_PATH: /robot/persist/log/nova_agent
```


---

## FILE: raw/t1/hardware/process_soc1.yaml

- bytes: 12260

```yaml
worker_info:
  aima_req_worker:
    thread_num: 2
    listen_ip: ${HTTP_LISTEN_IP}
    listen_port: 50080

  node_control_worker:
    thread_num: 1
    master_node: true
    listen_ip: ${HTTP_LISTEN_IP}
    listen_port: 56999

process_manager:
  work_dir: "/robot/sys/proc"
  env_file: "/robot/software/process_manager/bin/cfg/env"
  agi_user_uid: 1000
  agi_user_gid: 1000
  sudo_preserve_env: "PYTHONPATH"
  startup_stages:
    - apps: [
        "sys_guard",
        # 传感器
        # "device_manager",
        # "hal_audio",
        "hal_rgbd",
        "hal_camera",
        "hal_sensor",

        # 系统状态监控
        # "sm",
        # "hds",

        # 用户感知应用
        # "display_ui",
      ]
      delay_after_ms: 1500
    - apps: [
        # 用户感知应用
        # "task_engine",
        # "housekeeper",
        # "mc",
        # "app_proxy",
        # "rc",

        # 云端代理
        # "cloud_proxy",
        # 数据导出
        "data_exporter",

        # 交互应用
        # "agent",
        # "rtsp_server",

        # 数据录制
        # "drp",

        # ota
        "ota",

        # 跟随算法节点
        "coreon_fusion",
        # "odom",
        # "move_camera",
        "follow",
        # "face",
        "path_follow",
        "tracking",
        # "yolov8",

        # 亮度检测模块
        "brightness_detection",

        # "insta360",
        # "resource_manager",
        # "conduit_router"

        # 导航算法模块
        "navigation",
        # "recharge",

        # slam算法节点
        # "slam",

        # "aprilgrid_loc",

        # 地图管理节点
        # "map_manager",

        # 感知独立模块
        "percep"
      ]
      delay_after_ms: 8000
    # - apps: [
    #     "hal_rgbd",
    #     "hal_camera",
    #     "hal_sensor",
    #   ]
    #   delay_after_ms: 18000

  apps:
    "hal_camera":
      path: "/robot/software/hal_camera/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/hal_camera.log"
      stderr: "/tmp/hal_camera.err"
      env:
        LOG_PATH: /robot/persist/log/hal_camera
        FASTRTPS_DEFAULT_PROFILES_FILE: /robot/software/entry/cfg/standard/ros_dds_configuration_all.xml
    "hal_rgbd":
      path: "/robot/software/hal_rgbd/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/hal_rgbd.log"
      stderr: "/tmp/hal_rgbd.err"
      env:
        LOG_PATH: /robot/persist/log/hal_rgbd
        FASTRTPS_DEFAULT_PROFILES_FILE: ${DDS_CFG_PREFIX}/ros_dds_configuration_all.xml
    "coreon_fusion":
      path: "/robot/software/coreon_fusion/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/core.log"
      stderr: "/tmp/coreon_fusion.err"
      env:
        LOG_PATH: /robot/persist/log/coreon_fusion
        FASTRTPS_DEFAULT_PROFILES_FILE: ${DDS_CFG_PREFIX}/ros_dds_configuration_all.xml

    "face": # 人脸识别节点
      path: "/robot/software/algorithm/face/bin/start_face"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/face.log"
      stderr: "/tmp/face.err"
      env:
        LOG_PATH: /robot/persist/log/face

    "tracking":
      path: "/robot/software/algorithm/target_follow_perception/bin/start_target_follow_perception_T"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/track.log"
      stderr: "/tmp/track.err"
      env:
        LOG_PATH: /robot/persist/log/tracking

    "yolov8":
      path: "/robot/software/algorithm/yolov8_detection/bin/start_yolov8"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/yolo.log"
      stderr: "/tmp/yolo.err"
      env:
        LOG_PATH: /robot/persist/log/yolo

    "follow":
      path: "/robot/software/algorithm/follow/bin/start_follow.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/follow.log"
      stderr: "/tmp/follow.err"
      env:
        LOG_PATH: /robot/persist/log/follow
  
    "brightness_detection":
      path: "/robot/software/algorithm/brightness_detection/bin/start_brightness_status_T"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/brightness_detection.log"
      stderr: "/tmp/brightness_detection.err"
      env:
        LOG_PATH: /robot/persist/log/brightness_detection

    "navigation":
      path: "/robot/software/algorithm/nav2_bringup/bin/start_nav"
      sudo: false
      stderr: "/tmp/navigation.err"
      env:
        LOG_PATH: /robot/persist/log/navigation

    "recharge":
      path: "/robot/software/algorithm/nav2_recharge/share/nav2_recharge/scripts/em_run.sh"
      sudo: false
      stderr: "/tmp/recharge.err"
      env:
        LOG_PATH: /robot/persist/log/recharge
    
    "slam":
      path: "/robot/software/aimrt_slam/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/slam.log"
      stderr: "/tmp/slam.err"
      env:
        LOG_PATH: /robot/persist/log/slam
        
    "aprilgrid_loc":
      path: "/robot/software/aprilgrid_loc/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/aprilgrid_loc.log"
      stderr: "/tmp/aprilgrid_loc.err"
      env:
        LOG_PATH: /robot/persist/log/aprilgrid_loc

    

    "percep":
      path: "/robot/software/algorithm/perception/bin/start_percep.sh"
      sudo: false
      stderr: ""
      env:
          LOG_PATH: /robot/persist/log/percep

    "path_follow":
      path: "/robot/software/algorithm/path_follow_node/bin/em_run.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/path_follow.log"
      stderr: "/tmp/path_follow.err"
      env:
        LOG_PATH: /robot/persist/log/path_follow

    "odom":
      path: "/robot/software/algorithm/odom/bin/start_odom"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/odom.log"
      stderr: "/tmp/odom.err"
      env:
        LOG_PATH: /robot/persist/log/odom

    "move_camera":
      path: "/robot/software/algorithm/move_camera/bin/start_move_camera"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/move_camera.log"
      stderr: "/tmp/move_camera.err"
      env:
        LOG_PATH: /robot/persist/log/move_camera

    "hal_sensor":
      path: "/robot/software/hal_sensor/bin/em_run.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/hal_sensor.log"
      stderr: "/tmp/hal_sensor.err"
      env:
        LOG_PATH: /robot/persist/log/hal_sensor

    "device_manager":
      path: "/robot/software/device_manager/bin/em_run.sh"
      sudo: false # run the app with sudo, otherwise run with agi_user and agi_group configured in process_manager
      # stdout: "/tmp/device_manager.log"
      stderr: "/tmp/device_manager.err"
      env:
        LOG_PATH: /robot/persist/log/device_manager

    "hal_imu":
      path: "/robot/software/hal_imu/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/hal_imu.log"
      stderr: "/tmp/hal_imu.err"
      env:
        LOG_PATH: /robot/persist/log/hal_imu

    "drp":
      path: "/robot/software/drp/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/drp.log"
      stderr: "/tmp/drp.err"
      env:
        LOG_PATH: /robot/persist/log/drp

    "rc":
      path: "/robot/software/rc/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/rc.log"
      stderr: "/tmp/rc.err"
      env:
        LOG_PATH: /robot/persist/log/rc

    "mc":
      path: "/robot/software/mc/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/mc.log"
      stderr: "/tmp/mc.err"
      env:
        LOG_PATH: /robot/persist/log/mc

    "agent":
      path: "/robot/software/aimrt_agent/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/agent.log"
      stderr: "/tmp/agent.err"
      restart:
        max_retries: 500
      env:
        LOG_PATH: /robot/persist/log/agent
        FASTRTPS_DEFAULT_PROFILES_FILE: ${DDS_CFG_PREFIX}/ros_dds_configuration_all.xml

    "hal_audio":
      path: "/robot/software/hal_audio/bin/em_run.sh"
      sudo: false
      #  stdout: "/tmp/hal_audio.log"
      stderr: "/tmp/hal_audio.err"
      env:
        LOG_PATH: /robot/persist/log/hal_audio

    "rtsp_server":
      path: "/robot/software/rtsp_server/em_run.sh"
      sudo: false
      # stdout: "/tmp/rtsp_server.log"
      stderr: "/tmp/rtsp_server.err"
      env:
        LOG_PATH: /robot/persist/log/rtsp_server

    "app_proxy":
      path: "/robot/software/app_proxy/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/app_proxy.log"
      stderr: "/tmp/app_proxy.err"
      env:
        LOG_PATH: /robot/persist/log/app_proxy

    "housekeeper":
      path: "/robot/software/housekeeper/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/housekeeper.log"
      stderr: "/tmp/housekeeper.err"
      env:
        LOG_PATH: /robot/persist/log/housekeeper

    "task_engine":
      path: "/robot/software/task_engine/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/task_engine.log"
      stderr: "/tmp/task_engine.err"
      env:
        LOG_PATH: /robot/persist/log/task_engine

    "display_ui":
      path: "/robot/software/display_ui/em_run.sh"
      sudo: false
      # stdout: "/tmp/display_ui.log"
      stderr: "/tmp/display_ui.err"
      restart:
        max_retries: 500
      env:
        LOG_PATH: /robot/persist/log/display_ui

    "sm":
      path: "/robot/software/sm/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/sm.log"
      stderr: "/tmp/sm.err"
      restart:
        max_retries: 5
      env:
        LOG_PATH: /robot/persist/log/sm

    "hds":
      path: "/robot/software/hds/bin/em_run.sh"
      sudo: false
      args: ["hds"] #
      # stdout: "/tmp/hds.log"
      stderr: "/tmp/hds.err"
      env:
        LOG_PATH: /robot/persist/log/hds

    "sys_guard":
      path: "/robot/software/sys_guard/bin/start_sys_guard.sh"
      sudo: true
      # stdout: "/tmp/sys_guard.log"
      stderr: "/tmp/sys_guard.err"
      env:
        LOG_PATH: /robot/persist/log/sys_guard

    "cloud_proxy":
      path: "/robot/software/cloud_proxy/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/cloud_proxy.log"
      stderr: "/tmp/cloud_proxy.err"
      env:
        LOG_PATH: /robot/persist/log/cloud_proxy

    "data_exporter":
      path: "/robot/software/data_exporter/bin/em_run.sh"
      sudo: true
      # stdout: "/tmp/data_exporter.log"
      stderr: "/tmp/data_exporter.err"
      env:
        LOG_PATH: /robot/persist/log/data_exporter


    "ota":
      path: "/robot/software/ota/bin/em_run.sh"
      sudo: true
      # stdout: "/tmp/ota.log"
      stderr: "/tmp/ota.err"
      env:
        LOG_PATH: /robot/persist/log/ota


    "poweroff":
      oneshot: true
      path: "/robot/software/entry/cfg/pm/poweroff.sh"
      sudo: true
      # stdout: "/tmp/poweroff.log"
      stderr: "/tmp/poweroff.err"
      env:
        LOG_PATH: /robot/persist/log/poweroff

    "insta360":
      path: "/robot/software/insta360/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/insta360.log"
      stderr: "/tmp/insta360.err"
      env:
        LOG_PATH: /robot/persist/log/insta360

    "resource_manager":
      path: "/robot/software/resource_manager/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/resource_manager.log"
      stderr: "/tmp/resource_manager.err"
      env:
        LOG_PATH: /robot/persist/log/resource_manager

    "conduit_router":
      path: "/robot/software/conduit_router/bin/em_run.sh"
      sudo: true
      # stdout: "/tmp/conduit_router.log"
      stderr: "/tmp/conduit_router.err"
      env:
        LOG_PATH: /robot/persist/log/conduit_router

    "map_manager":
      path: "/robot/software/map_manager/bin/em_run.sh"
      sudo: false
      # stdout: "/tmp/map_manager.log"
      stderr: "/tmp/map_manager.err"
      env:
        LOG_PATH: /robot/persist/log/map_manager
```


---

## FILE: raw/t1/hardware/system_entry.sh

- bytes: 1610

```bash
#!/bin/bash
set -e

# --------------------------------------------------------------------------------------------------------------
# 软件分区的开机自启动的入口脚本
# --------------------------------------------------------------------------------------------------------------

# 工作目录在 entry 下
cd "$(dirname "$0")"

# -------------------------------------------------------------
# 按字典序运行给定目录下的所有脚本
# -------------------------------------------------------------
execute_all_scripts() {
    dir=$1
    tmp="$(mktemp)"
    find "${dir}" -maxdepth 1 -type f -regex "${dir}/[0-9][0-9][0-9]-.*sh" | sort > "${tmp}"

    while IFS= read -r script_path; do
      echo "[RUN] ${script_path}"
      "${script_path}"
    done < "${tmp}"

    sync
}

# -------------------------------------------------------------
# 执行特定 boot 阶段的脚本，并设置 flag
# -------------------------------------------------------------
execute_boot_scripts() {
  name=$1

  # 该阶段的 flag
  flag="/robot/flag/software_${name}.flag"

  # 仅该 flag 不存在时，执行本阶段的脚本
  if [ ! -f "${flag}" ]; then
    execute_all_scripts "${name}"

    # 设置本阶段已经执行完毕的 flag
    touch "${flag}"
    sync "${flag}"
    echo "[FLAG] ${name} done."
  fi
}

# -------------------------------------------------------------
# 开始执行各个阶段的 boot 脚本
# -------------------------------------------------------------

execute_boot_scripts "first_boot"
execute_boot_scripts "data_reset_boot"
execute_all_scripts "every_boot"
```


---
