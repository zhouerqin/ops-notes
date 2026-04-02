# Nginx 反向代理 Tomcat 常见坑与解决方案

## 1. 客户端真实 IP 丢失

### 现象
Tomcat 日志中所有请求 IP 都是 `127.0.0.1`，无法获取真实客户端 IP。

### 原因
Nginx 反向代理后，Tomcat 看到的连接来源是 Nginx 本机，而非原始客户端。

### 解决

**Nginx 侧配置**：

```nginx
location / {
    proxy_pass http://tomcat_backend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;           # 传递真实 IP
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  # 传递代理链 IP
    proxy_set_header X-Forwarded-Proto $scheme;        # 传递原始协议 (http/https)
}
```

**Tomcat 侧配置**（`conf/server.xml`）：

```xml
<!-- 在 <Host> 内添加 RemoteIpValve，解析 Nginx 传递的 X-Forwarded-* 头 -->
<Valve className="org.apache.catalina.valves.RemoteIpValve"
       remoteIpHeader="X-Forwarded-For"
       proxiesHeader="X-Forwarded-By"
       protocolHeader="X-Forwarded-Proto"
       protocolHeaderHttpsValue="https"
       hostHeader="X-Forwarded-Host"      <!-- 解析上游传递的主机名+端口 -->
       portHeader="X-Forwarded-Port" />   <!-- 解析上游传递的端口号 -->
```

> **`RemoteIpValve` 完整参数说明**：
>
> | 参数 | 默认值 | 说明 |
> |------|--------|------|
> | `remoteIpHeader` | `x-forwarded-for` | 客户端真实 IP 来源头 |
> | `protocolHeader` | `x-forwarded-proto`（6.x 为 `null`） | 客户端原始协议 |
> | `protocolHeaderHttpsValue` | `https` | 表示 HTTPS 的协议头值 |
> | `hostHeader` | `null`（不启用，6.x 不支持） | 客户端原始主机名（含端口），对应 Nginx 的 `X-Forwarded-Host` |
> | `portHeader` | `null`（不启用，6.x 不支持） | 客户端原始端口号，对应 Nginx 的 `X-Forwarded-Port` |
> | `httpServerPort` | `80` | HTTP 协议下无 portHeader 时的默认端口 |
> | `httpsServerPort` | `443` | HTTPS 协议下无 portHeader 时的默认端口 |
> | `internalProxies` | 见下方版本差异表 | 内部代理 IP 正则，匹配到的代理才会被信任并解析 X-Forwarded-* 头 |
> | `trustedProxies` | `null`（不启用，6/7.x 不支持） | 额外信任的代理 IP 正则，与 internalProxies 区别见下方说明 |
>
> **⚠️ `internalProxies` 版本差异（重点）**：
>
> 只有 Nginx 的 IP 匹配 `internalProxies` 或 `trustedProxies` 正则，Tomcat 才会信任并解析 `X-Forwarded-For` 等头。如果 Nginx IP 不在信任列表中，这些头会被忽略，导致 IP 获取失败。
>
> | Tomcat 版本 | `internalProxies` 默认值（正则） | 覆盖的 IP 段 | 语法格式 |
> |-------------|--------------------------------|-------------|----------|
> | 6.x | `10\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?, 192\.168\.\d\d?\d?\.\d\d?\d?, 169\.254\.\d\d?\d?\.\d\d?\d?, 127\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?` | 10/8, 192.168/16, 169.254/16, 127/8 | **逗号分隔**，不含 172.16/12，不含 IPv6 |
> | 7.x | `10\.\d{1,3}\.\d{1,3}\.\d{1,3}\|192\.168\.\d{1,3}\.\d{1,3}\|169\.254\.\d{1,3}\.\d{1,3}\|127\.\d{1,3}\.\d{1,3}\.\d{1,3}\|172\.1[6-9]\.\d{1,3}\.\d{1,3}\|172\.2[0-9]\.\d{1,3}\.\d{1,3}\|172\.3[01]\.\d{1,3}\.\d{1,3}` | 10/8, 172.16/12, 192.168/16, 169.254/16, 127/8 | **管道符分隔**，新增 172.16/12 |
> | 8.5.x | 同 7.x | 同 7.x | 管道符分隔 |
> | 9.0.x+ | 同 8.5.x + `\|0:0:0:0:0:0:0:1\|::1` | 额外包含 IPv6 回环地址 | 管道符分隔 |
> | 10.1.x+ | 同 9.0.x + `\|100\.6[4-9]\.\d{1,3}\.\d{1,3}\|100\.[7-9]\d\.\d{1,3}\.\d{1,3}\|100\.1[01]\d\.\d{1,3}\.\d{1,3}\|100\.12[0-7]\.\d{1,3}\.\d{1,3}` | 额外包含 CGNAT 段 100.64/10 | 管道符分隔 |
>
> **⚠️ Tomcat 6 特殊注意事项**：
>
> 1. **`internalProxies` 语法不同**：使用**逗号分隔**正则，正则内部**不能包含逗号**，否则会被错误拆分
> 2. **`protocolHeader` 默认为 `null`**：6.x 默认不解析协议头，必须显式设置 `protocolHeader="X-Forwarded-Proto"`
> 3. **不支持 `hostHeader` / `portHeader`**：6.x 的 `RemoteIpValve` 没有这两个参数，无法自动解析主机名和端口，需通过 Connector 的 `proxyName` / `proxyPort` 静态配置
> 4. **不支持 `trustedProxies`**：只有 `internalProxies` 一个信任列表
>
> ```xml
> <!-- Tomcat 6 完整配置示例 -->
> <Valve className="org.apache.catalina.valves.RemoteIpValve"
>        remoteIpHeader="X-Forwarded-For"
>        protocolHeader="X-Forwarded-Proto"
>        protocolHeaderHttpsValue="https"
>        internalProxies="127\.0\.0\.1, 192\.168\.1\.\d+" />
>
> <!-- Tomcat 6 需在 Connector 上静态配置主机名和端口 -->
> <Connector port="8080" protocol="HTTP/1.1"
>            proxyName="your-domain.com"
>            proxyPort="443"
>            scheme="https"
>            secure="true" />
> ```
>
> **生产环境建议**：不要依赖默认值，显式配置 Nginx 的 IP 地址：
>
> ```xml
> <!-- Tomcat 7+ 推荐配置 -->
> <Valve className="org.apache.catalina.valves.RemoteIpValve"
>        remoteIpHeader="X-Forwarded-For"
>        protocolHeader="X-Forwarded-Proto"
>        hostHeader="X-Forwarded-Host"
>        portHeader="X-Forwarded-Port"
>        internalProxies="127\.0\.0\.1|::1|10\.0\.0\.\d+" />  <!-- 显式指定 Nginx IP -->
> ```
>
> **`internalProxies` vs `trustedProxies` 区别**：
> - `internalProxies`：匹配到的代理 IP 会被信任，且**不会**出现在 `proxiesHeader` 中（视为内部链路）
> - `trustedProxies`：匹配到的代理 IP 会被信任，但**会**出现在 `proxiesHeader` 中（记录代理链路）
> - 实际生产中两者选其一即可，多数场景用 `internalProxies`
> - `trustedProxies` 仅 Tomcat 7+ 支持

**验证**：

```bash
# 查看 Tomcat 访问日志，确认 IP 不再是 127.0.0.1
tail -f logs/localhost_access_log.*.txt

# 在 JSP 中打印 request 信息验证
# request.getRemoteAddr()  → 应为客户端真实 IP
# request.getScheme()      → 应为 https（如果前端是 HTTPS）
# request.getServerName()  → 应为前端域名
# request.getServerPort()  → 应为前端端口（443/80/自定义）
```

---

## 2. 静态资源性能差

### 现象
CSS、JS、图片等静态文件由 Tomcat 处理，响应慢、CPU 占用高。

### 原因
Tomcat 是应用服务器，处理静态资源效率远低于 Nginx。

### 解决

**Nginx 侧分离动静**：

```nginx
# 静态资源由 Nginx 直接处理
location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2|ttf|eot)$ {
    root /opt/app/static;          # 静态文件存放路径
    expires 30d;                   # 浏览器缓存 30 天
    access_log off;                # 关闭静态资源访问日志
    add_header Cache-Control "public, immutable";
}

# 动态请求代理到 Tomcat
location / {
    proxy_pass http://tomcat_backend;
    # ... 其他 proxy 配置
}
```

> **注意**：如果静态资源打包在 WAR 包内，可通过 `alias` 指向 Tomcat 的 `webapps/APP_NAME/` 目录，或让 Nginx 代理静态资源但开启缓存。

---

## 3. 大文件上传失败（413 / 请求体过大）

### 现象
上传大文件时 Nginx 返回 `413 Request Entity Too Large`，或 Tomcat 侧报请求体超限。

### 原因
Nginx 默认 `client_max_body_size` 为 1m，Tomcat 的 `maxPostSize` 也有默认限制。

### 解决

**Nginx 侧**：

```nginx
http {
    # 全局设置，或在 server/location 块中单独设置
    client_max_body_size 100m;     # 根据业务需求调整
    client_body_buffer_size 128k;  # 缓冲区大小
}
```

**Tomcat 侧**（`conf/server.xml` Connector 配置）：

```xml
<Connector port="8080" protocol="HTTP/1.1"
           maxPostSize="104857600"    <!-- 100MB，单位字节，-1 表示不限制 -->
           maxSwallowSize="104857600" <!-- 同样需要调整 -->
           connectionTimeout="60000"  <!-- 上传耗时操作，适当延长超时 -->
           />
```

---

## 4. WebSocket 连接失败

### 现象
前端 WebSocket 连接报 `400 Bad Request` 或连接后立即断开。

### 原因
WebSocket 需要特殊的 Upgrade 头，Nginx 默认不传递这些头信息。

### 解决

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    location /ws {
        proxy_pass http://tomcat_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_read_timeout 86400s;   # WebSocket 长连接，延长超时
        proxy_send_timeout 86400s;
    }
}
```

---

## 5. HTTPS 终止后应用重定向回 HTTP

### 现象
Nginx 配置了 HTTPS，但 Tomcat 应用生成的重定向链接（如登录跳转）变成了 `http://`。

### 原因
Tomcat 不知道前端使用了 HTTPS，默认按自身接收到的协议生成 URL。

### 解决

确保 Nginx 传递了 `X-Forwarded-Proto` 头，且 Tomcat 配置了 `RemoteIpValve`（见第 1 节）。

额外检查 Tomcat 的 `conf/server.xml` Connector 是否设置了：

```xml
<Connector port="8080" protocol="HTTP/1.1"
           scheme="https"
           secure="true"
           proxyName="your-domain.com"
           proxyPort="443" />
```

---

## 6. 超时导致 502/504 错误

### 现象
某些耗时操作（报表导出、批量导入）返回 `502 Bad Gateway` 或 `504 Gateway Timeout`。

### 原因
Nginx 和 Tomcat 的超时时间不匹配，Nginx 默认超时较短。

### 解决

```nginx
location / {
    proxy_pass http://tomcat_backend;
    proxy_connect_timeout 60s;     # 与 Tomcat 建立连接的超时
    proxy_send_timeout 120s;       # 向 Tomcat 发送请求的超时
    proxy_read_timeout 300s;       # 等待 Tomcat 响应的超时（按需调大）
    
    # 对于特定耗时接口可单独设置
    location /api/export {
        proxy_read_timeout 600s;
    }
}
```

同时确保 Tomcat 侧 `connectionTimeout` 不小于 Nginx 的 `proxy_read_timeout`。

---

## 7. URI 编码/特殊字符问题

### 现象
URL 中包含中文或特殊字符时，Tomcat 报 `400 Invalid character` 或参数解析错误。

### 原因
Nginx 和 Tomcat 对 URI 编码的处理方式不一致，Tomcat 8+ 对 URL 中非法字符校验更严格。

### 解决

**方案一：Nginx 侧不对 URI 做额外编码**

```nginx
location / {
    proxy_pass http://tomcat_backend;
    # 不要使用 proxy_pass 末尾带 / 的形式，避免 URI 重写
    # 错误: proxy_pass http://backend/;
    # 正确: proxy_pass http://backend;
}
```

**方案二：Tomcat 侧放宽 URI 校验**（`conf/server.xml` Connector）：

```xml
<Connector port="8080" protocol="HTTP/1.1"
           relaxedPathChars="|{}[],"
           relaxedQueryChars="|{}[]," />
```

---

## 8. Session/Cookie 路径异常

### 现象
登录后跳转其他页面又提示未登录，Session 丢失。

### 原因
Tomcat 设置的 Cookie Path 与实际访问路径不一致（如应用部署在 `/app` 但通过 `/` 访问）。

### 解决

确保 Nginx 的 `location` 路径与 Tomcat 应用上下文一致，或在 Tomcat 中配置 Cookie 路径：

```xml
<!-- 应用的 META-INF/context.xml 或 conf/context.xml -->
<Context path="/" sessionCookiePath="/" />
```

---

## 9. 健康检查配置不当

### 现象
Nginx 将请求转发到已挂掉的 Tomcat 实例，或频繁剔除正常节点。

### 解决

```nginx
upstream tomcat_backend {
    server 10.0.0.1:8080 max_fails=3 fail_timeout=30s;
    server 10.0.0.2:8080 max_fails=3 fail_timeout=30s;
    
    # 备用节点（所有主节点挂掉时才启用）
    # server 10.0.0.3:8080 backup;
}
```

**注意**：Nginx 开源版不支持主动健康检查（active health check），仅支持被动检测。如需主动探测，可使用 `nginx_upstream_check_module` 第三方模块或升级到 Nginx Plus。

---

## 10. AJP 协议 vs HTTP 协议选型

### 对比

| 维度 | HTTP 代理 | AJP 代理 |
|------|-----------|----------|
| 协议 | `proxy_pass http://` | `proxy_pass ajp://` |
| 性能 | 稍低（文本协议） | 稍高（二进制协议） |
| 调试 | 方便（可直接 curl） | 不方便 |
| 安全性 | 成熟稳定 | CVE-2020-1938（Ghostcat）需注意 |
| 推荐场景 | 大多数场景 | 内网高吞吐场景 |

### AJP 代理配置示例

```nginx
upstream tomcat_ajp {
    server 127.0.0.1:8009;
}

location / {
    proxy_pass ajp://tomcat_ajp;
    include proxy_params;
}
```

> ⚠️ **[安全警告]**：如使用 AJP，务必确保 AJP 端口（默认 8009）仅监听 `127.0.0.1` 或内网 IP，切勿暴露到公网。Tomcat 8.5.51+ / 9.0.31+ 已修复 Ghostcat 漏洞，请确保版本达标。

---

## 11. Host 头丢失端口号

### 现象
Tomcat 应用生成重定向 URL 时端口丢失或错误，例如用户访问 `http://example.com:8080/app`，重定向后变成了 `http://example.com/app`（端口消失），导致请求失败。

### 原因
Nginx 中 `proxy_set_header Host $host;` 的 `$host` 变量**不包含端口号**。Nginx 变量区别：

| 变量 | 值示例 | 是否含端口 |
|------|--------|------------|
| `$host` | `example.com` | 否（始终小写，无端口） |
| `$http_host` | `example.com:8080` | 是（原始 Host 头完整值） |
| `$server_name:$server_port` | `example.com:8080` | 是（手动拼接） |

### 解决

**推荐：使用 `$http_host` 保留原始 Host 头（含端口）**

```nginx
location / {
    proxy_pass http://tomcat_backend;
    proxy_set_header Host $http_host;    # 保留原始 Host，包含端口
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $http_host;  # 额外传递原始主机+端口
    proxy_set_header X-Forwarded-Port $server_port; # 额外传递原始端口
}
```

**场景对比**：

| 场景 | 推荐写法 |
|------|----------|
| Nginx 监听标准端口（80/443），后端不需要感知端口 | `Host $host` |
| Nginx 监听非标准端口（如 8080），后端需要感知 | `Host $http_host` |
| 域名与 IP 混合访问，需精确保留原始请求 | `Host $http_host` |

> **注意**：如果 Nginx 监听 80/443 标准端口，使用 `$http_host` 也不会带端口号（浏览器默认不发送标准端口的 Host 头），此时 Tomcat 侧可通过 `X-Forwarded-Port` 获取原始端口。

---

## 完整配置模板

```nginx
upstream tomcat_backend {
    server 10.0.0.1:8080 max_fails=3 fail_timeout=30s;
    server 10.0.0.2:8080 max_fails=3 fail_timeout=30s;
    keepalive 32;
}

server {
    listen 80;
    server_name your-domain.com;

    # 日志格式（包含真实 IP）
    log_format main '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    '"$http_x_forwarded_for"';
    access_log /var/log/nginx/app-access.log main;

    # 上传大小限制
    client_max_body_size 100m;

    # 静态资源
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2)$ {
        root /opt/app/static;
        expires 30d;
        access_log off;
    }

    # 动态请求
    location / {
        proxy_pass http://tomcat_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header Connection "";

        proxy_connect_timeout 60s;
        proxy_send_timeout 120s;
        proxy_read_timeout 300s;
    }
}
```
