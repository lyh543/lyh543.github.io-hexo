---
title: 数值分析中的数据处理方法
date: 2019-11-25 19:47:54
tags:
- 课程笔记
- 数值分析
- 数学建模
- MATLAB
category:
- MATLAB
mathjax: true
---


## 插值

变量之中存在的函数关系，有时不能确定，而是通过获得的数据来找出两个变量间可能存在的连续。

这东西和拟合有点像。

已知 $f(x)$ 的很多点 $(x\_i, y\_i)$，要找一个函数 $P(x) \approx f(x)$。

这里使用的是多段分段函数进行近似。

常用的方法有：线性插值 `linear`、三次样条插值 `spline`、三次插值 `cubic`。推荐使用三次样条插值。

MATLAB 函数：`y_new = interp1(x,y,x_new,option)`

```m
x = linspace(0,2*pi,10);
y = sin(x);

x_new = linspace(0,2*pi,1000);
y_new = interp1(x,y,x_new,'spline');

plot(x,y,'o',x_new,y_new,'r-');
```

二维插值。这里不能使用 `interp2` 而需要使用 `griddata`，Google 了一下：

> 二者均是常用的二维差值方法，两者的区别是，`interp2` 的插值数据必须是矩形域，即已知数据点 `(x,y)` 组成规则的矩阵，或称之为栅格，可使用 `meshgrid` 生成。而 `griddata` 函数的已知数据点 `(x,y)` 不要求规则排列，特别是对试验中随机没有规律采取的数据进行插值具有很好的效果。
> `griddata(X,Y,XI,YI,'v4')` `v4`是一种插值算法，没有具体的名字，原文称为“MATLAB 4 griddatamethod”，是一种很圆滑的插值算法，效果不错。X 和 Y 提供的已知数据点，XI 和 YI是需要插值的数据点，一般使用 `meshgrid` 生成，当然也可以其他数据，但是那样绘图的时候就比较麻烦，不能使用 `mesh` 等，只能使用 `trimesh`。

```m
X=[129.0  140.5  103.5  88.0  185.5  195.0  105.5 ...
   157.5  107.5   77.0  81.0  162.0  162.0  117.5];
Y=[  7.5  141.5   23.0  147.0  22.5  137.5   85.5 ...
    -6.5  -81.0    3.0   56.5 -66.5   84.0  -33.5];
Z=[  4      8      6      8     6      8      8 ...
     9      9      8      8     9      4      9 ];

% 船的吃水深度为5英尺。
%在矩形区域（75，200）×（-50，150）
% 内的哪些地方船要避免进入。
xp = linspace(75,200,50);
yp = linspace(-50,150,50);
[xq,yq]=meshgrid(xp,yp);
vq = griddata(X,Y,Z,xq,yq,'cubic')
mesh(xq,yq,vq)
hold on
plot3(X,Y,Z,'O','markersize',14)
```

## 拟合

## 数值微分

微分其实用的不多。常用于[解微分方程](../differential-equation)。

前面两个差商比较垃圾，但是处理端点好用：

一阶前向差商（左端点） $f'(a)=\frac{f(a+h)-f(a)}{h}+O(h)$

一阶后向差商（右端点） $f'(a)=\frac{f(a)-f(a-h)}{h}+O(h)$

一阶中心差商（中间部分） $f'(a)=\frac{f(a+h)-f(a-h)}{2h}+O(h^2)$

二阶中心差商 $f''(a) =\frac{f(a+h)+f(a-h)-2f(a)}{h^2}+O(h^2)$

证明都是通过泰勒展式，略。

实际使用时，令 $h$ 为一个较小的数（如 $h=10^{-5}$）即可求 $f$ 在 $a$ 点的微分。

### 数值方法求梯度

> 参考链接：https://www.bilibili.com/video/av59319786

梯度的定义：

> $$\nabla f(\boldsymbol{x}) = \left[\begin{matrix}
\frac{\partial f}{\partial x_1} \\\\
\frac{\partial f}{\partial x_2} \\\\
\vdots \\\\
\frac{\partial f}{\partial x_n}
\end{matrix}\right]$$

数值方法求梯度，其实就是上面的微分方法用来求 n 遍偏导。  
每次求偏导的方法如下：

$$\frac{\partial f}{\partial x\_i} = \frac{ f(\boldsymbol{x};x\_i+\Delta x\_i) - f(\boldsymbol{x};x\_i-\Delta x\_i)}{2x\_i} + O \left((\Delta x\_i)^2 \right)$$

### 数值方法求黑塞矩阵

黑塞矩阵：

$$\nabla^2f(\boldsymbol{x})=\left[\begin{array}{cccc}
{\frac{\partial^2 f}{\partial x\_1^2}} & {\frac{\partial^2 f}{\partial x\_1 \partial x\_2}} & {\cdots} & {\frac{\partial^2 f}{\partial x\_1 \partial x\_n}} \\\\
{\frac{\partial^2 f}{\partial x\_2 \partial x\_1}} & {\frac{\partial^2 f}{\partial x\_2^2}} & {\cdots} & {\frac{\partial^2 f}{\partial x\_2 \partial x\_n}} \\\\
{\vdots} & {\vdots} & {\ddots} & {\vdots} \\\\
{\frac{\partial^2 f}{\partial x\_n \partial x\_1}} & {\frac{\partial^2 f}{\partial x\_n \partial x\_2}} & {\cdots} & {\frac{\partial^2 f}{\partial x\_n^2}}
\end{array}\right]$$

其实和上面本质是一样的，只是二阶导要求两次。推导过程就略了（可以看上面参考链接的视频），最后的每一项的结果如下：

$$\begin{aligned}
\frac{\partial^2 f}{\partial x\_i \partial x\_j} = &\frac{1}{4\Delta x\_i\Delta x\_j} \bigg[ \\\\
&f(\boldsymbol{x};x\_i+\Delta x\_i,x\_j+\Delta x\_j) + f(\boldsymbol{x};x\_i-\Delta x\_i,x\_j-\Delta x\_j)\\\\
&-f(\boldsymbol{x};x\_i-\Delta x\_i,x\_j+\Delta x\_j) - f(\boldsymbol{x};x\_i+\Delta x\_i,x\_j-\Delta x\_j)\bigg] \\\\
&+ O((\Delta x\_i)^2)
\end{aligned}$$

看起来麻烦，其实就是如下图，需要找得到 A 点的二阶偏导时，将 A 的 $x_i, x_j$ 各增加/减少 $\Delta x_i, \Delta x_j$ 的量，得到 B、C、D、E，用 (B+D)-(C+E) （的函数值加减以后的结果）除以 $4\Delta x_i\Delta x_j$ 即可。

![数值方法求二阶偏导](getting-partial-derivative.png)

注意这个方法不能用在对角线上。求对角线上的二阶导仍需要用上面数值微分提到的求二阶导方法。

$$\frac{\partial^2 f}{\partial x\_i^2} =\frac{ f(\boldsymbol{x};x\_i+\Delta x\_i) + f(\boldsymbol{x};x\_i-\Delta x\_i) - 2f(\boldsymbol{x}) } {(\Delta x\_i)^2}+O((\Delta x\_i)^2)$$

## 数值积分

按积分定义有：

$$\int_a^bf(x)dx=\lim_{h\to0}\sum_{i=1}^nf(x_j)h$$

当 $h$ 足够小时，数值积分结果即可近似实际结果。

数值积分分为左矩形法（积分的高度按左端点的函数值计算）、右矩形法。

效率不高（即使是一重积分中，$h$ 的精度就必须要相当高）

构造思路：想构造 $A_k$ 使得

$$\int_a^b f(x)dx=\sum_{k=0}^nA_kf(x_k)+R[f]$$

$R[f] = \int_a^b f(x)dx - \sum_{k=0}^nA_kf(x_k)$ 表示残差。不同算法的残差不同。

### 求积公式的代数精度

对于每个求积公式，我们用对多项式进行求积，来定义 $m$ 阶代数精度公式：

> 对于不高于 $m$ 次的任意多项式 $P(x)$，求积公式若恒等于 0，即  
> $$R[f] = \int_a^b P(x)dx - \sum_{k=0}^nA_kP(x_k) \equiv 0$$
> 且对于 $m+1$ 次多项式，不具有这么的性质，则称：
> $$\int_a^b f(x)dx \approx \sum_{k=0}^nA_kf(x_k)$$
> 具有 $m$ 阶的代数精度。


### 插值型求和公式

#### Lagrange 插值求积公式

这是基于 Lagrange 插值法的一个方法。

从思想上来说，Lagrange 插值法是通过函数 $f(x)$ 的已知的 $n+1$ 个点 $(x_j, y_j)$，构造出一个多项式 $p(x)$ 来近似 $f(x)$。（这个多项式最高为 $n$ 次，经过全部 $n+1$ 个点）  
而 Lagrange 插值求积分，其思想就是用 $f(x)$ 算出 $n+1$ 个点，构造出 $p(x)$，再用 $p(x)$ 的积分（多项式积分很容易）来近似 $f(x)$ 的积分。

在 Lagrange 插值中，已知 $n+1$ 个点 $(x_j, y_j)$，则应用 Lagrange 插值公式得到的 **Lagrange 插值多项式** 为：

$$p(x) \approx \sum_{j=0}^k y_j l_j(x)$$

其中

$$l_j(x) = \prod_{i=0, i \neq j}^n\frac{x-x_i}{x_j-x_i}=\frac{(x-x_0)}{(x_j-x_0)} \cdots \frac{(x-x_{j-1})}{(x_j-x_{j-1})} \frac{(x-x_{j+1})}{(x_j-x_{j+1})} \cdots \frac{(x-x_{k})}{(x_j-x_{k})}$$

公式的正确性略，请读者自行查阅资料。注意，这个 $l_j(x)$ 将会被用到积分过程中。

$$\begin{split}
f(x) &\approx p(x) \\\\
\int_a^b f(x) &\approx \int_a^b \sum_{j=0}^k l_j(x) \cdot y_j \\\\
&\approx  \sum_{j=0}^k \left[ \int_a^b l_j(x) \right] f(x_j)
\end{split}$$

令 $A_j = \int_a^b l_j(x)$，则推出了 [前面](#数值积分) 所提到的公式：

$$\int_a^b f(x) = \sum_{j=0}^k A_j f(x_j) + R[f]$$

可以证明此法的

$$R[f] = \sum_a^b \frac{f^{(n+1)}(\xi)}{(n+1)!} \omega(x)dx$$

其中 $\omega(x)=\prod_{i=0}^n (x-x_i)$。

进一步推进，对于 $n+1$ 点（即 $n$ 次） Lagrange 插值求积公式，其代数精度至少为 $n$ 阶。

##### 应用 1 梯形公式

我们可以把整段区间的积分，分割为数个小区间的积分再求和。在求小区间的积分的时候，我们对小区间的两个端点进行拉格朗日插值积分。

对于两点 $(a,f(a)), (b,f(b))$ 的线性插值，有

$$
l_0(x)=\frac{x_1-x}{x_1-x_0}\quad l_1(x)=\frac{x-x_0}{x_1-x_0} \\\\
A_0=\int_a^b \frac{b-x}{b-a}dx=\frac{1}{2}(b-a)  \quad A_1=\int_a^b \frac{x-a}{b-a}dx=\frac{1}{2}(b-a) \\\\
\int_a^b f(x)dx \approx \frac{b-a}{2}[f(a) + f(b)]
$$

误差

$$\begin{split}
R &=\int_a^b \frac{f''(\xi)}{2}(x-a)(x-b)dx = \frac{f''(\\eta)}{2}\int_a^b (x-a)(x-b)dx \\\\
&=-\frac{(b-a)^3}{12}f''(\eta)
\end{split}$$

要使误差小：一是区间取小，二是二阶导数小（曲线更趋近于直线，几何上看也比较明显）

梯形公式具有 1 阶代数精度。

> MATLAB 梯形法数值积分 `trapz`

另外梯形公式还能够推出另外一个公式：

> 来自数学建模实验的笔记：
> 
> 这是积分中值定理：$$\exists \xi, \quad \int_a^bf(x) = (b-a)f(\xi)$$
> 
> 在数值积分时，可以在 $[a, b]$ 中等间距地取 10000 个点，$f(x)$ 的平均值就可以近似 $f(\xi)$。
> 
> 貌似是数值积分的套路操作，但是微积分 I 没有讲。
> 2020.2.22 更新：确实，这是[梯形公式](https://zh.wikipedia.org/wiki/梯形公式)，可见维基百科

##### 应用 2 Simpson 公式（三点积分公式）

依旧是把整段区间的积分，分割为的积分再求和。不过，在求小区间的积分的时候，我们改用二次函数近似，在一个区间上取三个点（两个端点+中点）。

计算过程仍然是类似于梯形公式，算 $l_j(x)$，对每一个进行积分得到 $A_j$，然后和每段的 $y_j$ 相乘再相加，最后得到

$$\int_a^b f(x)dx \approx \frac{b-a}{6} \left[ f(a)+4f(\frac{a+b}{2})+f(b) \right]$$

近似效果会好些。

Simpson 公式竟然具有 3 阶代数精度。

当然，还可以用高次函数来跑 Lagrange 插值积分，但是高次函数有震荡性，一般就使用线性或二次即可。

##### Newton-C ？？？？

#### 复合梯形求积公式

将积分区间先拆为 $n$ 等份。

然后分的更细。**是迭代法！**

不过注意，迭代的时候可以重复使用之前的结果，只需要补上新增的点。

复合梯形法可以套用前面的所有插值法。

### 蒙特卡罗方法求积分

很显然的方法就是在每一维上取一些点，计算 $10^n$ 个点，但是复杂度与维数是成指数级的。

于是使用随机投点法，用矩形框起来，然后随机投点，计算概率，即可估算积分大小。

优点：算法复杂度和函数无关，和维数无关  
缺点：不能保证精确度

### 高斯型数值积分公式

震惊！用两个点就能得到代数精度为 3？

插值型求积公式$\int_{-1}^1f(x)dx \approx A_0f(x_0) + A_1f(x_1)$

为保证代数精度为 3，令 $f(x) = 1, x, x^2, x^3$，得到参数需要满足以下条件：

$$\left\\{ \begin{matrix}
A_0+A_1=2 & (1) \\\\
A_0x_0+A_1x_1=0 & (2) \\\\
A_0x_0^2+A_1x_1^2=2/3 & (3) \\\\
A_0x_0^3+A_1x_1^3=0 & (4)
\end{matrix}\right.$$

虽然是非线性不好解，但是可以解得：

。。。。。。。

> 定义 如果求积结点 $x_0, x_1, ..., x_n$，使得
> $$\int_{-1}^1f(x)dx \approx \sum_{k=0}^nA_kf(x_k)$$
> ？？？？

对于别的区间，可以进行伸缩变换：

`quad` 
