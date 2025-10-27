#!/usr/bin/env python3
"""最小测试用例，验证Black是否能正常工作"""


def simple_function():
    """一个简单的测试函数"""
    x = 1
    y = 2
    result = x + y
    return result


class SimpleClass:
    """一个简单的测试类"""

    def __init__(self):
        self.value = "test"

    def get_value(self):
        return self.value


if __name__ == "__main__":
    obj = SimpleClass()
    print(obj.get_value())
