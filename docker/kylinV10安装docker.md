# 在 KylinV10 上安装 Docker

## 前置条件
- 操作系统：KylinV10
- 需要 root 或具有 sudo 权限的用户
- 确保系统已经完成基础更新

## 安装步骤

### 1. 配置 Docker CE 软件源
```bash
# 添加 Docker CE 阿里云镜像源
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

### 2. 配置系统版本变量
```bash
# 设置 centos 版本为 8，以兼容 KylinV10
echo "8" > /etc/yum/vars/centos_version

# 替换软件源配置文件中的变量
sed -i 's/$releasever/$centos_version/g' /etc/yum.repos.d/docker-ce.repo
```

### 3. 安装 Docker
```bash
# 安装 Docker CE 及相关组件
yum install -y docker-ce docker-ce-cli containerd.io
```

### 4. 启动 Docker 服务
```bash
# 启动 Docker 服务并设置开机自启
systemctl enable --now docker
```

## 验证安装
执行以下命令验证 Docker 是否安装成功：
```bash
# 查看 Docker 版本
docker --version

# 运行测试容器
docker run hello-world
```

## 注意事项
1. 如果遇到软件源访问问题，可以尝试更换其他镜像源
2. 安装完成后，建议将当前用户加入 docker 用户组以避免每次使用 docker 命令时都需要 sudo：
   ```bash
   usermod -aG docker $USER
   ```
3. 重新登录后才能生效