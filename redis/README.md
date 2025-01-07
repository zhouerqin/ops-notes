# Redis 安装配置

## 编译安装
```bash
# 下载并解压
wget https://download.redis.io/releases/redis-6.2.2.tar.gz
tar xzf redis-6.2.2.tar.gz
cd redis-6.2.2

# 编译安装
make && make install PREFIX=/usr/local/redis

# 创建用户和目录
useradd -r -s /sbin/nologin redis
mkdir -p /usr/local/redis/{etc,logs,data}
chown -R redis:redis /usr/local/redis
```

## 配置 systemd 服务
```ini
# /etc/systemd/system/redis.service
[Unit]
Description=Redis persistent key-value database
After=network.target

[Service]
Type=forking
User=redis
Group=redis
ExecStart=/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf
ExecStop=/usr/local/redis/bin/redis-cli shutdown

[Install]
WantedBy=multi-user.target
```

## 启动服务
```bash
systemctl daemon-reload
systemctl enable redis
systemctl start redis
```

## 哨兵模式配置文件

## 哨兵模式常用命令

1. sentinel masters：返回该哨兵监控的所有Master的相关信息。
1. SENTINEL MASTER <name>：返回指定名称Master的相关信息。
1. SENTINEL SLAVES <master-name>：返回指定名称Master的所有Slave的相关信息。
1. SENTINEL SENTINELS <master-name>：返回指定名称Master的所有哨兵的相关信息。
1. SENTINEL IS-MASTER-DOWN-BY-ADDR <ip> <port><current-epoch> <runid>：如果runid是*，返回由IP和Port指定的Master是否处于主观下线状态。如果runid是某个哨兵的ID，则同时会要求对该runid进行选举投票。
1. SENTINEL RESET <pattern>：重置所有该哨兵监控的匹配模式（pattern）的Masters（刷新状态，重新建立各类连接）。
1. SENTINEL GET-MASTER-ADDR-BY-NAME <master-name>：返回指定名称的Master对应的IP和Port。
1. SENTINEL FAILOVER <master-name>：对指定的Mmaster手动强制执行一次切换。
1. SENTINEL MONITOR <name> <ip> <port> <quorum>：指定该哨兵监听一个Master。
1. SENTINEL flushconfig：将配置文件刷新到磁盘。
1. SENTINEL REMOVE <name>：从监控中去除掉指定名称的Master。
1. SENTINEL CKQUORUM <name>：根据可用哨兵数量，计算哨兵可用数量是否满足配置数量（认定客观下线的数量）；是否满足切换数量（即哨兵数量的一半以上）。
1. SENTINEL SET <mastername> [<option> <value> ...]：设置指定名称的Master的各类参数（例如超时时间等）。
1. SENTINEL SIMULATE-FAILURE <flag> <flag> ...<flag>：模拟崩溃。flag可以为crash-after-election或者crash-after-promotion，分别代表切换时选举完成主哨兵之后崩溃以及将被选中的从服务器推举为Master之后崩溃。

## 哨兵模式主从切换规则

1. 如果该Slave处于主观下线状态，则不能被选中。
2. 如果该Slave 5s之内没有有效回复ping命令或者与主服务器断开时间过长，则不能被选中。
3. 如果slave-priority为0，则不能被选中（slave-priority可以在配置文件中指定。正整数，值越小优先级越高，当指定为0时，不能被选为主服务器）。
4. 在剩余Slave中比较优先级，优先级高的被选中；如果优先级相同，则有较大复制偏移量的被选中；否则按字母序选择排名靠前的Slave。

## 内核优化
### 参数名称             | 参数值
--------             | ------
net.core.somaxconn   | 系统默认128， 建议1024
vm.overcommit_memory | 系统默认0，建议设置为1
