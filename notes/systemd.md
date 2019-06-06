# Systemd

[Systmed](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-Managing_Services_with_systemd#tabl-Managing_Services_with_systemd-Introduction-Units-Locations)

## 创建和修改单元文件

单元文件命名采用以下形式
> unit_name.type_extension

单元文件通常由三部分组成：

1. [Unit] `包含不依赖于单位类型的通用选项。这些选项提供单元描述，指定单元的行为，并设置与其他单元的依赖关系。`
1. [unit type] `例如，服务单元文件包含[Service]部分`
1. [Install] `包含有关单元安装systemctl enable和disable命令的信息`

下面创建一个 service 单元例子
```
[Unit]
Description = service_description
After = network.target

[Service]
ExecStart = path_to_executable
Type = forking
PIDFile = path_to_pidfile

[Install]
WantedBy = multi-user.target
```

Type字段定义启动类型。它可以设置的值如下。
- simple（默认值）：ExecStart字段启动的进程为主进程
- forking：ExecStart字段将以fork()方式启动，此时父进程将会退出，子进程将成为主进程
- oneshot：类似于simple，但只执行一次，Systemd 会等它执行完，才启动其他服务
- dbus：类似于simple，但会等待 D-Bus 信号后启动
- notify：类似于simple，启动结束后会发出通知信号，然后 Systemd 再启动其他服务
- idle：类似于simple，但是要等到其他任务都执行完，才会启动该服务。一种使用场合是为让该服务的输出，不与其他服务的输出相混合
