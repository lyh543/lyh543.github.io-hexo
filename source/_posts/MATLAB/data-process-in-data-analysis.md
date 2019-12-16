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

二维插值。这里不能使用 `interp2` 而需要使用 `griddata`，8 知道为什么。

```m
X=[129.0  140.5  103.5  88.0  185.5  195.0  105.5 ...
157.5  107.5  77.0  81.0  162.0  162.0  117.5];
Y=[ 7.5   141.5   23.0  147.0  22.5   137.5  85.5 ...
-6.5   -81.0    3.0   56.5  -66.5   84.0   -33.5];
Z=[ 4     8       6     8    6       8      8 ...
     9     9       8     8     9      4       9 ];

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

两个比较垃圾的差商，但是处理端点好用：

前向差商（左端点） $f'(a)=\frac{f(a+h)-f(a)}{h}+O(h)$

后向差商（右端点） $f'(a)=\frac{f(a)-f(a-h)}{h}+O(h)$

一阶中心差商（中间部分） $f'(a)=\frac{f(a+h)-f(a-h)}{2h}+O(h^2)$

二阶中心差商 $f''(a) =\frac{f(a+h)+f(a-h)-2f(a)}{h^2}+O(h^2)$

证明都是通过泰勒展式，略。

实际使用时，令 $h$ 为一个较小的数（如 $h=10^{-5}$）即可求 $f$ 在 $a$ 点的微分。

### 数值方法求梯度

> 参考链接：https://www.bilibili.com/video/av59319786

梯度的定义：

$$\nabla f(\vec{x}) = \left[\begin{matrix}
\frac{\partial f}{\partial x_1} \\\\
\frac{\partial f}{\partial x_2} \\\\
\vdots \\\\
\frac{\partial f}{\partial x_n}
\end{matrix}\right]$$

数值方法求梯度，其实就是上面的微分方法用来求 n 遍偏导。  
每次求偏导的方法如下：

$$\frac{\partial f}{\partial x\_i} = \frac{ f(\vec{x};x\_i+\Delta x\_i) - f(\vec{x};x\_i-\Delta x\_i)}{2x\_i} + O((\Delta x\_i)^2)$$

### 数值方法求黑塞矩阵

黑塞矩阵：

$$\nabla^2f(\vec{x})=\left[\begin{array}{cccc}
{\frac{\partial^2 f}{\partial x\_1^2}} & {\frac{\partial^2 f}{\partial x\_1 \partial x\_2}} & {\cdots} & {\frac{\partial^2 f}{\partial x\_1 \partial x\_n}} \\\\
{\frac{\partial^2 f}{\partial x\_2 \partial x\_1}} & {\frac{\partial^2 f}{\partial x\_2^2}} & {\cdots} & {\frac{\partial^2 f}{\partial x\_2 \partial x\_n}} \\\\
{\vdots} & {\vdots} & {\ddots} & {\vdots} \\\\
{\frac{\partial^2 f}{\partial x\_n \partial x\_1}} & {\frac{\partial^2 f}{\partial x\_n \partial x\_2}} & {\cdots} & {\frac{\partial^2 f}{\partial x\_n^2}}
\end{array}\right]$$

其实和上面本质是一样的，只是二阶导要求两次。推导过程就略了（可以看上面参考链接的视频），最后的每一项的结果如下：

$$\begin{aligned}
\frac{\partial^2 f}{\partial x\_i \partial x\_j} = &\frac{1}{4\Delta x\_i\Delta x\_j} \bigg[ \\\\
&f(\vec{x};x\_i+\Delta x\_i,x\_j+\Delta x\_j) + f(\vec{x};x\_i-\Delta x\_i,x\_j-\Delta x\_j)\\\\
&-f(\vec{x};x\_i-\Delta x\_i,x\_j+\Delta x\_j) - f(\vec{x};x\_i+\Delta x\_i,x\_j-\Delta x\_j)\bigg] \\\\
&+ O((\Delta x\_i)^2)
\end{aligned}$$

看起来麻烦，其实就是如下图，需要找得到 A 点的二阶偏导时，将 A 的 $x_i, x_j$ 各增加/减少 $\Delta x_i, \Delta x_j$ 的量，得到 B、C、D、E，用 (B+D)-(C+E) （的函数值加减以后的结果）除以 $4\Delta x_i\Delta x_j$ 即可。

![数值方法求二阶偏导](getting-partial-derivative.png)

注意这个方法不能用在对角线上。求对角线上的二阶导仍需要用上面数值微分提到的求二阶导方法。

$$\frac{\partial^2 f}{\partial x\_i^2} =\frac{ f(\vec{x};x\_i+\Delta x\_i) + f(\vec{x};x\_i-\Delta x\_i) - 2f(\vec{x}) } {(\Delta x\_i)^2}+O((\Delta x\_i)^2)$$

## 数值积分

梯形法数值积分 `trapz`

积分中值定理：$\exist \xi \space \int_a^bf(x) = (b-a)f(\xi)$

在数值积分时，可以在 $[a, b]$ 取均匀分布的 10000 个点，$f(x)$ 的平均值就可以近似 $f(\xi)$。？？？？

貌似是数值积分的套路操作，但是微积分 I 没有讲。