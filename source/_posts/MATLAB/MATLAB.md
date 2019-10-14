---
title: MATLAB编程基础
tags:
category:
- MATLAB
mathjax: true
---

## 前言

`help xxx` 用于查看命令。  
单引号 `'` 和双引号 `"` 一样，推荐单引号。  
用分号 `;` 结束语句，以屏蔽输出。  
等于 `==`，不等 `~=`，取反 `~`，与或是 `&&` 和 `||`。

## 构造矩阵

```MATLAB
>> a = [2 2; 5 8]
2 2
5 8
>> 1:2:10    % 1 3 5 7 9
>> 1:5         % 1 2 3 4 5
>> linspace(1,2,10)  %  (start, end, length) 1.0000    1.1111    1.2222    1.3333    1.4444   1.5556    1.6667    1.7778    1.8889    2.0000
```

`1:5` 语法是闭区间，和 Python 左闭右开不一样。

### 构造常见矩阵

```MATLAB
>> rand(2)
    0.8147    0.0975
    0.9058    0.2785
>> eye(5)
>> ones(3)
>> zeros(3)   % 可用于初始化
```

### 矩阵的合并、取行列

```MATLAB
>> a = [2 2; 5 8]
>> A=[a,a]
>> A=[a;a]
```

```MATLAB
>> a = [2 2; 5 8]
>> a(1, 2)                 % 第一行第二列，2
>> a(1,1:2)                % 2 2
>> a(1,:)                  % 2 2
>> a([1,2],:)              % 2 2; 5 8
>> a(end-1:end,:)          %% 取倒数两列，倒数第一行
>> A(1,:)=[]               %% 删除第一行，a = [5 8]
```

可以把矩阵变为线性矩阵：

```matlab
A = [1 2 3; 6 5 4];
A(:); %返回 [1 6 2 5 3 4]'
```

看起来没什么用，但是求矩阵元素和 `sum(A(:))`、最大值就很香了。

### 四则运算

1. `A\B` `B/A` (当A为方阵）等价于A^(-1)*B
2. （对应元素）点乘、点除、幂：`A.*A`，`A./B`，`A.\B`，`A.^B`，`A.^4`

### 矩阵变换

1. 转置：`A'`
2. 逆矩阵：`inv(a)`
3. 取对角变为列向量：`diag(A)`
4. 左右翻转：`fliplr(A)`
5. 将增广矩阵化为简化为阶梯形：`rrefA)`
6. 特征值、特征向量：`[V,D] = eig(A)`

$V^{-1} \cdot D \cdot V = A$

即$D$的对角线是特征值

## 编程语法

### 数据类型

`double`, `char`, `sym`, `struct`, `cell`  
数组以1开头（毕竟万物皆矩阵）

#### 取整函数

`ceil` 向上取整、`floor` 向下取整、`round` 四舍五入、`fix` 向零取整。

#### 强制转换

```MATLAB
c = char(49)
a = double('1')
```

#### 查询数据类型

```MATLAB
class(A)
% 返回数据类型名字的字符串khx
```

#### cell 数组

各元素可为不同类型tql

```MATLAB
a=cell{2,3}
a{4} = 'str'
a{1,2} = 123

class(a{4}) % == ‘str'
class(a(4)) % == 'cell'，注意区别
```

感觉有点鸡肋，但是 `strsplit` 能用。

#### 全局变量

MATLAB 脚本执行的时候，其**变量默认是既不跨文件，也不跨函数**的，只是在命令行中调用脚本，其变量会保留在命令行中。  

如在  `test.m` 中 `a=2; fun(1);`（`fun.m` 为 `function y=fun(x); a=1;`）以后，`a` 的值为 2。

如果需要全局变量，在声明和定义的部分都要写 `global a;`。

修改上述脚本得到：

```matlab
global a;
a=2;
fun(1);
disp(a);

function y=fun(x)
    a=1;
end
```

输出 1。

### 输入输出

```MATLAB
score=input('请输入您的成绩：')    %输入MATLAB表达式
name=input('请输入您的姓名：','s') %输入姓名
disp(a) 显示数组内容
fprintf('%6d', score)
str=sprintf('%6d',score)         %不能输出
```

转义字符：单引号`'`

貌似字符串的单双引号可以混用。

文件输入输出件另一篇[博客](../string-and-file-function)。

### 控制流程

#### for

```MATLAB
for a = 1:10          % for a = [array]
    string('njjnb')
end
```

支持 `continue` 和 `break`。

#### if

```MATLAB
if a == 1
    disp('1');
elseif a == 2
    sprintf("hehe");
else
    disp('233');
end
```

##### 逻辑运算符

`==`，`&`，`|`，`~`，`~=`

用不等号比较时，矩阵对应元素比较，得到的结果也是矩阵

#### switch

```MATLAB
switch name(1)
    case {'a','b','c','d','e','f','g','h'},
        disp(['Hello,',name])
    otherwise,
        disp(['Welcome,',name])
end
```

### 函数

MATLAB 函数好多啊，容易被绕进去。那我就不按教程讲叭。

函数这个词，有两个含义：
* 一个是数学上的含义，指数（数组）到数（数组）的映射；
* 第二个是编程意义上的，传入一个或多个参数，按规定执行某些操作，然后返回一个或多个参数。

原生 C 语言作为一种编程语言，只有第二种，因此概念不会混淆；

而 MATLAB 作为一个数学计算软件+脚本编程软件，两种函数都要有，
于是初学者就混淆了。

MATLAB 的**编程函数**有两种：[函数文件和子函数](函数文件和子函数)，具体区别放在后面。
MATLAB 的**数学函数**，网上都说有两种，分别是内联函数和匿名函数，但是我觉得要加上符号函数，一共三种。

> 在以后的版本中将会删除 `inline` 内联函数。请改用 匿名函数。  

因此对内联函数不做介绍，仅提供[官方文档](https://ww2.mathworks.cn/help/MATLAB/ref/inline.html)以查阅。

而匿名函数和符号函数呢，前者是可以代值运算的函数，后者是可以进行求导积分泰勒展开等等等等。

用比较形象的话来说，匿名函数就是 `f(x)=x^2`，而符号函数是 `y=x^2`。  
* 匿名函数可以求 `f(1)`、`f(2)` 等等，但是 `x` 并不是一个已经声明的符号（或者说，自变量），它只起了占位的功能，代值的时候就会被替换。  
* 而符号函数不能直接求 `y(1)`，而且需要提前声明 x 是符号（` sym x;`），但是它就可以进行求导等操作。
你可能会说，数学上，可以通过 `y=f(x)` 相互转换吖。确实，二者是可以互相转换的。具体方法在[后面](#匿名函数)提到。

#### 函数文件和子函数

函数文件是把函数作为模块，可以被其他程序调用，是模块化编程很重要的一点。  
而子函数是作为主函数的一部分，只能被主函数调用，不能被其他程序调用。

存储上，函数文件需要单文件存储。而子函数不用。  
如果涉及到了子函数，该文件所有函数（主函数和子函数）都需要写 `end`。

调用时，使用 `hello` 或 `test(1, 2)`。  

正常情况下，函数外的参数不能被使用，自变量也不能被修改。和 C 一样。  
若想要使用全局变量，在声明和使用变量时，都需要加 `global` 关键字，

```matlab
% hello.md
function ret = hello
disp('hello world');
ret = 1;
```

```MATLAB
% test.m
function r=test(r1, r2)
r = r1 + r2 + get_r3();
end
function r3 = get_r3
r3 = 2;
end
```

返回值可以为多参数。可以用 `nargin` 和 `nargout` 检测输入、输出参数个数。  
函数中支持 `return`。

```matlab
function [r, v]=myfun(x)
    r=x.^2;    %计算第1个输出参数
    if nargout>=2,
        v = 2*x; %计算第2个输出参数
    end
```

##### Function in Function

> 摘自：如何评价 MATLAB R2016b ? - winner245的回答 - 知乎
> https://www.zhihu.com/question/50662537/answer/122451045

在 MATLAB R2016b 以后，还支持在函数里面写函数，并且对于输入和输出相同的函数（即原地调用），性能会有优化。

```matlab
function main
tic, x = rand(1e8,1); toc
tic, y = notInplace(x); toc
tic, x = inplace(x); toc
isequal(x,y)

function y = notInplace(x)
y = 1.2*x; 

function x = inplace(x)
x = 1.2*x;
```

#### 匿名函数

[官方文档](https://ww2.mathworks.cn/help/matlab/matlab_prog/anonymous-functions.html)写的很好，就直接引用了。

> 匿名函数是一个 `函数句柄` （`function_handle`）（博主注：第一句话官方翻译的太烂了，我重新写了一下；函数句柄可理解为指向某个函数的指针，它并不存储这个函数）。匿名函数可以接受输入并返回输出，就像标准函数一样。但是，它们可能只包含一个可执行语句。  
>
> 例如，创建用于计算平方数的匿名函数的句柄：  
> `sqr = @(x) x.^2;`  
> 变量 `sqr` 是一个函数句柄。`@` 运算符创建句柄，`@` 运算符后面的圆括号 `()` 包括函数的输入参数。该匿名函数接受单个输入 `x`，并显式返回单个输出，即大小与包含平方值的 `x` 相同的数组。
>
> 通过将特定值 (5) 传递到函数句柄来计算该值的平方，与您将输入参数传递到标准函数一样。  
> `a = sqr(5)` 返回 25
>
> **许多 MATLAB® 函数接受将函数句柄用作输入**（博主注：无需创建符号变量 `syms`，直接调用即可~~不过貌似不多~~）。例如，通过将函数句柄传递到 integral 函数，计算 sqr 函数从 0 到 1 范围内的积分：  
> `q = integral(@(x) x.^2,0,1);`
>
> 可以对匿名函数嵌套：  
> `g = @(c) (integral(@(x) (x.^2 + c*x + 1),0,1));`  
> 上述 `g(2) == 3`。
> 
> 可以使用不带参数或多个参数的匿名函数：  
> `t = @() datestr(now); d = t()`  
>
> 匿名函数可以有多个返回值（本文作略，请查阅官方文档）。

`@` 还可以把一个程序函数变成一个函数句柄。  
如，定义 `function y=fun(x)`，就可以用 `g(@fun,1)` 跑遗传算法了。

匿名函数可以转化为符号函数：`f=@(x)x^2; syms x; y=f(x);`

符号函数可以转为匿名函数：`syms x; y=x^2; f=matlabFunction(y);`

## Matlab 自带函数

这都是查手册可以解决的事情，放在另一篇[博客](../MATLAB-functions)里了。

## 字符串与文件

参见另一篇博客：[MATLAB 字符串与文件](../string-and-file-function)。

## 符号编程

符号编程即 $y = ax^2 + bx + c$ 此类函数，并可以对其进行求极限、求导、积分等操作。

```MATLAB
syms x y n;
s = x^2 + y^2; subs(s,[x,y],[1,2])  % 替换变量（代值），返回 5

s = simplify(cos(x)^2-sin(x)^2)     % 化简表达式，返回 cos(2*x)

s = limit((1+1/n)^n, n, inf);       % 求极限，返回 exp(1)

s = symsum(1/factorial(x), 0, Inf)  % 求级数，返回 exp(1)

s = y^3+x^2; diff(s,y);             % 求（偏）导，返回 3*y^2
% 另有 diff(X,n,dim) 求 dim 阶导数

int(x^2);                           % 求积分，返回 x^3/3
% 另有 int(expr,var). int(expr,a,b),  int(expr,var,a,b) 的形式

taylor(exp(x),x,0,'order',3)        % 2阶泰勒展开，返回 x^2/2+x+1
```

分段函数：`pw = piecewise(cond1,val1,cond2,val2,...,otherwiseVal)`，如`y=piecewise(x<0,-x^2,x^2);`。

### 解常微分方程

```MATLAB
dsolve('Dy=(50-0.01*y)*y','y(0)=4','x'); % 二阶导的写法为'D2y'
```

## MATLAB 绘图

见 [MATLAB 绘图](../matlab-draw)。

## MATLAB显示

### 回显

不回显：使用分号 `;`  
回显：使用回车或逗号 `,`

### 显示模式

#### 分数模式

```MATLAB
format rat %% 分数模式
format %% 小数模式
```

#### 显示小数位数

```MATLAB
format long %%小数位数更多
format short %%回到短模式
```

### 清屏、清变量

```MATLAB
clc %% 清屏
clear
clear A B %% 清变量
```

### 暂停

```MATLAB
pause        %按任意键以继续
pause(0.5)
```
