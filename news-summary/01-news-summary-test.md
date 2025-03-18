---
author: 码码要洗手
date: 20250318
theme: ./CUSTOM_theme.json
---

# News-Summary 不在裸奔，支持单元测试了

🚀 **异步测试 + 真实数据库 = 更可靠的代码**

🔧 **Pytest fixture 轻松管理依赖**

🐍 **Pytest 异步并发测试 + asyncpg 避免坑点！**

---

## 🎬 **单元测试覆盖率可视化**

📌 **GitHub Codecov 集成**

📊 **本地 HTML 测试覆盖率展示**

---

## 🛠 Pytest + FastAPI + PostgreSQL 你可能踩过的坑

```
asyncpg.exceptions.InterfaceError: another operation is in progress

sqlalchemy.exc.PendingRollbackError: This Session's transaction has been rolled back

RuntimeError: Event loop is closed
```

---

## 🔍 排查过程

1️⃣ GPT 的建议（但不完全对 🧐）

2️⃣ 查官方文档（多读几遍，关键在细节 👀）

3️⃣ 最终解决方案

    ✅ poolclass=NullPool 让 pytest 独立管理连接池!
    ✅ scope = "session" or scope = "function"
    ✅ AnyIO vs pytest-asyncio 的正确使用方式

---

## 🛡 为什么要写单元测试？

💡增强信心

> 不怕代码改动后出现意外 Bug

> 开发效率提升，代码质量提高

🔄 避免回归问题

> 解决一个 Bug，可能带来另一个

> 单元测试让回归测试更简单

⚡ 提升协作

> 团队成员可以快速理解代码是否被破坏

> PR 之前跑测试，减少线上问题

---

## 🎉 关注+点赞+留言

🙏 感谢观看！

📌 别忘了 一键三连 + 关注支持！ 👍❤️🔄
