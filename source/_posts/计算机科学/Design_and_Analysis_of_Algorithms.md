---
title: 算法设计
date: 2019-09-05 19:58:20
tags:
- 课程笔记
category:
- 计算机科学
mathjax: true
---

该篇博客为肖鸣宇老师所开的 *Design and Analysis of Algorithms* 课程的笔记。

## 绪论

### 算法解决的三种问题

1. Desicion Problem（判断是否）
2. Optimal（最优化的结果/解）
3. Numeric Calculation（数字计算、解方程）

### 问题的分类（按复杂度）

P: a solutuon can be solved in polynimoal time.
NP: a solution can be checked in polynomial time.
NPC: problems that may not have a polynomial-time algorithm.

![P NP NP-Complete NP-Hard](P_np_np-complete_np-hard.svg)

PTAS: Polynomial-time approximation scheme, an approximation algorithm

#### NPC 问题的求解

1. 启发式算法（Heuristic algorithm）：我觉得怎么好，就怎么做。不知道对不对，但是跑的确实快。例如：人工智能方面。
2. 近似算法（Approximation Algorithm）：在多项式时间内得到一个近似解。（难点在于证明近似）
3. 快速算法：高效的指数运行时间的精确算法。
4. 参数算法：参数小的时候，能高效解决问题。近年来兴起。

### 稳定婚姻问题 Stable Match / Stable marriage problem

给定 n 男 n 女，以及每个人对异性对象的喜好程度（按 1 至 n 排列）。安排男女结婚，使得不出现以下不稳定情形：

> 在 n 男 n 女中的存在两对夫妇 (M, W) 和 (m, w)，M 男对 w 女喜好度大于现任妻子 W 女，并且 w 女对 M 男喜好度也大于现任丈夫 m 男。

找到解、证明其符合题意、证明是否存在最优解都不是很显然。

#### 稳定室友问题 可能无解

若给 2n 个人，可以随意选择其他 2n-1 人。可能无解。如下图：

![stable roommate match](stable_roommate_match.png)

#### Gale-Shapley 算法

Gale-Shapley 算法，1962

```
Initialize each person to be free.
while (some man is free and hasn't proposed to every woman)
{
    Choose such a man m
    w = 1st woman on m's list to whom m has not yet proposed
    if (w is free)
        assign m and w to be engaged
    else if (w prefers m to her fiancé m')
        assign m and w to be engaged, and m' to be free
    else
        w rejects m
}
```

[Demo](stable_marriage_match_demo.ppsx)

##### 正确性证明：终止

注意到：

(1) 男生从高到低求婚，且对同一个女生只会求一次婚；
(2) 女生一脱单，不会重返单身；

因此，由 (1)，最多进行 $n^2$ 次匹配后，程序会终止。

##### 正确性证明：所有人都被匹配

**数学三大证明方法：反证、归纳、构造。**

**反证（By Contradiction）**：不妨设（**Suppose, for sake of contradiction, that**）结束时 Zeus 没有被匹配，由 (1)，他向所有女生求过婚。

* 则一定有女生没有被匹配，不妨设为 Amy；
* 由 (2)，Amy 从来没有被求过婚；
* 则 Amy 没有被 Zeus 求过婚；
* 由假设和上一条，推出矛盾。

##### 正确性证明：稳定性

反证：假设 A-Z 是不稳定对。则分情况讨论：

* 情况 1：Z 没有向 A 求过婚。则 Z 更喜欢当前的对象，与假设矛盾；
* 证明 2：Z 向 A 求过婚，而 A-Z 没有在一起，则 A 更喜欢当前的对象，与假设矛盾；

综上，假设不成立。

##### 思考

1. 如何用算法实现？时间复杂度？（用数组即可，时间复杂度 $O(n^2)$）
2. 如果有多种稳定匹配，GS 算法得到的是哪一种？

##### 多种稳定匹配情况——GS 男生最优，女生最劣

定义：如果存在一组稳定匹配，其中男生 m 为女生 w 配对，则定义他们为彼此的合法伴侣。  
结论：GS 算法得到的是男生的最优解，女生的最劣解（男生匹配到的伴侣是最优的合法伴侣，女生匹配到的伴侣是最劣的合法伴侣）。

证明 GS 算法得到的匹配 S* 是男生最优的（男生匹配到的伴侣是最优的合法伴侣）：（反证）

* 假设某男在 S* 中匹配到了不是最佳合法伴侣的伴侣。由于男生是以降序求婚，有男生被其最佳合法伴侣拒绝过。设第一个被最佳合法伴侣拒绝的男生为 Y，其最佳合法伴侣为 A。
* 设在另一个稳定匹配 S 中，女生 A 和男生 Y 在一起。
* 在 S* 中，女生 A 拒绝过男生 Y，则女生 A 一定和某男生（设为 Z）在一起了（女生拒绝男生的充要条件是女生和她更喜欢的男生在一起）。则可得女生 A 对男生的好感度中，Z > Y (3)。
* 设在 S 中，男生 Z 和某女生 B 在一起。
* 由于在 S* 中，男生 Y 是第一个被拒绝的，所以此时男生 Z 还没有被拒绝过。此时男生 Z 和女生 A 在一起了，所以男生 Z 还没有向女生 B 求过婚（否则 Z 需要先被 B 拒绝，才能和 A 在一起）。则男生 Z 的好感度中，A > B (4)。
* 在稳定匹配 S 中，A-Y 在一起，B-Z 在一起。而由 (3)(4)，A-Z 对彼此的好感度高于他们的当前伴侣 B(Y)，因此，推出匹配 S 是不稳定的，矛盾。

问题得证。

有意思的是，男生的最优是以女生的最劣为代价（在 GS 算法中，女生匹配到的伴侣是最劣的合法伴侣），这可以由男生最优这一结论简单的推出：

* 假设在稳定匹配 S* 中，女生 A 和 男生 Z 在一起。而女生 A 的最劣合法伴侣是某男生 Y。则女生 A 对男生的好感度中，Z > Y (5)。
* 设在稳定匹配 S 中，女生 A 和某男生 Y 在一起，男生 Z 和 女生 B 在一起。
* S\* 中 A-Z 在一起。由 S\* 中男生最优的结论，男生 Z 对女生的好感中，A > B (6)。
* 在稳定匹配 S 中，A-Y 在一起，B-Z 在一起。而由 (5)(6)，A-Z 对彼此的好感度高于他们的当前伴侣 B(Y)，因此，推出匹配 S 是不稳定的，矛盾。

问题得证。

#### 问题拓展：将病人安排在医院

没有做过多研究，仅作摘抄。

Men ≈ hospitals, Women ≈ med school residents

Variant 1. Some participants declare others as unacceptable. (resident A unwilling towork in Cleveland)
Variant 2. Unequal number of men and women.
Variant 3. Limited polygamy. (hospital X wants to hire 3 residents)

Def. Matching S unstable if there is a hospital h and resident r such that:

* h and r are acceptable to each other; and
* either r is unmatched, or r prefers h to her assigned hospital; and
* either h does not have all its places filled, or h prefers r to at least one of its assigned residents.

## 算法复杂度分析

渐进复杂度分析。

$O(g(n)), \omega(g(n)), \Theta(g(n))$ 这些都是函数的集合。为什么用 “$=$”而不用 "$\in$"，只能说是习惯。

主要是想说说另外两个非紧上界、下界。

$o(g(n)) = \\{ f(n) |$ 对于任何正常数 $c>0$，存在正数 $n_0>0$ 使得对所有 $n \geq n_0$ 有：$0 \leq f(n) < cg(n) \\}$  

$ \omega (g(n)) = \\{ f(n) |$ 对于任何正常数 $c>0$，存在正数 $n_0>0$ 使得对所有 $n \geq n_0$ 有：$0 \leq cg(n) < f(n) \\}$

和上面的区别就是这是对于任何 $c$ 都满足，因此必须要在数量级上*非紧*，才能使得对于任何 $c$ 都满足。

这还正是极限的定义：

$$ f(n) = o(g(n)) \space \Leftrightarrow \space \lim_{n \to \infty} \frac{f(n)}{g(n)} = 0 \space \Leftrightarrow \space g(n) = \omega (f(n))$$

传递性、对称性、反身性、互对称性、算术运算。

### 贪心算法
