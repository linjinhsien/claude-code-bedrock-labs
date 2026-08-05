#!/bin/bash
# Lab 2: Claude Code 基本操作示範
# 需要先完成 Lab 1 的設定

set -e

# 載入 nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CODE_USE_BEDROCK=1

echo "🎯 Lab 2: Claude Code 基本操作示範"
echo "======================================"

# Demo 1: 簡單問答
echo ""
echo "📝 Demo 1: 簡單問答"
echo "-------------------"
echo "指令: claude -p \"用一句話解釋 Amazon Bedrock\""
echo ""
claude -p "用一句話解釋 Amazon Bedrock 是什麼，用繁體中文回答" --dangerously-skip-permissions 2>&1 | grep -v "^Warning"
echo ""

# Demo 2: 程式碼生成
echo "📝 Demo 2: 程式碼生成"
echo "-------------------"
echo "指令: claude -p \"寫一個 Python hello world with type hints\""
echo ""
claude -p "寫一個簡短的 Python hello world function with type hints，只輸出程式碼" --dangerously-skip-permissions 2>&1 | grep -v "^Warning"
echo ""

# Demo 3: 程式碼分析
echo "📝 Demo 3: 建立並分析程式碼"
echo "-------------------"
cat > /tmp/sample.py << 'PYTHON'
def calc(x, y, op):
    if op == "add":
        return x + y
    elif op == "sub":
        return x - y
    elif op == "mul":
        return x * y
    elif op == "div":
        return x / y
PYTHON
echo "建立了 /tmp/sample.py，請 Claude 分析..."
echo ""
claude -p "讀取 /tmp/sample.py 並指出潛在問題和改善建議，用繁體中文簡短回答" --dangerously-skip-permissions 2>&1 | grep -v "^Warning"
echo ""

# Demo 4: JSON 輸出
echo "📝 Demo 4: JSON 格式輸出"
echo "-------------------"
echo "指令: claude -p \"...\" --output-format json"
echo ""
claude -p "回傳一個 JSON，包含 name, version, status 三個欄位，描述這個 workshop 的狀態" --output-format json --dangerously-skip-permissions 2>&1 | grep -v "^Warning"
echo ""

echo "======================================"
echo "✅ Demo 完成！你已學會 Claude Code 的基本操作"
echo ""
echo "下一步: 前往 lab3-bedrock-models/ 學習模型管理"
