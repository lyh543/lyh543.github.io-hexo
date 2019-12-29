---
title: Windows 控制台常用操作
date: 2019-8-19
category:
- C++
- C++语法
tags:
- Windows
- C++
- Win32 API
- Visual Studio
mathjax: true
---

> 参考链接：https://github.com/guyaqi/backups/blob/master/notes/cpp1-2.md

Win32 API 的函数大多名称较长，如果不是有意向专门学习的话，没有太大的必要特地记住(用的时候还是会忘)

微软公司出产的各种 API，都可以在 [msdn](https://msdn.microsoft.com/zh-cn/) 找到详细的文档和简单的例子，如果你想了解某个 Win32 API 的所有用法，这是最权威的地方。

所有 Win32 API 都需要包含 `Windows.h` 头文件。

## system() 函数

直接执行 `cmd` 命令行的命令。对于在学 C++ 之前学命令行/批处理的人，这个用起来很香。

## 涉及字符串的函数

这部分可能会有点坑。因为涉及到字符串编码，所以在英文上可能没什么问题，但是换成中文就会乱码。

> > 摘自：https://github.com/guyaqi/backups/blob/master/notes/cpp1-4.md
> 
> TCHAR 与 TEXT 宏,这两个宏在对应的情况下有不同的解释，这与你的编译器默认使用的编码方式相关。
> 
> * 当 UNICODE 宏被定义的时候（MSVC 编译器指令 `/D UNICODE`)，TCHAR 是 wchat_t，TEXT 宏被解释成 C 语言内部用来转换宽字符的宏 `L"somestr"`
> * 如果没有定义 UNICODE 宏，TCHAR 就是 char，TEXT 宏不进行任何操作。
> 
> 这种设定是在 utf-8 编码没有被广泛支持的时候,为了程序代码能够兼容使用不同代码的机器设定的，比如我使用的 win7 默认使用 gb2312（还是 gbk 来着）字符集对应的编码方式,而 win10 以上和其他使用 linux 内核的系统默认使用 utf-8 编码方式。
> 
> 值得一提的是 utf-8 使用 char，而通常 C++，Java，C# 对 UNICODE 的支持指的是使用 utf-16 的编码方式，在 C++ 中 utf-16 字符就是 wchar_t（宽字符）。

简单的来说，C++ 有两种编码，一种是 ASCII 与其的拓展 UTF-8，另一种是 Unicode。C++ 默认使用的 `char` 是 ASCII 的，也就是说，你调用 Win32 API 时使用的是 `char` 字符串，但是程序按 Unicode 执行（Visual Studio 默认），那么就会出现乱码。（也可能出现编译错误，因为 `wchar_t` 和 `char` 是不能隐式转换的）

有三种解决办法：

一是将所有设计到字符和字符串的地方都改为 Unicode 流派的 `wchar_t`, `wstring`, `wiostream` 等等。如下面的程序：

```c++
TCHAR title[] = TEXT("新标题");
setConsoleTitle(str);
```

不过，在涉及到 `char` 到 `wchar_t` 的转换时，容易出问题。貌似没有好的转换方法。也就是，要么全部用 Unicode，要么就不用 Unicode。

方法二是将涉及到这样的函数的后面加一个 `A`。原因是，Visual Studio 的源码是这样实现这些函数的：

```cpp
#ifdef UNICODE
#define SetConsoleTitle  SetConsoleTitleW
#else
#define SetConsoleTitle  SetConsoleTitleA
#endif // !UNICODE
```

可以看到，这类函数都是用宏定义将函数分为两类，然后分开执行。第二种方法就是直接去执行带 `A` 的版本。

第三种方法就是取消 `Unicode` 的宏定义。具体在 Visual Studio 的 `项目属性->配置属性->常规->字符集`，设置为多节字符集（多字节字符集即没有设置UNICODE宏，使用Unicode字符集就是设置了 `UNICODE` 宏）。

设置的效果可以去 `C/C++->预处理器->预处理器定义` 查看

注意 `QT-Addin` 生成的 Visual Studio 项目默认是加上 `UNICODE` 宏，只去 `项目属性->配置属性->常规->字符集` 没用，还要手动把 `QT-Addin` 设置的 `UNICODE` 宏删掉。[参考链接](https://www.cnblogs.com/qrlozte/p/4972682.html)

## 窗口部分

窗口部分大多可以直接通过 `system()` 调用命令行的命令修改。

### 修改窗口标题

一个是用 `cmd` 命令的版本：

```c++
system("title newTitle");
```

~~好随意的标题~~

还有另一个版本，调用 Win32 API：

```c++
TCHAR title[] = TEXT("新标题");
setConsoleTitle(str);
```

但是如果涉及到变量字符串，就会变得比较麻烦了，建议涉及到标题部分的变量的地方都使用 utf-16 的东西，如 `wchar_t`，`wstring`，`wcout`。  
如果需要 `char` 到 `wchar_t` 的转化。目前测试了 `swprintf()` 和 `mbtowc()` 函数，在配合 `setConsoleTitle()` 函数时均出现了问题。

如果必须使用 `char`，可以尝试下面的方法：

```c++
char title[] = "新标题";
setConsoleTitleA(title);
```

强制指定使用 `char`。貌似挺好用的。

### 修改窗口颜色

```c++
system("color 3f");
```

3 和 f 分别是用 16 进制数字表示的 foreground color 和 background color。具体对应关系可以自己在命令行中输入 `color /?`。

### 修改窗口大小

```c++
system("mode con: cols=120 lines=35");
```

`mode` 语句有更多的用处~~不过看不懂~~

## 光标部分

### 获取光标位置

命令行上的光标位置是用 `HANDLE` 定义的。关于 `HANDLE` 是什么，可以自行 Google 或看这篇[博客](../handle)。

```c++
HANDLE handle = GetStdHandle(STD_OUTPUT_HANDLE);
```

注意到这个 handle 是随着输出的位置动态变化的，因此不需要在输入前后反复获取。

### 设置光标的颜色——以后输出内容的颜色

```c++
HANDLE handle = GetStdHandle(STD_OUTPUT_HANDLE);
SetConsoleTextAttribute(handle, (fc<<4) + bc);
```

fc 和 bc 分别是用 16 进制数字表示的 foreground color 和 background color。具体对应关系可以自己在命令行中输入 `color /?`。

顺便附 https://github.com/guyaqi/backups/blob/master/notes/cpp1-2.md 的[作业 CPP 文件](./homework_change_text_color.cpp)。

下面是摘自 https://github.com/guyaqi/backups/blob/master/notes/cpp1-2.md 的一个 C++ 程序。

```c++
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <Windows.h>
int main()
{
    int fc, bc;
    HANDLE handle;

    handle = GetStdHandle(STD_OUTPUT_HANDLE);
    srand(time(0));

    while (true) {
        fc = rand() % 16;
        bc = rand() % 16;
        SetConsoleTextAttribute(handle, (fc<<4) + bc);
        putchar('#');
    }
    return 0;
}
```

### 设置光标的位置——设置以后输出内容的位置

```c++
HANDLE handle = GetStdHandle(STD_OUTPUT_HANDLE);
COORD coord = {6,6};
SetConsoleCursorPosition(handle, coord);
```

其中 `COORD` 类型包含两个成员 `X` 和 `Y` 表示坐标。cursor 翻译为光标。

```c++
typedef struct _COORD {
    SHORT X;
    SHORT Y;
} COORD, *PCOORD;
```

### 不显示光标

```c++
HANDLE handle = GetStdHandle(STD_OUTPUT_HANDLE);
CONSOLE_CURSOR_INFO cursor = {100,FALSE};
SetConsoleCursorInfo(handle, &cursor);
```

`CONSOLE_CURSOR_INFO` 有两个成员：第一个 `dwSize` 表示光标占格子（高度）的百分比，范围是 1-100；第二个 `bVisible` 表示是否可见。

## 键盘按键

### 获取按键状态

```c++
SHORT GetKeyState(int nVirtKey);
SHORT GetAsyncKeyState(int nVirtKey);
```

首先，这个东西是获取执行函数时，某按键的状态，而不是类似于 `cmd` 的 `choice`。要是要等待输入的话，貌似要使用 `for(;;)` 的死循环语法（但是实测不会像 `for(;;);` 一样占用过高 CPU），个人感觉不是一个好的输入的形式（先挖个坑，以后来填）。

如果一定要用该方式进行输入，为防止语句运行过快导致某次短按按键被 `getKeyState()` 读多次，有两种输入形式：  
1. 可以在成功读入一个字符以后，应进行 `Sleep(100)`（100ms 是玄学调参的结论）。这样做的话，长按的按钮会每 100ms 被识别一次，但是短按后 100ms 以内其他操作无效。
2. 可以用 `while(getKey() < 0)` 读到按键结束为止。此方法把长按、短按都视为一次按键。

其次，这两个函数的区别也有点迷。理论上，前者是获取的 `Windows message queue` 里的信息（至于这是什么，我也不懂），后者是获取即时的硬件状态，[Stack Overflow](https://stackoverflow.com/a/24525939) 上也建议使用后者，但是我在 Visual Studio 上测试的效果，其实是差不多的。（又挖坑）

再次，对于数字和（大写）字母，参数 `nVirtKey` 即是它的 ASCII 码。对于其他按键，可以查阅 [MSDN 文档的虚拟键码部分](https://docs.microsoft.com/zh-cn/windows/win32/inputdev/virtual-key-codes)。

最后，对于其返回值，由于按键有上（up）、下（down）和按住（toggled）、没有按住（untoggled），两两组合，共四种状态，因此表示也一共有四种状态。

> 参考链接：https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getkeystate  

把 MSDN 的文档翻译过来就是，返回值的最高位是 1，表示该按键是按下的（down），反之则没有被按下（up）；返回值的最低位是 1，表示该按键被按住（toggled），如果最低位是0，则既没有被按下（up），也没有被按住（untoggled）。

下表是按键状态和对应的返回值：

按键状态|返回值
-|-
按下并按住（可理解为长按）|1000 0001（-127）
按下但不按住（可理解为短按）|1000 0000（-128）
不按下且没有按住|0000 0000（0）
不按下但按住（有点迷）|0000 0001（1）

关于按住（toggle）这个状态的理解有点迷。

但是若只需要判断是不是按下，那就可以忽略低位。一种实现是 `GetKeyState(nVirtKey) & 0x80`，第二种是判断 `GetKeyState(nVirtKey) >= 0`。

注意这里的

对于这段的理解还是挺迷的，不过以后需要的时候再来深究吧。

## 计时、获取系统时间戳

见[另一篇博客](../time#msvc-下获取本程序运行的时间μs-级)。

## 文件管理

### Directory Management

就是命令行中获取当前文件夹、更改当前文件夹（即`cd`）等操作。

微软官方文档链接：[Directory Management](https://docs.microsoft.com/en-us/windows/win32/fileio/directory-management)

```c++
DWORD GetCurrentDirectory(DWORD BUFSIZE, TCHAR[] Buffer);
bool SetCurrentDirectory(TCHAR[])
```

具体详解请看[微软官方文档](https://docs.microsoft.com/en-us/windows/win32/fileio/changing-the-current-directory)

### 遍历文件

需要 `FindFirstFile` `FindNextFile` 和 `FindClose` 函数。

具体详解请看[微软官方文档](https://docs.microsoft.com/en-us/windows/win32/fileio/listing-the-files-in-a-directory)

### 得到文件大小

需要上面遍历文件得到的 File Handle。

```c++
DWORD GetFileSize(
  HANDLE  hFile,
  LPDWORD lpFileSizeHigh
);
```

第二参数可省。

具体详解请看[微软官方文档](https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfilesize）