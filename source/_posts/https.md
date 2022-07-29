title: 后端云网站全部url http -> https
date: 2017-05-06 11:03:57
readmore: false
categories: 网站里程碑
tags:
- https
---

# url http -> https

记录下：2017.05.06 “后端云”网站弃用http，开始全部采用更加安全的https链接。

```bash
    server {
        listen 443;
        listen 80;
        server_name ~^www\.backendcloud\.cn$;
        #server_name ~^(.+)\.(backendcloud)\.cn$;
        #server_name ~^www\.(backendcloud)\.cn$;
        ssl on;
        root /usr/share/nginx/html/backendcloud/www;
        #root /usr/share/nginx/html/$2/$1;
        #root /usr/share/nginx/html/$2/www;
        index index.html index.htm;
        ssl_certificate   cert/..._www.backendcloud.cn.pem;
        ssl_certificate_key  cert/..._www.backendcloud.cn.key;
        ssl_session_timeout 5m;
        ssl_ciphers ECDHE-RS ... RC4;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        location / {
            #root /usr/share/nginx/html/$2/$1;
            root /usr/share/nginx/html/backendcloud/www;
            index index.html index.htm;
        }
    }
```


另外还改了2个小细节：

# 浏览器http的访问请求会被自动替换成https的
```bash
    server {
      listen 80;
      server_name www.backendcloud.cn;
      rewrite ^(.*)$  https://www.backendcloud.cn$1 permanent;
    }
```

# `http(s)://backendcloud.cn/*` 的url会被自动替换成 `https://www.backendcloud.cn/*`
```bash
    server {
      listen        80;
      listen        443;
      server_name   backendcloud.cn;
      return 301    https://www.backendcloud.cn$request_uri;
    }
```