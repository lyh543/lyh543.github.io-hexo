---
title: 面对SSH暴力破解，给你支个招|九州云
date: 2020-05-20 9:07:02
tags:
- Linux
- iptables
- 网络安全
category:
- Linux
mathjax: true
---

> 转载自 [面对SSH暴力破解，给你支个招|九州云](http://www.99cloud.net/10774.html%EF%BC%8F)。为防链接挂掉，转载一手。

在最近一次云上线的过程中，频繁遇到绑定公网浮动 IP 的云主机遭受外界 SSH 暴力破解攻击及用户设置弱密码的问题，由此引发的安全问题引起了针对防御 SSH 暴力破解的思考。

## SSH 暴力破解

`hydra` 和 `medusa` 是世界顶级密码暴力破解工具，支持几乎所有协议的在线密码破解，功能强大，密码能否被破解关键取决于破解字典是否足够强大。在网络安全渗透过程中，`hydra` 和 `medusa` 是必备的测试工具，配合社工库进行社会工程学攻击，有时会获得意想不到的效果。图示两款工具使用密码字典穷举 `SSH` 密码的过程。

![穷举 SSH 密码](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/c75250d317f8b7b9972a59185c9eb23690e7cc1055075bdf82cda1a9b8321806.png)

## iptables 限制 ssh 访问频率

面对暴力破解，根据其工作原理可知：降低其试错频率，提高其试错次数，从而将破解时间提高到不可容忍的程度，是一条有效的防范手段。

提高攻击方试错次数，无非是提升密码长度，扩展密码复杂度，定期更换密码这些手段。而降低攻击方的试错频率其实也是一条值得一试的防御手段。

通过调用 `iptables` 的 `state` 模块与 `recent` 模块，实现对 SSH 访问的频率限制。这里重点解释下不常用的 `recent` 扩展模块。

### recent 模块

Recent，该扩展能够动态的创建 IP 地址列表，用于后期以多种不同形式做出匹配。该扩展支持以下多种选项：

![Recent 选项](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/7c6612c60aa138422f8ee03bfc1047954d17c0541bbb77f06d44f8364ac30473.png)

### iptables 规则内容

要实现对 SSH 访问频率的控制，`iptables` 规则如下两条：

```sh
# 若是SSH访问，源IP在最近访问列表中，且60秒内访问次数大于等于3次，则丢弃。
iptables -I INPUT -p tcp –dport 22 -m state –state NEW -m recent –name SSH_RECENT –rcheck –seconds 60 –hitcount 3 -j DROP
#若是SSH访问，则将源IP加入最近访问列表中。
iptables -I INPUT -p tcp –dport 22 -m state –state NEW -m recent –name SSH_RECENT –set
```

### 实现效果

实现效果如下图所示。高频率的密码试错将被终结，直至一分钟超时后才可重新开始。

![实现效果](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/31ed234cf6d6e9cc82ed3d6d6ecb5713e9f75df0226c7199286e6f6b05cd0cc5.png)  

在 `/proc/net/xt_recent` 目录中，存在名为 `SSH_RECENT` 的一个日志文件。文件中记录了上面输入的 `iptables` 规则记录的最近访问 SSH 服务的源 IP 信息以及访问时间。其中默认记录的 `oldest_pkt` 是 20 个，可以通过 `modprobe ipt_recent ip_pkt_list_tot=50` 调大。默认记录的源 IP 是 100 个，可以通过 `modprobe ipt_recent ip_list_tot=1024` 扩大记录数量。

![](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/046f38cba1d2a6ecd2449878780f4988ee1b8f2376830edd54c92c8c57270d98.png)  

## iptables 实现远程开启 ssh 功能

任何一次靠谱的网络攻击都起步于网络侦查。如果攻击者在网络侦查阶段未发现目标开启 SSH 登录服务，这也将挫败其针对 SSH 发起攻击的计划。这里常用的操作都是更改 SSH 的默认 22 端口至其他端口号上以迷惑端口扫描软件。实际通过 `nmap` 等工具还是可以扫描到端口上捆绑的具体服务，如下图所示。这里通过一个取巧的办法，利用指定报文长度的 ICMP 作为钥匙，开启主机上的 SSH 服务。通过这种方式隐藏 SSH 服务端口。

![picture 5](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/e6a6716baf09e6164e94741ecd650a4025c01d210cabcdc6399b774ec18ffe12.png)  


### iptables 规则内容

以指定包长的 ICMP 报文，作为钥匙，开启对端的 SSH 服务。具体 iptables 规则如下所示。

```sh
# 用 78 字节的 icmp 数据包作为钥匙(包含 IP 头部 20 字节，ICMP 头部 8 字节)，将源 IP 加入 SSH 白名单
iptables -A INPUT -p icmp –icmp-type 8 -m length –length 78 -m recent –name SSH_ALLOW –set -j ACCEPT

# 检查访问 SSH 服务的源 IP 是否在白名单中，且白名单中的IP有效期为15秒。若在白名单中则放行通讯。
iptables -A INPUT -p tcp –dport 22 -m state –state NEW -m recent –name SSH_ALLOW  –rcheck –seconds 15 -j ACCEPT

#对于已建立的SSH连接放行
iptables -A INPUT -p tcp –dport 22 -m state –state ESTABLISHED -j ACCEPT

#其他SSH无关匹配全部拒止
iptables -A INPUT -p tcp –dport 22 -j DROP
```

### 实现效果

最终可以实现下图所示效果。在未使用指定包长ICMP之前，SSH服务无法通行（步骤1）。在使用指定包长ping之后（步骤2），使用SSH可以正常连接（步骤3）。以此实现了指定包长ICMP作为钥匙开启SSH通信服务的效果。其原理与上节限制SSH通信频率的原理一致。

![picture 6](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/08857c5aa8a168ec6446a21e794b0bb6bc9afd6de960f99d7df2c5b535d76bbd.png)  


## Fail2ban防止SSH暴力破解

### 安装

Centos上可以直接通过yum install fail2ban –y安装。安装完成后，可在/etc/fail2ban路径下找到程序运行的相应文件。在filter.d目录下存放有fail2ban支持的所有过滤器，action.d目录下存放有fail2ban支持的所有动作。通过在jail配置文件中组合多种过滤器与动作，可以实现各种自定义的防御功能（不仅限于SSH防护）。

### 配置及运行

对于fail2ban而言，每个.conf配置文件都可以被同名的.local文件重写。程序先读取.conf文件，然后读取.local文件。.local中的配置优先级更高。通过新建jail.local，增加下述配置，运行fail2ban-client start来实现对SSH暴力破解的防御。

```ini
[DEFAULT]
#白名单
ignoreip = 127.0.0.1/8

#解封禁时间
bantime  = 600

#试错窗口时间
findtime  = 600

#容许试错次数
maxretry = 3

[ssh-iptables]

#使能
enabled = true

#选择过滤器
filter = sshd

#选择防御动作
action = iptables[name=SSH, port=ssh, protocol=tcp]

#邮件通知
sendmail-whois[name=SSH,dest=yang.hongyu@99cloud.net, sender=test@email.com]

#SSH日志路径
logpath = /var/log/secure

#容许试错次数（优先级比default高）
maxretry = 1
```

### 运行效果

通过对目标主机的SSH试错，/var/log/secure日志中记录了SSH登录的错误信息。fail2ban通过对该文件的分析，识别出当前正在遭遇到SSH的暴力破解，继而触发防御功能。fail2ban-client status命令可以查看当前fail2ban的运行状态，遭遇SSH暴力破解后，识别到的攻击IP被添加至Banned IP list中，实际阻断功能则是fail2ban通过在iptables中下发针对攻击IP的阻断规则来实现。

![](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/aaeab33bd666e9bf50b774646c0ebcb42e36c8de47dc1d8ea86740c8138e0706.png)

## Denyhost防止SSH暴力破解

Denyhost工作原理与Fail2ban基本一致，同样是分析SSH的日志文件，定位重复的暴力破解IP。与Fail2ban通过写iptables规则阻断攻击IP的访问不同，Denyhost通过将攻击IP记录到hosts.deny文件来实现屏蔽攻击IP对SSH的访问。

### Denyhost安装：

```sh
wget "downloads.sourceforge.net/project/denyhosts/denyhosts/2.6/DenyHosts-2.6.tar.gz"
tar -xzf DenyHosts-2.6.tar.gz
cd DenyHosts-2.6
python setup.py install
```

### Denyhost配置及运行

```sh
#生成配置文件副本
cd /usr/share/denyhosts/
#生成配置文件副本
cp denyhosts.cfg-dist denyhosts.cfg
#生成执行文件副本
cp daemon-control-dist daemon-control
chmod 700 daemon-control
#自定义配置文件denyhosts.cfg
#SSH log路径
SECURE_LOG = /var/log/secure
#存储SSH拒止host信息的配置文件路径
HOSTS_DENY = /etc/hosts.deny
#拒止时间,此处配置为10分钟
PURGE_DENY = 10m
#无效用户登录重试次数限制
DENY_THRESHOLD_INVALID = 5
#有效用户登录重试次数限制
DENY_THRESHOLD_VALID = 10
#ROOT用户登录重试次数限制
DENY_THRESHOLD_ROOT = 1
#启动运行
./daemon-control start
```
## Denyhost效果：

从Denyhost的运行日志中看出，对目标主机的多次SSH密码试错触发了Denyhost的防御功能。攻击者的IP被添加至hosts.deny文件，该IP下的SSH访问也被拒止。

![](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/018d00ead6697ca7c9cf5c532cc863be747ad0e8680d3e9e88ab1bac24733959.png)  


![](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/afaab44468761d85c88d0ad3aa136599e711923ff931d966d76fd9cbb03bbbfa.png)  


## 网络安全，何来一招鲜

可能有些人要说使用密钥登录就能完美解决SSH暴力破解的问题。这里要说一段历史。2006年Debian Linux发行版中发生了一件有意思的事，软件自动分析工具发现了一行被开发人员注释掉的代码。这行被注释掉的代码用来确保创建SSH秘密钥的信息量足够大。该代码被注释后，密钥空间大小的熵值降低到215。这意味着不论哪种算法和密钥长度，最终生成的密钥一共只有32767个，复杂度比一个纯6位数字的密码的复杂度更差。该错误在两年之后才被发现，无疑相当多的服务器上都利用这这种存在缺陷的弱密钥。（引用自：Violent Python：A Cookbook for Hackers）

网络安全没有一招鲜。前文中列举的四种安全加固方式也无法抵御运维人员设置的弱密码，及攻击者的社工密码库。运维人员，唯有提高自身安全意识，合理利用安全工具，才能保障网络安全。