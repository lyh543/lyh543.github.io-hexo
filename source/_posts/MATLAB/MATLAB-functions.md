---
title: MATLAB 函数
date: 2019-09-30 19:50:36
category:
- MATLAB
mathjax: true
---

收集一些好用的函数名，语法用时再查。

常用的可以看 MATLAB 教程书籍的附录。这里放一个整理的 [pdf](MATLAB函数速查手册.pdf)。

## 好用的函数收集
 
（从 xls  txt）读写表格：`xlsread`，`readmatrix`（MATLAB R2019a 起）。

映射、map：[`containers.Map`](https://ww2.mathworks.cn/help/matlab/matlab_prog/creating-a-map-object.html)。

分段函数：`piecewise`。

## 最优化

求函数最小值，有一堆工具箱函数~~不知道有什么区别~~：

|功能|函数名|注释|
|-|-|-|
|单变量优化|`fminbnd()`|求一元函数最小值|
|无约束优化|`fminsearch()`|使用无导数法计算最小值（类似梯度下降法）|
||`fminunc()`|计算无约束的多变量函数的最小值（牛顿法）|
|有约束优化|`fmincon()`|在有线性约束下计算最小值|
|线性规划|`linprog()`|解线性规划问题|
|整数规划|`intlinprog()`|解整数线性规划问题|
|[遗传算法](../genetic-algorithm#在-MATLAB-中调用遗传算法)|`ga()`|包含以上所有功能，不过精度较低

## 概率统计相关

功能|函数名|注释
-|-|-
正态概率函数|`normpdf(x)`
正态分布函数|`normcdf(x)`
|
`cftool`|曲线拟合工具箱
`distributionFitter`|分布拟合工具箱|

## 工具箱

命令|名称
-|-
`cftool`|曲线拟合工具箱
`distributionFitter`|分布拟合工具箱|相关知识还可见[MATLAB参数估计与假设检验-参数估计](https://blog.csdn.net/MATLAB_matlab/article/details/55802815)

## 统计函数

### 向量的元素和/矩阵的每列和/最值/均值

```MATLAB
cumsum(A) % 累积和/每列的累积和，即前缀和
sum(A)
min(A)
max(A)
mean(A)

[x, l] = min(A) % 顺便把最小值位置 index 给 l

sum(A,2) % 矩阵的每行和（平均数），2 是第二维
```

### 向量长度、矩阵大小

```MATLAB
length(V)
size(A) %返回一个1x2数组
```

### 列排序（返回数列、原数列元素在新数列的index）

```
[B I] = sort(V)
[B I] = sort(V,'descend') %降序
```

### find

很重要很重要！！

找到 v 中大于 0 元素的下标。

```matlab
idx=find(v>=0);
v(find(v>=0));
```
