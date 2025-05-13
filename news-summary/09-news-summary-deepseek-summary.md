---
author: 码码要洗手
date: 2025-05-13
theme: ./CUSTOM_theme.json
---

# 📰 News-Summary · DeepSeek 总结你的订阅

## 📌 内容安排

🎬 功能演示

📝 `pytest-recording` 重新生成

🧪 Ollama 本地模型尝试（机器配置不行，超时）

---

## 🎬 功能演示：AI 驱动的 RSS 总结

- 💡 **模型**：`deepseek-chat`
- 🛠 **Prompt**：见 SYSTEM
- 📦 **数据库**：使用 `pg` 是否有 summary_md 数据生成
- 🪄 **总结输出**：看看 Markdown 效果

---

## 📝 单元测试重录：pytest-recording

```bash
make test ARGS='--record-mode=rewrite -s'

# 之后再次运行测试
make test ARGS='-s'
```

📌 说明：

--record-mode=rewrite 将生成 .yaml 录制数据

数据安全, 避免密钥等数据上传到 GitHub 👇

```Python
@pytest.fixture(scope="module")
def vcr_config():
    return {
        # Replace the Authorization request header with "DUMMY" in cassettes
        "filter_headers": [("authorization", "DUMMY")],
    }
```

---

## 🧪 Ollama 模型尝试（本地能运行，API调用超时）

### ⚙️ 尝试步骤

1. 使用 `docker-compose` 启动 Ollama
2. 模型选择：`qwen:1.8b`（中文支持较好）
3. 使用 `curl` 测试 API 效果 👇

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "qwen:1.8b",
  "prompt": "给我讲解下 TCP 协议为什么需要四次挥手？"
}' -H "Content-Type: application/json"
```

但输入 prompt 时调用本地 Ollama API 超时, 硬件配置不行，硬伤 = ]

---

## ✅ TODO

🧑‍🎨 UI 界面设计与开发

---

## 🎉 感谢观看

🙏 感谢支持

📬 欢迎留言交流

👍 一键三连 + 关注支持！ ❤️ 🔁 💬
