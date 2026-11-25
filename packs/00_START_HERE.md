# packs · 阅读包入口

> 自动生成。每个包把多个原始文件按主题拼接，带 `FILE:` 头；引用行号时回到 `raw/`。

| 包 | 主题 | 文件数 | 字节 |
|---|---|---:|---:|
| `packs/01_T1_SYSTEM_CONFIGS.md` | T1 系统/动作/图/安全/设备配置 | 13 | 135,345 |
| `packs/02_T1_POLICY_CONFIGS.md` | T1 全部 RL/经典策略配置 | 29 | 121,022 |
| `packs/03_T1_SWITCHING_EVIDENCE.md` | T1 变身/切换/过渡证据 | 16 | 156,021 |
| `packs/04_T1_SAFETY_AND_INPUTS.md` | T1 安全/速度源/超时 | 5 | 90,183 |
| `packs/05_ROBOPARTY_DEPLOY.md` | roboparty_deploy 基线（配置+源码） | 20 | 166,327 |
| `packs/06_MODELS_AND_OBS.md` | T1 模型/动作/观测清单 | 7 | 38,628 |
| `packs/07_INTERFACES_AND_UPSTREAM.md` | MC 接口、任务层、需求 | 16 | 214,803 |
| `packs/08_ANALYSIS_AND_BASELINE.md` | 当前 Collie 基线 + T1 拆解 | 6 | 299,411 |

## 建议顺序

1. `packs/03_T1_SWITCHING_EVIDENCE.md`（切换/过渡最关键）
2. `packs/05_ROBOPARTY_DEPLOY.md`（框架基线）
3. `packs/01_T1_SYSTEM_CONFIGS.md`（配置体系）
4. `packs/02_T1_POLICY_CONFIGS.md`（策略配置多样性）
5. `packs/04_T1_SAFETY_AND_INPUTS.md`（安全/输入）
6. `packs/06_MODELS_AND_OBS.md`（模型/观测）
7. `packs/07_INTERFACES_AND_UPSTREAM.md`（接口/上游）
8. `packs/08_ANALYSIS_AND_BASELINE.md`（当前基线）
