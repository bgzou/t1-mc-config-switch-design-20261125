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
