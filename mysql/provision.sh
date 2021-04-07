setenforce 0
sed -i s/^SELINUX=enforcing$/SELINUX=disabled/g /etc/selinux/config
timedatectl set-timezone "Asia/Shanghai"
yum install wget -y
yum install vim -y
yum install net-tools -y
yum install sysstat -y
yum install libaio -y
groupadd -r mysql
useradd -r -g mysql -s /bin/false mysql
cd /vagrant
wget -q https://repo.huaweicloud.com/mysql/Downloads/MySQL-8.0/mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
tar -xf mysql-8.0.23-linux-glibc2.17-x86_64-minimal.tar.xz
mv mysql-8.0.23-linux-glibc2.17-x86_64-minimal /opt/mysql
cp my.cnf /etc
cp mysql.profile /etc/profile.d/mysql.sh
cp mysql.logrotate /etc/logrotate.d/mysql
chown -R mysql.mysql /opt/mysql
cd /opt/mysql
bin/mysqld --no-defaults --initialize-insecure --user=mysql
bin/mysql_ssl_rsa_setup
cp support-files/mysql.server /etc/init.d/mysql
chkconfig --add mysql
chmod 755 /opt/mysql/data
service mysql start
source /etc/profile
mysqladmin -u root password 123456

