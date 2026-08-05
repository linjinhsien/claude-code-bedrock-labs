#!/usr/bin/env python3
"""
Lab 3: 列出並實測 Amazon Bedrock 上可用的 Claude 模型
Workshop: Claude Code on Amazon Bedrock
Region: us-west-2 | Account: 481665125543

重要：list-foundation-models 列出的是上架模型，不代表帳號有權限呼叫。
本腳本會實際測試每個模型是否可呼叫。
"""

import json
import subprocess
import sys


def run_aws_command(cmd: list[str]) -> tuple[int, str]:
    """執行 AWS CLI 指令，回傳 (return_code, output)"""
    result = subprocess.run(cmd, capture_output=True, text=True)
    output = result.stdout if result.returncode == 0 else result.stderr + result.stdout
    return result.returncode, output


def list_claude_models():
    """列出所有上架的 Anthropic Claude 模型"""
    print("🔍 查詢 Amazon Bedrock 上架的 Claude 模型...")
    print("=" * 60)

    rc, output = run_aws_command([
        "aws", "bedrock", "list-foundation-models",
        "--region", "us-west-2",
        "--output", "json"
    ])

    if rc != 0:
        print(f"❌ 錯誤: {output}")
        sys.exit(1)

    data = json.loads(output)
    claude_models = [
        m for m in data.get("modelSummaries", [])
        if "anthropic" in m.get("providerName", "").lower()
    ]

    print(f"\n📋 上架模型數量: {len(claude_models)} 個")
    print("⚠️  注意：上架 ≠ 可用，需實際測試\n")
    return claude_models


def test_model_access(model_id: str) -> tuple[bool, str]:
    """實際測試模型是否可呼叫"""
    rc, output = run_aws_command([
        "aws", "bedrock-runtime", "converse",
        "--model-id", model_id,
        "--region", "us-west-2",
        "--messages", '[{"role":"user","content":[{"text":"hi"}]}]',
        "--inference-config", '{"maxTokens":5}',
        "--output", "json"
    ])

    if rc == 0:
        return True, "OK"
    elif "not available for this account" in output:
        return False, "帳號無權限"
    elif "AccessDenied" in output:
        return False, "存取被拒"
    else:
        return False, output.split("\n")[0][:50]


def main():
    """主程式：列出模型並測試可用性"""
    claude_models = list_claude_models()

    # 定義要測試的 cross-region inference profiles
    test_profiles = [
        ("Claude Sonnet 4.6", "us.anthropic.claude-sonnet-4-6"),
        ("Claude Haiku 4.5", "us.anthropic.claude-haiku-4-5-20251001-v1:0"),
        ("Claude Opus 5", "us.anthropic.claude-opus-5"),
        ("Claude Opus 4.8", "us.anthropic.claude-opus-4-8"),
        ("Claude Opus 4.7", "us.anthropic.claude-opus-4-7"),
        ("Claude Sonnet 5", "us.anthropic.claude-sonnet-5"),
        ("Claude Fable 5", "us.anthropic.claude-fable-5"),
        ("Claude Sonnet 4", "us.anthropic.claude-sonnet-4-20250514-v1:0"),
    ]

    print("🧪 實測模型可用性（使用 cross-region inference profile）")
    print("=" * 60)
    print(f"\n{'模型名稱':<20} {'Profile ID':<45} {'狀態'}")
    print("-" * 85)

    available = []
    denied = []

    for name, profile_id in test_profiles:
        ok, msg = test_model_access(profile_id)
        status = f"✅ {msg}" if ok else f"❌ {msg}"
        print(f"{name:<20} {profile_id:<45} {status}")
        if ok:
            available.append((name, profile_id))
        else:
            denied.append((name, profile_id))

    # 摘要
    print("\n" + "=" * 60)
    print(f"\n📊 結果摘要:")
    print(f"   ✅ 可用: {len(available)} 個模型")
    print(f"   ❌ 無權限: {len(denied)} 個模型")

    if available:
        print(f"\n💡 推薦使用:")
        for name, pid in available:
            print(f"   claude --model {pid} -p \"你的問題\"")

    print(f"\n⚠️  Claude Code 會自動 fallback 到可用模型，")
    print(f"   所以直接用 'claude -p' 即可，不需手動指定 profile。")


if __name__ == "__main__":
    main()
    print("\n✅ Lab 3 完成！")
