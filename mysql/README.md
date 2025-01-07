# MySQL 8.0 二进制安装

```bash
# 安装依赖
yum install libaio -y

# 下载安装
cd /opt/
wget -q https://repo.huaweicloud.com/mysql/Downloads/MySQL-8.0/mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
tar -xf mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
mv mysql-8.0.23-linux-glibc2.17-x86_64-minimal mysql

# 初始化
cp my.cnf /etc/my.cnf
mysqld --no-defaults --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/opt/mysql/data
chown -R mysql.mysql /opt/mysql

# 启动服务
cp support-files/mysql.server /etc/init.d/mysql
chkconfig --add mysql
service mysql start
```

# MySQL 主从配置

主库操作：
```sql
# 导出数据
mysqldump --master-data=2 --single-transaction --set-gtid-purged=off -A >all.sql

# 创建复制用户
CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
```

从库操作：
```sql
-- 导入数据
mysql < all.sql

-- 配置主从
CHANGE MASTER TO  MASTER_HOST='192.168.51.11',
                  MASTER_PORT=3306,
                  MASTER_USER='repl',
                  MASTER_PASSWORD='password',
                  MASTER_LOG_FILE='mysql-bin.000056',
                  MASTER_LOG_POS=156;

-- 查看状态
SHOW SLAVE STATUS;
```
