---
title: C++：what's plus
date: 2019-09-02 16:58:17
tags:
- 课程
category:
- C++
- C++面向对象
mathjax: true
---

除了面向对象，C++ 和 C 有什么区别呢？

## C++ 不兼容 C 的地方

C 可以用非 const 指针指向 const 变量，从而间接修改 const 变量。而 C++ 不允许。

## C++ 新增的东西

1. 几种数据类型：逻辑类型（C 中是用 `# define true 1`)、引用类型、类类型。
2. 使用 new 和 delete 进行内存释放
3. 函数重载
4. 默认形参
5. 内联函数（inline）
6. 引用相关知识
