---
title: 字符串 hash（坑）
tags:
- 字符串
category:
- C++
- ACM
---

在竞赛中的hash一般使用除留余数法

它的主要思路是把字符串中的字符看成一个（k进制）大数字中的每一位数字，然后选择一个足够大的质数p让得到的大数对p取余数。得到的余数就是我们需要的特征值。

`Hash(s)=Σ(s[i]*k^i) mod p`

**不要把a映射到0**!!!!
k可以选择27、233都可以。
p最好是一个大质数，不要和2的整数幂接近
防止hash冲突可以使用双hash或拉链法

[博客](
https://blog.csdn.net/pengwill97/article/details/80879387)
