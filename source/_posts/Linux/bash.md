---
title: bash 笔记
date: 2019-8-16
tags:
category:
- Linux
mathjax: true
---

入坑 Linux 以后，命令行也是一个非常重要的工具。本文简单总结一下常用的 bash 语法。

这里只讲纯语法，文件操作、系统工具等可以看 [Linux 日常](../linux-daily-command)。

## 当前文件夹 current directory

当前文件夹是便于写相对路径的。

假设你当前在 `/mnt/c/Users/lyh/Documents/Git/lyh543.github.io` 文件夹。  

当你需要访问文件夹下的 `_config.yml`，你就可以写 `_config.yml` 或 `./_config.yml` （注意一定要加`.`，否则会被视为根目录）来代替 `/mnt/c/Users/lyh/Documents/Git/lyh543.github.io/_config.yml`。

可以在命令行的`$`前看到当前文件夹，也可以使用非常简洁的命令：`pwd`。该命令返回当前文件夹。

* 更改当前文件夹使用 `cd [DIRECTORY]`  
* 若想跳到当前文件夹下的 `themes` 文件夹，可以使用 `cd themes`  
* 若想跳到上一级文件夹，可以使用 `cd ..`（Windows cmd 中 `cd` 和 `..` 间可以不加空格，但是 Linux Shell 必须要有空格）  
* 若想跳到上两级文件夹，可以使用 `cd ../..`  
* 若想跳到上两级文件夹下的`theme`文件夹，可以使用 `cd ../../theme`  

## 变量

对变量名的要求和 C/C++ 相同。

### 变量赋值

```bash
var=123
```

注意等号左右都不能有空格。左边有空格，`var` 会被视为命令；右边有空格，`123` 会被视为命令。（而 bash 的 `if` 则强制要求等号左右必须有空格）

若赋值有空格，可以使用引号括起来，赋值的结果没有引号。

```bash
$ var="123 456"
$ echo $var
123 456
```

### 变量取值

在变量名前加 `$` 即可。也可以把变量名用大括号括起来。

```bash
echo $var
echo ${var}
```

值得注意的是，也可以把命令执行的结果看作是一个取值的过程，如下：

```bash
var=`command`

var=$(command)
echo the current time is $(date +%c)
```

后者支持嵌套。

## 输出：`echo`

需要看 `echo` 的帮助请使用 `man echo` 而不是一般的 `command --help`。
