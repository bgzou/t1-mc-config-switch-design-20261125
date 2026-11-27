# Pack 03 · 接口与任务门控

重点：`McHandHeldState` 5 态与 `is_held` 语义、`AmRequest REASON_HELD=41`、9 条 `allow_held_state:false`、`follow.yaml` 不拦 held。


===== FILE: raw/t1/interfaces/McHandHeldState.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McHandHeldState.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/data/msg/common/McHandHeldState.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    module McHandHeldState_Constants {
      @verbatim (language="comment", text=
        "The state is unknown when either hand has not produced a confirmed result.")
      const uint8 UNKNOWN = 0;
      @verbatim (language="comment", text=
        "Both hands are confirmed as not held.")
      const uint8 BOTH_NOT_HELD = 1;
      @verbatim (language="comment", text=
        "Only the left hand is held.")
      const uint8 LEFT_HELD_ONLY = 2;
      @verbatim (language="comment", text=
        "Only the right hand is held.")
      const uint8 RIGHT_HELD_ONLY = 3;
      @verbatim (language="comment", text=
        "Both hands are held.")
      const uint8 BOTH_HELD = 4;
    };
    @verbatim (language="comment", text=
      "Robot motion-control hand-held state.")
    struct McHandHeldState {
      @verbatim (language="comment", text=
        "True when at least one hand is confirmed as held." "\n"
        "False when neither hand is held or the combined state is unknown.")
      boolean is_held;

      @verbatim (language="comment", text=
        "Current combined hand-held state. The value must be one of the constants above.")
      uint8 hand_held;
    };
  };
};


===== FILE: raw/t1/interfaces/McHandHeldState.msg  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/common/McHandHeldState.msg) =====

# Robot motion-control hand-held state.

# The state is unknown when either hand has not produced a confirmed result.
uint8 UNKNOWN = 0

# Both hands are confirmed as not held.
uint8 BOTH_NOT_HELD = 1

# Only the left hand is held.
uint8 LEFT_HELD_ONLY = 2

# Only the right hand is held.
uint8 RIGHT_HELD_ONLY = 3

# Both hands are held.
uint8 BOTH_HELD = 4

# True when at least one hand is confirmed as held.
# False when neither hand is held or the combined state is unknown.
bool is_held

# Current combined hand-held state. The value must be one of the constants above.
uint8 hand_held


===== FILE: raw/t1/interfaces/McCommonState.msg  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McCommonState.msg) =====

# -----------------------------------------------------------------------------------
# 机器人运控状态
# -----------------------------------------------------------------------------------

MessageHeader header

# ------------ 输入源信息 ------------ #
McInputSource input_source

# ----------- Action 信息 ----------- #
McActionInfo action_info

# --------- 机器运行模型信息 ---------- #
McRuntimeModel runtime_model

# --------- 动作运行信息 ---------- #
McMotionStatus motion_status

# --------- 有限状态机状态 ---------- #
McFsmState fsm_state

# --------- 机器人形态信息 ---------- #
McFormState form_state

# --------- 机器人姿态信息 ---------- #
McPosture posture

# ----------机器人是否处于运动状态 ----------
bool is_moving

# ----------机器人是否摔倒（防摔检测触发后置 true；重新解锁站立防摔检测时置 false）----------
bool is_fallen

# ---------- 机器人提起检测状态 ---------- #
McLiftState lift_state

# ---------- rpc 请求 执行状态 ----------
McTaskInfo  task_info

# ---------- 机器人牵手状态 ---------- #
McHandHeldState held_state


===== FILE: raw/t1/interfaces/InteractionState.msg  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/InteractionState.msg) =====

# -----------------------------------------------------------------------------------
# interaction状态
# -----------------------------------------------------------------------------------

MessageHeader header

# ----------- 当前执行的interaction id ----------- #
int64 interaction_id

# --------- 动作运行信息 ---------- #
McPlayerState mp_state

# --------- 机器人形态信息 ---------- #
McFormState form_state

# ----------- Action 信息 ----------- #
McActionInfo action_info

# ---------- 机器人牵手状态 ---------- #
McHandHeldState held_state

# 1 室内模式 2 户外模式 3 超能模式
uint32 mode
float32 mode_speed

# 是否禁止网络播报
bool prohibition_broadcast_net

TaskState task_state

# ---------- 机器人motion信息 ---------- #
string motion

# ----------- 感知环境信息（0室内/1室外）----------- #
uint32 percep_env_state

===== FILE: raw/t1/interfaces/McLocomotionVelocity.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McLocomotionVelocity.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/motion/McLocomotionVelocity.msg
// generated code does not contain a copyright notice

#include "aimdk_msgs/msg/MessageHeader.idl"

module aimdk_msgs {
  module msg {
    @verbatim (language="comment", text=
      "消息头")
    struct McLocomotionVelocity {
      aimdk_msgs::msg::MessageHeader header;

      @verbatim (language="comment", text=
        "输入源")
      string source;

      @verbatim (language="comment", text=
        "前进速度 (m/s)" "\n"
        "方向: +为前进, -为后退")
      double forward_velocity;

      @verbatim (language="comment", text=
        "侧移速度 (m/s)" "\n"
        "方向: +为左移, -为右移")
      double lateral_velocity;

      @verbatim (language="comment", text=
        "旋转速度 (角速度) (m/s)" "\n"
        "方向: +为左旋转, -为右旋转")
      double angular_velocity;

      @verbatim (language="comment", text=
        "弯腰速度 (角速度) (m/s)")
      double pitch_velocity;

      @verbatim (language="comment", text=
        "等级")
      double level;
    };
  };
};


===== FILE: raw/t1/interfaces/AmRequest.srv  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/srv/AmRequest.srv) =====

# ======================================================================
# Arbitration Manager - 任务申请服务
# ======================================================================

CommonRequest header

TokenCommon token_common

# ======================================================================
# 来源类型 (引用 AmSourceType 常量)
# ======================================================================

AmSourceType source_type

# ======================================================================
# 任务信息
# ======================================================================

# 请求方模块
string requester_module

# 请求类型: 0-表示function_name, 1-表示使用request_action_type + request_action_id
uint8 am_mode

# ======================================================================
# 请求动作类型
# - function_name 不为空，使用function_name
# - request_action_id 与 request_action_type 需要配套使用
# ======================================================================

# 功能名
string function_name

# 动作类型: interaction/motion/animation/emotion
string request_action_type

# 动作id: interaction_id/motion_id/animation_id/emotion_id
uint64 request_action_id

# ======================================================================
# 场景与角色
# ======================================================================

# 场景标签
string scene_tag

# 角色名称
string role_name

---

CommonResponse header

# ======================================================================
# 仲裁结果
# ======================================================================

uint8 RESULT_UNKNOWN        = 0   # 未知状态
uint8 RESULT_REJECTED       = 1   # 拒绝
uint8 RESULT_OVERRIDE       = 2   # 抢占成功
uint8 RESULT_CANCELLED      = 3   # 取消成功
uint8 RESULT_SECOND_CONFIRM = 4   # 需要二次确认
uint8 RESULT_SUCCESS        = 5   # 仲裁成功

uint8 arbitration_result

# ======================================================================
# 仲裁拒绝原因: https://primebot.feishu.cn/wiki/EuSewXCAfiKwxzk5FnQcXd4kntf
# ======================================================================

uint32 REASON_SUCCESS          = 0   # 成功
uint32 REASON_OPENBOX          = 1   # 开箱状态中
uint32 REASON_STARTUP_CHECK    = 2   # 开机自检中
uint32 REASON_SHUTDOWN         = 3   # 关机状态中
uint32 REASON_FROM             = 4   # 当前形态不支持
uint32 REASON_LOW_BATTERY      = 5   # 低电量限制
uint32 REASON_CHARGE           = 6   # 正在充电中
uint32 REASON_NO_WHITELIST     = 7   # 动作不在白名单
uint32 REASON_HDS              = 8   # HDS故障
uint32 REASON_ACTION           = 9   # 当前模式不支持
uint32 REASON_OBSTACLE_FORWARD = 10  # 前方有障碍物
uint32 REASON_OBSTACLE_BACK    = 11  # 后方有障碍物
uint32 REASON_OBSTACLE_LEFT    = 12  # 左方有障碍物
uint32 REASON_OBSTACLE_RIGHT   = 13  # 右方有障碍物
uint32 REASON_OBSTACLE_UP      = 14  # 上方有障碍物
uint32 REASON_TASK_RUNNING     = 15  # 其他任务正在运行
uint32 REASON_TARGET_STATE     = 16  # 机器人已经是目标状态

uint32 REASON_NOT_FOUND            = 17   # 未找到相关动作
uint32 REASON_NO_SKILL_LIST        = 18   # 无可用技能列表
uint32 REASON_FORM_MIS_MATCH       = 19   # 无法执行任务，机器人需要处于双足站立状态
uint32 REASON_ACTION_NOT_MATCH     = 20   # 当前动作不匹配，无法执行动画
uint32 REASON_ACTION_BLACKLISTED   = 21   # 前动作在黑名单中，无法执行动画
uint32 REASON_NO_TRANSFER_PATH     = 22   # 当前姿态下无法进行动作转移
uint32 REASON_NO_ELIGIBLE_SKILL    = 23   # 无符合条件的技能

uint32 REASON_INDOOR_WHOLE_BODY    = 24   # 室内模式下暂不支持该动作
uint32 REASON_ENGINE_NOT_READY     = 25   # 动作配置未就绪，无法执行动画
uint32 REASON_NOT_SUPPORTED        = 26   # 当前机型不支持该功能
uint32 REASON_STAND_UP_IN_PROGRESS = 27   # 机器人正在起立，暂不能收起默认动作
uint32 REASON_NOT_INTERRUPTIBLE    = 28   # 当前动画不可打断
uint32 REASON_INTERRUPT_INVALID    = 29   # 当前动画 ID 无效，无法打断
uint32 REASON_TRANSFORM_CONDITION  = 30   # 当前状态不满足变形/动作执行条件
uint32 REASON_APP_DISCONNECTED      = 31   # APP断开连接
uint32 REASON_UPPER_LIMIT           = 32   # 超出上限
uint32 REASON_ROBOT_MOVING          = 33   # 机器人正在移动中
uint32 REASON_FALL_GUARD            = 34   # 跌落风险区域检测命中

uint32 REASON_CLOUD_DISCONNECTED          = 35   # 云端断开连接
uint32 REASON_NETWORK_ABNORMAL            = 36   # 网络异常
uint32 REASON_SYSTEM_STATE                = 37   # 系统状态不支持
uint32 REASON_INVALID_REQUEST             = 38   # 请求参数非法
uint32 REASON_INTERNAL_ERROR              = 39   # 内部错误
uint32 REASON_TASK_NOT_RUNNING            = 40   # 任务未处于运行状态

uint32 REASON_HELD                        = 41   # 机器人被牵手中
uint32 REASON_TASK_NOT_COMMIT             = 42   # 任务完成提交
uint32 REASON_LIGHT_NESS                  = 43   # 光照不足
uint32 REASON_POSTURE_NOT_MATCH           = 44   # 姿态不匹配

uint32 REASON_SWITCH_MAP_FAILED                 = 45   # 使用地图失败
uint32 REASON_MAPPING_START_FAILED              = 46   # 启动建图失败
uint32 REASON_MAPPING_BUSY                      = 47   # 建图任务占用/保存中
uint32 REASON_MAP_SAVE_FAILED                   = 48   # 保存地图失败
uint32 REASON_CHARGE_FRONT_POINT_NOT_FOUND      = 49   # 未找到专座前点
uint32 REASON_MAP_MANAGER_NO_CURRENT_MAP        = 50   # map_manager 无当前地图
uint32 REASON_CHARGE_FRONT_POINT_QUERY_REJECTED = 51   # 查询专座前点被拒绝
uint32 REASON_EMERGENCY_STOP                    = 52   # 系统处于急停中
uint32 REASON_JOYSTICK_CONTROLLING              = 53   # 手柄控制中

uint32 REASON_FILE_ALREADY_EXISTS               = 54   # 已有该名称，请换一个名称

uint32 REASON_BIPED_TO_QUADRUPED_TRANSFORM      = 55   # 背部背着相机
uint32 REASON_MAP_NAME_ALREADY_EXISTS           = 56   # 地图名称已存在
uint32 REASON_MAP_REQUEST_INVALID               = 57   # 地图请求参数非法
uint32 REASON_MAP_RESOURCE_NOT_FOUND            = 58   # 地图资源不存在
uint32 REASON_MAP_RESOURCE_ALREADY_EXISTS       = 59   # 地图资源已存在
uint32 REASON_MAP_DATA_OPERATION_FAILED         = 60   # 地图数据处理失败
uint32 REASON_MAP_OPERATION_NOT_SUPPORTED       = 61   # 地图操作不支持
uint32 REASON_MAPPING_CANCEL_FAILED             = 62   # 取消建图失败

uint32 REASON_SUPER_MODE_FOLLOW_BLOCKED         = 63   # 极限模式下不支持开启跟随

uint32 REASON_MAP_NOT_CURRENT                   = 64   # 请求地图不是当前地图

uint32 REASON_DISK_NO_SPACE                     = 65   # 请求地图不是当前地图

uint32 REASON_ODOM_STATUS_BLOCKED               = 66   # 里程计状态不支持

uint32 arbitration_code

# 仲裁原因
string arbitration_reason

# 扩展信息，JSON 字符串，默认空字符串
# 示例：{"obstacle_confidence":3}
# obstacle_confidence 取值示例：1 低置信度，2 中置信度，3 高置信度
string extra_message

string token


===== FILE: raw/t1/task_engine/rule/follow.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/follow.yaml) =====

# 跟随（AmRequest 仅前置检查；运行态由 FollowTaskCtrl / FollowTask 注册）
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
function_name_aliases: [follow_task]
allow_source: []
allow_velocity_source: []
velocity_source_block_robots: []
# 启动跟随后的目标丢失语音抑制时间
target_lost_voice_suppress_ms: 10000
# 目标丢失防抖时间：室内四足转向较慢，使用更长防抖
target_lost_debounce_biped_ms: 1500
target_lost_debounce_quadruped_indoor_ms: 3000
target_lost_debounce_quadruped_outdoor_ms: 1500
odom_condition:
  require_trusted: true
  allow_untrusted:
    - name: rest_posture_follow_recovery
      odom_status: [ANY]
      mc_action: [PASSIVE_DEFAULT, QUADRUPED_GET_DOWN_DEFAULT, QUADRUPED_SIT_DOWN_DEFAULT]
precondition:
  allow_posture: []
  block_posture: []
  battery_min_percent: 6
  allow_charging_state: false
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
alarm_condition:
  allow_mode: all
  allow_levels: []
  exclude_levels: []
motion_condition:
  allow_motion_state: []
  allow_preempt_running_task: false
# 是否使用 brightness_allow_follow 作为跟随启动的前置判断条件
use_brightness_allow_follow: false
# 跟随启动时的冲突策略
arbitration_policy:
  - task_name: follow
    action: reject     # 智能跟随运行中拒绝
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: parallel     # 与上肢动作并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: navigation
    action: override     # 覆盖室内导航
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: app_teach_demo
    action: reject   # 动作示教运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: localization
    action: override # 覆盖定位
  - task_name: mapping
    action: reject   # 建图运行中拒绝
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/posture.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/posture.yaml) =====

# 姿态变换动作（站起/坐下/趴下/变形等，可在任意姿态下执行）
# 不限制前置姿态，优先级高于 whole_body，允许在任何运动状态下触发。
task_base:
  enable: true
  task_name: posture
  task_type: long_task
  real_task_type: AnimationTask
  behavior_kind: posture_action
  priority: 50
  permission_level: normal
  allow_preempt: true
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source: []
allow_velocity_source: []
velocity_source_block_robots: []
precondition:
  allow_posture: []
  block_posture: []
  battery_min_percent: 0
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
  # 姿态豁免：目标 animation_id 命中时，跳过下方列出的检查项；其余检查照常执行。
  # 取值：battery / charging / app_conn / cloud_conn / network
  # 例：趴下动画(animation_id=4)下放行充电态
  posture_exemptions:
    "4": [battery, charging]
alarm_condition:
  allow_mode: exclude
  allow_levels: []
  exclude_levels: [fatal]
motion_condition:
  allow_motion_state: []
  allow_preempt_running_task: true
arbitration_policy:
  - task_name: move
    action: override     # 移动可打断姿态变换动作
  - task_name: posture
    action: override     # 新姿态动作可打断旧姿态动作
  - task_name: app_teach_demo
    action: reject       # 动作示教运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: override     # 覆盖上肢动作
  - task_name: whole_body
    action: override     # 覆盖全身动作
  - task_name: follow
    action: override     # 覆盖智能跟随
  - task_name: navigation
    action: reject       # 室内导航运行中拒绝
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: override     # 覆盖唤醒反馈
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: override     # 覆盖抚摸响应
  - task_name: app_gyro_ctrl
    action: override     # 覆盖远程遥控
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: localization
    action: reject   # 定位运行中拒绝
  - task_name: mapping
    action: reject   # 建图运行中拒绝
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/whole_body.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/whole_body.yaml) =====

# 全身动作（MC 全身动画，占用完整运控资源）
# 机器人站立或行走时可触发，运行期间不允许移动
task_base:
  enable: true
  task_name: whole_body
  task_type: long_task
  real_task_type: AnimationTask
  behavior_kind: whole_body_action
  priority: 45
  permission_level: normal
  allow_preempt: true
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source: []
allow_velocity_source: []
velocity_source_block_robots: []
precondition:
  allow_posture: []
  block_posture:
    - DAMPING_DEFAULT
    - LYING_DEFAULT
    - LIE_FACE_UP
    - LIE_FACE_DOWN
    - STORE_DEFAULT
  battery_min_percent: 6
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
alarm_condition:
  allow_mode: exclude
  allow_levels: []
  exclude_levels: [fatal]
motion_condition:
  allow_motion_state: [idle, preemptable]
  allow_preempt_running_task: false
  allow_running:
    - name: interruptible_locomotion
      mc_action:
        - QUADRUPED_LOCOMOTION_DEFAULT
        - QUADRUPED_LOCOMOTION_RUN
        - QUADRUPED_LOCOMOTION_TERRAIN
        - BIPED_LOCOMOTION_DEFAULT
        - BIPED_LOCOMOTION_TERRAIN
        - BIPED_LOCOMOTION_RUN
        - BIPED_LOCOMOTION_WBC
      mc_player_state: [PLAYING, PRE_PLAYING, INTERRUPTING]
      require_current_animation_interruptible: false
    - name: interruptible_whole_body_motion
      mc_action:
        - BIPED_MIMIC
        - QUADRUPED_MIMIC
        - QUADRUPED_LOCOMOTION_DANCE
      mc_player_state: [PLAYING, PRE_PLAYING, INTERRUPTING]
      require_current_animation_interruptible: true
arbitration_policy:
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: whole_body
    action: override     # 新全身动作可打断旧全身动作
  - task_name: app_teach_demo
    action: reject       # 动作示教运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: override     # 覆盖上肢动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: follow
    action: reject       # 智能跟随运行中拒绝
  - task_name: navigation
    action: reject       # 室内导航运行中拒绝
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: localization
    action: reject   # 定位运行中拒绝
  - task_name: mapping
    action: reject   # 建图运行中拒绝
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/upper_body.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/upper_body.yaml) =====

# 上肢动作（T1 双足模式下的上半身动画，不影响下半身行走）
# 双足站立姿态下可启动，允许与移动并行执行
task_base:
  enable: true
  task_name: upper_body
  task_type: long_task
  real_task_type: AnimationTask
  behavior_kind: upper_body_action
  priority: 40
  permission_level: normal
  allow_preempt: true
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source: []
allow_velocity_source: []
velocity_source_block_robots: []
precondition:
  allow_posture: []
  block_posture: []
  battery_min_percent: 6
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
alarm_condition:
  allow_mode: exclude
  allow_levels: []
  exclude_levels: [fatal]
motion_condition:
  allow_motion_state: []
  allow_preempt_running_task: false
arbitration_policy:
  - task_name: upper_body
    action: override     # 新上肢动作可打断旧上肢动作
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_teach_demo
    action: reject       # 动作示教运行中拒绝
  - task_name: app_joystick_ctrl
    action: parallel     # 与基础运动操控并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: follow
    action: reject       # 智能跟随运行中拒绝
  - task_name: navigation
    action: reject       # 室内导航运行中拒绝
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: localization
    action: reject   # 定位运行中拒绝
  - task_name: mapping
    action: reject   # 建图运行中拒绝
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/rc_gyro.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/rc_gyro.yaml) =====

# 陀螺仪遥控（长时运动任务，T1 专属四足模式）
# 电量>30%，必须四足站立姿态，运行中独占运控
task_base:
  enable: true
  task_name: app_gyro_ctrl
  task_type: long_task
  real_task_type: RcTask
  behavior_kind: long_task
  priority: 50
  permission_level: normal
  allow_preempt: true
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source:
  - SOURCE_APP
allow_velocity_source: []
velocity_source_block_robots: []
precondition:
  allow_posture: [QUADRUPED_STAND_DEFAULT, QUADRUPED_LOCOMOTION_DEFAULT, QUADRUPED_LOCOMOTION_BIONIC, QUADRUPED_LOCOMOTION_TERRAIN, QUADRUPED_LOCOMOTION_RUN]
  block_posture: []
  battery_min_percent: 30
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: true
  check_cloud_conn: false
  check_network: true
  check_log_sync: false
alarm_condition:
  allow_mode: exclude
  allow_levels: []
  exclude_levels: [fatal, error]
motion_condition:
  allow_motion_state: [idle, preemptable]
  allow_preempt_running_task: false
blocks_direct_rpc: true
arbitration_policy:
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: parallel     # 与上肢动作并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: navigation
    action: override     # 覆盖室内导航
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: app_teach_demo
    action: reject   # 动作示教运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: follow
    action: override # 覆盖智能跟随
  - task_name: localization
    action: override # 覆盖定位
  - task_name: mapping
    action: override # 覆盖建图
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/rc_joystick.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/rc_joystick.yaml) =====

# 摇杆遥控（实时速度信号，高频下发，不记录运行态）
# APP 摇杆为实时控制指令，仅做电量和告警校验
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
allow_velocity_source: []
velocity_source_block_robots: []
precondition:
  allow_posture: []
  block_posture: []
  battery_min_percent: 1
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
alarm_condition:
  allow_mode: exclude
  allow_levels: []
  exclude_levels: [fatal]
motion_condition:
  allow_motion_state: []
  allow_preempt_running_task: false
arbitration_policy:
  - task_name: app_joystick_ctrl
    action: override     # 基础运动操控运行中拒绝
  - task_name: move
    action: override       # 碰撞规避运行中拒绝
  - task_name: upper_body
    action: parallel     # 与上肢动作并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: follow
    action: interrupt    # 暂停智能跟随
  - task_name: navigation
    action: interrupt    # 暂停室内导航
  - task_name: camera_move
    action: override     # 覆盖跟拍运镜
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: override     # 覆盖唤醒反馈
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: override     # T1: 覆盖抚摸响应
  - task_name: app_gyro_ctrl
    action: parallel     # T1: 与远程遥控并行
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: app_teach_demo
    action: reject   # 动作示教运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: localization
    action: interrupt # 定位运行中拒绝
  - task_name: mapping
    action: interrupt # 建图运行中拒绝
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/motion_teach.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/motion_teach.yaml) =====

# 动作示教入口（APP 独占模式，允许手动操控机器人录制/回放姿态）
# 双足站立姿态下才可进入，运行中屏蔽所有其他 AmRequest
task_base:
  enable: true
  task_name: app_teach_demo
  task_type: long_task
  real_task_type: ArrangeTask
  priority: 50
  permission_level: normal
  allow_preempt: true
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source:
  - SOURCE_APP
allow_velocity_source: []
velocity_source_block_robots: []
blocks_direct_rpc: true
precondition:
  allow_posture: [BIPED_STAND_DEFAULT, BIPED_WHOLE_BODY_CTRL, BIPED_LOCOMOTION_WBC, BIPED_RECORD_UPPER]
  block_posture: []
  battery_min_percent: 5
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: true
  check_cloud_conn: false
  check_network: true
  check_log_sync: false
alarm_condition:
  allow_mode: none
  allow_levels: []
  exclude_levels: []
motion_condition:
  allow_motion_state: []
  allow_preempt_running_task: false
arbitration_policy:
  - task_name: app_teach_demo
    action: reject     # 动作示教运行中拒绝
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: parallel     # 与上肢动作并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: navigation
    action: override     # 覆盖室内导航
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: parallel # 与画图模式并行
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: follow
    action: override # 覆盖智能跟随
  - task_name: localization
    action: override # 覆盖定位
  - task_name: mapping
    action: override # 覆盖建图
  - task_name: motion_playback
    action: parallel # 与动作回放并行
  - task_name: motion_record
    action: parallel # 与动作录制并行
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/motion_record.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/motion_record.yaml) =====

# 动作录制（由 RecordMotion Service 注册运行态，录制双足自定义姿态）
task_base:
  enable: true
  task_name: motion_record
  task_type: long_task
  real_task_type: RecordTask
  priority: 60
  permission_level: normal
  allow_preempt: false
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source: []
allow_velocity_source: []
velocity_source_block_robots: []
blocks_direct_rpc: true
precondition:
  allow_posture: [BIPED_STAND_DEFAULT, BIPED_WHOLE_BODY_CTRL, BIPED_LOCOMOTION_WBC, BIPED_RECORD_UPPER]
  block_posture: []
  battery_min_percent: 25
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
alarm_condition:
  allow_mode: none
  allow_levels: []
  exclude_levels: []
motion_condition:
  allow_motion_state: []
  allow_preempt_running_task: false
arbitration_policy:
  - task_name: motion_record
    action: reject     # 动作录制运行中拒绝
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: parallel     # 与上肢动作并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: navigation
    action: override     # 覆盖室内导航
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: parallel # 与画图模式并行
  - task_name: app_teach_demo
    action: parallel # 与动作示教并行
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: follow
    action: override # 覆盖智能跟随
  - task_name: localization
    action: override # 覆盖定位
  - task_name: mapping
    action: override # 覆盖建图
  - task_name: motion_playback
    action: parallel # 与动作回放并行
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/motion_playback.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/motion_playback.yaml) =====

# 动作回放（由 PlayCustomMotion Service 注册运行态）
task_base:
  enable: true
  task_name: motion_playback
  task_type: long_task
  real_task_type: PlayCustomMotionTask
  priority: 60
  permission_level: normal
  allow_preempt: false
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source: []
allow_velocity_source: []
velocity_source_block_robots: []
blocks_direct_rpc: true
precondition:
  allow_posture: [BIPED_STAND_DEFAULT, BIPED_WHOLE_BODY_CTRL, BIPED_LOCOMOTION_WBC]
  block_posture: []
  battery_min_percent: 25
  allow_charging_state: false
  allow_held_state: false  # 牵手状态下拒绝进入
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
alarm_condition:
  allow_mode: none
  allow_levels: []
  exclude_levels: []
motion_condition:
  allow_motion_state: []
  allow_preempt_running_task: false
arbitration_policy:
  - task_name: motion_playback
    action: reject     # 动作回放运行中拒绝
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: parallel     # 与上肢动作并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: navigation
    action: override     # 覆盖室内导航
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: parallel # 与画图模式并行
  - task_name: app_teach_demo
    action: parallel # 与动作示教并行
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: follow
    action: override # 覆盖智能跟随
  - task_name: localization
    action: override # 覆盖定位
  - task_name: mapping
    action: override # 覆盖建图
  - task_name: motion_record
    action: parallel # 与动作录制并行
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/factory_reset.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/factory_reset.yaml) =====

# 恢复出厂设置
# 必须在安全姿态下触发（趴下/躺下/无力/收纳），告警不拦截
task_base:
  enable: true
  task_name: factory_reset
  task_type: short_task
  real_task_type: ""
  priority: 90
  permission_level: normal
  allow_preempt: false
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source:
  - SOURCE_SYSTEM
  - SOURCE_APP
allow_velocity_source: []
velocity_source_block_robots: []
precondition:
  allow_posture: [PASSIVE_DEFAULT, DAMPING_DEFAULT, QUADRUPED_GET_DOWN_DEFAULT, LIE_FACE_DOWN, LIE_FACE_UP, LYING_DEFAULT, STORE_DEFAULT]
  block_posture: []
  battery_min_percent: 20
  allow_charging_state: true
  allow_held_state: false  # 牵手状态下拒绝进入
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
arbitration_policy:
  - task_name: factory_reset
    action: reject     # 出厂重置运行中拒绝
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: parallel     # 与基础运动操控并行
  - task_name: whole_body
    action: override     # 覆盖全身动作（能打断）
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: follow
    action: reject       # 智能跟随运行中拒绝
  - task_name: navigation
    action: reject       # 室内导航运行中拒绝
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: reject       # 抚摸响应运行中拒绝
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: override # 覆盖画图模式
  - task_name: app_teach_demo
    action: override # 覆盖动作示教
  - task_name: localization
    action: reject   # 定位运行中拒绝
  - task_name: mapping
    action: reject   # 建图运行中拒绝
  - task_name: motion_playback
    action: override # 覆盖动作回放
  - task_name: motion_record
    action: override # 覆盖动作录制
  - task_name: shutdown
    action: reject   # 关机运行中拒绝
  - task_name: upper_body
    action: override # 覆盖上肢动作
