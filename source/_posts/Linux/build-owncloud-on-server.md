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

## 安装基于 Docker 的 NextCloud

为什么要用 Docker 呢？这是为了系统的干净吧。不过坏处是，Docker 的 NextCloud 访问宿主机的文件就没那么容易了。当然，两种方法各有所长。

顺便一提，如果使用 Docker 的话，甚至可以在一台 Windows 电脑上部署了，就可以在自己的 Windows 电脑上搭建一个，然后用 `frp` 等方式内网穿透到公网了（可参考[博客](/Windows/use-remote-desktop-with-frp)）。

首先要安装 Docker 以及 Docker Compose，可参照[这篇教程](../docker)。

然后需要几个配置文件，我压缩好以后，放在我的网站上，当然也可以直接从服务器下载：

```bash
wget https://www.lyh543.xyz/Linux/build-owncloud-on-server/nextcloud-docker-compose.tar
tar -xf nextcloud-docker-compose.tar
cd nextcloud-docker-compose
cd nextcloud
```

然后一句

```bash
docker-compose up -d
```

经过漫长的镜像下载以后，即可在 `127.0.0.1:7070` 看到 NextCloud 初始化页面。

### 配置 Nextcloud

如果需要进入到 `docker` 的虚拟机中，可以使用一下命令进入容器的命令行：

```
[root@iz2ze nextcloud]# docker exec -it nextcloud_web_1 /bin/sh
/ #
```

其中 `nextcloud_web_1` 为你的容器名，一般来说就是这个，可以通过 `docker ps` 查看。

进入以后，就是 shell 的操作了。Nextcloud 文件的目录在 `/var/www/html`。
