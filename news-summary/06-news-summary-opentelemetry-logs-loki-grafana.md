---
author: 码码要洗手
date: 20250417
theme: ./CUSTOM_theme.json
---

# 🪵 News-Summary OpenTelemetry Logs → Loki → Grafana

## 🗺️ Logs 流程概览

```txt
FastAPI 应用 (OpenTelemetry SDK)
      │
      └──(OTLP/gRPC Logs)──▶ otel-collector ──▶ Loki ──▶ Grafana 日志展示(与 Traces 联动)

```

---

## 🎯 项目关键配置

- 🛠️config otel exporters

```yaml
exporters:
  loki:
    endpoint: http://loki:3100/loki/api/v1/push
```

- 🐳docker-compose add Loki service

```yaml
services:
  loki:
    image: grafana/loki:2.9.1
    ports:
      - "3100:3100"
    command: -config.file=/config/loki/loki.yaml
```

- ⚙️FastAPI .otel.env 配置

```dotenv
OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true
OTEL_LOGS_EXPORTER=otlp
OTEL_EXPORTER_OTLP_LOGS_PROTOCOL=grpc
```

---

## 📊 Grafana Data Sources 关键配置，联动 Loki and Tempo

### 🔧 Config Grafana `Loki` Data Sources

### 🔧 Config Grafana `Tempo` Data Sources

---

## ✅ 验证步骤

1. 请求接口触发日志

2. Grafana → Explore → Loki → 查看日志

3. 可与 Tempo trace 联动跳转（点击 trace_id）

---

## 🎉 感谢观看

🙏 感谢支持

📬 欢迎留言交流

👍 一键三连 + 关注支持！ ❤️ 🔁 💬
