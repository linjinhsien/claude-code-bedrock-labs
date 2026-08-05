#!/usr/bin/env python3
"""
Lab 3: 列出 Amazon Bedrock 上可用的 Claude 模型
Workshop: Claude Code on Amazon Bedrock
Region: us-west-2 | Account: 481665125543
"""

import json
import subprocess
import sys


def run_aws_command(cmd: list[str]) -> dict:
    """執行 AWS CLI 指令並回傳 JSON 結果"""
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"❌ 錯誤: {result.stderr}")
        sys.exit(1)
    return json.loads(result.stdout)


def list_claude_models():
    """列出所有可用的 Anthropic Claude 模型"""
    print("🔍 查詢 Amazon Bedrock 可用的 Claude 模型...")
    print("=" * 60)

    # 列出 foundation models
    data = run_aws_command([
        "aws", "bedrock", "list-foundation-models",
        "--region", "us-west-2",
        "--output", "json"
    ])

    # 過濾 Anthropic 模型
    claude_models = [
        m for m in data.get("modelSummaries", [])
        if "anthropic" in m.get("providerName", "").lower()
    ]

    if not claude_models:
        print("⚠️  未找到 Claude 模型，請確認 Bedrock 已啟用")
        return

    print(f"\n📋 找到 {len(claude_models)} 個 Claude 模型:\n")
    print(f"{'模型 ID':<50} {'狀態':<12} {'串流'}")
    print("-" * 80)

    for model in sorted(claude_models, key=lambda x: x.get("modelId", "")):
        model_id = model.get("modelId", "N/A")
        status = model.get("modelLifecycle", {}).get("status", "N/A")
        streaming = "✅" if model.get("responseStreamingSupported", False) else "❌"
        print(f"{model_id:<50} {status:<12} {streaming}")

    print("\n" + "=" * 60)
    print("💡 提示：在 Claude Code 中使用模型：")
    print("   claude --model sonnet -p \"你的問題\"")
    print("   claude --model opus -p \"複雜任務\"")


def list_inference_profiles():
    """列出 inference profiles"""
    print("\n\n🔍 查詢 Inference Profiles...")
    print("=" * 60)

    data = run_aws_command([
        "aws", "bedrock", "list-inference-profiles",
        "--region", "us-west-2",
        "--output", "json"
    ])

    profiles = data.get("inferenceProfileSummaries", [])
    claude_profiles = [
        p for p in profiles
        if "claude" in p.get("inferenceProfileId", "").lower()
        or "anthropic" in p.get("inferenceProfileId", "").lower()
    ]

    if claude_profiles:
        print(f"\n📋 找到 {len(claude_profiles)} 個 Claude Inference Profile:\n")
        for p in claude_profiles[:10]:  # 只顯示前 10 個
            print(f"  • {p.get('inferenceProfileId', 'N/A')}")
            print(f"    狀態: {p.get('status', 'N/A')}")
            print()
    else:
        print("  未找到 Claude inference profiles")


if __name__ == "__main__":
    list_claude_models()
    list_inference_profiles()
    print("\n✅ Lab 3 完成！")
