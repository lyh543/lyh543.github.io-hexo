---
title: apt-get笔记
date: 2019-8-20
tags:
category:
- Linux
mathjax: true
---

APT，高级打包工具（英语：Advanced Packaging Tools，缩写为APT）是Debian及其派生的Linux软件包管理器。  ——[Wikipedia](https://zh.wikipedia.org/wiki/APT)

## 第一件事：更新源

`apt-get`的下载链接可以理解为是存在本地的。  
如果第一次用`apt-get`，或者太久没有用，可能某些链接就失效了。  
所以，这种情况下就得先：

```bash
sudo apt-get update
```

### 第零件事：更换中科大源

由于众所周知的原因，Ubuntu 的源在国内访问很慢，建议换国内的镜像源。  
由于 USTC 的 wiki 对操作方法写的很清楚了，所以直接贴一个链接好了。

https://lug.ustc.edu.cn/wiki/mirrors/help/ubuntu

## 安装

```bash
sudo apt install <package name>
```
