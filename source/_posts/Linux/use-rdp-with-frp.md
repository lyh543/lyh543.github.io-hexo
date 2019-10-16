---
title: 利用内网穿透进行远程桌面访问
date: 2019-10-16 20:07:27
tags:
- 服务器
- frp
category:
- Linux
mathjax: true
---

平时带一台轻薄的笔记本，打开远程家里/寝室里的台式，进行远程桌面，在有网速保证的前提下，既能获得笔记本的轻便型，也能获得台式电脑的强大性能，更能最大化笔记本的续航，更重要的是可以在同一台机器上进行办公、开发，无需资料同步。是很不错的选择。

博主体验过的几款远程桌面软件里，

* Teamviewer 是一个很优秀的选择；
* 向日葵免费版有 300kbps 的限速，几乎等于不能用；
* Anydesk 国内网速太慢，不可用；
* 应急的话，还可以用 QQ 的远程协助。（用 QQ 的远程协助启动 Teamviewer 的远程协助）

除了以上选择以外，其实微软自带了远程桌面 `mstsc`。在局域网内你就可以通过远程 `*.*.*.*:3389` （你的电脑 ip）体验到远程桌面，体验同样是相当不错的。

（**但是实测 mstsc 没有 Teamviewer 好，因为在 10M 以下带宽，mstsc 会模糊字体；而 Teamviewer 可以在较低的带宽显示清晰的字体**，所以本文只是用于体验）

但是，如果在外网体验的话，就不大好了。原因是，你在外网里找不到被远程端的 ip 地址（未经强调，本文所有 ip 指 ipv4，此处是因为 ipv6 在中国还没普及）。

## NAT 及内网穿透的原理

ip 是一台机器在互联网上的唯一地址，可以通过你的机器 ip，从互联网的任何一端找到你的机器。

然而， ipv4 的数量是极其有限的，只有 256\*256\*256\*256=4294967296 四十亿个（想想现在地球多少人口）。  
而且还有很多 ip 是保留的，不能作为互联网里的 ip。   
现在的 ip 地址已经快要用完了。 

因此，聪明的运营商们想了一个办法，可以用一个设备，把他的一个 ip，下发为一万个 ip（当然，远不止这么多）。  
这种方法叫 NAT（Network Address Translation，网络地址转换）。  
好处是 ip 够用了，坏处是，转换过的 ip 是不能在互联网上直接访问到，你就不能直接靠输入 ip 来实现远程。（所以互联网上能直接访问到的 ip 又叫公网 ip）

但是，你想想，肯定是会有方法的，要是你的电脑和一个有公网 ip 的电脑建立了联系，要想访问你的电脑，就可以通过找到这个 ip，让公网 ip 电脑转发一下数据到你的电脑上，就成了！  
这便是内网穿透。

内网穿透需要一台有公网的电脑，最简单的办法，就是去租一个服务器。而实现转发数据、内网穿透的软件叫 [frp](https://github.com/fatedier/frp)。

（以下两段复制自 [使用 Shadowsocks 搭建回国代理](../build-shadowsocks)）

## 租服务器

首先，去租一个阿里云或腾讯云的服务器。学生的话，都是一月10元即可（找不到可以在知乎搜一下相关回答）。

推荐使用 Debian 或 Ubuntu。

然后租了服务器会给 ip 地址（下面为方便叙述，设为 `39.1.2.3`）和密码。

## ssh 远程登录

注意**阿里云的服务器要开放防火墙的端口，不然连不上**！！！！！！！！  
作者就是被这个坑了一下午还没弄好。上面需要开放 `22` 端口，协议选 `tcp`。

在本地 wsl（或自行百度 ssh 的方法）使用 `ssh -p22 root@39.1.2.3` 登录远程服务器。

## 下载并配置 frp

> 参考链接：https://www.hostloc.com/thread-463360-1-1.html

本地和远程下载 [frp](https://github.com/fatedier/frp/releases) 的压缩包，然后解压。

注意下**对应系统**的**最新**的包，而不是复制粘贴下面的命令（我遇到 `i/o deadline reached` 什么的奇奇怪怪的错误就是因为下的 `0.9.0` 版本的）。

服务器端的命令：

```bash
wget https://github.com/fatedier/frp/releases/download/v0.29.0/frp_0.29.0_linux_amd64.tar.gz
tar -zxvf frp_0.29.0_linux_amd64.tar.gz
cp -r frp_0.29.0_linux_amd64 /etc/frps
rm -f frpc frpc_full.ini frpc.ini
```

frp 的压缩包中同时包含了 server 服务器版本 `frps` 和 client 客户端版本 `frpc`。服务器可以删除 `frpc` 相关文件，客户端（被远程的电脑）可以删除 `frps` 相关文件。

然后配置服务器的 `frps.ini` 和客户端的 `frpc.ini`。

服务端 `frps.ini` 一行即可，指明客户端连入的端口：

```
bind_port = 7000
```

客户端 `frpc.ini` 要复杂一点。

```
[common]
server_addr = 39.1.2.3 # 这里是 vps 的 ip
server_port = 7000
[rdp]
type = tcp
local_ip = 127.0.0.1
local_port = 3389  # 本地的 Remote Desktop 对应端口
remote_port = 5200 # 服务器接收 Remote Desktop 信息的端口，可以改
```

几个端口解释一下：

1. 首先，服务器启动
2. 客户端启动访问服务器的 7000 端口，建立内网穿透
3. 远程的设备访问服务器的 5200 端口，服务器即把数据转发给客户端的 3389 端口，即可远程桌面

**注意开放服务器防火墙 tcp 7000 和 5200 端口！！！！** 博主被这后面这个坑了一个小时。明明配置好了，就是连不上，原来是服务器没开端口。

另外还需要配置一下客户端的远程桌面方面的设置，这个比较常见，在 `控制面板-系统-(侧边栏)远程设置-(单选框)允许远程连接到此计算机`。

## 启动 frp 及守护进程

服务器 `/etc/frp/frps -c /etc/frp/frp.ini`，客户端 `frpc.exe -c frpc.ini`。

启动以后，要是有什么问题，建议检查端口开放和 frp 版本是否为最新，然后再百度。（对我各被坑了一个小时）

如果没什么问题，就可以测试远程桌面了。

要是可以正常使用，就可以准备守护进程了。

服务端使用 `nohup /etc/frp/frps -c /etc/frp/frps.ini & &> /dev/null`。

可能会看到 `ignore input` 之类的警告，不用管，`Ctrl+C` 退出前台即可，此时 `ssserver` 正在后台运行。

客户端需要开机后台启动 `frpc`，可以使用 vbs：

新建一个文本文档，加入下面两行脚本代码，并改名为 `startup-frpc.vbs`，复制到 `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp` 下。

```vbs
set ws=WScript.CreateObject("WScript.Shell")
ws.Run "c:\frp\frpc.exe -c c:\frp\frpc.ini",0
```

要是这时没启动，就双击执行一下 vbs 即可。