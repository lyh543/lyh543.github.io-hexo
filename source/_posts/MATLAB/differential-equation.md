---
title: MATLAB 解常微分方程
date: 2019-11-11 19:44:18
tags:
- 课程笔记
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

### 使用字符串：

```m
desolve('')
```

### 运用符号函数

```m
syms N(t) K N0 r0;
dsolve(diff(N,t,1)==r0*(1-N/K)*N, N(0)==N0)
pretty(ans)
```

## 求解常微分方程数值解

有些常微分方程能够解得显式函数，但是也有不能的。于是我们退而求其次，只需要求其数值解。

更一般的是：

$$
\frac{dy}{dt} = f(t,y) \\\\
y(t_0) = y_0
$$

解法：（欧拉法，又名左矩形法）积分。

$$\begin{aligned}
\int_{t_0}^{t_1}y'(t)dt &= \int_{t_0}^{t_1}f(t,y)dt \\\\
y(t_1) - y(t_0) &\approx (t_1 - t_0)f(t_0,y_0) \\\\
y(t_1) &\approx y(t_0) + (t_1 - t_0)f(t_0,y_0)
\end{aligned}$$

以此解出 $y(t_1)$ 的近似值，并继续用 $y(t_1)$ 解出 $y(t_2),...$

用这个方法还可以解多元的情况。

例题：预测战争模型

$\left\\{ \begin{aligned}
\frac{dx}{dy} &= -0.15y \\\\
\frac{dy}{dx} &= -0.1x \\\\
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

## 解高阶微分方程

```m
function dy=odefun(t,y)
n=length(y);  dy=zeros(n,1);
dy(1)=y(2)
dy(2)=y(3)
% ...
dy(n)=f(t,y(2),y(3),...,y(n-1));
```