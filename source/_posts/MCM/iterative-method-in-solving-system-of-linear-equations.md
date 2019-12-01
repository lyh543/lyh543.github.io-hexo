---
title: 迭代法求解线性方程组
date: 2019-11-30 9:31:22
tags:
- 课程笔记
- 最优化
- 迭代法
category:
- 数学建模
mathjax: true
---

大一线代学的高斯消元法不适合高阶线性方程组。因此发展新的方法——迭代法。

## 迭代法的基本概念

设方程组 $Ax=f$ 有唯一解 $x^*$。将方程组变形为：

$$x=Bx+f$$

由此建立迭代公式：

$x^{(k+1)}=Bx^{(k)}+f \quad (k=0,1,2,...)$

再给定 $x^{(0)}$，即可得到近似解序列 $\{x^{(k)}\}$。

若 $\lim_{k\to\infty}x^{(k)}=x^\*$，有 $x^\*=Bx^\*+f$（$x^\*$为不动点），则称迭代法是收敛的，否则是发散的。

$B$ 称为迭代矩阵，$B$ 的取法不同，就是各种迭代法的区别。各种方法[是否收敛](#迭代的收敛性)？速度如何？如何进行误差估计？

迭代法适用于解**大型稀疏方程组**。

## 雅可比迭代法

最简单的方法是将每个方程组左边留一个变量，其他全部丢到右边，这就是一个最简单的迭代矩阵。

具体的来说，对于方程，

$$\sum_{j=1}^n a_{ij}x_j = b_i \quad (i=1,2,...,n)$$

迭代公式为：

$$x_i^{(k+1)} = \frac{1}{a_{ii}} [b_i - \sum_{j = 1}^{i-1}a_{ij}x_j^{(k)} - \sum_{j = i+1}^{n}a_{ij}x_j^{(k)}]$$

初始点任取，进行迭代即可。

不过呢，这玩意不一定收敛。


## 高斯——赛德尔迭代法

注意到，如果上面如果收敛，新值一般比旧值优秀。  
所以我们尽可能使用新的值，把第 $k+1$ 次迭代前面算出来的数用到该次迭代中（迭代表达式中只改了一个下标）：

$$x_i^{(k+1)} = \frac{1}{a_{ii}} [b_i - \sum_{j = 1}^{i-1}a_{ij}x_j^{(k+1)} - \sum_{j = i+1}^{n}a_{ij}x_j^{(k)}]$$

理论上，如果使用两个方法都收敛，高斯——赛德尔方法会略快于雅可比迭代。

## 雅可比迭代法的矩阵表示

将 $Ax=b$ 的 $A$ 分裂

$$ A= D - U -L $$
$$ D = \left[\begin{matrix}
a_{11} \\\\
& a_{22} \\\\
& & \ddots \\\\
& & & a_{nn}
\end{matrix}\right]
\quad
L = \left[\begin{matrix}
0 \\\\
a_{21} & 0 \\\\
\vdots & \ddots & \ddots \\\\
a_{n1} & \cdots & a_{n,n-1} & 0
\end{matrix}\right]
\quad
U = \left[\begin{matrix}
0 & a_{12} & \cdots & a_{1n} \\\\
& \ddots & \ddots & \vdots \\\\
&  & 0 & a_{n-1,n} \\\\
& &  & 0
\end{matrix}\right]
$$

有：

$$ AX = b \Rightarrow DX^{(k+1)} = (U+L)X^{(k)} + b \\\\
X^{(k+1)} = D^{-1}(U+L)X^{k} + D^{-1}b \\\\
$$

记

$$B_J=D^{-1}(U+L) \quad f_J=D^{-1}b \\\\
X^{(k+1)}=B_JX^{(k)}+f_J$$

$$\begin{aligned}
B_J &=\begin{bmatrix}
a_{11} &  &  &  \\\\
& a_{22} &  &  \\\\
&  & {\ddots} &  \\\\
&  &  & {a_{n n}}
\end{bmatrix}^{-1}
\begin{bmatrix}
{0} & {-a_{12}} & \cdots & {-a_{1 n}} \\\\
{-a_{21}} & {0} & \cdots & {-a_{2 n}} \\\\
\cdots & \cdots & \cdots & \cdots \\\\
{-a_{n 1}} & {-a_{n 2}} & \cdots & {0}
\end{bmatrix} \\\\
&=
\begin{bmatrix}
0 & -a_{12}/a_{11} & \cdots & -a_{1n}/a_{11} \\\\
-a_{21}/a_{22} & 0 & \cdots & -a_{2n}/a_{22} \\\\
\cdots & \cdots & \cdots & \cdots \\\\
-a_{n1}/a_{nn} & -a_{n2}/a_{nn} & \cdots & 0
\end{bmatrix}
\end{aligned}$$

$$f_J=D^{-1}b=\begin{bmatrix}
b_1/a_{11} \\\\
b_2/a_{22} \\\\
\cdots
b_n/a_nn
\end{bmatrix}$$

## 高斯-赛德尔迭代法的矩阵表示

高斯赛德尔的矩阵逆会复杂一点。

## 向量的收敛性

范数知识请看[范数简介](../non-linear-equation/#范数简介)

## 迭代的收敛性

得出结论：

$$ \lim_{k\to\infty}\varepsilon^{(k)} = \mathbf{0} \Leftrightarrow \lim_{k\to\infty} B^k = \mathbf{0}$$

结论非常漂亮，就是没法用（逃

于是出现了范数：

$$ \lim_{k\to\infty}\varepsilon^{(k)} = \mathbf{0} \Leftarrow  \\|B\\| < 1 $$

证明如下：

然而我们还是不知道当 $\\|B\\| \geq 1$ 时会发生什么。因此我们要推广

### 矩阵的谱

矩阵的谱 $\rm{ch}\\;B$ （或$\sigma(B)$）就是矩阵特征值的集合 $\\{\lambda_1, \lambda_2, ..., \lambda_n\\}$。

矩阵 $B$ 的谱半径 $\rho(B) = \max\limits_{1\leq k\leq n}|\lambda_k|$

结论啊啊啊啊

定理：

$$\lim_{k\to\infty}\varepsilon^{(k)} = \mathbf{0} \Leftrightarrow \rho(B)  < 1 $$

对于有些问题，雅可比不收敛、高斯——赛德尔收敛；也有前者收敛，后者不收敛。

啊啊啊代码

定理