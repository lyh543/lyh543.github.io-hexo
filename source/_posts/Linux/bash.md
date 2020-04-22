---
title: bash 笔记
date: 2019-8-16
tags:
- Linux
category:
- Linux
mathjax: true
---

入坑 Linux 以后，命令行也是一个非常重要的工具。本文简单总结一下常用的 bash 语法。

这里只讲纯语法，文件操作、系统工具等可以看 [Linux 日常](../linux-daily-command)。

## 常见要点

* 变量赋值 `=` 左右不能有空格  
* `if` `=` 左右都要有空格

## 变量

对变量名的要求和 C/C++ 相同。

```bash
var=123
```

注意等号左右都不能有空格。左边有空格，`var` 会被视为命令；右边有空格，`123` 会被视为命令。  
（而 bash 的 `if` 则强制要求等号左右必须有空格）

若赋值有空格，可以使用引号括起来，赋值的结果没有引号。

```bash
$ var="123 456"
$ echo $var
123 456
```

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

## 输出

`echo` 使用较简单。

需要看 `echo` 的帮助请使用 `man echo` 而不是一般的 `echo --help`。

## 流程控制

### 条件判断


### 循环

```bash
for ((i=1; i<=100; i ++))
do
	echo $i
done
```

