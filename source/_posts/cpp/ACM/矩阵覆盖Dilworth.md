---
title: 矩阵覆盖 Dilworth（摘抄）
date: 2019-6-25
tags:
- 数据结构
- C++
- ACM
category:
- C++
- ACM
---

偏序集能划分成的最少的全序集的个数与最大反链的元素个数相等。以上为引理，本题想要求一个降序列中最小划分方式的全序集，即求最大的升序链，即LIS
这是一道非常好的题，甚至想要摘抄题意：
一堆木头棍子共有n根，每根棍子的长度和宽度都是已知的。棍子可以被一台机器一个接一个地加工。机器处理一根棍子之前需要准备时间。准备时间是这样定义的：
第一根棍子的准备时间为1分钟；
如果刚处理完长度为L，宽度为W的棍子，那么如果下一个棍子长度为Li，宽度为Wi，并且满足L>＝Li，W>＝Wi，这个棍子就不需要准备时间，否则需要1分钟的准备时间；
计算处理完n根棍子所需要的最短准备时间。比如，你有5根棍子，长度和宽度分别为(4, 9)，(5, 2)，(2, 1)，(3, 5)，(1, 4)，最短准备时间为2（按(4, 9)、(3, 5)、(1, 4)、(5, 2)、(2, 1)的次序进行加工）。

一道贪心+LIS LIS有n^2暴力 n^2一维dp nlogn二分贪心 nlogn 二维dp
本题使用n^2方法会T，本笔记采用二分贪心（dp不会呜呜呜）

本问题可以划归为矩阵覆盖问题，需要长和宽都要单调不升才是最好情况，要注意“同时”，此时将一边排序【若相等再排序另一边】必为一个最优情况，是一个易于考虑的贪心
需要注意的是，最后拿去加工的顺序并不是排序的顺序，而是一个个LIS，lyhnb！
不需要什么花里胡哨的证明，下次思考问题还是要由简单到复杂

然后就是求解延迟了，这时候使用上述引理，想要求到不增序列的最小划分方法，直接安排LIS（经典：导弹拦截），使用二分贪心，思路在代码注释中（很强）

```c++
#define _CRT_SECURE_NO_WARNINGS
#include<bits/stdc++.h>
typedef long long LL;
using namespace std;
#define MAXN 5005
#define INF INT_MIN
struct stick {
        int left;
        int right;
};
stick sticks[MAXN];
bool cmp1(stick a, stick b) {//此处无论是排序左边还是排序右边都是无所谓的，因为要求全覆盖，固定一边找另一边就行
        if (a.left == b.left) return a.right > b.right;
        return a.left > b.left;
}
/*
        接下来用贪心+二分的方法求LIS（最长上升子序列）
        lows数组表示长度为i的上升子序列结尾最小值是lows[i]
        lows中的数一定是严格递增哒。最后的lows最大值就是我们的答案（维护的一个len）
        每次更新数据时使用二分查找lower_bound(nums,nums+n,targer)-nums//反正就是很诡异辣
*/
int lows[MAXN];
//int rights[MAXN];
int getLIS(int n) {//数组开成全局变量，n为数组长度
        //printf("%d", sticks[4998].right);
        int maxLen = 0;
        lows[0] = sticks[0].right;
        for (int i = 1; i < n; i++) {
               int temp = lower_bound(lows, lows + maxLen, sticks[i].right) - lows;
               if (sticks[i].right > lows[maxLen]) {
                       lows[++maxLen] = sticks[i].right;
               }
               else {
                       lows[temp] = sticks[i].right;
               }
        }
        return maxLen + 1;//玄学调参
}
int main() {
        //ios::sync_with_stdio(false);
        //cin.tie(0);
        int groups;
        //scanf("%d", &groups);
        groups = 1;
        for (int i = 0; i < groups; i++) {
               int n;
               scanf("%d", &n);
               for (int j = 0; j < n; j++) {
                       //scanf("%d%d", &sticks[j].left,&sticks[j].right);
                       //cin >> sticks[j].left >> sticks[j].right;
                       scanf("%d", &sticks[j].left);
                       scanf("%d", &sticks[j].right);
               }
               sort(sticks, sticks + n, cmp1);
               int temp = getLIS(n);
               int ans = temp;
               printf("%d", ans);
        }
        return 0;
}
```

不知道为什么大数据会读入不进去，很难受

P1020 导弹拦截的二问
**可以发现该问询问的是一种最坏情况，显然需要找的是最长单增子序列，我最近有些浮躁了，这种题目纸上推一推一个就莫得问题
顺便这种没有总数量、没有标志结束的输入方式： while(scanf("%d",&a[tot])!=EOF)**
若数组为降序，lower_bound()第四个参数： greater<int>()

```c++
#define _CRT_SECURE_NO_WARNINGS
#include<bits/stdc++.h>
typedef long long LL;
using namespace std;
#define MAXN 100005
#define INF INT_MIN
int lows[MAXN];
int lows2[MAXN];
int nums[MAXN];
//注意单调不升和单调升之间进行的调整
int getLIS(int n) {//获取单调不升
        int maxLen = 0;
        lows[0] = nums[0];
        for (int i = 1; i < n; i++) {
               int temp = upper_bound(lows, lows + maxLen, nums[i], greater<int>()) - lows;
               if (nums[i] <= lows[maxLen]) {
                       lows[++maxLen] = nums[i];
               }
               else {
                       lows[temp] = nums[i];
               }
        }
        return maxLen + 1;//玄学调参
}
int getLIS2(int n) {//获取单调升
        int maxLen = 0;
        lows[0] = nums[0];
        for (int i = 1; i < n; i++) {
               int temp = lower_bound(lows, lows + maxLen, nums[i]) - lows;
               if (nums[i] > lows[maxLen]) {
                       lows[++maxLen] = nums[i];
               }
               else {
                       lows[temp] = nums[i];
               }
        }
        return maxLen + 1;//玄学调参
}
int main() {
        //ios::sync_with_stdio(false);
        //cin.tie(0);
        int groups;
        //scanf("%d", &groups);
        groups = 1;
        for (int i = 0; i < groups; i++) {
               int j = 0, n = 0;
               while (scanf("%d", &nums[j]) != EOF&&nums[j]!=-1) {
                       j++;
                       n = j;
               }
               int ans1 = getLIS(n);
               int ans2 = getLIS2(n);
               printf("%d\n%d", ans1, ans2);
        }
        return 0;
}
```
