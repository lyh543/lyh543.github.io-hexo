---
title: apt-get笔记
tags:
category:
- Linux
mathjax: true
---

APT，高级打包工具（英语：Advanced Packaging Tools，缩写为APT）是Debian及其派生的Linux软件包管理器。  ——[Wikipedia](https://zh.wikipedia.org/wiki/APT)

## 第一件事：更新源

`apt-get`的下载链接可以理解为是存在本地的。  
如果第一次用`apt-get`，或者太久没有用，可能某些链接就失效了。  
所以，这种情况下就得先

```bash
sudo apt-get update
```

## 安装

```bash
sudo apt install <package name>
```
