---
title: 搭建自己的 Owncloud 云盘
date: 2020-2-11 16:33:05
tags:
- 服务器
category:
- Linux
mathjax: true
---

> 2020.2.12 更新：相比 Owncloud，NextCloud 貌似更新。所以博主转投 NextCloud 了。另外知乎上也有很多人安利 seafile。

## 安装 Owncloud

转载链接：https://zhuanlan.zhihu.com/p/28648363

官方教程：https://doc.owncloud.org/server/9.0/admin_manual/installation/linux_installation.html

按照上面无脑配就可以了。不多说。

## 配置 Owncloud

按照知乎的链接装完以后

* 配置文件在 `/etc/owncloud/config.php`
* 云盘文件默认在 `/var/lib/owncloud/data`，可在开始使用，进入管理员账户的时候修改。

顺便一提，对于 NextCloud，配置文件在 ``，安装文件在 `/var/www/html/nextcloud/`。

如果需要进行配置，需要用 apache 用户运行 `/var/www/html/nextcloud/occ` 命令，还需要给可执行权限。

```
chmod a+x /var/www/html/nextcloud/occ # 给可执行权限
sudo -u apache /var/www/html/nextcloud/occ --help
```

## 重置 Owncloud 密码

官方的不会用。我 Owncloud 又没存什么东西，于是就直接卸载、重装了。（最省事

