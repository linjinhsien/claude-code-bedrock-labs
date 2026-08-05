# Lab 2：Claude Code 基本操作

## 目標
學會使用 Claude Code 的基本指令，包括互動模式、單次查詢、程式碼生成和檔案操作。

## 基本指令

### 單次查詢（Print 模式）
```bash
# 簡單問答
claude -p "用 Python 寫一個 fibonacci 函式"

# 指定模型
claude --model sonnet -p "解釋什麼是 AWS Bedrock"

# 限制花費
claude --max-budget-usd 0.50 -p "重構這段程式碼"
```

### 檔案操作
```bash
# 讓 Claude 讀取並分析檔案
claude -p "讀取 main.py 並找出潛在的 bug"

# 產生新檔案
claude -p "建立一個 Express.js REST API 的基本架構" --dangerously-skip-permissions
```

### 進階用法
```bash
# 繼續上次對話
claude --continue

# 以 JSON 格式輸出
claude -p "列出 3 個 Python best practices" --output-format json

# 串流 JSON 輸出（適合整合到 CI/CD）
claude -p "分析程式碼品質" --output-format stream-json
```

## 實作練習
執行 `demo.sh` 看完整示範：
```bash
chmod +x demo.sh
./demo.sh
```

## 進階設定
| 參數 | 說明 |
|------|------|
| `--model sonnet` | 使用 Sonnet 模型（較快較便宜）|
| `--model opus` | 使用 Opus 模型（最強但較貴）|
| `--effort low/medium/high` | 控制回答深度 |
| `--dangerously-skip-permissions` | 跳過權限確認（僅限 sandbox）|
| `--max-budget-usd N` | 限制 API 花費 |
