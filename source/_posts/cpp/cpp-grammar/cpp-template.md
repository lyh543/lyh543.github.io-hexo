---
title: cpp-template.md
date: 2019-12-26 22:07:45
tags:
- 课程笔记
- C++
- 面向对象编程
category:
- C++
- C++语法
mathjax: true
---

> C++ 最重要的特征之一就是 **代码重用**。

所以有了这么一个东西，可以

> 不受数据类型的影响。可以将数据类型也参数化（又叫参数化程序设计）。

于是就产生了了模板。从`模板`的字面义来看，有了模板应该就可以自动“产生”一堆类似的东西。

## 函数模板

比如我们要写最大值的函数，可能要写：

```cpp
int max(int a, int b){return a > b ? a : b};
float max(float a, float b){return a > b ? a : b};
//更多的类型对应的函数。。。。
```

但是很麻烦，而且加大代码维护难度。

一个替代方案是宏定义，但是宏定义很容易出锅。

因此，C++ 把数据类型也作为一个参数：

```cpp
template <class T>
    T max(T a, T b){return a > b  ? a : b};
```

我好了。

这样，对于需要调用 `max` 函数的任意类，只要定义了类间的 `>` 符号，即可直接运行。

对于比较 `int` 和 `char` 类型的，就不能调用上面的模板了。

其实，还可以以下写：

```cpp
template <class X, class Y>
    X max(X a, Y b){return a > b ? a : b};
```

### 函数模板的匹配

当一个函数有多个模板可以使用的时候，该使用哪个呢？

比如以下代码：

```cpp
int max(int a, int b){cout << "Template Function Used!\n"; return a > b ? a : b};
template <class T>
    T max(T a, T b){cout << "Simple Function Used!\n"; return a > b  ? a : b};
```

对于 `max(1, 2)`，该调用谁呢？

重载函数的最下匹配遵循以下优先原则：

> 1. 完全匹配时，普通函数优于模板函数；
> 2. 提升转换（如 `char` to `int`、`short` to `int`、`float` to `double`）
> 3. 标准转换（如 `int` to `char`、`long` to `double`）
> 4. 用户定义的类型转换

对于这部分，书上讲的貌似不是特别清楚~~但是期末了没时间深究了，先挖个坑~~

## 类模板

由于 C++ 的 `vector` 是用类模板实现的，我们从 `vector` 入手讲讲模板。

定义过程应如下：

```cpp
template <class T> class vector
{
private:
    T * beginPointer;
public:
    T * begin();
    //...
}
```

在类外定义 `begin()` 函数，应为：

```cpp
//template <模板形参列表> 返回值 类名<模板形参> :: 函数名()
template  <class T> T * vector<T>::begin()
{
    return beginPointer;
}
```
