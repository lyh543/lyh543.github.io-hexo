---
title: MATLAB 字符串与文件
date: 2019-09-23 19:46:47
tags:
- 课程笔记
- MATLAB
category:
- MATLAB
mathjax: true
---

## char 和 string

老师上课讲的字符串是 char 类型，等价于字符矩阵，形式为 `'this is a char'`，和 C 语言等不一样的是，结尾无 `\0`。

MATLAB R2016b 引入了一种新的 string 字符串类型，每个字符串为一个元素，这样构建一个 n*m 矩阵就只需要一个二维矩阵（如果是 char，需要三维矩阵，或者改用二维 cell）。string 字符串用双引号以示区别 `"this is a string"`。

两种类型可以互相转换 `cstr = char(str);` `str = string(cstr);`，并且在不少地方都可以通用。

## char 字符串函数

函数名|函数用途
-|-
`length`或`strlength`|计算 char 字符串的长度
`s=[s1,s3,num2str(num)]`|连接 char 字符串
`num2str`|数字转字符串
`str2num`|字符串转数字
`strtok(str, delim)`|查找 `str` 的第一个 `delim` 之前和之后的字符串
`strcat`, `strvcat`|横向/纵向拼接字符串（纵向时可能会补长度）
`strsplit(str,delimiter)`|按 `delimiter` 分割 `str`（多 `delimiter` 用 `cell` 传递）

### 分割字符串

`str2 = strsplit(str,delimiter)`

```matlab
str = 'ABC;UVW;QWERTY';
strsplit(str, {';', 'V'}); % == "ABC"    "U"    "W"    "QWERTY"
```

## string 字符串

> 从 R2016b 开始，您可以使用字符串数组而不是字符数组来表示文本。字符串数组的每个元素存储一个字符序列。序列可以具有不同长度，无需填充，例如 "yes" 和 "no"。只有一个元素的字符串数组也称为字符串标量。
> 您可以按照标准数组运算对字符串数组进行索引、重构和串联，还可以使用 + 运算符向字符串追加文本。如果字符串数组表示数字，则可以使用 double 函数将其转换为数值数组。

前面提到，`char` 和 `string` 两种类型可以互相转换 `cstr = char(str);` `str = string(cstr);`，并且在不少地方都可以通用。

但是注意，二者对于矩阵处理的函数可能不同，这是因为一个 `string` 字符串被视为元素，而一个 `char` 字符串被视为矩阵，二者在字符串拼接、`length` 函数上的效果会有不同。

`string` 还引入了更多了函数，也非常方便。

但是 `string` 似乎不能处理字符串内的某个字符，此时可能需要将 `string` 转换为 `char` 来处理。

## 文件函数

和C语言很像。打开文件、读取、关闭。`fid` 是文件句柄。

```matlab
fid = fopen('myout.txt', 'wt');     %打开
fprintf(fid,'name=%s', name);    %格式化读取
fgets(fid);                                    %读取一行和回车
if ~feof(fid)                                 %判断文件末
    fgetl(fid);                                 %读取一行无回车
end
fclose(fid)                                    %关闭
```

### 打开文件

打开模式|意义
-|-
`r`|只读，文件必须存在
`w`|写；若存在，则清空
`a`|在文末追加
字母后加 `t`|以文本形式（默认）
字母后加 `b`|以二进制形式
字母后加 `+`|读写都可

`fclose('all')` 直接关闭所有文件。

### 读取文件

读一行：`A = fgetl(fin);`。当读入空行时，返回 `0x0` 矩阵。
`scanf` 天下第一！：`A = fscanf(fin,'%d%d%c')`。得到的 `A` 是一个矩阵。

这两个够用了.jpg
