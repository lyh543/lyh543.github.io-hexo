---
title: MATLAB 绘图
date: 2019-09-23 20:33:01
tags:
- 课程笔记
category:
- MATLAB
mathjax: true
---

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

## plot

老师教的方法。[官方文档](https://ww2.mathworks.cn/help/matlab/ref/plot.htm)

已知表达式：

```MATLAB
xx = linspace(0, 2*pi, 100);
yy = sin(xx);
plot(xx,yy);
```

参数方程：

```matlab
t = linspace(0,2*pi,100);
x1 = r*cos(t);
y1 = r*sin(t);
plot(x1,y1)
```

利用 `for` 和 `pause(0.02); hold off;` 还能做出动画来。

```matlab
r = 3;
t = linspace(0,2*pi,100);
x1 = r*cos(t); y1 = r*sin(t);
x2 = 7+x1;     y2 = y1;
spacex = 0.2;
for i=1:100
    hold off
    x1 = x1 + spacex;
    x2 = x2 + spacex;
    plot(x1,y1),hold on
    plot(x2,y2)
    axis equal
    axis([0  10+100*spacex -r r])
    pause(0.02)
end
```

还可以指定线型。

但是 `fplot` 不香吗？

绘制三维图可以使用 `plot3`。

### fplot

[官方文档](https://ww2.mathworks.cn/help/matlab/ref/fplot.html)

fplot 可以直接传函数进去（推荐用符号函数，用匿名函数会警告）。传一个函数即是普通函数，传两个就是参数方程。区间用一个二元向量 `[1 2]`表示。

```matlab
fplot(f)
fplot(f,xinterval)
fplot(funx,funy)
fplot(funx,funy,tinterval)
```

### ezplot

```MATLAB
ezplot(sin(x)/x);
ezplot(t,t^2,[1,2]);
```


