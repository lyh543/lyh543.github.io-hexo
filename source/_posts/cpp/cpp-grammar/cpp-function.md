---
title: C++ 函数
date: 2019.9.2
tags: 
- C++
category:
- C++
- C++语法
---

## 函数原型

函数原型就是函数声明，常放在头文件里。

## 函数参数

`f(void)==f()`

`f(int*)==f(int[])==f(int[10])`

## 默认参数

* 在声明或定义中写默认参数，声明中必须写（不然人家咋知道调用的是谁呢）

```c++
double sqrt(double f=1.0);
void main(){
	cout<<sqrt()<<endl;
}
double sqrt(double f) {
	return f*f;  
}
```

一旦某个参数开始指定默认值，它右边的所有参数都必须指定默认；
一旦某个参数开始取默认值，它右边的所有参数都必须取默认；

```c++
int f(int i1,int i2=2,int i3=0);	//正确
int g(int i1,int i2=0,int i3);	//错误

f(3);               	//正确，i1=3,i2=2,i3=0
f(1,,3);              	//错误
```

### 引用的作用域

不同作用域内，允许说明不同的默认形参值。

```c++
int add(int x = 5, y = 6);
int main()
{
	int add(int x = 7, y = 8);
	add(); // return 15
}
int add(int x, int y)
{
	return x + y;
}
```

## 函数和引用

### 传递引用

* 需要从函数中返回多于一个值。
* 需要修改实参值本身。
* 传递地址可以节省复制大量数据的内存空间和时间。

### 返回引用

`int & index(int i){return a[i];}`

有了引用，甚至能写这种骚代码：

`index(2) = 30;`

## 内联函数

加 `inline` 即可。能够节省开销。

内联函数不允许有循环和 `switch` 语句，否则按照普通函数来处理。

## 结构、类的成员函数

具体见[结构的博客](../struct/)。
