# 摘录 · UC3 牵手跟随（二手现象记录，非机制证明）

| **UC3 牵手跟随** | 326s | 14:35:13 `QUADRUPED_TO_BIPED_ROTATE(11)` 变形双足 → 14:35:18 `BIPED_LOCOMOTION_WBC(300)` → 14:36:11 跟随任务启动但 `follow/state=1 未发现目标`（全程未锁定）→ **实际为牵手带步**（用户握手、MC 力导引 WBC 步态随行）→ 14:40 结束 |


#### 6.2.3 UC3「牵着 T1 的手一起走」（跟随）


**流程图 UC3「牵着 T1 的手一起走」——双路径链路拓扑：视觉跟随路径（本例未生效，虚线）+ 牵手带步路径（实际生效，实线）**


    USER(["👤 用户: 语音「跟着我」<br/>+ 牵手带步"])
    subgraph RK["🖥 运控板 rk"]

    PTR -.->|"follow_candidates ★ (本例未锁定目标<br/>follow/state=1 未发现)"| TE
    FLW -.->|"velocity(source=follow)→MC<br/>(视觉跟随路径·本例未生效)"| MC

**时序图 UC3「牵着 T1 的手一起走」——跟随任务启停（视觉未锁定）→ 牵手 held_state 检测 → 双足 WBC 力导引带步**


    loop 牵手带步 3~4 分钟（力导引，人主导）
        U->>MC: 牵引（速度/方向由人施加）

读图要点（本例为「未锁定目标的牵手带步」）：
1. **双路径设计**：实线 = 视觉跟随路径（person_track 检测+ReID → follow_candidates★ → follow_node 语义规划 → `velocity`→MC 按 `SetMcInputSource` 仲裁），虚线标注本例实际状态——**跟随任务已启动但全程 `follow/state=1 未发现目标`**（牵手位置遮挡相机视角），未产生跟随速度指令。

1. **双路径设计**：实线 = 视觉跟随路径（person_track 检测+ReID → follow_candidates★ → follow_node 语义规划 → `velocity`→MC 按 `SetMcInputSource` 仲裁），虚线标注本例实际状态——**跟随任务已启动但全程 `follow/state=1 未发现目标`**（牵手位置遮挡相机视角），未产生跟随速度指令。
2. **实际生效机制 = 牵手带步**：MC 通过关节电流/力矩实时估计 `McHandHeldState`（UNKNOWN/BOTH_NOT_HELD/LEFT_HELD_ONLY/RIGHT_HELD_ONLY/BOTH_HELD + `is_held`），牵手后机器人先自主变形双足（实测 `QUADRUPED_TO_BIPED_ROTATE(11)`→`BIPED_LOCOMOTION_WBC(300)`），在 WBC 全身控制下以力导引随人迈步——**该路径不经 `velocity` 话题，完全在 MC 实时层闭环**。

2. **实际生效机制 = 牵手带步**：MC 通过关节电流/力矩实时估计 `McHandHeldState`（UNKNOWN/BOTH_NOT_HELD/LEFT_HELD_ONLY/RIGHT_HELD_ONLY/BOTH_HELD + `is_held`），牵手后机器人先自主变形双足（实测 `QUADRUPED_TO_BIPED_ROTATE(11)`→`BIPED_LOCOMOTION_WBC(300)`），在 WBC 全身控制下以力导引随人迈步——**该路径不经 `velocity` 话题，完全在 MC 实时层闭环**。
3. **held_state 的反向作用**：任务规则层以 `allow_held_state: false` 门控姿态切换/示教/遥控等 8 类任务（牵手时拒绝），即牵手既是控制输入也是任务态约束。
