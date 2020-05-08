---
title: C# 入门笔记
date: 2020-05-08 10:35:28
tags:
- C#
- 编程语言入门
category:
- C#
mathjax: true
---

> 本篇的链接：https://docs.microsoft.com/zh-cn/learn/paths/csharp-first-steps/
> 该教程浅显易懂，挺适合零基础编程基础的同学。
> 当然也可以去看微软的其他入门教程。

## Hello World!

以下为一段 C# 代码的完整框架。

```cs
using System;

namespace CSharp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
```

注意，C# 严格区分大小写。因此，不能使用 `console.WriteLine` 或 `Console.writeline`。

该函数在末尾自带 `\n`，等价于 `Console.Write("Hello World!\n")`。

## 变量和数据类型

### 数据类型

数据类型|中文|代码中的写法|输出时的写法
-|-|-|-
`string`|字符串|`"Hello world!"`|`Hello world!`
`char`|字符|`'H'`|`H`
`int`|字整数|`123`|`123`
`decimal`|十进制文本|`12.3m`|`12.3`
`bool`|布尔类型|`true false`|`True Fause`

```cs
Console.WriteLine(true);
```

该语句会输出 `True`。

### 声明变量

```cs
string firstName;
```

变量名称的规则和 C++、Python 等语言类似：

* 不许使用特殊字符
* 不能数字开头
* 不能是关键字
* 区分大小写

下面是一些约定：

* 推荐使用 CamelCase，如 `thisIsCamelCase`。
* 请勿使用缩写（约定好的缩写除外，如 `msg`）
* 变量名不应包含其数据类型，如 `string strValue;` 是不被推荐的。这可能是强大的 Visual Studio 能够通过智能感知查到变量名的类型。原文如下：

> 你可能会看到使用类似 `string strValue;` 样式的一些建议。这是几年前的热门样式。但是，大多数开发者不会再遵循此建议。

### 使用变量

在对变量赋值前使用变量，会报错。

对变量赋值的方法和 C++ 相同。

```cs
string message = "123";

string msg2;
msg2 = "213";
```

### var 类型

```cs
var msg = "this is a message";
```

`var` 和 C++ 的 `auto` 一样，在初始化的时候，编译器根据等号右边的值的类型（在这里是 `string`），将变量名声明为相同类型。

注意这些都是在编译阶段完成的，也就是说，不能在之后改变其数据类型，再将 `int` 值赋给 `msg`。

另外，`var` 变量必须在使用的时候进行初始化。

`var` 变量被叫做隐式类型本地变量。

为什么使用 `var` 类型呢？

> var 关键字已被 C# 社区广泛采用，因此，如果你查看书籍或联机中的代码示例，很有可能会看到使用的是 var 关键字，而不是实际的数据类型名称。因此，我们想确保在此模块中将它引入。  
> 但 var 关键字在 C# 中具有重要用途。由于在编写高级代码之前你可能不甚了解，因此在某些情况下，初始化变量时，数据类型可能不太明显。实际上，在某些情况下， C# 可能会为代码提供一种新的数据类型，并可能无法提前为其指定可预测的命名。再说一次，这是 C# 的一项高级功能，我们将在其他模块中进行介绍。  
> 开始之际，我们建议声明变量时继续使用实际的数据类型名称。声明变量时使用数据类型有助于你有目的性地编写代码。

## 基本字符串格式设置

这部分的内容很少有教程在刚开始的时候专门用一节提过，但是个人认为很有必要。

### 转义字符

和其他编程语言一样 `\n` `\t` `\"` `\\` 等都是支持的。

C# 的 `\u` 是 utf-16 编码。如下面的代码：

```cs
Console.WriteLine("\u4f60\u597d，世界！");
```

会输出 `你好，世界！`。

### 逐字字符串

不少语言都支持 `跨行字符串` （或 `verbatim string literal` `raw string` `字符串字面量`）这一特性，即在写字符串的时候加一定的前缀、后缀，即可逐字的保留字符串中的内容，无需转义。

> 其他语言的类似情况可参考 [逐字字符串在各语言中的表达式](/Computer-Science/verbatim-strings-literal-grammar/)。

如下面的代码：

```cs
string testString = @"verbatim
\
string";
```

等价于：

```cs
string testString = "verbatim\n\\\nstring";
```

使用 `Console.WriteLine(testString)` 会输出：

```
verbatim
\
string
```

### 字符串串联

和 C++、Python 相同的是，C# 可以使用 `+` 对字符串进行串联。

```cs
string a = "Hello", b = "World";
string message = a + " " + b + "!";
// 也可以使用字符串和字符进行串联
```

但是 C# 还可以用 `字符串内插`。

```cs
string message = $"{a} {b}!";
```

> 字符串内插通过使用“模板”和一个或多个内插表达式将多个值合并为单个文本字符串。内插表达式是一个变量，由一个左大括号和一个右大括号符号 `{` `}` 括起来。 当文本字符串以 `$` 字符为前缀时，该字符串将变为模板。

这里涉及到两个概念 `内插表达式` 和 `模板`。请读者务必分清。

甚至可以逐字文本和字符串内插嵌套。其中 `$` 和 `@` 的顺序可以交换，先解析字符串内插，再逐字文本。

```cs
string projectName = "First-Project";
Console.WriteLine($@"C:\Output\{projectName}\Data");
```

### 基本数字运算操作

这部分 C# 和 C++ 相同。

C# 支持 `+=`、`-=`、`*=`、`++`、`--` 等，并且 `++` `--` 也分为前缀加和后缀加。

## if-elseif-else

这部分 C# 和 C++ 也完全相同。放一段代码以供参考：

```cs
if (total >= 16)
{
    Console.WriteLine("You win a new car!");
}
else if (total >= 10)
{
    Console.WriteLine("You win a new laptop!");
}
else if (total == 7)
{
    Console.WriteLine("You win a trip for two!");
}
else
{
    Console.WriteLine("You win a kitten!");
}
```

## 数组和 foreach

### 声明数组

下面以声明一个 String 类型数组为例：

```cs
string[] firstArray = new string[3];
```

注意到，执行该语句后，firstArray 的元素将被初始化。

那为什么不初始化单个的变量，导致在使用变量前会报错说“未初始化”呢？

根据 [Stack Overflow][1] 的回答，对于变量也是会进行初始化的，但是，由于在未初始化之前使用变量是一个很像 bug 的行为，于是就规定这种行为不合法了。

[1]:https://stackoverflow.com/a/8933935/12208030

### 对元素赋值

```cs
firstArray[0] = "firstElement";
firstArray[1] = "secondElement";
firstArray[2] = "thirdElement";
```

### 获取数组元素的值

结合内插表达式，可以写出如下语句：

```cs
Console.WriteLine($"First: {firstArray[0]}");
Console.WriteLine($"Second: {firstArray[1]}");
Console.WriteLine($"Third: {firstArray[2]}");
```

另外，可使用 `firstArray.Length` 获取数组的长度。

### foreach

```cs
string[] names = { "Bob", "Conrad", "Grant" };
foreach (string name in names)
{
    Console.WriteLine(name);
}
```

上述代码的运行结果：

```cs
Bob
Conrad
Grant
```

不过，对于 `string[] name = new string[10]` 这种数组，无论后面的变量是否使用，都会被遍历到。

## 使用 C# 创建具有约定、空格和注释的易读代码 

这部分并非针对 C#，而是针对所有开发者，写代码应该注意以下几点：

* 应该正确地使用首行缩进
* 写代码应该多使用空格，以更清楚地传达代码意图
* 使用代码注释，但也要有原则的使用

这部分讲的深入浅出，推荐阅读：

https://docs.microsoft.com/zh-cn/learn/modules/csharp-readable-code/