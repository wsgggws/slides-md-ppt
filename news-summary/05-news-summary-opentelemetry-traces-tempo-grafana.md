---
author: 码码要洗手
date: 20250414
theme: ./CUSTOM_theme.json
---

# 🧩 News-Summary OpenTelemetry Traces → Tempo → Grafana

## 🗺️ Trace 流程概览

```txt
FastAPI 应用 (OpenTelemetry SDK)
      │
      ├──(OTLP/gRPC Metrics)──▶ otel-collector ──▶ Prometheus ──▶ Grafana Metrics 图表
      │
      └──(OTLP/gRPC Traces)──▶ otel-collector ──▶ Tempo ───▶ Grafana Trace 可视化
```

---

## 🧭 目标

- 使用 OpenTelemetry 实现 FastAPI 的 Trace 采集
- 将 Trace 数据通过 OTLP gRPC 协议发送给 otel-collector
- otel-collector 转发给 Tempo
- Grafana 展示 trace 可视化

---

## ⚙️ 各组件职责

### FastAPI + OpenTelemetry SDK

- 自动采集 HTTP 请求、数据库、依赖调用等 Trace
- 使用 OTLP 协议（gRPC）将 Trace 数据发送至 otel-collector

### otel-collector

```yaml
exporters:
  otlp/tempo:
    endpoint: tempo:4317
    tls:
      insecure: true

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp/tempo]
```

---

## 🧊 Tempo 配置（tempo.yaml）

```yaml
server:
  http_listen_port: 3200

distributor:
  receivers:
    otlp:
      protocols:
        grpc:

storage:
  trace:
    backend: local
    local:
      path: /tmp/tempo
```

- Tempo 支持 OTLP/gRPC 协议接收 trace
- 存储使用本地 `/tmp/tempo`

---

## 📦 Docker Compose（tracing 部分）

确保 `otel-collector` 和 `tempo` 不冲突：

```yaml
services:
  tempo:
    image: grafana/tempo:latest
    ports:
      - "3200:3200"
    volumes:
      - ./config/tempo/tempo.yaml:/etc/tempo.yaml
      - tempo_data: /tmp/tempo
```

---

## 🧪 FastAPI 环境变量配置

`.otel.env`:

```dotenv
OTEL_SERVICE_NAME=news-summary
OTEL_METRICS_EXPORTER=otlp
OTEL_EXPORTER_OTLP_ENDPOINT=grpc://localhost:4317
OTEL_EXPORTER_OTLP_METRICS_PROTOCOL=grpc
OTEL_TRACES_EXPORTER=otlp
OTEL_EXPORTER_OTLP_TRACES_PROTOCOL=grpc
OTEL_LOGS_EXPORTER=none
```

---

## 🚀 FastAPI 启动方式对比及自动注入 Trace

### ✅ 推荐方式（适配无 export 的 .otel.env）

```bash
set -a
source .otel.env
set +a
opentelemetry-instrument uvicorn app.main:app
```

### ⚠ 不推荐（除非 .otel.env 每行都写了 export）

```bash
source .otel.env && opentelemetry-instrument uvicorn app.main:app
```

| 启动方式         | 是否能读取 `.otel.env` 中的变量 | 是否要求 `.otel.env` 写法带 export | 推荐    |
| ---------------- | ------------------------------- | ---------------------------------- | ------- |
| `set -a; source` | ✅ 是                           | ❌ 否                              | ✅ 推荐 |
| `source &&`      | ❌ 若无 export 无效             | ✅ 是                              | 🚫 小心 |

---

## 🧩 Middleware 注入 Trace ID 到 Header

```python
from starlette.middleware.base import BaseHTTPMiddleware
from opentelemetry import trace

class TraceIDHeaderMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response: Response = await call_next(request)

        span = trace.get_current_span(get_current())
        ctx = span.get_span_context()
        if ctx and ctx.trace_id != 0:
            trace_id = format_trace_id(ctx.trace_id)
            response.headers["x-trace-id"] = trace_id
        return response

```

> 中间件注册顺序必须：

```python
# 最后注册的中间件最先执行（在请求进入时）
# 最先注册的中间件最后执行（在响应返回时）
# 2 ➝ 1 ➝ 路由处理函数 ➝ 1 ➝ 2
app.add_middleware(TraceIDHeaderMiddleware)
app.add_middleware(OpenTelemetryMiddleware)
# 为每个请求创建一个 Root Span, 将 SpanContext 放入当前 Context 中
# 供后续代码（比如 FastAPIInstrumentor、自定义中间件）访问 trace.get_current_span() 获取当前 trace 上下文。
```

---

## ✅ 测试验证

1. `docker-compose up -d`
2. postman 发个请求
3. 查看返回 Header 是否包含 `x-trace-id`
4. 打开 Grafana 查看 Tempo 数据源
5. 根据 trace_id 查询链路

---

## 🎉 总结

- 正确配置各组件 trace 转发链路（FastAPI → OTEL → Tempo → Grafana）
- 使用 OTLP/gRPC 协议全链路传输
- 利用中间件将 trace_id 写入 Header，便于排查
- Grafana 可视化追踪链路

## TODO

- Logs 集成到 Grafana(可配合 Traces)
- Grafana 使用指南

---

## 🎉 感谢观看

🙏 感谢支持

📬 欢迎留言交流

👍 一键三连 + 关注支持！ ❤️ 🔁 💬
