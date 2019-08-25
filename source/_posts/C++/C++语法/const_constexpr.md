---
title: const 和 constexpr
tags:
category:
- C++
- C++语法
---

C: `#define ll long long`
C++: 'cosnt int k=5;'

const中可以有变量名，但constexpr的表达式中不能有变量（可以有常量），因为：

**constexpr 在编译时进行初始化，const 在运行时初始化**！

## 底层const 和顶层 const

不是很懂，感觉没用
