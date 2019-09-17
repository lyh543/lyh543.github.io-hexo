---
title: Matlab编程
date: 2019-7-7
tags:
category:
- Matlab
mathjax: true
---

## 构造矩阵

```matlab
>> a = [2 2; 5 8]
2 2
5 8
>> 1:2:10
1 3 5 7 9
>> 1:5
1 2 3 4 5
>> linspace(1,2,10)
1.0000    1.1111    1.2222    1.3333    1.4444   1.5556    1.6667    1.7778    1.8889    2.0000
```

`1:5` 语法是闭区间，和 Python 左闭右开不一样。

### 构造常见矩阵

```matlab
>> rand(5)
    0.8147    0.0975
    0.9058    0.2785
>> eye(5)
>> ones(3)
>> zeros(3) % 可用于初始化
```

### 矩阵的合并、取行列

```matlab
>> a = [2 2; 5 8]
>> A=[a,a]
>> A=[a;a]
```

```matlab
>> a = [2 2; 5 8]

>> a(1, 2) % 第一行第二列，2

>> a(1,1:2) % 2 2

>> a(1,:) % 2 2

>> a([1,2],:)
2 2
5 8

>> a(end-1:end,:) %% 取倒数两列，倒数第一行

%%删除第一行（？？？？）
>> A()
```


### 四则运算

1. `A\B` `B/A` (当A为方阵）等价于A^(-1)*B
2. （对应元素）点乘、点除、幂：`A.*A`，`A./B`，`A.\B`，`A.^B`，`A.^4`

### 矩阵变换

1. 转置：`A'`
2. 逆矩阵：`inv(a)`
3. 取对角变为列向量：`diag(A)`
4. 左右翻转：`fliplr(A)`
5. 将增广矩阵化为简化为阶梯形：`reff(A)`
6. 特征值、特征向量：`[V,D] = eig(A)`

$$V^{-1} \cdot D \cdot V = A$$  
即$D$的对角线是特征值

## 编程语法

### 数据类型

`double`, `char`, `sym`, `struct`, `cell`  
数组以1开头（毕竟万物皆矩阵）

#### 强制转换

```matlab
c = char(49)
a = double('1')
```

#### 查询数据类型

```matlab
class(A)
% 返回数据类型名字的字符串khx
```

#### cell数组

各元素可为不同类型tql

```matlab
a=cell{2,3}
a{4}
a{1,2}
```

### 输入输出

```matlab
score=input('请输入您的成绩：')    %输入matlab表达式
name=input('请输入您的姓名：','s') %输入姓名
disp(a) 显示数组内容
fprintf('%6d', score)
str=sprintf('%6d',score) %不能输出
```

转义字符：单引号`'`

### 控制流程

#### for

```matlab
for a = 1:10          % for a = array
    string('njjnb')
end
```

支持 `continue` 和 `break`。

#### if

```matlab
if a == 1
    disp('1')
elseif a == 2
else
    disp('233')
end
```

##### 逻辑运算符

`==`，`&`，`|`，`~`，`~=`

用不等号比较时，矩阵对应元素比较，得到的结果也是矩阵

#### switch

```matlab
switch name(1)
    case {'a','b','c','d','e','f','g','h'},
        disp(['Hello,',name])
    otherwise,
        disp(['Welcome,',name])
end
```

### 函数

需要分文件存储

```matlab
function r=sum2(ri, r2)
r = r1 + r2
```

## 统计函数

### 向量的元素和/矩阵的每列和

```matlab
sum(A)
min(A)
max(A)
mean(A)

[x, l] = min(A) % 顺便把最小值位置给l

sum(A,2) % 矩阵的每行和/平均数
```

### 向量长度、矩阵大小

```matlab
length(V)
size(A) %返回一个1x2数组
```

### 列排序（返回数列、原数列元素在新数列的index）

```
[B I] = sort(V)
[B I] = sort(V,'descend') %降序
```

### find

很重要很重要！！

## 数学运算

### 定义数学函数

```matlab
f1=@(x)x^2
f2=inline('X^2') //教材版本
f1(x)
% 类似于define f1(int x)(return 0;)
% 或typedef
```

### 替换变量（代值）

```matlab
syms x y;
s = x^2 + y^2
subs(s,[x,y],[1,2]);
```

### 化简表达式

```matlab
syms x y;
s = simplify(cos(x)^2-sin(x)^2)
```

### 求极限

```matlab
syms n;
s = limit((1+1/n)^n, n, inf);
```

### 求导

```matlab
syms v;
s = v^3+x^2;
diff(s,'v');
diff(s,'v',n)
```

### 积分

```matlab
syms x;s = x^2;int(s)
```

### 泰勒展开

```matlab
taylor(exp(x),x,0,'order',8) %7阶
```

### 解常微分方程

```matlab
dsolve('Dy=(50-0.01*y)*y','y(0)=4','x'); % 二阶导的写法为'D2y'
```

## Matlab绘图

### plot

```matlab
xx = linspace(0, 2*pi, 100);
yy = sin(xx);
plot(xx,yy);
```

### ezplot

```matlab
ezplot(sin(x)/x);
ezplot(t,t^2,[1,2]);
```

## Matlab显示

### 回显

不回显：使用分号 `;`  
回显：使用回车或逗号 `,`

### 显示模式

#### 分数模式

```matlab
format rat %% 分数模式
format %% 小数模式
```

#### 小数位数

```matlab
format long %%小数位数更多
format short %%回到短模式
```

### 清屏

```matlab
clc %% 清屏
clear
clear A B %% 清变量
```
