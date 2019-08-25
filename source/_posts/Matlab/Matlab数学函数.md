---
title: Matlab数学函数
tags:
category:
- Matlab
mathjax: true
---

[学习目录](../Matlab学习目录)

## 向量的元素和/矩阵的每列和

```matlab
sum(A)
min(A)
max(A)
mean(A)

% 顺便把最小值位置给l
[x, l] = min(A)

% 矩阵的每行和/平均数
sum(A,2)
```

## 向量长度、矩阵大小

```matlab
length(V)
size(A) %返回一个1x2数组
```

## 列排序（返回数列、原数列元素在新数列的index）

```
[B I] = sort(V)
[B I] = sort(V,'descend') %降序
```

## find

很重要很重要！！~~但是没有学过去~~

Index=find(A>3)
