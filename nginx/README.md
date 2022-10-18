# nginx https配置

```
server {
    listen       443 ssl;                # 如果未在此处配置HTTPS的默认访问端口，可能会造成Nginx无法启动,如果您使用Nginx 1.15.0及以上版本，请使用listen 443 ssl代替listen 443和ssl on
    server_name example.com;             # 需要将example.com替换成证书绑定的域名
    ssl_certificate cert/server.pem;     # 需要将cert-file-name.pem替换成已上传的证书文件的名称（注意修改）
    ssl_certificate_key cert/server.key; # 需要将cert-file-name.key替换成已上传的证书密钥文件的名称
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
                                         # 表示使用的加密套件的类型
                                         # ssl_ciphers AES256-GCM-SHA384; # 表示使用的加密套件的类型(wireshark抓包时使用)
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # 表示使用的TLS协议的类型
    ssl_prefer_server_ciphers on;
}
```
