---
title: const 和 constexpr
date: 2019-9-2
tags:
category:
- C++
- C++语法
---

## C99 的 const

```c
const int n = 10;
int a[n];
```

上面的代码不能通过 C99 标准的 C 编译器。
因为 C99 对 const 的定义为只读的变量（而不是常量）。

## const 和 constexpr

C: `#define ll long long`
C++: 'const int k=5;'

const中可以有变量名，但constexpr的表达式中不能有变量（可以有常量），因为：

**constexpr 在编译时进行初始化，const 在运行时初始化**！

## 底层const 和顶层 const

不是很懂，感觉没用
