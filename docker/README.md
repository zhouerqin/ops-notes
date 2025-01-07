# Docker 日志配置

## 使用 Elastic 日志插件

```json
{
  "log-driver": "elastic",
  "log-opts": {
    "elastic-url": "http://localhost:9200",
    "elastic-index": "docker-%Y.%m.%d",
    "elastic-type": "_doc",
    "elastic-timeout": "10s"
  }
}
```

## 配置默认日志驱动

在 /etc/docker/daemon.json 中：
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

## 参考文档
- Docker 日志配置：<https://docs.docker.com/config/containers/logging/>
- Elastic 日志插件：<https://www.elastic.co/guide/en/beats/loggingplugin/8.11/log-driver-usage-examples.html>
- Nginx 官方镜像示例：<https://github.com/nginxinc/docker-nginx/blob/8921999083def7ba43a06fabd5f80e4406651353/mainline/jessie/Dockerfile#L21-L23>
