---
title: TCHAR TEXT
date: 2019-8-19
tags:
category:
- C++
- C++语法
mathjax: true
---

> 摘自：https://github.com/guyaqi/backups/blob/master/notes/cpp1-4.md

TCHAR 与 TEXT 宏,这两个宏在对应的情况下有不同的解释，这与你的编译器默认使用的编码方式相关。

* 当 UNICODE 宏被定义的时候（MSVC 编译器指令 `/D UNICODE`)，TCHAR 是 wchat_t，TEXT 宏被解释成 C 语言内部用来转换宽字符的宏 `L"somestr"`
* 如果没有定义 UNICODE 宏，TCHAR 就是 char，TEXT 宏不进行任何操作。

这种设定是在 utf-8 编码没有被广泛支持的时候,为了程序代码能够兼容使用不同代码的机器设定的，比如我使用的 win7 默认使用 gb2312（还是 gbk 来着）字符集对应的编码方式,而 win10 以上和其他使用 linux 内核的系统默认使用 utf-8 编码方式。

值得一提的是 utf-8 使用 char，而通常 C++，Java，C# 对 UNICODE 的支持指的是使用 utf-16 的编码方式，在 C++ 中 utf-16 字符就是 wchar_t（宽字符）。
