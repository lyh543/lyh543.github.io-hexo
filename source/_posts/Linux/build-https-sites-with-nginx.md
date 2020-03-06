---
title: 全站添加 https
date: 2020-3-1 15:42:05
tags:
- 服务器
- https
- Nginx
category:
- Linux
mathjax: true
---

> 参考链接：
> * [LET'S ENCRYPT 给网站加 HTTPS 完全指南](https://ksmx.me/letsencrypt-ssl-https/)
> * [Docker 搭建私有云 Nextcloud](https://www.pbeta.me/docker-nextcloud-ssl/)
> * [nginx强制使用https访问(http跳转到https)](https://blog.csdn.net/wzy_1988/article/details/8549290)

~~哪个程序员不想要自己的网站全站 https 呢~~

现在基本都要求各网站使用 `HTTPS` 、`SSL` 之类的。于是准备给自己的博客和网站也整一个。

这篇博客就简单说一下，如何在自己的网站上使用 https。

请把本文中出现的所有 `example.com` 替换为你的域名，将 `yourip` 替换为你的服务器的 ip,

## HTTPS、SSL、TLS 相关术语介绍

参考[这篇博客](https://blog.csdn.net/enweitech/article/details/81781405)，可以知道 `HTTPS`、`SSL`、`TLS` 的定义和区别。

简单来说，

* SSL 是指安全套接字层，简而言之，它是一项标准技术，可确保互联网连接安全；
* TLS（传输层安全）是更为安全的升级版 SSL。由于 SSL 这一术语更为常用，因此我们仍然可以将我们的 TLS 安全证书称作 SSL。但当您从赛门铁克购买 SSL 时，您真正购买的是最新的 TLS 证书；
* TLS/SSL是一种加密通道的规范；
* HTTPS 实际上就是 HTTP over SSL

下面就开始正式内容。

## 关闭 Apache

Apache 和 Nginx 都属于 Web 服务器。二者可以同时安装，但是（一般）不能同时运行，因为对于 `http` 的 `80` 端口只能由一个软件监听，而 `https` 的 `443` 同理。

如何查看自己的电脑是否运行的是 Apache 呢？

```
lsof -i:80
```

如果看到了 `httpd` 或 `apache` 等字样，就说明你的服务器正运行了 Apache。

如果运行了 Apache，则需要关闭 Apache。这里请读者自己百度完成。

安装 Nginx 可以采用直接在系统上安装和使用 Docker 安装在容器里。

## 在系统上安装 Nginx

以下两种安装 Nginx 的方法二选一。如果不知道选什么，推荐这一种方法，不使用 Docker。

对于 CentOS 7，安装并运行 nginx 的命令为：

```sh
yum install nginx
systemctl start nginx
```

停止 nginx 的命令为：`systemctl stop nginx`  
重启 nginx 的命令为：`systemctl restart nginx`  

## 在 Docker 容器中安装 Nginx

安装 Nginx 的方法二选一。如果不知道选什么，推荐上面的方法，而不是这种方法。

这里由于我们需要将 SSL 证书文件所在文件夹传给 `Nginx`，但是还没有申请证书，我们就先新建一个文件夹，否则 docker 的命令会报错。

```bash
mkdir /etc/letsencrypt
```

安装 Docker 的过程可以看这篇[博客](../docker)。假设你已经安装好 Docker 了，下面就讲一讲在 Docker 中下载、构建、运行 Nginx 的命令。

```bash
docker run --name nginx \
-p 80:80 \
-p 443:443 \
-v /etc/nginx:/etc/nginx \
-v /var/www:/var/www \
-v /etc/letsencrypt:/etc/letsencrypt \
-id nginx
```

其中 `-v` 参数是将`:`左边的本机地址映射到右边的容器中。（所以为什么要用 Docker 呢）

停止 nginx 的命令为：`docker stop nginx`
重启 nginx 的命令为：`docker restart nginx`

## 测试 Nginx

打开你的服务器网站 `example.com`，如果看到了欢迎界面，则说明 Nginx 正常。

## 域名解析

然后要进行域名解析。

在你的域名提供商那里，把你想要加 https 的所有域名（如 `cloud`）以 `A` 的形式解析到你的服务器。也可以直接将 `*` 解析到你的服务器，这样没有专门设定解析的域名都会被以 `A` 解析到你的服务器。

## 申请 SSL 证书

参考：[Docker 搭建私有云 Nextcloud -- 申请 SSL 证书](https://www.pbeta.me/docker-nextcloud-ssl/#ssl)。

下载 autocert 软件并给予可执行权限：


```sh
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
```

然后一行命令（记得替换两个 `example.com`）：


```
./certbot-auto certonly -d "example.com" -d "*.example.com" --manual --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```

这样可以申请到 `example.com` 及其下的所有子域名的证书。还可以继续增加域名（即使是别的域名）：`-d "another.xyz"`

过程中需要：

1. 输入你的邮箱（可选）
2. 是否同意条款（那必须得同意）
3. 是否加入邮件列表（看你）
4. 是否同意 IP 被公示（同意）
5. 往你的域名加入一段 TXT（照着做就可以了），然后回车继续。这是在验证这确实是你的网站

之后如果看到了 `Congratulations`，就是成功了。

在

完成这一步以后，文件夹 `/etc/letsencrypt/live/example.com` 会有以下文件

```
# ls /etc/letsencrypt/live/example.com
cert.pem  chain.pem  fullchain.pem  privkey.pem  README
```

这四个都是证书文件，请妥善保管。具体哪个是什么，可以先不追究这些细节。

接下来，我们针对三种情况进行

## 对全站加载 SSL 证书

接下来我们要用 Nginx 做两件事：

* 将 `https://*.example.com/` 加载 SSL 证书
* 将 `http://*.example.com/` 转发到 `https://*.example.com/`
、
我们要通过配置 nginx 服务来完成这一点。

> 如果你已经搭建过 nginx 服务，请直接参考修改 nginx 配置文件即可。

我们在 `/etc/nginx/conf.d/` 新建一个 `https.conf`。

```sh
nano /etc/nginx/conf.d/https.conf
```

然后添加以下内容：

```conf
server {
        listen  80;
        server_name .example.com;

	return 301 https://$host$request_uri;
}


server {
       listen 443 ssl http2;
       server_name *.example.com;
       ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
       ssl_trusted_certificate  /etc/letsencrypt/live/example.com/chain.pem;
       ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
       ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4:!DH:!DHE;
                ssl_prefer_server_ciphers on;
                ssl_session_cache shared:SSL:10m;
                ssl_session_timeout 30m;
       add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
}
```

第三行的 `.example.com` 是 Nginx [官方](http://nginx.org/en/docs/http/server_names.html)给出的，可以同时匹配 `*.example.com` 和 `example.com` 的形式。好评！

同时从官方链接可以看到 `server_name` 可以使用四种方式匹配，这里就提一笔，略过了。

**读者需要自行修改第 3、10-13 行中的 `example.com`**

保存并退出后，（根据自己安装 Nginx 的形式）重启 Nginx。

这之后，访问域名下的任意子域名都可以被强制跳转到 https 并且使用正确的加密。

## 自动定期更新证书

Let's Encrypt 证书有效期是 3 个月，我们可以通过 `certbot` 来自动化续期。

这里使用 `crontab`。

```
$ sudo crontab -e
```

以下是 vim 的操作界面。先按 `i` 以进入编辑模式，然后输入以下内容：

```
 0,12 * * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew
```

然后按 `esc` 退出编辑模式，再按 `:wq` 保存并退出即可。
