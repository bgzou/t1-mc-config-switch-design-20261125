# 07 · 术语表

**用途**：避免"同词异义"。正文首次出现时引用本表；与本表冲突时，在正文说明。

| 术语 | 含义 | 不要混淆 |
|---|---|---|
| **MC（Motion Control）** | 运控域：把上游意图变成关节/轮命令的软件与策略集合 | 不是任务引擎、不是导航、不是训练 |
| **Policy** | 一个可执行控制器实例：RL 模型、经典控制律、轨迹播放器、过渡策略、安全策略 | 不等于 ONNX 文件；一个模型可被多个 Policy 引用 |
| **Model** | Policy 的一种资产（ONNX/RKNN/参数/轨迹） | "换模型"是换 Policy 的特例 |
| **Runner** | 框架里执行一个 Policy 的运行时对象；有生命周期、`step()`、进入/退出 | 不是训练循环里的 Runner |
| **Action** | 对上层可见的行为单元（站、走、跑、变形、表演、恢复） | 不等于 Policy；一个 Action 可由多个 Policy 组成 |
| **ActionBundle** | 一个 Action 的执行组合：primary + overlay + `owns_mask` | 不是一个执行阶段 |
| **Execution Group** | Action 下的一组 runner + 周期 + 优先级 + owner | 不强制一线程一组 |
| **RobotProfile** | 机器人本体静态描述：关节、限位、轮/传动、URDF、形态/能力、传感器外参 | 不是标定文件；标定是站点覆盖 |
| **PolicyManifest** | 一个 Policy 的完整契约：资产、tensor IO、obs/action spec、周期、增益、生命周期、兼容性 | 不是"模型卡片"；必须可校验、可执行 |
| **ObsSpec** | 观测配方：逐块/逐维来源、顺序、尺度、裁剪、滤波、历史、缺失策略 | 不是训练代码 |
| **ActionSpec** | 动作解码配方：逐关节 mode、scale、default、gain、limit、activation、owner | 不是"动作列表" |
| **ActionGraph** | 动作级有向图：节点=Action，边=允许的切换+守卫+过渡 | 不是任务流程图 |
| **TransitionGraph** | 切换图：边=Policy/Action 之间的迁移，含 TransitionSpec | 可与 ActionGraph 合并，但语义要分开 |
| **TransitionSpec** | 一条切换边的过渡数据：kind、phase、曲线、锚点、所有权、超时、回退、事件 | 不是代码；由 TransitionController 解释 |
| **TransitionController** | 框架里执行过渡的组件；统一接口，多策略实现 | 不是某个 Policy 的私有逻辑 |
| **Handoff** | 旧 Policy 停止写、新 Policy 开始写的原子时刻 | 不是"混合开始"；混合可以在 handoff 前后 |
| **Epoch** | 一次切换/所有权变更的单调版本号；用于拒绝旧命令/旧输出 | 不是时间戳 |
| **Ownership / owns_mask** | 某个 runner/Policy 对关节的写权限；按关节/组声明 | 不是"优先级"；冲突必须启动期拒绝 |
| **Overlay** | 在主 Policy 之上写局部关节的 Policy（手势/头/云台） | 不是"混合两个全身模型" |
| **Scope** | 作用域：ALL / LEGS / UPPER / 单关节组 | 不是形态 |
| **Form** | 形态：四足/双足/过渡态 | 不是 Action、不是 Mode |
| **Mode** | 运行模式：NORMAL / DEGRADED / SAFE / ESTOP / RECOVERY 等 | 不是 Form |
| **switch_ready** | 当前 Policy 稳定且允许接受下一个普通请求 | 不等于"动作完成"、不等于"安全"、不等于"用户可走" |
| **ZOH（零阶保持）** | 50 Hz 策略目标在 200 Hz 发布中重复保持 4 拍，不插值 | 不是"提高策略频率" |
| **Contract distance** | 两个 Policy 的 obs/action/频率/语义差异程度 | 不是"参数差异" |
| **Attractor basin** | 目标 Policy 能稳定接管的初始状态集合 | 不是"默认姿态" |
| **Anchor pose** | 过渡用的共同姿态锚点（目标默认位/经典站姿） | 不是"末态" |
| **Gate / gated_wait** | 过渡前的门控等待：速度归零、脚落地、滑移低于阈值、稳定窗口 | 不是"延时" |
| **Hard cut** | 立即切换，无混合；用于安全接管/完全同契约 | 不是"所有切换都能硬切" |
| **Blend / crossfade** | 两路输出按权重混合；仅同形态/同语义/双方稳定时可用 | 不能用于跨形态 |
| **Ramp** | 对增益/scale/命令做时间斜坡，避免力矩/速度跳变 | 不等于输出混合 |
| **Dedicated transition policy** | 独立训练的过渡策略（phase/q_ref 驱动），用于跨形态/大动作 | 不是"插值" |
| **Pause-swap** | 暂停输出→换指针→重置→恢复；调试/低风险用 | 不适合高速/跨形态 |
| **SIL / HIL** | 软件在环 / 硬件在环 | 不是"仿真训练" |
| **Golden trace / fixture** | 一段可复现的输入/输出/事件记录，用于逐拍对比 | 不是"截图" |
| **WCET** | 最坏执行时间 | 不是"平均耗时" |
| **DDS / ROS2** | 框架的通信中间件；不等于领域接口 | 领域接口可跨 DDS/共享内存/RPC |
| **T1 / Collie** | T1 Pro 是参照机型；Collie 是目标机型 | T1 数字不是 Collie 标定值 |
| **RPO** | Roboparty 的开源机器人（23 关节）；`roboparty_deploy` 的默认机器人 | 不是 T1；不要混用关节数 |
