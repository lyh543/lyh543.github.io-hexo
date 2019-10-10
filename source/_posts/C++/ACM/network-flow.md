---
title: 网络流
date: 2019-10-4
tags:
- 图论
- 搜索
category:
- C++
- ACM
---

在 ACM 中第一次听到网络流，但是还没认真学就被迫退役了。（菜的真实）

第二次是在肖老师的 [算法设计与分析](/计算机科学/Design_and_Analysis_of_Algorithms#网络流) 课程上，大概了解了网络流的思想。

## 定义

### 流网络

流网络（flow network）是一种带权有向图，但是有一个源点（source）和一个汇点（sink），每个权叫做该边的容量（capacity）$c(e)$。如下图。

![Flow Network](flow_network.png)

### 流

流是一个比较形象的概念，好比每个有向边都是一根管道，权重代表这根管道能流多少水。

但是要想用数学定义下来，还是比较麻烦。

> s-t 流是一个满足以下条件的函数：
> 1. 对于图中任意一边 e，有 $0 \leq f(e) \leq c(e)$
> 2. 对于图中任意一点 v，有 $\sum_\text{e in to v}f(e) = \sum_\text{e out of v}f(e)$

流的价值： $v(f) = \sum_\text{e out of s}f(e)$。  

最大流即为最大价值的流。

下图的一个流为 24。（但最大流为 28，从上往下流进 t 点的流量为 9、9、10，请读者自己思考这是如何达到的）

![流](flow.png)

### 割

然后我们要引入
s-t 割，就是把图分为 A、B两块的一种方法，要满足 A 块有 s，B 块有 t。

并定义 A-B 割的容量为流出 A 块的所有容量之和，最小割即指容量最小的割：

$$cap(A, B) = \sum_\text{e out of A} c(e)$$

![Cut](cut.png)

## 最大流等于最小割

接下来我们要证明：一个图中，最大流等于最小割。

$$\sum_\text{e out of A} {f(e)}  - \sum_\text{e in to A} {f(e)}   =  v(f)$$

证明：

\begin{equation}
\begin{split}
v(f) &= \sum_\text{e out of s}f(e) \qquad (流的定义) \\\\
&= \sum_{v \in A}\bigg(\sum_\text{e out of v}f(e) - \sum_\text{e in to v}f(e)\bigg) \qquad(加了一堆为值 0 的表达式) \\\\
&= \sum_\text{e out of A}f(e) - \sum_\text{e in to A}f(e) \qquad(意会一下块的流的定义)\\\\.
\end{split}
\end{equation}

由上面的结果，我们可以继续往下推得：对于某个图中的任意流 f 和任意 (A,B) 割，有：$v(f) \leq cap(A,B)$。  
证明：

\begin{equation}
\begin{split}
v(f) &= \sum_\text{e out of A}f(e) - \sum_\text{e in to A}f(e) \\\\
&\leq \sum_\text{e out of A}f(e) \\\\
&\leq \sum_\text{e out of A}c(e) \\\\
&=cap(A,B).
\end{split}
\end{equation}

那么显然地，对于一个流网络，如果找到一个流 f 和 cap(A,B)，有 $v(f)=cap(A,B)$，那么 f 就一定是最大流，且 (A,B) 是最小割。

到这里，貌似还没有证明最大流等于最小割，因为我们不知道是不是一定有 $v(f)=cap(A,B)$。  
我们后面会提到 Ford-Fulkerson 算法，对于这个算法返回的流，我们可以构造一个 s-t 割使得该割等于算法返回的流，即完成了证明。

## 最大流算法

### 贪心算法 

最容易想到的是先用贪心跑一下。贪心算法如下：

1. 刚开始设所有边的 f(e)=0；
2. 找到任意一条从 s 连向 t，且每条边都还没有流满（即 $f(e) < c(e)$）的路径 P。增大该路径每条边上的流；
3. 反复执行上步操作直到流不动了。

贪心在一些图上确实有很好的表现，但是很容易构造出贪心不是最优解的情况，如下：

![贪心算法](greedy.jpg)

造成这个的问题是，可能会先选到一条不好的边，导致某个瓶颈满了，其他边无法继续流。

于是就想到了一种可以把已经被占满的边撤销、改回来的方法，叫剩余图(Residual graph)。

### 剩余图

原图中的每一条边 e 都有 $c(e)$ 和 $f(e)$。

对于原图的每一条边，我们在一个新的图中都定义两条相互反向的边，把他命名叫剩余边（Residual edge）。

定义剩余边的权重（剩余容量，Residual capacity）：我们把与原图的边同向的边的剩余容量设为原边还能流的量 $c(e)-f(e)$，把反向的边设为原边已经流过的量 $f(e)$。

$c_f(e)=\begin{cases}
c(e) - f(e) & if \\ e \in E \\\\
f(e) & if \\ e^R \in E
\end{cases}$

刚才的新图便叫做剩余图（又叫残余网络，Residual graph）。

![剩余图](Residual-Graph.jpg)

### Ford-Fulkerson 算法

良心的肖老师也提供了[演示 PPT](demo-maxflow.ppsx)。

### 增广路算法

## 后记

最大流问题中还有一个经典的问题: 最小费用最大流问题。请大家自学。
对于求最大流的算法, 在实践中往往使用效率更高的 **`Dinic`** 算法或 **`ISAP`** 算法（参考《算法竞赛入门经典-训练指南》)。
**对于竞赛来说, 实际更重要的在于网络流模型的建立, 这时把网络流算法作为模板来使用就可以了。**
