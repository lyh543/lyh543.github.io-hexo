---
title: SQL SERVER 基础
date: 2020-03-23 9:31:21
tags:
- 课程笔记
- SQL
category:
mathjax: true
---

此篇博客来自《数据库管理及应用》课程的第三章。教材为《数据库系统及应用》（第 2 版，魏祖宽 主编）。

## SQL 简介

> SQL：Structured Query Language

> SQL 决不仅仅是一个查询工具，还用于控制 DBMS 提供给用户的所有功能：
> * 数据定义(Data definition)：SQL 可用于定义被存放数据的结构和组织，以及数据项之间的关系。 
> * 数据检索(Data retrieval)：SQL 能使用户或应用程序从数据库中检索数据并使用这些数据。 
> * 数据操纵(Data manipulation)： 用户或应用程序通过 SQL 更改数据库，如增加新数据，删除旧数据，修改已存入的数据等。 
> * 存取控制(Access control)：SQL 可用来限制用户检索，增加和修改数据的权限，保护所存储的数据不被非法存取。 
> * 数据共享(Data sharing)：SQL 可用于调整数据让并发用户共享，以保证用户之间彼此不受影响。 
> * 数据完整性(Data integrity)：SQL 能对数据库的完整性条件作出规定，以使其不会因为修改紊乱或系统出错而被破坏。 

> SQL 有以下特点：
> * 支持数据库的三级模式
> * 高度非过程化
> * 面向集合的操作方式（操作对象和结果均为集合）
> * 集 DDL（数据定义语言）、DML（数据操作语言）、DCL （数据控制语言）的功能于一体。下面是三部分用到的关键词：
>   - DDL：CREATE、DROP、ALTER
>   - DML： SELECT、INSERT、UPDATE、DELETE
>   - DCL：GRANT、REVOKE

## SQL Server 运行环境

环境配置这部分就请百度吧。

Server 方面，教材讲的是 SQL Server 2000。当然也可以使用最新版的 SQL Server 2019。

编辑器方面，可以使用 SQL Server 配套的 SQL Server Management Studio，也可以使用 VS Code 的 [SQL 插件](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql)。

[SQL 样式指南]

[SQL 样式指南]:https://www.sqlstyle.guide/zh/

## 数据库操作

开始讲语法之前，先说两点：
1. SQL Server 对大小写不敏感
2. 注释的形式为 `--单行注释` 和 `/*跨行注释*/`

### 创建数据库

> 数据库中的所有数据和对象（如表、存储过程、触发器和视图）都存储在三种操作系统文件中：
> 1. 第一类是主文件，扩展名为 `mdf`（priMary Database Files），该文件包含数据库的启动信息及数据信息，每个数据库都有一个主文件。
> 2. 第二是次要文件，也称从文件，扩展名为 `ndf`（secoNdary Database Files），这些文件含有主文件以外的所有数据。可选。次要文件的主要用处是，当数据库中的数据量非常大时，需要多个次要文件来提高数据访问效率，或使用多个次要文件将数据扩展到多个不同的磁盘驱动器上。
> 3. 第三类是事务日志，扩展名为 `ldf`（Log Databse Files），这些文件包含用于恢复数据库的日志信息。每个数据库都必须至少有一个日志文件。


创建数据库的过程可以像下面这么简单。

```sql
Create Database HIS
```

也可以指定一些参数：

```sql
CREATE DATABASE HIS
ON Primary                          -- On Primary 关键字，表明与该关键字相邻的文件为主文件
( NAME = HIS_DATA1,                 -- SQLServer 使用的逻辑名称
    FILENAME = 'd:\HIS_DATA1.mdf',  -- 文件名
    SIZE = 10,                      -- 文件的初始大小
    MAXSIZE = 1500,                 -- 文件的最大大小
    FILEGROWTH = 5 ),               -- SQLServer 每次扩大文件的大小，默认为 10%
( NAME = HIS_DATA2,
    FILENAME = 'd:\HIS_DATA2.ndf',  -- ndf 是次要文件
    SIZE = 10,
    MAXSIZE = 500,
    FILEGROWTH = 5 )
LOG ON                               -- Log On 为关键字，见后
( NAME = HIS_LOG,
    FILENAME = 'd:\ HIS_LOG.ldf',
    SIZE = 5MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 5MB )
```

`LOG ON` 用来指定数据库的 SQL Server 事务日志将存储在一个与数据库对象不同的设备上。如果数据库所在的物理设备被破坏而日志还可以使用（如果该日志所在的设备没有被破坏），使用一个以前的数据库备份和一个未破坏的日志的脱机复制，可以将数据库恢复到发生故障时刻的数据库的状态。

### 修改数据库

```sql
ALTER DATABASE HIS
Add File
( NAME = HIS_DATA3,
    FILENAME = 'd:\data\HIS_DATA3.ndf',
    SIZE = 10,
    MAXSIZE = 1000,
    FILEGROWTH = 5 )

ALTER DATABASE HIS
Modify File
( NAME = HIS_DATA2,
    FILENAME = 'd:\data\HIS_DATA1.mdf',
    SIZE = 10,
    MAXSIZE = 1500,
    FILEGROWTH = 5 )

ALTER DATABASE HIS
Remove File HIS_DATA2
```

可以看到有三种操作：`Add File`、`Modify File`、`Remove File`，其中前两者要指定的参数创建数据库相同。

### 删除数据库

```sql
DROP DATABASE HIS
```

不能删除系统数据库（`msdb`，`master`，`model` 和 `tempdb`）

## 数据类型

看看就好（逃

数据类型|功能|范围|注释
-|-|-|-
`CHAR(n)`|固定长度字符串|长度范围 1~8000|默认 1
`NCHAR(n)`|固定长度 Unicode 字符串|长度范围 1~4000|默认 1
`VARCHAR(n)`|变长字符串|长度范围 1~8000|默认 1
`NVARCHAR(n)`|变长 Unicode 字符串|长度范围 1~4000|默认 1
`TEXT`|变长字符数据|最长 $2^{31}-1$ 字节|行中存储指向第一个数据页的指针。实际的文本是以 B-树 页面存储
`NTEXT`|变长 Unicode 字符数据|最长 $2^{30}-1$ 字节|同上
`DEC(n,m)`<br>`DECIMAL(n,m)`<br>`NUMERIC(n,m)`|数值型，n 是总位数，m 是小数点右边的位数|n 范围 1\~38<br>m 范围 0\~n|默认 n=38, m=0
`INT`<br>`INTEGER`|整数|范围 $-2^{31}$~$2^{31}-1$
`FLOAT(n)`|浮点数，n 是尾数位数|范围 1~53|如果 n 为 1\~24 则指定单精度；如果 n 为 25\~53 则指定双精度（8字节）；默认 53
`REAL`|||等价于 `FLOAT(24)`
`SMALLDATETIME`|四字节日期和时间|日期范围 `?` ~ `6-6-2079`|时间精度是自午夜开始的 1 分钟之内
`DATETIME`|八字节日期和时间|日期范围 `?` ~ `12-31-9999`|时间精度：3.33毫秒之内
`BINARY(n)`|定长二进制数据|长度范围 1~8000 字节|默认 1
`VARBINARY(n)`|变长二进制数据|长度范围 1~8000 字节|默认 1
`IMAGE`|变长二进制数据，用于储存图形数据|最长 $2^{31}-1$ 字节|行中存储指向第一个数据页的指针。实际的数字以 B-树 的页面存储

## 表操作

### 创建表

下面的代码将创建一个 `Medicine` 表，包含五个属性，并且定义了数据类型。

```sql
CREATE TABLE Medicine (
    Mno    VARCHAR(10)   PRIMARY KEY,      -- 主键
    Mname  VARCHAR(50)   NOT NULL,       -- 非空
    Mprice DECIMAL(18,2) NOT NULL,    -- 非空
    Munit  VARCHAR(10)   DEFAULT '克',   -- 默认值为 '克'
    Mtype  VARCHAR(10)
)
```

常用的完整性约束如下：

* 主键约束：`PRIMARY KEY`
* 唯一性约束：`UNIQUE`
* 非空值约束：`NOT NULL`
* 外键约束：`FOREIGN KEY`

主键也同时需要满足非空、唯一。

下面是外键的演示：

```sql
CREATE TABLE RecipeMaster (
    Rno       VARCHAR(10) PRIMARY KEY,
    Pno       VARCHAR(10) NOT NULL,
    Dno       VARCHAR(10) NOT NULL,
    DGno      VARCHAR(10),
    Rdatetime DATETIME,
)

CREATE TABLE RecipeDetail (
    Rno     varchar(10),
    Mno     varchar(10)
            FOREIGN KEY(Mno)
            REFERENCES medicine(Mno),
    Mamount decimal(18, 0),
            CONSTRAINT Rnofk FOREIGN KEY(Rno)
            REFERENCES RecipeMaster(Rno), --最后一行的逗号是可选的
);
```

最后一张表 `RecipeDetail` 用两种方法进行了外键约束。

一种形式是在列后面进行约束：

```sql
Mno varchar(10) FOREIGN KEY(Mno) REFERENCES medicine(Mno)
-- FOREIGN KEY 后的 Mno 指的是该表的属性列的名称，即第一个 Mno
```

另一种形式是作为表级的约束：

```sql
CONSTRAINT Rnofk FOREIGN KEY(Rno) REFERENCES RecipeMaster(Rno)
-- 第一个 Rnofk 是外键名称（而非外键列名称），不需和后面保持一致
```

### 修改表

修改表有四种操作，如下：

```sql
ALTER TABLE 〈基表名〉
    [ ALTER COLUMN <列名> <数据类型>],      --更改列
    [ ADD <新列名> <数据类型> <约束规则>],   --新增列
    [ DROP COLUMN <列名>],                  --删除列
    [ DROP CONSTRAINT <约束规则>];          --删除约束规则
```

如下的代码向处方明细表 `RecipeDetail` 增加一列存储药品单价。

```sql
ALTER TABLE RecipeDetail
  ADD Price Decimal(5, 3)
```

> 注意，使用 `ALTER TABLE` 语句在表中增加列，如果新增列定义为 `NOT NULL` 列，必须用 `Default` 指定缺省值。否则，没有指定缺省值，当给表增加新列时，表中原有记录的新增列将自动为 `NULL`，这样就会违背 `NOT NULL` 的定义而出错。
> 在 `CREATE TABLE` 时，`NOT NULL` 列可以不指定缺省值。  
> 但即使表中没有一个记录，SQL Server 2000 也不允许用 `ALTER TABLE` 指定没有缺省值的 `NOT NULL` 列。


### 删除表

```sql
DROP TABLE RecipeMaster
```

此外，还可以使用参数：

```sql
DROP TABLE <表名> [RESTRICT|CASCADE];
-- RESTRICT：拥有表的对象（Check、Foreign Key、视图、触发器、存储过程、函数等）时禁止删除；
-- CASCADE：级联删除表的所有对象
```

## 数据操作

### 数据查询

在介绍查询语句的格式之前，我们先来看一下用 `SELECT` 、`FROM` 和 `WHERE` 表达的简单查询语句。

从关系 `Doctor(Dno, Dname, Dsex, Dage, Ddeptno, Dlevel, Dsalary)` 中找出所有主任医师级别的男医生的信息，其 SQL 语句为：

```sql
SELECT *
  FROM Doctor
 WHERE Dlevel='主任医师' and Dsex='男';
```

该查询语句显示了大部分 SQL 查询语句的结构特征，即 `select-from-where` 形式。  
* `FROM` 语句说明了查询语句针对的关系，在这里就是对 `Doctor` 关系；
* `WHERE` 是一个条件语句，说明了我们查询的元组需要满足的条件；
* `SELECT` 说明要输出元组的哪些属性列。这里使用 `SELECT *` 输出了所有属性列。

[SQL 样式指南] 中指出，关键字应当右对齐，元素名应当左对齐，形成两边向中间对齐的“川流”。（对于双关键字如 `ORDER BY`，第二个关键字 `BY` 应在川流右边，和元素一样左对齐）

说完了查询语句的最基础的 `select-from-where` 形式，下面我们来说说查询语句的基本结构。

```sql
SELECT [ DISTINCT|ALL ] <目标列表达式> [, <目标列表达式>] …
    FROM <表名或视图名>[, <表名或视图名> ] …
    [ INTO <新表名> ]
    [ WHERE <条件表达式> ]
    [ GROUP BY <列名1> [ HAVING <条件表达式> ] ]
    [ ORDER BY <列名2> [ ASC|DESC ] ];
```

从上面我们可以看到：

* 上述各子句的排列顺序不能改变
* `SELECT` 子句和 `FROM` 子句是必须的，其他子句都是可选的

该语句执行顺序如下：

1. `FROM`：指定数据的来源。
2. `WHERE`：依据约束条件对元组进行过滤。
3. `GROUP BY`：对元组进行分组。
4. `HAVING`：依据分组的选择条件对组进行过滤（与 `GROUP BY` 搭配使用）。
5. `SELECT`：对上述结果按照列表达式选出元组中的属性分量值，形成结果集。
   - `DISTINCT` 选项表示去掉结果集中的重复元组；
   - 系统默认为 `ALL`，表示不去重复。
6. `ORDER BY`：对结果集按指定列进行排序
   - `ASC` 表示将结果按升序排序（默认) ；
   - `DESC` 表示按降序排序。
7. `INTO`：将结果放入指定的新表（默认输出到屏幕）。

#### 简单查询

本节介绍单表查询，即数据源只涉及一张表的查询。

##### SELECT

上面讲了 `SELECT *` 可以查询所有列，如果用户只对一部分属性列感兴趣，可以使用：

```sql
SELECT Dname, Dno, Ddeptno
  FROM Doctor
```

语句的效果是：从 `Doctor` 表中取出一个元组，取出该元组在属性 `Dname`、属性 `Dno` 和属性 `Ddeptno` 上的分董值，形成一个新的元组输出。对 `Doctor` 表中的其他元组做相同的处理。

注意，上面的语句输出的属性列是按照 `SELECT` 后面内容的顺序，可以和原表不同。

如果想要去掉重复内容，可以使用 `DISTINCT`：

```sql
SELECT DISTINCT Ddeptno
  FROM Doctor
```

如果想查询所有内容，就是前文的 `SELECT *` 语法。

`SELECT` 的内容，还可以是属性列的库函数运算表达式、属性列与常量之间的算术运算表达式。

```sql
-- 查询医生的姓名及年薪
SELECT Dname, Dsalary * 12
  FROM Doctor
```

以上计算的表达式的列不会有列标题。我们可以使用“别名”：

```sql
-- 结果的表头为 姓名 和 年薪，而非 Dname 和（空）
SELECT Dname AS 姓名, Dsalary * 12 AS 年薪
  FROM Doctor

-- AS 可省略，即上面的代码和下面等价：
SELECT Dname 姓名, Dsalary * 12 年薪
  FROM Doctor
```

`AS` 可省略（但为了代码的可读性，不推荐删除）。

如果省略了 `AS`，并且别名中有空格，需要给别名加引号。

表也可以有别名。但是当为表指定了别名时，在查询语句中的其他用到表名的地方都要使用别名，不能再使用原表名。

##### WHERE

下面我们主要说 `WHERE` 后的 `<行选择条件>`。

1. 比较大小运算符（用 $\theta$ 统称）有 `>` `<` `=` `<>` `!=` `>=` `<=`（其中 `!=` 等价于 `<>`。MSSQL 还有非标准的 `!<` `>!`，但也等价于 `>=` 和 `<=`）。

所有的 `<行选择条件>` 还可以配合逻辑运算符 `AND` `OR` `NOT`。

```sql
-- 查询男医生的信息
SELECT *
  FROM Doctor
 WHERE Dsex = '男'

-- 查询年龄在 40 岁以下的医生信息
SELECT *
  FROM Doctor
 WHERE Dage < 40

-- 查询年龄在 40 岁以下的男医生信息
SELECT *
  FROM Doctor
 WHERE Dage < 40 AND Dsex = '男'
```

2. 确定集合 `IN`。`IN` 的含义是指当属性列的值与指定集合中的某一个常量相等时，结果为真。`NOTIN` 含义正好相反。

```sql
-- 查询部门编号为 102, 103 和 201 的医生信息
SELECT *
  FROM Doctor
 WHERE Ddeptno IN ('102', '103', '201')
    /* 等价于 WHERE Ddeptno='102' OR Ddeptno='103' OR Ddeptno='201' */
```

3. 确定范围 `BETWEEN ... AND`。其含义是当属性列的取值在上限值和下限值的范围内，结果为真。`NOT BETWEEN ... AND` 含义正好相反。

```sql
-- 查询年龄在 35~40 岁之间的医生信息
SELECT *
  FROM Doctor
 WHERE Dage BETWEEN 35 AND 40
    /*等价于 WHERE Dage>=35 AND Dage<=40 */
```

4. 字符串比较。字符串比较可以用到以下运算符：

* 直接使用 `=` 来判断两个字符串完全相同；
* 使用 `>` `<` 等比较运算符，比较的是其 ASCII 或 Unicode 码；
* 使用 `LIKE` 关键字搭配通配符。SQL Server 提供了以下通配符：
  - `_` 匹配任意一个字符
  - `%` 匹配任意长的字符
  - `[]` 匹配一定范围内的任何单个字符，如 `[abcdef]` 或 `[a-f]` 匹配 `a`、`b`……或 `f` 字符
  - `[^]` 匹配范围之外的字符
  - 如果用户查询的字符传本身就含有 `%` 等字符，要使用 `ESCAPE` 对通配符进行转义。（SQL Server 默认为 `\`，但也推荐显式地指定转义字符）

```sql
-- 查询副级职称的医生信息
SELECT *
  FROM Doctor
 WHERE Dlevel LIKE '副％'

-- 查询姓“欧阳”且全名为三个汉字的医生的姓名
SELECT Dname
  FROM   Doctor
 WHERE  Dname LIKE '欧阳_';

-- 查询包含 “葡萄糖_5%_150mL” 的药物
SELECT *
  FROM Medicine
 WHERE Mname LIKE '%葡萄糖\_5\%\_150mL%' ESCAPE '\'
```

对于中文占几个字符的问题，在 SQL Server 2000 和 2019 版上，博主得到了相同的测试结果：

> 对于 ` CHAR` `varchar` `nvarchar` 和 `text` 类型，一个 `_` 等价于一个汉字，即 `'欧阳_'` 匹配欧阳开头的三个汉字；
> 对于 `nchar`，结果有些出人意料，对于 `nchar(10)` 类型的列，`欧阳________`（共八个下划线）才能匹配到欧阳开头的三个汉字，并且，同时也能匹配欧阳开头的四个汉字。

对于后面这点，博主没有继续深入下去，只是简单[搜索了一下]，得到以下的结论：

[搜索了一下]:https://stackoverflow.com/questions/612430/when-must-we-use-nvarchar-nchar-instead-of-varchar-char-in-sql-server?answertab=votes#tab-top

> 如果会在一列中出现不同语言，一定要使用 `nvarchar`。

对于纯中文，那就尽量使用 `nvarchar`，绝对不要使用 `nchar` 吧。

5. 空值 `NULL`。`NULL` 在数据库表示不确定的值。空和非空语法格式分别为 `IS NULL` 和 `IS NOT NULL`。
 
```sql
-- 查询没有药品信息的处方
SELECT * 
  FROM RecipeDetail
 WHERE Mno IS NULL
```

##### ORDER BY

`ORDER BY` 在输出的时候对元组进行排序。默认为升序 `ASC`（小的在前）。降序关键字为 `DESC`。

当排序列含空值时，若为按升序排序，排序列为空值的元组最后显示；若为按降序排序，排序列为空值的元组最先显示。也就是说，在排序中可以把 `NULL` 理解成极大值。

```sql
-- 查询所有男医生的基本信息，按照年龄升序输出显示
SELECT *
  FROM Doctor
 WHERE Dsex='男'
 ORDER BY Dage

-- 查询所有医生信息，按部门编号升序排序，相同元素按年龄降序排序显示
SELECT *
  FROM Doctor
 ORDER BY Ddeptno ASC, Dage DESC
```

##### TOP

`TOP` 的功能是：

> 使用 `SELECT` 语句进行查询时，可能只希望列出结果集中的前儿个结果而不是全部结果。例如，  
> 统计医生的年薪时只取薪水最高的前三名，这时就可以使用 `TOP` 谓词限制输出的结果。

`TOP` 的语法如下：

```sql
TOP n [percent] [WITH TIES]
```

加上 `percent`，表示查询的是前 n%；加上 `WITH TIES`，表示包括并列的结果。

`TOP` 放在 `SELECT` 后，查询列表之前。如有 `DISTINCT`，则在 `DISTINCT` 后。

`TOP` 通常与 `ORDER BY` 一起。如果不使用 `ORDER BY`，系统会按照主键进行排序。

值得注意的是，当使用 `WITH TIES` 时，要求必须使用 `ORDER BY`。（请读者思考为什么？）

下面是两个例子：

```sql
-- 查询医院年龄最大的三名医生姓名，年龄。
SELECT TOP 3 Dname, Dage
  FROM Doctor
 ORDER BY Dage DESC

-- 查询医院年龄最大的医生姓名，年龄。
SELECT TOP 1 WITH TIES Dname, Dage
  FROM Doctor
 ORDER BY Dage DESC
```

##### 聚合函数

聚合函数（Aggregate Functions）又称统计函数、集合函数、聚类函数、聚集函数，是指把数据集进行统计、求和、求平均等汇总操作的函数。

```sql
-- 统计在岗医生人数
SELECT COUNT(DISTINCT Dno)
  FROM Diagnosis
```

聚类函数的输出只有一行。如下：

行数|青年医生人数
:-|:-
1|5

常用的聚类函数有：`count()`、`sum()`、`avg()`、`max()`、`min()`。

以上函数都可以在列名前添加 `DISTINCT` 关键字，表示不计算重复分量值。

##### GROUP BY

上面的查询结果都是整体或者整体的聚合函数，使用 `GROUP BY` 函数可以将数据按分组输出、对每一组数据按照聚合函数进行统计输出。

根据 ISO 标准，若使用了 `GROUP BY` 子句，`SELECT` 目标列中的每一项在每一个组中都必须是单值的（相同），即 `SELECT` 语句的查询目标列只能是： `GROUP BY` 分组依据的列、聚集函数、常量，或前三种形式的组合。

以下代码不能运行：

```sql
SELECT employer_name, department, max(salary)
  FROM employer_salary
 GROUP BY department;
-- employer_name 在同 department 下可能有不同值，因此是非单值的项
```

下面是按部门编号统计不同部门的医生人数的代码：

```sql
-- 按部门编号统计不同部门的医生人数
SELECT Ddeptno 部门编码, COUNT(Dno) 人数
  FROM Doctor
 GROUP BY Ddeptno
/*
** 1. SQL 先将医生按照他们所属的部门进行分组，这样就将所有的医生分为四组。
**    在每一组中，所有的医生具有相同的部门编号。
** 2. 对每一组，SQL 计算该组的人员个数。
*/
```


```sql
select name
  from reviewer A
 where
       (select count(stars)
        from rating B
       where A.rid=B.rid
       group by rid)
       >=3
```

`HAVING` 和 `WHERE` 的语法类似，但 `HAVING` 是和 `GROUP BY` 搭配使用的。在 `WHERE`、`GROUP BY`、`HAVING` 同时出现时，代码的执行顺序如下：

1. 按 `WHERE` 子句找出满足条件的数据行；
2. 按 `GROUP BY` 子句指定的列，对经 `WHERE` 子句筛选后的结果进行分组；
3. `HAVING` 子句在 `GROUP BY` 分组之后选择符合条件的分组结果。

借助下面的例子能很好的理解这三者的关系。

```sql
-- 按部门统计男医生的平均年龄不超过 40 岁的部门编号，并按平均年龄升序显示
SELECT Ddeptno 部门编号, AVG(Dage) 平均年龄
  FROM Doctor
 WHERE Dsex='男'
 GROUP BY Ddeptno
       HAVING AVG(Dage)<=40
 ORDER BY AVG(Dage)
```

#### 连接查询

> 同时涉及多个关系表的查询称为连接查询。  
> 用来连接两个表的条件称为连接条件或连接谓词。  
> 多表间的连接运算遵循笛卡儿规则，但“笛卡儿”查询是无条件查询。这种连接操作会产生大量的无意义的数据记录。因此，在进行连接时加上一些限制条件，进行连接运算，这样产生的数据记录是笛卡儿连接结果集的子集。进行连接运算的表，必须存在着有某种关系的公共列，连接运算实际是比较各表的公共列值，如果满足条件的连接产生组合输出行。

##### 连接操作的实现

连接操作的执行大致有三种方法：嵌套循环法，排序合并法和索引连接法。

下面简单介绍这三种方法的执行步骤。

1. 循环嵌套法 (NESTED-LOOP)
   1. 在表 1 中找到第一个元组，然后从头开始扫描表 2，逐一查找满足连接条件的元组，找到后就将表 1 中的第一个元组与该元组拼接起来，形成结果表中一个元组。
   2. 对表 1 剩下的元组依次执行该操作，直到表 1 中的全部元组都处理完毕。
2. 排序合并法 (SORT-MERGE)
   1. 按连接属性对表 1 和表 2 排序。
   2. 对表 1 的第一个元组，从头开始扫描表 2，顺序查找满足连接条件的元组，找到后就将表 1 中的第一个元组与该元组拼接起来，形成结果表中一个元组。当遇到表 2 中第一条大于表 1 连接字段值的元组时，对表 2 的查询不再继续。
   3. 找到表 1 的第二条元组，然后从刚才的中断点处继续顺序扫描表 2，查找满足连接条件的元组，查询的方法与上面类似。
   4. 重复上述操作，直到表 1 或表 2 中的全部元组都处理完毕为止。
3. 索引连接法 (INDEX-JOIN)
   1. 对表 2 按连接字段建立索引。
   2. 对表 1 中的每个元组，依次根据其连接字段值查询表 2 的索引，从中找到满足条件的元组，找到后就将表 1 中的一个元组与该元组拼接起来，形成结果表中一个元组。

##### 内连接

连接方式有内连接和外连接。内连接只在两个表中找出满足连接条件的结果并输出，而外连接会输出一张表的所有元组和另一张表满足连接条件的记录。相比而言，内连接更常用。

内连接的方式依旧是 `select-from-where`，只是需要指出列来自哪一张表。

自然连接分为等值连接（`WHERE` 的条件是 `=`）和非等值连接（其他）。等值连接如下面四例：~~非等值连接咕咕咕了~~

```sql
-- 内连接
-- 查询每个处方的用药信息
SELECT RecipeDetail.*, Medicine.*
  FROM RecipeDetail, Medicine
 WHERE RecipeDetail.Mno = Medicine.Mno

-- 查询急诊内科医生的出诊信息
SELECT Doctor.Dname, Diagnosis.*
  FROM Doctor, Diagnosis, Dept
 WHERE Doctor.Dno = Diagnosis.Dno AND
       Doctor.DdeptNo = Dept.DeptNo AND
       Dept.DeptName = '急诊内科'

-- 下例为自然连接
-- 查询开出处方的医生信息。
SELECT Rno, Pno, D.Dno, Dname, Dsex, Dage, Ddeptno, Dlevel
  FROM RecipeMaster R, Doctor D
 WHERE R.Dno=D.Dno
-- 当为表指定了别名时，在查询语句中的其他用到表名的地方都要使用别名，不能再使用原表名

-- 查询急诊内科每位医生的出诊数量。
SELECT Doctor.Dname, count(*) 出诊数量
  FROM Doctor, Diagnosis, Dept
 WHERE Doctor.Dno = Diagnosis,Dno AND
       Doctor.Ddeptno = Dept.Deptno AND
       Dept.DeptName = '急诊内科'
 GROUP BY Doctor.Dname
```

自连接是一种特殊的内连接。

> 它是指相互连接的表在物理上为同一张表，但可以在逻辑上分为两张表。使用自连接时必须为两个表取别名，使之在逻辑上成为两张表。可以把自连接理解为同一张表（或视图）的两个副本之间的连接，使用不同别名来区别副本，处理过程与不同表之间的连接相同。

```sql
-- 在医院部门表中，需要医院的各部门名称和上级部门名称
SELECT A.DeptName 部门名称, B.DeptName 上级部门
  FROM Dept AS A, Dept AS B
 WHERE A.ParentDeptNo = B.DeptNo
```

##### 外连接

外连接在前面简单说过了，就是输出表 1，和两张表的连接情况。下面是书上的详细介绍：

> 内连接操作只从两个表中找出满足连接条件记录的结果输出。  
> 在某些应用中，我们也希望输出那些不满足连接条件的元组的信息。比如查看全部医生所属的部门信息，包括暂时没有医生的部门情况。
> 如果用内连接实现，则只能找出有医生的部门信息，对不满足关系表 `Doctor.DdeptNo=Dept.DeptNo` 条件的元组是查找不出来的。
> 这种情况就需要用外连接来实现。即两张表的连接查询，要输出一张表的所有元组，另外一张表输出满足连接条件的记录。如果没有满足条件的元组，则用 `NULL` 匹配输出。
> 我们称这种连接查询为外连接，是其他连接方式的扩展。

SQL SERVER数据库系统的命令格式如下：~~看不懂预警~~

```sql
SELECT <查询列表>
    [ INTO <新表名> ]
  FROM <基表1|视图1> [ AS 别名1 ]
    {< LEFT | RIGHT | FULL > [ OUTER ] JOIN}
        <基表2|视图2> [ AS 别名2 ]
    ON <连接条件>
```

我们现在只需要关注第四行：

> 其中，`LEFT OUTER JOIN` 表示左外连，输出左表的所有记录相关列值；右表输出与左表匹配的记录（如果没有与左表匹配的记录，则使用 `NULL` 匹配输出）；  
> `RIGHT OUTER JOIN` 表示右外连，输出右表的所有记录相关列值；左表输出与右表匹配的记录（如果没有与右表匹配的记录，则使用 `NULL` 匹配输出）；
> `FULL OUTER JOIN` 表示全外连接，是左外连接与右外连接所产生结果的并集。

下面是外连接的例子：

```sql
-- 在医院部门表中，查询医院的各部门名称和该部门医生姓名
SELECT DeptName 部门名称, DName 医生姓名
  FROM Dept
       LEFT OUTER JOIN Doctor
    ON Dept.DeptNo = Doctor.Ddep1no
```

上面这个例子的输出如下：

行号|部门名称|医生姓名
:-|:-|:-
1|XX 医院|NULL
2|门诊部|NULL
3|消化内科|杨财
4|急诊内科|郝亦伟
5|急诊内科|罗晓
6|门内三诊室|刘伟
7|社区医疗部|NULL
8|家庭病床病区|邓英超

内连接能方便的实现这样的功能吗？如果只使用上面介绍的内连接，只会输出存在医生的部门，而不会输出医生为 `NULL` 的部门。  
如果使用右外连，可能有医生的部门名称会出现 `NULL`。

#### 嵌套查询

SQL 支持嵌套查询。那么，在哪里可以嵌套呢？

可以在 `WHERE` 和 `FROM` 的地方进行嵌套。

来看一个 `WHERE` 嵌套的例子：

```sql
-- 查询与医生刘伟有诊断关系患者姓名。
SELECT Pname FROM Patient
 WHERE Pno IN
       (SELECT Pno FROM RecipeMaster
         WHERE Dno =
               (SELECT Dno FROM Doctor
                 WHERE Dname = '刘伟'))
```

外层的查询被称为主查询（或父查询），内层的 `SELECT` 查询子句被称为子查询。子查询还允许嵌套子查询，但最多嵌套 255 层。

该查询的执行顺序如下：

1. 首先执行 `SELECT Ono FROM Doctor WHERE Dname='刘伟'`，返回 `21`； 
2. 然后执行 `SELECT Pno FROM RecipeMaster WHERE Ono ='21'`，返回`201`；
3. 最后执行 `SELECT Pname FROM Patient WHERE Pno IN('201')`，返回查询结果。

注意该查询的写法。当医院有且仅有一个名字叫刘伟的医生时，该查询才能正确运行；如果有多个或者没有名字叫刘伟的医生，该查询将会出错。  
主要原因是比较运算符 `=`、`<>`、`<`、`<=`、`>`、`>=` 只能与返回单值的子查询相连。所以，建议这些运算符最好不要与子查询连接使用，最好用 `IN`、`NOTIN`、`ANY`、`ALL`、`EXISTS`、`NOT EXISTS` 等比较运算符代替。

##### IN

`IN` 在 [WHERE](#where) 部分已经提到过了，这里仅放一下配合嵌套查询的语法：

```sql
-- 查询所开处方不包含药品“胃立康片”的医生姓名
SELECT Dname
  FROM Doctor
 WHERE Dno IN 
       (SELECT Dno
          FROM RecipeMaster
         WHERE Rno IN
               (SELECT Rno
                  FROM RecipeDetail
                 WHERE Mno NOT IN
                       (SELECT Mno
                          FROM Medicine
                         WHERE Mname = '胃立康片')))
```

##### ANY ALL

上面的 `IN` 是查询子表有没有这个分量值，而 `ANY` 做的事情是配合比较运算符，查询子表中是否有值满足这个比较式。`ALL` 则配合比较运算符，查询子表中是否所有值都满足这个比较式。

`ALL` 关键字可省略。（顺便，`SELECT` 后的 `ALL` 也可以省略）


```sql
-- 查询小于任何男医生年龄的女医生姓名和年龄
SELECT Dname AS 姓名, Dage AS 年龄
  FROM Doctor
 WHERE Dsex＝'女'
   AND Dage < ALL      -- ALL 可省略
       (SELECT Dage
          FROM Doctor
         WHERE Dsex='男')
```

##### EXISTS

嵌套查询中，还可用 `EXISTS` 运算符与相关子查询相连。其形式如下：

```sql
WHERE [NOT] EXISTS (子查询)
```

带 `EXISTS` 谓词的子查询不返回查询的数据，只产生逻辑真值和逻辑假值。  
基本思想为：如果 `EXISTS` 运算符限定的子查询有查询记录返回，那么该条件为真，否则为假。`NOT EXISTS` 则反之。

```sql
-- 使用相关查询
-- 查询给姓名为“刘景”的患者开过处方的医生。
SELECT Dno AS 医生编号, Dname AS 姓名, Dsex AS 性别,
       age AS 年龄, Dlevel AS 职称
  FROM Doctor
 WHERE EXISTS
       (SELECT *
          FROM RecipeMaster
         WHERE RecipeMaster.Dno = Doc.Dno
           AND EXISTS
               (SELECT *
                  FROM Patient
                 WHERE Patient.Pname = '刘景'
                   AND Patient.Pno = RecipeMaster.Pno))
```

该查询还可以使用如下的不相关子查询：

```sql
-- 使用不相关查询
-- 查询给姓名为“刘景”的患者开过处方的医生。
SELECT Dno AS 医生编号, Dname AS 姓名, Dsex AS 性别,
       age AS 年龄, Dlevel AS 职称
  FROM Doctor
 WHERE Dno IN
       (SELECT Dno
          FROM RecipeMaster
         WHERE RecipeMaster.Pno IN
               (SELECT Pno
                  FROM Patient
                 WHERE Patient.Pname = '刘景'))
```

除此之外，还可以用连接查询。

```sql
-- 使用连接查询
-- 查询给姓名为“刘景”的患者开过处方的医生。
SELECT D.Dno AS 医生编号, D.Dname AS 姓名, D.Dsex AS 性别,
       D.age AS 年龄, D.Dlevel AS 职称
  FROM Doctor AS D, RecipeMaster AS R, Patient AS P
 WHERE D.Dno = R.Dno
   AND R.Pno = P.Pno
   AND Pname = '刘景'
```
这说明同一个查询可以有多种实现方式。

由于查询优化器可以对多表连接查询进行更多的优化，总体上来说，**多表连接查询**的执行效率会高于子查询的执行效率。

##### FROM 嵌套

上面一例还可以使用 `FROM` 嵌套。~~有完没完啦~~

```sql
-- 使用连接查询和 FROM 嵌套
-- 查询给姓名为“刘景”的患者开过处方的医生。
SELECT D.Dno AS 医生编号, D.Dname AS 姓名, D.Dsex AS 性别,
       D.age AS 年龄, D.Dlevel AS 职称
  FROM Doctor,
       (SELECT RecipeMaster.Dno
          FROM RecipeMaster, Patient
         WHERE RecipeMaster.Pno=Patient.Pno
           AND Patient.Pname='刘景') AS R
 WHERE Doctor.Dno=R.Dno
```

注意，由于 `FROM` 嵌套子查询的结果没有名字，必须给它取一个别名。

#### 集合查询

> 在关系代数中可以用集合操作的并、交、差来组合关系。在查询结果上， SQL 提供了对应的操作，条件是这些查询结果提供的关系具有相同的属性和属性类型列表。保留字 `UNION`、`INTERSECT`、`EXCEPT` 分别对应关系代数中的并、交和差运算符。
> 进行集合查询连接多个 `SELECT` 语句时，只能在最后 `SELECT` 查询表达式之后指定 `ORDER BY` 子句，决定查询记录的输出顺序。但 `ORDER BY` 子句后面不能引用列名，仅能引用相应列在查询列表中的顺序号。

算了直接看例子吧。

> 在医院数据库中，为了提高系统处理效率，要定期对患者的诊断信息归档。假定患者诊断归档信息表为 DiagnosisBak, 如果医生要查询患者“刘景”的近期和历史诊断信息，以便分析患者的病因。其查询语句如下：

```sql
SELECT DGno AS 诊断号, Dname AS 医生姓名, Symptom AS 症状,
       Diagnosis AS 诊断, DiagDateTime AS 时间
  FROM DiagnosisBak AS DiagB, Doctor AS Doc, AS Patient P
 WHERE DiagB.Dno = Doc.Dno
   AND P.Pno = DiaB.Pno
   AND P.Pname = '刘景'
 UNION
SELECT DGno, Dname, Symptom, Diagnosis, DiagDateTime
  FROM Diagnosis AS Diag, Doctor AS Doc, Patient AS P
 WHERE Diag.Dno = Doc.Dno
   AND P.Pno = DiaB.Pno
   AND P.Pname ='刘景'
```

### 数据插入

#### 插入元组

也就是一行一行地插入。使用 `insert-into-values`：

```sql
INSERT INTO Doctor(Dno, Dname, Dsex, Dage, DDeptNO, Dlevel)
VALUES ('145', '王军', '男', 28, '101', '医师')
```

* 可以省略表名 `Doctor`，表示向目标表所有列插入数据；
* 可以省略列名 `(Dno,Dname,Dsex,Dage,DDeptNO,Dlevel)`，但 VALUE 就必须按照默认的顺序；使用列名，可以交换顺序；
* 对于省略部分列名的情况，对应列使用默认值，或 `NULL`。

```sql
INSERT INTO Doctor
VALUES ('145', '王军', '男', 28, '101', '医师')
```

#### 插入子查询的结果

用 `insert-into-select`，把查询内容直接插到另一个表。不求两个表列名相同，只求长度、对于位置的数据类型兼容。

```sql
-- 统计每个医生每天诊断的患者数量，并把结果存入数据库
INSERT INTO DiagNum (Dno, DiagDate, PatientNum)
SELECT Dno, Rdatetime, COUNT(DGno)
  FROM RecipeMaster
 GROUP BY Dno, Rdatetime
```

### 数据修改

如果某些数据发生了变化，就需要对表中已有的数据进行修改。

可以使用 `update-set-where` 语句对数据进行修改，其语句的一般格式为：

```sql
UPDATE <基表名>
   SET <列名1>=<表达式2>，<列名2>=<表达式2>…
[WHERE <条件表达式>]
```

其功能就是修改指定表中满足 `WHERE` 子句条件的元组，将这些元组在 `SET` 子句给出的属性列分量值用 `<表达式>` 的值取代。

如果省略 `WHERE` 子句，则表示要修改表中所有元组（称作无条件修改）。

`UPDATE` 语句中 `WHERE` 子句的作用和写法同 `SELECT` 语句中的 `WHERE` 子句一样。

```sql
-- 无条件修改
-- 将所有医生的年龄增加 1 岁
UPDATE Doctor
   SET Dage = Dage + 1

-- 修改某一元组的值
-- 将编号为 '423' 的患者的社会保险号，修改为 '20073425'。
UPDATE Patient
   SET Pino = '20073425'
 WHERE Pno = '423'

-- 带子查询的修改语句
-- 将门诊部所有医生的工资上浮 10%
UPDATE Doctor
   SET Dsalary = Dsalary + Dsalary * 0.1
 WHERE Ddeptno IN
       (SELECT DeptNo
          FROM Dept
         WHERE DeptName = '门诊部')
```

### 数据删除

当确定不再需要某些元组时，可以使用删除语句 `DELETE`。删除语句的一般格式为：

```sql
DELETE FROM <即表明>
[WHERE <行选择条件>]
```

其功能是从指定表中删除满足 `WHERE` 子句条件的所有元组。

如果省略 `WHERE` 子句，则表示删除表中所有元组，但表的定义仍在字典中。也就是说，`DELETE `语句删除的是表中的数据，而不是关于表的定义。

```sql
-- 删除所有医生的记录
DELETE
  FROM Doctor
-- 这条 DELETE 语句删除了 Doctor 表中的所有元组，使 Doctor 表成为空表

-- 删除某一个元组
-- 将编号为 '423' 的患者从系统中删除
DELETE
  FROM Patient
 WHERE Pno = '423'

-- 将门诊部所有医生的信息删除
DELETE
  FROM Doctor
 WHERE Ddeptno IN
       (SELECT DeptNo
          FROM Dept
         WHERE DeptName = '门诊部')
```

## 视图

在数据库的基本概念中降到数据库的三层模式结构（外模式、模式、内模式）。而外模式对应到数据库中的概念就是视图。

> 视图是一种特殊类型的表。它是从一个或多个基表（或视图）导出的表，是基本表的部分行或列数据的组合。
> 视图可定义在一个或多个基表上，或者其他视图上。
> 视图本身并不存储任何数据，只提供了一种访问基表中数据的方法。
> 可以简单地认为视图是一个逻辑虚表。
> 数据库中只存放视图的定义，而不存放视图包含的数据。当基本表中的数据发生变化后，从视图查询出的数据也会随之变化。从这个意义上说，视图就像一个窗口，用户透过它可以看到自己感兴趣的数据。  
> 当视图建立后，用户可以像基表一样对视图进行数据查询，在某些特殊情况下，还可以对视图进行修改和插入操作。

### 视图的定义

定义视图的 SQL 语句是 `CREATE VIEW`，其一般格式为：

```sql
CREATE VIEW <视图名> ［ (视图列名) ］
    AS <子查询>
[ WITH CHECK OPTION J
```

（一千行纪念！）

* `视图列名`可以省略，如果省略了，则视图的列名由查询语句中查询结果显示的列名组成。但下列三种情况下必须明确指定 `视图列名`：
  1. 某个目标列不是单纯的属性名，而是聚集函数或列表达式
  2. 多表连接时选出几个同名列作为视图的字段
  3. 需要在视图中为某个列启用新的更合适的名字
* 若视图列表不省略，则属性列的个数应与子查询的目标列个数相一致。
* 视图不能为列指定数据类型和长度，而是默认为数据源的类型和长度。
* `<子查询>` 可以是任意的 `SELECT` 语句，但不允许包含 `ORDER BY` 子句和 `DISTINCT` 短语。
* `WITH CHECK OPTION` 选项表示对视图进行更新操作（插入、修改和删除）时会进行检查，要保证插入、修改和删除的行满足视图定义中 `<子查询>` 的条件表达式。

```sql
-- 为消化内科诊断的患者信息建立一个视图
CREATE VIEW DiagView
    AS SELECT DGno, P.Pno, Pname, Doc.Dno, 
              Dname, Symptom, Diagnosis, DiagDateTime
         FROM Diagnosis AS Diag, Doctor AS Doc, Patient AS P
        WHERE Diag.Dno = Doc.Dno
          AND P.Pno = Diag.Pno
          AND Doc.DdeptNo IN 
              (SELECT DeptNo
                 FROM Dept
                WHERE DeptName = '消化内科')
```

本例中省略了视图 `DiagView` 的列名，隐含视图列名由子查询中SELECT 目标列组成。

RDBMS 执行 `CREATE VIEW` 语句的结果只是把视图的定义存入数据字典，并不执行其中的 `SELECT` 语句。
只有对视图执行查询操作时，才按视图的定义从相应基本表中检索数据。

```sql
/* 为消化内科诊断的患者信息建立一个视图
   要求进行修改和插入操作时仍需保证该视图只有消化内科的患者 */
CREATE VIEW DiagView
    AS SELECT DGno, P.Pno, Pname, Doc.Dno, 
              Dname, Symptom, Diagnosis, DiagDateTime
         FROM Diagnosis AS Diag, Doctor AS Doc, Patient AS P
        WHERE Diag.Dno = Doc.Dno
          AND P.Pno = Diag.Pno
          AND Doc.DdeptNo IN 
              (SELECT DeptNo
                 FROM Dept
                WHERE DeptName = '消化内科')
  WITH CHECK OPTION
/* 这意味着，以后对该视图进行修改、删除操作时
   RDBMS 会自动加上 DeptName='消化内科' 的条件
   若进行插入操作，RDBMS 自动检查插入医生的 DeptName 属性列的值是否为消化内科
   如果不是则拒绝执行操作 */
```

视图不仅可以建立在基本表上，还可以建立在已定义好的视图上，或建立在基本表和视图之上。

```sql
-- 为消化内科 2007 年诊断的患者信息建立一个视图。
CREATE VIEW DiagView_check_2007
    AS SELECT *
         FROM DiagView_check
        WHERE DiagDateTime > '2007-1-1'
          AND DiagDateTime < '2007-12-30'
-- 这里的视图 DiagView_check_2007 就是建立在视图 DiagView_check 之上的
```

定义视图时可以根据应用的需要设置一些派生属性列，这样的视图称为带表达式的视图。

```sql
-- 将消化内科医生的年薪建立一个视图
CREATE VIEW Doc_Deg_sal (Dno, Dname, Salary)
    AS SELECT Dno, Dname, Dsalary * 12
         FROM Doctor
        WHERE DdeptNo IN
              (SELECT DeptNo
                 FROM Dept
                WHERE DeptName = '消化内科')
-- 视图中的 Salary 属性列的值通过计算得到
```

还可以用带有聚集函数和 `GROUP BY` 子句的查询来定义视图，这种视图称为分组视图。

```sql
-- 定义视图反映各部门的医生人数
CREATE VIEW Dept_num (Deptno, Dnumber)
    AS SELECT Ddeptno, COUNT(Dno)
         FROM Doctor
        GROUP BY Ddeptno
```

上面两例中，由于 `SELECT` 语句中的目标列包含有表达式和聚集函数，且在查询语句中没有为这样的列指定别名，则在 `CREATE VIEW` 中必须明确定义视图的各个属性列名。

### 视图的删除

```sql
DROP VIEW <视图名> [CASCADE]
```

使用 `CASCADE` 级联删除语句，把该视图和它导出的所有视图一起删除。

若基本表被删除，由该基本表导出的所有视图仍存在，但已无法使用。删除这些视图需显式地使用 `DROP VIEW` 语句。

```sql
-- 删除视图 DiagView_check
DROP VIEW DiagView_check
/* 由于 DiagView_check 视图还导出了 DiagView_check_2007 视图，
   上述删除操作将被使 DiagView_check_2007 视图不能再使用
   可以使用级联删除语句将两个视图都删除 */
DROP VIEW DiagView_check CASCADE
```

### 视图的查询

视图的查询和[基本表查询](#数据查询)完全一样。

### 视图的更新

根据视图的定义，一个视图要么是只读的视图要么是可更新的视图。

对一个只读的视图就只能执行 `SELECT` 语句。所有视图都至少是可读的。

对可更新的视图，用户就可以执行 `INSERT`、`UPDATE` 或 `DELETE` 操作。

> 这里提到的操作，均为对数据的更新操作，而不是 `DELETE VIEW` 等对视图本身的操作。

由于视图是不存储数据的虚表，数据是来自其他基表的部分数据，对视图的更新最终是对基表的更新。因此只能对特殊的视图进行更新。下面将介绍视图更新操作的限制条件。

1. 只能对直接定义在一个基表上的视图进行插入、修改、删除等更新操作。

> 对定义在**多个基表或多个其他视图**之上的视图，数据库管理系统不允许进行更新操作。

上面这一点其实有一点歧义。  
首先肯定的是，SQL Server 不允许会影响多个基表的修改操作；  
然而，如果修改操作不会影响到多个基表（举个例子，视图 V1 基于基表 T，视图 V2 为 V1 和 T 的连接的结果，则修改 V2 只会影响到基表 T），这种操作是允许的。

```sql
-- 在医院数据库中，创建了医生与患者的诊断信息视图
-- 该视图为不可修改视图
CREATE VIEW DiagView
    AS SELECT DGno, P.Pno, Pname, Doc.Dno,
              Dname, Symptom, Diagnosis, DiagDateTime
         FROM Diagnosis Diag, Doctor Doc, Patient P
        WHERE Diag.Dno = Doc.Dno
          AND P.Pno = Diag.Pno
```


2. 如果视图数据只来源于一个基表，但 `SELECT` 语句含有 `GROUP BY`、`DISTINCT` 或聚集函数等，除可执行删除操作外，不能进行插入或修改操作。

这个操作感觉从逻辑上说没有问题，可能会在数据库的实现上可能导致效率低下。

```sql
-- 在医院数据库中，统计每位医生每天诊断工作量，建立如下视图
-- 该视图除可执行删除操作外，不能进行插入或修改操作
CREATE VIEW DiagNum (Dno, DiagDate, PatientNum）
    AS SELECT Dno, Rdatetime, COUNT(DGno)
         FROM RecipeMaster
        GROUP BY Dno, Rdatetime
```

3. 如果视图中包含由表达式计算的列，则不允许进行更新操作。

```sql
-- 在药品信息表中，为药品单价提高 15% 后建立药品价格视图
-- 不能修改该视图中的药品单价
CREATE VIEW MedicineNewPrice (Mno, Mname, Newprice, Munit, Mtype)
   AS SELECT Mno, Mname, Mprice * 1.15, Munit, Mtype
        FROM Medicine
       WHERE Mprice * 1.15 >= 30
```

4. 如果视图满足上述 3 个条件，但该视图中没有包含基表的所有 `NOT NULL` 列，则不能对该视图进行插入操作。

原因是，对视图的插入实际是对基表的插入操作。当视图没有包含基表的所
有 `NOT NULL` 列时，在向视图进行插入时，系统默认为 `NULL`，这与定义中的 `NOT NULL` 相矛盾。

### 视图的作用

~~复制粘贴警告~~

视图是定义在基本表之上的一个虚表，对视图的操作最终是对基本表的操作，且视图操作中有许多限制条件。这样看来视图似乎没有什么作用。但实际上，如果能合理地利用视图将带来许多好处。

1. 视图能简化用户的操作
  
当视图中数据不是直接来自基本表时，定义视图能够简化用户的操作。

- 基于多张表连接形成的视图
- 基于复杂嵌套查询的视图
- 含导出属性的视图


2. 视图对重构数据库提供一定程度的逻辑独立性

当我们重构数据库时会改变数据库的逻辑结构，如增加新的关系或改变原有关系的属性列等。要保证数据的逻辑独立性，使用户的应用程序不受影响，就要使用户的外模式保持不变。

视图是构建外模式的一种方式。

数据库重构最常见的方法是把基本表做“垂直“划分，将一个基本表分成多个基本表。例如将医生 `Doctor` 关系表：

`Doctor(Dno,Dname,Dsex,Dage,Ddeptno,Dlevel,Dsalary)`

分为 `Doctor_x(Dno,Dname,Dsex,Dage)` 和 `Doctor_y(Dno,Ddeptno,Dlevel,Dsalary)` 两个关系。那么用户应用程序中原来对 `Doctor` 关系的操作就要转换为对 `Doctor_x` 和 `Doctor_y` 的操作，修改麻烦。

这时可建立一个 `Doctor` 视图：

```sql
CREATE VIEW Doctor(Dno, Dname, Dsex, Dage, Ddeptno, Dlevel, Dsalary
    AS SELECT Doctor_x.Dno, Dname, Dsex, Dage, Ddeptno, Dlevel, Dsalary
         FROM Doctor_x, Doctor_y
        WHERE Doctor_x.Dno = Doctor_y.Dno
```

这样应用程序就不必修改。 

当然，视图只能在一定程度上提供数据的逻辑独立性。如果视图是不可更新的，则应用程序中修改数据的语句仍要随着基本表结构的改变而改变。

3. 视图为用户提供多个视角看待同一数据

4. 提高数据的安全性

对不同用户定义不同视图，使得每个用户只能看到他有权看到的数据.

例如，医生关系中每个医生的薪水是保密的。就可以定义一个不包括薪水字段的视图供用户操作，不让用户直接操作基本表。这样，就在一定程度上提高了数据的安全性。

5. 保证数据的完整性

若在视图定义时使用了 `WITH CHECK OPTION` 选项，那么 SQL 就能保证进入基本表中的元组都能满足 `WHERE` 子句中给出的限定条件。

## 索引

* 建立索引是加快查询速度的有效手段
* 索引由 DBMS 内部实现，属于内模式范畴
* 建立索引
    - DBA或表的属主（即建立表的人）根据需要建立
    - 有些 DBMS 自动建立以下列上的索引: `PRIMARY KEY` 和 `UNIQUE`
* 维护索引
    - DBMS 自动完成 
* 使用索引
    - DBMS自动选择是否使用索引以及使用哪些索引


### 索引的分类

根据索引与数据表的存储特点可以分为：聚簇索引、非聚簇索引和唯一索引。

1. 聚簇索引
   
* 建立聚簇索引后，基表中数据也需要按指定的聚簇属性值的升序或降序存放。也即聚簇索引的索引项顺序与表中记录的物理顺序一致
* 在一个基本表上最多只能建立一个聚簇索引
* 聚簇索引的用途：对于某些类型(范围查找)的查询，可以提高查询效率
* 聚簇索引的适用范围
    - 很少对基表进行增删操作
    - 很少对其中的变长列进行修改操作 

```sql
-- 
CREATE CLUSTER INDEX Stusname
    ON Student(Sname);
```

1. 非聚簇索引

* 数据存储在一个地方，索引存储在另一个地方，索引带有指针指向数据的存储位置。
* 索引中的项目按索引键值的顺序存储，而表中的信息按另一种顺序存储（也可以由聚簇索引规定）。
* 在搜索数据值时，先对非聚集索引进行搜索，找到数据值在表中的位置，然后从该位置直接检索数据。
* 由于索引包含描述查询所搜索的数据值在表中的精确位置的条目，这使非聚集索引成为精确匹配查询的最佳方法。


3. 唯一索引

* 唯一索引确保索引列不包含重复的值。在多列唯一索引的情况下，该索引可以确保索引列中每个值组合都是唯一的。
* 聚集索引和非聚集索引都可以是唯一的。因此，只要列中的数据是唯一的，就可以在同一个表上创建一个唯一的聚集索引和多个唯一的非聚集索引。
* 创建PRIMARY KEY或UNIQUE约束会在表中指定的列上自动创建唯一索引。
* 在同一个列组合上创建唯一索引而不是非唯一索引可为查询优化器提供附加信息，所以最好创建唯一索引。

### 索引的原则

1. 选择数据量较大的表建立索引 

一般来说，对于数据量较大的表，数据库系统越有机会找到最短路径，索引越能更好地改善响应的时间，越能显示出优势。

索引对于列中的数据多而杂的列是特别有用。例如，在医院信息系统中，如果对患者诊断信息建立索引，速度提高的效果就比较明显。但是，不适宜在性别列上建立索引，因为有大量重复值，对其索引反而会降低查询速度。

对于数据量较小的表最好不要建立索引，因为对小表索引，速度提高不仅不明显，反而会增大系统的开销，除非有特殊需要，要建立唯一索引来加强唯一。

2. 建立索引的数量要适量（需要付出代价） 

尽管对一个基表可以建立多个索引，提高查询速度，但不宜建立太多的索引，最好不超过 3 个。

- 索引要占用磁盘空间
- 系统要维护索引结构，维护索引结构系统要花费一定的开销，尤其是经常要插入或删除的表，其维护索引结构的代价是很大的，因此建立索引会减慢插入、修改、删除的执行速度。

用户应该在加快查询速度和降低更新速度之间作出权衡。对于一个仅用来查询的表来讲，建立多个索引是比较合适的，但对更新操作比较频繁的表来讲最好少建立一些索引。

3. 选择合适的时机建立索引 

通常，建立索引应选择在表中装入数据之后。如果先建立索引后装入数据，则每次插入一行数据都要对索引进行更新，这样会很浪费时间。

但是，如果要保证装入数据的唯一性，则只能以牺牲系统性能为代价，而在装入数据前建立唯一性索引。

4. 优先考虑主键列建立索引 

当主键包含多列时，最好把数据差异最多的列放在索引命令列表的首位。

如果各列数据种类相近，则最好把经常用到的列放在前面。

最好选择包含大量非重复值的列，如医生编号。

如果只有很少的非重复值，如性别只有男和女，最好不要使用索引查询，此时采用顺序扫描更为有效。


### 索引的创建与删除

```sql
-- 创建单列索引
-- 在药品基本信息表中，在药品名称上，按照升序创建非聚簇索引
CREATE NONCLUSTERED INDEX MedIndex
ON Medicine(Mname ASC) 

-- 创建复合索引
-- 在处方详细信息表中，在处方编码和药品编码上，创建聚簇索引
CREATE CLUSTERED INDEX RDIndex
ON RecipeDetail (Rno ASC, Mno DESC) 

-- 创建唯一索引
-- 在医生基本信息表上，在医生编码上，创建唯一索引
CREATE UNIQUE INDEX DoctorIndex
ON Doctor (Dno ASC)

-- 删除 DoctorIndex 索引
DROP INDEX DoctorIndex 
```
