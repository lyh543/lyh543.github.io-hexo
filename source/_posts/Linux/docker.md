---
title: Docker 笔记
date: 2020-02-19 21:01:58
tags:
- Docker
- 服务器
- Linux
category:
- Linux
mathjax: true
---

Docker 像是一个容器一样，能够让应用运行在隔离的环境中。其实很像一个虚拟机，但是其本质和虚拟机是不同的，结构较虚拟机简单的多，因此速度也远快于虚拟机。  
Docker 还是跨平台的，可以在 Linux/Windows/MacOS 上运行。  
对于 Windows 的 Docker（准确的说是 Docker Desktop），它还提供了 Linux 和 Windows 两种子系统。（也就是说，在 Linux 下能运行的 Docker 容器，完全能够在 Windows 上运行）

而 Docker Compose 可以根据配置文件自动下载镜像、配置、运行 Docker 容器，一气呵成。  
下载网上写好的配置文件，然后一行代码 `docker-compose` 即可完成配置，搭建好自己的云服务。它同样是跨平台的。这也是 Docker 方便的原因之一。

> Docker 文档：https://docs.docker.com/install/linux/docker-ce/centos/
> Docker Compose 文档：https://docs.docker.com/compose/install/

我收集的基于 Docker 的好用的云服务可以见[后面小节](#docker-镜像)。

## 安装 Docker

### Linux 安装 Docker

#### 脚本安装

```sh
bash <(curl -s https://get.docker.com)
```

#### 手动安装

由于项目是基于 Docker 的，所以要先安装 Docker。这篇文章安装的是稳定版的 Docker Engine - Community。

先卸载以前的 Docker 安装：

```sh
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

```sh
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

接下来添加 Docker 的库，并安装 Docker：

```sh
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
$ sudo yum install -y docker-ce docker-ce-cli containerd.io
```

到这里，我们安装了 Docker 并建立了 `Docker` 用户组，但里面还没有成员。  

接下来启动 Docker：

```sh
$ sudo systemctl start docker
```

然后进行一个对 Docker 的 Hello-World 测试：

```sh
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

### Windows 安装 Docker

Windows 也是支持 Docker 的，他还支持 Windows 容器和 Linux 容器。

安装方法是去官网下载 Docker Desktop 并安装，然后就可以在命令行中使用 `docker` 和下面提到的 `docker-compose` 了，命令和 Linux 也是一样的。

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

## Docker 更换国内源

> 参考链接：https://www.cnblogs.com/wushuaishuai/p/9984228.html#_label0

和很多东西一样，Docker 镜像也有国内仓库。

国内的 Docker 镜像仓库有：

```
https://registry.docker-cn.com
http://hub-mirror.c.163.com
https://3laho3y3.mirror.aliyuncs.com
http://f1361db2.m.daocloud.io
https://mirror.ccs.tencentyun.com
```

这里选 aliyun 的做示范。

创建一个 `daemon.json`：

```bash
sudo vim /etc/docker/daemon.json
```

按 `i` 进入编辑模式，写入以下内容：

```json
{
  "registry-mirrors": ["https://3laho3y3.mirror.aliyuncs.com"]
}
```

按 `esc` 退出编辑模式，按 `:wq` 保存。

然后重启 Docker 服务。

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Windows 应到 Docker Desktop 的 Settings 中的 Docker Engine 栏中修改。下面是我修改后的内容。

```json
{
  "registry-mirrors": ["https://3laho3y3.mirror.aliyuncs.com"],
  "insecure-registries": [],
  "debug": true,
  "experimental": false
}
```

验证镜像源可以使用命令 `docker info`，如果看到有两行：

```
 Registry Mirrors:
  https://3laho3y3.mirror.aliyuncs.com/
```

就表示成功。

下次拉取镜像的时候就快得多了。

## 常用 Docker 镜像

个人收集的一些基于 Docker 的云服务。

用途|镜像名|`docker-compose.yml`链接
-|-|-
私人云|NextCloud|[nextcloud-docker-compose.tar](https://blog.lyh543.xyz/Linux/build-owncloud-on-server/nextcloud-docker-compose.tar)
私人云|[Seafile](https://github.com/HumanBrainProject/seafile-compose/)|[docker-compse.yaml](https://github.com/HumanBrainProject/seafile-compose/blob/master/docker-compose.yaml)
在线 Markdown 编辑器|[CodiMD](https://github.com/hackmdio/codimd)|[docker-compse.yml](https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-docker-deployment#Using-docker-compose-to-setup-CodiMD)
在线 LaTeX 编辑器|[Overleaf](https://github.com/overleaf/overleaf/wiki/Quick-Start-Guide)|[docker-compose.yml](https://github.com/overleaf/overleaf/blob/master/docker-compose.yml)
云 SSH|[WebSSH2](https://hub.docker.com/r/oldiy/docker-webssh2)|无
远程 Firefox|[firefox-enpass-novnc](https://hub.docker.com/r/oldiy/firefox-enpass-novnc)|无
v2ray+自定义dns||`sudo docker run -d --rm --name v2ray -p 443:443 -p 80:80 -v $HOME/.caddy:/root/.caddy  pengchujin/v2ray_ws:0.08 YOURDOMAIN.COM V2RAY_WS && sleep 3s && sudo docker logs v2ray`





## Docker 基础命令

初次接触 Docker，要记得两个概念：images（镜像） 和 containers（容器）。从网上获取一个镜像，然后每次可以由这个镜像创造一个容器（像是每次由一个系统镜像安装一个系统一样）。

下面是博主最先接触到的几条命令，可能比较适合和博主一样的新人。

命令|用途|常用参数
-|-|-
`docker run -dit ubuntu`|从 Ubuntu 镜像创造一个容器并运行|可用 `--name` 对容器命名，默认名是随机生成的；在最后可加 `<command>`
`docker start -i <name>`|运行名为 `<name>`（也可以是容器的 container ID 值的前几位）的容器
`docker images`|查看本地的镜像
`docker image prune -af`|删除所有没有使用的镜像（如果有容器使用了某镜像，无论这个容器正在运行/已停止，这个镜像不会被删除）
`docker ps`|查看正在运行的容器|加 `--all` 或 `-a` 查看所有的（包括已停止的镜像）
`docker container rm <name>`|删除名为 `<name>`（也可以是容器的 container ID 值的前几位）的容器
`docker container prune -af`|删除所有已停止的容器
`docker container rename <old_name> <new_name>`|给容器改名
`docker exec -it <name> /bin/bash`|在正在运行的 `<name>` 容器中运行 bash 命令行

## Docker Compose 基础命令

命令|用途|常用参数
-|-|-
`docker-compose up`|以当前文件夹下的 `docker-compose.yml` 作为配置文件，`run` 一个容器|`-d`可在后台运行
`docker-compose down -v`|删除当前文件夹下的 `docker-compose.yml` 所指的容器

## Docker Compose 文件语法

本人不会写 `docker-compose.yml`，只会做一些简单的修改，因此只记录自己用过的语法。

```yml
    ports:
      - 7070:80
      # 将 Docker 内的 80 端口映射到宿主机的 7070 端口
      # 即可以通过访问 Docker 外部的 7070 端口访问到内部的 80 端口
```

## 常见错误（更新中）

### 在 Docker 容器中如何安装软件

不少 Docker 容器都是采用的 Alpine Linux，这个 linux 发行版没有 `sudo`，没有 `bash`，我猜是为了简洁吧，毕竟要做成镜像，所以把没用的功能尽量都砍了。

Alpine Linux 下安装软件的命令为：

```sh
apk add <package name>
```

顺便中科大镜像源也有 Alpine Linux 的软件源，觉得国内网速慢的可以去更换，镜像站也有更换教程。

### Read-only file system

可能是 `docker-compose.yml` 中指定了目录为只读。这些可能出现在：

```yml
version: '3.3'
 
services:
  redis:
    image: redis:4.0.1-alpine
    networks:
      - myoverlay
    read_only: true # 指定为只读
    
networks:
  myoverlay:
```

```yml
  web:
    build: ./web
    restart: always
    ports:
      - 7070:80
    volumes:
      # - nextcloud:/var/www/html:ro   # ro 为只读 (read-only)
      - nextcloud:/var/www/html        # 可读写的版本
    depends_on:
      - app
```

### Container is unhealty

博主在 Windows 下安装 overleaf 时，出现过下面的情况。

```sh
> docker-compose up
Creating network "overleaf_default" with the default driver
Creating overleaf_redis ... done
Creating overleaf_mongo ... done

ERROR: for sharelatex  Container "233abaae4ea7" is unhealthy.
ERROR: Encountered errors while bringing up the project.
```

在配置文件 `docker-compose.yml` 中写到，`sharelatex` 基于 `overleaf_redis` 和 `overleaf_mongo`，并且要求 `mongo` 是 healthy 的。  
`233abaae4ea7` 正是我电脑上的 `mongo` 的 Container ID。

```yml
sharelatex:
    depends_on:
        mongo:
            condition: service_healthy
        redis:
            condition: service_started
mongo:
    healthcheck:
        test: echo 'db.stats().ok' | mongo localhost:27017/test --quiet
        interval: 10s
        timeout: 10s
        retries: 5
```

healthy 可以理解为是正常运行。

这里出错就有两种情况了，一是 `mongo` 本身不正常了，另一种是 `mongo` 检查的太频繁了，导致还没完成启动，就被诊断为 unhealthy 了。

我们检查一下 mongo 的 log。

```bash
> docker ps | find "233a"
233abaae4ea7        mongo                                   "docker-entrypoint.s鈥?   About a minute ago   Restarting (14) 47 seconds ago                            overleaf_mongo
```

显示 `mongo` 正在重启，我估计是在反复不正常-重启，因此就考虑在这方面进行 debug。  
最后的问题出在由于我是在 Windows 上运行，文件映射可能不正确，我把配置文件的 `volumes` 部分删掉就可以了。

当然，如果是正确的情况，上一行会显示：

```bash
> docker ps --all | find "mongo"
194bafd8158f        mongo                                   "docker-entrypoint.s鈥?   13 minutes ago      Up 12 minutes (healthy)   27017/tcp                overleaf_mongo
```

这种情况下，可以考虑把 `mongo` 的 `healthcheck` 部分的 `inteval` 和 `timeout` 调大。
