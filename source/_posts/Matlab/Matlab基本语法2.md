---
title: Matlab基本语法2——矩阵运算
tags:
category:
- Matlab
mathjax: true
---

[学习目录](../Matlab学习目录)

## 列向量之和

```matlab
>> A = [2 2; 5 8]

    2 2
    5 8

>> sum(A)

    7 10
```

## 矩阵除法

```matlab
>> A\B
>> B/A
%% (当A为方阵）等价于A^(-1)*B
```

## 对应元相乘、相除（求幂）

```matlab
>> A.*A
>> A./B
>> A.\B
>> A.^B
>> A.^4
```

## A的转置

```matlab
>> A'

    2 5
    2 8
```

## 逆矩阵

```matlab
>> inv(a)

    1.3333 -0.3333
    -0.8333 0.3333
```

## 取对角

```matlab
>> diag(A)

    2
    8

>> ans

    2
    8
```

## 左右翻转

```matlab
>> fliplr(A)

    2 2
    8 5
```

## 将增广矩阵化为简化为阶梯形

```matlab
>> reff(A)

    1 0
    0 1
```

## 特征值、特征向量

```matlab
>> [V,D] = eig(A)
```

$$V^{-1} \cdot D \cdot V = A$$  
即$D$的对角线是特征值
