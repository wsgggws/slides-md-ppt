---
author: 码码要洗手
date: 20250414
theme: ./CUSTOM_theme.json
---

# 📦 News-Summary OpenTelemetry Metrics + Prometheus + Grafana

## 🔍 整体流程

```
FastAPI 应用 (OpenTelemetry SDK)
      │
      └──(OTLP/gRPC)──▶ otel-collector (监听 4317)
                                │
                                └──▶ 暴露 Prometheus 接口 (9464)
                                                │
                                                └──▶ Prometheus scrape 指标
                                                                  │
                                                                  └──▶ Grafana 展示指标图表
```

---

## 🧭 项目概览

- 使用 OpenTelemetry SDK 采集 FastAPI 应用的 Metrics
- 通过 OTLP gRPC 协议发送给 OpenTelemetry Collector
- Collector 暴露 Prometheus 接口供 Prometheus 拉取数据
- 最终在 Grafana 中可视化指标数据

---

## 🛠️ OpenTelemetry SDK

应用内集成 SDK：

- 自动采集 HTTP 请求响应、路由信息等 Metrics
- **通过**环境变量或代码配置选择导出方式（OTLP）
- 示例环境变量（存入 `.otel.env`）：

```env
OTEL_SERVICE_NAME=news-summary
OTEL_METRICS_EXPORTER=otlp
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_EXPORTER_OTLP_METRICS_PROTOCOL=grpc
OTEL_TRACES_EXPORTER=none
OTEL_LOGS_EXPORTER=none
```

---

## 🧩 otel-collector 配置详解

### Receivers

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
```

监听 4317 端口，接收 gRPC 形式的 OTLP 数据

---

### Processors

```yaml
processors:
  batch:
    timeout: 500ms
    send_batch_size: 20
```

缓冲 + 批量发送，提升性能，减少网络请求数

---

### Exporters

```yaml
exporters:
  prometheus:
    endpoint: "0.0.0.0:9464"
```

将采集到的指标转换为 Prometheus 可识别格式，并暴露 HTTP 接口

---

### Service Pipeline

```yaml
service:
  pipelines:
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
```

构建完整处理链：接收 ▶️ 处理 ▶️ 导出

---

## 🔎 Prometheus 配置

```yaml
global:
  scrape_interval: 2s

scrape_configs:
  - job_name: "otel-collector"
    static_configs:
      - targets: ["otel-collector:9464"]
```

每 2 秒抓取一次 otel-collector 暴露的指标数据

---

## 📊 Grafana 展示

Grafana 数据源配置:

- 类型：Prometheus
- URL：`http://prometheus:9090`

推荐 Dashboard：

- 数据库监控（`db_client_connections_usage`）
- 各状态码分布（`http_server_response_size_bytes_sum`）
- 响应时间分布（`http_server_duration_seconds_bucket`）
  ...

---

## 🧪 如何验证流程

1. 启动服务：`docker-compose up -d`
2. FastAPI 应用使用 `.otel.env` 环境变量启动
3. 打开 [http://localhost:9464/metrics](http://localhost:9464/metrics) 验证 Collector 接口
4. [http://localhost:9090/graph](http://localhost:9090/graph) 查看 Prometheus 抓取情况
5. [http://localhost:3000](http://localhost:3000) 打开 Grafana 看指标图
6. 模拟负载请求：

```bash
wrk -t4 -c20 -d60s http://127.0.0.1:8000/api/v1/user/register
```

---

## ⚠️ 注意事项

- 保证网络连通性：FastAPI 应用能连接 otel-collector:4317
- `.otel.env` 启动时要加载到应用环境中
- metrics 相关 instrumentations 要正确启用（如 `opentelemetry-instrument`）
- 配置变更后需重启 docker-compose 服务

---

## ✅ 总结

- OpenTelemetry 提供了零侵入采集方式
- Prometheus + Grafana 是当前主流指标可视化方案
- Collector 配置灵活，既能导出 Prometheus，也支持其它平台

---

## 🎉 感谢观看

🙏 感谢支持

📬 欢迎留言交流

👍 一键三连 + 关注支持！ ❤️ 🔁 💬
