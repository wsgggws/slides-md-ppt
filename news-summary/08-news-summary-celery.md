---
author: 码码要洗手
date: 20250506
theme: ./CUSTOM_theme.json
---

# 🛠 **News-Summary Celery定期爬取订阅**

## 🎯 **内容安排**

1. **功能演示** 🔧
2. **Feeds 更新流程与策略** 🔄
3. **Celery Beat & Worker** 🐎
4. **feedparser + parsel + html2text** 📄
5. **pytest-recording** 📝

---

## 🚀 **功能演示**

- 🕹 **Beat**：定时任务调度
- 👷 **Worker**：后台任务执行
- 🛠 **Redis**：任务队列 & 存储
- 📝 **Markdown**：文章内容格式化(将传给AI进行总结)
- 💾 **pg**：PostgreSQL 数据存储

---

## **🔄Feeds 更新流程**

1. **用户订阅 Feed URL** 🌐
2. **定期抓取 RSS Feed** (使用 `aiohttp` 🌐)
3. **解析 XML 并提取内容** (使用 `feedparser` & `parsel` 🔍)
4. **存储文章 & 更新记录** (使用 `html2text` 📝 & AI 🤖)
5. **通知或展示新内容** 🔔

---

## 🐎 **Celery Beat & Worker**

### **为什么选择 Celery**

| 场景                               | 推荐方式          |
| ---------------------------------- | ----------------- |
| 定时 / 周期性 / 可追踪             | ✅ Celery         |
| 简短 / 非阻塞 / 请求触发的异步任务 | ✅ BackgroundTask |

- **Celery Worker & Beat** 配合，支持定时任务和任务调度
- 使用 **Redis** 作为 **Broker 和 Backend**
- 每个任务对应独立的 worker，实现并发处理

### 🔧 Beat 启动命令

celery -A celery_app beat --loglevel=info

### 💻 Worker 启动命令

celery -A celery_app worker --loglevel=info --pool=threads --concurrency=1 --loglevel=info

---

## 📄feedparser + parsel + html2text

feedparser: 解析 feeds

parsel(XPath): 解析出 text

html2text: html -> makrdown

---

## 📝 4. pytest-recording

pytest-recording 记录网络请求，确保测试的准确性。

在测试时模拟网络请求并返回预定义响应，避免重复请求。

---

## 🎉 感谢观看

🙏 感谢支持

📬 欢迎留言交流

👍 一键三连 + 关注支持！ ❤️ 🔁 💬
