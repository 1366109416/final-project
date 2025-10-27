#!/usr/bin/env python3
"""调试脚本来查看实际输出"""

from app.new_feature import ConfigManager, display_configuration
from app.main import greet, show_config
import os
import sys

# 添加项目根目录到 Python 路径
sys.path.insert(0, os.path.dirname(__file__))

# 现在导入模块

# 设置测试环境变量
os.environ["USER_NAME"] = "TestUser"
os.environ["API_TOKEN"] = "1234567890abcdef"

print("=== 调试输出 ===")
print()

print("1. greet() 输出:")
result1 = greet()
print(f"   '{result1}'")
print()

print("2. show_config() 输出:")
result2 = show_config()
print(f"   '{result2}'")
print()

print("3. display_configuration() 输出:")
result3 = display_configuration()
print(f"   '{result3}'")
print()

print("4. ConfigManager 配置摘要:")
config = ConfigManager()
summary = config.get_config_summary()
print(f"   用户名称: {summary['user_name']}")
print(f"   API Token: {summary['api_token']}")
print(f"   调试模式: {summary['debug_mode']}")
