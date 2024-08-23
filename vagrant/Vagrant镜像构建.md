# Vagrant镜像构建

## 使用virtualbox安装Rockylinux8.9
1. 最小化安装
2. 添加用户vagrant,密码vagrant
3. root用户密码vagrant
4. vagrant添加vagrant key 
   mkdir ~/.ssh
   chmod 700 ~/.ssh
   wget -O ~/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub
   chmod 600 ~/.ssh/authorized_keys

5. vagrant添加sudo权限
`echo vagrant ALL=(ALL) NOPASSWD:ALL>/etc/sudoer`

6. usermod -aG vboxsf vagrant
 
7. SSH调整
为了保持 SSH 快速，即使您的计算机或 Vagrant 机器也是如此 未连接到互联网，请在 SSH 服务器配置中将配置设置为。UseDNS=no
这避免了在连接的 SSH 客户端上进行反向 DNS 查找，该客户端 可能需要几秒钟。

## 打包镜像

vagrant package --base rocky8 --output rocky8.box

## 导入镜像

vagrant box add ./rocky8.box --name rocky8

## 使用镜像

vagrant init -m rocky8
vagrant up
vagrant ssh
