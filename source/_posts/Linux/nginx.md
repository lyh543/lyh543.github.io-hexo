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

这里的情形是：用户访问 `https://cloud.example.com` 时，服务器将其跳转到 `127.0.0.1:8080`，地址栏仍然显示 `https://cloud.example.com`。

首先要将域名 `cloud.example.com` 以 `A` 的形式指向你的服务器 ip（也就是 `example.com` 的服务器）。

然后在服务器上新建文件 `\etc\nginx\conf.d\cloud.example.com`（习惯用网站命名配置文件），然后加入以下内容：

```nginx
server {
        listen 443 ssl http2;
        server_name cloud.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

1. 这里默认你已经配置好了 `https` 以及 `http` 转发到 `https` 的操作。如果不想使用 https，将第二行修改为 `listen 80;` 即可。配置 https 请看[另一篇博客](../build-https-sites-with-nginx/)。
2. 第三行的 `server_name` 不限形式，可以使用通配符、正则表达式，还可以使用 `.example.com` 的形式匹配 `example.com` 及其所有子域名。更多细节可以看 [server_name 的官方文档]
3. [server_name 的官方文档]:(http://nginx.org/en/docs/http/server_names.html)
4. 也可以转发到别的网址，但是貌似不能转发到 `https`，并且有些网站可能限制转发。

### 显性转发

这里的情形是：用户访问 `https://cloud.example.com` 时，服务器服务器将其跳转到 `https://baidu.com/`，地址栏显示 `https://baidu.com/`。

```nginx
server {
    listen 443 ssl http2;
    server_name cloud.example.com;

    return 301 https://baidu.com/;
}
```

这种方法也可以转发到别的网址，无限制。

#### 识别路径和参数并转发

这里我们讨论更复杂的显性转发情况。方便起见，用表格进行说明：

用户输入的网址|转发后的网址
-|-
`https://www.lyh543.xyz/`|`https://blog.lyh543.xyz/`
`https://www.lyh543.xyz/git`|`https://blog.lyh543.xyz/Linux/Git/`
`https://www.lyh543.xyz/linux`|`https://blog.lyh543.xyz/Linux/linux-daily-command/`
`https://www.lyh543.xyz/<其他参数>`|`https://blog.lyh543.xyz/<其他参数>`

我使用的配置文件如下：

```nginx
server{
    listen 443 ssl http2;
    server_name www.lyh543.xyz;


    location = / {
        return 301 https://blog.lyh543.xyz/;
    }

    location /git {
        return 301 https://blog.lyh543.xyz/Linux/Git/;
    }

    location /linux {
        return 301 https://blog.lyh543.xyz/Linux/linux-daily-command/;
    }

    location / {
        return 301 https://blog.lyh543.xyz$request_uri;
    }
}
```

注意到最后的 `$request_uri` 是个很好用的东西。除此之外，我们可以把任意一个 `url` 拆分为 `$scheme://$host$request_uri`。

具体地，对于访问链接 `https://blog.lyh543.xyz/nginx/`，我们有：

参数名|实际意义
`$scheme`|`https`
`$host`|`blog.lyh543.xyz`
`$request_uri`|`/nginx/`

按这种方法，很容易写出 `http` 强制跳 `https` 的配置文件：

```nginx
server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name  _;

    return 301 https://$host$request_uri;
}
```

## 显示某路径下 index.html

这里的情形是：用户访问 `https://example.com/` 时，服务器显示 `/path/to/index.html` 的内容。

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    location /{
        root /path/to;
        index index.html;
    }
}
```