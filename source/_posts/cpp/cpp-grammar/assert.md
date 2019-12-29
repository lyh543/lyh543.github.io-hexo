---
title: assert
date: 2019-8-1
tags:
- C++
category:
- C++
- C++语法
mathjax: true
---

## 用途

最初看到 `assert`，是在 ACM 时，看到的别人的高精度板子，限定了除数大于0：

```c++
assert(b>0)
```

但是感觉没什么用：如果 此时不等于 0，程序立即停止（`abort`）并返回一个非 0 值，就算 RE 了， 好像没什么用。

直到看《编程珠玑》的时候看到了它的用处：

断言的意思是，按照我为我的代码设定的逻辑，这种情况是绝对、永远为 true，如果是 false 就是代码出 bug 了。

它的作用是：它能限定当前程序的状态（如果和预期不一样就会报错），一方便是方便调试（能让程序一直保持在正确等状态下），另一方面是能让其他人理解自己的程序。

## 语法

该函数在 `<assert.h>` 或 `<cassert>` 中。

```c++
assert(bool)
```

可以这么用：

```c++
assert(i >= 0 && i < n)
```

还可以把布尔判断式写成一个 `bool` 类型的函数。

```c++
bool isSorted(int * arr, int n)
{
    for (int i = 0; i < n - 1; i++)
        if (arr[i] >= arr[i+1]) return false;
    return true;
}
assert(isSorted(arr, n));
```

### 禁用所有 `assert`

甚至还有一行关掉所有 `assert` 语句的方法：

```c
#define NDEBUG
```

## `assert()` 的涉及用法

1. 捕捉逻辑错误。可以在程序逻辑必须为真的条件上设置断言。除非发生逻辑错误，否则断言对程序无任何影响。即预防性的错误检查，在认为不可能的执行到的情况下加一句 `assert(0)`，如果运行到此，代码逻辑或条件就可能有问题。
2. 程序没写完的标识，放个 `assert(0)` 调试运行时执行到此为报错中断，好知道成员函数还没写完。

## Which one: 断言、异常处理和 return false

当程序遇到预期可能的错误时，可以进行断言、[异常处理](../cpp-exception-handling.)和返回一个错误返回值表示执行错误。那么到底该选择哪个呢？

[知乎](https://www.zhihu.com/question/23669218)上有这个问题。结论基本是：

* 三个词可以分为两类：一类是 `assert`，另一类是异常处理和返回错误值。因为 `assert` 应当是程序出了 bug 才会触发（程序应当“留下证据然后立即自爆”），另两个可能是用户输入了错误的内容触发的。应当修改错误或者引导用户进行正确输入。
* 针对采用return value 还是 exception，没有一定的结论。[Stack Overflow](https://stackoverflow.com/questions/99683/which-and-why-do-you-prefer-exceptions-or-return-codes) 有一个针对这个问题的讨论，不过基本上没有结论，我比较喜欢的是抛出异常会强迫调用者处理，返回值则不会。无论那种，基本上都要有一堆的处理语句。[来源](https://www.zhihu.com/question/23669218/answer/28175134)