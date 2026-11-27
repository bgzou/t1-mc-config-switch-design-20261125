# UC3 真机日志摘录（c2_events.log）

## 来源
- 原始文件：`03_参考库/qiliang_T1Pro报告库/docs/primebot/on_device_measured_data/c2_events.log`（10.8 MB，**未打包**）
- 设备端 2026-10-28 会话，UC3「牵手跟随」；
- 本目录只保留：状态变化表 + 4 个原始窗口。

## 文件
| 文件 | 内容 |
|---|---|
| `uc3_state_timeline.csv` | 由日志解析出的状态变化（action / is_held / hand_held / form / follow），39 行 |
| `uc3_enter_biped.log` | 14:35:13.5–14:35:19.5，`QUADRUPED_TO_BIPED_ROTATE` → `BIPED_LOCOMOTION_WBC` |
| `uc3_held_on.log` | 14:37:23.8–14:37:25.2，`is_held` 首次变为 true |
| `uc3_held_off.log` | 14:37:47.8–14:37:49.2，第一次 `is_held` 变回 false |
| `uc3_follow_window.log` | 14:37:23.5–14:37:24.8，含 `[FLW] state` 变化 |

## 实测时间线（关键点）
| 时刻 | 事件 |
|---|---|
| 14:35:13.982 | `QUADRUPED_TO_BIPED_ROTATE`（11） |
| 14:35:18.822 | `BIPED_LOCOMOTION_WBC`（300） |
| 14:35:24.716 | `hand_held` 首次变为 1（BOTH_NOT_HELD） |
| 14:37:24.205 | **`is_held: true`**，随后 `hand_held: 3`（RIGHT_HELD_ONLY） |
| 14:37:48.634 | `is_held: false`（第一次松开） |
| 14:39:30.427 | 再次 `is_held: true`（hand_held=3） |
| 14:39:45.661 | `is_held: false` |
| 14:40:02.221 | 再次 `is_held: true` |
| 14:40:40.760 | `is_held: false` |
| 14:40:46.385 | 再次 `is_held: true` |

## held 区间
| 开始 | 结束 | 时长 |
|---|---|---|
| 14:37:24.205 | 14:37:48.634 | 24.4 s |
| 14:39:30.427 | 14:39:45.661 | 15.2 s |
| 14:40:02.221 | 14:40:40.760 | 38.5 s |
| 14:40:46.385 | 日志结束（未再清零） | 1.7 s |

> 说明：`is_held` 与 `hand_held` 是同一消息里的相邻字段，日志按字段逐行 dump，所以 `is_held=true` 的那一行后面 6 ms 才出现 `hand_held=3`。不要把 6 ms 的差当成真实状态机中间态。

## 能证明什么 / 不能证明什么
**能证明**
1. 整个牵手过程 `action_desc` 始终是 `BIPED_LOCOMOTION_WBC`，**动作没有切换**；
2. `held_state` 在 300 内多次 on/off，是 runner/MC 内部状态，不是 Action；
3. `hand_held` 稳定为 3（右手单牵）；`form=2`（双足）；
4. 进入 300 后约 2 分 5 秒才首次 held，说明不是"一进 300 就置位"，而是外力触发。

**不能证明**
- 速度指令、关节角、`arm_drag` 解算中间量（日志不含 `McCommonState` 的速度/命令字段）；
- `held_state` 与内部 `drag_active` 是否同一判据；
- 拖拽指令与视觉速度的仲裁关系。

> 完整日志未打包；需要更多窗口时让用户从工作区补齐，不要在报告里假装读过。
