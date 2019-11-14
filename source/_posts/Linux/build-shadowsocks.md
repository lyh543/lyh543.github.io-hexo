---
title: 使用 Shadowsocks 搭建回国代理
date: 2019-10-14 12:33:12
tags: 
- 服务器
- Shadowsocks
- ssh
category:
- Linux
mathjax: true
---

本文就记流水账一般，记录一下，方便以后再配置的时候查阅。这些方法基本都是可以百度到的。

## 租服务器

首先，去租阿里云或腾讯云的服务器。学生的话，都是一月10元即可（找不到可以在知乎搜一下相关回答）。

推荐使用 Debian 或 Ubuntu。

然后租了服务器会给 ip 地址（下面为方便叙述，设为 `39.1.2.3`）和密码。

## ssh 远程登录服务器

注意**阿里云的服务器要开放防火墙的端口，不然连不上**！！！！！！！！  
作者就是被这个坑了一下午还没弄好。上面需要开放 `22` 端口，协议选 `tcp`。

在本地 Ubuntu（或 wsl 或 [Windows 的 ssh 客户端](../setup-ssh-windows/)）使用 `ssh -p22 root@39.1.2.3` 登录远程服务器。

要是出现 `ssh: connect to host 39.1.2.3 port 22: Resource temporarily unavailable`，  
再本地尝试 `ping 39.1.2.3`，要是连不上，说明 ip 被封了，需要删掉服务器，重新建一台服务器。

## 服务器配置 shadowsocks

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
    "password":"lyh543,xyz",
    "timeout":600,
    "method":"aes-256-cfb",
    "fast_open": false
}
```

注意：
* `server` 不能为 `127.0.0.1`，不然连不上；  
* `server_port` 建议不要使用默认的 `8838`；
* 如果有：`local_address` 必须删掉；
* `password` 改为自己设的密码。

然后执行 `ss-server`（CentOS 下是 `ssserver  -c /etc/shadowsocks.json`）。理论上服务器端就配置好了。

在本地下载 Shadowsocks， 并修改 Shadowsocks 配置（具体过程略），就可以进行连接了。（再次提醒，记得开放服务器的对应端口~~不然你一个小时又没了~~，这里是 `443`），协议选 `tcp`。

如果连接以后，随便上一个网站，看到服务器上出现 `INFO     connecting www.baidu.com:443 from x.x.x.x`，那么恭喜你，成功啦！

## 服务器上后台运行、开机自启

下面两种方法二选一：

### 使用 nohup 后台运行

由于服务器一般是不断电一直运行的。因此一般不用考虑开机自启的。

使用 `nohup` 的话，一行代码就 ok：

```bash
# nohup <command> & &>/dev/null
nohup ssserver & &> /dev/null
```

可能会看到 `ignore input` 之类的警告，不用管，`Ctrl+C` 退出前台即可，此时 `ssserver` 正在后台运行。

### 设置开机自启

在 `/etc/rc.local` 直接追加命令即可。

```
sudo echo "nohup ssserver & &> /dev/null" >>/etc/rc.local
```

### 使用 pm2 后台守护、开机自启

pm2 可以进行后台守护、开机自启。

这个要麻烦一点，要从 `npm` 下载，所以还得先下载 `npm`。

```bash
sudo apt install npm
sudo npm install pm2 -g
pm2 --name s1 -f start ss-server # 配置 pm2
pm2 startup # 设置 pm2 开机自启
pm2 save # 保存
```

## 配置 bbr

搭上梯子以后，发现学校教育网很稳，但是寝室里面的电信网丢包率有 40% 左右。

Google 了一下，说是可以上 BBR。BBR 是什么，如何开启，可以看下面两篇博客，博主就不再复读了。

[Google BBR是什么？](https://tech.jandou.com/CentOS7-Google-BBR.html)

[Ubuntu 18.04/18.10快速开启Google BBR的方法](https://www.moerats.com/archives/612/)

但貌似丢包率还是不低。。。
