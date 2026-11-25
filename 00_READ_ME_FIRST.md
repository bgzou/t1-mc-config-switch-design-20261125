# 00 · 先读这一页

**给 GPT / 评审者的入口。** 本仓库是一个**公开的输入包**：用 T1 真机证据 + `roboparty_deploy` 基线，产出两份设计——**运控框架的 YAML 配置体系**与**模型切换/过渡的统一架构**。

仓库：<https://github.com/bgzou/t1-mc-config-switch-design-20261125>

---

## 1. 你要产出什么

一份**可评审、可落地、可验收**的设计文档（单文件 HTML），不是读书笔记、不是原则清单。最低要求：

- 框架团队能据此实现配置加载、校验、Registry、Graph、TransitionController、JointMux、OutputGuard、状态发布；
- 运控团队能据此交付策略资产（manifest / obs spec / action spec / transition spec / golden trace）；
- 测试能据此设计回放、切换图覆盖、故障注入、SIL/HIL；
- 非软件背景决策者能看懂"为什么这样分层、最坏会坏在哪、还要谁拍板"。

完整交付物结构、HTML 技术要求、评分 rubric、输出协议：**[08_DELIVERABLE_SPEC.md](08_DELIVERABLE_SPEC.md)**。

---

## 2. 15 分钟阅读顺序

| 顺序 | 文件 | 为什么 |
|---|---|---|
| 1 | [02_CONTEXT_BRIEF.md](02_CONTEXT_BRIEF.md) | T1 事实、`roboparty_deploy` 能力与缺口、Collie 约束、两套候选抽象的张力 |
| 2 | [03_YAML_DESIGN_REQUIREMENTS.md](03_YAML_DESIGN_REQUIREMENTS.md) | YAML 必须满足什么、至少覆盖哪些文件/概念、验收标准 |
| 3 | [04_SWITCHING_DESIGN_REQUIREMENTS.md](04_SWITCHING_DESIGN_REQUIREMENTS.md) | 切换类型、统一状态机、过渡描述符、策略库、12+ 案例 |
| 4 | [06_OPEN_QUESTIONS.md](06_OPEN_QUESTIONS.md) | 15 个必须裁决的问题 |
| 5 | [05_EVIDENCE_MAP.md](05_EVIDENCE_MAP.md) | 每条关键论断的证据与强度 |
| 6 | [07_GLOSSARY.md](07_GLOSSARY.md) | 术语对齐 |
| 7 | [08_DELIVERABLE_SPEC.md](08_DELIVERABLE_SPEC.md) | 最终 HTML 的章节/图表/评分/输出协议 |

---

## 3. 核心设计输入（按优先级）

### 第一优先：T1 的配置与切换证据

1. `packs/01_T1_SYSTEM_CONFIGS.md` — `mc_T1.yaml`、`action_setting.yaml`、`action_state.yaml`、`action_ruler.yaml`、`security_guard.yaml`、`robot_model.yaml`、`motion_list.yaml`、设备/系统模式/进程配置。
2. `packs/02_T1_POLICY_CONFIGS.md` — 48 份 RL 配置 + 13 份经典配置，覆盖行走/奔跑/越野/变形/mimic/位控/阻尼。
3. `packs/03_T1_SWITCHING_EVIDENCE.md` — 变身全流程、相位表、重力包络、落位、退出判据。
4. `packs/04_T1_SAFETY_AND_INPUTS.md` — 安全八层、三通道跌倒、速度源仲裁、超时族。
5. `packs/06_MODELS_AND_OBS.md` — 42 个 RL 条目、34 份权重、obs 布局、网络统计、动作→执行组表。
6. `packs/07_INTERFACES_AND_UPSTREAM.md` — MC 接口目录、任务引擎配置、需求原文。

### 第二优先：`roboparty_deploy` 基线

7. `packs/05_ROBOPARTY_DEPLOY.md` — README、`robot.yaml`、7 份策略配置、`inference_node`/`ros_interface`/`obs_manager`/`robot_interface` 源码、`motion_player.py`、launch/start 脚本。

### 第三优先：当前 Collie 基线（可修订，但要说明）

8. `packs/08_ANALYSIS_AND_BASELINE.md` — 当前 Runner 主文档、接口/数据链路、ADR-25 50 Hz、外部接口、需求。

**原始文件**在 `raw/` 下，packs 是带文件头的拼接版，便于一次读多份；需要核对行号/上下文时回到 raw。

> 注意：`raw/docs/` 里的原始文档保留了它们在自己项目里的相对链接，复制到本仓库后**可能断链**；不要因为链接 404 就跳过内容。以本页索引和 `packs/` 为准。

---

## 4. 如果浏览能力/上下文受限

**最低必读**（6 份）：

1. `00_READ_ME_FIRST.md`（本页）
2. `02_CONTEXT_BRIEF.md`
3. `03_YAML_DESIGN_REQUIREMENTS.md`
4. `04_SWITCHING_DESIGN_REQUIREMENTS.md`
5. `packs/03_T1_SWITCHING_EVIDENCE.md`
6. `packs/05_ROBOPARTY_DEPLOY.md`

然后至少再读 `packs/01`、`packs/02`、`packs/06`、`packs/08` 中的关键节。

在正文 Part 1 开头**列出你实际读了哪些、没读哪些、对设计结论有什么影响**。**不要假装读过。**

---

## 5. 证据规则

- `[事实]`：原始配置/IDL/源码/日志可核对；
- `[实测]`：真机日志/录制；
- `[文档]`：厂商或项目文档；
- `[假设]`：未冻结，必须给验证方法；
- `[建议]`：架构选择，需评审拍板；
- `[待定]`：需实验/标定/产品输入；
- `[推断]`：由证据推理，不是直接事实。

**硬规则**：

1. T1 的 Action ID、关节顺序、阈值、增益、模型尺度**不能直接复制**到 Collie；只复用结构关系与工程约束。
2. Collie 的关节拓扑/双足定义/权重/标定**未冻结**；示例数值必须标 `[假设]`，不能写成事实。
3. 正文引用证据写 `[E-xx]`（见 `05_EVIDENCE_MAP.md`），并给文件路径；不要只写"根据配置"。
4. 读不到的文件写 `UNKNOWN` 并给解决路径；不要编数字。
5. 发现文档冲突时，以原始配置/源码为准，并在正文指出冲突。

---

## 6. 两套候选抽象的张力（务必先看）

| 维度 | Runner 中心（当前主文档） | 简化交付（早期方案） |
|---|---|---|
| 行为表达 | `ActionBundle`（primary + overlay + owns_mask） | `Behavior + CONTINUOUS/ONE_SHOT + ALL/LEGS/UPPER` |
| 过渡 | 独立 `TransitionRunner`（phase 驱动） | `ONE_SHOT + return_to` |
| 叠加 | `OverlayRunner` + 冲突检查 | `Scope=UPPER` 与 `LEGS` 并行 |
| 对外 | 3 类领域接口 + Adapter | 4 个 RPC |
| 复杂度 | 高，贴近 T1 | 低，易交付 |

**任务不是简单选一个**，而是给出**统一模型**：用一套最小概念同时表达连续、一次性、过渡、叠加、安全五类行为，并说明如何裁剪/迁移。YAML 必须能承载这套模型；如果承载不了，要明确说"哪一层放弃、为什么"。

---

## 7. 仓库结构

```text
README.md                          仓库入口
00_READ_ME_FIRST.md                本页
01_PROMPT_FOR_GPT.md               可直接复制给 GPT 的任务书
02_CONTEXT_BRIEF.md                15 分钟背景
03_YAML_DESIGN_REQUIREMENTS.md     YAML 硬性要求
04_SWITCHING_DESIGN_REQUIREMENTS.md 切换/过渡硬性要求
05_EVIDENCE_MAP.md                 论断→证据
06_OPEN_QUESTIONS.md               必须裁决的问题
07_GLOSSARY.md                     术语
08_DELIVERABLE_SPEC.md             HTML 结构/评分/输出协议
packs/                             按主题拼接的高密度阅读包
raw/                               原始文件（T1 配置/文档/接口/模型清单 + roboparty 源码/配置）
MANIFEST.csv                       文件清单 + SHA256 + 来源路径
SHA256SUMS.txt                     校验和
```

---

## 8. 开始

读完以上，直接打开 **[01_PROMPT_FOR_GPT.md](01_PROMPT_FOR_GPT.md)**，从"任务"一节开始执行。不要等确认，不要先提问；信息不足时做最合理假设并标注。
