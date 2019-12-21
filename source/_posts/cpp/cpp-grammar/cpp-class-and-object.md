---
title: C++ 面向对象——类与对象
date: 2019-09-10 7:55:13
tags:
- 课程笔记
- C++
- 面向对象编程
category:
- C++
- C++语法
mathjax: true
---

## 类的定义

类（Class）其实和 C++ 结构体差不多。

```c++
class ClassName
{
    public:
        //公有成员
        void setTime(int h, int m, int s);
        void showTime(){...} //在类内部实现成员函数
    protected:
        //保护型成员
    private:
        //私有成员
        int h, m, s;
}

void ClassName::setTime(int h, int m, int s)
{
    ...
} //在类外部实现成员函数
```

`public`，`protected`，`private` 叫做`段约束符`。
`private` 和 `protected` 只允许类的内部成员访问。`protect` 和 `private` 在[派生](../inheritance-derive-polymorphism/#保护成员-和-继承方式：公有继承、私有继承、保护继承)的地方不同。不写段约束符时，成员默认是 `private` 的。

三个段约束符的顺序可换；  
可以把公开成员分开写，需要用多个 `public` 约束。

`::` 叫做`作用域分辨符`。

## 类成员的定义、使用

和 `struct` 完全一样。`.`，`->`。略。

对了，以类声明的变量叫做 `对象`（Object）。

### 静态数据成员

```c++
class ClassName
{
    public:
        static int s_value; //声明
        static const int cs_value = 10; //常量：声明+定义
        int value;
}
int ClassName s_value = 10; //定义
```

`ClassName` 的对象各自有成员 `value`，但他们共同拥有成员 `s_value`。

对于非常量的静态成员，必须在类内声明，类外定义（常量定义可以写在里面或外面）。

静态成员函数[见后](#静态成员函数)。

### const 数据成员

`const` 数据一般是不可以被修改的，理应每个类的成员的值都一样，是可以共用以节省空间的。实际呢？

如果把一个数据设为 `const` ，他会自动变为 `static` 吗？

```c++
class Test
{
public:
	const int c = 10;
}A, B;

int main()
{
	std::cout << &A.c << " " << &B.c;
}
```

输出 `00007FF64CC64034 00007FF64CC64038`。显然是没有共用的，必须加 `static` 才可以共用内存。

### 类类型本身、指针、引用作为函数参数

```c++
void setTime(ClassName o);    //类对象作为参数，会有拷贝构造函数
void setTime(ClassName * po); //对象指针作为参数
void setTime(ClassName & ro); //对象引用作为参数
```

## 类的成员函数

这部分简单，不多说。

### 构造函数

在声明一个对象，或 `new` 一个对象的时候，会触发构造函数。

（注意 `malloc` 不会）

已经有的对象可以通过新建一个对象，然后赋值过去。

```cpp
CString A;
A = CString();
```

#### 一般构造函数

```c++
class CString
{
    //...
    public:
        CString(){...}; //该函数即为构造函数
}

CString aStr;   //调用构造函数
aStr.CString(); //也会调用构造函数
```

#### 重载构造函数

```c++
class CString
{
    //...
    public:
        CString(){}
        CString(int n)
        {
            if (n > 0) {size = n; buf = new char[n]};
        }
        CString(const char * str)
        {
            size = strlen(str) + 1;
            buf = new char[size];
            strcpy(buf, str);
        }
}

CString str1;       //调用 CString()
CString str2(2);    //调用 CString(int)
CString str3("3");  //调用 CString(const char *)
```

定义函数要 `{}`，就不用打 `;` 了，声明函数要打 `;`。~~这不是 C 语言基础吗~~

#### 拷贝构造函数

当使用 `CString str2 = str1;` 时，编译器实际上调用了默认的 `CString(CString &)` 拷贝构造函数，把 `str1` 的内容通过**位拷贝**，复制给了 `str2`。  

同时，拷贝构造函数也是将 `const CString &` 强转为 `CString` 的方法。

如果我们不想这么做，而是手动复制部分数据，可以使用：

```c++
class CString
{
    //...
    public:
    CString(CString &)}{...};
}
```

注意 `CString str2 = str1;` 和 `CString str2; str2 = str1;` 是有区别的！！！

函数类型|函数原型|调用场景
-|-|-
强制转换|`int ()`|`int(A);` 和 `int i = A;`（隐式）
拷贝构造函数|`CString(const CString &)`|`CString B = A;` 和 `return A;`
赋值函数|`CString& operator = (const CString &)`|`Cstring B; B = A;`

二者是不同的。

所以，重载拷贝构造函数的时候，要思考是否同时需要重载赋值函数。

#### 类到其他类型的强制转换

既然提了把其他结构转为这个类的方法，那就顺便说说把这个类转为其他的结构吧。

把 `int` 当作一个一元操作符可还行。

```c++
class teamS {
private:
    int s; //solved
    int p; //penalty
public:
    operator int()
    {
        return s * 100 - p;
    }
};
```

### 析构函数

函数结束后，函数中声明的对象的内存会被释放，但对象申请的动态内存不会。  
因此需要一个析构函数，这样，声明对象的函数运行完以后，即会执行析构函数，然后再释放对象的内存，最后退出函数。

```c++
class CString
{
    //...
    public:
        ~CString() //该函数即为构造函数
        {
            if(buf) delete []buf;
        };
}
```

以下场景会触发对象的析构函数：

* 声明对象的函数运行结束；
* 指向对象的指针被 `delete` 时。(`free` 不会）

这样以后，程序猿就不用再考虑什么时候对象不再使用，得释放内存了。

### this 指针

在调用成员函数的时候，我们发现如果使用其他对象的成员需要加 `对象->`，而使用自己的成员却不需要。  
而调用不同对象的同一个成员时，编译器不会弄混用的是谁的成员。这是因为：**编译器对成员函数隐含加上了 `this` 形参。**

因此调用某对象的成员函数时，使用该对象的成员不需要加对象名和 `->`（也可以加 `this->`）。

需要返回该对象（或该对象的引用）时，使用 `*this` 即可。

### 静态成员函数

静态成员函数与众不同的地方在于，它没有 `this` 参数。声明仅仅是在返回类型前加了一个 `static`。

```c++
class CString
{
    int maxn;
    public:
        static int maxlength(){return maxn;}
}
```

### 友元函数 友元类

对于某些需要封装过的数据的函数，调用这些数据不大容易。因此，产生了友元的机制。

友元函数是让**类外的函数**可以访问到类的 private 成员；  
友元类是让类下的所有函数可以访问前一个类里的 private 成员。

注意友元函数是**类外的函数**，因此没有 `*this` 参数，且不用 `ClassName::` 作用域符。（不过定义部分还是可以写在声明后面）

```c++
class Y; //前向声明
class X
{
    //...
    friend operator >> (istream & in, X & x);
    friend class Y; //类 Y 是 X 的友元
}

operator >> (istream & in, X & x){ /*...*/ }

class Y
{
    //Y 的成员函数可随意调用 X 的 private 成员
}
```

友元类没有对称性、传递性。

友元函数虽然方便，但是破坏了 OOP 的封装性，不能滥用。

## 类的组合

一句话，就是一个类的某个成员是另一个类的对象。

注意构造函数和析构函数一般需要调用包含的类的构造和析构函数，否则无法修改前一个类的 `private` 成员。  
具体语法如下：

```c++
class Point{
    int x, y;
    public : Point(int _x, int _y){x = _x; y = _y;}
    /*...*/
}

class Circle
{
    Point center;
    int radius;
    Circle(int _x, int _y, int _radius) : Point(_x, _y)
    {
        radius = _radius;
    }
}
```


## const  对象、函数

一句话，const 对象不能被非 const 的成员函数调用。

```c++
const CString str; //常对象
int CString::size() const 
{
    /*...*/
}; //常函数
```

