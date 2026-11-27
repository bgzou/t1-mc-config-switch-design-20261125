# 摘录 · 运控对外接口与场景交互 §4.4（手牵）

### 4.4 模式 P4：变形 / 手牵 / 表演

```mermaid
sequenceDiagram
    autonumber
    participant P as 平台
    participant M as 运控
    participant H as HAL
    participant S as SM

    P->>M: SetMcAction(11 旋转变形)
    M->>M: 寻路 + 准入（站姿/无速度/电量）
    M->>H: 变形策略 100 Hz（≈4.8 s）
    Note over M,H: 期间腰部舵机联动、重力包络守护
    M-->>P: state.action=变形中
    M->>M: 完成 → 自动落位 300（WBC）
    M-->>P: state.action=300、form_state=双足
    P->>M: SetVelocity(source=interaction, v=0.3) 手牵行走
    Note over M: 手牵=WBC + 手臂柔顺（arm_drag）【推断】
```

| 子动作 | 接口 | 参数 | 备注 |
|---|---|---|---|
| 变形 | `SetMcAction` | `10/11`（Q→B）、`20/21`（B→Q） | 约 4.8 s；期间拒绝其他动作 |
| 手牵 | `SetVelocity` + 手臂柔顺参数 | `source=interaction` | 手臂拖拽参数在人牵方向可配置【推断】 |
| 表演 | `SetMcAction(109)` / `SetMcMotion` | 舞蹈/模仿 | 全身动作，会占用动作通道 |
| 结束回安全 | `SetMcAction(101/201)` | 站立 | 表演结束默认回站立 |

**关键约束**：

- 变形窗口内**不接受**普通动作请求（忙 → 拒绝），紧急安全路径除外；
- 变形后 `form_state` 变化，导航/避障布局需同步切换（dog↔human）；
- 手牵时若人走太快，运控无法"跟上"——需要限速约定（建议 ≤0.6 m/s）。
