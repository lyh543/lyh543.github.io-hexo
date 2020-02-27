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

## 安装基于 Docker 的 Seafile

这里我们基于 [HumanBrainProject/seafile-compose](https://github.com/HumanBrainProject/seafile-compose/) 来配置 Seafile。

为什么要用 Docker 呢？这是为了系统的干净吧。不过坏处是，Docker 的 NextCloud 访问宿主机的文件就没那么容易了。当然，两种方法各有所长。

顺便一提，如果使用 Docker 的话，甚至可以在一台 Windows 电脑上部署了，就可以在自己的 Windows 电脑上搭建一个，然后用 `frp` 等方式内网穿透到公网了（可参考[博客](/Windows/use-remote-desktop-with-frp)）。

首先要安装 Docker 以及 Docker Compose，可参照[这篇教程](../docker)。

然后我们下载前面提到的项目：

```bash
# 如果还没有安装 git，记得安装
git clone https://github.com/HumanBrainProject/seafile-compose
cd seafile-compose
```

但是！这个模板直接使用貌似会在一个过程中卡住。在修改一个地方以后，我才能够正常的进行部署。

```bash
nano seafile_dev_docker/Dockerfile
```

在这里，我们修改第三行起的 `RUN` 语句，将其拆分为几个 `RUN` 语句，顺便也替换了中科大的镜像源。

```dockerfile
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt update
RUN apt-get install -qq -y --no-install-recommends \
      vim \
      htop \
      net-tools \
      psmisc \
      git \
      wget \
      curl \
      build-essential \
      python-dev \
      python-pip \
      python-setuptools \
      python-wheel \
      libmysqlclient-dev
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
```

所以完整的 `seafile_dev_docker/Dockerfile` 应该如下：

```dockerfile
FROM ubuntu:16.04

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt update
RUN apt-get install -qq -y --no-install-recommends \
      vim \
      htop \
      net-tools \
      psmisc \
      git \
      wget \
      curl \
      build-essential \
      python-dev \
      python-pip \
      python-setuptools \
      python-wheel \
      libmysqlclient-dev
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENV SEAFILE_VERSION=6.3.3 SEAFILE_SERVER=seafile-server

RUN mkdir -p /opt/seafile/conf && \
    mkdir -p /opt/seafile/data && \
    mkdir -p /opt/seafile/pids && \
    mkdir -p /opt/seafile/ccnet && \
    mkdir -p /opt/seafile/sockets && \
    mkdir -p /opt/seafile/logs && \
    openssl genrsa -out /opt/seafile/ccnet/mykey.peer 4096 && \
    touch /opt/seafile/logs/seafile.log && \
    touch /opt/seafile/logs/ccnet.log && \
    touch /opt/seafile/logs/seahub.log

RUN mkdir -p /opt/seafile/ && \
    curl -sSL -o - https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz \
    | tar xzf - -C /opt/seafile/ && \
    ln -s /opt/seafile/seafile-server-${SEAFILE_VERSION} /opt/seafile/seafile-server-latest

ENV LD_LIBRARY_PATH=/opt/seafile/seafile-server-latest/seafile/lib:/opt/seafile/seafile-server-latest/seafile/lib64:$LD_LIBRARY_PATH
ENV SEAFILE_DATA_DIR=/opt/seafile/data CCNET_CONF_DIR=/opt/seafile/ccnet SEAFILE_CENTRAL_CONF_DIR=/opt/seafile/conf SEAFILE_CONF_DIR=/opt/seafile/seafile-data
ENV PYTHONPATH=/opt/seafile/seafile-server-${SEAFILE_VERSION}/seafile/lib64/python2.7/site-packages:/opt/seafile/seafile-server-6.3.3/seahub:/opt/seafile/seafile-server-6.3.3/seahub/thirdpart:$PYTHONPATH

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --disable-pip-version-check \
                -r /tmp/requirements.txt \
                -r /opt/seafile/seafile-server-${SEAFILE_VERSION}/seahub/requirements.txt

COPY config /opt/seafile/conf/
COPY ccnet /opt/seafile/ccnet/
COPY scripts /opt/seafile
```

然后使用该项目提供的命令进行构建：

```
docker-compose \
  -f docker-compose.yaml \
  up \
  --force-recreate \
  --renew-anon-volumes \
  --build
```

整个过程比较慢，最后如果看到了 `seahub_1` 开头的行，应该是配置完毕了。此时访问 `yourip:8000`，如果出现了 Seafile 登录页面，那么你就成功了 3/4 了。

接下来按 `Ctrl+C` 停止，然后重新让他以后台形式运行：

```
docker-compose up -d
```

前面的 `docker-compose` 命令只用于第一个构建 Docker，之后就用常规的 `docker-compose up -d` 即可。运行完以后可以检查一下 `8000` 端口是否正常。

剩下的 1/4 就是注册新账户了。这里 Seafile 不像 NextCloud 在第一次登陆时创建管理员账户，而是需要调用容器内的 Python 脚本。

在宿主机执行以下命令：

```sh
$ docker-compose exec seahub python /opt/seafile/seafile-server-latest/seahub/manage.py createsuperuser
/opt/seafile/seafile-server-6.3.3/seahub/thirdpart/requests/__init__.py:80: RequestsDependencyWarning: urllib3 (1.19) or chardet (3.0.4) doesn't match a supported version!
  RequestsDependencyWarning)
E-mail address: lxl361429916@live.com
Password:
Password (again):
Superuser created successfully.
```

前面的 Warning 可以忽略。注册完账户以后，就可以在 `8000` 端口登陆了。

### 可能报错及解决方案

#### 第一次配置时卡住

如果第一次配置的时候卡住，出现了下面的内容：

```
# docker-compose \
>   -f docker-compose.yaml \
>   up \
>   --force-recreate \
>   --renew-anon-volumes \
>   --build
Building ccnet
Step 1/15 : FROM ubuntu:16.04
 ---> 77be327e4b63
Step 2/15 : RUN apt update     && apt-get install -qq -y --no-install-recommends       vim       htop       net-tools       psmisc       git       wget       curl       build-essential       python-dev       python-pip       python-setuptools       python-wheel       libmysqlclient-dev     && apt-get clean     && rm -rf /var/lib/apt/lists/*
 ---> Running in 379f2d9271b1

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://archive.ubuntu.com/ubuntu xenial InRelease [247 kB]
Get:2 http://security.ubuntu.com/ubuntu xenial-security InRelease [109 kB]
Get:3 http://archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]
Get:4 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages [1063 kB]
Get:5 http://archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]
Get:6 http://archive.ubuntu.com/ubuntu xenial/main amd64 Packages [1558 kB]
Get:7 http://security.ubuntu.com/ubuntu xenial-security/restricted amd64 Packages [12.7 kB]
Get:8 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 Packages [620 kB]
Get:9 http://security.ubuntu.com/ubuntu xenial-security/multiverse amd64 Packages [6280 B]
Get:10 http://archive.ubuntu.com/ubuntu xenial/restricted amd64 Packages [14.1 kB]
Get:11 http://archive.ubuntu.com/ubuntu xenial/universe amd64 Packages [9827 kB]
1231231Get:12 http://archive.ubuntu.com/ubuntu xenial/multiverse amd64 Packages [176 kB]
Get:13 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages [1432 kB]
Get:14 http://archive.ubuntu.com/ubuntu xenial-updates/restricted amd64 Packages [13.1 kB]
Get:15 http://archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [1021 kB]
Get:16 http://archive.ubuntu.com/ubuntu xenial-updates/multiverse amd64 Packages [19.3 kB]
Get:17 http://archive.ubuntu.com/ubuntu xenial-backports/main amd64 Packages [7942 B]
Get:18 http://archive.ubuntu.com/ubuntu xenial-backports/universe amd64 Packages [8807 B]
Fetched 16.4 MB in 1min 46s (153 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.
```

可能是你没有修改 `Dockerfile`，请按照上面的方法修改 `Dockerfile`，然后重新 `docker-compose`

#### 设置密码时报错

如果设置密码时报错：

```py
seahub.base.accounts.DoesNotExist: User matching query does not exits.
```

可能是数据库的容器自己退出了。可以用 `docker ps --all`，然后看 `seafile-compose_db_1` 的 `STATUS` 是 `UP` 还是 `EXIT`。

如果是退出了，那么 `docker-compose up -d` 即可重启。
