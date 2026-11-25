# NOT INCLUDED · 未上传的大文件与替代查法

本仓库是**文本证据包**，以下大文件未上传；需要时按"替代查法"在本地/内网找。

| 未上传 | 体积 | 原因 | 替代查法 |
|---|---|---|---|
| `04_真机与模型数据/运控模型库/真机/qd1_t2d0/模型/*.onnx` | 约 926 MB（183 份） | 二进制、体积大、网页 GPT 不能读 | 用 `raw/t1/model_lists/model-network-stats.csv`、`rl-runner-weights.csv`、`obs-layout.csv` 核对 I/O、参数量、obs 维度 |
| `03_参考库/roboto_origin-main` 全树 | 约 2.1 GB | 含第三方、子模块、二进制 | 本包 `raw/roboparty/` 已含 `roboparty_deploy` 的 README/配置/推理源码/脚本；完整树在本地 |
| 真机二进制（`libmc_common_runner.so` 等） | 约 1.5 GB | 二进制 | 结论来自文档/符号分析；不要把二进制行为当运行验证 |
| `res/` 下全部 motion CSV（132 份）与 NPZ | 数十 MB | 数量大、二进制 | `motion_list.yaml` 有全量清单；本包仅放 4 份代表性 CSV |
| SDK 示例源码树 / OpenCV 第三方 | 数百 MB | 与本轮设计无关 | 需要时看 `raw/docs/t1_mc_decomposition.md` 的接口摘录 |
| 历史站点报告 / 重复文件 / 旧快照 | 数百 MB | 已被当前文档取代 | 见 `99_归档/`（本地） |

## 关于 ONNX

网页 GPT 不能读 ONNX。设计里需要模型 I/O 时，用：

- `raw/t1/model_lists/model-network-stats.csv`：逐模型输入/输出/参数量/层数；
- `raw/t1/model_lists/obs-layout.csv`：46 份配置的 obs 维度与构成；
- `raw/t1/model_lists/rl-runner-weights.csv`：动作→runner→配置→ONNX→obs→act→dt→stack；
- `raw/t1/config/rl/*.yaml`：逐策略的 obs_index/action_scale/kp/kd/default/exit。

## 关于 T1 与 Collie

- T1 的数字是**对标证据**，不是 Collie 标定值。
- Collie 的关节拓扑、双足定义、权重、轮模式、平台均未冻结；本包示例中的 16 关节/数值是 `[假设]`。
