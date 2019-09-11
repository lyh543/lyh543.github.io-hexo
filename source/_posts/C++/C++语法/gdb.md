---
title: gdb 简易调试
date: 2019-09-04 11:05:31
tags:
- 课程笔记
category:
- C++
- C++语法
mathjax: true
---

~~虽然还是喜欢用 Visual Studio~~

设置编译选项：`-g`  
启动与推出：`r(run)`，`q(quit)`  
设置断点：`break`（设断点），`info`（`info breakpoint` 展示断点），`del`，`enable`，`disable`，`watch`（跟踪某值）  
控制程序执行：`next`，`step`（下一行），`continue`，`finist`，`set`，`call`  
查看程序状态：`list`（展示代码），`backtrace`，`p(print) <variable>`（打印此时变量值），`break`，``  
执行上一条指令：`（回车）`
