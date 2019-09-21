---
title: Excel 公式
date: 2019-9-14
category:
- Excel
---

[Office链接](https://support.office.com/zh-cn/article/excel-中的公式概述-ecfdc708-9162-49e8-b993-c311f47ca173?ui=zh-CN&rs=zh-CN&ad=CN)

## 统计计算

求和：`=SUM(D38:D41)`

平均数：`=AVERAGE(D38:D41)`
中位数：`=MEDIUM(D38:D41)`

众数：`=MODE(D38:D41)`
最大值：`=MAX(D38:D41)`
最小值：`=MIN(D38:D41)`

### 部分统计

对开启筛选后的部分表格进行统计，可以用 `SUBTOTAL()` 函数，第一个参数为上述常用函数的标号。

## 矩阵计算

### 用 Excel 求逆矩阵

1. 选定目标矩阵区域
2. 输入 `=MINVERSE(A1:C3)` （矩阵区域）
3. 按 `Ctrl+Shift+Enter` 以进行数组赋值

## 时间

今天：`=TODAY()`
现在：`=NOW()`

## 分支 if

IF语句：`=IF(F3=233,""对啦,"错了额")`

## 检测错误

输入 `ERR` 即可查到以下公式：

公式|`ERROR.TYPE()`|`IFERROR()`|`ISERR()`|`ISERROR()`
-|-|-|-|-|-
返回|整数值|和 `IF()` 语句的结合|返回布尔值|返回布尔值

## 逻辑运算符、布尔函数

中文|等于|不等于
-|-|-
符号|`=`|`<>`

`TRUE` 和 `FALSE` 在数学运算中被视为 `1` 和 `0`。

逻辑运算函数有 `NOT()`，`AND()`，`OR()`，`NAND()`，`NOR()`，`XOR()`。

## 寻找

`FIND()` 和 `FINDB()`，是单个单元格对单个单元格的**字符串意义上**的匹配。配合 [ERROR 系统](#检测错误)使用。

也可以使用 `VLOOKUP()`，不过是多单元格对单个单元格的**内容和格式**匹配。~~格式不同匹配不上，用的我心态爆炸~~
