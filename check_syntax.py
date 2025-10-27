#!/usr/bin/env python3
"""检查所有Python文件的语法"""

import ast
import os
import sys


def check_file_syntax(filepath):
    """检查单个文件的语法"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        ast.parse(content)
        print(f"✓ {filepath}: 语法正确")
        return True
    except SyntaxError as e:
        print(f"✗ {filepath}: 语法错误 - {e}")
        return False
    except UnicodeDecodeError:
        print(f"✗ {filepath}: 编码错误")
        return False


def main():
    """主函数"""
    python_files = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.py'):
                python_files.append(os.path.join(root, file))

    print(f"找到 {len(python_files)} 个Python文件")

    all_valid = True
    for filepath in python_files:
        if not check_file_syntax(filepath):
            all_valid = False

    if all_valid:
        print("🎉 所有文件语法正确！")
        return 0
    else:
        print("❌ 发现语法错误，请修复上述文件")
        return 1


if __name__ == '__main__':
    sys.exit(main())
