---
title: MATLAB 解常微分方程
date: 2019-11-11 19:44:18
tags:
- 课程笔记
- MATLAB
- 常微分方程
category:
- MATLAB
mathjax: true
---

## 常微分方程

常微分方程就是解 $\frac{dN}{dt}=rN, N(0)=N_0$ 这一类的方程。

上式中，若 $r$ 为常量，则常微分方程的解为 $N_0 e^{rt}$。

建立常微分模型的过程略。

## MATLAB 解常微分方程的函数解

运用 `desolve` 命令。

如果使用字符串，方法如下：

```m
desolve('')
```

如果运用符号编程，方法如下：

```m
syms N(t) K N0 r0;
dsolve(diff(N,t,1)==r0*(1-N/K)*N, N(0)==N0)
pretty(ans)
```

## 求解一元一阶常微分方程数值解

有些常微分方程能够解得显式函数，但是也有不能的。于是我们退而求其次，只需要求其数值解。

更一般的是：

$$
\frac{dy}{dt} = f(t,y) \\\\
y(t_0) = y_0
$$

### 误差分析

局部截断误差思想：假设 $y_n$ 准确，计算 $y_{n+1}$ 的误差。

> 设 $y_n=y(x_n)$，称 $R_{n+1} = y(x_{n+1}) - y_{n+1}$ 为局部截断误差。
> 若局部误差为 $O(h^{n+1})$，则称该方法有 $n$ 阶精度。

### 欧拉法

解法：（欧拉法，又名左矩形法）积分。

显式快，但是不稳定，h需要很小；
隐式慢，但是稳定，h可以很大。

显式的如下：

$$\begin{aligned}
\int_{t_0}^{t_1}y'(t)dt &= \int_{t_0}^{t_1}f(t,y)dt \\\\
y(t_1) - y(t_0) &\approx (t_1 - t_0)f(t_0,y_0) \\\\
y(t_1) &\approx y(t_0) + (t_1 - t_0)f(t_0,y_0) \qquad\cdots(1)
\end{aligned}$$

由 (1) 式可解出 $y(t_1)$ 的近似值，并继续用 $y(t_1)$ 解出 $y(t_2),...$

隐式的方法：

$$\begin{aligned}
\int_{t_0}^{t_1}y'(t)dt &= \int_{t_0}^{t_1}f(t,y)dt \\\\
y(t_1) - y(t_0) &\approx (t_1 - t_0)f(t_1,y_1) \\\\
y(t_1) &\approx y(t_0) + (t_1 - t_0)f(t_1,y_1) \qquad\cdots(2)
\end{aligned}$$

同样可由 (2) 式解出 $y(t_1)$ 的近似值，并继续用 $y(t_1)$ 解出 $y(t_2),...$但问题在于对于 (2) 式右边的部分是未知的，也就是说，还要解一下 (2) 这个非线性方程。

以上方法还可以解多元的情况。

例题：预测战争模型

$\left\\{ \begin{aligned}
\frac{dx}{dt} &= -0.15y \\\\
\frac{dy}{dt} &= -0.1x \\\\
x_0 &= 10000 \\\\
y_0 &= 5000
\end{aligned} \right.$

计算 t 为何值时， x 或 y 变为 0。

```m
dt=1/3600;
N=10;
size = fix(N/dt);
a = 0.15;
b = 0.1;
y = zeros(1,size);
x = zeros(1,size);
x(1) = 10000;
y(1) = 5000;
for i = 2:size+1
    x(i) = x(i-1) - a * y(i-1) * dt;
    y(i) = y(i-1) - b * x(i-1) * dt;
    if (x(i) < 0 || y(i) < 0)
        break;
    end
end
fprintf( 't=%d, x=%d, y=%d',double(i-1)*dt,x(i), y(i))
t = 1:i;
t = t * dt;
h = plot(t, x(1:i),'r-', t, y(1:i), 'k-') % r 红色， k 黑色
set(h, 'linewidth' ,2);
legend('x', 'y');
```

### 梯形法

但是不想解非线性方程。

于是搞了一个近似的方法——预估——校正法（修正的欧拉法）。是二阶误差的。

$$
y(t_1) - y(t_0) = \frac{h}{2}[f(t_0,y_0)+f(t_1, y_1)] \\\\
\Rightarrow \begin{cases}
\tilde{y_1} = y_0 + hf(x_0, y_0) \qquad(由 1 式) \\\\
y_1 = y_0 + \frac{h}{2}[f(t_0,y_0)+f(t_1, \tilde{y_1})]
\end{cases}
$$


### Range-Kutta 公式

简单介绍一下就行。不需要记。

> MATLAB 命令解常微分方程数值解：二阶 `ode23`，四阶 `ode45`。

### ode45

题目是[上面](#欧拉法)的预测战争模型。

```m
function testmain
[T,Y]=ode45(@rigid,[0 6],[10000 5000]);

plot(T,Y(:,1),'-',T,Y(:,2),'*')
% T的每一行表示时间，Y的每一行表示两边的兵力

function dy=rigid(t,y)
a=0.15;
b=0.1;
dy=zeros(2,1);
dy(1)= -a*y(2);
dy(2)= -b*y(1);
```

## 求解多元常微分方程

将 $y1,y2$ 用向量 $\vec{y}$ 来写，$f$ 用向量 $F$ 来写，数值解法和一元一阶常微分方法相同。

## 解高阶微分方程

就是降阶。

```m
function dy=odefun(t,y)
n=length(y);  dy=zeros(n,1);
dy(1)=y(2)
dy(2)=y(3)
% ...
dy(n)=f(t,y(2),y(3),...,y(n-1));
```