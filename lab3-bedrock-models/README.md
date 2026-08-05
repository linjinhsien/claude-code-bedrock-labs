# Lab 3：Bedrock 模型管理

## 目標
學會列出和選擇 Amazon Bedrock 上可用的 Claude 模型，理解 cross-region inference 和模型選擇策略。

## ⚠️ 重要觀念

`aws bedrock list-foundation-models` 列出的是 Bedrock **上架**的所有模型，**不代表你的帳號有權限呼叫**。

高階模型（Opus 5、Sonnet 5 等）需要另外向 AWS 申請 access。

## 實測結果（帳號 481665125543）

### ✅ 可用模型（需使用 cross-region inference profile `us.*`）

| 模型 | Profile ID | 狀態 |
|------|-----------|------|
| Claude Sonnet 4.6 | `us.anthropic.claude-sonnet-4-6` | ✅ 可呼叫 |
| Claude Haiku 4.5 | `us.anthropic.claude-haiku-4-5-20251001-v1:0` | ✅ 可呼叫 |

### ❌ 無權限模型（AccessDeniedException）

| 模型 | 錯誤訊息 |
|------|---------|
| Claude Opus 5 | "is not available for this account" |
| Claude Opus 4.8 | "is not available for this account" |
| Claude Sonnet 5 | "is not available for this account" |
| Claude Fable 5 | "is not available for this account" |
| Claude Sonnet 4 (原版) | "is not available for this account" |

### 直接呼叫 vs Cross-Region Profile

```bash
# ❌ 直接用 model ID — 全部失敗
aws bedrock-runtime converse --model-id "anthropic.claude-sonnet-4-6" ...
# → AccessDeniedException

# ✅ 用 cross-region inference profile — 部分成功
aws bedrock-runtime converse --model-id "us.anthropic.claude-sonnet-4-6" ...
# → 正常回應
```

## 操作步驟

### 1. 列出上架模型（不代表可用）
```bash
aws bedrock list-foundation-models --region us-west-2 \
  --query "modelSummaries[?contains(providerName,'Anthropic')].{ID:modelId,Name:modelName}" \
  --output table
```

### 2. 列出 Inference Profiles（確認可用的 cross-region 路由）
```bash
aws bedrock list-inference-profiles --region us-west-2 \
  --query "inferenceProfileSummaries[?contains(inferenceProfileId,'anthropic')].{id:inferenceProfileId,status:status}" \
  --output table
```

### 3. 實際測試模型是否可呼叫
```bash
aws bedrock-runtime converse \
  --model-id "us.anthropic.claude-sonnet-4-6" \
  --region us-west-2 \
  --messages '[{"role":"user","content":[{"text":"hi"}]}]' \
  --inference-config '{"maxTokens":10}'
```

### 4. 使用 Python 腳本列出模型
```bash
python3 list_models.py
```

## Claude Code 的 Fallback 機制

Claude Code 會自動處理模型不可用的情況：
```
Warning: Opus: Opus 5 not available — using Opus 4.6 for this session
```

當你指定 `--model opus` 但 Opus 5 無權限時，它會自動降級到可用的模型（本帳號實際使用 Sonnet 4.6）。

## 在 Claude Code 中使用模型
```bash
# 讓 Claude Code 自動選擇（推薦）
claude -p "你的問題"

# 指定 Sonnet（本帳號實際可用）
claude --model sonnet -p "你的問題"

# 指定 Haiku（快速便宜）
claude --model haiku -p "這段 code 有 bug 嗎？"
```

## Cross-Region Inference
現代 Claude 模型（3.7+）**必須**使用 cross-region inference profile：
- `us.*` — US 區域路由（us-east-1 + us-west-2）
- `global.*` — 全球路由

本 workshop 使用 `us-west-2` 區域，模型前綴為 `us.`。

## 成本考量
- Haiku 4.5: 最便宜最快
- Sonnet 4.6: 平衡品質與成本（本帳號推薦）
- Opus 系列: 最強但需額外申請 access

建議開發階段用 Sonnet，簡單任務用 Haiku。
