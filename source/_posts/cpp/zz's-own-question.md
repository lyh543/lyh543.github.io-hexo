---
title: z的专属题库
date: 2019-8-15
mathjax: true
---

以下题目的 `main()`函数均已写好，z只需写出函数实现的部分。

## 函数基础（2019.8.15）

### abs()

实现一个绝对值函数 `abs(int x)`。

```c++
int main()
{
    int x = -1;
    printf("%d", abs(x));
}
```

### add()

实现一个函数 `add(int x)`，被调用时，输出 `x+1` 并换行，然后返回 `x+2`。

```c++
int main()
{
    int x = 1;
    printf("add(x)=%d", add(x));
}
```

输入 1，输出：

```
2
add(x)=3
```

### add1()

实现一个函数，使得变量 +1。

```c++
int main()
{
    int x = 1;
    //调用add()函数
    printf("%d", x);
}
```

输出 2。


[参考代码](Add_1.cpp)

### addAll()

实现一个函数，传入数组名和数组长度，将数组中所有数 +1。

```c++
int main()
{
    int x[3] = {1,2,3};
    addAll(x,3);
    for(int i = 0; i < 3; i++) printf("%d ", x[i]);
}
```

输出

```
2 3 4
```

[参考代码](Add_All.cpp)

## 栈（2019.8.15）

写一个栈的结构，并用函数实现栈的以下功能，并自己完成测试：

1. `push(int x)` 函数，用于往栈里增加元素 `x`。
2. `print_stack()` 函数，从栈底到栈顶，输出栈中的所有元素。
3. `int top()` 函数，返回栈顶的元素（不移除）。
4. `int size()` 函数，返回栈中元素的个数。
5. `int pop()` 函数，移除栈顶的元素，并返回这个元素。

[参考代码](stack.cpp)

## 单向链表（2019.8.15）

写一个单向链表的结构，并用函数实现链表的以下功能，并自己完成测试：

1. `void push_back(int x)` 函数，用于在链表尾部增加值为 `x` 的结点。
2. `int size()` 函数，要求 $O(n)$ （即遍历的形式）返回链表中结点的个数。
3. `node * get_head()` 函数，返回头结点的地址。
4. `void insert(node * posi, int x)` 函数，用于在 `posi` 结点后插入一个值为 `x` 的结点。保证 `posi` 合法。
5. `void delete_node(node * posi)` 函数，删除地址为 `posi` 的结点。保证 `posi` 合法。
6. `void pop_back()` 函数，用于删除链表尾部的结点。
7. `void print_linked_list()` 函数，按顺序输出链表中的所有结点的值。
8. `node * find(int x)` 函数，返回链表中第一个值为 `x` 的结点的地址。

[参考代码](list.cpp)

## 字符串匹配（2019.10.10）

输入两个字符串 s 和 t，判断 s 是否是 t 的子串（**要求不区分大小写**）。如是，输出 s 第一次出现的下标；如不是，输出 `-1`。  

如，输入为 `DaB ABCDABC` 时，输出 `4`；  
输入 `daBb ABCDABC` 时，输出 `-1`。

要求算法复杂度不大于 $O((|t|-|s|)*|s|)$。

[参考代码](String_Matching.cpp)

## 括号匹配（2019.10.10）

https://www.luogu.org/problem/P1739

[参考代码](luogu_p1739.cpp)

## 哈希查找（2019.10.13）

用哈希散列实现以下算法：

输入 $n$ 和 $m$，随后输入 $n$ 个整数和 $m$ 个整数，问这 $m$ 个整数中有多少个出现在了 $n$ 个整数之中。

$n, m \leq 10^5, 1 \leq a_i \leq 10^9$。要求从文件 `input.txt` 里输入。

提示：数可能有重复。

样例输入：

```
3 3
1 2 2
1 1 3
```

输出 `2`。

用 `C++ set` 写的[数据生成代码](Hash_Data_Maker.cpp)。

[参考代码](Hash_Searching.cpp)

## 字符串移位

题目来自[编程珠玑](/Computer-Science/Programming-Pearls/#将一个字符串-S-的后-i-位移到前-i-位)。  

要求用移位和倒序两种方法实现。

## 各类排序算法

包含的排序有：

* 简单插入排序 [代码](sort.cpp)

* 希尔排序 [代码](sort.cpp)

* 归并排序 [代码](merge_sort.java)

## 二叉树

### 从先序、中序遍历求后序遍历

如题，输入两个字符串，表示二叉树的先序和中序遍历，输出后序遍历。

另外，洛谷有类似的题目：求先序遍历 [洛谷 P1030](https://www.luogu.org/problem/P1030)

## 递归练习

* [洛谷 P1028 数的计算](https://www.luogu.org/problem/P1028)

* 输入一个十进制的数，将其转为二进制并输出。如，输入 `13`，输出 `1101`。

* 输入一个正整数，输出相同的数。要求：
  * 使用 `int` 类型存储
  * 使用 `getchar` 和 `putchar`，而不是 `scanf` 和 `printf` 进行输入、输出。


## 动态规划练习

* [洛谷 P1880 (NOI1995) 石子合并](https://www.luogu.com.cn/problem/P1880)

## 洛谷题库合集

题目类型|题目|完成日期|参考代码
栈|[括号匹配](https://www.luogu.org/problem/P1739)|2019.10.10|[p1739](luogu_p1739.cpp)
递归|[数的计算](https://www.luogu.org/problem/P1028)|
二叉树|[求先序遍历](https://www.luogu.org/problem/P1030)|
动态规划|[石子合并](https://www.luogu.com.cn/problem/P1880)|

# 大作业

大整数四则计算器