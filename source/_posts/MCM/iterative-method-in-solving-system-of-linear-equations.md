---
title: 迭代法求解线性方程组
date: 2019-11-30 9:31:22
tags:
- 课程笔记
- 最优化
- 迭代法
- 数学建模
category:
- 数学建模
mathjax: true
---

大一线代学的高斯消元法不适合高阶线性方程组。因此发展新的方法——迭代法。

## 迭代法的基本概念

设方程组 $Ax=f$ 有唯一解 $x^*$。可将方程组变形为：

$$x=Bx+f$$

由此建立迭代公式：

$$x^{(k+1)}=Bx^{(k)}+f \quad (k=0,1,2,...)$$

再给定 $x^{(0)}$，即可得到近似解序列 $\{x^{(k)}\}$。

若 $\lim\limits_{k\to\infty}x^{(k)}=x^\*$，有 $x^\*=Bx^\*+f$（$x^\*$为不动点），则称迭代法是收敛的，否则是发散的。

$B$ 称为迭代矩阵，$B$ 的取法不同，就是各种迭代法的区别。各种方法[是否收敛](#迭代的收敛性)？速度如何？如何进行误差估计？这就是我们要研究的问题。

迭代法适用于解**大型稀疏方程组**。

## 雅可比迭代法

最简单的方法是将每个方程组左边留一个变量，其他全部丢到右边，这就是一个最简单的迭代矩阵。

具体的来说，对于方程组中第 $i$ 个方程，

$$\sum_{j=1}^n a_{ij}x_j = b_i \quad (i=1,2,...,n)$$

我们把 $a_{ii} x_i$ 留在左边，其他丢到右边，再两边同时除以 $a_{ii}$，得到迭代公式为：

$$x_i^{(k+1)} = \frac{1}{a_{ii}} [b_i - \sum_{j = 1}^{i-1}a_{ij}x_j^{(k)} - \sum_{j = i+1}^{n}a_{ij}x_j^{(k)}]$$

（迭代公式中后面两项其实可以合并为一个求和符号，但是这里分开写，是为了给后面做铺垫）

初始点任取，进行迭代即可。

不过呢，这玩意不一定收敛。


## 高斯——赛德尔迭代法

注意到，如果上面如果收敛，一般来说，新值比旧值优秀。  
所以我们尽可能使用新的值，把第 $k+1$ 次迭代前面算出来的数用到该次迭代中（迭代表达式中只改了一个上标）：

$$x_i^{(k+1)} = \frac{1}{a_{ii}} [b_i - \sum_{j = 1}^{i-1}a_{ij}x_j^{(k+1)} - \sum_{j = i+1}^{n}a_{ij}x_j^{(k)}]$$

理论上，如果使用两个方法都收敛，高斯——赛德尔方法会略快于雅可比迭代。

## 雅可比迭代法的矩阵表示

（这一段的公式也太长了叭）

将 $Ax=b$ 的 $A$ 分裂

$$ A= D - U -L $$
$$ D = \left[\begin{matrix}
a_{11} \\\\
& a_{22} \\\\
& & \ddots \\\\
& & & a_{nn}
\end{matrix}\right]
\quad
L = -\left[\begin{matrix}
0 \\\\
a_{21} & 0 \\\\
\vdots & \ddots & \ddots \\\\
a_{n1} & \cdots & a_{n,n-1} & 0
\end{matrix}\right]
\quad
U = -\left[\begin{matrix}
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

$$B_J=D^{-1}(U+L) \qquad f_J=D^{-1}b \\\\
X^{(k+1)}=B_JX^{(k)}+f_J$$

进一步计算 $B_J$ 和 $f_J$：

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
\vdots \\\\
b_n/a_{nn}
\end{bmatrix}$$

## 高斯-赛德尔迭代法的矩阵表示

高斯-赛德尔的矩阵会复杂一点，因为上面方法被求逆的矩阵是一个对角矩阵，而这里是一个下三角矩阵。

$$
(D-L)X^{(k+1)} = UX^{(k)} + b \\\\
X^{(k+1)} = (D-L)^{-1}UX^{k} + (D-L)^{-1}b
$$

记

$$B_{G-S}=(D-L)^{-1}U \qquad f_{G-S}=(D-L)^{-1}b \\\\
X^{(k+1)}=B_{G-S}X^{(k)}+f_{G-S}$$

进一步计算 $B_{G-S}$ 和 $f_{G-S}$ 有（其实没有必要往下写了）：

$$
B_{G-S} =\begin{bmatrix}
a_{11} &  &  &  \\\\
a_{21} & a_{22} &  &  \\\\
{\vdots} & {\vdots} & {\ddots} &  \\\\
a_{n1} & a_{n2} & {\cdots} & {a_{n n}}
\end{bmatrix}^{-1}
\begin{bmatrix}
{0} & {a_{12}} & \cdots & {a_{1 n}} \\\\
& {0} & \ddots & {a_{2 n}} \\\\
&  & \ddots & \vdots \\\\
&  &  & {0}
\end{bmatrix}$$

$$f_J=D^{-1}b=
\begin{bmatrix}
a_{11} &  &  &  \\\\
a_{21} & a_{22} &  &  \\\\
{\vdots} & {\vdots} & {\ddots} &  \\\\
a_{n1} & a_{n2} & {\cdots} & {a_{n n}}
\end{bmatrix}^{-1}
\begin{bmatrix}
b_1 \\\\
b_2 \\\\
\vdots \\\\
b_n
\end{bmatrix}$$

## 向量的收敛性

范数知识请看[范数简介](../non-linear-equation/#范数简介)

## 迭代的收敛性

在[基本概念](#迭代法的基本概念)中提到，迭代即是

$$
\lim_{k \to \infty}X^{(k)} = X^* 
\Leftrightarrow
\lim_{k \to \infty}\\| X^{(k)} - X^* \\|_2 = 0
$$

令 $\varepsilon^{(k)} = X^{(k)} - X^*$，则上述结论可以写为

$$
\lim_{k \to \infty}X^{(k)} = X^* 
\Leftrightarrow
\lim_{k \to \infty}\\| \varepsilon^{(k)} \\|_2 = 0
$$

（利用向量范数的等价性，我们还可以进一步推出上述结论对任意范数同样成立）

接下来，我么换一个角度，看从迭代法的定义还能推出什么关于 $\varepsilon^{(k)}$ 的结论：

$$
X^{(k+1)}=BX^{(k)}+f \quad (k=0,1,2,...) \\\\
X^* = BX^* + f \\\\
X^{(k+1)} - X^* = B(X^{(k)}-X^*)
$$

则有：

$$
\varepsilon^{(k)} = B \varepsilon^{(k-1)} \quad (k=1,2,3,...)
$$

递推一下，

$$\varepsilon^{(k)} = B \varepsilon^{(k-1)} = B^2 \varepsilon^{(k-2)} = \cdots = B^k \varepsilon^{(0)}
$$

得出结论：

$$ \lim_{k\to\infty}\varepsilon^{(k)} = \mathbf{0} \Leftrightarrow \lim_{k\to\infty} B^k = \mathbf{0}$$

结论非常漂亮，就是没法用（逃

于是出现了范数：

$$ \lim_{k\to\infty}\varepsilon^{(k)} = \mathbf{0} \Leftarrow  \\|B\\| < 1 $$

证明如下：

由 $\varepsilon^{(k)} = B \varepsilon^{(k-1)}$ 和[范数的相容性](../non-linear-equation/#矩阵范数的相容性)，有

$$
\\| \varepsilon^{(k)} \\| \leq \\|B \\| \\| \varepsilon^{(k-1)} \\| \\\\
\\| \varepsilon^{(k)} \\| \leq \\|B \\|^k \\| \varepsilon^{(0)} \\|
$$

由于 $\\|B \\| < 1$，

$$\lim_{k \to \infty} \\| \varepsilon^{(k)} \\|
\leq
\lim_{k \to \infty} \\|B \\|^k \\| \varepsilon^{(0)} \\|
= 0$$

所以有 $\lim_{k\to\infty}\varepsilon^{(k)} = \mathbf{0}$。

然而我们还是不知道当 $\\|B\\| \geq 1$ 时会发生什么。因此我们要进行推广：

## 矩阵的谱

> 定义 矩阵的谱 $\rm{ch}\\;B$ （或$\sigma(B)$）就是矩阵特征值的集合 $\\{\lambda_1, \lambda_2, ..., \lambda_n\\}$。

> 定义 矩阵 $B$ 的谱半径 $\rho(B) = \max\limits_{1\leq k\leq n}|\lambda_k|$

那么，关于在 [范数的相容性](../non-linear-equation/#矩阵范数的相容性) 中提到的最大特征值的结论都可以套过来：

> 结论 1：当 $B$ 是对称矩阵时，$\\|B\\|_2 = \rho(B)$  
> 结论 2：对于任意范数都有：$\rho(B) \leq \\|B\\|_2$

定理：

$$\lim_{k\to\infty}\varepsilon^{(k)} = \mathbf{0} \Leftrightarrow \rho(B)  < 1 $$

这里就是充要条件了。

对于有些问题，雅可比不收敛、高斯——赛德尔收敛；也有前者收敛，后者不收敛。

套用雅可比和高斯——赛德尔方法中的 $B$ 的结果，可以得到判断该方法是否收敛的算法：

```m
% 雅可比迭代法 B=D\(U+L)
D=diag(diag(A1));
B=D\(D-A);
max(abs(eig(B1))); % 值小于 1 则收敛，大于 1 则不收敛
```

```m
% 高斯——赛德尔迭代法 B=(D-L)\U
DL=tril(A1);
B1=DL\(DL-A1);
max(abs(eig(B1))); % 值小于 1 则收敛，大于 1 则不收敛
```

定理：设 $X^\*$ 是方程组 $AX=b$ 的解，迭代形式为：$X^{(k+1)}=BX^{(k)}+f$。若 $\\|B\\| < 1$，则有：
* $$\\| X^{(k)} - X^\* \\| \leq \frac{\\|B\\|}{1-\\|B\\|} \\|X^{(k)} - X^{(k-1)}\\|$$ 
* $$\\| X^{(k)} - X^\* \\| \leq \frac{\\|B\\|^k}{1-\\|B\\|} \\|X^{(1)} - X^{(0)}\\|$$

PPT 上给了第一条的证明，但是太硬核了（给刚接触范数的同学看这些真的看得懂吗），如果需要的话，再来翻 PPT 重学吧。  

至于第二条，真的不懂了（逃