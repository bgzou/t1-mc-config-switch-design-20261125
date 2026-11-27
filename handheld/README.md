# T1 牵手跟随（Hand-Held Follow）机制分析 · 2026-11-27

> 公开输入包：把 **T1 真机配置 + 接口 + 模型 IO + 我们的待验证假设** 交给网页版 GPT，让它独立回答三个问题：
> ① 怎么判定"进入牵手"？是不是"通用四足行走 + 另配一个换 kp/kd 的 runner"？
> ② 具体切换/准入/准出流程是什么？要不要单独进"牵手模式"，还是待机时牵一下自动进入？
> ③ 速度到底怎么解算出来的？逐项拆开。

**仓库**：<https://github.com/bgzou/t1-mc-config-switch-design-20261125/tree/main/handheld>

---

## 这是什么 / 不是什么

- **是**：一份可核对的证据包 + 任务书。证据来自板端 YAML、IDL/msg、ONNX 输入输出、任务规则。
- **不是**：代码仓库；T1 没有开源运控源码，`arm_drag` / `ArmDragLocomotion` 只有**配置字段**和**注释**，没有实现。
- **不含**：ONNX 权重（只给 IO 形状）、真机二进制、日志原始包。
- **重要**：`raw/analysis/` 里是我们自己的**假设稿**，不是证据。Prompt 要求 GPT **先独立读证据，再逐条裁决这份假设**（同意/修正/反驳），不许照抄。

---

## 从这里开始

1. **[00_READ_ME_FIRST.md](00_READ_ME_FIRST.md)** — 阅读顺序、证据规则、三层框架（Action / Runner 内部 / Command）。
2. **[02_CONTEXT_BRIEF.md](02_CONTEXT_BRIEF.md)** — 15 分钟背景：T1 构型、300 WBC、配置地图、已确认事实与未知、**UC3 真机日志实证**。
3. **[03_THREE_QUESTIONS.md](03_THREE_QUESTIONS.md)** — 三个问题的展开与验收标准（GPT 必须逐条回答）。
4. **[01_PROMPT_FOR_GPT.md](01_PROMPT_FOR_GPT.md)** — **可直接复制给网页版 GPT 的任务书**；纯文本版 [PROMPT_TO_COPY.txt](PROMPT_TO_COPY.txt)。
5. **[04_EVIDENCE_MAP.md](04_EVIDENCE_MAP.md)** — 论断 → 文件/字段 → 强度。
6. **[05_OPEN_QUESTIONS.md](05_OPEN_QUESTIONS.md)** — 必须裁决的 12 个问题。
7. **[06_GLOSSARY.md](06_GLOSSARY.md)** — 术语。
8. **[07_DELIVERABLE_SPEC.md](07_DELIVERABLE_SPEC.md)** — HTML 章节、图、评分、输出协议。

---

## 仓库地图

```text
README.md                       本页
00_READ_ME_FIRST.md             阅读入口 + 证据规则
01_PROMPT_FOR_GPT.md            任务书（复制给 GPT）
02_CONTEXT_BRIEF.md             背景与已知事实
03_THREE_QUESTIONS.md           三问展开 + 验收标准
04_EVIDENCE_MAP.md              证据地图
05_OPEN_QUESTIONS.md            必须裁决的问题
06_GLOSSARY.md                  术语
07_DELIVERABLE_SPEC.md          HTML 交付规格
PROMPT_TO_COPY.md / .txt        仅任务书正文（可直接粘贴）
LAUNCH_PROMPT.md                一句短消息（先让 GPT 打开仓库）
packs/                          按主题拼接的阅读包（每个文件带 FILE 头）
  01_HANDHELD_CONFIGS.md        牵手相关全部配置：WBC/GIMBAL/动画/WBC 对比
  02_ACTION_SAFETY_AND_GATING.md 动作图、执行组、安全、状态、任务门控
  03_INTERFACES_AND_RULES.md    McAction 全枚举、held_state、SetMcInputSource、14 条规则
  04_ANALYSIS_HYPOTHESIS.md     我们的假设稿 + T1 架构/接口文档摘录
  05_MODEL_IO_AND_LIMITS.md     ONNX IO、obs 布局、关节限位、URDF
  06_TRANSITIONS_DEVICE_AND_LISTS.md 变身 runner、device_manager、动作/模型清单
  07_REAL_MACHINE_LOG.md        UC3 真机日志：held 时间线 + 4 个原始窗口
raw/                            原始证据（UTF-8 副本、去除 BOM，见 raw/ENCODING.md）
  t1/                           配置、接口、任务规则、变身/设备
  model_list/                   派生的动作/权重/规则图/观测清单
  logs/                         UC3 日志摘录（全量 10.8 MB 未打包）
  docs/                         文档摘录
  docs_full/                    完整内部文档（二手；冲突时以配置为准）
  INDEX.md                      每个文件干什么、按问题查
  NOT_INCLUDED.md               没放什么、为什么
MANIFEST.csv                    文件清单 + SHA256 + 原始路径 + 编码
SHA256SUMS.txt                  校验和
```

---

## 证据规则（摘要）

- **配置优先于文档**；文档里的数字若与 YAML 冲突，以 YAML 为准。
- 任何结论必须给 `文件路径 + 字段名`；只有字段名而推不出语义的，写 `[推断]`。
- 仓库没有源码：**算法结构靠字段名、注释、数值关系反推**，必须显式标注推断与不确定性。
- 不要编造字段、单位、量纲；不确定就写 `UNKNOWN` 并给出验证方法。
- T1 的数值不能直接搬到 Collie；只复用结构关系与工程约束。

---

## 使用方式

1. 打开 `01_PROMPT_FOR_GPT.md`，从 `## 任务` 一节开始整段复制；或直接复制 `PROMPT_TO_COPY.txt`。
2. 让 GPT 先打开仓库、读 `00`/`02`/`03`，再读 `packs/01`–`05`；读不完的必须在正文开头声明。
3. 要求它先独立给结论，再对照 `raw/analysis/` 的假设逐条裁决。
4. 输出单文件 HTML；长度受限时按 Part 分段并标注续写。

> 仓库为 Public，含 T1 真机配置与实验室网段；已检查未发现密码/私钥。若要放更敏感数据，应改用私有仓库或企业版 GPT。
