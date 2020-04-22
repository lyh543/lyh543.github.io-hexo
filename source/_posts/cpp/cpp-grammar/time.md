---
title: C/C++ 获取秒级、微秒级、纳秒级时间戳
date: 2019-8-2
tags:
- C++
- C++语法
category:
- C++
- C++语法
mathjax: true
---

> 转自：  
> https://blog.csdn.net/CAIYUNFREEDOM/article/details/75388111  
> http://sodino.com/2015/03/20/c-time-micro-nano/

## 获取时间戳（s 级）

```c++
//in <time.h>
time_t t= time(NULL);
std::cout<<" s秒级 ----:";
std::cout<<t<<endl;
```

## Linux 下获取系统时间的时间戳（μs, ns 级）

`unistd.h` 和 `sys/time.h` 存在于 GCC，但是 Visual Studio 没有这两个头文件。Dev-C++ 可以使用该方法。

```c++
#include <iostream>  
#include <sys/time.h>
#include <cstdlib>  
#include <cstdio>
#include <ctime>
#include <cmath>
#include <unistd.h>

using namespace std;
time_t clocktime()
{
//in <sys/time.h>
struct timeval tv;  
gettimeofday(&tv,NULL);
std::cout<<"10e6 微秒级s ----:";
std::cout<<tv.tv_sec<<"s,"<<tv.tv_usec<<"微秒"<<endl;

//in <time.h>
struct timespec tn;
cout<<"----";
clock_gettime(CLOCK_REALTIME, &tn);

std::cout<<"10e9 纳秒级s ----:";
std::cout<<tn.tv_sec<<"s,"<<tn.tv_nsec<<"纳秒"<<endl;


struct timespec current_time,last_time;
double aa=1.1234567891;
printf("double %.12f\n",aa);
cout<<"----";
clock_gettime(CLOCK_REALTIME, &last_time);
sleep(1);
std::cout<<last_time.tv_sec<<","<<last_time.tv_nsec<<endl;
clock_gettime(CLOCK_REALTIME, ¤t_time);
std::cout<<current_time.tv_sec<<","<<current_time.tv_nsec<<","<<pow(10,-9)<<endl;
double delta_time = (current_time.tv_sec - last_time.tv_sec)+ (current_time.tv_nsec - last_time.tv_nsec)*pow(10,-9);
printf("double %.12f\n",delta_time);

}
int main( ){
    clocktime();
    return 0;
}
```

测试如下：

```shell
10e6 微秒级s ----:1500448195s,315233微秒
----10e9 纳秒级s ----:1500448195s,315235598纳秒
double 1.123456789100
----1500448195,315242687
1500448196,315388886,1e-09
double 1.000146199000
```

### ms 级时间的运算

由于 C 语言既没有成员函数，也没有引用，  
于是，减法函数居然是在宏定义里实现的：

```c++
#define    timersub(tvp, uvp, vvp)                        \
    do {                                                  \
        (vvp)->tv_sec = (tvp)->tv_sec - (uvp)->tv_sec;    \
        (vvp)->tv_usec = (tvp)->tv_usec - (uvp)->tv_usec; \
        if ((vvp)->tv_usec < 0) {                         \
            (vvp)->tv_sec--;                              \
            (vvp)->tv_usec += 1000000;                    \
        }                                                 \
    } while (0)
```

还行。

可以调用的函数还有如下：

```c++
timersub(tvp, uvp, vvp) //v = t - u
timerclear()  // 清除时间
timerisset()  // 结构体中是否有设置时间值
timercmp()    // 比较时间值大小
timeradd()    // 两个时间值相加
```

## MSVC 下获取本程序运行的时间（μs 级）

> 参考链接：https://docs.microsoft.com/zh-cn/windows/win32/sysinfo/acquiring-high-resolution-time-stamps

在测时间戳上，微软使用的是它的 API: QueryPerformanceCounter（QPC，查询性能计数器？），精确度在 1μs 内。

网站上还直接给出了可用的代码：

```c++
#include<profileapi.h>

LARGE_INTEGER StartingTime, EndingTime, ElapsedMicroseconds;
LARGE_INTEGER Frequency;

QueryPerformanceFrequency(&Frequency);
QueryPerformanceCounter(&StartingTime);

// Activity to be timed

QueryPerformanceCounter(&EndingTime);
ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;


//
// We now have the elapsed number of ticks, along with the
// number of ticks-per-second. We use these values
// to convert to the number of elapsed microseconds.
// To guard against loss-of-precision, we convert
// to microseconds *before* dividing by ticks-per-second.
//

ElapsedMicroseconds.QuadPart *= 1000000;
ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
```

但是在 VS 2017 上直接编译会报错：`#error No Target Architecture`。

Google 以后发现，需要在 `项目` - `（项目名）属性` - `配置属性` - `C/C++` - `预处理器` - `预处理器定义` 中加入 `_X86_`（32 位应用程序） 或 `_AMD64_` （64 位应用程序），再编译即可。

最后 `ElapsedMicroseconds.QuadPart` 即是以微秒为单位的 `long long` 时间间隔变量。

## 获取本程序运行的时间（s 级）

就是使用 `clocks` 啦。Just use `clocks`. However, accuracy is not guaranteed, and because of CPU problems, there are errors that can only be used for rough estimation. The s level should be no problem.但是不保证精度，而且因为 CPU 问题，存在误差，只能用于粗略估计。s 级应该是没有问题的。

```c++
#include<time.h>
float t = clock() * 1.0 / CLOCKS_PER_SEC
```

## Linux 下获取本程序运行的时间（ns 级）

由于要获取 pid，挺麻烦的。  
需要用到的函数有：

```c++
#include<inistd.h>
pid_t getpid();

#include <time.h>
int clock_getcpuclockid(pid_t pid, clockid_t *clock_id);

#include<time.h>
int clock_gettime(clockid_t clk_id, struct timespec *tp);
```

写成代码就是：

```c++
clockid_t clock_id;
timespec tp;
clock_getcpuclockid(getpid(), &clock_id)
clock_gettime(clock_id, &tp);
```

貌似不是特别常用，因此不再深入。
