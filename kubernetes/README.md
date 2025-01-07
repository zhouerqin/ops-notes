# Kubernetes 集群配置

## 初始化主节点
```bash
# 初始化集群
kubeadm init \
  --kubernetes-version=v1.20.5 \
  --pod-network-cidr="10.244.0.0/16" \
  --image-repository registry.aliyuncs.com/google_containers \
  --apiserver-advertise-address=192.168.50.11

# 安装网络插件
kubectl apply -f kube-flannel.yml
```

## 配置镜像加速
```bash
# 配置 Docker 镜像加速
echo '{"registry-mirrors":["https://registry.docker-cn.com"]}' > /etc/docker/daemon.json
systemctl restart docker

# 获取节点加入命令
kubeadm token create --print-join-command
```

## 待完善
1. docker 日志警告处理
2. docker 国内镜像加速
