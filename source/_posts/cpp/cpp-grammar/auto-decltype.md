---
title: auto 和 decltype 类型
date: 2019-8-17
tags:
- C++
category:
- C++
- C++语法
---

## auto

```c++
auto i = 1;
```

### auto 和 const 引用

引用字面常量需要手动 `const`，引用类型常量就自带 `const` 了

```c++
int i;
const int ic = I;

auto &ri = i;			// int &ri=i
auto &rc = ic;			// const int &rc=ic, 顶层const

auto &r0=4.3			//错误，不能够将非常绑定到常数
const auto &r1=4.3		//正确
```

一条auto可以同时定义多个变量，但数据类型只能有一种。

```c++
auto x = 3, y = 12, z = 30;         //正确，x,y,z为int类型
auto a = 3, b = 3.2;                //错误，a和b的类型不同
```

## decltype

```c++
deltype(表达式1) 变量=表达式2；
deltype((表达式1)) 变量=表达式2;     //定义引用
```

从表达式1的结果类型定义变量，并用表达式2的值初始化量。

~~当表达式1是变量时，decltype不会忽略顶层const，其结果是定义与表达式1相同类型的变量（包括顶层const和引用在内）。~~ 不懂

用双重括号把表达式括起来时，定义的一定是引用。而用单括号时，只有当变量本身是引用时，定义的才是引用。

### decltype 和 const 引用

引用字面常量和常量表达式需要手动 `const`，引用类型常量就自带 `const` 了

样例：

```c++
int i = 10, j,*p=&i,&r=i;
const int ic = i,&cj=ic;
decltype(i + 3.4) x = 9;	// double x;
decltype(ic + 3) y1;		// int y1;
decltype(ic) y2 = 4;		// const int y2=4;
//decltype(ic) y3;			// 错误，const int y3
decltype(p) p1;				// int *p1
decltype((i)) ri = j;		// int &ri=j
decltype(*p) rp = i;		// int &rp=i
```

### atuo decltype 和 数组

在处理数组的问题上，auto将对象定义为指向数组第一个元素类型的指针，decltype采用与数组完全相同的类型变定义数组。

```c++
int a[] = {1,2,3,4,5};
auto p1 = a;		// 等价： int *p1
decltype(a) p2;		// 等价： int p2[5]
```
