---
title: C++ 命名空间
date: 2019-12-26 22:10:03
tags:
- 课程笔记
- C++
- 面向对象编程
- C++
- C++语法
category:
- C++
- C++语法
mathjax: true
---

> 命名空间是表达多个变量和多个函数组合成一个组的方法。主要是为了解决名字（类型、变量、函数名）冲突的问题。

## 定义命名空间

用一个例子来说明：在 `MyStudent.h` 和 `YourStudent.h` 中都定义了 Student 类，并在 main 函数中包含这两个文件。

```cpp
//MyStudent.cpp
class Student
{
public:
    void Show() {cout << "MyStudent"; };
};

//YourStudent.cpp
class Student
{
public:
    void Show() {cout << "YourStudent"; };
};

//main.cpp
#include"MyStudent.cpp"
#include"YourStudent.cpp"
int main()
{
    Student s;
    s.Show();
    return 0;
}
```

以上代码会报错：`Student 不明确`。

所以用 `namespace` 将两个代码分开：

```cpp
//MyStudent.cpp
namespace MyStudent
{
    class Student
    {
    public:
        void Show() {cout << "MyStudent"; };
    };
}

//YourStudent.cpp
namespace MyStudent
{
    class Student
    {
    public:
        void Show() {cout << "YourStudent"; };
    };
}

//main.cpp
#include"MyStudent.cpp"
#include"YourStudent.cpp"
int main()
{
    Student s;
    s.Show();
    return 0;
}
```

应该可以了。（注意 `namespace` 没有分号）

然而还是不行。因为没有指明用的是哪一个 namespace 的。

修改上一段的 `main.cpp`：

```cpp
//main.cpp
#include"MyStudent.cpp"
#include"YourStudent.cpp"
int main()
{
    MyStudent::Student ms;
    YourStudent::Student ys;
    ms.Show();
    ys.Show();
    return 0;
}
```

总算能正常使用了。

注意这个 `::` 符号，和类的也是一样，都是表明域运算符。

关于定义命名空间，再多说几句，namespace：

* 可以在**全局范围**定义
* 可以在**另一个 namespace 中**定义（形成嵌套 namespace）
* **不可以**在**函数、类的内部**定义

* 定义可以不连续、分段定义（和类一样）
* 甚至可以没有名字，但是就不能跨文件调用，起到了类似 `static` 的效果

## using 语句

还可以使用 `using namespace` 语句，使得 `using` 作用域里的代码使用该 namespace 时可以省略 namespace 的名称。

（这里的 `作用域` 遵循正常的范围规则：从使用 `using` 开始，直到范围结束）

继续修改上一例的 `main.cpp`：

```cpp
//main.cpp
#include"MyStudent.cpp"
#include"YourStudent.cpp"
using namespace MyStudent;
int main()
{
    Student ms;
    YourStudent::Student ys;
    ms.Show();
    ys.Show();
    return 0;
}
```

注意，如果在本例中对 `MyStudent` 和 `YourStudent` 都进行 `using`，会报最开始就提到的 `不明确` 的错。

也可以使用名称空间的部分内容：

```cpp
using std::cout;
```

## namespace std

C++ 标准语法库的所有代码都被包含在了 std 名称空间中。

这意味着，如果不指明名称空间，形如 `string` `sort` `cout` 的东西都无法使用。

所以，我们一般会在代码最开始，或 main 函数开头加一个 `using namespace std`，或者将所有需要的代码加上 `std::`。

另外，值得一提的是，如果在类中定义了和 C++ std 的同名成员函数，其他成员函数想调用 C++ std 函数的话，就可以加上 `std::`。如以下代码：

```cpp
class BigInteger
{
// ...
public:
    void rand()
    {
        int n = std::rand(); //调用的是 cstdlib 中的 rand，而不是 BigIntegr::rand
        rand(); //调用的是 BigInteger::rand()，会发生递归
    }
    void foo()
    {
        rand(); //调用的是 BigInteger::rand();
    }
}
```
