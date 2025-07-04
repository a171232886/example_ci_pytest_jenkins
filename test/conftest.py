import os
import pytest
from datetime import datetime


def pytest_configure(config):
    """
    在 Pytest 启动后、收集测试用例之前执行。
    只会运行一次（整个测试会话开始时）。

    测试运行前执行自定义逻辑（如环境检查、目录创建、插件初始化等）
    """

    if not os.path.exists("cache"):
        os.makedirs("cache")

    if not os.path.exists("logs"):
        os.makedirs("logs")

@pytest.fixture(autouse=True, scope="session")
def f():
    # 前置操作
    print(datetime.now(), "开始执行")
    
    yield "fixture_result"  # 执行用例
    
    # 后置操作
    print("\n", datetime.now(), "执行结束")