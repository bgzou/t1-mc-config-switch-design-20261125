# 08 · 交付物规格：单文件 HTML 设计文档

**版本**：V1.0　**日期**：2026-11-25
**用途**：规定 GPT 最终交付的 HTML 的结构、必备内容、技术约束与评分标准。提示词会引用本文件。

---

## 1. 交付物

**一个自包含的 HTML 文件**：`T1_MC_YAML_SWITCH_DESIGN.html`

- 中文正文；UTF-8；`<html lang="zh-CN">`。
- 单文件：CSS 写在 `<style>`，图用 inline SVG，不引用外部 CDN/字体/图片/JS。
- 可在浏览器直接打开、可打印为 PDF；带固定/可折叠目录。
- 目标体积 150–300 KB；不超过 500 KB。
- 不允许 `TODO`、`待补充`、空章节；未知写 `UNKNOWN` 并给解决路径。

---

## 2. 必须包含的章节（顺序可微调，但不能缺）

### 封面 + 阅读指南

- 标题、副标题、日期、版本、状态（评审稿）、读者、范围。
- 三条阅读路径：10 分钟（执行摘要+决策表）、1 小时（配置+切换）、完整。
- 证据标记说明：`[事实]/[实测]/[文档]/[假设]/[建议]/[待定]/[推断]`。

### Part 0 执行摘要与决策表

- 一段话说清"配置体系 + 切换架构"。
- **12–15 条关键决策表**：`ID | 决策 | 理由 | 替代方案 | 代价 | 状态`。
- 给非软件背景决策者的 5 分钟版：为什么这样分层、最坏会坏在哪、还需要谁拍板。
- 交付物地图（本文各 Part 回答什么问题）。

### Part 1 范围、证据、假设

- 范围/非目标。
- T1 证据摘要（配置/切换/安全/速度源/踩坑），引用 `[E-xx]`。
- `roboparty_deploy` 基线：已有什么、缺什么、哪些能改/不能改。
- Collie 约束与未冻结假设（拓扑、双足定义、权重、轮模式、平台）。
- 术语表（可放附录，正文给最小集）。

### Part 2 配置体系总览

- 10–12 条设计原则（单一事实源、分层、稳定 ID、单位、严格枚举、schema+语义校验、不可变、版本、站点覆盖、可迁移、可观测、无逻辑）。
- **分层/依赖图**（inline SVG）：robot → policy → action → graph/system → site。
- **文件地图**：文件、回答什么问题、owner、生命周期（仓库/部署/站点）、消费者。
- **加载顺序图** + 失败语义。
- **所有权矩阵**：运控/框架/本体/安全/运维各拥有哪些文件与字段。
- 版本/兼容/灰度/回滚策略。
- 与 `roboparty_deploy` 的迁移路径（字段映射、适配器、弃用）。

### Part 3 逐文件 Schema 设计

按层组织，每类给：目的、owner、生命周期、字段表（字段/类型/必填/单位/默认/语义/校验/消费者）、完整示例、反模式、失败模式。

至少覆盖：

1. **RobotProfile**：identity、joints、links/frames、limits、wheel/gear、close-chain、URDF、forms/capabilities、sensor extrinsics。
2. **HardwareIO / Calibration**：CAN/IMU/bus、motor id/type/zero/sign、rates/timeouts、device version、site overlay。
3. **PolicyManifest**：id/kind/asset+SHA/runtime、tensor IO、obs/action spec 引用、period/decimation、default pose、gains、scale/clip、history/first-frame、lifecycle、ownership/scope、compat、entry/exit/complete/fail、provenance。
4. **ObsSpec**：逐块/逐维字段（index/name/source/size/unit/frame/scale/clip/filter/history/tap/dtype/required/freshness/missing policy）。
5. **ActionSpec**：逐关节 mode/scale/default/gain/tau limit/clip/activation/ownership/decoding。
6. **ActionBundle**：primary/overlay、scope/owns、rate、priority、params、allowed transitions、return_to、timeouts、events。
7. **ActionGraph / TransitionGraph**：节点、边、guard、via、default landing、global safety exits、switch_ready、forbidden edges。
8. **TransitionSpec**：kind、phases、curves、anchor、ownership、history、command、timeouts、fallback、events、logging。
9. **SafetyLimits/Guards**：position/velocity/torque/rate/gain limits、fall/timeout/NaN/estop、form-specific guards、safe actions、latch/reset。
10. **InputArbitration**：sources/priority/TTL/zero-speed/frames/lease/epoch/disconnect.
11. **Runtime/Scheduling**：rates/budgets/threads/cores/queues/WCET/startup/shutdown/overload.
12. **Observability/Replay**：logs/metrics/trace/black box/sampling/size/privacy.
13. **SiteOverlay**：unit serial/calibration/merge precedence/activation.
14. **Schema/Validation**：JSON Schema、语义校验、错误码、CI。
15. **Migration/Compat**：旧 `robot.yaml`/ROS2 params → 新文件；生成器；弃用。

### Part 4 完整示例（Collie 假设拓扑）

- 明确声明假设拓扑：可用 16 关节（12 腿 + 4 轮）作示例，也可声明你选择的其它拓扑；所有数值 `[假设]`，不得写成 Collie 事实。
- 一套最小可运行集合：robot profile + hardware/calibration + 1 个 RL 行走 manifest + obs/action spec + 1 个经典站立 manifest + 1 个 Q2B 过渡 manifest + ActionBundle + graph 片段 + 3 条 transition 边 + safety + inputs + runtime。
- 每个文件给完整 YAML（不是片段）或明确"省略部分"。
- **新增策略/动作/过渡 checklist**：改哪些文件、跑哪些校验、谁签收。
- **校验命令与预期错误**：至少 8 个坏配置示例（缺关节、tensor 维度不匹配、所有权冲突、非法边、缺 SHA、周期不整除、未知枚举、安全字段默认值）。
- **迁移示例**：把 `roboparty_deploy` 的 `default.yaml` + `robot.yaml` 映射到新文件。

### Part 5 切换与过渡架构

- 切换类型表（T1–T10，可扩展）：契约差异、物理风险、是否过渡、默认策略。
- **决策树**：必须独立过渡策略 / 框架混合 / 门控等待 / 硬切 / 禁止。
- **统一状态机**（inline SVG + 状态表）：`IDLE → REQUESTED → ADMITTED → PREPARE_EXIT → WAIT_EXIT → HANDOFF → ENTER → STABILIZE → RUNNING` + `ABORT/ROLLBACK/FAULT/SAFE`；每状态的进入/退出/超时/取消/幂等。
- **TransitionSpec schema**（字段表 + 示例）。
- **策略库**（≥9 种）：适用/不适用/参数/保证/失败模式；一张 "策略 × 场景" 矩阵。
- **所有权/epoch/单写者**图与时序。
- **50 Hz 策略 + 200 Hz RT** 时序图：ZOH、斜坡、候选过期、超时。
- **观测/历史/命令**处理表：清空/保留/重建/冻结。
- **失败/回退矩阵**：准入、退出、加载、首拍、推理超时、NaN、失稳、急停、断流、落位失败、回滚失败。
- **状态/事件/switch_ready**：字段、频率、语义、上层编排。
- **过渡期安全**：跌倒/接触/重力/滑移判据切换，急停独立性。
- **12–14 个具体案例表**：from→to、原因、契约差、风险、是否过渡、策略、守卫、最大时长、失败/回退、验收。
- 至少 5 条 transition 的 YAML 示例（同契约换版、经典↔RL、走→停、Q2B、B2Q、安全接管）。
- **反模式**：T1 的隐式中转、分散 ExitCheck、双写、插值变形、无超时、`switch_ready` 误用。

### Part 6 与框架协同

- 框架必须提供的 hook/API（配置加载、Registry、Graph、TransitionController、JointMux、OutputGuard、Status、Replay）。
- 映射到 `roboparty_deploy` 的模块/文件；哪些复用、哪些新增、哪些改。
- 最小改动路径 vs 原生扩展路径（给取舍）。
- 线程/周期/预算表；50/200 Hz；ZOH/斜坡在哪层。
- 接口/IDL 草图（C++/ROS2）：SwitchRequest、Plan、TransitionStatus、StateSnapshot。
- 兼容/迁移阶段（M0–M5）、验收门、回滚。
- 工作量/风险（人日量级，标注假设）。

### Part 7 测试、验收、运维

- 测试矩阵：schema/图、单元、回放、SIL、HIL、真机。
- Golden trace/fixture：每条边、每个过渡、每个故障。
- 故障注入清单。
- 指标与门槛：过渡时长、跟踪误差、力矩峰值/变化率、IMU 冲击、滑移、switch_ready 时延、失败率、回滚率。
- 日志/黑匣子/回放字段与体积。
- 发布门：哪些边可开放、哪些默认关闭、谁签收。

### Part 8 决策记录、风险、开放问题

- Q1–Q15 的裁决记录（按模板）。
- 风险登记表：风险、概率、影响、缓解、owner。
- 待拍板清单（谁、何时、需要什么证据）。
- 路线图（首版/下一版）。

### 附录

- A. 完整 YAML 示例（若正文已含，可索引）。
- B. JSON Schema / 校验规则摘录。
- C. 证据索引（`[E-xx]` 表）。
- D. T1→Collie 映射表（配置/切换概念）。
- E. 术语表。
- F. 自检与评分（按 §6 rubric 自评）。

---

## 3. 必备图表（inline SVG，至少 8 张）

1. 配置分层与依赖图。
2. 加载顺序/生命周期图。
3. 文件→消费者矩阵图（可用表）。
4. 动作图/过渡图示例（节点+边+守卫）。
5. 统一切换状态机。
6. 过渡期所有权/epoch 时序。
7. 50 Hz 策略 + 200 Hz RT 时序（ZOH/斜坡/超时）。
8. 经典↔RL 的锚点过渡时序。
9. 跨形态 Q2B/B2Q 的 phase + guard 时间轴。
10. 故障/回退决策树。

> SVG 必须自带 `<title>`/`<desc>`，颜色对比度足够；不要用外部图片。

---

## 4. 必备表格（至少 15 张）

决策表、文件地图、字段表（每类至少 1 张）、策略×场景矩阵、切换案例表、状态表、失败/回退矩阵、观测处理表、测试矩阵、指标表、迁移映射表、T1 踩坑表、风险表、开放问题表、评分表。

---

## 5. 代码/YAML 示例要求

- 所有 YAML 用 ```yaml 代码块；JSON Schema 用 ```json；C++/ROS2 用 ```cpp/```text。
- 示例必须能"看出结构"，不要用 `...` 省略关键字段；可以标注"其余字段省略"。
- 每个示例前说明"这是什么、谁读、验证什么"。
- 不得把示例数值写成 Collie 标定值；统一标注 `[假设]`。
- 至少 8 个完整文件、5 条 transition、3 个坏配置。

---

## 6. 评分 rubric（100 分）

| 维度 | 分值 | 满分标准 |
|---|---:|---|
| YAML 体系完整性 | 20 | 覆盖全部 15 类概念；分层/依赖/加载/版本/站点/迁移闭环；无关键缺口 |
| Schema 深度与字段语义 | 20 | 每类有字段表、单位、必填、校验、消费者；示例完整；能据此实现加载器 |
| 切换/过渡架构 | 25 | 统一状态机+描述符+策略库；12+ 案例；判据清晰；无专门分支；安全/回退闭环 |
| 框架协同/可落地 | 15 | 明确 hook/API/最小改动；50/200 Hz 时序；单写者；迁移阶段；工作量可信 |
| 示例/校验/测试 | 10 | 完整示例、坏配置、golden trace、SIL/HIL、指标门槛 |
| HTML 质量 | 5 | 单文件、无外部依赖、目录/打印/响应式、图/表/代码清晰 |
| 证据纪律 | 5 | 引用 `[E-xx]`/文件路径；区分事实/假设/建议；不编数字；冲突指出 |

**通过线**：≥80 分，且"切换/过渡架构"≥20、"YAML 体系"≥16；否则退回重写。

---

## 7. 输出协议（重要）

### 7.1 如果有 Canvas / 代码执行 / 文件下载

- 直接生成 `T1_MC_YAML_SWITCH_DESIGN.html` 文件并提供下载。
- 同时在对话里给：文件结构、字数/体积、自评分、未决问题。
- 不要只给片段。

### 7.2 如果只能文本输出（无文件能力）

按三段输出，保证可拼接：

**第 1 段**：从 `<!DOCTYPE html>` 到 Part 4 结束，最后一行 `<!-- PART1_END -->`。
**第 2 段**：从 `<!-- PART2_START -->` 到 Part 6 结束，最后一行 `<!-- PART2_END -->`。
**第 3 段**：从 `<!-- PART3_START -->` 到 `</html>`。

规则：

- 每段放在**一个** ```html 代码块里；代码块外只写"第 X/3 段，回复『继续』输出下一段"。
- 不要在第 1 段提前闭合 `</body></html>`；不要在第 2 段重复 `<html><head>`。
- 每段结尾必须是完整标签/完整章节，不能断在表格/代码块中间。
- 第 3 段末尾给自评分与"如何本地打开"。
- 如果一次能输出完整文件，直接给完整文件，并在开头写"完整版（1/1）"。

### 7.3 续写规则

- 用户回复"继续"时，从上次的标记之后**精确续写**，不要重复前文，不要重新总结。
- 如果发现前文有错，在续写开头用 3 行"更正"说明，然后继续。
- 不要在续写时降低详细度；后续章节必须同样有字段表/示例/图。

---

## 8. 交付前自检（GPT 在最后一段输出）

- [ ] 单文件、无外部依赖、可打印。
- [ ] 目录锚点全部可用；无空章节。
- [ ] 15 类配置概念全部覆盖。
- [ ] 12+ 切换案例全部有"是否过渡/策略/守卫/时长/回退"。
- [ ] 至少 8 张 SVG、15 张表、8 个完整 YAML、5 条 transition。
- [ ] 所有 T1 数字有 `[E-xx]`；所有 Collie 示例标 `[假设]`。
- [ ] Q1–Q15 全部裁决。
- [ ] 自评分与未决问题。
