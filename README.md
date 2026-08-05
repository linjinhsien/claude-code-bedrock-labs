# 🛠️ Workshop 實作紀錄：Claude Code on Amazon Bedrock

> 實作者：linjinhsien  
> 日期：2026-08-05  
> Workshop：[Claude Code on Amazon Bedrock](https://catalog.us-east-1.prod.workshops.aws/workshops/d26e21f4-3360-468f-b3b0-761e768d0427/en-US)  
> AWS Account: 481665125543 | Region: us-west-2

---

## 📋 實驗清單

| Lab | 主題 | 狀態 |
|-----|------|------|
| [Lab 1](./lab1-setup/) | 設定 Claude Code + Bedrock | ✅ 完成 |
| [Lab 2](./lab2-basic-usage/) | Claude Code 基本操作 | ✅ 完成 |
| [Lab 3](./lab3-bedrock-models/) | Bedrock 模型管理 | ✅ 完成 |
| [Lab 4](./lab4-automation/) | 自動化 Code Review & CI/CD | ✅ 完成 |

---

## 🏗️ 環境資訊

```
OS:       Linux (Debian 13 trixie) on AWS k3s pod
CPU:      Intel Xeon Platinum 8259CL @ 2.50GHz
RAM:      1.9 GiB
Node.js:  v24.19.0
Claude:   v2.1.222
Provider: Amazon Bedrock (us-west-2)
Role:     WSParticipantRole
```

## 🔑 AWS 帳號可用服務

| 服務 | 狀態 |
|------|------|
| Bedrock (InvokeModel) | ✅ |
| Bedrock AgentCore | ✅ |
| IAM (唯讀 + scoped 寫入) | ✅ |
| EC2 (唯讀) | ✅ |
| CloudFormation (scoped) | ✅ |
| Lambda (scoped) | ✅ |
| S3 (scoped) | ✅ |
| DynamoDB (scoped) | ✅ |
| ECS + ELB | ✅ |
| CloudWatch | ✅ |

---

## 🚀 快速開始

```bash
# 1. Clone 此 repo
git clone https://github.com/linjinhsien/claude-code-on-bedrock-workshop.git
cd claude-code-on-bedrock-workshop/workshop-labs

# 2. 設定 AWS credentials
export AWS_DEFAULT_REGION="us-west-2"
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_SESSION_TOKEN="your-token"

# 3. 執行 Lab 1 設定
cd lab1-setup && ./setup.sh

# 4. 依序執行各 Lab
cd ../lab2-basic-usage && ./demo.sh
cd ../lab3-bedrock-models && python3 list_models.py
cd ../lab4-automation && ./auto_review.sh
```

---

## 📚 參考資源

- [Guidance for Claude Code with Amazon Bedrock](https://github.com/aws-solutions-library-samples/guidance-for-claude-code-with-amazon-bedrock)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Amazon Bedrock User Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/)
