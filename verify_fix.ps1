#!/bin/bash
# verify_fix.sh - 验证所有修复

echo "🔍 验证修复结果..."

# 1. 检查Black格式
echo "✅ 检查Black格式..."
if black --check .; then
    echo "🎉 Black检查通过！"
else
    echo "❌ Black检查失败，请运行: black ."
    exit 1
fi

# 2. 检查Python语法
echo "✅ 检查Python语法..."
for file in $(find . -name "*.py"); do
    if python -m py_compile "$file"; then
        echo "✓ $file 语法正确"
    else
        echo "✗ $file 语法错误"
        exit 1
    fi
done

# 3. 运行测试
echo "✅ 运行测试..."
if pytest -v; then
    echo "🎉 所有测试通过！"
else
    echo "❌ 测试失败"
    exit 1
fi

echo ""
echo "🎊 所有检查通过！代码现在符合Black格式要求。"
echo "🚀 可以安全地推送到GitHub了。"