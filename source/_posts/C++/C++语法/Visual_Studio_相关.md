---
title: Visual Studio 相关
date: 2019-8-17
tags:
- 资源
- Visual Studio
category:
- C++
- C++语法
---

## 格式化代码

Visual Studio 2017，在 `编辑` - `高级`  - `设置文档的格式`。快捷键为 `Ctrl+D`，`Ctrl+E`。

## 给Visual Studio的头文件

[catch.hpp](catch.hpp)  
[bits/stdc++.h](stdc++.h)

放到`C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.15.26726\include`目录下

因版本不同而不同

## 通过宏定义判断

```c++
#ifdef _MSC_VER
```

## 更改程序编码

```c++
#pragma execution_character_set("utf-8")
```

## 预编译头 `pch.h` 或 `StdAfx.h`

### 预编译头的作用

用 Visual Studio 编程的小白都有过这样的经历：每次新建一个项目都会给我建一个 `pch.h` （或 `StdAfx.h`，下略），删掉以后还不能通过编译，还得到设置里面关掉。

今天在刷知乎：[什么c++要“在头文件中声明，在源文件中定义”？](https://www.zhihu.com/question/58547318/answer/157951158)的时候，突然看到了**预编译头**这四个字，于是打算研究一下。

预编译头的出现，还得从 C/C++ 程序编译原理说起。

> `#include`是什么？一条预处理指令。于是你就需要搞清楚预处理在c++程序的编译过程中大约发生在什么环节。以下引用 cppreference.com:  
>
> > The preprocessor is executed at translation phase 4, before the compilation. The result of preprocessing is a single file which is then passed to the actual compiler.  
>
> C++ 的预处理器在编译之前执行，它看到 `#include` 指令，就会把那个文件的内容替换到当前位置。其它的预处理指令例如`#define`、`#ifdef` 等也在这个阶段被执行、并产生相应的内容。预处理器执行完成后，所有的预处理指令都会被移除。其结果是一个单个头的大文件（我猜测这文件只存在于内存里），这个文件才会被进一步传给编译器做编译。

也就是说，对于每一次 #include，都会把被 include 文件复制进源代码，得到一个超级长的代码。这也解释了重复编译头文件是不被 Visual Studio 允许的：不然会出现重名函数。

于是，出现了预编译头：

我们把一些不经常修改的代码放到 `pch.h` 文件里（通常是 `#include` 系统的头文件、宏定义 `#define`）。  
之后进行编译的时候，系统先将预编译头编译为 `.pch` 文件，再编译我们的其他 `.cpp` 文件。  
在之后的编译，要是 `pch.h`没有发生修改，则不会重新编译该文件。由于系统自带的库文件很大，不重新编译这些文件，能够加速我们后期的编译过程。

同时，引用的这一段话也解释了，为什么单独的 `pch.h` 文件不能编译，必须要有一个仅有 `#include"pch.h"` 一句话的 `pch.cpp`：C/C++ 是不直接编译 `pch.h` 文件的，是把该文件的代码复制到了 `pch.cpp` 文件，然后对 `pch.cpp` 文件进行编译的。

### 预编译头的使用方法

1. 现在 Visual Studio 新建项目都是自带了预编译头的，如果没有，需要自己创建一个 `.h` 和同名的 `.cpp` 文件，名字可以自取，不过 Visual Studio 使用的是 `pch.h`。  
2. 如果是自己创建，还需要把 `项目` - `（项目名）属性` - `C/C++` - `预编译头` - `预编译头` 改为 `使用（/Yu）`，后面的文件名改为刚才新建的 `.h` 文件。  
3. 如果是新建的项目，上面 Visual Studio 已经帮我们做好了，我们以后只需要：
    a. 在预编译头文件中加入不经常修改的预处理命令，如 `#define`、`#include` 系统头文件或第三方库的头文件；  
    b. 在所有你的 `.cpp` **文件的第一句**写上 `#include` 你的预编译头（必须是第一句，不然编译不过）；  
    c. 如果你的其他自定义的 `.h` 文件不需要库函数，可以不包含预编译头，否则写上；  
    d. 不用管预编译头的同名 `.cpp` 文件。
