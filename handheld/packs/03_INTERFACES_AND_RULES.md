# Pack 03 · 接口与任务门控

重点：`McHandHeldState` 5 态与 `is_held` 语义、`AmRequest REASON_HELD=41`、`McAction` 全枚举（证明没有「牵手」动作）、`SetMcInputSource`（视觉速度源）、14 条任务规则（含 9 条 `allow_held_state:false`）、`follow.yaml` 不拦 held。


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


===== FILE: raw/t1/interfaces/McAction.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McAction.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/action/McAction.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    module McAction_Constants {
      @verbatim (language="comment", text=
        "============================================================================" "\n"        "急停" "\n"        "============================================================================" "\n"        "被动模式")
      const int32 PASSIVE_DEFAULT = 1;
      @verbatim (language="comment", text=
        "阻尼模式")
      const int32 DAMPING_DEFAULT = 2;
      @verbatim (language="comment", text=
        "四足躺下")
      const int32 QUAD_LIE_DOWN = 3;
      @verbatim (language="comment", text=
        "============================================================================" "\n"        "形态切换" "\n"        "============================================================================" "\n"        "四足切换两足形态-常规")
      const int32 QUADRUPED_TO_BIPED = 10;
      @verbatim (language="comment", text=
        "四足切换两足形态-带旋转")
      const int32 QUADRUPED_TO_BIPED_ROTATE = 11;
      @verbatim (language="comment", text=
        "四足切换双足形态-前空翻")
      const int32 QUADRUPED_TO_BIPED_FRONTFLIP = 12;
      @verbatim (language="comment", text=
        "两足切换四足形态-常规")
      const int32 BIPED_TO_QUADRUPED = 20;
      @verbatim (language="comment", text=
        "两足切换四足形态-旋转")
      const int32 BIPED_TO_QUADRUPED_ROTATE = 21;
      @verbatim (language="comment", text=
        "两足切换四足形态-前空翻")
      const int32 BIPED_TO_QUADRUPED_FRONTFLIP = 22;
      @verbatim (language="comment", text=
        "============================================================================" "\n"        "四足相关动作 (100-199)" "\n"        "============================================================================" "\n"        "倒地四足站起")
      const int32 QUADRUPED_RECOVERY = 100;
      @verbatim (language="comment", text=
        "四足站立模式")
      const int32 QUADRUPED_STAND_DEFAULT = 101;
      @verbatim (language="comment", text=
        "四足行走/奔跑模式")
      const int32 QUADRUPED_LOCOMOTION_DEFAULT = 102;
      @verbatim (language="comment", text=
        "四足奔跑模式")
      const int32 QUADRUPED_LOCOMOTION_RUN = 112;
      @verbatim (language="comment", text=
        "四足越障行走模式")
      const int32 QUADRUPED_LOCOMOTION_TERRAIN = 103;
      @verbatim (language="comment", text=
        "四足仿生模式")
      const int32 QUADRUPED_LOCOMOTION_BIONIC = 104;
      @verbatim (language="comment", text=
        "四足前空翻")
      const int32 QUADRUPED_LOCOMOTION_FRONTFLIP = 105;
      @verbatim (language="comment", text=
        "四足后空翻")
      const int32 QUADRUPED_LOCOMOTION_BACKFLIP = 106;
      @verbatim (language="comment", text=
        "四足握手")
      const int32 QUADRUPED_LOCOMOTION_HANDSHAKE = 107;
      @verbatim (language="comment", text=
        "四足坐下")
      const int32 QUADRUPED_LOCOMOTION_SIT = 108;
      @verbatim (language="comment", text=
        "四足跳舞")
      const int32 QUADRUPED_LOCOMOTION_DANCE = 109;
      @verbatim (language="comment", text=
        "四足趴下")
      const int32 QUADRUPED_GET_DOWN_DEFAULT = 110;
      @verbatim (language="comment", text=
        "四足坐下")
      const int32 QUADRUPED_SIT_DOWN_DEFAULT = 111;
      @verbatim (language="comment", text=
        "四足骄傲")
      const int32 QUADRUPED_LOCOMOTION_PRIDE = 113;
      @verbatim (language="comment", text=
        "四足愉快")
      const int32 QUADRUPED_LOCOMOTION_PLEASURE = 114;
      @verbatim (language="comment", text=
        "四足准备站立")
      const int32 QUADRUPED_READY_STAND_DEFAULT = 115;
      @verbatim (language="comment", text=
        "四足跳跃")
      const int32 QUADRUPED_LOCOMOTION_JUMP = 116;
      @verbatim (language="comment", text=
        "四足伸展")
      const int32 QUADRUPED_LOCOMOTION_STRETCH = 117;
      @verbatim (language="comment", text=
        "四足俯卧撑")
      const int32 QUADRUPED_PUSH_UP = 118;
      @verbatim (language="comment", text=
        "四足模仿动作")
      const int32 QUADRUPED_MIMIC = 119;
      @verbatim (language="comment", text=
        "四足蜷缩")
      const int32 QUADRUPED_CROUCH_DEFAULT = 120;
      @verbatim (language="comment", text=
        "四足踏步模式")
      const int32 QUADRUPED_LOCOMOTION_STEP = 121;
      @verbatim (language="comment", text=
        "四足前肢手臂反轴站立")
      const int32 QUADRUPED_STAND_REVERSE_DEFAULT = 122;
      @verbatim (language="comment", text=
        "四足反向行走模式")
      const int32 QUADRUPED_LOCOMOTION_REVERSE_DEFAULT = 123;
      @verbatim (language="comment", text=
        "四足姿态调整")
      const int32 QUADRUPED_BODY_ADJUST_DEFAULT = 124;
      @verbatim (language="comment", text=
        "============================================================================" "\n"        "两足相关动作 (200-299)" "\n"        "============================================================================" "\n"        "倒地两足站起")
      const int32 BIPED_RECOVERY = 200;
      @verbatim (language="comment", text=
        "两足站立模式")
      const int32 BIPED_STAND_DEFAULT = 201;
      @verbatim (language="comment", text=
        "两足行走/奔跑模式")
      const int32 BIPED_LOCOMOTION_DEFAULT = 202;
      @verbatim (language="comment", text=
        "两足越障行走模式")
      const int32 BIPED_LOCOMOTION_TERRAIN = 203;
      @verbatim (language="comment", text=
        "双足原地旋转(删除)" "\n"        "int32 BIPED_LOCOMOTION_ROTATE_LOCAL = 204" "\n"        "双足下腰模式(删除)" "\n"        "int32 BIPED_LOCOMOTION_BACKBEND = 205" "\n"        "双足太空步")
      const int32 BIPED_LOCOMOTION_MOONWALK = 206;
      @verbatim (language="comment", text=
        "双足奔跑模式")
      const int32 BIPED_LOCOMOTION_RUN = 207;
      @verbatim (language="comment", text=
        "双足模仿动作")
      const int32 BIPED_MIMIC = 208;
      @verbatim (language="comment", text=
        "双足羽生结弦(删除)" "\n"        "int32 BIPED_YUZURU = 209" "\n"        "双足劈叉(删除)" "\n"        "int32 BIPED_SPLIT = 210" "\n"        "双足全身控制模式")
      const int32 BIPED_LOCOMOTION_WBC = 300;
      @verbatim (language="comment", text=
        "双足动画控制模式")
      const int32 BIPED_LOCOMOTION_ANIMATION = 301;
      @verbatim (language="comment", text=
        "双足控制上肢录制模式")
      const int32 BIPED_RECORD_UPPER = 302;
      @verbatim (language="comment", text=
        "双足 gimbal 轨迹移动模式")
      const int32 BIPED_GIMBAL = 303;
      @verbatim (language="comment", text=
        "双足 npz 模仿")
      const int32 BIPED_NPZ_MIMIC = 304;
      @verbatim (language="comment", text=
        "双足小彩旗")
      const int32 BIPED_LOCOMOTION_WBCDANCE = 305;
      @verbatim (language="comment", text=
        "双足转圈(删除)" "\n"        "int32 BIPED_MIMIC_ROTATE_DANCE = 400" "\n"        "============================================================================" "\n"        "Q 系列Action" "\n"        "============================================================================" "\n"        "折叠收储")
      const int32 STORE_DEFAULT = 1001;
      @verbatim (language="comment", text=
        "走跑")
      const int32 BIPED_WALK_RUN = 1002;
      @verbatim (language="comment", text=
        "模仿动作")
      const int32 MIMIC = 1003;
      @verbatim (language="comment", text=
        "模仿动作-灵创")
      const int32 MIMIC_LINKCRAFT = 1004;
      @verbatim (language="comment", text=
        "全身动作控制")
      const int32 BIPED_WHOLE_BODY_CTRL = 1005;
      @verbatim (language="comment", text=
        "模仿动作-开源")
      const int32 MIMIC_OPENSOURCE = 1006;
      @verbatim (language="comment", text=
        "站起")
      const int32 STAND_UP = 1007;
      @verbatim (language="comment", text=
        "躺姿")
      const int32 LYING_DEFAULT = 1008;
      @verbatim (language="comment", text=
        "躺下-俯卧")
      const int32 LIE_FACE_DOWN = 1009;
      @verbatim (language="comment", text=
        "躺下-仰躺")
      const int32 LIE_FACE_UP = 1010;
      @verbatim (language="comment", text=
        "轻柔步态(室内)")
      const int32 BIPED_QUIET_WALK = 1011;
      @verbatim (language="comment", text=
        "越障模式(室外)")
      const int32 BIPED_BLIND_TERRAIN = 1012;
      @verbatim (language="comment", text=
        "坐下")
      const int32 BIPED_SIT_DOWN = 1013;
      @verbatim (language="comment", text=
        "二开上肢控制")
      const int32 BIPED_CUSTOM_UPPER = 1014;
      @verbatim (language="comment", text=
        "超能模式/跑步模式")
      const int32 BIPED_RUN = 1015;
      @verbatim (language="comment", text=
        "入座")
      const int32 BIPED_TAKE_SEAT = 1016;
      @verbatim (language="comment", text=
        "离座")
      const int32 BIPED_LEAVE_SEAT = 1017;
      @verbatim (language="comment", text=
        "模仿动作_V2")
      const int32 MIMIC_V2 = 1018;
      @verbatim (language="comment", text=
        "模仿动作-开源_V2")
      const int32 MIMIC_OPENSOURCE_V2 = 1019;
    };
    @verbatim (language="comment", text=
      "定义枚举字段")
    struct McAction {
      int32 value;
    };
  };
};


===== FILE: raw/t1/interfaces/McActionInfo.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McActionInfo.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/action/McActionInfo.msg
// generated code does not contain a copyright notice

#include "aimdk_msgs/msg/McAction.idl"
#include "aimdk_msgs/msg/McActionStatus.idl"

module aimdk_msgs {
  module msg {
    @verbatim (language="comment", text=
      "当前运行的Action")
    struct McActionInfo {
      aimdk_msgs::msg::McAction current_action;

      @verbatim (language="comment", text=
        "当前action的触发源")
      string source;

      @verbatim (language="comment", text=
        "描述")
      string action_desc;

      @verbatim (language="comment", text=
        "Action状态")
      aimdk_msgs::msg::McActionStatus status;

      @verbatim (language="comment", text=
        "action 切换是否就绪, false 未准备就绪, true 切换就绪")
      boolean switch_ready;
    };
  };
};


===== FILE: raw/t1/interfaces/McActionStatus.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McActionStatus.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/action/McActionStatus.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    module McActionStatus_Constants {
      @verbatim (language="comment", text=
        "未知状态")
      const int32 IDLE = 0;
      @verbatim (language="comment", text=
        "运行中")
      const int32 RUNNING = 100;
      @verbatim (language="comment", text=
        "切换中")
      const int32 TRANSITION = 200;
    };
    @verbatim (language="comment", text=
      "定义枚举字段")
    struct McActionStatus {
      int32 value;
    };
  };
};


===== FILE: raw/t1/interfaces/McMotionStatus.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McMotionStatus.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/data/msg/common/McMotionStatus.msg
// generated code does not contain a copyright notice

#include "aimdk_msgs/msg/McControlArea.idl"
#include "aimdk_msgs/msg/McMotionIntrInfo.idl"
#include "aimdk_msgs/msg/McMotionType.idl"
#include "aimdk_msgs/msg/McPlayerState.idl"

module aimdk_msgs {
  module msg {
    @verbatim (language="comment", text=
      "-----------------------------------------------------------------------------------" "\n"
      "机器人运控状态 - 动作运行信息" "\n"
      "-----------------------------------------------------------------------------------")
    struct McMotionStatus {
      @verbatim (language="comment", text=
        "动作运行状态")
      aimdk_msgs::msg::McPlayerState player_state;

      @verbatim (language="comment", text=
        "控制区域")
      aimdk_msgs::msg::McControlArea control_area;

      @verbatim (language="comment", text=
        "动作名称")
      string motion;

      @verbatim (language="comment", text=
        "动作类型")
      aimdk_msgs::msg::McMotionType type;

      @verbatim (language="comment", text=
        "动作断点信息")
      aimdk_msgs::msg::McMotionIntrInfo intr_info;

      @verbatim (language="comment", text=
        "当前动作执行进度")
      int32 current_steps;
    };
  };
};


===== FILE: raw/t1/interfaces/McMotionType.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McMotionType.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/motion/McMotionType.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    module McMotionType_Constants {
      @verbatim (language="comment", text=
        "NONE")
      const int32 NONE = 0;
      @verbatim (language="comment", text=
        "动画，上肢动作")
      const int32 ANIMATION = 1;
      @verbatim (language="comment", text=
        "模仿")
      const int32 MIMIC = 2;
      @verbatim (language="comment", text=
        "基座")
      const int32 FOUNDATION = 3;
      @verbatim (language="comment", text=
        "运动跟踪")
      const int32 MIMIC_OPENSOURCE = 4;
    };
    struct McMotionType {
      int32 value;
    };
  };
};


===== FILE: raw/t1/interfaces/McControlArea.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McControlArea.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/motion/McControlArea.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    module McControlArea_Constants {
      @verbatim (language="comment", text=
        "没有控制区域")
      const int32 NONE = 0;
      @verbatim (language="comment", text=
        "左手")
      const int32 LEFT_HAND = 1;
      @verbatim (language="comment", text=
        "右手")
      const int32 RIGHT_HAND = 2;
      @verbatim (language="comment", text=
        "头部")
      const int32 HEAD = 4;
      @verbatim (language="comment", text=
        "腰部")
      const int32 WAIST = 8;
    };
    struct McControlArea {
      int32 value;
    };
  };
};


===== FILE: raw/t1/interfaces/McPlayerState.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McPlayerState.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/motion/McPlayerState.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    module McPlayerState_Constants {
      @verbatim (language="comment", text=
        "无上肢动作")
      const uint32 IDLE = 0;
      @verbatim (language="comment", text=
        "IDLE 过渡至下一动作")
      const uint32 PRE_PLAYING = 1;
      @verbatim (language="comment", text=
        "上肢动作正在播放")
      const uint32 PLAYING = 2;
      @verbatim (language="comment", text=
        "打断当前动作过渡至下一动作")
      const uint32 INTERRUPTING = 3;
      @verbatim (language="comment", text=
        "播放错误状态")
      const uint32 ERROR = 4;
    };
    @verbatim (language="comment", text=
      "-----------------------------------------------------------------------------------" "\n"
      "机器人运控状态 - 上肢动作运行状态" "\n"
      "-----------------------------------------------------------------------------------")
    struct McPlayerState {
      uint32 value;
    };
  };
};


===== FILE: raw/t1/interfaces/McInputSource.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McInputSource.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/motion/McInputSource.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    @verbatim (language="comment", text=
      "-----------------------------------------------------------------------------------" "\n"
      "机器人运控状态 - 输入源信息" "\n"
      "-----------------------------------------------------------------------------------")
    struct McInputSource {
      @verbatim (language="comment", text=
        "输入源名称（rc/vr/app_proxy/interaction/pnc）")
      string name;

      @verbatim (language="comment", text=
        "输入源优先级(0-100)")
      int32 priority;

      @verbatim (language="comment", text=
        "超时时间(ms), 默认 1000 ms")
      int32 timeout;
    };
  };
};


===== FILE: raw/t1/interfaces/SetMcInputSource.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/srv/SetMcInputSource.idl) =====

// generated from rosidl_adapter/resource/srv.idl.em
// with input from aimdk_msgs/mc/motion/srv/SetMcInputSource.srv
// generated code does not contain a copyright notice

#include "aimdk_msgs/msg/CommonRequest.idl"
#include "aimdk_msgs/msg/CommonTaskResponse.idl"
#include "aimdk_msgs/msg/McInputAction.idl"
#include "aimdk_msgs/msg/McInputSource.idl"

module aimdk_msgs {
  module srv {
    @verbatim (language="comment", text=
      "Request 部分")
    struct SetMcInputSource_Request {
      aimdk_msgs::msg::CommonRequest request;

      @verbatim (language="comment", text=
        "ADD MODIFY DELETE DISABLE ENABLE")
      aimdk_msgs::msg::McInputAction action;

      aimdk_msgs::msg::McInputSource input_source;
    };
    struct SetMcInputSource_Response {
      aimdk_msgs::msg::CommonTaskResponse response;
    };
  };
};


===== FILE: raw/t1/interfaces/SetMcInputSource.srv  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/srv/SetMcInputSource.srv) =====

# Request 部分
CommonRequest request

McInputAction action # ADD MODIFY DELETE DISABLE ENABLE

McInputSource input_source
---

CommonTaskResponse response


===== FILE: raw/t1/interfaces/SetMcInputSource_Request.msg  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/srv/SetMcInputSource_Request.msg) =====

# Request 部分
CommonRequest request

McInputAction action # ADD MODIFY DELETE DISABLE ENABLE

McInputSource input_source


===== FILE: raw/t1/interfaces/SetMcAction.srv  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/srv/SetMcAction.srv) =====

# 请求头
RequestHeader header

# 触发源 定义见 McTaskSource.msg 
string source

# Action命令
McActionCommand command

---

CommonTaskResponse response


===== FILE: raw/t1/interfaces/JointCommand.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/JointCommand.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/hal/msg/JointCommand.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    struct JointCommand {
      string name;

      double position;

      double velocity;

      double effort;

      double stiffness;

      double damping;
    };
  };
};


===== FILE: raw/t1/interfaces/JointState.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/JointState.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/hal/msg/JointState.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    struct JointState {
      string name;

      double position;

      double velocity;

      double effort;

      int16 coil_temp;

      int16 motor_temp;

      uint8 motor_vol;
    };
  };
};


===== FILE: raw/t1/interfaces/McPresetMotion.idl  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/interface/aimdk_msgs/share/aimdk_msgs/msg/McPresetMotion.idl) =====

// generated from rosidl_adapter/resource/msg.idl.em
// with input from aimdk_msgs/mc/motion/McPresetMotion.msg
// generated code does not contain a copyright notice


module aimdk_msgs {
  module msg {
    module McPresetMotion_Constants {
      @verbatim (language="comment", text=
        "恢复默认姿态")
      const int32 DEFAULT_POS = 0;
      @verbatim (language="comment", text=
        "右手挥手")
      const int32 RIGHT_ARM_WAVE = 1001;
      @verbatim (language="comment", text=
        "右手握手")
      const int32 RIGHT_ARM_HANDSHAKE = 1002;
      @verbatim (language="comment", text=
        "左手握手1.5m上对象")
      const int32 RIGHT_ARM_HANDSHAKE_FOR_1D5METER = 1003;
      @verbatim (language="comment", text=
        "左手挥手")
      const int32 LEFT_ARM_WAVE = 1011;
      @verbatim (language="comment", text=
        "左手握手")
      const int32 LEFT_ARM_HANDSHAKE = 1012;
      @verbatim (language="comment", text=
        "左手握手1.5m上对象")
      const int32 LEFT_ARM_HANDSHAKE_FOR_1D5METER = 1013;
      @verbatim (language="comment", text=
        "双手比心")
      const int32 BOTH_HANDS_MAKE_HEART = 2001;
      @verbatim (language="comment", text=
        "双手摆动，表达喜悦")
      const int32 BOTH_HANDS_ACTION_HAPPY = 2002;
      @verbatim (language="comment", text=
        "双手动作，说话动作")
      const int32 BOTH_HANDS_ACTION_TALKING = 2003;
      @verbatim (language="comment", text=
        "说话动作1")
      const int32 T1_TALK1 = 2004;
      @verbatim (language="comment", text=
        "说话动作2")
      const int32 T1_TALK2 = 2005;
      @verbatim (language="comment", text=
        "说话动作3")
      const int32 T1_TALK3 = 2006;
      @verbatim (language="comment", text=
        "说话动作4")
      const int32 T1_TALK4 = 2007;
      @verbatim (language="comment", text=
        "说话动作5")
      const int32 T1_TALK5 = 2008;
      @verbatim (language="comment", text=
        "说话动作6")
      const int32 T1_TALK6 = 2009;
      @verbatim (language="comment", text=
        "拍照动作1")
      const int32 PHOTO_POSE_1 = 2011;
      @verbatim (language="comment", text=
        "拍照动作2")
      const int32 PHOTO_POSE_2 = 2012;
      @verbatim (language="comment", text=
        "拍照动作3")
      const int32 PHOTO_POSE_3 = 2013;
      @verbatim (language="comment", text=
        "拍照动作4")
      const int32 PHOTO_POSE_4 = 2014;
      @verbatim (language="comment", text=
        "三连拍姿势")
      const int32 PHOTO_THREE_SHOT = 2020;
      @verbatim (language="comment", text=
        "-----------------------------------------------------------------------------------" "\n"        "Q 预置的上肢动作" "\n"        "-----------------------------------------------------------------------------------" "\n"        "招手")
      const int32 Q_BECKON = 3001;
      @verbatim (language="comment", text=
        "握手")
      const int32 Q_SHAKE_HANDS = 3002;
      @verbatim (language="comment", text=
        "碰拳")
      const int32 Q_BUMP_FISTS = 3003;
      @verbatim (language="comment", text=
        "挥手")
      const int32 Q_WAVE_HAND = 3004;
      @verbatim (language="comment", text=
        "情绪动作 - 开心")
      const int32 Q_SHOW_HAPPINESS = 3005;
      @verbatim (language="comment", text=
        "双手比心")
      const int32 Q_MAKE_HEART = 3007;
      @verbatim (language="comment", text=
        "加油")
      const int32 Q_CHEER_ON = 3008;
      @verbatim (language="comment", text=
        "伸懒腰")
      const int32 Q_STRETCH = 3010;
      @verbatim (language="comment", text=
        "讲话动作A")
      const int32 Q_SPEAK_A = 3012;
      @verbatim (language="comment", text=
        "讲话动作B")
      const int32 Q_SPEAK_B = 3013;
      @verbatim (language="comment", text=
        "讲话动作C")
      const int32 Q_SPEAK_C = 3014;
      @verbatim (language="comment", text=
        "拥抱")
      const int32 Q_HUG = 3018;
      @verbatim (language="comment", text=
        "拒绝")
      const int32 Q_REFUSE = 3021;
      @verbatim (language="comment", text=
        "跳舞动作A")
      const int32 Q_DANCE_A = 3046;
      @verbatim (language="comment", text=
        "跳舞动作B")
      const int32 Q_DANCE_B = 3047;
      @verbatim (language="comment", text=
        "跳舞动作C")
      const int32 Q_DANCE_C = 3048;
    };
    @verbatim (language="comment", text=
      "预设动作")
    struct McPresetMotion {
      int32 value;
    };
  };
};


===== FILE: raw/t1/interfaces/MC_INTERFACE_CATALOG.md  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/05_GPT架构评审/input_bundle/evidence/interfaces/MC_INTERFACE_CATALOG.md) =====

# MC Interface Catalog

> 由 `aimdk_msgs/share/aimdk_msgs/{action,common,motion,msg,srv}` 下与 MC/关节相关的 `.msg`/`.srv` 原文拼接生成。
> 这是 T1 真机接口语义的直接证据，不等于 `libmc_common_runner.so` 的 C++ ABI。

## action

### action/McAction.msg

```text
# 定义枚举字段
int32 value

# ============================================================================
# 急停
# ============================================================================

# 被动模式
int32 PASSIVE_DEFAULT = 1

# 阻尼模式
int32 DAMPING_DEFAULT = 2

# 四足躺下
int32 QUAD_LIE_DOWN = 3

# ============================================================================
# 形态切换
# ============================================================================

# 四足切换两足形态-常规
int32 QUADRUPED_TO_BIPED = 10

# 四足切换两足形态-带旋转
int32 QUADRUPED_TO_BIPED_ROTATE = 11

# 四足切换双足形态-前空翻
int32 QUADRUPED_TO_BIPED_FRONTFLIP = 12

# 两足切换四足形态-常规
int32 BIPED_TO_QUADRUPED = 20

# 两足切换四足形态-旋转
int32 BIPED_TO_QUADRUPED_ROTATE = 21

# 两足切换四足形态-前空翻
int32 BIPED_TO_QUADRUPED_FRONTFLIP = 22

# ============================================================================
# 四足相关动作 (100-199)
# ============================================================================

# 倒地四足站起
int32 QUADRUPED_RECOVERY = 100

# 四足站立模式
int32 QUADRUPED_STAND_DEFAULT = 101

# 四足行走/奔跑模式
int32 QUADRUPED_LOCOMOTION_DEFAULT = 102

# 四足奔跑模式
int32 QUADRUPED_LOCOMOTION_RUN = 112

# 四足越障行走模式
int32 QUADRUPED_LOCOMOTION_TERRAIN = 103

# 四足仿生模式
int32 QUADRUPED_LOCOMOTION_BIONIC = 104

# 四足前空翻
int32 QUADRUPED_LOCOMOTION_FRONTFLIP = 105

# 四足后空翻
int32 QUADRUPED_LOCOMOTION_BACKFLIP = 106

# 四足握手
int32 QUADRUPED_LOCOMOTION_HANDSHAKE = 107

# 四足坐下
int32 QUADRUPED_LOCOMOTION_SIT = 108

# 四足跳舞
int32 QUADRUPED_LOCOMOTION_DANCE = 109

# 四足趴下
int32 QUADRUPED_GET_DOWN_DEFAULT = 110

# 四足坐下
int32 QUADRUPED_SIT_DOWN_DEFAULT = 111

# 四足骄傲
int32 QUADRUPED_LOCOMOTION_PRIDE = 113

# 四足愉快
int32 QUADRUPED_LOCOMOTION_PLEASURE = 114

# 四足准备站立
int32 QUADRUPED_READY_STAND_DEFAULT = 115

# 四足跳跃
int32 QUADRUPED_LOCOMOTION_JUMP = 116

# 四足伸展
int32 QUADRUPED_LOCOMOTION_STRETCH = 117

# 四足俯卧撑
int32 QUADRUPED_PUSH_UP = 118

# 四足模仿动作
int32 QUADRUPED_MIMIC = 119

# 四足蜷缩
int32 QUADRUPED_CROUCH_DEFAULT = 120

# 四足踏步模式
int32 QUADRUPED_LOCOMOTION_STEP = 121

# 四足前肢手臂反轴站立
int32 QUADRUPED_STAND_REVERSE_DEFAULT = 122

# 四足反向行走模式
int32 QUADRUPED_LOCOMOTION_REVERSE_DEFAULT = 123

# 四足姿态调整
int32 QUADRUPED_BODY_ADJUST_DEFAULT = 124


# ============================================================================
# 两足相关动作 (200-299)
# ============================================================================

# 倒地两足站起
int32 BIPED_RECOVERY = 200

# 两足站立模式
int32 BIPED_STAND_DEFAULT = 201

# 两足行走/奔跑模式
int32 BIPED_LOCOMOTION_DEFAULT = 202

# 两足越障行走模式
int32 BIPED_LOCOMOTION_TERRAIN = 203

# 双足原地旋转(删除)
# int32 BIPED_LOCOMOTION_ROTATE_LOCAL = 204

# 双足下腰模式(删除)
# int32 BIPED_LOCOMOTION_BACKBEND = 205

# 双足太空步
int32 BIPED_LOCOMOTION_MOONWALK = 206

# 双足奔跑模式
int32 BIPED_LOCOMOTION_RUN = 207

# 双足模仿动作
int32 BIPED_MIMIC = 208

# 双足羽生结弦(删除)
# int32 BIPED_YUZURU = 209

# 双足劈叉(删除)
# int32 BIPED_SPLIT = 210

# 双足全身控制模式
int32 BIPED_LOCOMOTION_WBC = 300

# 双足动画控制模式
int32 BIPED_LOCOMOTION_ANIMATION = 301

# 双足控制上肢录制模式
int32 BIPED_RECORD_UPPER = 302

# 双足 gimbal 轨迹移动模式
int32 BIPED_GIMBAL = 303

# 双足 npz 模仿
int32 BIPED_NPZ_MIMIC = 304

# 双足小彩旗
int32 BIPED_LOCOMOTION_WBCDANCE = 305

# 双足转圈(删除)
# int32 BIPED_MIMIC_ROTATE_DANCE = 400

# ============================================================================
# Q 系列Action
# ============================================================================

# 折叠收储
int32 STORE_DEFAULT = 1001

# 走跑
int32 BIPED_WALK_RUN = 1002

# 模仿动作
int32 MIMIC = 1003

# 模仿动作-灵创
int32 MIMIC_LINKCRAFT = 1004

# 全身动作控制
int32 BIPED_WHOLE_BODY_CTRL = 1005

# 模仿动作-开源
int32 MIMIC_OPENSOURCE = 1006

# 站起
int32 STAND_UP = 1007

# 躺姿
int32 LYING_DEFAULT = 1008

# 躺下-俯卧
int32 LIE_FACE_DOWN = 1009

# 躺下-仰躺
int32 LIE_FACE_UP = 1010

# 轻柔步态(室内)
int32 BIPED_QUIET_WALK = 1011

# 越障模式(室外)
int32 BIPED_BLIND_TERRAIN = 1012

# 坐下
int32 BIPED_SIT_DOWN = 1013

# 二开上肢控制
int32 BIPED_CUSTOM_UPPER = 1014

# 超能模式/跑步模式
int32 BIPED_RUN = 1015

# 入座
int32 BIPED_TAKE_SEAT = 1016

# 离座
int32 BIPED_LEAVE_SEAT = 1017

# 模仿动作_V2
int32 MIMIC_V2 = 1018

# 模仿动作-开源_V2
int32 MIMIC_OPENSOURCE_V2 = 1019
```

### action/McActionCommand.msg

```text
# Action
McAction action

# 描述
string action_desc
```

### action/McActionInfo.msg

```text
# 当前运行的Action
McAction current_action

# 当前action的触发源
string source

# 描述
string action_desc

# Action状态
McActionStatus status

# action 切换是否就绪, false 未准备就绪, true 切换就绪
bool switch_ready
```

### action/McActionStatus.msg

```text
# 定义枚举字段
int32 value

# 未知状态
int32 IDLE = 0

# 运行中
int32 RUNNING = 100

# 切换中
int32 TRANSITION = 200
```

## common

### common/CommonTaskResponse.msg

```text
# 响应头
ResponseHeader header

# 任务ID
uint64 task_id

# 状态
CommonState state
```

### common/McFormState.msg

```text
# -----------------------------------------------------------------------------------
# 机器人运控状态 - 机器人形态
# -----------------------------------------------------------------------------------

uint8 current_form

# 未知形态
uint8 UNKNOWN = 0

# 四足形态
uint8 QUADRUPEDAL = 1

# 双足形态
uint8 BIPEDAL = 2
```

### common/McFsmState.msg

```text
# -----------------------------------------------------------------------------------
# 机器人运控状态 - 有限状态机状态
# -----------------------------------------------------------------------------------

uint32 current_state

# 未知状态
uint32 UNKNOWN = 0

# 预备状态
uint32 STARTING = 1

# 原地稳定状态
uint32 STABLE = 2

# 行走状态
uint32 MOVING = 3

# 安全状态
uint32 SAFE = 4

# 特殊状态
uint32 SPECIAL = 5

# 测试状态
uint32 TEST = 6
```

### common/McHandHeldState.msg

```text
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
```

### common/McLiftState.msg

```text
# -----------------------------------------------------------------------------------
# Lift detector detailed state
# -----------------------------------------------------------------------------------

# Whether lift has been triggered and latched by the detector.
bool is_lifted

# Lift probability after logit smoothing and sigmoid.
float32 probability

# Probability threshold used by the detector.
float32 threshold
```

### common/McMotionStatus.msg

```text
# -----------------------------------------------------------------------------------
# 机器人运控状态 - 动作运行信息
# -----------------------------------------------------------------------------------

McPlayerState player_state             # 动作运行状态

McControlArea control_area             # 控制区域

string motion                          # 动作名称

McMotionType type                      # 动作类型

McMotionIntrInfo intr_info             # 动作断点信息

int32 current_steps                    # 当前动作执行进度
```

### common/McPosture.msg

```text
# -----------------------------------------------------------------------------------
# 机器人姿态信息
# -----------------------------------------------------------------------------------

# 横滚角
float64 roll

# 俯仰角
float64 pitch

# 航向角
float64 yaw
```

### common/McSquatStatus.msg

```text
# -----------------------------------------------------------------------------------
# 机器人运控状态 - 下蹲动作运行状态
# -----------------------------------------------------------------------------------
bool enable                             # 是否处于下蹲状态

float64 offset                          # 下蹲高度偏置         

uint32 squat_limit                      # 下蹲上下限位

# squat_limit = 0 - 未到限位
# squat_limit = 1 - 下蹲到下限
# squat_limit = 2 - 下蹲到上限
```

### common/McTaskInfo.msg

```text
# 任务 ID (0 表示未曾接收过任何请求)
uint64 task_id
```

### common/McTaskSource.msg

```text
# 定义 Action 触发源
int32 value

# 未知/未指定
int32 UNKNOWN     = 0

# APP
int32 APP         = 1

# 云端
int32 CLOUD       = 2

# 遥控器
int32 RC          = 3

# SDK/RPC 直接调用
int32 SDK_RPC     = 4

# agent
int32  AGENT  = 5

# task engine 自动任务
int32 TASK_ENGINE   = 6

# MC 内部自动切换（如 Moving → Stable 稳态复位）
int32 MC_INTERNAL = 7

# Insta360
int32 INSTA360 = 8

# 其他
int32 OTHER       = 255
```

## motion

### motion/McBodyPose.msg

```text
# 消息头
MessageHeader header

# 输入源
string source

# 站立高度 (站直/下蹲)， 正值站立， 负值下蹲
# 单位：m，距离地面的高度
float64 stand_height

# 身体前倾/后倾, 正值前倾， 负值后倾
# 单位：rad
float64 bend_forward

# 身体侧弯, 正值左侧弯， 负值右侧弯
# 单位：rad
float64 bend_sideways

# 腰部旋转， 正值左转， 负值右转
# 单位：rad
float64 twist_waist

# 点头/抬头，正值低头，负值抬头
# 单位：rad
float64 raise_head

# 头部旋转，正值左转，负值右转
# 单位：rad
float64 turn_head
```

### motion/McControlArea.msg

```text
int32 value

# 没有控制区域
int32 NONE = 0

# 左手
int32 LEFT_HAND = 1

# 右手
int32 RIGHT_HAND = 2

# 头部
int32 HEAD = 4

# 腰部
int32 WAIST = 8
```

### motion/McCustomJointCommand.msg

```text
# 消息头
MessageHeader header

# 上肢关节目标命令数组（mc内部自动按 name 匹配对应关节数据）
JointCommand[] joints
```

### motion/McHandStatus.msg

```text
# 手部状态

int32 value

# 灵巧手
int32 OMNI_HAND = 1000

# 夹爪
int32 OMNI_PICKER = 2000
```

### motion/McInputAction.msg

```text
# 输入源操作

int32 value

# 添加新的输入源
int32 INPUTACTION_ADD = 1001

# 修改输入源配置
int32 INPUTACTION_MODIFY = 1002

# 删除输入源
int32 INPUTACTION_DELETE = 1003

# 使能输入源
int32 INPUTACTION_ENABLE = 2001

# 下使能输入源
int32 INPUTACTION_DISABLE = 2002
```

### motion/McInputSource.msg

```text
# -----------------------------------------------------------------------------------
# 机器人运控状态 - 输入源信息
# -----------------------------------------------------------------------------------

string name                           # 输入源名称（rc/vr/app_proxy/interaction/pnc）

int32 priority                       # 输入源优先级(0-100)

int32 timeout                        # 超时时间(ms), 默认 1000 ms
```

### motion/McLocomotionGaitType.msg

```text
int32 value

# 步态: 走
int32 WALK = 0

# 步态: 站
int32 STANCE = 1

# 步态: 原地踏步
int32 STATIC_WALK = 2
```

### motion/McLocomotionVelocity.msg

```text
# 消息头
MessageHeader header

# 输入源
string source

# 前进速度 (m/s)
# 方向: +为前进, -为后退
float64 forward_velocity

# 侧移速度 (m/s)
# 方向: +为左移, -为右移
float64 lateral_velocity

# 旋转速度 (角速度) (m/s)
# 方向: +为左旋转, -为右旋转
float64 angular_velocity

# 弯腰速度 (角速度) (m/s) 
float64 pitch_velocity

# 等级
float64 level
```

### motion/McMotion.msg

```text
# Mc 动作接口

# 名称
string tag

# 动作类型
McMotionType type

# 打断信息
McMotionIntrInfo intr_info
```

### motion/McMotionIntrInfo.msg

```text
# -----------------------------------------------------------------------------------
# 动作断点信息
# -----------------------------------------------------------------------------------

# 打断类型
McMotionIntrType intr_type

# 断点列表
int32[] breakpoint_steps
```

### motion/McMotionIntrType.msg

```text
# 定义枚举字段
int32 value

# 不支持打断
int32 INTR_NO = 0

# 自由打断，任意时刻
int32 INTR_FREE = 1

# 断点打断
int32 INTR_BREAKPOINT = 2
```

### motion/McMotionType.msg

```text
int32 value

# NONE
int32 NONE = 0

# 动画，上肢动作
int32 ANIMATION = 1

# 模仿
int32 MIMIC = 2

# 基座
int32 FOUNDATION = 3

# 运动跟踪
int32 MIMIC_OPENSOURCE = 4
```

### motion/McPlayerState.msg

```text
# -----------------------------------------------------------------------------------
# 机器人运控状态 - 上肢动作运行状态
# -----------------------------------------------------------------------------------

uint32 value

# 无上肢动作
uint32 IDLE = 0

# IDLE 过渡至下一动作
uint32 PRE_PLAYING = 1

# 上肢动作正在播放
uint32 PLAYING = 2

# 打断当前动作过渡至下一动作
uint32 INTERRUPTING = 3

# 播放错误状态
uint32 ERROR = 4
```

### motion/McPresetMotion.msg

```text
# 预设动作

int32 value

# 恢复默认姿态
int32 DEFAULT_POS = 0

# 右手挥手
int32 RIGHT_ARM_WAVE = 1001

# 右手握手
int32 RIGHT_ARM_HANDSHAKE = 1002

# 左手握手1.5m上对象
int32 RIGHT_ARM_HANDSHAKE_FOR_1D5METER = 1003

# 左手挥手
int32 LEFT_ARM_WAVE = 1011

# 左手握手
int32 LEFT_ARM_HANDSHAKE = 1012

# 左手握手1.5m上对象
int32 LEFT_ARM_HANDSHAKE_FOR_1D5METER = 1013

# 双手比心
int32 BOTH_HANDS_MAKE_HEART = 2001

# 双手摆动，表达喜悦
int32 BOTH_HANDS_ACTION_HAPPY = 2002

# 双手动作，说话动作
int32 BOTH_HANDS_ACTION_TALKING = 2003

# 说话动作1
int32 T1_TALK1 = 2004

# 说话动作2
int32 T1_TALK2 = 2005

# 说话动作3
int32 T1_TALK3 = 2006

# 说话动作4
int32 T1_TALK4 = 2007

# 说话动作5
int32 T1_TALK5 = 2008

# 说话动作6
int32 T1_TALK6 = 2009

# 拍照动作1
int32 PHOTO_POSE_1 = 2011

# 拍照动作2
int32 PHOTO_POSE_2 = 2012

# 拍照动作3
int32 PHOTO_POSE_3 = 2013

# 拍照动作4
int32 PHOTO_POSE_4 = 2014

# 三连拍姿势
int32 PHOTO_THREE_SHOT = 2020

# -----------------------------------------------------------------------------------
# Q 预置的上肢动作
# -----------------------------------------------------------------------------------

# 招手
int32 Q_BECKON = 3001

# 握手
int32 Q_SHAKE_HANDS = 3002

# 碰拳
int32 Q_BUMP_FISTS = 3003

# 挥手
int32 Q_WAVE_HAND = 3004

# 情绪动作 - 开心
int32 Q_SHOW_HAPPINESS = 3005

# 双手比心
int32 Q_MAKE_HEART = 3007

# 加油
int32 Q_CHEER_ON = 3008

# 伸懒腰
int32 Q_STRETCH = 3010

# 讲话动作A
int32 Q_SPEAK_A = 3012

# 讲话动作B
int32 Q_SPEAK_B = 3013

# 讲话动作C
int32 Q_SPEAK_C = 3014

# 拥抱
int32 Q_HUG = 3018

# 拒绝
int32 Q_REFUSE = 3021

# 跳舞动作A
int32 Q_DANCE_A = 3046

# 跳舞动作B
int32 Q_DANCE_B = 3047

# 跳舞动作C
int32 Q_DANCE_C = 3048
```

### motion/McRuntimeModel.msg

```text
# -----------------------------------------------------------------------------------
# 机器人运控状态 - 运行模型信息
# -----------------------------------------------------------------------------------

bool waist_status                      # 腰部状态

McHandStatus left_hand_status          # 左手手部状态

McHandStatus right_hand_status         # 右手手部状态
```

## msg

### msg/JointCommand.msg

```text
string name
float64 position
float64 velocity
float64 effort
float64 stiffness
float64 damping
```

### msg/JointCommandArray.msg

```text
MessageHeader header

JointCommand[] joints
```

### msg/JointInfo.msg

```text
string name
string hardware_version
string software_version
uint8 mode
JointMitParams mit_params
JointProtectConfig protect_config
```

### msg/JointInfoArray.msg

```text
MessageHeader header

JointInfo[] joints
```

### msg/JointMitParams.msg

```text
int16 pos_max
int16 pos_min
int16 vel_max
int16 vel_min
int16 tor_max
int16 tor_min
int16 kp_max
int16 kp_min
int16 kd_max
int16 kd_min
```

### msg/JointProtectConfig.msg

```text
int16 l1_mos_protect
int16 l1_mos_recover
int16 l1_current_protect
int16 l1_current_recover
int16 l1_voltage_protect
int16 l1_voltage_recover
int16 l2_mos_protect
int16 l2_mos_recover
int16 l2_current_protect
int16 l2_current_recover
int16 l2_voltage_protect
int16 l2_voltage_recover
```

### msg/JointState.msg

```text
string name
float64 position
float64 velocity
float64 effort
int16 coil_temp
int16 motor_temp
uint8 motor_vol
```

### msg/JointStateArray.msg

```text
MessageHeader header

JointState[] joints
```

### msg/McCommonState.msg

```text
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
```

## srv

### srv/GetAllJointState.srv

```text
CommonRequest request

---

CommonResponse response

JointState[] head_joints
JointState[] arm_joints
JointState[] waist_joints
JointState[] leg_joints
```

### srv/GetAllJointState_Request.msg

```text
CommonRequest request
```

### srv/GetAllJointState_Response.msg

```text


CommonResponse response

JointState[] head_joints
JointState[] arm_joints
JointState[] waist_joints
JointState[] leg_joints
```

### srv/GetJointPowerState.srv

```text
# Request
CommonRequest request

---


# 响应头
CommonResponse header

uint8 power_state

uint8 POWER_ON=1   # 电机上电
uint8 POWER_OFF=2    # 电机下电
```

### srv/GetJointPowerState_Request.msg

```text
# Request
CommonRequest request
```

### srv/GetJointPowerState_Response.msg

```text



# 响应头
CommonResponse header

uint8 power_state

uint8 POWER_ON=1   # 电机上电
uint8 POWER_OFF=2    # 电机下电
```

### srv/GetMcAction.srv

```text
# Request 部分
CommonRequest request

---

# 响应头
ResponseHeader header

# Action信息
McActionInfo info
```

### srv/GetMcAction_Request.msg

```text
# Request 部分
CommonRequest request
```

### srv/GetMcAction_Response.msg

```text


# 响应头
ResponseHeader header

# Action信息
McActionInfo info
```

### srv/GetMcAvailableActions.srv

```text
# Request 部分
CommonRequest request

---


# 响应头
ResponseHeader header

# 可用的Action列表
string[] actions

# 可用的Action命令列表
McActionCommand[] commands
```

### srv/GetMcAvailableActions_Request.msg

```text
# Request 部分
CommonRequest request
```

### srv/GetMcAvailableActions_Response.msg

```text



# 响应头
ResponseHeader header

# 可用的Action列表
string[] actions

# 可用的Action命令列表
McActionCommand[] commands
```

### srv/GetMcJointState.srv

```text
# Request 部分
CommonRequest request

---

# 响应头
ResponseHeader header

# Joint信息
JointState[] joints
```

### srv/GetMcJointState_Request.msg

```text
# Request 部分
CommonRequest request
```

### srv/GetMcJointState_Response.msg

```text


# 响应头
ResponseHeader header

# Joint信息
JointState[] joints
```

### srv/GetMcLocomotionGait.srv

```text
# Request 部分
CommonRequest request

---

# 响应头
ResponseHeader header

McLocomotionGaitType gait
```

### srv/GetMcLocomotionGait_Request.msg

```text
# Request 部分
CommonRequest request
```

### srv/GetMcLocomotionGait_Response.msg

```text


# 响应头
ResponseHeader header

McLocomotionGaitType gait
```

### srv/GetMcMotions.srv

```text
# 请求头
RequestHeader header

---

CommonTaskResponse response

# 当前存在的动作列表
McMotion[] motion
```

### srv/GetMcMotions_Request.msg

```text
# 请求头
RequestHeader header
```

### srv/GetMcMotions_Response.msg

```text


CommonTaskResponse response

# 当前存在的动作列表
McMotion[] motion
```

### srv/GetMcPresetMotionState.srv

```text
# Request 部分
CommonTaskRequest request

---

CommonTaskResponse response
```

### srv/GetMcPresetMotionState_Request.msg

```text
# Request 部分
CommonTaskRequest request
```

### srv/GetMcPresetMotionState_Response.msg

```text


CommonTaskResponse response
```

### srv/GetMcTaskState.srv

```text
# Request 部分
CommonTaskRequest request

---

CommonTaskResponse response
```

### srv/GetMcTaskState_Request.msg

```text
# Request 部分
CommonTaskRequest request
```

### srv/GetMcTaskState_Response.msg

```text


CommonTaskResponse response
```

### srv/McMotionRecord.srv

```text
# Request 部分
CommonRequest request

# 操作区域部分
int32 record_area
# 上半身
int32 RECORD_UPPER = 1
# 下半身
int32 RECORD_LOWER = 2 
# 全身
int32 RECORD_ALL   = 3

# 操作模式部分
int32 operation_type
# 开始录制
int32 OPER_START  = 1
# 结束录制
int32 OPER_STOP   = 2
# 暂停录制(产品暂时没提)
int32 OPER_PAUSE  = 3
# 继续录制(产品暂时没提)
int32 OPER_RESUME = 4

# 录制时长限制
int32 max_duration

# 存储路径
string folder_path
# 文件名
string file_name

---

# Response 部分
CommonResponse response
```

### srv/McMotionRecord_Request.msg

```text
# Request 部分
CommonRequest request

# 操作区域部分
int32 record_area
# 上半身
int32 RECORD_UPPER = 1
# 下半身
int32 RECORD_LOWER = 2 
# 全身
int32 RECORD_ALL   = 3

# 操作模式部分
int32 operation_type
# 开始录制
int32 OPER_START  = 1
# 结束录制
int32 OPER_STOP   = 2
# 暂停录制(产品暂时没提)
int32 OPER_PAUSE  = 3
# 继续录制(产品暂时没提)
int32 OPER_RESUME = 4

# 录制时长限制
int32 max_duration

# 存储路径
string folder_path
# 文件名
string file_name
```

### srv/McMotionRecord_Response.msg

```text


# Response 部分
CommonResponse response
```

### srv/SetJointPower.srv

```text
# Request
CommonRequest request

#调用请求的模块名
string input_source
#命令
uint8 command

uint8 POWER_ON=1   # 电机上电
uint8 POWER_OFF=2    # 电机下电

---


# 响应头
CommonResponse header
```

### srv/SetJointPower_Request.msg

```text
# Request
CommonRequest request

#调用请求的模块名
string input_source
#命令
uint8 command

uint8 POWER_ON=1   # 电机上电
uint8 POWER_OFF=2    # 电机下电
```

### srv/SetJointPower_Response.msg

```text



# 响应头
CommonResponse header
```

### srv/SetMcAction.srv

```text
# 请求头
RequestHeader header

# 触发源 定义见 McTaskSource.msg 
string source

# Action命令
McActionCommand command

---

CommonTaskResponse response
```

### srv/SetMcAction_Request.msg

```text
# 请求头
RequestHeader header

# 触发源 定义见 McTaskSource.msg 
string source

# Action命令
McActionCommand command
```

### srv/SetMcAction_Response.msg

```text


CommonTaskResponse response
```

### srv/SetMcInputSource.srv

```text
# Request 部分
CommonRequest request

McInputAction action # ADD MODIFY DELETE DISABLE ENABLE

McInputSource input_source
---

CommonTaskResponse response
```

### srv/SetMcInputSource_Request.msg

```text
# Request 部分
CommonRequest request

McInputAction action # ADD MODIFY DELETE DISABLE ENABLE

McInputSource input_source
```

### srv/SetMcInputSource_Response.msg

```text


CommonTaskResponse response
```

### srv/SetMcLocomotionGait.srv

```text
# 请求头
RequestHeader header

# 步态
McLocomotionGaitType gait

---

CommonResponse response
```

### srv/SetMcLocomotionGait_Request.msg

```text
# 请求头
RequestHeader header

# 步态
McLocomotionGaitType gait
```

### srv/SetMcLocomotionGait_Response.msg

```text


CommonResponse response
```

### srv/SetMcMotion.srv

```text
# 此接口是播放全身动作接口

# 请求头
RequestHeader header

# 触发源 定义见 McTaskSource.msg 
string source

# 资源类型
int32 type

# 自有模型
int32 MIMIC_QY = 1

# 灵创模型
int32 MIMIC_LC = 2

# 全身动作名称，若motion为空，加载model中resource; 反之，从本地加载执行资源。
string motion

# onnx 模型绝对路径
string model

# 资源绝对路径，比如轨迹参考
string resource

# 是否打断(给后面animation接口合并预留)
bool interrupt

# 操作类型
int32 operation

# 预先加载
int32 PRELOAD = 1

# 开始执行
int32 EXECUTION = 2

---

# 响应头
CommonTaskResponse response
```

### srv/SetMcMotionSeq.srv

```text
# 此接口是播放动作序列接口(暂不使用)

# 请求头
RequestHeader header

# 动作序列
string[] motion_seq

# 打断
bool interrupt

---

CommonTaskResponse response
```

### srv/SetMcMotionSeq_Request.msg

```text
# 此接口是播放动作序列接口(暂不使用)

# 请求头
RequestHeader header

# 动作序列
string[] motion_seq

# 打断
bool interrupt
```

### srv/SetMcMotionSeq_Response.msg

```text


CommonTaskResponse response
```

### srv/SetMcMotion_Request.msg

```text
# 此接口是播放全身动作接口

# 请求头
RequestHeader header

# 触发源 定义见 McTaskSource.msg 
string source

# 资源类型
int32 type

# 自有模型
int32 MIMIC_QY = 1

# 灵创模型
int32 MIMIC_LC = 2

# 全身动作名称，若motion为空，加载model中resource; 反之，从本地加载执行资源。
string motion

# onnx 模型绝对路径
string model

# 资源绝对路径，比如轨迹参考
string resource

# 是否打断(给后面animation接口合并预留)
bool interrupt

# 操作类型
int32 operation

# 预先加载
int32 PRELOAD = 1

# 开始执行
int32 EXECUTION = 2
```

### srv/SetMcMotion_Response.msg

```text


# 响应头
CommonTaskResponse response
```

### srv/SetMcPresetMotion.srv

```text
# 请求头
RequestHeader header

# 触发源 定义见 McTaskSource.msg 
string source

# 控制区域
McControlArea area

# 预设动作
McPresetMotion motion

# 是否打断前一个动作
bool interrupt

# 自定义动作地址
string ani_path

---

CommonTaskResponse response
```

### srv/SetMcPresetMotion_Request.msg

```text
# 请求头
RequestHeader header

# 触发源 定义见 McTaskSource.msg 
string source

# 控制区域
McControlArea area

# 预设动作
McPresetMotion motion

# 是否打断前一个动作
bool interrupt

# 自定义动作地址
string ani_path
```

### srv/SetMcPresetMotion_Response.msg

```text


CommonTaskResponse response
```

---

共 89 个接口定义。

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


===== FILE: raw/t1/task_engine/rule/interaction.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/interaction.yaml) =====

# 主动交互 / 定时任务（主动发起的对话、情感表达、定时提醒等）
task_base:
  enable: true
  task_name: interaction
  task_type: long_task
  real_task_type: InteractionTask
  priority: 30
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
  allow_charging_state: true
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
  - task_name: interaction
    action: reject     # 主动交互运行中拒绝
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: override     # T1: 覆盖基础运动操控
  - task_name: upper_body
    action: reject       # 上肢动作运行中拒绝
  - task_name: whole_body
    action: reject       # 全身动作运行中拒绝（T1）
  - task_name: posture
    action: override     # 姿态变换运行中拒绝
  - task_name: follow
    action: parallel     # 与智能跟随并行
  - task_name: navigation
    action: parallel     # 与室内导航并行
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: idle
    action: parallel     # 与闲时行为并行
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: touch
    action: parallel     # 与抚摸响应并行
  - task_name: app_gyro_ctrl
    action: parallel     # 与远程遥控并行
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: app_teach_demo
    action: reject   # 动作示教运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
  - task_name: localization
    action: parallel # 与定位并行
  - task_name: mapping
    action: parallel # 与建图并行
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝


===== FILE: raw/t1/task_engine/rule/move.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/move.yaml) =====

# 移动（仅做前置仲裁，不记录运行态；实际移动由 PlayMove 派发）
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
allow_velocity_source: [interaction, task_engine]
velocity_source_block_robots: [Q1]
odom_condition:
  require_trusted: true
  allow_untrusted:
    - name: rest_posture_move_recovery
      odom_status: [ANY]
      mc_action: [PASSIVE_DEFAULT, QUADRUPED_GET_DOWN_DEFAULT, QUADRUPED_SIT_DOWN_DEFAULT]
precondition:
  allow_posture: []
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
  check_log_sync: false
alarm_condition:
  allow_mode: exclude
  allow_levels: []
  exclude_levels: [fatal]
motion_condition:
  allow_motion_state: [idle, preemptable, running]
  allow_preempt_running_task: false
arbitration_policy:
  - task_name: move
    action: reject     # 碰撞规避运行中拒绝
    ignore_if_running: [follow]  # 跟随中的 is_moving 不阻断室内/户外切模预检查
  - task_name: posture
    action: override     # 覆盖姿态变换动作
  - task_name: app_joystick_ctrl
    action: override     # 覆盖基础运动操控
  - task_name: upper_body
    action: override     # 覆盖上肢动作
  - task_name: whole_body
    action: override     # 覆盖全身动作
  - task_name: follow
    action: override     # 覆盖智能跟随
  - task_name: navigation
    action: override     # 覆盖室内导航
  - task_name: camera_move
    action: override     # 覆盖跟拍运镜
  - task_name: idle
    action: override     # 覆盖闲时行为
  - task_name: wake_turn
    action: override     # 覆盖唤醒反馈
  - task_name: interaction
    action: parallel     # 与主动交互并行
  - task_name: touch
    action: override     # 覆盖抚摸响应
  - task_name: app_gyro_ctrl
    action: reject       # 陀螺仪玩法运行中拒绝移动
  - task_name: app_canvas
    action: reject   # 画图模式运行中拒绝
  - task_name: app_teach_demo
    action: reject   # 动作示教运行中拒绝
  - task_name: factory_reset
    action: reject   # 出厂重置运行中拒绝
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


===== FILE: raw/t1/task_engine/rule/navigation.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/navigation.yaml) =====

# 自主导航（路径规划 + 移动到目标点）
# 导航期间独占移动资源；电量不足或碰撞告警时终止
task_base:
  enable: true
  task_name: navigation
  task_type: long_task
  real_task_type: NavigationTask
  priority: 50
  permission_level: normal
  allow_preempt: false
  track_running_state: true
  timing_cycle_ms: 0
  need_confirm: false
allow_source: []
allow_velocity_source: []
velocity_source_block_robots: []
precondition:
  allow_posture: []
  block_posture:
    - PASSIVE_DEFAULT
    - DAMPING_DEFAULT
    - LYING_DEFAULT
    - LIE_FACE_UP
    - LIE_FACE_DOWN
    - STORE_DEFAULT
  battery_min_percent: 20
  allow_charging_state: false
  check_app_conn: false
  check_cloud_conn: false
  check_network: false
  check_log_sync: false
alarm_condition:
  allow_mode: exclude
  allow_levels: []
  exclude_levels: [fatal, error]
motion_condition:
  # 动作冲突由 WorkerManager 按 ActionManager 规则及是否可打断进行最终仲裁。
  allow_motion_state: []
  allow_preempt_running_task: false
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


===== FILE: raw/t1/task_engine/rule/idle.yaml  (source: D:/Projects/Athena/运动控制/Collie/T1运控架构分析/04_真机与模型数据/真机资料/task_engine/cfg/rule/t1/idle.yaml) =====

# 闲时行为（机器人空闲时的自主行为，优先级最低）
# 任何主动任务到来时均可被打断
task_base:
  enable: true
  task_name: idle
  task_type: long_task
  real_task_type: IdleTask
  priority: 10
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
  allow_charging_state: true
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
arbitration_policy:
  - task_name: idle
    action: reject     # 闲时行为运行中拒绝
  - task_name: move
    action: reject       # 碰撞规避运行中拒绝
  - task_name: app_joystick_ctrl
    action: parallel     # 与基础运动操控并行
  - task_name: upper_body
    action: reject       # 上肢动作运行中拒绝
  - task_name: whole_body
    action: reject       # 全身动作运行中拒绝
  - task_name: posture
    action: override     # 姿态变换运行中拒绝
  - task_name: follow
    action: reject       # 智能跟随运行中拒绝
  - task_name: navigation
    action: reject       # 室内导航运行中拒绝
  - task_name: camera_move
    action: reject       # 跟拍运镜运行中拒绝
  - task_name: wake_turn
    action: reject       # 唤醒反馈运行中拒绝
  - task_name: interaction
    action: reject       # 主动交互运行中拒绝
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
    action: reject   # 定位运行中拒绝
  - task_name: mapping
    action: reject   # 建图运行中拒绝
  - task_name: motion_playback
    action: reject   # 动作回放运行中拒绝
  - task_name: motion_record
    action: reject   # 动作录制运行中拒绝
  - task_name: shutdown
    action: reject   # 关机运行中拒绝
  - task_name: self_check
    action: reject
    real_task_type: SelfCheckTask   # 无独立 rule 文件，按 worker TaskType 判断
  - task_name: low_battery
    action: reject
    real_task_type: LowBatteryTask
  - task_name: photo
    action: reject
    real_task_type: PhotoTask
  - task_name: time
    action: parallel
    real_task_type: TimeTask
  - task_name: text
    action: parallel
    real_task_type: TextTask
  - task_name: emotion
    action: parallel
    real_task_type: EmotionTask
  - task_name: light
    action: parallel
    real_task_type: LightTask
  - task_name: post_process
    action: reject
    real_task_type: PostProcessTask
  - task_name: scene
    action: reject
    real_task_type: SceneTask
  - task_name: set_mode
    action: reject
    real_task_type: SetModeTask
  - task_name: charge_point_sit
    action: reject
    real_task_type: ChargePointSitTask
  - task_name: group_photo
    action: reject
    real_task_type: GroupPhotoTask
  - task_name: hitchcock
    action: reject
    real_task_type: HitchcockTask
  - task_name: charge_point_setup
    action: reject
    real_task_type: ChargePointSetupTask
