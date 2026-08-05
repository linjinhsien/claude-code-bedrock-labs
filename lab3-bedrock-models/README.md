# Lab 3：Bedrock 模型管理

## 目標
學會列出和選擇 Amazon Bedrock 上可用的 Claude 模型，理解 cross-region inference 和模型選擇策略。

## 可用模型

在 Claude Code 中可使用以下模型別名：
| 別名 | 模型 | 特點 |
|------|------|------|
| `sonnet` | Claude Sonnet (最新) | 平衡速度和品質 |
| `opus` | Claude Opus (最新) | 最強推理能力 |
| `haiku` | Claude Haiku (最新) | 最快最便宜 |

## 操作步驟

### 1. 列出可用模型
```bash
aws bedrock list-foundation-models --region us-west-2 \
  --query "modelSummaries[?contains(providerName,'Anthropic')].{ID:modelId,Name:modelName}" \
  --output table
```

### 2. 使用 Python 腳本列出模型
```bash
python3 list_models.py
```

### 3. 在 Claude Code 中切換模型
```bash
# 使用 Sonnet（推薦，性價比最高）
claude --model sonnet -p "你的問題"

# 使用 Opus（最強，複雜任務用）
claude --model opus -p "設計一個微服務架構"

# 使用 Haiku（快速回答用）
claude --model haiku -p "這段 code 有 bug 嗎？"
```

## Cross-Region Inference
Bedrock 支援跨區域推理，確保高可用性：
- **US Profile**: us-east-1 + us-west-2
- **EU Profile**: eu-west-1 + eu-central-1

本 workshop 使用 `us-west-2` 區域。

## 成本考量
- Haiku: ~$0.25/M input tokens
- Sonnet: ~$3/M input tokens  
- Opus: ~$15/M input tokens

建議開發階段用 Sonnet，簡單任務用 Haiku，關鍵決策用 Opus。
