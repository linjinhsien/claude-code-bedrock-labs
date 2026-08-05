# Lab 1：設定 Claude Code + Amazon Bedrock

## 目標
在本實驗中，你將學會如何設定 Claude Code 以使用 Amazon Bedrock 作為模型提供者。

## 前置條件
- AWS 帳號（本 workshop 使用帳號 `481665125543`）
- 已安裝 Node.js 18+
- 有效的 AWS credentials（Access Key、Secret Key、Session Token）

## 步驟

### 1. 安裝 Claude Code
```bash
npm install -g @anthropic-ai/claude-code
```

### 2. 設定 AWS 環境變數
```bash
export AWS_DEFAULT_REGION="us-west-2"
export AWS_ACCESS_KEY_ID="你的Access Key"
export AWS_SECRET_ACCESS_KEY="你的Secret Key"
export AWS_SESSION_TOKEN="你的Session Token"
export CLAUDE_CODE_USE_BEDROCK=1
```

### 3. 建立 Claude Code 設定檔
```bash
mkdir -p ~/.claude
cat > ~/.claude/settings.json << 'EOF'
{
  "provider": "bedrock",
  "primaryProvider": "bedrock",
  "bedrock": {
    "region": "us-west-2"
  }
}
EOF
```

### 4. 驗證設定
```bash
claude --version
claude -p "Hello, are you running on Bedrock?" --dangerously-skip-permissions
```

## 自動設定
執行 `setup.sh` 可自動完成上述步驟（需要先設定 AWS 環境變數）：
```bash
chmod +x setup.sh
./setup.sh
```

## 注意事項
- Session Token 是臨時的，會過期
- `us-west-2` 和 `us-east-1` 是本帳號允許的區域
- Bedrock 模型需要事先在 AWS Console 中啟用
