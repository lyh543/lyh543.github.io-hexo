---
title: bash笔记
tags:
category:
- Linux
mathjax: true
---

入坑 Linux 以后，命令行也是一个非常重要的工具。本文简单总结一下使用过的 Linux 语句。

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

## 重定向输出到文档、创建文档：`>>`

在命令行控制台中，类似于 `C++` 的 `printf` 的输出语句 `echo` 貌似没什么用。  
但是使用重定向，就可以把本来要输出到屏幕的东西输出到某文件。

在任意命令后（其实在前面也可以的）加 `>[FILE]` 即可把输出

## 文件/文件夹操作

```bash
ls  # 显示文件夹的内容
cat text.txt  # 显示文档的内容
mkdir new_dir # 新建文件夹
chmod a+x test.sh # 给脚本文件加可执行的权限
./test.sh  # 执行可执行文件
```

若想修改文档，请使用 [vi](../vi笔记)。

### 删除：`rm`

`rm [FILE]` 是 remove 的缩写，用于删除文件/文件夹。

很经典的一个删库跑路语句是`rm -rf /*`，我们能从这句话记它的用法。

* `-r`: recursive, 递归，即递归删除该文件夹以下的文件（夹），删非空文件夹时必加。
* `-f`: force, 强制，即强制删除~~虽然不知道有什么用~~
* `[File]`: 写文件、文件夹名就行啦。

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
