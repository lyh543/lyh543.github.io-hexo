---
title: 使用 Shadowsocks 搭建回国代理
date: 2019-10-14 12:33:12
tags: 
- 服务器
- Shadowsocks
category:
- Linux
mathjax: true
---

本文就记流水账一般，记录一下，方便以后再配置的时候查阅。这些方法基本都是可以百度到的。

## 租服务器

首先，去租阿里云或腾讯云的服务器。学生的话，都是一月10元即可（找不到可以在知乎搜一下相关回答）。

推荐使用 Debian 或 Ubuntu。

然后租了服务器会给 ip 地址（下面为方便叙述，设为 `39.1.2.3`）和密码。

## ssh 远程登录

注意**阿里云的服务器要开放防火墙的端口，不然连不上**！！！！！！！！  
作者就是被这个坑了一下午还没弄好。上面需要开放 `22` 端口，协议选 `tcp`。

在本地 Ubuntu（或 wsl 或自行百度 ssh 的方法）使用 `ssh -p22 root@39.1.2.3` 登录远程服务器。

要是出现 `ssh: connect to host 39.1.2.3 port 22: Resource temporarily unavailable`，  
再本地尝试 `ping 39.1.2.3`，要是连不上，说明 ip 被封了，需要删掉服务器，重新建一台服务器。

## 配置 shadowsocks

成功连上以后，安装 shadowsocks-libev：

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

然后 `ss-server`（CentOS 下是 `ssserver  -c /etc/shadowsocks.json`），并在本地修改 Shadowsocks 配置，就可以进行连接了。（再次提醒，记得开放服务器的对应端口~~不然你一个小时又没了~~，这里是 `443`），协议选 `tcp`。

如果连接以后，随便上一个网，看到服务器上出现 `INFO     connecting www.baidu.com:443 from x.x.x.x`，那么恭喜你，成功啦！

## 服务器上守护进程

可以用了以后，你想要开机自启，还想要让他在后台跑，就需要进程守护。下面两种方法二选一：

### 使用 nohup

使用 `nohup` 的话，一行代码就 ok：

```bash
# nohup <command> & &>/dev/null
nohup ssserver & &> /dev/null
```

可能会看到 `ignore input` 之类的警告，不用管，`Ctrl+C` 退出前台即可，此时 `ssserver` 正在后台运行。

### 使用 pm2

这个要麻烦一点，要从 `npm` 下载，所以还得先下载 `npm`。

```bash
apt install npm
npm install pm2 -g
pm2 --name s1 -f start ss-server # 配置 pm2
pm2 startup # 启动
pm2 save # 保存
```