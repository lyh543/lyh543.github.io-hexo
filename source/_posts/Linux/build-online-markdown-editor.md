---
title: 搭建在线 MarkDown 编辑器 -- CodiMD
date: 2020-02-19 16:58:37
tags:
- 服务器
- Docker
- Markdown
category:
- Linux
mathjax: true
---

偶然在群里看到了在服务上搭建的 Markdown 编辑器，叫 CodiMD，也想自己整一个。于是就找官方文档来安装。

> 项目链接：https://github.com/hackmdio/codimd
> CodiMD 文档：https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-docker-deployment

## 安装 Docker 及 Docker Compose

这两个部分已被迁移到一篇专门讲 Docker 的 [博客](../docker#安装-Docker) 中。

## 安装 CodiMD

现在准备工作做好了，就准备安装 CodiMD 了。

下面一份从 [CodiMD 文档](https://hackmd.io/c/codimd-documentation/%2Fs%2Fcodimd-docker-deployment) 获得的配置文件。复制下面的代码，并在任意处保存为 `docker-compose.yml`。

```
version: "3"
services:
  database:
    image: postgres:11.5
    environment:
      - POSTGRES_USER=codimd
      - POSTGRES_PASSWORD=change_password
      - POSTGRES_DB=codimd
    volumes:
      - "database-data:/var/lib/postgresql/data"
    restart: always
  codimd:
    image: nabo.codimd.dev/hackmdio/hackmd:1.4.1
    environment:
      - CMD_DB_URL=postgres://codimd:change_password@database/codimd
      - CMD_USECDN=false
    depends_on:
      - database
    ports:
      - "3000:3000"
    volumes:
      - upload-data:/home/hackmd/app/public/uploads
    restart: always
volumes:
  database-data: {}
  upload-data: {}
```

> 这里的原理是建立了两个容器（container），分别名为 `database` 和 `codimd`。他们之后就是他们的设置。  
> `database` 先通过 6-7 行建立数据库的账户，`codimd` 再通过 15 行 `CMD_DB_URL=postgres://codimd:change_password@database/codimd` 登录 `database` 进行数据交换。可以修改账户密码，但是记得 6-7 行和 15 行要同时改。

最后在文件所在目录下，一键下载配置：

```
docker-compose up -d
```

然后要等待漫长的镜像下载。

## 可能错误

### password authentication failed for user

首先检查 `docker-compose.yml` 的两个容器的 6-7、15 是否对应。

如果是对的，但是仍然报错，可能需要先删除容器，再重新建立容器：

```
docker-compose down -v
docker-compose up -d
```