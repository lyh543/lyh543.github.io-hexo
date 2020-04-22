---
title: C 语言 I/O 输入输出
date: 2019.6.18
tags:
- C++
- stdio
- C++
- C++语法
category:
- C++
- C++语法
---

C++ I/O 请见[C++ I/O](../C++_IO/)。

## C输入输出标识符

类型|输入|输出
-|-|-
long|%ld|%ld
long long|%lld %I64d|%lld %I64d *
float|%f|%f
double|%lf|%f
long double|%llf %Lf|%Lf

\* 在 Codeforces 使用 `%lld` 输出可能会炸，在 Light OJ 上使用 `%I64d` 会炸，所以我选择 `cout`🙄

## 为什么要 scanf_s

`scanf` 在读入字符串的时候中[存在安全漏洞][1]，简单的来说就是读字符串时没有指定长度上限，导致可能把字符串（恶意代码）写入其他内存部分。因此使用 Visual Studio 进行工程开发时建议使用 `scanf_s` 或者 `cout`。（貌似 `scanf_s` 也加入了 C++ 20 的标准中，是微软提议的）。  
使用时，`scanf_s` 在用 `%s` 输入字符串时，要在 `char*` 指针后加一个长度 `count` 参数。其他语法和 `scanf` 一致。

[1]: (https://www.zhihu.com/question/43933571/answer/238686480)

## scanf %c 不忽略空格、回车

`scanf("%c")` 是看得见空格、回车的。相比下，`cin` 会看不见空格、回车。

## scanf `%*d` 忽略对应输入

```c
scanf("%d%*d%d", &a, &b, &c);
```

输入 `1 2 3`，`a=1`，2 被跳过，`b=3`，c 未被赋值。

## printf 格式化输出

```c++
printf("%7.3d", 2);  //output: "    002"
printf("%-7.3d", 2);  //output: "002    "
printf("%7.3f", float(2)); //output: "  2.000"
printf("%f", 2); //output: "0.0"
```

## puts, gets, putchar, getchar, getc

```c++
puts("a"); //with endline
char a[100];
gets(a); //until it get a endline or eof, and a exclude '\n'
putchar(65); //'A'
char a = getchar();

char a = getc(FILE* fin);
//getc == fgetc
```

值得注意的是，`gets` 因为和 `scanf` 拥有同样的[安全漏洞][1]，在 C++ 11 中被弃用，在 C++ 14 中被移除，现在建议使用 [fgets](#fgets)，但输入输出有不同。

## fgets

```c++
char str[100];
fgets(str,100,stdin);
```

`fgets` 后的 `str` 包含 `\n`，而 `gets` 后的 `str` 不包含。处理时需注意。

## getch

```c++
char a = getch() //没有回显，在conio.h里
```

## 从文件输入、输出

```c++
//从文件输入、输出（1）
freopen("input.txt","r",stdin);
freopen("output.txt","w",stdout);

// 从文件输入、输出（2）
char* s;
FILE *fp1,*fp2;
fp1=fopen("input.txt","r");
fp2=fopen("output.txt","w");
fscanf(fp1,"%s",s);
fprintf(fp2,"Hello World! And \"input.txt\" is:%s",s);
fclose(fp1);
fclose(fp2);
```
