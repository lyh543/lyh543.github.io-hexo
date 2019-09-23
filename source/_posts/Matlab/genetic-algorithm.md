---
title: 遗传算法
date: 2019-09-23 21:13:10
tags:
- 课程笔记
category:
- MATLAB
mathjax: true
---

## 概述

啦啦啦啦啦。

## 算法

### 按二进制生成随机数

要按二进制每一位、每一位的生成，这样才能保证二进制下的精度。

```m
function ret = randNum
a = 200; b = 500;
wid = b - a;
h = 0.00001;
num = wid / h;
Kbit = ceil(log(num)/log(2));
t1 = fix(2*rand(1,Kbit)); % Kbit 长度的 0-1 向量
dl = bin2dec(num2str(t1, '%d')); 
ret = dl / 2^Kbit * wid + a;
sprintf('%d', ret);
end
```
