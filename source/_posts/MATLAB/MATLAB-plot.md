---
title: MATLAB 绘图
date: 2019-09-23 20:33:01
tags:
- MATLAB 语法
- 课程笔记
category:
- MATLAB
mathjax: true
---

## plot 按自变量、因变量值绘图

这是老师教的方法。[官方文档](https://ww2.mathworks.cn/help/matlab/ref/plot.htm)

这个方法的实现是：将输入的 n 个点中，相邻两个点都用直线连接。当点足够密时，可以认为曲线是平滑的了。需要散点图在最后加一个参数 `.`。

### 已知表达式

```MATLAB
xx = linspace(0, 2*pi, 100);
yy = sin(xx);
plot(xx,yy);
```

### 参数方程

```matlab
t = linspace(0,2*pi,100);
x1 = r*cos(t);
y1 = r*sin(t);
plot(x1,y1)
```

### plot 散点图

```m
plot(1:5, 1:5, '.'); % 另可用 `o`, `*`
```

## hold on

使用两个 `plot` （或其他画图语句）后，第二个会删掉前面的图并且重新画。

要想将两个图叠加，需要在两个 `plot` 之间加一句 `hold on`。一般习惯写法是：

```m
plot(...), hold on;
plot(...), hold on;
plot(...)
```

## fplot 按符号函数绘图

[官方文档](https://ww2.mathworks.cn/help/matlab/ref/fplot.html)

fplot 可以直接传函数进去（推荐用符号函数，用匿名函数会警告）。传一个函数即是普通函数，传两个就是参数方程。区间用一个二元向量 `[1 2]`表示。

```matlab
fplot(f)
fplot(f,xinterval)
fplot(funx,funy)
fplot(funx,funy,tinterval)
```

## ezplot

```MATLAB
ezplot(sin(x)/x);
ezplot(t,t^2,[1,2]);
```

## scatter 散点图

后来老师讲了带参数的 `plot`，真香。

```m
for i = 1:10
    scatter(i,rand()), hold on;
end
```

使用实心圆可以使用 `scatter(i,rand(), 8, 'filled')`。

## histogram 直方图

旧版使用 `hist`，新版使用 `histogram`。

输入一个向量，绘出 x 的每个元素的直方图。

其中，默认把 x 的值分为 10 个区间。

## plot3 三维图

## mesh 散点图

啊啊啊

## 动画程序框架

```matlab
close all;
N = 100;
for i=1:N
    hold off;
    % ... 绘图语句
    pause(0.05);
end;
```

## subplot 多图并排

```m
subplot(1,2,1);
scatter(rand(1,10000),rand(1,10000))
subplot(1,2,2)；
scatter(rand(1,10000),rand(1,10000))
``

## 图的注释、美化

### 图的注释

```m
plot(x,y);
title('y=f(x)')
xlabel('x'), ylabel('y')
```

### plot 图的美化

```m
h = plot(x1,y1, 'r-'); % r 红色， k 黑色
set(h, 'linewidth' ,2);
legend('X', 'Y');
```


### 散点图的美化

```m
plot(d(:,1),y,'o','markersize',12)
set(gca,'fontsize',14)
set(gcf,'color','w')
```