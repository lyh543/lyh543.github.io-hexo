---
title: Hexo 建站
date: 2019-9-17
tags:
- Hexo
- npm
- 资源
category:
- Blog
---

先放一个[Hexo官方文档](https://hexo.io/zh-cn/docs/)的链接。

## 初始化hexo博客

```bash
npm install hexo-cli -g
hexo init lyh543.github.io
```

然后接[常规二连](#常规二连)就可以了

## 常规二连

```bash
# hexo clean
# 如果后面突然报bug，可以试下clean（虽然我也不知道有什么用）
hexo g
hexo d #可以替换为git add, commit, push三连
```

貌似调用`hexo`的任何命令的前 20 秒内命令行会没有回显，用~~Windows下的~~任务管理器查看是 `node` 占用了高 CPU。不知道是不是通病。

甚至可以简写为（以下二选一）：

```bash
hexo d -g
hexo g -d
```

## 配置 hexo-server

Hexo 提供了本地即时预览网页的功能，需要安装 hexo-server:

```bash
npm install hexo-server --save
```

安装以后，`hexo s`以后即可在`http://127.0.0.1:4000/`预览自己的博客了。本地更新文件以后，hexo 会即时更新，刷新网站即可预览更改。

## 配置 deploy

配置deploy就不用再到 git 里 push 了。

deploy 之前配置博客根目录下`_config.yml`最后三行为（冒号后一定要有空格！！！！）

```yml
deploy:
  type: git
  repo: https://github.com/lyh543/lyh543.github.io
  branch: master
```
  
还要安装`hexo-deployer-git`：

```bash
npm install hexo-deployer-git --save 
```

## 给 hexo 换主题

先区分两个概念：`主题配置文件`和`站点配置文件`。

`站点配置文件`用于配置站点，在`/_config.yml`；  
`主题配置文件`用于配置主题，在 `/theme/<theme name>/_config.yml`。
二者同名，故用概念区分，下同。

理论上，只要在`/theme`文件夹下配置好以后，修改站点配置文件的`theme`一项，即可方便的切换主题。

本文以[material](https://github.com/viosey/hexo-theme-material/)主题做示范，演示如何下载、配置主题。

1. 在github把上面的库`clone`到本地；
2. 在 Hexo 博客中的`/theme/`文件夹下创一个`material`文件夹；
3. 接下来把刚才`clone`的整个库复制到`material`文件夹里；
4. 最后改一下站点配置文件：

```yml
theme: material

language: zh-CN
```

即可。

Material主题配置具体需要注意的点见另一篇[博客](../hexo-material)。
