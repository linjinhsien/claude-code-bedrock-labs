#!/bin/bash
# Lab 4: Claude Code 自動化 Code Review 示範
# Workshop: Claude Code on Amazon Bedrock

set -e

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CODE_USE_BEDROCK=1

echo "🔍 Lab 4: Claude Code 自動化 Code Review"
echo "=========================================="

# 建立範例程式碼供 review
echo ""
echo "📝 建立範例程式碼..."
mkdir -p /tmp/review-demo
cat > /tmp/review-demo/app.py << 'PYTHON'
import os
import sqlite3
from flask import Flask, request, jsonify

app = Flask(__name__)

# Database connection
def get_db():
    db = sqlite3.connect('users.db')
    return db

@app.route('/user', methods=['GET'])
def get_user():
    username = request.args.get('name')
    db = get_db()
    # SQL query
    result = db.execute(f"SELECT * FROM users WHERE name = '{username}'")
    user = result.fetchone()
    return jsonify({"user": user})

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    password = data['password']
    db = get_db()
    result = db.execute(f"SELECT * FROM users WHERE password = '{password}'")
    if result.fetchone():
        token = os.urandom(16).hex()
        return jsonify({"token": token, "password": password})
    return jsonify({"error": "invalid"}), 401

@app.route('/admin/delete', methods=['DELETE'])
def delete_all():
    db = get_db()
    db.execute("DELETE FROM users")
    db.commit()
    return jsonify({"status": "all users deleted"})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
PYTHON

echo "✅ 範例程式碼已建立: /tmp/review-demo/app.py"
echo ""

# 使用 Claude Code 進行自動 Review
echo "🤖 呼叫 Claude Code 進行安全性 Review..."
echo "-------------------------------------------"
echo ""

claude -p "請以資安專家的角度 review /tmp/review-demo/app.py。用繁體中文輸出，格式如下：
## 🚨 嚴重問題
列出每個嚴重的安全漏洞

## ⚠️ 警告
列出次要問題

## 💡 改善建議
列出最佳實踐建議

## ✅ 修正後的程式碼
提供修正後的完整程式碼" --dangerously-skip-permissions 2>&1 | grep -v "^Warning"

echo ""
echo "=========================================="
echo "✅ 自動 Code Review 完成！"
echo ""
echo "在實際 CI/CD 中，你可以："
echo "  1. 將 review 結果貼到 PR comment"
echo "  2. 根據嚴重程度決定是否 block merge"
echo "  3. 自動產生修正 PR"
