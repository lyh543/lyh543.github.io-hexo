---
title: Nginx（萌新向）
date: 2020-03-01 20:46:22
tags:
- 服务器
- Nginx
category:
- Linux
mathjax: true
---

下面记录 Nginx 在使用过程中遇到的“基本”操作。

## 给全站添加 SSL 证书

请看[另一篇博客](../build-https-sites-with-nginx/)。

## 网页转发

### 隐性转发

这里的情形是：用户访问 `https://cloud.example.com` 时，服务器服务器将其跳转到 `example.com:8080`（也可以转发到别的网址，但是貌似不能转发到 `https`，并且有些网站可能限制转发），地址栏仍然显示 `https://cloud.example.com`。

首先要将域名 `cloud.example.com` 以 `A` 的形式指向你的服务器 ip（也就是 `example.com` 的服务器）。

然后在服务器上新建文件 `\etc\nginx\conf.d\cloud.example.com`（习惯用网站命名配置文件），然后加入以下内容：

```conf
server {
       listen 443 ssl http2;
       server_name cloud.example.com;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://yourip:8080;
    }
}
```

记得修改 `cloud.example.com` 和 `yourip`。

这里默认你已经配置好了 `https` 以及 `http` 转发到 `https` 的操作。如果不想使用 https，将第二行修改为 `listen 80;` 即可。配置 https 请看[另一篇博客](../build-https-sites-with-nginx/)。

第三行的 `server_name` 不限形式，可以使用通配符、正则表达式，还可以使用 `.example.com` 的形式匹配 `example.com` 及其所有子域名。更多细节可以看 [server_name 的官方文档]

[server_name 的官方文档]:(http://nginx.org/en/docs/http/server_names.html)

### 显性转发

这里的情形是：用户访问 `https://cloud.example.com` 时，服务器服务器将其跳转到 `https://baidu.com/`（也可以转发到别的网址，无限制），地址栏显示 `https://baidu.com/`。

```conf
server {
       listen 443 ssl http2;
       server_name cloud.example.com;

       return https://baidu.com/;
}
```

### 显示某路径下 index.html

这里的情形是：用户访问 `https://example.com/` 时，服务器显示 `/path/to/index.html` 的内容。

```conf
server {
       listen 443 ssl http2;
       server_name cloud.example.com;

       location /{
           root /path/to;
           index index.html;
       }
}
```