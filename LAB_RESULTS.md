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

## ✅ Lab 3: Bedrock 模型列表

| Model ID | Name | Streaming |
|----------|------|-----------|
| anthropic.claude-sonnet-4-20250514-v1:0 | Claude Sonnet 4 | ✅ |
| anthropic.claude-haiku-4-5-20251001-v1:0 | Claude Haiku 4.5 | ✅ |
| anthropic.claude-fable-5 | Claude Fable 5 | ✅ |
| anthropic.claude-sonnet-4-6 | Claude Sonnet 4.6 | ✅ |
| anthropic.claude-opus-4-6-v1 | Claude Opus 4.6 | ✅ |
| anthropic.claude-opus-5 | Claude Opus 5 | ✅ |
| anthropic.claude-opus-4-8 | Claude Opus 4.8 | ✅ |
| anthropic.claude-opus-4-7 | Claude Opus 4.7 | ✅ |
| anthropic.claude-sonnet-4-5-20250929-v1:0 | Claude Sonnet 4.5 | ✅ |
| anthropic.claude-sonnet-5 | Claude Sonnet 5 | ✅ |
| anthropic.claude-opus-4-1-20250805-v1:0 | Claude Opus 4.1 | ✅ |
| anthropic.claude-opus-4-5-20251101-v1:0 | Claude Opus 4.5 | ✅ |

---

## ✅ Lab 4: 自動化 Code Review

**Review 目標：** 一個有安全漏洞的 Flask 應用

**發現的嚴重漏洞：**
| # | 漏洞 | 說明 |
|---|------|------|
| 1 | SQL Injection | 直接拼接使用者輸入進 SQL |
| 2 | 密碼明文儲存 | 未經雜湊比對 |
| 3 | 回傳密碼至客戶端 | 違反最小揭露原則 |
| 4 | Debug + 0.0.0.0 | 暴露 Werkzeug debugger RCE |

**修正建議：** 參數化查詢、密碼雜湊、關閉 debug、限制監聽介面

---

## 🎉 全部 Lab 執行成功！
