# Elastic Stack 配置

## 设置用户密码
```bash
# 交互式设置以下账号的密码：
# elastic, apm_system, kibana, logstash_system, beats_system, remote_monitoring_user
elasticsearch-setup-passwords interactive
```

## 配置 TLS 证书
```bash
# 生成证书
elasticsearch-certutil cert -out elastic-stack-ca.p12

# 生成 CSR
elasticsearch-certutil csr -out elastic-stack.csr

# 生成 HTTP 证书
elasticsearch-certutil http
```

## 参考文档
- Elasticsearch 证书工具：<https://www.elastic.co/guide/en/elasticsearch/reference/current/certutil.html>
