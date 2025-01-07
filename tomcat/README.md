# Tomcat隐藏版本号和报错信息

在conf/server.xml配置文件中的<Host>配置项中添加如下配置：

```
<Valve className="org.apache.catalina.valves.ErrorReportValve" showReport="false" showServerInfo="false" />
