---
title: 调一万年才能发现的bug
date: 2019-7-25
tags:
- C++
- C++语法
category:
- C++
- C++语法
---

## 我脑子可能有问题.jpg

### 仔细看题

看题看题看题啊！！连续两场比赛因为看错题贡献了数小时的罚时。但是困的话，读英文就很难受，读不进去。所以打 ACM 得有一个良好的作息。

### 先读题跑一下样例

2019.8.16 的 [Codeforces Round #574 (Div. 2) D1](https://codeforces.com/contest/1195/problem/D1)，最后20分钟写，一直过不了样例，手跑了一下，发现是理解错样例了。差点 4.5 题。

### 爆数组

不知道为什么，居然数据范围多大就开了多大内存。正好这题从 1 开始计数的。`-2`  
同场比赛一个 1e5 的数据范围看成 1e4 了。`-1`

```c++
const int maxn = 3000;
```

### 爆char了解一下

顺便提一下（cin）输出100K位的字符串是没问题的，而且速度较for更快，但是内存占用+100K

```c++
char str[1000], length;
```

### 还有爆 int

> 所有数都保证在int范围内。

然后 int 一直 wa1。改成long long 就过了。哦，原来是输入保证在 int 内。

```c++
#define int long long
signed main()
{
    scanf("%lld", &a);
    printf("%lld", a);
}
```

### 甚至可以爆 long long （指忘取模）

快速幂（或类似物）对 `ans` 取模，没对 `temp` 取模。

```c++
ans = ans * temp % mod;
temp *= mod;
```

还有加法的时候忘了优先级。

```c++
C[i][j] = C[i-1][j-1] + C[i-1][j] % mod
```

### 减法前必取模

即使是减 1 也要取模。——2019.7.23

### 手写 hash 避免常用质数

wdg 手写 hash 时，使用 1e9+7 做模数没过，改个数就过了。以后还是用非常见质数比如 ~~19260817~~ 100008221。

### 两层for的时候，i和j别写错了

```c++
if (up[a][i].point != up[b][i].point) // excluding overflow that  are both 0
{
       ans = min(min(ans, up[a][i].distance), up[b][i].distance);
       a = up[a][i].point;
       b = up[b][j].point;
}
```

### 多组输出时，cout不输出endl

```c++
cout << a;
```

### ios::sync::with_stdio(0)以后，混写 cout 和 getchar/scanf，在本地跑没问题，但是OJ上就会炸

```c++
ios::sync_with_stdio(0)
cout << 'a';
putchar('a');
```

### 被卡Case #n:

错误示范

```
case #1     //Capitalize c
Case #0
Case #1:1 //needs ' ' after ':'
Case 0Case1 //needs '\n'!!!!!!!!!!
//其实可以学 cxmm 每次加一个回车
```

### 多组数据爆时间复杂度

`T = 10000` 了解一下，本来 1 秒钟能跑 1e8 的， T = 10000，平均每组只能跑 1e4-1e5 了。或者是预处理。

### 尽量不要使用结构种的成员变量名做作变量名，不然错了都不报错的

```c++
struct{
    int d;
}s;
int d;
```

### queue::size()不是int类型？？？

```c++
queue<int> q, q2;
q.push(-1);
long long b = (q2.size() - q.size());
printf("%lld", b);
```

输出 `4294967295`。`sise_t` 类似于 `unsigned int`，必须要在 `size_t` 类型做运算前，强制转换为 `long long`。

### 交互题忘 `endl` ——2019.7.24

```c++
cout << "? " << i;
cout.flush()
```

依旧 `Idleness Limit Exceeded`。

### 矩阵的左乘和右乘

矩阵的左乘和右乘是有区别哒！注意左右。——2019.7.25
