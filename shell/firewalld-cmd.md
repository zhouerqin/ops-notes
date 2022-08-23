# firewalld-cmd
参数
```
--zone      作用域

--add-port  添加端口，格式为：端口/通讯协议

--permanent 永久生效，没有此参数重启后失效

--reload    并不中断用户连接，即不丢失状态信息
```

## 简单用法

添加开放端口
```
firewall-cmd --permanent --zone=public --add-port=80/tcp
```

添加ip白名单
```
firewall-cmd --permanent --zone=trusted --add-source=192.168.56.1
```

重新加载配置
```
firewall-cmd --reload
```
