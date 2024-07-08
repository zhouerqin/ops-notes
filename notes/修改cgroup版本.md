## 查看cgroup版本

要检查你的发行版使用的是哪个 cgroup 版本，请在该节点上运行 stat -fc %T /sys/fs/cgroup/ 命令：

`stat -fc %T /sys/fs/cgroup/`

对于 cgroup v2，输出为 cgroup2fs。

对于 cgroup v1，输出为 tmpfs。

## 修改cgroup版本

Ubuntu22.04系统 Cgroup v2 切换成v1

原因：ubuntu自21.04版本后的版本（不包含21.04）linux内核改用了cgroup v2版本，而容器镜像环境（centos7）需要的还是cgroup v1版本且centos7由于几乎不更新维护，因此后续小概率会支持cgroup v2。同时由于cgroup v2和v1不能兼容，因此导致容器启动后，内置的病毒沙箱引擎和相关服务无法正常启动。

vim /etc/default/grub

GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=0 systemd.unified_cgroup_hierarchy=0"

sudo update-grub

sudo reboot

> <https://blog.csdn.net/qq_44534541/article/details/133996067>
> <https://zhuanlan.zhihu.com/p/666615736?utm_id=0>
