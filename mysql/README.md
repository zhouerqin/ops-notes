CentOS系统下使用通用二进制安装包安装MySQL 8.0
=============================================

警告:
- 如果系统已经安装mysql,请先卸载mysql,并移除/etc/my.cnf文件或者/etc/mysql目录
- MySQL对libaio 库有依赖,CentOS7系统下使用`yum install libaio -y`安装


初始化

    cd /opt/
    wget -q https://repo.huaweicloud.com/mysql/Downloads/MySQL-8.0/mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
    tar -xf mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
    mv mysql-8.0.23-linux-glibc2.17-x86_64-minimal mysql
    #拷贝my.cnf配置文件,可以参考版本库里面的模板
    cp my.cnf /etc/my.cnf
    mysqld --no-defaults --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/opt/mysql/data
    chown -R mysql.mysql /opt/mysql
    cp support-files/mysql.server /etc/init.d/mysql
    chkconfig --add mysql
    service mysql start

修改环境变量

    cp mysql.profile /etc/profile.d/mysql.sh

设置日志轮转

    cp mysql.logrotate /etc/logrotate.d/mysql

修改默认密码

    set password="123456";

主从配置
-------------

主库导出数据

    mysqldump --master-data=2 --single-transaction --set-gtid-purged=off --log-error=all.log -A >all.sql
    # 创建复制的用户
    CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
    GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

从库执行

    # 导入数据库
    mysql < all.sql
    # 设置主库信息
    # MASTER_LOG_FILE MASTER_LOG_POS 参数在all.sql查看
    CHANGE MASTER TO  MASTER_HOST='192.168.51.11',
                      MASTER_PORT=3306,
                      MASTER_USER='repl',
                      MASTER_PASSWORD='password',
                      MASTER_LOG_FILE='mysql-bin.000056',
                      MASTER_LOG_POS=156;
    # 查看从库状态
    SHOW SLAVE STATUS | SHOW REPLICA STATUS
    # 主库上查看从库信息
    SHOW SLAVE HOSTS  | SHOW REPLICAS
