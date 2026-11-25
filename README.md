# T1 MC Config & Switch Design · 2026-11-25

> 公开输入包：为网页版 GPT 提供 **T1 真机证据 + `roboparty_deploy` 基线**，产出两份设计——
> ① 运控框架的 **YAML 配置体系**；② 模型与模型之间 **切换/过渡的统一架构**（含经典/RL、同形态/跨形态、一次性/连续、安全接管）。

**仓库**：<https://github.com/bgzou/t1-mc-config-switch-design-20261125>

---

## 这是什么 / 不是什么

- **是**：给 GPT 的输入包 + 任务书 + 可核对的原始配置/源码/文档；给框架团队和运控团队的契约素材。
- **不是**：代码仓库、训练资料、Collie 标定值、最终架构冻结版。
- **不含**：ONNX 权重（926 MB）、真机二进制（约 1.5 GB）、`roboto_origin-main` 全树（2.1 GB）、历史站点报告。
  这些的替代查找方式见 `raw/NOT_INCLUDED.md`。

---

## 从这里开始

1. **[00_READ_ME_FIRST.md](00_READ_ME_FIRST.md)** — 阅读顺序、证据规则、两套候选抽象的张力。
2. **[01_PROMPT_FOR_GPT.md](01_PROMPT_FOR_GPT.md)** — **可直接复制给网页版 GPT 的任务书**（含仓库链接、必读清单、交付物、HTML 结构、评分、输出协议）。只想复制正文用 **[PROMPT_TO_COPY.md](PROMPT_TO_COPY.md)**；想先发一句短消息用 **[LAUNCH_PROMPT.md](LAUNCH_PROMPT.md)**。
3. **[02_CONTEXT_BRIEF.md](02_CONTEXT_BRIEF.md)** — 15 分钟背景：T1 事实、roboparty 能力/缺口、Collie 约束。
4. **[03_YAML_DESIGN_REQUIREMENTS.md](03_YAML_DESIGN_REQUIREMENTS.md)** — YAML 必须满足的 R1–R15、至少覆盖的 15 类概念。
5. **[04_SWITCHING_DESIGN_REQUIREMENTS.md](04_SWITCHING_DESIGN_REQUIREMENTS.md)** — 切换类型、统一状态机、TransitionSpec、策略库、12+ 案例。
6. **[05_EVIDENCE_MAP.md](05_EVIDENCE_MAP.md)** — 论断→证据→强度。
7. **[06_OPEN_QUESTIONS.md](06_OPEN_QUESTIONS.md)** — 15 个必须裁决的问题。
8. **[07_GLOSSARY.md](07_GLOSSARY.md)** — 术语。
9. **[08_DELIVERABLE_SPEC.md](08_DELIVERABLE_SPEC.md)** — 最终 HTML 的章节/图表/评分/输出协议。

---

## 核心问题

Collie 的运控框架由另一个团队基于 `roboparty_deploy` 设计与适配。本轮不设计框架代码，而是定义：

- **配置契约**：机器人/硬件/标定、策略 manifest、obs/action spec、ActionBundle、动作图、过渡边、安全、速度源、调度、日志/回放、站点覆盖；单一事实源、严格校验、可迁移、可回滚。
- **切换架构**：一套 `Plan → Prepare → Handoff → Stabilize` 状态机 + 一套 `TransitionSpec` + 一组可插拔策略；同形态/跨形态/经典↔RL/一次性↔连续/安全接管都用同一架构表达，差异在数据，不在专门代码。
- **与框架协同**：谁 tick、谁拥有 50/200 Hz、谁写关节、观测历史怎么处理、失败怎么回退、状态/事件怎么发布、怎么回放/验收。

---

## 仓库地图

```text
README.md                            本页
00_READ_ME_FIRST.md                  阅读入口
01_PROMPT_FOR_GPT.md                 任务书（复制给 GPT）
02_CONTEXT_BRIEF.md                  背景综合
03_YAML_DESIGN_REQUIREMENTS.md       YAML 要求
04_SWITCHING_DESIGN_REQUIREMENTS.md  切换要求
05_EVIDENCE_MAP.md                   证据地图
06_OPEN_QUESTIONS.md                 必须裁决的问题
07_GLOSSARY.md                       术语
08_DELIVERABLE_SPEC.md               HTML 交付规格
packs/                               按主题拼接的阅读包（带 FILE 头）
raw/
  t1/config/                         T1 真机 YAML（动作/图/状态/安全/RL/经典/URDF）
  t1/transitions/                    变身重力包络录制 CSV
  t1/hardware/                       设备/系统模式/进程配置
  t1/task_engine/                    任务层动作/姿态/编排配置
  t1/interfaces/                     MC 接口目录 + 关键 msg/srv
  t1/model_lists/                    动作→执行组→runner、RL 权重、obs 布局、网络统计
  docs/                              T1 逆向/变身/安全/三链路 + 当前 Collie 基线 + 需求
  roboparty/                         roboparty_deploy 的 README/配置/源码/脚本
MANIFEST.csv                         文件清单 + SHA256 + 来源
SHA256SUMS.txt                       校验和
```

---

## 证据规则（摘要）

- T1 数字**不能直接复制**到 Collie；只复用结构关系与工程约束。
- Collie 关节拓扑/双足定义/权重/标定**未冻结**；示例必须标 `[假设]`。
- 正文引用证据用 `[E-xx]` + 文件路径；读不到写 `UNKNOWN`。
- 原始配置/源码优先于二手文档；发现冲突要指出。

---

## 使用方式

1. 打开 `01_PROMPT_FOR_GPT.md`，从"任务"一节开始整段复制给网页版 GPT（需开启联网/浏览）。
2. 让 GPT 先读 `00_READ_ME_FIRST.md`、`02`–`04`，再读 `packs/01`–`08`；读不完的在 Part 1 声明。
3. GPT 按 `08_DELIVERABLE_SPEC.md` 输出单文件 HTML；如果长度受限，按三段拼接。
4. 第一轮重点看：决策表、YAML 文件地图、`TransitionSpec`、状态机、12+ 案例、与 roboparty 的协同/迁移。

> 仓库为 Public，含 T1 真机配置与内网 IP；已检查未发现密码/私钥。若要放敏感数据，改用私有仓库或企业版 GPT。网页版 GPT 无法访问私有仓库。
>
> 已把上游开源 README 中的默认 AP 密码替换为 `<REDACTED_DEFAULT_AP_PASSWORD>`，见 `raw/REDACTIONS.md`；内网 IP 仍保留在证据文档中，属实验室地址，不是凭据。
>
> 第三方来源与许可见 `THIRD_PARTY_NOTICES.md`；`roboparty_deploy` 源码为 GPL-3.0-only。

---

*整理：2026-11-25。目录/链接变更见 `MANIFEST.csv`。*
