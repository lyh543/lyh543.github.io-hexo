---
title: bash笔记
tags:
category:
- Linux
mathjax: true
---

入坑 Linux 以后，命令行也是一个非常重要的工具。本文简单总结一下使用过的 Linux 语句。

## 当前文件夹 current directory

当前文件夹是便于写相对路径的。若你当前在 `/mnt/c/Users/lyh/Documents/Git/lyh543.github.io` 文件夹。当你需要访问文件夹下的 `_config.yml`，你就可以写 `_config.yml` 或 `./_config.yml` （注意一定要加`.`，否则会被视为根目录）来代替 `/mnt/c/Users/lyh/Documents/Git/lyh543.github.io/_config.yml`。

可以在命令行的`$`前看到当前文件夹，也可以使用命令：

```bash
pwd
```

该命令返回当前文件夹。

* 更改当前文件夹使用 `cd [DIRECTORY]`  
* 若想跳到当前文件夹下的 `themes` 文件夹，可以使用 `cd themes`  
* 若想跳到上一级文件夹，可以使用 `cd ..`（Windows cmd中 `cd` 和 `..` 间可以不加空格，但是 Linux Shell 必须要有空格）  
* 若想跳到上两级文件夹，可以使用 `cd ../..`  
* 若想跳到上两级文件夹下的`theme`文件夹，可以使用 `cd ../../theme`  

## 查看文档： `cat`

使用 `cat [FILE]` 即可在控制台内显示文档。但是只能看文档，若想修改文档，请使用 [vi](../vi笔记)。

## 重定向输出到文档、创建文档

在命令行控制台中，类似于 `C++` 的 `printf` 的输出语句 `echo` 貌似没什么用。  
但是使用重定向，就可以把本来要输出到屏幕的东西输出到某文件。

在任意命令后（其实在前面也可以的）加 `>[FILE]` 即可把输出

## 删除：`rm`

`rm [FILE]` 是 remove 的缩写，用于删除文件。

很经典的一个删库跑路语句是`rm -rf /*`，我们能从这句话记它的用法。

* `-r`: recursive, 递归，即递归删除该文件夹以下的文件（夹），删非空文件夹时必加。
* `-f`: force, 强制，即强制删除~~虽然不知道有什么用~~
* `[File]`: 写文件、文件夹名就行啦。
