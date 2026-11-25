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