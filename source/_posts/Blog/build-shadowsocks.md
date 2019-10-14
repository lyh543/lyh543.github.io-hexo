---
title: 使用 Shadowsocks 搭建回国代理
date: 2019-10-14 12:33:12
tags:
category:
- Blog
mathjax: true
---

本文就记流水账一般，记录一下，方便以后再配置的时候查阅。这些方法基本都是可以百度到的。

## 租服务器

首先，去租阿里云或腾讯云的服务器。学生的话，都是一月10元即可（找不到可以在知乎搜一下相关回答）。

推荐使用 Debian 或 Ubuntu。

然后租了服务器会给 ip 地址（下面为方便叙述，设为 `39.1.2.3`）和密码。

## ssh 远程登录

注意**阿里云的服务器要开放防火墙，不然连不上**！！！！！！！！

在本地 Ubuntu（或 wsl 或自行百度 ssh 的方法）使用 `ssh -p22 root@39.1.2.3` 登录远程服务器。

要是出现 `ssh: connect to host 39.1.2.3 port 22: Resource temporarily unavailable`，再本地尝试 `ping 39.1.2.3`，要是连不上，说明 ip 被封了，需要删掉服务器，重新建一台服务器。

## 配置 shadowsocks

成功连上以后，安装 shadowsocks-libev：

```
apt update
apt install shadowsocks-libev
```

修改配置文件：

```
nano /etc/shadowsocks-libev/config.json
```

修改为以下内容：

```
{
    "server":"0.0.0.0",
    "server_port":443,
    "local_port":1080,
    "password":"AMDyes",
    "timeout":600,
    "method":"aes-256-cfb",
    "fast_open": false
}
```

注意：
* `server` 不能为 `127.0.0.1`，不然连不上；  
* `server_port` 建议不要使用默认的 `8838`；
* 如果有：`local_address` 必须删掉。

然后 `ss-server`，并在本地修改 Shadowsocks 配置，进行连接。

## 守护进程

我是使用 `pm2` 进行守护的，以后可以试下别的。先留坑。