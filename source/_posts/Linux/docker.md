---
title: Docker 笔记
date: 2020-02-19 21:01:58
tags:
- Docker
- 服务器
category:
- Linux
mathjax: true
---

Docker 像是一个容器一样，能够让应用运行在隔离的环境中。其实很像一个虚拟机，但是其本质和虚拟机是不同的，结构较虚拟机简单的多，因此速度也远快于虚拟机。

> Docker 文档：https://docs.docker.com/install/linux/docker-ce/centos/
> Docker Compose 文档：https://docs.docker.com/compose/install/

## 安装 Docker

由于项目是基于 Docker 的，所以要先安装 Docker。这篇文章安装的是稳定版的 Docker Engine - Community。

先卸载以前的 Docker 安装：

```
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

再安装所需的包：

```
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

接下来添加 Docker 的库，并安装 Docker：

```
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
$ sudo yum install -y docker-ce docker-ce-cli containerd.io
```

到这里，我们安装了 Docker 并建立了 `Docker` 用户组，但里面还没有成员。  

接下来启动 Docker：

```
$ sudo systemctl start docker
```

然后进行一个对 Docker 的 Hello-World 测试：

```
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:9572f7cdcee8591948c2963463447a53466950b3fc15a247fcad1917ca215a2f
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

表示测试正常。

## 安装 Docker Compose

Docker Compose，就可以使用配置文件，一行代码配置 Docker 了。

下载 Docker Compose 1.25.4（如需下载最新版，请上 [GitHub](https://github.com/docker/compose/releases) 查看版本号），并给予可执行权限：

```
$ curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

最后检查一下是否成功安装：

```
$ docker-compose --version
docker-compose version 1.25.4, build 8d51620a
```
