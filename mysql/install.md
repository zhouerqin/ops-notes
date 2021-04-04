MySQL 8.0安装
=============

yum install libaio -y

初始化
------

    mysqld --initialize --user=mysql --basedir=/opt/mysql --datadir=/opt/mysql/data
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
