# locale -a 报错

如果您的CentOS系统没有en_US语言环境，可以通过以下步骤安装：

1. 更新系统软件包：

```
sudo yum update
```

2. 安装en_US语言包：

```
sudo yum install -y glibc-common
sudo localedef -c -f UTF-8 -i en_US en_US.UTF-8
```

3. 确认语言环境已经创建：

```
locale -a
```

此时应该可以看到en_US.UTF-8已经被添加到语言环境中了。