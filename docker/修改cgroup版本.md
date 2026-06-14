# Cgroup 版本切换

## 查看当前版本
```bash
# 检查 cgroup 版本
stat -fc %T /sys/fs/cgroup/

# 输出说明：
# - cgroup2fs：表示使用 cgroup v2
# - tmpfs：表示使用 cgroup v1
```

## Ubuntu 22.04 切换到 cgroup v1
```bash
# 1. 修改 grub 配置
sudo vim /etc/default/grub

# 2. 添加或修改以下行
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=0 systemd.unified_cgroup_hierarchy=0"

# 3. 更新 grub
sudo update-grub

# 4. 重启系统
sudo reboot
```

## 参考文档
- Cgroup v2：<https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html>
- Ubuntu Cgroup：<https://ubuntu.com/blog/ubuntu-22-04-lts-and-cgroups-v2>
