---
author: 码码要洗手
date: 20250413
theme: ./CUSTOM_theme.json
---

# 📦 News-Summary 零代码集成 OpenTelemetry 初体验

## 🧭 Agent

- 使用 OpenTelemetry 的 `Console` 输出，快速体验其功能
- 安装与使用
- 探索 `--reload` 与 `OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED` 的行为差异

---

## 🔍 什么是 OpenTelemetry？

- 📊 统一可观测性标准：可运行、`可观测`、可维护
- 🎯 三大核心能力：Tracing / Metrics / Logs
- 🌐 多种导出方式：Console、Prometheus、Jaeger、Grafana Tempo 等

---

## 📦 安装依赖

```bash
# 包含 opentelemetry-sdk、opentelemetry-api 等
poetry add opentelemetry-distro

# 查看支持的 auto instrumentations
opentelemetry-bootstrap -a requirements

# 按需添加
poetry add opentelemetry-instrumentation-fastapi
```

---

## 🚀 启动方式示例

```bash
export OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true && \
opentelemetry-instrument \
--disabled_instrumentations starlette,tortoiseorm \
--traces_exporter console \
--metrics_exporter console \
--logs_exporter console \
--service_name news-summary \
uvicorn app.main:app
```

---

## 🌿 环境变量作用

```bash
export OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true
```

- ✅ 自动 Hook 标准库的 `logging`
- ✅ 自动添加 trace_id / span_id
- ✅ 自动附带资源标签（如 service.name、环境等）
- ✅ 日志自动关联当前 Trace 上下文

---

## 🔧 disabled_instrumentations

```bash
--disabled_instrumentations starlette,tortoiseorm
```

- ❗ Starlette 与 OpenTelemetry 版本冲突，禁用
- ✅ FastAPI 有专用 instrumentation 足够用
- 💤 TortoiseORM 当前未使用，禁用防止警告输出

---

## 🐛 常见坑：--reload 不生效？

- `--reload` 会启动：
  - 主进程：用于文件变动监控
  - 子进程：实际运行你的代码

### 导致的问题

1. 🌱 子进程可能无法继承主进程设置的环境变量
2. 🔧 OpenTelemetry 仅 patch 主进程，子进程无效

### ✅ 建议

- 开发阶段避免使用 `--reload` 测试 trace
- 或使用 `env $(cat .env)` 显式传递所有变量

---

## 🗂️ TODO

- ✅ 集成 Prometheus + Grafana
- 📰 集成 RSS 爬虫追踪任务链路
- 📤 导出至 OTLP + 可视化追踪

---

## 🎉 感谢观看

🙏 感谢支持

📬 欢迎留言交流

👍 一键三连 + 关注支持！ ❤️ 🔁 💬
