# Tomcat 隐藏版本号和报错信息

## 背景

Tomcat 默认会在 HTTP 响应头和错误页面中暴露服务器版本信息，攻击者可利用这些精准版本信息查找对应 CVE 漏洞进行攻击。隐藏版本号和详细报错信息是安全基线的基本要求。

## 操作步骤

### 1. 编辑 server.xml

打开 Tomcat 配置文件 `conf/server.xml`，在 `<Host>` 标签内添加 `ErrorReportValve`：

```xml
<Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
    <!-- 隐藏详细报错信息和服务器版本号 -->
    <Valve className="org.apache.catalina.valves.ErrorReportValve"
           showReport="false"
           showServerInfo="false" />
    <!-- 其他配置... -->
</Host>
```

### 2. 参数说明

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `showReport` | `true` | 是否显示详细错误堆栈信息，设为 `false` 隐藏 |
| `showServerInfo` | `true` | 是否在错误页面和响应头中显示服务器版本，设为 `false` 隐藏 |

### 3. 自定义错误页面（可选）

隐藏默认报错后，建议配置友好的自定义错误页面：

```xml
<Valve className="org.apache.catalina.valves.ErrorReportValve"
       showReport="false"
       showServerInfo="false"
       errorCode.404="404.html"
       errorCode.500="500.html" />
```

将 `404.html`、`500.html` 放在 Tomcat 的 `webapps/ROOT/` 目录下。

### 4. 重启 Tomcat

> ⚠️ **[风险警告]**：重启将导致服务短暂中断，请在业务低峰期操作。

```bash
# 使用 catalina.sh 重启
./bin/shutdown.sh && sleep 3 && ./bin/startup.sh

# 或使用 systemctl（如已配置为系统服务）
systemctl restart tomcat
```

## 验证方法

### 验证响应头

```bash
# 查看 Server 响应头是否已隐藏版本号
curl -I http://localhost:8080/nonexistent-page

# 期望结果：Server 头仅显示 "Apache" 或完全不显示，不再包含 Tomcat/x.x.x
```

### 验证错误页面

访问一个不存在的页面，确认不再显示详细的 Tomcat 错误堆栈和版本信息。

## 补充安全加固

| 措施 | 操作 |
|------|------|
| 移除默认应用 | 删除 `webapps/docs`、`webapps/examples`、`webapps/host-manager`、`webapps/manager` |
| 禁用 AJP 端口 | 在 `server.xml` 中注释掉 `<Connector port="8009" protocol="AJP/1.3" />` |
| 修改默认端口 | 将 8080 改为非标准端口，减少自动化扫描命中 |
| 关闭目录遍历 | 在 `conf/web.xml` 中设置 `listings` 为 `false` |
| 限制管理接口访问 | 通过 IP 白名单限制 `/manager` 和 `/host-manager` 访问 |

## 回退方案

如需恢复默认行为，删除 `<Host>` 中添加的 `<Valve>` 配置行，重启 Tomcat 即可。
