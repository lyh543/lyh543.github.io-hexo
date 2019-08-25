---
title: C++函数
category:
- C++
- C++语法
---

## 函数原型

函数原型就是函数声明，常放在头文件里。

## 函数参数

`f(void)==f()`

`f(int*)==f(int[])==f(int[10])`

## 传递引用

* 需要从函数中返回多于一个值。
* 需要修改实参值本身。
* 传递地址可以节省复制大量数据的内存空间和时间。

## 默认参数

* 在声明或定义中写默认参数

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

## 返回引用

`int & index(int i){return a[i];}`

有了引用，甚至能写这种骚代码：

`index(2) = 30;`
