# firewalld 防火墙配置

## 常用命令
```bash
# 查看防火墙状态
systemctl status firewalld

# 启动/停止防火墙
systemctl start firewalld
systemctl stop firewalld

# 开机启动/禁用
systemctl enable firewalld
systemctl disable firewalld
```

## 端口管理
```bash
# 开放端口
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=443/tcp

# 移除端口
firewall-cmd --permanent --zone=public --remove-port=80/tcp

# 查看开放的端口
firewall-cmd --zone=public --list-ports
```

## IP 管理
```bash
# 添加信任 IP
firewall-cmd --permanent --zone=trusted --add-source=192.168.1.100

# 移除信任 IP
firewall-cmd --permanent --zone=trusted --remove-source=192.168.1.100

# 查看信任 IP
firewall-cmd --zone=trusted --list-sources
```

## 服务管理
```bash
# 开放服务
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

# 查看开放的服务
firewall-cmd --zone=public --list-services
```

## 配置生效
```bash
# 重新加载配置（不中断连接）
firewall-cmd --reload

# 查看所有配置
firewall-cmd --list-all
```

## 参考文档
- firewalld 官方文档：<https://firewalld.org/>
- Red Hat firewalld 配置：<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/securing_networks/using-and-configuring-firewalls_securing-networks>
