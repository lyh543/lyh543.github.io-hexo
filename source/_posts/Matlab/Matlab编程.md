---
title: Matlab编程
tags:
category:
- Matlab
mathjax: true
---

[学习目录](../Matlab学习目录)

## 数据类型

`double`, `char`, `sym`, `struct`, `cell`  
数组以1开头（毕竟万物皆矩阵）

## 强制转换

```matlab
c = char(49)
a = double('1')
```

## 查询数据类型

```matlab
class(A)
% 返回数据类型名字的字符串khx
```

## cell数组

各元素可为不同类型tql

```matlab
a=cell{2,3}
a{4}
a{1,2}
```

## 输入输出

```matlab
score=input('请输入您的成绩：')    %输入matlab表达式
name=input('请输入您的姓名：','s') %输入姓名
disp(a) 显示数组内容
fprintf('%6d', score)
str=sprintf('%6d',score) %不能输出
```

转义字符：单引号`'`

## for

```matlab
for a = 1:10          \% for a = array
    string('njjnb')
end
```

## if

```matlab
if a == 1
    disp('1')
elseif a == 2
    disp('2')
else
    disp('233')
end
```

## switch

```matlab
switch name(1)
    case {'a','b','c','d','e','f','g','h'},
        disp(['Hello,',name])
    otherwise,
        disp(['Welcome,',name])
end
```

## 逻辑运算符：

```matlab
&    %AND
|    %OR
~    %NOT
~=   %NOTEQ
```

用不等号比较时，矩阵对应元素比较，得到的结果也是矩阵

```matlab
>> x=rand(1,5)>rand(1,5)

x =

  1×5 logical 数组

   0   0   0   0   1
```
