---
title: 指针 pointer & 引用 reference
date: 2019-9-2
tags:
- C++
- 指针
- 引用
- C++
- C++语法
category:
- C++
- C++语法
---

## 指针和变量的存储方式

每个指针指向的是第一个字节，但是数是倒着存的（第一个字节是最低位）。如存一个`int i=1024`，再从第二个字节开始读，结果是4（当然先要清掉周围的内存）。

测试代码及输出：

```c++
#include<bits/stdc++.h>
using namespace std;
int main()
{
       int i[10] = { 0,1024}, *pi = &i[1];
       cout << pi << " " << *pi << endl;
       pi = (int*)(int(pi) + 1);
       cout << pi << " " << *pi;
}

/*
输出：
00C3FD04 1024
00C3FD05 4
*/
```

## 指针和 const

![pointer and const](pointer_and_const.png)

const 先向前看，没有就再向后看？

## 函数指针

```c++
//正确用法：
int (*f)(int,char);  // f是指向“具有两个参数，返回 int 的函数”的指针
int (*f)(void);
int (*f) (ostream&, const vector<string>&); //例三

//错误用法：
int *f(int)         // f是一个函数，返回一个“指向 int 的指针”
int *f(void)        // 参数是 void 也得写
```

使用时直接 `f(x)` 即可。`f` 又被称为回调函数(callback function)。

例三的 `f` 的变量类型为 `int (*) (ostream&, const vector<string>&)`。

C++ 11 中 `NULL`，`0`，`nullptr` 等价。

## void * 指针

void * 指针只表示与它相关的值是个内存地址，但该内存的数据类型是未知的。它是能够接受任何数据类型的特殊指针。
**void * 最重要的用途是作为函数的参数，向函数传递一个类型可变的对象。另一种用途就是从函数返回一个无类型的对象。**
在**使用void * 指针之前，必须显式地将它转换成某种数据类型的指针后使用**，其他操作都不允许。（可以使用，不能赋值）

```c++
  int i=4,*pi=&i;
  void* pv;
  double d=9,*pd=&d;
  pv=&i;        //L1：正确
  pv=pi;        //L2：正确
cout<<*pv<<endl;  //L3：错误
  pv=pd;        //L4：正确
  cout<<*(double*)pv;  //L5：正确，输出9
```

## begin 和 end (C++11)

<iterator>头文件的两个函数，用于确定指向数组首元素和尾元素后一位置的指针，方便遍历数组。

```c++
int a[] = { 1,2,3,4,5,6,7,8,9,10 };
for (int *p = begin(a); p != end(a); p++)
{
    //...
}
```

对于容器的用法有：

```c++
stack<int> s;
for (auto &i : s)
{
    //i
}

for (auto iter = s.begin(); iter != end; iter++)
{
    //*iter
}
```

## 动态内存

### malloc & free from C

```c++
#include <cstdlib>
int main()
{
int * a;
a = (int*)malloc(sizeof(int));
*a = 3;
free(a);
}
```

### new & delete (C++)

`new` 用于从内存中分配指定大小的内存
用法 1：`p=new type;`
用法 2：`p=new type(x);`
用法 3：`p=new type[n];`
`delete` 用于释放 `new` 分配的堆内存
用法 1：`delete p;`
用法 2：`delete [ ]p;`

注意对 `int` 数组，`delete p` 和 `delete [] p` 效果一样。但若把 `int` 换成自定义的类型，则 `delete p` 只释放第一个元素的内存，`delete [] p` 才释放全部内存，因为 **`delete` 后就会走析构函数，基本类型的对象没有析构函数，所以回收基本类型组成的数组空间用  `delete` 和 `delete[]` 都是可以的；但是对于类对象数组，只能用 `delete[]`**。总之保证 `new delete` 的 `[]` 的配套使用。

### new/delete 与 malloc/free的区别

* new 能够自动计算要分配的内存类型的大小，不必用 sizeof 计算所要分配的内存字节数
* new 不需要进行类型转换，它能够自动返回正确的指针类型。
* new 可以对分配的内存进行初始化。
* new 和delete 可以被重载，程序员可以借此扩展new和delete的功能，建立自定义的存储分配系统。

## 智能指针

自动回收所指对象，无需调用delete回收。

需要包含头文件 `memory`

* auto_ptr ：动态分配对象以及当对象不再需要时自动执行清理，构造时获取对某个对象的所有权，在析构时释放该对象，两个指针不能同时拥有同一个对象；

```c++
int*p = new int(0);
auto_ptr<int> ap(p);
auto_ptr<int>ap2(new int(10));

*p = 5;
cout << *p << "  " << *ap << endl;

auto_ptr<string> p1(new string("There is only one point to me."));
auto_ptr<string> p2;
p2 = p1;                     //L1，p1不再指向任何对象，其所指对象由p2指向
cout << *p1;                //L2，发生运行错误，因为p1没有指向任何对象。
```

* shared_ptr：作用有如同指针，但会记录有多少个shared_ptrs共同指向一个对象。最后一个这样的指针被销毁，也就是一旦某个对象的引用计数变为0，这个对象会被自动删除。
* unique_ptr：它持有对对象的独有权——两个unique_ptr不能指向一个对象，不能进行复制操作只能进行移动操作

## 引用

分为：

1. 左值引用：`int & a = b;`
2. 右值引用：`int && a = 3+1;`

* 引用不是值，不占用存储空间，引用的地址就是其所引用的变量的地址
* 引用必须被初始化，且不可重新赋值
* 可以建立数组或数组元素的引用，但**不能建立引用数组**

```c++
int i = 0, a[10] = { 1,2,3,4,5,6,7,8,9,10 }, *b[10];
int (&ra)[10] = a;        //L1：正确，ra是具有10元素的整型数组的引用
int *(&rpa)[] = b;          //L2: 错误！！！！
int *(&rpa)[10] = b;      //L3：正确，rpa是具有10个整型指针的数组的引用
int &ia[10]=a;               //L4：错误，ia是引用数组，每个数组元素都是引用
```

**注意数组引用要注明长度！！！！！**

**由 `int *(&rpa)` 可以看出，指针的`*` 是连着 `int` 的，引用的 `&` 是连着 `变量名` 的。**

### 函数和引用

参见这篇[引用](../C++函数/函数和引用)的博客。

### 右值引用

右值引用是C++11为了支持移动操作而引入的新型引用类型，其重要特点就是只能绑定到即将（~~瞬间~~）销毁的对象上，比如常量或表达式。通过右值引用可以方便地将它引用的资源“移动”到另一个对象上。

右值引用存的是表达式的值（表达式中变量变化不改变其值）

`double && rr = r;` 是错的。

### const 和引用

`const` 引用其实和右值引用差不多，变量修改不会改变引用值了。

### 题外话：指针和引用谁好？

C 只有指针，没有引用；Java 只有引用，没有指针；C++ 二者皆有（C++ 和 Java 的引用不同，但在此不表）。

那么，指针和引用谁好呢？
