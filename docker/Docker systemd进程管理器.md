# Docker systemd 容器配置

## 使用 systemd 作为容器的 init 进程
```dockerfile
FROM centos:7
ENV container docker
RUN yum -y install systemd; \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
```

## 运行容器
```bash
docker run -d --privileged --cgroupns=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw your-image
```

## 参考文档
- Docker systemd 指南：<https://cloud-atlas.readthedocs.io/zh-cn/latest/docker/init/docker_systemd.html>
- systemd 容器：<https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container>
