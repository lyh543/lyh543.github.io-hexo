---
title: 遗传算法 和 MATLAB
date: 2019-09-23 21:13:10
tags:
- 课程笔记
- 遗传算法
category:
- MATLAB
mathjax: true
---

> 参考链接：如何通俗易懂地解释遗传算法？有什么例子？ - 严晟嘉的回答 - 知乎
> https://www.zhihu.com/question/23293449/answer/120220974

那就不多说了，仅说说自己更多的理解。

## 遗传算法原理

遗传算法的原理其实大家在初中生物就学过了，对你没看错，是生物书，就是那个达尔文的进化论。

> 我们希望有这样一个种群，它所包含的个体所对应的函数值都很接近于f(x)在[0,9]上的最大值，但是这个种群一开始可能不那么优秀，因为个体的染色体串是随机生成的。如何让种群变得优秀呢？
>
> 不断的**进化**。
> 每一次进化都尽可能保留种群中的优秀个体，**淘汰**掉不理想的个体，并且在优秀个体之间进行染色体**交叉**，有些个体还可能出现**变异**。

## 遗传算法的迭代过程

遗传算法其实就是模拟了进化的过程。大概流程如下：

1. 初始化种群，给他们一大堆随机的基因（将不同基因的种群布满所有地方）
2. 计算每个个体的适应度函数（生物学上来说就是判断它适不适应当前的环境，为优胜劣汰做准备。适应度函数即代表这个个体的优秀程度，如求函数 `f(x)` 最大值时，适应度函数即 `f(x)` 本身）
3. 对个体按适应度排序，这是为了后面选择做准备
4. 接下来准备培养后代，要进行选择（选择父母来繁衍后台）。可以采用轮盘赌选择方法（当然还有很多别的选择方法），各个个体被选中的概率与其适应度函数值大小成正比；也可以进行优胜劣汰，淘汰掉适应度低的个体，直接选前代最优的个体。
5. 选完以后，进行交叉，开始繁衍后代。
6. 还要考虑变异的可能。虽然变异概率小，但是在一个大种群里面，还是可能变异出更优秀的个体的。
7. 交叉变异完了，后代繁衍好了，至此，一轮迭代完成了。下一次迭代又会回到第二步。

实际运用中，我们会把所有基因映射到一个二进制串里，一是可以把多自变量映射为一个变量（即基因），二是方便进行基因交叉和变异。这个过程叫**编码**。

我们需要写解码公式（貌似不需要编码公式），这样才能计算适应度。具体怎么计算可以看转载来源（咕咕咕）。

## 在 MATLAB 中调用遗传算法

第一种调用方法，就是直接调用 `ga()` 函数。第二种是调用工具箱。

### ga() 函数

额[官方](https://www.mathworks.com/help/releases/R2019b/gads/ga.htm)没有汉化文档。

MATLAB 的 `ga()` 函数可以寻找函数在无约束或线性、非线性、整数约束下的**最小值**。

```matlab
x = ga(fun,nvars)
x = ga(fun,nvars,A,b)
x = ga(fun,nvars,A,b,Aeq,beq)
x = ga(fun,nvars,A,b,Aeq,beq,lb,ub)
x = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon)
x = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,options)
x = ga(fun,nvars,A,b,[],[],lb,ub,nonlcon,IntCon)
x = ga(fun,nvars,A,b,[],[],lb,ub,nonlcon,IntCon,options)
x = ga(problem)
[x,fval] = ga(___)
[x,fval,exitflag,output] = ga(___)
[x,fval,exitflag,output,population,scores] = ga(___)
```

额参数怎么这么多啊。一个一个说一下吧：

`problem` 应该是一个类，在此不表（还没学呢.jpg）。剩下的，

* `fun` 是一个函数句柄，如 `@(x)x^2` 或 `@myfun`
* `nvars` 是自变量的维数
* $A$ 和 $b$ 是自变量（称为 $x$，下同）的限制条件，满足 $A \cdot x \leq b$
* $A_{eq}$ 和 $b_{eq}$ 是 $x$ 的限制条件，满足 $A_{eq} \cdot x = b_{eq}$
* $lb$ 和 $ub$ 是 $x$ 的下界（lower bound）和下界（upper bound），满足 $lb \leq x \leq ub$
* `nonlcon` 意思是非线性限制条件（non-linear constraints）。在这里是一个函数句柄，接受变量 $x$，返回 $C(x)$ 和 $C_{eq}(x)$ 的函数值组成的向量，要求遗传算法在 $C(x) \leq 0 \wedge C_{eq}(x) = 0$ 的非线性范围下进行搜索。
* `IntCon`，整数限制，是一个元素取值从 1 到 `nvars` 的向量，要求 $x$ 的这些维度需要取整数。注意如果设了这一项，$A_{eq}$、$b_{eq}$、`nonlcon(2)` 需要设为空（整数规划不能和线性规划同时具备）。

上述 $A$、$b$、$A_{eq}$、$b_{eq}$、`nonIcon` 如果想要设为空，请使用 `[]`。

如果想要屏蔽输出 `Optimization terminated: ....`，要使用 `option` 参数：

```m
op=optimoption('ga');
op.Display=off;
```

更多细节还是看官网吧。

### 优化工具 Optimization Tool

网上有人说 `gatool`，但是这个工具在 R2015b 版本中被移除了。文档说，在之后的版本应该使用 `optimtool` 打开 Optimization App。  
但在 MATLAB 命令行中输入 `optimtool` 后，提示该工具也快要被移除了，现在建议 [Optimizing Without the App](https://ww2.mathworks.cn/help/optim/ug/optimization-app-alternatives.html) 了。。。行吧行吧。具体里面什么内容我也咕咕咕了。。。

但是不得不说，MATLAB nb！
