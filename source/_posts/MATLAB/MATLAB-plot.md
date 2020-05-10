---
title: MATLAB 绘图
date: 2019-09-23 20:33:01
tags:
- MATLAB
- 课程笔记
category:
- MATLAB
mathjax: true
---

## 按自变量、因变量值绘图

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

## 按符号函数绘图

[官方文档](https://ww2.mathworks.cn/help/matlab/ref/fplot.html)

fplot 可以直接传函数进去（推荐用符号函数，用匿名函数会警告）。传一个函数即是普通函数，传两个就是参数方程。区间用一个二元向量 `[1 2]`表示。

```matlab
fplot(f)
fplot(f,xinterval)
fplot(funx,funy)
fplot(funx,funy,tinterval)
```

## ezplot（不知道是什么）

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

## 三维线图

`plot3`，和 `plot` 用法类似，给定 n 个点的 (x, y, z) 坐标，`plot3` 绘制其连起来的线图。

## 三维面图

`surf` 三维面图要稍微麻烦一点，需要给定 X, Y, Z 三个矩阵（而不是向量），其中 X, Y 可以用 `meshgrid` 函数和 x, y 的 n 个坐标进行生成。

下面的代码将生成抛物线 $z=x^2+y^2$ 在 [-5,5] 的范围。

```m
x = -5:0.1:5;
y = -5:0.1:5;
[X, Y] = meshgrid(x, y);
Z = X.^2 + Y.^2;
surf(X,Y,Z);
```

MATLAB 自带了生成绘制标准球（`sphere`）、椭球（`ellipsoid`）和标准圆柱侧面（`cylinder`）的 X,Y,Z 的函数。  

如果想要生成其他大小、位置的球/圆柱，可以考虑坐标变换。下面的代码生成了半径为 R，球心在 `[-R, -R, L]` 的球。

```m
[x1, y1, z1] = sphere;
x1 = x1 * R - R;
y1 = y1 * R - R;
z1 = z1 * R + L;
surf(x1, y1, z1);
```

也可以手算得到 X, Y, Z：

```m
close all
a = 6000;
b = 5000;
[r,t]=meshgrid(linspace(0,a,50),linspace(0,2*pi,50));
x=r.*cos(t); y=r.*sin(t);
z = b*sqrt(1-(x.^2+y.^2)/(a*a));
z = real(z);
surf(x,y,z);
hold on;
surf(x,y,-z)
axis equal
```

如果给定函数和范围想要直接画出图形，可以改用 `fsurf`。

## mesh 散点图

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

## image 输出图片

```m
background = imread('Snakes_And_Ladder.png');
image(background);
```

输出了以后还可以用 `hold on; plot` 在图上绘制几何图形，每个像素为一个单位长度。但需要注意，该图的原点在左上角，x、y 轴的正方向分别为右方、下方。

提示：还可以使用 `axis equal off` 来保持图片的长宽比，然后隐藏坐标轴。

## 图的注释、美化

### hold on

使用两个 `plot` （或其他画图语句）后，第二个会删掉前面的图并且重新画。

要想将两个图叠加在一起，需要在第一次绘图以后加一句 `hold on`。如：

```m
plot(...);
hold on;
plot(...);
plot(...)
```

如下次绘图不想叠加了，就在这次绘图之后加一句 `hold off` 即可。

但请注意，`hold on` 和 `hold off` 的原理是设置图/表的 `NextPlot` 属性为 `add` 或 `replace`，并非立即刷新。在下次绘图时，会检查 `NextPlot` 的属性，再决定是否覆盖掉，还是将图形进行叠加。

因此，下图的代码中的 `hold off` 其实无意义。

```m
plot(...);
hold off;
hold on;
plot(...);
plot(...)
```

另外，很神奇的是，在 MATLAB R2020a 中，`rectangle` 的语法很诡异。（在 MATLAB R2017a 中没有这个问题）

```m
plot(...);
hold off;
rectangle();
hold on;
plot(...);
plot(...)
```

### 多图并排

```m
subplot(1,2,1);
scatter(rand(1,10000),rand(1,10000))
subplot(1,2,2)；
scatter(rand(1,10000),rand(1,10000))
```

另外，从 R2019b 开始，您可以使用 `tiledlayout` 和 `nexttile` 函数显示平铺绘图。

```m
x = linspace(0,10);
y1 = sin(x);
y2 = cos(x);
tiledlayout(2,1)

% Top plot
ax1 = nexttile;
plot(ax1,x,y1)

% Bottom plot
ax2 = nexttile;
plot(ax2,x,y2)
```

### 坐标轴格式调整

```m
axis off     % 隐藏坐标轴
axis equal   % 使坐标轴的 x, y, z 轴单位长度相同
```

### 图的注释

```m
plot(x,y);
title('y=f(x)')
xlabel('x'), ylabel('y')
```

### 线图的美化

```m
h = plot(x1,y1, 'r-');      % 选择曲线颜色、线型   r 红色，k 黑色，b 蓝色，o 
set(h, 'linewidth' ,2);     % 调整线的属性
legend('X', 'Y');
axis([0 25 0 20])           % 调整坐标区的范围
```

### 散点图的美化

```m
plot(d(:,1),y,'o','markersize',12)
set(gca,'fontsize',14)
set(gcf,'color','w')
```