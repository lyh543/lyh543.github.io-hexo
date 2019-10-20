---
title: vector
date: 2019-7-25
tags:
- STL
category:
- C++
- C++语法
mathjax: true
---

本文写一写 vector 冷门但是可能有用的功能。

## swap

vector 有一个成员函数叫 `swap`。这个 `swap` 是做什么的？

在 [cppreference](https://zh.cppreference.com/w/cpp/container/vector/swap) 上提到，该函数可以和另一个 vector 进行交换，时间复杂度为 $O(1)$。貌似只是换一下指向数组的位置，但是可以用于滚动数组，不用再 `%2` 和 `(cur+1)%2` 啦。
