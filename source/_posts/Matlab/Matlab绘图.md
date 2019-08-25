---
title: Matlab绘图
tags:
category:
- Matlab
mathjax: true
---

[学习目录](../Matlab学习目录)

## plot

```matlab
xx = linspace(0, 2*pi, 100);
yy = sin(xx);
plot(xx,yy);
```

## ezplot

```matlab
ezplot(sin(x)/x);
ezplot(t,t^2,[1,2]);
```
