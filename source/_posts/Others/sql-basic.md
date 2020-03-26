---
title: SQL 基础
date: 2020-03-23 9:31:21
tags:
- 课程笔记
- SQL
category:
mathjax: true
---

## 数据查询

## 数据插入

### INSERT VALUE

一行一行地插入。

```sql
INSERT 
    INTO Doctor(Dno,Dname,Dsex,Dage,DDeptNO,Dlevel)
    VALUES('145','王军','男',28,'101','医师')
```

* 可以省略表名 `Doctor`，表示向目标表所有列插入数据；
* 可以省略列名 `(Dno,Dname,Dsex,Dage,DDeptNO,Dlevel)`，但 VALUE 就必须按照默认的顺序；使用列名，可以交换顺序。

```sql
INSERT 
    INTO Doctor
    VALUES('145','王军','男',28,'101','医师')
```

### INSERT SELECT

用 `SELECT`，把查询内容直接插到另一个表。不求两个表列名相同，只求长度、对于位置的数据类型兼容。

例：在医院数据库中，如果需要统计每个医生每天诊断的患者数量，并把结果存入数据库。

```sql
INSERT 
    INTO DiagNum (Dno, DiagDate, PatientNum)
    SELECT Dno,Rdatetime,COUNT(DGno)
    FROM RecipeMaster
    GROUP BY Dno,Rdatetime
```

上方法每天向 `DiagNum` 中追加一次数据，会出现冗余。可定义 `no+date` 为主键。

```sql
INSERT 
    INTO DiagNum (Dno, DiagDate, PatientNum)
    SELECT Dno，getdate(DGtime)，COUNT(DGno)
    FROM Diagnosis
    GROUP BY Dno，getdate(DGtime)
```

## 数据修改

