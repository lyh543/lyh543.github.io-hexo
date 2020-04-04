---
title: MATLAB 符号编程
date: 2020-03-31 22:00:58
tags:
- MATLAB
- 课程笔记
category:
- MATLAB
mathjax: true
---

> 符号对象 (Symbolic Objects 不同于普通的数值计算) 是 Matlab 中的一种特殊数据类型，它可以用来表示符号变量、表达式以及矩阵。  
> 利用符号对象能够在不考虑符号所对应的具体数值的情况下能够进行代数分析和符号计算 (symbolic math operations)，例如解代数方程、微分方程、进行矩阵运算等。  
> 符号对象需要通过 `sym` 或 `syms` 函数来指定, 普通的数字转换成符号类型后也可以被作为符号对象来处理。
> 我们可以用一个简单的例子来表明数值计算和符号计算的区别：
> 
> > `2/5+1/3` 的结果为 `0.7333` (`double`类型数值运算)，而 `sym(2)/sym(5)+sym(1)/sym(3)` 的结果为 `11/15`，且这里 `11/15` 仍然是属于 `sym` 类型, 是符号数。
> 
> -- [MATLAB符号对象与符号运算](https://www.cnblogs.com/zhouqing/p/3306076.html)

符号编程即 $y = ax^2 + bx + c$ 此类函数，并可以对其进行求极限、求导、积分等操作。

除此之外，符号编程还有精确的优点，比如可以用 `sym(1)/sym(3)` 来表示精确的分数。

## sym 类型

和 `double` 一样，`sym` 也是一种类型，可以用 `whos` 命令查看。

`sym` 类型不仅可以存储 `x` `y` 这样的数学意义上的（而不是编程意义上的）变量，还可以存储 `1`、`1/3` 这样的数。但请注意，这里的 `1/3` 是精确的，而不是用浮点数存储的 `double` 类型的 `0.33333...`。

`sym` 类型的数值可以和 `double` 类型互相转换，转换方法和其他的类似。

```m
a = sym(1)         # 将 double 值转换为 sym
b = a/3；          # b 为 sym, 1/3
c = double(b)      # 将 sym 转为 double, c = 0.3333
```

除此之外，还可以使用 `vpa()` 函数来求一个 `sym` 数值的任意精度的小数（没错，任意！）。不过请注意， `vpa` 的返回值仍然是一个 `sym`。

另外请注意，`sym` 也支持加减乘除幂运算，也支持等于和不等于，但是不支持大于、小于。  
如需大于、小于，可以考虑将其转为 `double` 再比较，或者使用 `sort` 函数，这之后小的会在前面，大的会在后面。

## 函数代值

可以在定义 `f` 的时候就显式地指出其自变量 `f(x,y)`，然后就可以用 `f(1,2)` 的形式代入。

```MATLAB
syms x y;
syms f;
f(x,y) = x^2 + y^2;
f(1,2) # 输出 5
```

将 `x = 1, y = 2` 代入，返回 5。注意这里返回的 `5` 同样是一个 `syms`。

此外，还有使用 `subs` 和 `eval` 的方法，如下例：

```m
% 来源链接 https://blog.csdn.net/zengxiantao1994/java/article/details/77943305

f = sin(x^x / x^2/exp(x));
% 利用符号计算求f(x)的二阶导数
% diff函数用于求导数或者向量和矩阵的比较。
% 如果输入一个长度为n的一维向量，则该函数将会返回长度为n-1的向量，向量的值是原向量相邻元素的差
d2f = diff(f, x, 2);
 
% 第一种方法：利用subs函数求d2f在x=1时的值。
d2fx1 = subs(d2f, x, 1);  % d2fx1 = 2.2082
 
% 第二种方法：x赋值1后，利用eval函数求d2f在x = 1时的值
x = 1;
d2_fx1 = eval(d2f); %d2_fx1 = 2.2082
   
% 第三种方法：将d2f转化成匿名函数，求其在x = 1时的值
% vectorize的含义就是将乘转成点乘等。  '*' -> '.*'； '/' -> './'； '^' -> '.^'； 最后再将替换结果中的“..”删除一个"."。
F = eval(['@(x)',vectorize(char(d2f))]);
F(1)  % ans=  2.2082
```

## 解方程

```m
syms x;
y = x^2 + 2*x;
solve(y-1,x);
```

解 `y-1=0` 关于 x  的方程。返回：


```
[- 2^(1/2) - 1
   2^(1/2) - 1]
```

另有：

```m
equa = x^2 + 2*x == 1;
solve(equa);

syms u v
eqns = [2*u + v == 0, u - v == 1];
S = solve(eqns,[u v])
```

以上都是 `solve` 函数。如有必要，还可以考虑使用 `fzero`、`fsolve`、`vpasolve`，用法可查看官方文档或[博客](https://blog.csdn.net/zengxiantao1994/article/details/77943305)。

## 化简表达式

```m
s = simplify(cos(x)^2-sin(x)^2)
```

返回 `cos(2*x)`。

## 求极限

```m
s = limit((1+1/n)^n, n, inf);
```

返回 `exp(1)`。

## 求级数

```m
s = symsum(1/factorial(x), 0, Inf)
```

当然，如果上下界使用整数，这就是一个普通的求和过程（无需用 `for` 语句）。

返回 `exp(1)`。

## 求导

```m
s = y^3+x^2; diff(s,y);
```

返回 `3*y^2`。

另有求 dim 阶导数：

```m
diff(X,n,dim)
```

另外，对于矩阵 `A`，`diff(A)` 是差分。  

另外可以求近似导数 $f'(x)=\lim\limits_{h \to 0} \frac{f(x+h)-f(x)}{h}$：

```
h = 0.001;
X = 1:h:2;
Y = sin(X);
D = diff(Y)/h;
```

## 积分

```m
int(x^2);
```

返回 `x^3/3`。

另有以下形式：

```m
int(expr,var);
int(expr,a,b);
int(expr,var,a,b);
```

## 泰勒展开

```m
taylor(exp(x),x,0,'order',3)
```

2 阶泰勒展开，返回 `x^2/2+x+1`。 

## 解常微分方程

```MATLAB
dsolve('Dy=(50-0.01*y)*y','y(0)=4','x'); % 二阶导的写法为'D2y'
```

详见[MATLAB 解常微分方程](../differential-equation/#MATLAB-解常微分方程)。

## 分段函数

分段函数：`pw = piecewise(cond1,val1,cond2,val2,...,otherwiseVal)`，如`y=piecewise(x<0,-x^2,x^2);`。