---
title: C/C++ stdio.h iostream I/O 输入输出
tags:
category:
- C++
- C++语法
---

## C 风格 stdio.h 输入输出

### C输入输出标识符

类型|输入|输出
-|-|-
long|%ld|%ld
long long|%lld %I64d|%lld %I64d *
float|%f|%f
double|%lf|%f
long double|%llf %Lf|%Lf

\* 在 Codeforces 使用 `%lld` 输出可能会炸，在 Light OJ 上使用 `%I64d` 会炸，所以我选择 `cout`🙄

### 为什么要 scanf_s

`scanf` 在读入字符串的时候中[存在安全漏洞][1]，简单的来说就是读字符串时没有指定长度上限，导致可能把字符串（恶意代码）写入其他内存部分。因此使用 Visual Studio 进行工程开发时建议使用 `scanf_s` 或者 `cout`。（貌似 `scanf_s` 也加入了 C++ 20 的标准中，是微软提议的）。  
使用时，`scanf_s` 在用 `%s` 输入字符串时，要在 `char*` 指针后加一个长度 `count` 参数。其他语法和 `scanf` 一致。

[1]: (https://www.zhihu.com/question/43933571/answer/238686480)

### scanf %c 不忽略空格、回车

`scanf("%c")` 是不忽略空格、回车的。相比下，`cin` 会忽略空格、回车

```c++
int i;
char c;
scanf("%d%c", &i, &c); //input '1 2', a=='1', c == ' '
cin >> i >> c;//input '1 2', a=='1', c == '2'
```

### printf 格式化输出

```c++
printf("%7.3d", 2);  //output: "    002"
printf("%-7.3d", 2);  //output: "002    "
printf("%7.3f", float(2)); //output: "  2.000"
printf("%f", 2); //output: "0.0"
```

### puts, gets, putchar, getchar, getc

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

### fgets

```c++
char str[100];
fgets(str,100,stdin);
```

`fgets` 后的 `str` 包含 `\n`，而 `gets` 后的 `str` 不包含。处理时需注意。

### getch

```c++
char a = getch() //没有回显，在conio.h里
```

### 从文件输入、输出（C）

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

## C++ 风格 iostream 输入输出

### cin, cout

```c++
int ch;
cin >> ch; //ignore endline when reading
cout << endl;
```

### cin.getline()

```c++
char word[50];
cin.getline(word, 50); //ignore endline when storing

//input a string to x which is up to 100 char
//and see 'x' as end(default '\n')
cin.getline(ch, 100, 'x');
```

### cin.get()

```c++
cin.get(ch);
//input a char (including space, tab and enter)
```

### **错误示范1**

```c++
int a; char s[10];
cin >> a;
cin.getline(s);
```

紧接在读取数字等类型的cin语句后，getline会读取其前一条语句留在输入法中的”\n”而结束。

```c++
cin >> a >> s;
```

而上面这个方法则没有问题。

**cin会过滤空白字符，而cin.getline()不会。**

### **错误示范2**

```c++
int a, b, c;
cin >> a >> b;
cin >> c;
```

输入"1a2"时，当'a'不能输入到b时，输入流将关闭。
需要`cout.flush()`

### 设置输出格式

```c++
#include<iomanip>
cout << fixed; //一定先 cout <<fixed, 某 OJ 上不写会出错
cout << setprecision(n); //设置有效位数，四舍五入
cout << setw(n); //设置对齐位数
cout << setiosflags(ios::left); //设置对齐方向
resetiosflags(ios::left);
cout << hex << setiosflags(ios::showbase) <<  17 << 18; //hex十六进制，oct八进制，dec十进制
```

### 从文件输入、输出（C++）

```c++
int i;
ofstream output;
ifstream input;
output.open("output.txt");
input.open("input.txt");
input >> i;
output << i;
```

### string 和 iostream 的关系

参见这篇[博客](../string/#string 和 iostream 的关系)。

### 重载 iostream

> 参考博客: http://blog.csdn.net/caroline_wendy/article/details/15336063 

#### 1. 输出操作符(ostream)重载

```c++
std::ostream &operator<< (std::ostream& os, const ClassA& ca);
```

ostream需要修改，不能复制，所以应该为**非常量引用类型(nonconst &)**；输出类不需要修改, 应该为**常量引用类型(const &)**；

函数有可能使用内部的私有成员，需要定义为**友元(friend)**；

重载操作符应该为非类成员函数(nonmember function)。如果为类成员函数，则也必须为标准库成员函数，显然无法完成。

注意函数不要有格式信息(minimal formatting)，为了和标准输入操作符进行统一。

#### 2. 输入操作符(istream)重载

```c++
std::istream &operator>> (std::istream& is, ClassA& ca);
```

基本同输出操作符；

参数都为nonconst，都需要修改；

操作符函数应该包括错误恢复(error recovery)，保证输入错误时，不会产生未知错误；

可以增加I/O条件状态(condition state)进行判断，输入错误原因。
