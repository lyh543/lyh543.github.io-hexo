---
title: 数值分析中的数据处理方法
date: 2019-11-25 19:47:54
tags:
- 课程笔记
category:
- MATLAB
mathjax: true
---


## 插值

变量之中存在的函数关系，有时不能确定，而是通过获得的数据来找出两个变量间可能存在的连续。

这东西和拟合有点像。

已知 $f(x)$ 的很多点 $x_i, y_i)$，要找一个函数 $P(x) \approx f(x)$。

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

证明都是泰勒展式。

## 数值积分

梯形法数值积分 `trapz`