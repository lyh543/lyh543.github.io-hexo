---
title: MATLAB 函数
date: 2019-09-30 19:50:36
tags:
- MATLAB
- 最优化
category:
- MATLAB
mathjax: true
---

收集一些好用的函数名，具体语法等用时再查文档。

常用的可以看 MATLAB 教程书籍的附录。这里放一个整理的 [pdf](MATLAB函数速查手册.pdf)。

## 好用的函数收集
 
（从 xls  txt）读写表格：`xlsread`，`readmatrix`（MATLAB R2019a 起）。

映射、map：[`containers.Map`](https://ww2.mathworks.cn/help/matlab/matlab_prog/creating-a-map-object.html)。

分段函数：`piecewise`。

## 最优化相关

求函数最小值，有一堆工具箱函数~~不知道有什么区别，可能使用的算法不同~~：

|功能|函数名|注释|
|-|-|-|
|单变量优化|`fminbnd()`|求一元函数最小值|
|无约束优化|`fminsearch()`|使用无导数法计算最小值|使用 Lagarias 等的单纯形搜索法
||`fminunc()`|计算无约束的多变量函数的最小值|使用牛顿法和（梯度法？）
|有约束优化|`fmincon()`|在有线性约束下计算最小值|
|线性规划|`linprog()`|解线性规划问题|双单纯形法或 `interior-point algorithm`
|整数规划|`intlinprog()`|解整数线性规划问题|
|[遗传算法](../genetic-algorithm#在-MATLAB-中调用遗传算法)|`ga()`|包含以上所有功能，不过精度较低

### 基于问题的最优化

最优化相关的基于问题的方法 `Problem-Based Approach`：

```m
x = optimvar('x',2,'LowerBound',0);
xb = optimvar('xb','LowerBound',0,'UpperBound',1,'Type','integer');
prob = optimproblem('Objective',-3*x(1)-2*x(2)-xb);
cons1 = sum(x) + xb <= 7;
cons2 = 4*x(1) + 2*x(2) + xb == 12;
prob.Constraints.cons1 = cons1;
prob.Constraints.cons2 = cons2;

% Convert the problem object to a problem structure.
problem = prob2struct(prob);

% Set Options
problem.options = optimoptions('intlinprog','Display',"off");

% Solve the resulting problem structure.
[sol,fval,exitflag,output] = intlinprog(problem)
```

说白了，就是 `prob2struct` 函数能够将 `4*x(1) + 2*x(2) + xb == 12` 这样的直白的优化式子和约束条件，换为 `intlinprog` 的 `Aeq` `beq`。  
如果使用传统的方式，这一步转化需要人工完成。  
对于复杂的问题，这样更不容易出错。

跑出来的 `sol` 是一个 1*3 向量，那么 `x` 和 `xb` 对应哪些变量呢？

可以使用 `varindex`：

```m
>> varindex(prob)

ans = 

  包含以下字段的 struct:

    x: [1 2]
    xb: 3
```

就可以看出对应关系了。

更多相关资料可查看 [Problem-Based Optimization Setup - MATLAB & Simulink](https://www.mathworks.com/help/optim/problem-based-approach.html)

## 概率统计相关

功能|函数名|注释
-|-|-
正态概率函数|`normpdf`|pdf: Probability Density Function
正态分布函数|`normcdf`|cdf: Cumulative Density Function
正态下侧分位数|`norminv(p)`|返回 $x$ 满足 $\varPhi(x)=p$
按正态分布生成随机数|`normrnd`
|
上述函数的卡方分布版本|将四个函数的 `norm` 改为 `chi2`|很香
上述函数的均匀分布版本|将四个函数的 `norm` 改为 `unif`|
上述函数的指数分布版本|将四个函数的 `norm` 改为 `exp`|
|
正态分布拟合|`normfit`|使用 Wald 检验
|
曲线拟合工具箱|`cftool`|
分布拟合工具箱|`distributionFitter`|

## 工具箱函数

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

## 图论

命令名|作用
-|-
`graphallshortestpaths`|求图中所有顶点对之间的最短距离
`graphconncomp`|找无向图的连通分支，或有向图的强弱连通分支
`graphisdag`|测试有向图是否含有圈，不含圈返回1，否则返回0
`graphisomorphism`|确定两个图是否同构，同构返回1，否则返回0
`graphisspantree`|确定一个图是否是生成树，是返回1，否则返回0
`graphmaxflow`|计算有向图的最大流
`graphminspantree`|在图中找最小生成树
`graphpred2path`|把前驱顶点序列变成路径的顶点序列
`graphshortestpath`|求图中指定的一对顶点间的最短距离和最短路径
`graphtopootder`|执行有向无圈图的拓扑排序
`graphtraverse`|求从一顶点出发，所能遍历图中的顶点

## 绘图

见[绘图](../MATLAB-plot)。

## 符号编程

见[符号编程](../MATLAB-syms)。

## 图片处理

* 读取：`pic = imread('a.bmp')`
* 显示：`imshow(pic)`