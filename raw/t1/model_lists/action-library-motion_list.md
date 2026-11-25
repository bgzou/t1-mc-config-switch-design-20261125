# 动作库（motion_list.yaml，真机 108 条）

来源：`真机/qd1_t2d0/配置/motion_list.yaml`。这是 **MIMIC / ANIMATION 的动作注册表**，
每条动作自带「模型（可为空）+ 参考轨迹」。

| motion 类型 | 条数 | 不同模型数 | 轨迹数 | body | 挂到哪个 Action |
|---|---|---|---|---|---|
| ANIMATION | 78 | 0 | 77 | upper | BIPED_LOCOMOTION_WBC |
| QUADRUPED_MIMIC | 19 | 1 | 19 | whole | QUADRUPED_MIMIC |
| BIPED_MIMIC | 8 | 1 | 8 | whole | BIPED_MIMIC |
| BIPED_NPZ_MIMIC | 3 | 3 | 3 | whole | BIPED_NPZ_MIMIC |

## 结论

- `QUADRUPED_MIMIC` 19 条共用 **1 个模型**，靠 19 条 CSV 区分
- `BIPED_MIMIC` 8 条共用 **1 个模型**，靠 8 条 CSV 区分
- `BIPED_NPZ_MIMIC` 3 条各一个模型 + 各一条 NPZ
- `ANIMATION` 78 条**没有模型**，纯 CSV 回放（fps 60），在 `BIPED_LOCOMOTION_WBC` 内叠加上肢
- `ANIMATION` 的 name 是数字（1001…），对应 `McPresetMotion` 枚举——所谓「预设动作」就是这 78 条

## 字段说明

| 字段 | 含义 |
|---|---|
| `policy_path` | 这条动作的模型；**可为空**（由 MotionManager 运行时下发） |
| `custom.trajectory_path` | 参考轨迹（CSV 或 NPZ） |
| `custom.fps` | 回放帧率（ANIMATION 为 60） |
| `custom.animation_type` | 柔性/刚性/保持末帧 |
| `interrupt_type` | 能否被别的动作打断 |
| `custom.start_count` / `end_count` | 轨迹截取的起止帧 |
| `motion_area` | 执行区域（细化语义未完全确证） |

> 明细见 `动作库-motion_list.csv`（108 行）。

## 本机的两个"看着有、其实没启用"

| 项 | 状态 |
|---|---|
| `BIPED_LINGCHUANG_MIMIC`（灵创） | **本机 0 条 active**（6 条全被注释）；`rl_models/` 里仍留着 6 个模型。灵创在 **qd1_t1d5** 上才启用（6 条） |
| `ANIMATION` 里的 78 条 | 本机启用，就是"预设动作"（数字名 1001…） |

**灵创 vs NPZ 的判据**：看模型输入——`[1,264]+[1,1]` 是灵创（轨迹烘在模型里）；`[1,83]` 是 NPZ（轨迹在外部 .npz）。
