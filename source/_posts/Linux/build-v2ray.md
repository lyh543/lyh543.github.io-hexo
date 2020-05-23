---
title: 服务器一键搭建 V2Ray
date: 2020-05-22 11:26:55
tags: 
- 服务器
- V2Ray
- 代理
- Linux
category:
- Linux
mathjax: true
---

## 前置需求

* 一个域名，且已以 A 记录指向服务器

## 暂时关闭 Nginx 和 Apache

由于 V2Ray 安装过程中会申请 SSL 证书，它会使用 HTTP 的验证方法，也就是在域名的某个网页上放一个 HTML 文件。因此必定会占用 80 端口，即使你的 V2Ray 最终不使用 80 端口。如果你正运行了 Nginx、Apache 或其他应用占用了 80 端口，请关闭。

```sh
systemctl stop nginx # 关闭 Nginx 
```

## 安装 Docker

一键脚本安装。如果不行，可以尝试到 Docker 官网上找方法。

```sh
bash <(curl -s https://get.docker.com)
```

## 安装 V2Ray 服务器端

一行命令，但是有需要修改的参数。

```sh
docker run -d --name v2ray --restart always -p <port>:443 -p 80:80 -v $HOME/.caddy:/root/.caddy pengchujin/v2ray_ws:0.08 <example.com> testv2ray <uuid> && sleep 3s && sudo docker logs v2ray
```

* `<port>`：代理使用的端口，任选一个 0-65535 的数字，如果不知道的话可以选 11111 或者就用 443（不知道那个 80 用来做什么。
* `<uud>`：一个随机的 id，可[在线生成](https://1024tools.com/uuid)。
* `<example.com>`：你的域名。

在本地修改好上述命令后，粘贴到命令行中执行。

三条命令监控 V2Ray：

```sh
docker start v2ray      # 启动 v2ray 并重新申请 SSL 证书
docker stop v2ray       # 停止 v2ray
docker logs v2ray       # 输出日志，可在这里查看 vmess 链接
```

链接可在 `docker logs v2ray ` 中查看。

logs 中有一个安卓链接，一个 ios 链接，PC 用安卓的链接即可。

## 配置 BBR

搭上梯子以后，发现有时候丢包率有 40% 左右。

Google 了一下，说是可以上 BBR。BBR 是什么，如何开启，可以看下面两篇博客，博主就不再复读了。

[Google BBR是什么？](https://tech.jandou.com/CentOS7-Google-BBR.html)

注意，BBR 是针对 TCP 发包的，也就是说，设置好以后，对于所有代理软件和服务器上的所有网页等都会生效。

[Ubuntu 18.04/18.10快速开启Google BBR的方法](https://www.moerats.com/archives/612/)
