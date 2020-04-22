---
title: 修改 ssh 的端口
date: 2019-10-18 10:01:34
tags:
- ssh
- 服务器
- Linux
category:
- Linux
mathjax: true
---

## 修改 ssh 端口的前因后果

今天用安卓手机 ssh 连接我的服务器的时候，出现了 `kex_exchange_identification`。又要修 bug 了。

百度了一下，按照 [ssh连接失败，排错经验](https://www.cnblogs.com/starof/p/4709805.html) 的步骤做了一下，发现 ssh 有时连得上，有时连不上。迷惑行为。

按照他的方法，关闭 ssh 服务，并开始 ssh 的调试模式：

```bash
service sshd stop
/usr/sbin/sshd -d
```

打开以后，貌似一切正常。

几秒以后，发现 ssh 显示了很多，然后就直接退出了？？？

粗略看了一下，有一个未知 ip （最后查出来是法国的）在尝试 ssh 连接我的服务器。大概是来搞我的。

于是我就把他放进 ssh 的黑名单了。

```sh
echo x.x.x.x >> /etc/hosts.allow
```

重新开启调试模式，发现几秒以后他又关掉了。

这次是江苏的。

重复了一次，发现又有一个北京的。

？？？？

大家都来搞我？？？

ssh 没有仅允许白名单访问的方法，那咋办嘛。

后来突然想到，**不应该用默认端口的**，否则他发现端口可用就可以暴力破解了！

于是下面才是正题：如何更改 ssh 的端口。

## 修改方法

```
vi /etc/ssh/sshd_config
```

```
# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key
```

现在的端口 `Port` 是默认的 22，我们要修改，先要把 `Port` 前注释的 `#` 去掉，然后把 22 改为自己想要的数字（0-65535 都可，只要不跟自己其他的端口重合）。

```
Port 2333
#AddressFamily any
```

然后再开调试模式，发现一切都和平了。

以后要 `ssh` 远程的时候，就要带一个端口参数了。对于 `39.1.2.3` 的服务器的 2333 端口，应该使用

```
ssh -p2333 root@39.1.2.3
```

即可。