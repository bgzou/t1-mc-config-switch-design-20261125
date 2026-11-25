# 启动语（短版）

如果你想先发一句短消息，让 GPT 自己打开仓库读任务书，用下面这段；更稳妥的是直接复制 `PROMPT_TO_COPY.md` 全文。

```text
你是一名资深机器人运控软件架构师。请打开并完整阅读：
https://github.com/bgzou/t1-mc-config-switch-design-20261125
先读 00_READ_ME_FIRST.md、02_CONTEXT_BRIEF.md、03_YAML_DESIGN_REQUIREMENTS.md、04_SWITCHING_DESIGN_REQUIREMENTS.md、06_OPEN_QUESTIONS.md，再按 packs/00_START_HERE.md 的顺序读证据包。然后严格按 01_PROMPT_FOR_GPT.md 的任务，产出一份单文件 HTML 设计文档（T1_MC_YAML_SWITCH_DESIGN.html）。不要先问问题；信息不足时做最合理假设并标注。如果输出长度受限，按该文件第 8 节的三段协议输出。
```
