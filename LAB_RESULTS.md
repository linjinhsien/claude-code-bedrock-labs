# 🧪 Lab 執行結果紀錄

> 執行時間：2026-08-05 02:38 UTC  
> 環境：AWS k3s pod (us-west-2)  
> 帳號：481665125543 (WSParticipantRole)

---

## ✅ Lab 1: 設定 Claude Code + Bedrock

```
📋 AWS Identity:
  UserId: AROAXAJL2RST4OBOA3I37:Participant
  Account: 481665125543
  Arn: arn:aws:sts::481665125543:assumed-role/WSParticipantRole/Participant

📋 Claude Code Version: 2.1.222
🧪 測試 Bedrock 連線... Bedrock 連線成功！
✅ Lab 1 完成！
```

---

## ✅ Lab 2: Claude Code 基本操作

**Demo 1 - 解釋 Bedrock:**
> Amazon Bedrock 是 AWS 提供的全託管服務，讓開發者透過統一的 API 存取多家供應商的基礎模型（如 Claude、Llama、Titan 等），無需自行管理基礎設施即可建構生成式 AI 應用。

**Demo 2 - 程式碼生成:**
```python
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b
```

---

## ✅ Lab 3: Bedrock 模型實測

### ⚠️ 重要發現
`list-foundation-models` 列出 12 個 Claude 模型，但**實測只有 2 個可呼叫**。

### 實測結果（使用 cross-region inference profile）

| 模型 | Profile ID | 狀態 |
|------|-----------|------|
| Claude Sonnet 4.6 | `us.anthropic.claude-sonnet-4-6` | ✅ 可用 |
| Claude Haiku 4.5 | `us.anthropic.claude-haiku-4-5-20251001-v1:0` | ✅ 可用 |
| Claude Opus 5 | `us.anthropic.claude-opus-5` | ❌ 帳號無權限 |
| Claude Opus 4.8 | `us.anthropic.claude-opus-4-8` | ❌ 帳號無權限 |
| Claude Sonnet 5 | `us.anthropic.claude-sonnet-5` | ❌ 帳號無權限 |
| Claude Fable 5 | `us.anthropic.claude-fable-5` | ❌ 帳號無權限 |
| Claude Sonnet 4 | `us.anthropic.claude-sonnet-4-20250514-v1:0` | ❌ 帳號無權限 |

### 關鍵知識點
1. **直接呼叫 model ID 全部失敗** — 必須使用 `us.*` cross-region inference profile
2. **上架 ≠ 可用** — 高階模型需向 AWS 另外申請 access
3. **Claude Code 自動 fallback** — 指定 opus 時會自動降級到 Sonnet 4.6

---

## ✅ Lab 4: 自動化 Code Review

**Review 目標：** 一個有安全漏洞的 Flask 應用

**發現的嚴重漏洞：**
| # | 漏洞 | 嚴重度 | 說明 |
|---|------|--------|------|
| 1 | SQL Injection | 🔴 嚴重 | 使用者輸入直接拼接 SQL |
| 2 | 密碼明文儲存 | 🔴 嚴重 | 未經雜湊儲存與比對 |
| 3 | 密碼外洩 | 🟠 高 | API 回應包含明文密碼 |
| 4 | Debug 模式 | 🟠 高 | 暴露 Werkzeug debugger RCE |

**修正重點：**
- SQL 改用 `?` 參數化查詢
- 密碼改用 `check_password_hash` 比對
- 回應中移除密碼欄位
- 關閉 debug、限制監聽介面

---

## 🎉 全部 Lab 執行成功！
