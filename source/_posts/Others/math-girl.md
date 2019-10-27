---
title: 《数学女孩》笔记
date: 2018-07-01
tags:
- 读书笔记
category:
- Others
mathjax: true
---

> 《数学女孩》系列以小说的形式展开，重点描述一群年轻人探寻数学中的美。内容由浅入深，数学讲解部分十分精妙，被称为“绝赞的数学科普书”。

—— [图灵新知](http://www.ituring.com.cn/book/2617)

## 学习和研究的不同

> 我有时候在想，学习和研究到底有何不同呢?  
> 数学课上，只要读读教科书上写着的内容，然后记住公式， 再用记住的公式解开问题，对一下答案就结束了。  
> 然而我认为，研究是去探求“未知的答案”， 是向答案逼近的一个过程。 因为不知道答案才会有趣。 从自己找寻、发现答案的过程中， 才能感受到研究的魅力所在。  —— 山本裕子  

——《数学女孩2》

## Q. E. D.

> Q.E.D. 是拉丁片语  Quod  Erat Demonstrandum（意思是“这就是所要证明的”）的缩写。这句拉丁片语译自希腊语，包括欧几里得和阿基米德在内的很多早期数学家都用过。

——《数学女孩 3：哥德尔不完备定理》

## 碰上前所未有的概念

> 出错了、不合逻辑  ——  之所以会陷入这种泥潭，是因为碰上了前所未有的概念。  
> 我们可以认为自己失败了，然后折返。  
> 不过，我们也可以认为这是一个新的发现，然后继续前进。

——《数学女孩 3：哥德尔不完备定理》

## 微积分中的 $n!$ —— 斯特林公式

> 斯特林公式用于评估 $n!$ 的近似值。它的精度非常高，即使 $n$ 很小，其取值也十分精确。斯特林公式的典型形式是
> $$ln \space n! = nln \space n - n + O(log \space n)$$
> 更精确的形式是
> $$n! \sim \sqrt{2 \pi n}(\begin{smallmatrix}n\\\\e\end{smallmatrix})^n$$

由斯特林公式可以得到 $ln \space n! = \Omega (nlog \space n)$。

## “幸福的台阶”——一直掷 6 面骰子，直到掷出过所有面，掷骰子的期望次数

出现于《数学女孩 4》。

### 分解为子问题——“上台阶”

可以把丢出一个新数字看作上一个台阶，原事件等价于上六次台阶。

设“掷出所有点数时，掷骰子的次数”为 $X$。又设“掷出 $j$ 种点数以后，直至丢出没出过的点数时，掷骰子的次数”为 $X_j$。显然有：

\begin{equation}
\begin{split}
X &= X_0 + X_1 + X_2 + X_3 + X_4 + X_5 \\\\
E[X] &= E[X_0] + E[X_1] + E[X_2] + E[X_3] + E[X_4] + E[X_5]
\end{split}
\end{equation}

### 研究子问题——“上一次台阶”的期望次数

现在讨论 $E[X_i]$。显然，$E[X_0] = 1$。

掷一次骰子有两种情况：掷出没有出现过的点数、掷出已经出现的点数。对于已经出现过 $j$ 个点的情况，记

\begin{equation}
\begin{split}
p_j &= P \\{ 掷出没有出现过的点数 \\} = 1 - \frac{j}{6} \\\\
q_j &= P \\{ 掷出出现过的点数 \\} = \frac{j}{6}
\end{split}
\end{equation}

那么，$X_j$ 可以被视为丢概率不同的硬币，丢出一次正面的期望丢硬币次数（非常漂亮的转化）。

要计算 $E(X_j)$，我们就分别计算 $P(X_j = k)$。貌似不可直接列表算，但是可以**取极限**（出现了，微积分！）。有

\begin{equation}
\begin{split}
P(X_j = k) &= q_j^{k-1} \cdot p_j \\\\
           &= q_j^{k-1} \cdot (1- q_j) \\\\
           &= q_j^{k-1} - q_j^k
\end{split}
\end{equation}

则

\begin{equation}
\begin{split}
E[X_j] &= \sum_{k=1}^{\infty} k \cdot P(X_j = k) \\\\
       &= \lim_{n \to \infty} \sum_{k=1}^{n} k \cdot P(X_j = k) \\\\
       &= \lim_{n \to \infty} \sum_{k=1}^{n} k (q_j^{k-1} - q_j^k) \\\\
       &= \lim_{n \to \infty} ( 1 \cdot (q_j^0 - q_j^1) + 2 \cdot (q_j^1 - q_j^2) + \cdots n \cdot (q_j^{n-1} - q_j^n)) \\\\
       &= \lim_{n \to \infty} ( 1 + q_j^1 + q_j^2 + \cdots q_j^{n-1} - n \cdot q_j^n) \\\\
       &= \lim_{n \to \infty} \bigg( \frac{1-q_j^n}{1-q_j} - n \cdot q_j^n \bigg) \\\\
       &= \lim_{n \to \infty} \bigg[ \frac{1- (\frac{j}{6})^n}{1-\frac{j}{6}} - n \cdot (\frac{j}{6})^n \bigg] \\\\
       &= \frac{1}{1-\frac{j}{6}} \\\\
       &= \frac{6}{6-j}
\end{split}
\end{equation}

### 回到原问题

结果就比较显然了。

\begin{equation}
\begin{split}
E[X] &= E[X_0] + E[X_1] + E[X_2] + E[X_3] + E[X_4] + E[X_5] \\\\
     &= \frac{6}{6} + \frac{6}{5} + \frac{6}{4} + \frac{6}{3} + \frac{6}{2} + \frac{6}{1} \\\\
     &= 6H_6 \\\\
     &\approx 14.7
\end{split}
\end{equation}

其中 $$H_n = \sum_{i=1}^{n} \frac{1}{i}$$ 为调和级数。

该问题还有通用结论：

> 一直掷 $n$ 面骰子，直到掷出过所有面，掷骰子的期望次数为
> $$n \cdot H_n = n \cdot \sum_{i=1}^{n} \frac{1}{i}$$.

## 哈密尔顿–凯莱定理

线代相关。~~然而线代忘完了~~
https://zh.wikipedia.org/wiki/%E5%87%B1%E8%90%8A%E2%80%93%E5%93%88%E5%AF%86%E9%A0%93%E5%AE%9A%E7%90%86

对于二次来说，对于矩阵 A，有：

$$A^2 = tr(A) \cdot A + |A| \cdot I$$
