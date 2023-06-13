# 描述
Gixy是一个分析Nginx配置的工具。 Gixy 的主要目标是防止安全配置错误并自动检测漏洞。

目前支持的 Python 版本是 2.7、3.5、3.6 和 3.7。

## 安装
    pip install gixy

## 用法

默认情况下，Gixy 会尝试分析放置在 中的 Nginx 配置。/etc/nginx/nginx.conf

但是您始终可以指定所需的路径：

    gixy /etc/nginx/nginx.conf