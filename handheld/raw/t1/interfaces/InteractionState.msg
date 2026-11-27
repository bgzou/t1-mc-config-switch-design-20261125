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