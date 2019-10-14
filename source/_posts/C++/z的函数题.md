---
title: z的函数题
date: 2019-8-15
mathjax: true
---

以下题目的 `main()`函数均已写好，z只需写出函数实现的部分。

## 函数基础（8.15）

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

## 实现一个栈

写一个栈的结构，并用函数实现栈的以下功能，并自己完成测试：

1. `push(int x)` 函数，用于往栈里增加元素 `x`。
2. `print_stack()` 函数，从栈底到栈顶，输出栈中的所有元素。
3. `int top()` 函数，返回栈顶的元素（不移除）。
4. `int size()` 函数，返回栈中元素的个数。
5. `int pop()` 函数，移除栈顶的元素，并返回这个元素。

[参考代码](stack.cpp)

## 实现一个单向链表

写一个单向链表的结构，并用函数实现链表的以下功能，并自己完成测试：

1. `void push_back(int x)` 函数，用于在链表尾部增加值为 `x` 的节点。
2. `int size()` 函数，要求 $O(n)$ 返回链表中节点的个数。
3. `node * get_head()` 函数，返回头节点的地址。
4. `void insert(node * posi, int x)` 函数，用于在 `posi` 节点后插入一个值为 `x` 的节点。保证 `posi` 合法。
5. `void delete_node(node * posi)` 函数，删除地址为 `posi` 的节点。保证 `posi` 合法。
6. `void pop_back()` 函数，用于删除链表尾部的节点。
7. `void print_linked_list()` 函数，按顺序输出链表中的所有节点的值。
8. `node * find(int x)` 函数，返回链表中第一个值为 `x` 的节点的地址。

[参考代码](list.cpp)

## 字符串匹配（10.10）

输入两个字符串 s 和 t，判断 s 是否是 t 的子串（**要求不区分大小写**）。如是，输出 s 第一次出现的下标；如不是，输出 `-1`。  

如，输入为 `DaB ABCDABC` 时，输出 `4`；  
输入 `daBb ABCDABC` 时，输出 `-1`。

要求算法复杂度不大于 $O((|t|-|s|)*|s|)$。

[参考代码](String_Matching.cpp)

## 括号匹配（10.10）

https://www.luogu.org/problem/P1739

[参考代码](Bracket_Matching.cpp)

## 哈希查找（10.13）

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