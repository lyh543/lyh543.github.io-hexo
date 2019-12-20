---
title: C++类型转换
date: 2019-9-17
tags:
- C++
category:
- C++
- C++语法
---

* 隐式类型转换就是编译器自动转；

* 显式类型转换类如 `(char)`

## C++的强制类型转换（nb）

C++中强制类型转换的几种形式

```c++
cast-name<type>(expression);
```

其中的cast-name可以为：

```c++
static_cast			//静态转换
dynamic_cast		//动态转换
const_cast			//常量转换
reinterpret_cast	//用于不相关的类型转换，如将int转换成指针等。
```

实例：搞掉 const

```c++
#include<iostream>
using std::cout;
using std::endl;
void sqrt(const int *x) {
	int *p=const_cast <int *>(x); //const_cast去掉了x的const限制
	*p=(*p) * (*p);		//p和x指向同一内存地址，即*p实际修改了*x
}
void sqr(const &x) {
	const_cast<int &>(x)=x*x;    //const_cast去掉了x的const限制后修改了x
}
void main(){
	int a=5;
	sqrt(&a);         		//通过指针将a改为25
	cout<<a<<endl;   		//输出25
	sqr(a);           			//通过引用将a改为625
	cout<<a<<endl;    		//输出625
}
```
