# Pack 02 · 动作图 / 执行组 / 安全 / 状态

重点：102→10/11→300 的准入路径、300 的出口、DAMPING 只能回 PASSIVE、`security_guard` 仍监控 300、`mc_T1` 的输入源。


===== FILE: raw/t1/qd1_t2d0/action_ruler.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/action_ruler.yaml) =====

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


===== FILE: raw/t1/qd1_t2d0/action_setting.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/action_setting.yaml) =====

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


===== FILE: raw/t1/qd1_t2d0/action_state.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/action_state.yaml) =====

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

===== FILE: raw/t1/qd1_t2d0/security_guard.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/security_guard.yaml) =====

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


===== FILE: raw/t1/qd1_t2d0/mc_T1.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/mc_T1.yaml) =====

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


===== FILE: raw/t1/qd1_t2d0/robot_model.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/robot_model.yaml) =====

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


===== FILE: raw/t1/task_engine/action_manager.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/action_manager.yaml) =====

version: 1

# policies[running_category][incoming_category]: parallel | override | reject
# 技能类别仲裁：按 running / incoming 的 TaskCategory 匹配。
#
# policies.<group>.task_types[incoming_task_type]: parallel | override | reject
# TaskType 细粒度仲裁：running 任务类型由 group 决定
#   - follow：FollowTask 运行中
#   - SelfCheckTask：低电保护 / 摔倒阻尼 / 关机等运行中

default: parallel

all_parallel: &all_parallel
  motion: parallel
  audio: parallel
  emoticon: parallel
  light: parallel

all_reject: &all_reject
  motion: reject
  audio: reject
  emoticon: reject
  light: reject

# define in: https://primebot.feishu.cn/wiki/BoaYwCRG8ihSsgksnTmcSlfvnNd
policies:
  touch:
    motion: override
    follow: override
    touch: reject
    idle: reject

  motion:
    motion: override
    follow: override
    touch: reject
    idle: reject

  follow:
    motion: reject
    follow: override
    touch: reject
    idle: reject
    audio: parallel
    task_types:
      AnimationTask: reject  # 允许的动作见 follow_context_gate（模式并行 / 姿态取消跟随）
      PlayCustomMotionTask: reject
      RecordTask: reject
      ArrangeTask: reject
      AgentFlowTask: reject
      TouchTask: reject
      IdleTask: reject
      InteractionTask: reject
      RcTask: override
      MoveTask: parallel
      SelfCheckTask: override
      PostProcessTask: override
      SpeechTask: parallel

  SelfCheckTask:
    task_types:
      FollowTask: reject
      NavigationTask: reject
      ChargePointSitTask: reject
      TouchTask: reject
      IdleTask: reject
      SelfCheckTask: reject  # 同类任务正在执行时拒绝新来的，由上层重试
      AgentFlowTask: reject

  PostProcessTask:
    task_types:
      AnimationTask: reject

  RecordTask:
    task_types:
      FollowTask: reject
      NavigationTask: reject
      ChargePointSitTask: reject
      AgentFlowTask: reject

  PlayCustomMotionTask:
    task_types:
      FollowTask: reject
      NavigationTask: reject
      ChargePointSitTask: reject
      AgentFlowTask: reject

  ArrangeTask:
    task_types:
      AgentFlowTask: reject

  RcTask:
    task_types:
      AgentFlowTask: reject

  SceneTask:
    task_types:
      FollowTask: reject
      NavigationTask: reject
      ChargePointSitTask: reject
      RcTask: reject
      RecordTask: reject
      PlayCustomMotionTask: reject
      ArrangeTask: reject
      AgentFlowTask: reject
      MoveTask: reject
      AnimationTask: reject
      TouchTask: reject
      IdleTask: reject
      InteractionTask: reject
      SpeechTask: reject
      SetModeTask: reject
      GyroCtrlTask: reject
      PostProcessTask: reject
      McCommonTask: reject
      OrbitShotTask: reject
      HitchcockTask: reject
      GroupPhotoTask: reject
      MapLocalizationTask: reject
      ChargePointSetupTask: reject
      TextTask: reject
      PhotoTask: reject
      LowBatteryTask: reject
      PowerSaveTask: reject
      EmotionTask: reject
      LightTask: reject
      TimeTask: reject

  AgentFlowTask:
    task_types:
      FollowTask: reject
      NavigationTask: reject
      ChargePointSitTask: reject
      RcTask: reject
      RecordTask: reject
      PlayCustomMotionTask: reject
      ArrangeTask: reject
      SelfCheckTask: override
      MoveTask: override
      AnimationTask: override
      AgentFlowTask: reject

  idle:
    motion: override
    follow: override
    touch: override
    idle: override


===== FILE: raw/t1/task_engine/task_rules.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/task_rules.yaml) =====

# TaskEngine 任务规则配置文件
# allow_source: AmSourceType 白名单，直接填写协议枚举名；[] 表示不校验来源
# allow_posture: McAction 白名单，直接填写枚举名；[] 表示不校验 McAction
# block_posture: McAction 黑名单；非空时当前姿态命中则拒绝进入该任务
# allow_velocity_source: 速度来源白名单(McLocomotionVelocity.source)；[] 表示不校验。
#   当机器人正按速度移动(is_moving_by_velocity)且当前速度来源不在白名单内时拒绝该任务，
#   用于防止与 APP 摇杆/遥控等外部控制器争抢运动控制。
# velocity_source_block_robots: 上述速度来源排除仅对列表内机型生效(如 [Q1])；[] 表示对所有机型生效。
# function_name_aliases: 可选，AmRequest.function_name 额外别名，均归一到 task_base.task_name。
#   YAML task_list 节名（如 task_follow）若与 task_name 不同，加载时自动注册为别名。
task_list:
  # 1. 恢复出厂设置（APP 主触发，系统兜底）
  # 真实操作会关机/重启，必须在零力矩、趴着、躺着等安全姿态触发；告警不拦截。
  task_factory_reset:
    task_base:
      enable: true
      task_name: factory_reset
      task_type: short_task
      real_task_type: ""           # 仅仲裁，无对应 WorkerManager 任务
      priority: 90
      permission_level: normal
      allow_preempt: false
      timing_cycle_ms: 0
      need_confirm: false
    allow_source:
      - SOURCE_SYSTEM
      - SOURCE_APP
    precondition:
      allow_posture: [PASSIVE_DEFAULT, DAMPING_DEFAULT, QUADRUPED_GET_DOWN_DEFAULT, LIE_FACE_DOWN, LIE_FACE_UP, LYING_DEFAULT, STORE_DEFAULT]
      battery_min_percent: 20
      allow_charging_state: true
      check_app_conn: false
      check_cloud_conn: false
      check_network: true
      check_log_sync: true
    alarm_condition:
      allow_mode: all
      allow_levels: []
      exclude_levels: []
    motion_condition:
      allow_motion_state: [idle, preemptable]
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [follow]
      block_op_list: [all]

  # 2. APP 摇杆控制（实时速度信号）
  # 摇杆为高频实时指令：仅校验电量，不记录运行态（track_running_state=false）。
  # HDS 告警 1/2/3 级时拦截（1 最严重；fatal=level1, error=level2, warn=level3）；4/5 级放行。
  task_app_joystick_ctrl:
    task_base:
      enable: true
      task_name: app_joystick_ctrl
      task_type: realtime_task
      real_task_type: RcTask
      priority: 50
      permission_level: normal
      allow_preempt: true
      track_running_state: false
      timing_cycle_ms: 0
      need_confirm: false
    allow_source:
      - SOURCE_APP
    precondition:
      allow_posture: []
      battery_min_percent: 1
      allow_charging_state: false
      check_app_conn: false
      check_cloud_conn: false
      check_network: false
    alarm_condition:
      allow_mode: exclude
      allow_levels: []
      exclude_levels: [fatal]
    motion_condition:
      allow_motion_state: []
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: []
      block_op_list: []

  # 3. APP 陀螺仪控制（长时运动任务）
  # 电量>30%、不可充电中，MC Action 必须四足站立
  task_app_gyro_ctrl:
    task_base:
      enable: true
      task_name: app_gyro_ctrl
      task_type: long_task
      real_task_type: RcTask
      priority: 50
      permission_level: normal
      allow_preempt: true
      timing_cycle_ms: 0
      need_confirm: false
    allow_source:
      - SOURCE_APP
    precondition:
      allow_posture: [QUADRUPED_STAND_DEFAULT, QUADRUPED_LOCOMOTION_DEFAULT, QUADRUPED_LOCOMOTION_BIONIC, QUADRUPED_LOCOMOTION_TERRAIN,QUADRUPED_LOCOMOTION_RUN]
      battery_min_percent: 5
      allow_charging_state: false
      check_app_conn: true
      check_cloud_conn: false
      check_network: true
    alarm_condition:
      allow_mode: exclude
      allow_levels: []
      exclude_levels: [fatal, error]
    motion_condition:
      allow_motion_state: [idle, preemptable]
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [app_joystick_ctrl, app_teach_demo, follow]
      block_op_list: [all]

  # 4. APP 动作录制（长时任务，由 RecordMotion Service 注册运行态）
  task_motion_record:
    task_base:
      enable: true
      task_name: motion_record
      task_type: long_task
      real_task_type: RecordTask
      priority: 60
      permission_level: normal
      allow_preempt: false
      timing_cycle_ms: 0
      need_confirm: false
    allow_source: []
    precondition:
      allow_posture: [BIPED_STAND_DEFAULT, BIPED_WHOLE_BODY_CTRL, BIPED_LOCOMOTION_WBC, BIPED_RECORD_UPPER]
      battery_min_percent: 25
      allow_charging_state: false
      check_app_conn: false
      check_cloud_conn: false
      check_network: false
    alarm_condition:
      allow_mode: none
      allow_levels: []
      exclude_levels: []
    motion_condition:
      allow_motion_state: []
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [follow]
      block_op_list: [all]

  # 5. APP 自定义动作回放（长时任务，由 PlayCustomMotion Service 注册运行态）
  task_motion_playback:
    task_base:
      enable: true
      task_name: motion_playback
      task_type: long_task
      real_task_type: PlayCustomMotionTask
      priority: 60
      permission_level: normal
      allow_preempt: false
      timing_cycle_ms: 0
      need_confirm: false
    allow_source: []
    precondition:
      allow_posture: [BIPED_STAND_DEFAULT, BIPED_WHOLE_BODY_CTRL, BIPED_LOCOMOTION_WBC]
      battery_min_percent: 25
      allow_charging_state: false
      check_app_conn: false
      check_cloud_conn: false
      check_network: false
    alarm_condition:
      allow_mode: none
      allow_levels: []
      exclude_levels: []
    motion_condition:
      allow_motion_state: []
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [follow]
      block_op_list: [all]

  # 6. APP 动作示教（独占任务）
  # 动作示教/录制/回放要求双足站立或双足示教控制模式
  task_app_teach_demo:
    task_base:
      enable: false
      task_name: app_teach_demo
      task_type: long_task
      real_task_type: ArrangeTask
      priority: 50
      permission_level: normal
      allow_preempt: true
      timing_cycle_ms: 0
      need_confirm: false
    allow_source:
      - SOURCE_APP
    precondition:
      allow_posture: [BIPED_STAND_DEFAULT, BIPED_WHOLE_BODY_CTRL, BIPED_LOCOMOTION_WBC, BIPED_RECORD_UPPER]
      battery_min_percent: 25
      allow_charging_state: false
      check_app_conn: true
      check_cloud_conn: false
      check_network: true
    alarm_condition:
      allow_mode: none
      allow_levels: []
      exclude_levels: []
    motion_condition:
      allow_motion_state: []
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [app_joystick_ctrl, app_gyro_ctrl, follow]
      block_op_list: [all]

  # 7. 通用移动任务（供 AmRequest function_name=move 使用）
  # AmRequest 仅用于查询当前是否允许移动，不记录 Running 运行态；实际移动由 PlayMove 派发。
  task_move:
    task_base:
      enable: true
      task_name: move
      task_type: short_task
      real_task_type: MoveTask
      priority: 70
      permission_level: normal
      allow_preempt: false
      track_running_state: false
      timing_cycle_ms: 0
      need_confirm: false
    allow_source: []
    # 速度来源白名单：机器人正按速度移动且来源不在白名单内(如 APP 摇杆/遥控占用运控)时拒绝本任务；[] 表示不校验。
    allow_velocity_source: [interaction, task_engine]
    # 上述速度来源排除仅对列表内机型生效(如 [Q1] 拦截、T1 不拦截)；[] 表示对所有机型生效。
    velocity_source_block_robots: [Q1]
    precondition:
      allow_posture: []
      # 以下姿态不允许移动（PlayMove / AmRequest move 共用）
      block_posture:
        - DAMPING_DEFAULT
        - LYING_DEFAULT
        - LIE_FACE_UP
        - LIE_FACE_DOWN
        - STORE_DEFAULT
      battery_min_percent: 1
      allow_charging_state: false
      check_app_conn: false
      check_cloud_conn: false
      check_network: false
    alarm_condition:
      allow_mode: exclude
      allow_levels: []
      exclude_levels: [fatal]
    motion_condition:
      allow_motion_state: [idle, preemptable, running]
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [app_joystick_ctrl, app_gyro_ctrl, app_teach_demo, motion_record, motion_playback, app_canvas]
      block_op_list: []

  # 8. 跟随任务（AmRequest 仅前置检查；运行态由 FollowTaskCtrl / ControlTask / FollowTask 注册）
  task_follow:
    function_name_aliases: [follow_task]
    task_base:
      enable: true
      task_name: follow
      task_type: long_task
      real_task_type: FollowTask
      priority: 50
      permission_level: normal
      allow_preempt: false
      track_running_state: false
      timing_cycle_ms: 0
      need_confirm: false
    allow_source: []
    precondition:
      allow_posture: []
      battery_min_percent: 5
      allow_charging_state: false
      check_app_conn: false
      check_cloud_conn: false
      check_network: false
    alarm_condition:
      allow_mode: none
      allow_levels: []
      exclude_levels: []
    motion_condition:
      allow_motion_state: []
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [app_gyro_ctrl, motion_record, motion_playback]
      block_op_list: []
  
  # 9. 图形化编程任务
  # AmRequest 仅前置仲裁，不记录运行态；运行态由 AgentFlowTaskCtrl 启停时注册。
  # 阻尼状态 / 运动中禁止进入；运行中与 move 等任务互斥（block_op_list=all）
  task_app_canvas:
    task_base:
      enable: true
      task_name: app_canvas
      task_type: long_task
      real_task_type: AgentFlowTask
      priority: 50
      permission_level: normal
      allow_preempt: true
      track_running_state: false
      timing_cycle_ms: 0
      need_confirm: false
    allow_source:
      - SOURCE_APP
    precondition:
      allow_posture: []
      block_posture: [DAMPING_DEFAULT]
      battery_min_percent: 30
      allow_charging_state: false
      check_app_conn: true
      check_cloud_conn: false
      check_network: true
    alarm_condition:
      allow_mode: exclude
      allow_levels: []
      exclude_levels: [fatal]
    motion_condition:
      allow_motion_state: [idle, preemptable]
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [follow]
      block_op_list: [all]

  # 10. APP 设置专座任务（长时搜索 + 保存导航点）
  # 启动前复用 TaskRule 前置校验；运行态由 ChargePointTaskServicePlugin 控制。
  task_charge_point_setup:
    task_base:
      enable: true
      task_name: charge_point_setup
      task_type: long_task
      real_task_type: ""
      priority: 50
      permission_level: normal
      allow_preempt: false
      track_running_state: true
      timing_cycle_ms: 0
      need_confirm: false
    allow_source:
      - SOURCE_APP
    precondition:
      allow_posture: []
      block_posture:
        - DAMPING_DEFAULT
        - LYING_DEFAULT
        - LIE_FACE_UP
        - LIE_FACE_DOWN
        - STORE_DEFAULT
      battery_min_percent: 5
      allow_charging_state: false
      check_app_conn: true
      check_cloud_conn: false
      check_network: false
    alarm_condition:
      allow_mode: exclude
      allow_levels: []
      exclude_levels: [fatal, error]
    motion_condition:
      allow_motion_state: [idle, preemptable]
      allow_preempt_running_task: false
    mutex_block:
      mutex_task_list: [app_joystick_ctrl, app_gyro_ctrl, follow, motion_record, motion_playback, app_canvas]
      block_op_list: []


===== FILE: raw/t1/task_engine/actions_transfer.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/t1/actions_transfer.yaml) =====

# T1 McAction 转换图（有向图）
# 描述从当前 McAction 状态跳转到目标状态时所需的直接转换关系。
#
# 字段说明：
#   from:     当前所处的 McAction 名称
#   to:       需要切换到的目标 McAction 名称
#   form:     适用的机器人形态（biped / quadruped）
#   delay_ms: 切换完成后需等待的毫秒数（0 = 不等待）
#   note:     触发场景说明
#
# 来源：src/task_description/t1_animation_task_description.cpp

transfers:

  # ─────────────────────────────────────────────
  # 双足（Biped）转换
  # ─────────────────────────────────────────────

  # 行走/运动模式 → WBC（播放上肢 motion_id 动作前）
  - from: "BIPED_LOCOMOTION_DEFAULT"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 150
    note: "非 WBC 行走模式下播放上肢动作，需先切换到 WBC"

  - from: "BIPED_LOCOMOTION_TERRAIN"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 150
    note: "地形行走模式下播放上肢动作，需先切换到 WBC"

  - from: "BIPED_LOCOMOTION_RUN"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 150
    note: "跑步模式下播放上肢动作，需先切换到 WBC"

  - from: "BIPED_MIMIC"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 150
    note: "MIMIC 动作模式下复位到双足默认姿态，需先切换到 WBC"

  - from: "QUADRUPED_TO_BIPED"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 150
    note: "变形到双足后尚未稳定，需先切换到 WBC"

  - from: "QUADRUPED_TO_BIPED_ROTATE"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 150
    note: "旋转变形到双足后尚未稳定，需先切换到 WBC"

  # WBC / ANIMATION / RUN 三者可直接相互切换（无需等待）
  - from: "BIPED_LOCOMOTION_WBC"
    to: "BIPED_LOCOMOTION_ANIMATION"
    form: biped
    delay_ms: 50
    note: "WBC → ANIMATION（播放全身动画动作）"

  - from: "BIPED_LOCOMOTION_ANIMATION"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 50
    note: "ANIMATION → WBC（动画结束后切回上肢 WBC 模式）"

  - from: "BIPED_LOCOMOTION_RUN"
    to: "BIPED_LOCOMOTION_DEFAULT"
    form: biped
    delay_ms: 0
    note: "RUN → DEFAULT（切换户外/室内模式前先退出跑步模式）"

  - from: "BIPED_LOCOMOTION_RUN"
    to: "BIPED_LOCOMOTION_ANIMATION"
    form: biped
    delay_ms: 50
    note: "RUN → ANIMATION（跑步模式下直接切换到动画模式）"

  - from: "BIPED_LOCOMOTION_ANIMATION"
    to: "BIPED_LOCOMOTION_RUN"
    form: biped
    delay_ms: 50
    note: "ANIMATION → RUN"

  # WBC → 太空步 / 退出太空步
  - from: "BIPED_LOCOMOTION_WBC"
    to: "BIPED_LOCOMOTION_MOONWALK"
    form: biped
    delay_ms: 0
    note: "kMoonwalk：从 WBC 进入太空步模式"

  - from: "BIPED_LOCOMOTION_MOONWALK"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 0
    note: "kExitMoonwalk：退出太空步，返回 WBC"

  # WBC → 变形（双足→四足）
  - from: "BIPED_LOCOMOTION_WBC"
    to: "BIPED_TO_QUADRUPED"
    form: biped
    delay_ms: 0
    note: "kEasyTransformate 双足形态：WBC → 简易变形到四足"

  - from: "BIPED_LOCOMOTION_WBC"
    to: "BIPED_TO_QUADRUPED_ROTATE"
    form: biped
    delay_ms: 0
    note: "kTransformateRotate 双足形态：WBC → 旋转变形到四足"

  # MODE_CARRY 双足：WBC → 变形 → STORE
  - from: "BIPED_LOCOMOTION_WBC"
    to: "BIPED_TO_QUADRUPED_ROTATE"
    form: biped
    delay_ms: 0
    note: "MODE_CARRY 双足形态：先变形到四足再进入搬运姿态"

  - from: "BIPED_RECORD_UPPER"
    to: "BIPED_LOCOMOTION_WBC"
    form: biped
    delay_ms: 50
    note: "录制模式下直接切换到 WBC"

  # ─────────────────────────────────────────────
  # 四足（Quadruped）转换
  # ─────────────────────────────────────────────

  # 被动/阻尼状态起身：直接进入四足稳定站立
  # 注：STAND_UP(1007) 属 Q 系列站起动作，T1 四足下发会报 can not find action，
  #     T1 四足站起的正确目标即 QUADRUPED_STAND_DEFAULT(101)，从 PASSIVE 可直达。
  - from: "DAMPING_DEFAULT"
    to: "PASSIVE_DEFAULT"
    form: quadruped
    delay_ms: 100
    note: "阻尼状态先恢复到被动状态"

  - from: "DAMPING_DEFAULT"
    to: "QUADRUPED_GET_DOWN_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "kLieDown：阻尼状态下允许直接进入四足趴下"

  - from: "PASSIVE_DEFAULT"
    to: "QUADRUPED_GET_DOWN_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "kLieDown：被动状态下允许直接进入四足趴下"

  - from: "PASSIVE_DEFAULT"
    to: "QUADRUPED_RECOVERY"
    form: quadruped
    delay_ms: 0
    note: "kRecoverPosture：被动状态下直接触发四足恢复"

  - from: "PASSIVE_DEFAULT"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 1000
    note: "PASSIVE_DEFAULT 状态下直接进入四足站立锁定并等待稳定"

  # 快速运动模式 → DEFAULT（播放非行走动作前先降速）
  - from: "QUADRUPED_LOCOMOTION_RUN"
    to: "QUADRUPED_LOCOMOTION_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "快速奔跑时执行非行走动画，需先降速到 DEFAULT"

  # 模式切换：DEFAULT → RUN / TERRAIN（升挡）
  # 三种 locomotion gait 模式经由 DEFAULT 互切：
  #   MODE_INDOORS=DEFAULT / MODE_OUTDOORS=TERRAIN / MODE_SUPERPOWER=RUN
  # 补齐正向边后，RUN↔TERRAIN 可经 DEFAULT 中转（BFS 多跳）
  - from: "QUADRUPED_LOCOMOTION_DEFAULT"
    to: "QUADRUPED_LOCOMOTION_RUN"
    form: quadruped
    delay_ms: 0
    note: "MODE_SUPERPOWER：从默认行走切换到奔跑模式"

  - from: "QUADRUPED_LOCOMOTION_DEFAULT"
    to: "QUADRUPED_LOCOMOTION_TERRAIN"
    form: quadruped
    delay_ms: 0
    note: "MODE_OUTDOORS：从默认行走切换到地形模式"

  - from: "QUADRUPED_STAND_DEFAULT"
    to: "QUADRUPED_LOCOMOTION_JUMP"
    form: quadruped
    delay_ms: 0
    note: "向前跳动作：从四足默认行走模式切换到 JUMP"

  - from: "QUADRUPED_LOCOMOTION_TERRAIN"
    to: "QUADRUPED_LOCOMOTION_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "地形模式时执行非行走动画，需先切换到 DEFAULT"

  - from: "QUADRUPED_LOCOMOTION_DANCE"
    to: "QUADRUPED_LOCOMOTION_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "舞蹈模式执行复位/停止动作前，需先切换到 DEFAULT"

  - from: "QUADRUPED_LOCOMOTION_DANCE"
    to: "QUADRUPED_LOCOMOTION_RUN"
    form: quadruped
    delay_ms: 0
    note: "舞蹈模式执行复位/停止动作时，允许直接切换到 RUN"

  - from: "QUADRUPED_LOCOMOTION_DANCE"
    to: "QUADRUPED_LOCOMOTION_TERRAIN"
    form: quadruped
    delay_ms: 0
    note: "舞蹈模式执行复位/停止动作时，允许直接切换到 TERRAIN"

  # 任意非 STAND_DEFAULT 状态 → STAND_DEFAULT（播放全身 motion_name 前）
  - from: "QUADRUPED_LOCOMOTION_DEFAULT"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 100
    note: "播放全身预设动作（motion_name）前需进入站立锁定姿态"

  - from: "QUADRUPED_LOCOMOTION_RUN"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 100
    note: "播放全身预设动作前，经由 DEFAULT 降速后再进入 STAND_DEFAULT"

  - from: "QUADRUPED_LOCOMOTION_TERRAIN"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 100
    note: "播放全身预设动作前，经由 DEFAULT 降速后再进入 STAND_DEFAULT"

  - from: "QUADRUPED_LOCOMOTION_DANCE"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 100
    note: "舞蹈模式执行站立复位前，先退出舞蹈并进入 STAND_DEFAULT"

  # 低位/特殊状态 → STAND_DEFAULT（kProud/kJoy/kGreet/kRightHandshake/kLeftHandshake/kStretch 前）
  - from: "QUADRUPED_GET_DOWN_DEFAULT"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "趴下状态执行 Proud/Joy/Greet/Handshake/Stretch 前需先站起"

  - from: "QUADRUPED_SIT_DOWN_DEFAULT"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 800
    note: "坐下状态执行 Proud/Joy/Greet/Handshake/Stretch 前需先站起"

  - from: "STORE_DEFAULT"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "搬运/收纳状态执行 Proud/Joy/Greet/Handshake/Stretch 前需先站起"

  - from: "QUADRUPED_LOCOMOTION_HANDSHAKE"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "握手状态执行 Proud/Joy/Greet/Stretch 前需先退出握手姿态"

  # 坐姿起身：先进入 STAND_DEFAULT 稳定，再进入 DEFAULT
  - from: "QUADRUPED_STAND_DEFAULT"
    to: "QUADRUPED_LOCOMOTION_DEFAULT"
    form: quadruped
    delay_ms: 500
    note: "kStandUp：坐姿先切到站立锁定，稳定后再进入四足默认行走模式"

  # 变形：四足 → 双足
  - from: "QUADRUPED_LOCOMOTION_DEFAULT"
    to: "QUADRUPED_TO_BIPED"
    form: quadruped
    delay_ms: 0
    note: "kEasyTransformate 四足形态：DEFAULT → 简易变形到双足"

  - from: "QUADRUPED_MIMIC"
    to: "QUADRUPED_LOCOMOTION_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "QUADRUPED_MIMIC -> QUADRUPED_LOCOMOTION_DEFAULT: 退出 Mimic 模式，回到四足默认行走模式"

  - from: "QUADRUPED_MIMIC"
    to: "QUADRUPED_STAND_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "QUADRUPED_MIMIC -> QUADRUPED_STAND_DEFAULT: 退出 Mimic 模式，回到四足站立默认模式"

  - from: "QUADRUPED_STAND_DEFAULT"
    to: "BIPED_LOCOMOTION_WBC"
    form: quadruped
    delay_ms: 0
    note: "kStandUp：四足已处于 STAND_DEFAULT，触发变形到双足 WBC"

  # kStandUp 特殊：四足已在 STAND/DEFAULT 时触发变形到双足
  - from: "QUADRUPED_STAND_DEFAULT"
    to: "BIPED_LOCOMOTION_WBC"
    form: quadruped
    delay_ms: 0
    note: "kStandUp：四足已处于 STAND_DEFAULT，触发变形到双足 WBC"

  # kLieDown / MODE_CARRY 快速运动时先降速
  - from: "QUADRUPED_LOCOMOTION_RUN"
    to: "QUADRUPED_LOCOMOTION_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "kLieDown/MODE_CARRY：快速运动时先降速再趴下/搬运"

  # 俯卧撑结束后退出到默认行走
  - from: "QUADRUPED_PUSH_UP"
    to: "QUADRUPED_LOCOMOTION_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "俯卧撑动作结束/被打断后，恢复到四足默认行走模式"

  # 搬运模式：QUADRUPED 进入 STORE
  - from: "QUADRUPED_LOCOMOTION_DEFAULT"
    to: "STORE_DEFAULT"
    form: quadruped
    delay_ms: 0
    note: "MODE_CARRY 四足形态：进入搬运收纳姿态"


===== FILE: raw/t1/task_engine/t1_cfg.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/t1/t1_cfg.yaml) =====

# 低电量限制忽略配置

# 是否忽略低电量动作限制
# false: 保持现有逻辑，低电量时限制动作（默认）
# true: 忽略电量限制，允许所有动作执行
ignore_low_battery_limit: false

# 忽略电源关机行为
ignore_power_off_behavior: false

# 是否启用开箱流程
# true: 启用开箱流程（Q1 每次开机均按进度执行，T1 仅首次执行一次）
# false: 跳过开箱流程，直接走正常自检
enable_openbox_flow: false

# 是否启用闲时行为
# true: 启用闲时行为，带有动作执行
enable_idle_behavior: false

# 是否启用建图功能
enable_mapping_function: false

# 是否启用地图定位功能
enable_map_localization_function: false

# 是否启用普通导航功能
enable_navigation_function: false

# 是否启用设置专座功能
enable_charge_point_setup_function: false

# 是否启用专座回坐/自主回充功能（APP、闲时、低电量）
enable_charge_point_sit_function: false

# 闲时网络断开测试开关；true: 强制按无网络处理，false: 使用网络状态 topic 的真实状态
force_idle_network_disconnected: false

# T1 闲时行为分层触发周期（秒）
l1_idle_period: 900
l2_idle_period: 1800
l3_idle_period: 2400
l4_idle_period: 5400

# 用户停止闲时动作后，下一次闲时动作额外增加的冷却时间（秒）
stop_idle_cooldown_extension: 10
# 用户语音打断闲时输出后，等待停止指令的有效时间（毫秒）
idle_stop_command_timeout_ms: 3000

# 闲时层级 Shuffle Bag 权重（一轮内 L1:L2:L3:L4，各层至少出现 1 次）
l1_idle_weight: 4
l2_idle_weight: 3
l3_idle_weight: 2
l4_idle_weight: 1

# 支持 SM 待机/闲时低功耗的 SKU；匹配 ROBOT_SKU，空列表或缺省表示不支持。
sm_power_save_skus: ["T1-2X", "T1-3X"]

# SM 自动低功耗独立开关，仅 ROBOT_SKU 匹配上述列表时生效。
# 与上面的闲时行为 enable_power_save 独立；修改后重启 TaskEngine 生效。
standby_power_save_enabled: true
idle_power_save_enabled: true

# 有线充电时，双足仅允许待机，四足允许待机和闲时；其他充电仍要求已完成 0 力矩。
# false 恢复充电拦截。
charging_power_save_enabled: true

# SM 低功耗超时，单位：秒，必须大于 0。
# 待机：连续无运动。无语音交互。
standby_power_save_timeout_s: 180
# 闲时：连续无外部交互及用户语音；Idle 自身动作不重置计时。
idle_power_save_timeout_s: 480

# 从待机/闲时低功耗恢复 Ready 后，算法请求的共享等待时长（毫秒，必须大于 0）
power_save_algorithm_ready_delay_ms: 1000

# 等待 SM 恢复 Ready + IN_READY 的超时（毫秒，必须大于 0），不包含上面的出流等待。
power_save_sm_ready_timeout_ms: 30000

# SM 已接受恢复请求但进入 IN_FALLBACK 后，首次请求之外的重试次数；0 表示不重试。
power_save_sm_ready_max_retries: 3
# 上述恢复重试间隔，单位秒，必须大于 0。
power_save_sm_ready_retry_interval_seconds: 5

# 低功耗逻辑的 App 在线/重连判定超时，单位秒，必须大于 0。
# 超过此间隔再次收到心跳，允许开启新一轮恢复；持续心跳不解除失败锁存。
power_save_app_heartbeat_timeout_seconds: 5

# 算法启停 RPC 超时，单位：毫秒，必须大于 0。
power_save_algorithm_rpc_timeouts_ms:
  brightness: 2000
  charge_point: 2000
  navigation: 2000
  perception: 2000
  retry_interval: 1000  # 失败后重试间隔（毫秒，必须大于 0）
  max_retries: 2  # 首次请求之外的重试次数；0 表示不重试

# 是否使用新的动作引擎（T1MotionEngine）替代 T1AnimationTaskDescription
# true: 使用 src/engine/t1/t1_motion_engine（基于 cfg/t1/motions.yaml 配置驱动）
# false: 使用原有的 T1AnimationTaskDescription（代码硬编码逻辑）
use_motion_engine: true

# 是否使用移动引擎（T1MoveEngine）处理移动任务
# true: 使用 src/task/engine/t1/t1_move_engine
# false: 使用原有的 T1MoveTaskDescription（代码硬编码逻辑）
use_move_engine: false

# 移动判定模式
# false（默认）：使用 MC is_moving 判定移动，不订阅 /aima/mc/locomotion/velocity
# true：订阅速度 topic，基于 moving_velocity_threshold 等参数判定移动
use_velocity_for_moving_detection: false

# 基于速度判断机器人是否在移动的阈值（线/角/垂直速度任一分量绝对值超过此值视为有速度）
moving_velocity_threshold: 0.05

# Acquire：速度持续超过阈值多久（毫秒）后判定为「在移动」（建议 ≤ release，防起步抖动误触发）
moving_duration_ms: 300

# Release：距上次速度超阈值多久（毫秒）后清除移动态（建议 ≥ acquire，防松手/零速抖动/停发 topic 误清除）
# 同时覆盖：连续发零速、摇杆松开后停发速度消息两种停止场景
moving_release_duration_ms: 500

# 参与移动判定的速度来源白名单（msg.source）；非白名单来源的消息会被忽略
moving_velocity_sources:
  - rc
  - app_proxy

# 动作示教单次最大录制时长（秒），APP 通过 GetTaskInfo 获取后用于录制进度展示
motion_record_max_duration_sec: 300

# 握手/松手状态持续稳定多久后生效，单位毫秒；0 表示不做时间防抖
hold_hand_nlg_delay_ms: 1000

# 模式速度配置（用于发布 interaction_state.mode_speed）
mode_speed:
  t_quadruped:
    indoors: 0.7
    outdoors: 0.7
    superpower: 0.7
    fold: 0.7
  t_biped:
    indoors: 0.7
    outdoors: 0.7
    superpower: 0.7
    fold: 0.7

# 是否启用执行动作前开启障碍物检测（AmRequest 服务）
# true: 启用障碍物检测，机器人在执行动作时会检查周围环境，避免碰撞
# false: 禁用障碍物检测，机器人不检查周围环境，可能会碰撞（默认）
enable_check_obstacle: true

# 是否启用 InteractWithId 服务中的变形动作障碍物检测
# true: 启用避障检查，T1 执行变形动作前会检查周围环境
# false: 禁用避障检查（默认）
enable_app_check_obstacle: true

# 是否启用双足形态下执行 kLieDown（趴下）前的障碍物检测
# true: 双足形态执行趴下前检查周围空间
# false: 禁用（默认）
enable_lie_down_biped_obstacle_check: true

# 是否启用环境感知(室内外检测)自动切换模式
# true: 订阅 percep/detect/env, 检测到室内外变化时自动切模式并播报
# false: 禁用(默认)
enable_percep_env: true

# 是否启用室内禁止极限模式(仅室外允许进入超能模式)
# true: 室内检测非室外时拒绝切换超能模式并播报提示(默认)
# false: 不限制, 室内也可切换超能模式
enable_super_outdoor_only: true

# 是否启用四足站立状态下执行 kStandUp（变形站起）前的障碍物检测
# true: 四足行走/站立状态执行站起变形前检查周围空间
# false: 禁用（默认）
enable_stand_up_obstacle_check: true

# 双足→四足障碍物检查前是否伸臂；关闭时直接检查障碍物，默认关闭
enable_biped_to_quad_safety_motion: false

# 双足→四足障碍物检查时，等待 MC 上肢动作（3065 到位并保持 / 0 收回完成）的超时时间，单位毫秒，默认 5000ms
mc_safety_motion_timeout_ms: 10000

# 3065 伸手到位（MC PLAYING）后的保持时间，单位毫秒，默认 800ms
mc_safety_hold_ms: 800

# motion 0 收回后，player IDLE 再等待的稳定时间，避免变形打断未完成的收回，单位毫秒，默认 1000ms
mc_safety_reset_stable_ms: 1000

# 距离上一次对话结束的时间间隔阈值，单位毫秒，默认 1000ms
last_conversation_interval_threshold_ms: 1000

# 机器人处于 THINKING 状态超过该时间时，视为不在对话状态，单位毫秒，默认 10000ms (10s)
thinking_timeout_ms: 10000

# agent 持续处于 LISTENING + VOICE_ACTIVE（用户语音活跃）超过该时间时，视为 VAD 卡死，
# 允许进入/保持在闲时阶段，单位毫秒，默认 120000ms (2min)；<=0 禁用此机制
voice_active_stuck_timeout_ms: 120000

# 低电量阈值，单位百分比，低于该电量时会限制动作执行，当前主要针对闲时动作
low_battery_threshold: 15

# 是否启用双足形态插充电线时的语音播报
# true: 检测到双足+充电时循环播报 NLG 提示（默认）
# false: 禁用语音播报
enable_biped_charge_audio: true

# 是否启用 PMU huoer 信号对 T1 双足→四足变形动作的抑制
# true: pmu_state.huoer=1 时阻止双足→四足变形（默认 false）
# false: 忽略 huoer 信号，变形不受限制
enable_pmu_huoer_block: true

# map_manager 本地地图根目录，task_engine 用于拼接 /navi/load_map 的 map_path
map_manager_data_path: "/robot/data/keyinfo/MapManagerModule"


===== FILE: raw/t1/task_engine/t1_groups.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/t1/t1_groups.yaml) =====

#以低电量为例，以下是全部的字段，用到哪个字段就写哪个字段，不需要的字段不写
# - name: LOWBATTERY
#   id: 11
#   type: "meta"
#   emotion_ids: [230]
#   emotion_mod: 1 # 单次
#   led_strip_mode : 12
#   preset_motion_id: 0
#   motion_mod: 0 # 无
#   priority: 61 # 优先级
#   text: "电量低于25%了，我快关机了，快给我充电吧！"
#   text: ""
#   speak_mode: 0 # 播一次
#   speak_gap: 300 # 播报间隔, 仅循环播报时有效
#   description: "机器人25%低电量"

# 未定义状态
- name: UNDEFINED
  id: 1
  type: "meta"
  emotion_ids: [10]
  emotion_mod: 1 # 循环
  preset_motion_id: 0
  motion_mod: 0 # 无
  priority: 0 # 优先级
  text: ""
  speak_mode: 0 # 不讲话
  speak_gap: 0
  description: "机器人未定义状态"

# 四足抚摸提示音
- name: QUAD_TOUCHPROMPT
  id: 191
  type: "meta"
  emotion_ids: [90]  # 快乐
  emotion_mod: 1 # 单次
  # preset_motion_id: 0
  # motion_mod: 0 # 无
  priority: 60 # 优先级
  # text: ""
  # speak_mode: 0 # 不讲话
  # speak_gap: 0
  description: "四足抚摸提示"
  audio_file_path: "/robot/software/task_engine/resource/resource_audios/"
  audio_file_name_quadruped: "撒娇.wav"
  audio_file_name_biped: "撒娇.wav"

# 双足抚摸提示音（只说话/音频，不触发表情）
- name: BIPE_TOUCHPROMPT
  id: 192
  type: "meta"
  emotion_ids: [90]  # 快乐
  emotion_mod: 1 # 单次
  # preset_motion_id: 0
  # motion_mod: 0 # 无
  priority: 60 # 优先级
  text: "不要摸我，我怕痒"
  speak_mode: 0 # 不讲话
  speak_gap: 0
  description: "双足抚摸提示"


#   # 普通变形加音效
# - name: TRANSFORMATION_NORMAL
#   id: 300
#   type: "meta"
#   # emotion_ids: [270]
#   # emotion_mod: 1 # 单次
#   # preset_motion_id: 0
#   # motion_mod: 2 # kOnce
#   priority: 60 # 优先级
#   # text: ""
#   # speak_mode: 0 # 不讲话
#   # speak_gap: 0
#   audio_file_path: "/robot/data/system/hal_audio/audio/"
#   audio_file_name_quadruped: "transform4to2.wav"
#   audio_file_name_biped: "transform2to4.wav"
#   mc_action_id: 300
#   description: "普通变形加音效"

#   # 旋转变形加音效
# - name: TRANSFORMATION_ROTATE
#   id: 301
#   type: "meta"
#   # emotion_ids: [270]
#   # emotion_mod: 1 # 单次
#   # preset_motion_id: 0
#   # motion_mod: 2 # kOnce
#   priority: 60 # 优先级
#   # text: ""
#   # speak_mode: 0 # 不讲话
#   # speak_gap: 0
#   audio_file_path: "/robot/data/system/hal_audio/audio/"
#   audio_file_name_quadruped: "transform4to2.wav"
#   audio_file_name_biped: "transform2to4.wav"
#   mc_action_id: 301
#   description: "旋转变形加音效"

#   # 空翻变形加音效
# - name: TRANSFORMATION_FRONTFLIP
#   id: 302
#   type: "meta"
#   # emotion_ids: [270]
#   # emotion_mod: 1 # 单次
#   # preset_motion_id: 0
#   # motion_mod: 2 # kOnce
#   priority: 60 # 优先级
#   # text: ""
#   # speak_mode: 0 # 不讲话
#   # speak_gap: 0
#   audio_file_path: "/robot/data/system/hal_audio/audio/"
#   audio_file_name_quadruped: "transform4to2.wav"
#   audio_file_name_biped: "transform2to4.wav"
#   mc_action_id: 302
#   description: "空翻变形加音效"

#   # 跳舞➕播音乐
# - name: DANCE_AND_MUSIC
#   id: 400
#   type: "meta"
#   # emotion_ids: [270]
#   # emotion_mod: 1 # 单次
#   # preset_motion_id: 0
#   # motion_mod: 2 # kOnce
#   priority: 60 # 优先级
#   # text: ""
#   # speak_mode: 0 # 不讲话
#   # speak_gap: 0
#   audio_file_path: "/robot/data/system/hal_audio/audio/"
#   audio_file_name_quadruped: "dance.wav"
#   audio_file_name_biped: "dance.wav"
#   mc_action_id: 400
#   description: "跳舞➕播音乐"

- name: TRANS_TO_T1_BIPED_WBC
  id: 610
  type: "meta"
  preset_motion_id: 300
  motion_mod: 0
  description: "T1双足状态下切换到WBC"

# T1Animation 动作组
- name: QUADRUPED_LOCOMOTION_HANDSHAKE
  id: 1
  type: "meta"
  preset_motion_id: 1
  motion_mod: 2
  emotion_ids: [17, 102, 240, 18]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_wave_hands"
  speak_mode: 0
  description: "打招呼"

- name: QUADRUPED_LOCOMOTION_HANDSHAKE
  id: 2
  type: "meta"
  preset_motion_id: 2
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  emotion_random_pick: true
  priority: 50
  scene_id: "app_shake_hands_right"
  speak_mode: 0
  description: "握手"

- name: QUADRUPED_SIT_DOWN_DEFAULT
  id: 3
  type: "meta"
  preset_motion_id: 3
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  description: "坐下"
  pre_audio_before_action: true
  pre_scene_id: "app_sit_down"

- name: QUADRUPED_GET_DOWN_DEFAULT
  id: 4
  type: "meta"
  preset_motion_id: 4
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  description: "趴下"
  pre_audio_before_action: true
  pre_scene_id: "app_lie_down"
  pre_scene_id_delay_ms: 3000

- name: QUADRUPED_LOCOMOTION_DEFAULT
  id: 5
  type: "meta"
  preset_motion_id: 5
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  scene_id: "app_stand_up"
  speak_mode: 0
  description: "站起"
  pre_audio_before_action: true

- name: BOTH_HANDS_MAKE_HEART
  id: 6
  type: "meta"
  preset_motion_id: 6
  motion_mod: 2
  emotion_ids: [18]
  emotion_mod: 2
  priority: 50
  scene_id: "app_hand_heart_both"
  speak_mode: 0
  description: "双手比心"

- name: QUADRUPED_LOCOMOTION_DANCE
  id: 7
  type: "meta"
  preset_motion_id: 7
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102, 18]
  emotion_mod: 5
  emotion_random_pick: true
  priority: 50
  speak_mode: 0
  description: "跳舞（人形小彩蝶旋转舞蹈）"

- name: BIPED_LOCOMOTION_WBC
  id: 8
  type: "meta"
  preset_motion_id: 8
  motion_mod: 2
  emotion_ids: [240, 19]
  emotion_mod: 1
  priority: 50
  pre_audio_before_action: true
  speak_mode: 0
  description: "旋转变形"

- name: PHOTO_POSE_1
  id: 20
  type: "meta"
  preset_motion_id: 20
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_pose_A"
  speak_mode: 0
  description: "拍照姿势1"

- name: PHOTO_POSE_2
  id: 21
  type: "meta"
  preset_motion_id: 21
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_pose_B"
  speak_mode: 0
  description: "拍照姿势2"

- name: PHOTO_POSE_3
  id: 22
  type: "meta"
  preset_motion_id: 22
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_pose_C"
  speak_mode: 0
  description: "拍照姿势3"

- name: QUADRUPED_LOCOMOTION_STRETCH
  id: 27
  type: "meta"
  preset_motion_id: 27
  motion_mod: 2
  emotion_ids: [15]
  emotion_mod: 1
  priority: 50
  scene_id: "app_stretch_quadruped"
  speak_mode: 0
  description: "伸懒腰"

- name: RIGHT_HAND_PUNCH
  id: 28
  type: "meta"
  preset_motion_id: 28
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_fist_bump_hand_right"
  speak_mode: 0
  description: "右手碰拳"

- name: LEFT_HAND_PUNCH
  id: 29
  type: "meta"
  preset_motion_id: 29
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_fist_bump_hand_left"
  speak_mode: 0
  description: "左手碰拳"

- name: TALKING
  id: 60
  type: "meta"
  preset_motion_id: 60
  motion_mod: 2
  emotion_ids: [27, 32]
  emotion_mod: 1
  priority: 50
  scene_id: "app_talk"
  speak_mode: 0
  description: "说话姿态"

# ─── 新增动作组（基于 0610 动作表）───────────────────────────────────────────

- name: EASY_TRANSFORIMATE
  id: 9
  type: "meta"
  preset_motion_id: 9
  motion_mod: 2
  emotion_ids: [240]
  emotion_mod: 1
  priority: 50
  random_scene_ids:
    - "t1_easy_transform_1"
    - "t1_easy_transform_2"
    - "t1_easy_transform_3"
  speak_mode: 0
  description: "简易变形"

- name: DANCE_B
  id: 10
  type: "meta"
  preset_motion_id: 10
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102, 240, 18, 19]
  emotion_mod: 3
  emotion_random_pick: true
  priority: 50
  speak_mode: 0
  description: "跳舞B"

- name: DANCE_C
  id: 11
  type: "meta"
  preset_motion_id: 11
  motion_mod: 2
  emotion_ids: [17, 102, 240, 18, 19]
  emotion_mod: 3
  emotion_random_pick: true
  priority: 50
  speak_mode: 0
  description: "跳舞C"

- name: PROUD
  id: 25
  type: "meta"
  preset_motion_id: 25
  motion_mod: 2
  emotion_ids: [240]
  emotion_mod: 1
  priority: 50
  scene_id: "app_proud"
  speak_mode: 0
  description: "骄傲"

- name: JOY
  id: 26
  type: "meta"
  preset_motion_id: 26
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_laughing"
  speak_mode: 0
  description: "喜悦"

- name: LEFT_HANDSHAKE
  id: 30
  type: "meta"
  preset_motion_id: 30
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  emotion_random_pick: true
  priority: 50
  scene_id: "app_shake_hands_left"
  speak_mode: 0
  description: "左手握手"

- name: BOTH_HANDS_CELEBRATE
  id: 31
  type: "meta"
  preset_motion_id: 31
  motion_mod: 2
  emotion_ids: [18]
  emotion_mod: 2
  priority: 50
  scene_id: "app_cheer_up"
  speak_mode: 0
  description: "加油欢呼"

- name: LEFT_HAND_UP
  id: 32
  type: "meta"
  preset_motion_id: 32
  motion_mod: 2
  emotion_ids: [10, 11, 12, 90, 28]
  emotion_mod: 1
  emotion_random_pick: true
  priority: 50
  scene_id: "app_raise_left_hand"
  speak_mode: 0
  description: "左手抬起"

- name: RIGHT_HAND_UP
  id: 33
  type: "meta"
  preset_motion_id: 33
  motion_mod: 2
  emotion_ids: [10, 11, 12, 90, 28]
  emotion_mod: 1
  emotion_random_pick: true
  priority: 50
  scene_id: "app_raise_right_hand"
  speak_mode: 0
  description: "右手抬起"

- name: BOTH_HANDS_UP
  id: 34
  type: "meta"
  preset_motion_id: 34
  motion_mod: 2
  emotion_ids: [10, 11, 12, 28]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  scene_id: "app_raise_both_hands"
  speak_mode: 0
  description: "双手抬起"

- name: LEFT_HAND_DOWN
  id: 35
  type: "meta"
  preset_motion_id: 35
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_left_hand_down_1"
    - "t1_left_hand_down_2"
    - "t1_left_hand_down_3"
  description: "左手放下"

- name: RIGHT_HAND_DOWN
  id: 36
  type: "meta"
  preset_motion_id: 36
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_right_hand_down_1"
    - "t1_right_hand_down_2"
    - "t1_right_hand_down_3"
  description: "右手放下"

- name: BOTH_HANDS_DOWN
  id: 37
  type: "meta"
  preset_motion_id: 37
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_both_hands_down_1"
    - "t1_both_hands_down_2"
    - "t1_both_hands_down_3"
  description: "双手放下"

- name: POSING
  id: 38
  type: "meta"
  preset_motion_id: 38
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_posing_1"
    - "t1_posing_2"
    - "t1_posing_3"
  description: "摆姿势"

- name: LOCK_POSTURE
  id: 39
  type: "meta"
  preset_motion_id: 39
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_lock_posture_1"
    - "t1_lock_posture_2"
    - "t1_lock_posture_3"
  description: "锁定姿态"

- name: PUSH_UP
  id: 40
  type: "meta"
  preset_motion_id: 40
  motion_mod: 2
  emotion_ids: [240]
  emotion_mod: 1
  priority: 50
  scene_id: "app_push_up_quadruped"
  speak_mode: 0
  description: "俯卧撑"

- name: CIRCLE
  id: 42
  type: "meta"
  preset_motion_id: 42
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_circle_1"
    - "t1_circle_2"
    - "t1_circle_3"
  description: "转圈"

- name: RHYTHM
  id: 43
  type: "meta"
  preset_motion_id: 43
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  emotion_random_pick: true
  priority: 50
  speak_mode: 0
  description: "律动"

- name: FEAR
  id: 44
  type: "meta"
  preset_motion_id: 44
  motion_mod: 2
  emotion_ids: [20]
  emotion_mod: 2
  priority: 50
  scene_id: "app_scary"
  speak_mode: 0
  description: "害怕"

- name: SAD
  id: 45
  type: "meta"
  preset_motion_id: 45
  motion_mod: 2
  emotion_ids: [21]
  emotion_mod: 2
  priority: 50
  scene_id: "app_sad"
  speak_mode: 0
  description: "难过"

- name: RECOVER_POSTURE
  id: 46
  type: "meta"
  preset_motion_id: 46
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_recover_1"
    - "t1_recover_2"
    - "t1_recover_3"
  description: "任意姿态恢复"

- name: LISTEN_POSTURE
  id: 49
  type: "meta"
  preset_motion_id: 49
  motion_mod: 2
  emotion_ids: [250]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_listen_1"
    - "t1_listen_2"
    - "t1_listen_3"
  description: "聆听姿态"

- name: TALK_POSTURE
  id: 50
  type: "meta"
  preset_motion_id: 50
  motion_mod: 2
  emotion_ids: [270]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_talk_1"
    - "t1_talk_2"
    - "t1_talk_3"
  description: "说话姿态"

- name: THINK_POSTURE
  id: 51
  type: "meta"
  preset_motion_id: 51
  motion_mod: 2
  emotion_ids: [260]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_think_1"
    - "t1_think_2"
    - "t1_think_3"
  description: "思考姿态"

- name: MOONWALK
  id: 52
  type: "meta"
  preset_motion_id: 52
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102, 18]
  emotion_mod: 4
  emotion_random_pick: true
  priority: 50
  scene_id: "app_moonwalk"
  speak_mode: 0
  description: "太空步"

- name: QUADRUPED_MIMIC_GLANCE
  id: 54
  type: "meta"
  preset_motion_id: 54
  motion_mod: 2
  emotion_ids: [22]
  emotion_mod: 1
  priority: 50
  scene_id: "app_look_around_quadruped"
  speak_mode: 0
  description: "四处看"

- name: FRONT_FLIP_TRANSFORM
  id: 55
  type: "meta"
  preset_motion_id: 55
  motion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_front_flip_transform_1"
    - "t1_front_flip_transform_2"
    - "t1_front_flip_transform_3"
  description: "前空翻变形"

- name: FRONT_FLIP
  id: 56
  type: "meta"
  preset_motion_id: 56
  motion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_front_flip_1"
    - "t1_front_flip_2"
    - "t1_front_flip_3"
  description: "前空翻"

- name: RHYTHM_2
  id: 57
  type: "meta"
  preset_motion_id: 57
  motion_mod: 2
  emotion_ids: [18]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_rhythm_2_a"
    - "t1_rhythm_2_b"
    - "t1_rhythm_2_c"
  description: "律动2"

- name: BIPED_TALK_SMALL_1
  id: 58
  type: "meta"
  preset_motion_id: 58
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_talk_small_1_a"
    - "t1_talk_small_1_b"
    - "t1_talk_small_1_c"
  description: "小幅度人形讲话动作1"

- name: BIPED_TALK_SMALL_2
  id: 59
  type: "meta"
  preset_motion_id: 59
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_talk_small_2_a"
    - "t1_talk_small_2_b"
    - "t1_talk_small_2_c"
  description: "小幅度人形讲话动作2"

- name: BIPED_TALK_SMALL_3
  id: 61
  type: "meta"
  preset_motion_id: 61
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_talk_small_3_a"
    - "t1_talk_small_3_b"
    - "t1_talk_small_3_c"
  description: "小幅度人形讲话动作3"

- name: QUADRUPED_TALK_1
  id: 62
  type: "meta"
  preset_motion_id: 62
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_quad_talk_1_a"
    - "t1_quad_talk_1_b"
    - "t1_quad_talk_1_c"
  description: "四足讲话动作1"

- name: QUADRUPED_TALK_2
  id: 63
  type: "meta"
  preset_motion_id: 63
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_quad_talk_2_a"
    - "t1_quad_talk_2_b"
    - "t1_quad_talk_2_c"
  description: "四足讲话动作2"

- name: QUADRUPED_TALK_3
  id: 64
  type: "meta"
  preset_motion_id: 64
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_quad_talk_3_a"
    - "t1_quad_talk_3_b"
    - "t1_quad_talk_3_c"
  description: "四足讲话动作3"

- name: QUADRUPED_TALK_4
  id: 65
  type: "meta"
  preset_motion_id: 65
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_quad_talk_4_a"
    - "t1_quad_talk_4_b"
    - "t1_quad_talk_4_c"
  description: "四足讲话动作4"

- name: HIP_POSE
  id: 66
  type: "meta"
  preset_motion_id: 66
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_hip_pose_1"
    - "t1_hip_pose_2"
    - "t1_hip_pose_3"
  description: "掐腰（人形思考动作3）"

- name: BIPED_TALK_SMALL_4
  id: 67
  type: "meta"
  preset_motion_id: 67
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_talk_small_4_a"
    - "t1_talk_small_4_b"
    - "t1_talk_small_4_c"
  description: "小幅度人形讲话动作4"

- name: QUADRUPED_TALK_5
  id: 68
  type: "meta"
  preset_motion_id: 68
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_quad_talk_5_a"
    - "t1_quad_talk_5_b"
    - "t1_quad_talk_5_c"
  description: "四足讲话动作5"

- name: BIPED_THINK_1
  id: 69
  type: "meta"
  preset_motion_id: 69
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_think_1_a"
    - "t1_think_1_b"
    - "t1_think_1_c"
  description: "人形思考动作1"

- name: BIPED_THINK_2
  id: 70
  type: "meta"
  preset_motion_id: 70
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_think_2_a"
    - "t1_think_2_b"
    - "t1_think_2_c"
  description: "人形思考动作2"

- name: BIPED_THINK_4
  id: 71
  type: "meta"
  preset_motion_id: 71
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_think_4_a"
    - "t1_think_4_b"
    - "t1_think_4_c"
  description: "人形思考动作4"

- name: BIPED_ROTATE_90
  id: 72
  type: "meta"
  preset_motion_id: 72
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_rotate_90_1"
    - "t1_rotate_90_2"
    - "t1_rotate_90_3"
  description: "人形惯性转圈90度"

- name: BIPED_ROTATE_360
  id: 73
  type: "meta"
  preset_motion_id: 73
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_rotate_360_1"
    - "t1_rotate_360_2"
    - "t1_rotate_360_3"
  description: "人形惯性转圈360度"

- name: BIPED_HUG_OPENBOX
  id: 74
  type: "meta"
  preset_motion_id: 74
  motion_mod: 2
  emotion_ids: [18]
  emotion_mod: 2
  priority: 50
  scene_id: "app_hug"
  speak_mode: 0
  description: "人形拥抱（开箱）"

- name: BIPED_DANCE_OPENBOX
  id: 75
  type: "meta"
  preset_motion_id: 75
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_dance_openbox_1"
    - "t1_dance_openbox_2"
    - "t1_dance_openbox_3"
  description: "人形舞蹈（开箱）"

- name: BIPED_SHOWCASE
  id: 76
  type: "meta"
  preset_motion_id: 76
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_showcase_1"
    - "t1_showcase_2"
    - "t1_showcase_3"
  description: "人形展示动作"

- name: BREATH
  id: 77
  type: "meta"
  preset_motion_id: 77
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_breath_1"
    - "t1_breath_2"
    - "t1_breath_3"
  description: "呼吸动作"

- name: BIPED_DEFAULT_POS
  id: 100
  type: "meta"
  preset_motion_id: 100
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_default_pos_1"
    - "t1_default_pos_2"
    - "t1_default_pos_3"
  description: "动作复位"

# ─── 世界杯动作组 ───────────────────────────────────────────────────────────

- name: GREET_NEW
  id: 3052
  type: "meta"
  preset_motion_id: 3052
  motion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_greet_new_1"
    - "t1_greet_new_2"
    - "t1_greet_new_3"
  description: "打招呼新"

- name: BOTH_HANDS_CHEER_1
  id: 3048
  type: "meta"
  preset_motion_id: 3048
  motion_mod: 2
  emotion_ids: [90]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  random_scene_ids:
    - "t1_cheer_1_a"
    - "t1_cheer_1_b"
    - "t1_cheer_1_c"
  description: "双手欢呼1"

- name: BOTH_HANDS_CHEER_2
  id: 3054
  type: "meta"
  preset_motion_id: 3054
  motion_mod: 2
  emotion_ids: [16]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_cheer_2_a"
    - "t1_cheer_2_b"
    - "t1_cheer_2_c"
  speak_mode: 0
  description: "双手欢呼2"

- name: BOTH_HANDS_CHEER_3
  id: 3055
  type: "meta"
  preset_motion_id: 3055
  motion_mod: 2
  emotion_ids: [102]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_cheer_3_a"
    - "t1_cheer_3_b"
    - "t1_cheer_3_c"
  speak_mode: 0
  description: "双手欢呼3"

- name: DANCE_30S
  id: 3061
  type: "meta"
  preset_motion_id: 3061
  motion_mod: 2
  emotion_ids: [90, 16, 240, 18, 19]
  emotion_mod: 3
  emotion_random_pick: true
  priority: 50
  speak_mode: 0
  description: "双手欢呼3"

- name: BOTH_HANDS_WAVE_LR
  id: 3047
  type: "meta"
  preset_motion_id: 3047
  motion_mod: 2
  emotion_ids: [17]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_wave_lr_1"
    - "t1_wave_lr_2"
    - "t1_wave_lr_3"
  speak_mode: 0
  description: "左右手挥舞"

- name: BOTH_HANDS_WAVE
  id: 3043
  type: "meta"
  preset_motion_id: 3043
  motion_mod: 2
  emotion_ids: [240]
  emotion_mod: 1
  priority: 50
  random_scene_ids:
    - "t1_wave_both_1"
    - "t1_wave_both_2"
    - "t1_wave_both_3"
  speak_mode: 0
  description: "双手挥舞"

- name: BOTH_HANDS_WAVE_2
  id: 3045
  type: "meta"
  preset_motion_id: 3045
  motion_mod: 2
  emotion_ids: [19]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_wave_both_2_a"
    - "t1_wave_both_2_b"
    - "t1_wave_both_2_c"
  speak_mode: 0
  description: "双手挥舞2"

- name: BOTH_HANDS_WAVE_3
  id: 3046
  type: "meta"
  preset_motion_id: 3046
  motion_mod: 2
  emotion_ids: [16]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_wave_both_3_a"
    - "t1_wave_both_3_b"
    - "t1_wave_both_3_c"
  speak_mode: 0
  description: "双手挥舞3"

- name: BOTH_HANDS_CHEER
  id: 3040
  type: "meta"
  preset_motion_id: 3040
  motion_mod: 2
  emotion_ids: [18]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_cheer_both_1"
    - "t1_cheer_both_2"
    - "t1_cheer_both_3"
  speak_mode: 0
  description: "双手欢呼"

- name: SINGLE_ARM_CLAP
  id: 3038
  type: "meta"
  preset_motion_id: 3038
  motion_mod: 2
  emotion_ids: [10, 240]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_single_clap_1"
    - "t1_single_clap_2"
    - "t1_single_clap_3"
  speak_mode: 0
  description: "单臂击掌"

- name: BIPED_RECOVERY
  id: 1101
  type: "meta"
  preset_motion_id: 1101 
  emotion_ids: [10,13,13,13]
  emotion_mod: 0  # 循环播放
  emotion_priority: -1000
  priority: 50
  random_scene_ids:
    - "t1_recovery_1"
    - "t1_recovery_2"
    - "t1_recovery_3"
  description: "双足自恢复"

- name: QUADRUPED_LOCOMOTION_BACKFLIP
  id: 1102
  type: "meta"
  preset_motion_id: 1102
  emotion_ids: [10,13,13,13]
  emotion_mod: 0  # 循环播放
  emotion_priority: -1000
  priority: 50
  random_scene_ids:
    - "t1_backflip_1"
    - "t1_backflip_2"
    - "t1_backflip_3"
  description: "四足后空翻"

- name: QUADRUPED_LOCOMOTION_FRONTFLIP
  id: 1103
  type: "meta"
  preset_motion_id: 1103
  emotion_ids: [10,13,13,13]
  emotion_mod: 0  # 循环播放
  emotion_priority: -1000
  priority: 50
  random_scene_ids:
    - "t1_frontflip_1"
    - "t1_frontflip_2"
    - "t1_frontflip_3"
  description: "四足前空翻"

- name: QUADRUPED_TO_BIPED_FRONTFLIP
  id: 1104
  type: "meta"
  preset_motion_id: 1104
  emotion_ids: [10,13,13,13]
  emotion_mod: 0  # 循环播放
  emotion_priority: -1000
  priority: 50
  random_scene_ids:
    - "t1_frontflip_transform_1"
    - "t1_frontflip_transform_2"
    - "t1_frontflip_transform_3"
  description: "四足空翻变双足"

- name: BIPED_LOCOMOTION_MOONWALK
  id: 1105
  type: "meta"
  preset_motion_id: 1105
  emotion_ids: [10,13,13,13]
  emotion_mod: 0  # 循环播放
  emotion_priority: -1000
  priority: 50
  random_scene_ids:
    - "t1_moonwalk_biped_1"
    - "t1_moonwalk_biped_2"
    - "t1_moonwalk_biped_3"
  description: "双足太空步"
  audio_file_path: "/robot/software/task_engine/resource/resource_audios/"
  audio_file_name_quadruped: "Billiejean_cut_15sec.wav"
  audio_file_name_biped: "Billiejean_cut_15sec.wav"

# ─── 补全 cfg/motions/t1 中所有动作 ──────────────────────────────────────────

# 向前跳
- name: FORWARD_JUMP
  id: 41
  type: "meta"
  preset_motion_id: 41
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  priority: 50
  speak_mode: 0
  description: "向前跳"

# 退出太空步
- name: EXIT_MOONWALK
  id: 53
  type: "meta"
  preset_motion_id: 53
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_exit_moonwalk_1"
    - "t1_exit_moonwalk_2"
    - "t1_exit_moonwalk_3"
  speak_mode: 0
  description: "退出太空步"

# 左手举过头顶
- name: LEFT_HAND_OVERHEAD
  id: 78
  type: "meta"
  preset_motion_id: 78
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  scene_id: "app_raise_hand_top_left"
  speak_mode: 0
  description: "左手举过头顶"

# 右手举过头顶
- name: RIGHT_HAND_OVERHEAD
  id: 79
  type: "meta"
  preset_motion_id: 79
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 1
  priority: 50
  scene_id: "app_raise_hand_top_right"
  speak_mode: 0
  description: "右手举过头顶"

# 随机跳舞
- name: RANDOM_DANCE
  id: 80
  type: "meta"
  preset_motion_id: 80
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_random_dance_1"
    - "t1_random_dance_2"
    - "t1_random_dance_3"
  speak_mode: 0
  description: "随机跳舞"

# 冰上旋舞
- name: ICE_SPIN_DANCE
  id: 3098
  type: "meta"
  preset_motion_id: 3098
  motion_mod: 2
  emotion_ids: [10, 90, 11, 18, 12, 16, 19, 240, 33, 33, 10, 102, 17]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  description: "冰上旋舞"

# 极光冰舞
- name: AURORA_ICE_DANCE
  id: 3099
  type: "meta"
  preset_motion_id: 3099
  motion_mod: 2
  emotion_ids: [90, 11, 18, 12, 16, 19, 240, 33, 33, 10, 102, 17, 240, 33, 33, 10, 102, 17, 18, 10, 16, 90]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  description: "极光冰舞"

# 滑行登场
- name: SLIDING_ENTRANCE
  id: 3100
  type: "meta"
  preset_motion_id: 3100
  motion_mod: 2
  emotion_ids: [16, 102, 18]
  emotion_mod: 1
  priority: 50
  speak_mode: 0
  description: "滑行登场"

# 室内模式
- name: MODE_INDOORS
  id: 4001
  type: "meta"
  preset_motion_id: 4001
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_mode_indoor_1"
    - "t1_mode_indoor_2"
    - "t1_mode_indoor_3"
  speak_mode: 0
  description: "室内模式"

# 户外模式
- name: MODE_OUTDOORS
  id: 4002
  type: "meta"
  preset_motion_id: 4002
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_mode_outdoor_1"
    - "t1_mode_outdoor_2"
    - "t1_mode_outdoor_3"
  speak_mode: 0
  description: "户外模式"

# 超能力模式
- name: MODE_SUPERPOWER
  id: 4003
  type: "meta"
  preset_motion_id: 4003
  motion_mod: 2
  emotion_ids: [90, 16, 17, 102]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_mode_super_1"
    - "t1_mode_super_2"
    - "t1_mode_super_3"
  speak_mode: 0
  description: "超能力模式"

# 搬运模式
- name: MODE_CARRY
  id: 4004
  type: "meta"
  preset_motion_id: 4004
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_mode_carry_1"
    - "t1_mode_carry_2"
    - "t1_mode_carry_3"
  speak_mode: 0
  description: "搬运模式"

# 模拟动画
- name: SIMULATE_ANIMATION
  id: 9999
  type: "meta"
  preset_motion_id: 9999
  motion_mod: 2
  emotion_ids: [10, 11, 12]
  emotion_mod: 2
  priority: 50
  random_scene_ids:
    - "t1_simulate_1"
    - "t1_simulate_2"
    - "t1_simulate_3"
  speak_mode: 0
  description: "模拟动画"


===== FILE: raw/t1/qd1_t2d0/motion_list.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/motion_list.yaml) =====

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


===== FILE: raw/t1/qd1_t2d0/mc_T1.yaml.dump  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/运控模型库/真机/qd1_t2d0/配置/mc_T1.yaml.dump) =====

aimrt:
  configurator:
    temp_cfg_path: /tmp/robot-run/proc/mc/cfg
  log:
    core_lvl: Info
    default_module_lvl: Info
    backends:
      - type: console
        options:
          pattern: "[%c.%f][%l][%t][%G:%R] %v"
      - type: rotate_file
        options:
          path: /robot/persist/log/mc
          filename: mc.log
          pattern: "[%c.%f][%l][%t][%G:%R] %v"
          max_file_size_m: 50
          max_file_num: 6
          enable_sync: true
          sync_interval_ms: 1000
          sync_executor_name: default_log_sync_executor
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
          executor_bind_cpus:
            - 3
      - name: nsm_plugin
        path: libaimrt_nsm_plugin.so
        options:
          node_name: mc
          state_reporting_executor: nsm_state_reporting_executor
          state_reporting_period:
            value: 1
            unit: sec
          modules_processing_executor: nsm_modules_processing_executor
  channel:
    backends:
      - type: iceoryx
        options:
          listener_thread_name: rt_iceoryx_sub
          listener_thread_sched_policy: SCHED_RR:85
          listener_thread_bind_cpu: [3]
      - type: sm
        options:
          sub_default_executor: mc_sm_thread
          sub_topic_options:
            - topic_name: (.*)
      - type: ros2
        options:
          pub_topics_options:
            - topic_name: (.*)
              use_serialized: false
              qos:
                history: keep_last
                depth: 10
                reliability: best_effort
                durability: volatile
                liveliness: automatic
                liveliness_lease_duration: -1
          sub_topics_options:
            - topic_name: (.*)
              use_serialized: false
              qos:
                history: keep_last
                depth: 10
                reliability: best_effort
                durability: volatile
                liveliness: automatic
                liveliness_lease_duration: -1
      - type: local
    pub_topics_options:
      - topic_name: /aimrte/sm/node_state
        enable_backends:
          - ros2
      - topic_name: /aima/hal/joint/command
        enable_backends:
          - iceoryx
      - topic_name: /aima/mc/action/info
        enable_backends:
          - ros2
      - topic_name: /aima/mc/common/state
        enable_backends:
          - ros2
      - topic_name: /robot/trace/events
        enable_backends:
          - ros2
      - topic_name: /aima/hds/diagnostic_list
        enable_backends:
          - ros2
    sub_topics_options:
      - topic_name: /aima/hal/joint/state
        enable_backends:
          - iceoryx
      - topic_name: /aima/hal/imu/torso/state
        enable_backends:
          - iceoryx
      - topic_name: /aima/mc/locomotion/velocity
        enable_backends:
          - ros2
      - topic_name: /aima/mc/body_pose
        enable_backends:
          - ros2
      - topic_name: /aima/mc/custom/joint/command
        enable_backends:
          - ros2
      - topic_name: /aima/teleop_bridge/vr_data
        enable_backends:
          - ros2
  rpc:
    backends:
      - type: ros2
      - type: local
    clients_options:
      - func_name: (pb:/_/aimrte/sm/rpc/module_fallback/.*)
        enable_backends:
          - local
      - func_name: (pb:/_/aimrte/sm/rpc/module_state_switch/.*)
        enable_backends:
          - local
      - func_name: (.*)
        enable_backends:
          - ros2
    servers_options:
      - func_name: (pb:/_/aimrte/sm/rpc/module_fallback/.*)
        enable_backends:
          - local
      - func_name: (pb:/_/aimrte/sm/rpc/module_state_switch/.*)
        enable_backends:
          - local
      - func_name: (pb:/aimdk\.protocol\.SmNodeService/.*)
        enable_backends:
          - ros2
      - func_name: (.*)
        enable_backends:
          - ros2
  main_thread:
    name: mc_main
  guard_thread: {}
  executor:
    executors:
      - type: asio_thread
        name: rt_joint_pub
        options:
          thread_num: 1
          thread_sched_policy: SCHED_RR:80
          thread_bind_cpu:
            - 3
      - type: asio_thread
        name: mc_sm_thread
        options:
          thread_num: 1
          thread_sched_policy: SCHED_OTHER
          thread_bind_cpu:
            - 3
      - type: asio_thread
        name: com_data_pub
        options:
          thread_bind_cpu:
            - 3
      - type: asio_thread
        name: event_trace_pub
        options:
          thread_num: 1
      - type: asio_thread
        name: hds_pub
        options:
          thread_num: 1
      - type: asio_thread
        name: main_executor
      - type: asio_thread
        name: common_server
        options:
          thread_num: 2
      - type: asio_thread
        name: MotionControlModule/hds_executor
      - type: asio_thread
        name: MotionControlModule/event_executor
      - type: asio_thread
        name: default_timeout_executor
      - type: time_wheel
        name: default_timeout_time_wheel
        options:
          bind_executor: default_timeout_executor
          dt_us: 50000
      - type: asio_thread
        name: nsm_state_reporting_executor
      - type: asio_thread
        name: nsm_modules_processing_executor
        options:
          thread_num: 1
      - type: asio_thread
        name: default_log_sync_executor
  module:
    pkgs: []
    modules:
      - name: MotionControlModule
MotionControlModule:
  env_path: /robot/software/mc/bin
  config_path: ./cfg/robot
  resource_path: ../res
  robot_name: qd1_t2d0
  main_executor_name: main_executor
  PublisherManager:
    publisher_cfg_list:
      - name: joint_command
        topic: /aima/hal/joint/command
        enable: true
        frequency: 200
        executor: rt_joint_pub
        print_interval: 0
      - name: mc_common_state
        topic: /aima/mc/common/state
        enable: true
        frequency: 50
        executor: com_data_pub
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
        pub_inter_frame_interval_ns: 10000000
        recv_inter_frame_interval_ns: 10000000
        pub_to_recv_delay_ns: 10000000
      - name: imu_state
        topic: /aima/hal/imu/torso/state
        executor: rt_imu_sub
        enable: true
        wait_ready: true
        print_interval: 0
        pub_inter_frame_interval_ns: 10000000
        recv_inter_frame_interval_ns: 10000000
        pub_to_recv_delay_ns: 10000000
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
        priority: 80
        timeout: 1000
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