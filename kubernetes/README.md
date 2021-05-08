初始化
================

  kubeadm init --kubernetes-version=v1.20.5 --pod-network-cidr="10.244.0.0/16" --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address=192.168.50.11 
  kubectl apply -f /vagrant/kube-flannel.yml
  
注意：
为了从国内的镜像托管站点获得镜像加速支持，建议修改Docker的配置文件，增加Registry Mirror参数，将镜像配置写入配置参数中
`echo '{"registry-mirrors":["https://registry.docker-cn.com"]}' > /etc/docker/daemon.json`
,然后重启Docker服务。

修改 k8s集群宿主机hosts 文件

kubeadm token create --print-join-command

kubectl logs -f deployment/mongo

待完善
-------------
1. docker 日志警告处理
2. docker 国内镜像加速


