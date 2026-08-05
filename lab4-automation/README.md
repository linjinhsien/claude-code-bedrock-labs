# Lab 4：Claude Code 自動化 — Code Review & CI/CD 整合

## 目標
學會將 Claude Code 整合到自動化工作流程中，包括自動 code review、CI/CD pipeline 整合、以及批次任務處理。

## 自動化場景

### 場景 1：自動 Code Review
```bash
# Review 最近的 git changes
claude -p "Review the git diff and provide feedback" --dangerously-skip-permissions

# Review 特定檔案
claude -p "Review main.py for security issues, performance problems, and code style" --dangerously-skip-permissions
```

### 場景 2：CI/CD 整合
```bash
# 在 GitHub Actions 中使用
claude -p "Run tests and fix any failures" \
  --dangerously-skip-permissions \
  --max-budget-usd 1.00 \
  --output-format json
```

### 場景 3：批次文件生成
```bash
# 自動產生 API 文件
claude -p "Generate OpenAPI spec for all endpoints in src/routes/" \
  --dangerously-skip-permissions \
  --output-format text > api-docs.yaml
```

## 實作練習

執行自動 review 示範：
```bash
chmod +x auto_review.sh
./auto_review.sh
```

## GitHub Actions 範例

```yaml
# .github/workflows/claude-review.yml
name: Claude Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code
      - name: Run Review
        env:
          AWS_DEFAULT_REGION: us-west-2
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          CLAUDE_CODE_USE_BEDROCK: "1"
        run: |
          claude -p "Review the changes in this PR. Focus on security, performance, and best practices. Output as markdown." \
            --dangerously-skip-permissions \
            --output-format text > review.md
          gh pr comment ${{ github.event.pull_request.number }} --body-file review.md
```

## 注意事項
- `--dangerously-skip-permissions` 僅用於受信任的 sandbox 環境
- 生產環境請使用 `--max-budget-usd` 控制成本
- CI/CD 中建議用 `--output-format json` 方便後續處理
