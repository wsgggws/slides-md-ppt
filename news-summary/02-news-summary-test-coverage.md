---
author: 码码要洗手
date: 20250325
theme: ./CUSTOM_theme.json
---

# News-Summary 准确的单元测试覆盖率

- `concurrency=["gevent"]` 对测试覆盖率的影响
-
- 引入 `pytest-async-sqlalchemy`，取消 NullPool
-
- 调整测试目录结构，针对不同模块提供不同 `fixture`
-
- 优化 `UserResponse` 响应格式
-
- 统一错误处理及自定义错误

---

## 🎬 **更准确的单元测试覆盖率**

- 为什么 `concurrency = ["gevent"]` 对测试覆盖率很重要？
- 如何检查 `pytest` 是否真的在使用 `gevent`？
- 如果 `FastAPI + SQLAlchemy + asyncpg` 默认基于 `asyncio`，为何 `gevent` 仍然影响覆盖率？

📌 **排查方式**

```sh
pip freeze | grep gevent  # 检查 gevent 是否安装
pytest --trace-config | grep gevent  # 检查 pytest 插件是否使用 gevent
...追问了GPT
```

> 结论: 目前还不知道！先标记使用 gevent

---

## 🤔 **pytest-async-sqlalchemy 为什么要创建 event_loop 的 fixture**

`pytest-asyncio` 定义的 `event_loop` fixture 是 `function` 作用域的，需要把它改成 `session` 作用域

```python
import pytest
import asyncio

@pytest.fixture(scope="session")
def event_loop():
    loop = asyncio.get_event_loop()
    yield loop
    loop.close()
```

---

## 🛠 **调整测试目录**

```python
tests/
  conftest.py
  user/
    conftest.py
    test_users.py
```

- `conftest.py` 负责提供全局 `fixture` 如 `event_loop`, `setup_database`, `client`。
-
- 模块 `user/conftest.py` 提供独立的 `fixture`，避免耦合
  - 如 `setup_user_in_database` 执行该模块前自动添加两个用户。

---

## 🛡 **注意检查 `pyproject.toml` 的内容**

```sh
[tool.pytest.ini_options]
asyncio_mode = "auto"
asyncio_default_fixture_loop_scope = "function"
filterwarnings = "ignore::DeprecationWarning"
addopts = "--cov=app --cov-report=html --cov-report=xml"

[tool.coverage.run]
concurrency = ["gevent"]
```

---

## 🛡 **下一步**

- 💡 **订阅功能**
- 🔍 **新闻爬取**
- 📊 **优化日志 & 监控**

---

## 🎉 **关注+点赞+留言**

🙏 感谢观看！

💬 欢迎留言与讨论

📌 别忘了 **一键三连 + 关注支持！** 👍 ❤️ 🔄
