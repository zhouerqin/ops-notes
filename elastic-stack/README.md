yum 安装 ELK 环境
=======================

  vagrant up

elasticsearch-setup-passwords interactive
这里会设置六个账号的密码：elastic,apm_system,kibana,logstash_system,beats_system,remote_monitoring_user.需要根据提示逐一设置密码。

* elasticsearch-certutil

该命令简化了 与 Elastic Stack 中的传输层安全性 （TLS） 配合使用

<https://www.elastic.co/guide/en/elasticsearch/reference/current/certutil.html>
