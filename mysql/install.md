CentOS系统下使用通用二进制安装包安装MySQL 8.0
=========================================

[下载mysql](https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar)

- 如果系统已经安装mysql,请先卸载mysql,并移除/etc/my.cnf或者/etc/mysql,/etc/profile.d/mysql
- CentOS7系统下需要安装libaio依赖`yum install libaio -y`


初始化
------

    mysqld --no-defaults --initialize --user=mysql --basedir=/opt/mysql --datadir=/opt/mysql/data
    or 
    mysqld -I --user=mysql --basedir=/opt/mysql --datadir=/opt/mysql/data
    cp my.cnf /etc/my.cnf #拷贝my.cnf配置文件,可以参考版本库里面的模板
    cp support-files/mysql.server /etc/init.d/mysql
    chkconfig --add mysql
    
    service mysql start

修改环境变量
-----------

设置日志轮转
-----------

复制[mysql.logrotate](mysql.logrotate)

    cp mysql.logrotate /etc/logrotate.d/mysql

修改默认密码
-----------

    set password="123456";

主从配置
=======

主库导出数据
-------------

    mysqldump --master-data=2 --single-transaction --set-gtid-purged=off --log-error=all.log -A >all.sql

从库执行
--------

    mysql < all.sql
    change master to  master_host='192.168.50.11',
                      master_port=3306,
                      master_user='root',
                      master_password='123456',
                      master_log_file='mysql-bin.000056',
                      master_log_pos=156;
    
    
    SHOW SLAVE STATUS|SHOW REPLICA STATUS
    SHOW SLAVE HOSTS|SHOW REPLICAS
