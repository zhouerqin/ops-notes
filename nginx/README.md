# Nginx HTTPS 配置

在 nginx.conf 中添加：
```nginx
server {
    listen       443 ssl;                # 如果使用Nginx 1.15.0及以上版本，请使用listen 443 ssl代替listen 443和ssl on
    server_name example.com;             # 需要将example.com替换成证书绑定的域名
    ssl_certificate cert/server.pem;     # 需要将server.pem替换成已上传的证书文件的名称
    ssl_certificate_key cert/server.key; # 需要将server.key替换成已上传的证书密钥文件的名称
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1.2 TLSv1.3;      # 表示使用的TLS协议的类型
    ssl_prefer_server_ciphers on;
}
```
