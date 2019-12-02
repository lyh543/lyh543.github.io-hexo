---
title: 使用 Shadowsocks 搭建回国代理
date: 2019-10-14 12:33:12
tags: 
- 服务器
- Shadowsocks
- ssh
- 代理
category:
- Linux
mathjax: true
---

## 前言

本文就记流水账一般，记录一下，方便以后再配置的时候查阅。这些方法基本都是可以百度到的。

> 2019.12.1 更新：发现周围有些人在问我如何搭建代理，我直接把这篇文章分享给他们，但是发现这篇博客写的太浅薄了，对新手也不够友好。最近也挺忙，要是有空，就再把这篇文章写的更加详实吧。先挖点坑：

* 为什么有些网站无法访问
* 如何访问这些网站（借助一个中介，介绍 Shadowsocks 原理）
* 服务器是什么？虚拟服务器是什么？如何使用？（介绍 ssh）

对于萌新，你们可能需要提前准备：

* 以下三选一（个人推荐 wsl）：
  * Ubuntu 双系统或虚拟机（如果你看不懂这个选项可以直接跳过）
  * wsl（百度“WSL(Windows Subsystem for Linux)的安装与使用”）
  * [Windows 的 ssh 客户端](/Windows/setup-ssh-windows/)（不推荐，但是如果你电脑的硬盘实在不够用了，可以选择这个选项）
* 准备好学习 Linux 命令行的决心
* 愿意在遇到问题的时候上网搜索，即使可能消耗十几分钟到一整天的时间

本文正式开始。

## 租服务器

首先，去租阿里云或腾讯云的虚拟服务器。学生的话，都是一月 10 元即可（找不到入口可以在知乎搜一下相关回答）。

系统推荐使用 Debian 或 Ubuntu。

租了服务器以后，会给你的服务器的 ip 地址（下面为方便叙述，设为 `39.1.2.3`）和密码。

## ssh 远程登录服务器

ssh 是什么，可以见前言。

注意**阿里云的服务器要开放防火墙的端口，不然连不上**！！！！！！！！  
作者就是被这个坑了一下午还没弄好。上面需要开放 `22` 端口，协议选 `tcp`。

在本地 Ubuntu（或 wsl 或 [Windows 的 ssh 客户端](/Windows/setup-ssh-windows/)）使用 `ssh -p22 root@39.1.2.3` 登录远程服务器。

要是出现 `ssh: connect to host 39.1.2.3 port 22: Resource temporarily unavailable`，  
再本地尝试 `ping 39.1.2.3`，要是连不上，说明 ip 被封了，需要删掉服务器，重新建一台服务器。

## 服务器配置 Shadowsocks

成功连上以后，在服务器安装 shadowsocks-libev：

```bash
apt update # debian 下是 apt，CentOS 换成 yum install 即可
apt install shadowsocks-libev
```

修改配置文件：

```bash
nano /etc/shadowsocks-libev/config.json
```

修改为以下内容：

```json
{
    "server":"0.0.0.0",
    "server_port":443,
    "local_port":1080,
    "password":"lyh543",
    "timeout":600,
    "method":"aes-256-cfb",
    "fast_open": false
}
```

注意：
* `server` 不能为 `127.0.0.1`，不然连不上；  
* `server_port` 建议不要使用默认的 `8838`，可以修改为 `0-65535` 间的其他端口，比如 `22222`；
* 如果有：`local_address` 必须删掉；
* `password` 改为自己设的密码。

然后执行 `ss-server`（CentOS 下是 `ssserver  -c /etc/shadowsocks.json`）。理论上服务器端就配置好了。

在本地下载 Shadowsocks， 并修改 Shadowsocks 配置（具体过程略），就可以进行连接了。（再次提醒，记得开放服务器的对应端口~~不然你一个小时又没了~~，这里是 `443`，协议选 `tcp`）。

如果连接以后，随便上一个网站，看到服务器上出现 `INFO     connecting www.baidu.com:443 from x.x.x.x`，那么恭喜你，成功啦！

## 服务器上后台运行

由于服务器一般是不断电一直运行的。因此一般不用考虑开机自启的。但是后台运行比较重要：

使用 `nohup` 的话，一行代码就 ok：

```bash
# nohup <command> & &>/dev/null
nohup ssserver & &> /dev/null
```

（实际山 ssserver 自带了后台运行的方法，但是通用方法它不香吗）

到这里，Shadowsocks 的配置就基本完成了。

## 番外篇：配置 bbr

搭上梯子以后，发现有时候丢包率有 40% 左右。

Google 了一下，说是可以上 BBR。BBR 是什么，如何开启，可以看下面两篇博客，博主就不再复读了。

[Google BBR是什么？](https://tech.jandou.com/CentOS7-Google-BBR.html)

[Ubuntu 18.04/18.10快速开启Google BBR的方法](https://www.moerats.com/archives/612/)

但貌似丢包率还是不低。。。

## 常见错误及解决方案

### 无法 ssh 登录远程服务器

* 尝试 ping 你的服务器，输入命令 `ping x.x.x.x`，如果显示 `100% 丢失`（或 `100% packet loss`），说明这个 ip 已经被墙了，需要删掉服务器，重新开一台；
* 可能没有开放服务器上的 `22` 端口（协议为 `tcp`）？

### 服务端配置好了，本地连不上/连上以后显示 500 Internal Proxy Error

* 可能是某些信息（如网址、密码、加密方式）没对应上，总之某些信息出锅了，而不是网络故障。
* 可能 Shadowsocks 使用的端口被屏蔽了，在[服务端修改端口](#服务器配置-Shadowsocks)，然后在本地客户端也修改为对应的端口，再尝试链接。
* 可能是端口被服务端其他进程占用了（可以通过命令 `lsof -i <端口号>` 查看）。如果确实，再改一个。

如果仍然没有搞定，可能需要通过查看 `nohup.out` 文件来看 Shadowsocks 的日志的最后二十行：

```
tail -n 20 nohup.out
```

然后上网百度 / Google。