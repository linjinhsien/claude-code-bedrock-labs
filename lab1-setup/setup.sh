#!/bin/bash
# Lab 1: Claude Code + Bedrock 自動設定腳本
# Workshop: Claude Code on Amazon Bedrock
# Region: us-west-2 | Account: 481665125543

set -e

echo "🚀 Claude Code + Amazon Bedrock 設定工具"
echo "========================================="

# 檢查 AWS 環境變數
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "❌ 錯誤：請先設定 AWS 環境變數"
  echo "   export AWS_ACCESS_KEY_ID=..."
  echo "   export AWS_SECRET_ACCESS_KEY=..."
  echo "   export AWS_SESSION_TOKEN=..."
  exit 1
fi

# 設定 Bedrock 環境
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-west-2}"
export CLAUDE_CODE_USE_BEDROCK=1

echo "✅ AWS Region: $AWS_DEFAULT_REGION"

# 驗證 AWS 身份
echo ""
echo "📋 驗證 AWS 身份..."
aws sts get-caller-identity 2>/dev/null || {
  echo "❌ AWS 認證失敗，請檢查 credentials"
  exit 1
}

# 安裝 Claude Code（如果未安裝）
if ! command -v claude &> /dev/null; then
  echo ""
  echo "📦 安裝 Claude Code..."
  npm install -g @anthropic-ai/claude-code
fi

echo ""
echo "📋 Claude Code 版本: $(claude --version)"

# 建立設定檔
echo ""
echo "⚙️  建立 ~/.claude/settings.json..."
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
echo "✅ 設定完成"

# 測試連線
echo ""
echo "🧪 測試 Bedrock 連線..."
RESPONSE=$(claude -p "Say 'Bedrock connection successful' in exactly those words" --dangerously-skip-permissions 2>&1 | grep -i "successful" || true)

if [ -n "$RESPONSE" ]; then
  echo "✅ Bedrock 連線成功！"
else
  echo "⚠️  連線測試結果不確定，請手動驗證：claude -p 'hello'"
fi

echo ""
echo "========================================="
echo "🎉 設定完成！你現在可以使用 Claude Code on Bedrock"
echo ""
echo "使用方式："
echo "  互動模式: claude"
echo "  單次指令: claude -p \"你的問題\""
echo "  背景執行: claude --background -p \"任務\""
