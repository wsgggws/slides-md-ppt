---
author: 码码要洗手
date: 20250419
theme: ./CUSTOM_theme.json
---

# 🛠 News‑Summary 工具链升级：pydantic‑settings · Makefile · Ruff

## 🎯 内容安排

1. ✨ 引入 `pydantic‑settings`
2. 🧪 tests 代码重构（由 pydantic‑settings 带来的思考）
3. 🐎 引入 `Makefile`（更简洁的 run/test/otel-run）
4. 🪄 pre‑commit 引入 `Ruff`（一键替代 black + isort）

---

## 🔧 1. pydantic‑settings

官方文档：
<https://docs.pydantic.dev/latest/concepts/pydantic_settings/>

### 🆚 与 Dynaconf 对比

| 特性                    | pydantic‑settings                   | Dynaconf                                       |
| ----------------------- | ----------------------------------- | ---------------------------------------------- |
| 类型验证                | ✅ Pydantic 强类型 & 自动校验       | ✅ 支持基本类型转换                            |
| 多环境配置              | ✅ `env_file` + `APP_ENV` 切换加载  | ✅ 原生支持 `.env` / `.toml` / 多环境切换      |
| 配置层级覆盖            | ✅ 支持多 `env_file` 列表优先级覆盖 | ✅ 支持 settings 文件、环境变量、Secret 等混合 |
| 与 FastAPI 集成         | ✅ 无缝集成，依赖注入自动工作       | ⚠️ 需额外封装和桥接                            |
| 嵌套 & 复杂结构         | ✅ 支持 Pydantic 嵌套模型           | ⚠️ 需自行管理子配置对象                        |
| CLI/Shell 变量加载      | ✅ 自动读取 `.env.*`                | ✅ 支持多种加载方式                            |
| IDE 类型提示 & 自动补全 | ✅ Pydantic 提供丰富的 IDE 支持     | ⚠️ 需阅读 Dynaconf API 文档                    |
| 学习成本                | ✅ 轻量，上手快                     | ⚠️ 功能更丰富，需要额外学习                    |

---

## 🧪 2. tests 代码变更

- 由 pydantic‑settings 引入，**无需** `TEST_DATABASE_URL`
- 测试配置只需 `.env.ci` 中的基本变量
- 📝 思考：让测试更轻量、更聚焦

---

## 🐎 3. Makefile

- **`make run`**  
  👉 本地开发：`db` 启动 + 加载 `.env.local` + `uvicorn`
- **`make otel-run`**  
  👉 带 OpenTelemetry：加载本地 env + `.otel.env` + `opentelemetry-instrument`
- **`make test`**
  - 无参：运行 `pytest`
  - 传参：`make test ARGS="-vv -s"` 或 `make test ARGS="tests/test_whoami.py -vv -s"`

---

## 🪄 4. pre‑commit 引入 Ruff

Ruff 已可完全替代 black + isort + flake8，且性能优异。

<https://github.com/astral-sh/ruff-pre-commit>

| 功能        | 传统工具组合                              | ✅ Ruff 全家桶           |
| ----------- | ----------------------------------------- | ------------------------ |
| 代码格式化  | black                                     | ✅ `ruff format`         |
| import 排序 | isort                                     | ✅ Ruff rule: I001       |
| 静态检查    | flake8, mccabe, pyflakes, pycodestyle     | ✅ 内建 lint             |
| 执行速度    | 多工具串行执行                            | 🚀 Rust 实现，极速       |
| 配置管理    | 多文件（`pyproject.toml` + `.isort.cfg`） | ✅ 单一 `pyproject.toml` |

见示例配置片段（`pyproject.toml` and `.pre-commit-config.yaml`）

---

## 🎉 感谢观看

🙏 感谢支持

📬 欢迎留言交流

👍 一键三连 + 关注支持！ ❤️ 🔁 💬
