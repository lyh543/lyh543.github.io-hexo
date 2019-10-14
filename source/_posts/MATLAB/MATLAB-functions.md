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

* `fminbnd()` 求一元函数极值
* `fminsearch()` 使用无导数法计算无约束多变量函数的最小值（梯度下降法）
* `fminunc()` 计算无约束的多变量函数的最小值（牛顿法）
* `fmincon()` 计算有约束的多变量函数的最小值
* `linprog()` 解线性规划问题
* `intlinprog()` 解整数线性规划问题

* `ga()` ([遗传算法](../genetic-algorithm#在-MATLAB-中调用遗传算法)). 

## 统计函数

### 向量的元素和/矩阵的每列和

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
