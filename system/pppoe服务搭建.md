# PPPoE 服务器搭建

## 安装 PPPoE 服务器
```bash
# Debian/Ubuntu
sudo apt-get install pppoe-server

# CentOS/RHEL
sudo yum install rp-pppoe-server
```

## 配置 PPPoE 服务
```bash
# 1. 创建 PPPoE 配置文件
sudo vi /etc/ppp/pppoe-server-options

# 2. 添加基本配置
ms-dns 8.8.8.8
ms-dns 8.8.4.4
netmask 255.255.255.0
defaultroute
require-pap
require-chap

# 3. 创建用户账号
sudo vi /etc/ppp/chap-secrets
# 格式：用户名 服务类型 密码 IP地址
# 例如：
# user    *    password    *
```

## 启动服务
```bash
# 启动 PPPoE 服务
sudo pppoe-server -I eth0 -L 192.168.1.1 -R 192.168.1.100-200

# 查看服务状态
sudo systemctl status pppoe-server
```

## 参考文档
- PPPoE 服务器配置：<https://linux.die.net/man/8/pppoe-server>
- PPP 认证配置：<https://ppp.samba.org/pppd.html>