---
title: Matlab函数运算.md
tags:
category:
- Matlab
mathjax: true
---

[学习目录](../Matlab学习目录)

## 数学函数

```matlab
f1=@(x)x^2
f2=inline('X^2') //教材版本
f1(x)
% 类似于define f1(int x)(return 0;)
% 或typedef
```

## 自定义函数 `sum2.m`

需要分文件存储

```matlab
function r=sum2(ri, r2)
r = r1 + r2
```

## 替换变量（代值）

```matlab
syms x y;
s = x^2 + y^2
subs(s,[x,y],[1,2]);
```

## 化简表达式

```matlab
syms x y;
s = simplify(cos(x)^2-sin(x)^2)
```

## 求极限

```matlab
syms n;
s = limit((1+1/n)^n, n, inf);
```

## 求导

```matlab
syms v;
s = v^3+x^2;
diff(s,'v');
diff(s,'v',n)
```

## 积分

```matlab
syms x;s = x^2;int(s)
```

## 泰勒展开

```matlab
taylor(exp(x),x,0,'order',8) %7阶
```

## 解常微分方程

```matlab
dsolve('Dy=(50-0.01*y)*y','y(0)=4','x');
% 二阶导的写法为'D2y'
```
