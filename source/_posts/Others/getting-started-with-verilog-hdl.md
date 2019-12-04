---
title: Verilog HDL 速成手册
date: 2019-12-02 21:37:29
tags:
- 课程笔记
mathjax: true
---

数字逻辑要学这个，于是整理了一篇笔记。顺便说一下，如果打算写代码，我们使用的是 `Xilinx 14.5 Webpack`。（安装下来占了 20G，我只是想入个 Verilog 的门。。。。）

## 概述

（以下抄 PPT）

> Verilog HDL（以下简称 Verilog）是一种硬件描述语言，用于从算法级、门级到开关级的多种抽象设计层次的数字系统建模。 

Verilog硬件描述语言的主要功能包括：

1. **基本逻辑门**，例如 `and`、`or` 和 `nand` 等都内在语言中。
2. **用户定义原语**（UDP）创建的灵活性。用户定义的原语既可以是组合逻辑原语，也可以是时序逻辑原语。（UDP太难，应该不考）
3. 提供显式语言结构指定设计中的端口到端口的**时延**及路径时延和设计的时序检查。
4. 可采用三种不同方式或混合方式对设计建模。这些方式包括：
   * **行为描述方式**——使用过程化结构建模；
   * **数据流方式**——使用连续赋值语句方式建模；
   * **结构化方式**——使用门和模块实例语句描述建模。
5. Verilog HDL 中有两类数据类型：**网络数据类型和寄存器数据类型**。网络类型表示构件间的物理连线，而寄存器类型表示抽象的数据存储元件。

等我学完这一章以后再来看看哪些不重要，可以删。

> 2019.12.4：从八点删到四点（不算 UDP），不愧是我。

## 程序基础

### Verilog 由模块构成

> 一个复杂电路系统的完整 Verilog HDL 模型是由若干个 **Verilog HDL 模块**构成的，每一个模块又可以由若干个子模块构成。

（划重点，模块 `module` 思想）

模块是什么？

> 用 Verilog HDL 描述的电路设计就是该电路的 Verilog HDL 模型，也称为模块，是 Verilog 的基本描述单位。  
> 一般来说一个模块可以是**一个元件**或者是**一个更低层设计模块的集合**。  
> 模块是**并行运行**的，通常需要一个高层模块通过调用其他模块的实例来定义一个封闭的系统，包括测试数据和硬件描述。

老师连 PPT 都不分行的吗，还得我手动分行。。。

### 代码结构

Verilog 程序结构：

```v
// 模块声明
module 模块名（端口列表）

    // 端口定义
    input 输入端口
    output 输出端口
    inout 输入/输出端口

    // 数据类型说明
    wire
    reg
    parameter

    // 逻辑功能定义
    assign
    always
    function
    task
    // ....

endmodule
```

以上各部分解释：

* <模块名> 是模块唯一的标识符；
* <端口列表> 是由模块各个**输入**、输出和双向端口组成的一张端口列表，这些端口用来与其他模块进行通信；
* 数据类型说明部分：用来指定模块内用到的数据对象为**寄存器型**、**存储器型**还是**连线**型；
* 逻辑功能定义部分：通过使用**逻辑功能语句**来实现具体的逻辑功能。

## 语言要素

* 每个 Verilog HDL 程序源文件都以 `.v` 作为文件扩展名。
* Verilog HDL 区分大小写。
* Verilog HDL 程序的书写与 C 语言类似
  * 一行可以写多条语句，也可以一条语句分成多行书写
  * **每条语句以分号结束**（`endmodule` 语句后不加分号）
  * 新行、制表符和空格没有特殊意义
  * 间隔符包括空格字符 `\b`、制表符 `\t`、换行符 `\n` 以及换页符。
  * 注释和 C 语言完全相同，有两种风格：

```v
 /*第一种形式：可以扩展至多行* /
 //第二种形式：在本行结束。
```

关于标识符：

> Verilog HDL 中的标识符 `identifier`可以是任意一组字母、数字、`$` 符号和 `_` (下划线)符号的组合，是赋予一个对象唯一的名字。  
> 标识符的第一个字符必须是字母或者下划线。  
> 标识符是区分大小写的。

关于关键字，类似于 C 语言的关键字概念，如 `if` `int` 等：

> Verilog HDL 语言内部使用的词称为关键字或保留字，保留字不能随便使用。所有的关键字都使用小写字母。

运算符部分[见后](#操作符)。

## 程序结构

### 模块声明

```v
module <module_name>(port_name1,…,port_namen);

// ...
// ...

endmodule;
```

* `module_name` 为模块名（类似于 C 语言的函数名）。
* `port_name` 为端口名（类似于函数的输入输出），

### 端口定义

```v
input <input_port_name>, ...<other_inputs>...;   //输入
output <output_port_name>,...<other_outputs>...; //输出
inout <inout_port_name>,...<other_inouts>...;    //双向端口
```

双向端口类似于输入以后被修改了，然后输出？

注意：

1. 在声明输入/输出时，要声明其数据类型是 `net` （网络）型还是 `reg` （寄存器）型；默认为 `net` 类型中的 `wire` 类型。
2. 无论是在网络说明还是寄存器说明中，网络或寄存器必须与端口说明中指定的宽度相同。
3. 输入和双向端口不能声明为寄存器型。

也可以使用 C 语言风格的端口声明。

如果看不懂网络和寄存器的概念，请跳转到[数据类型](#数据类型)部分，看一眼概念，然后再回到这里来。

示例：

```v
module addr(cout,sum,ina,inb,cin);
    input cin;
    input[7:0] ina,inb;
    output[7:0] sum;
    output cout;
    //...
endmodule
```

```v
module fulladd4(output reg [3:0] sum, output reg c_out,
    input [3:0] a,b,input c_in);
     
    //...

endmodule 
```

### 变量声明

见[数据类型声明](#数据类型声明-2)。

## 数值和数据类型

### 逻辑值

~~为什么他 PPT 不写这个啊啊啊，很重要的啊~~

逻辑值有四种：

逻辑值|硬件电路中的条件
-|-
`0`|逻辑 0，条件为假
`1`|逻辑 1，条件为真
`x`|逻辑值不确定
`z`|高阻，浮动状态

注意 `x` 和 `z` 不分大小写。

### 常量

> 在程序运行过程中，不能改变的量称为常量 `constants`。  
> Verilog HDL中有三类常量：  
> 1. 整型；  
> 2. 实数型；（不重要）  
> 3. 字符串型。（不重要）  

#### 整数常量

整数型常量可以按如下两种方式描述：

1．简单的十进制格式（不重要）

这种形式的整数定义为带有一个 `+` （可省略）或 `-` 的数字序列。如：

描述|值
-|-
`32`|十进制数 32
`-15`|十进制数 -15

2．基数表示法（重要）

> 预警：这部分可能会有一点点无聊。

这种形式的整数格式为：`<size><'base_format><number>`；

* `<size>`：常量的位的长度。
* `<'base_format>`：`'` 加字母指明基数，如十进制 `d`、二进制 `b`、八进制 `o`、十六进制 `h`。
* `<number>`：是基于基数的值的数字序列，可以出现 `0123456789abcdefxz`。

注意：三个部分都不区分大小写。

示例：

描述|值
-|-
`5'O37`|5位二进制显示的八进制数
`4'D2`|4位二进制显示的十进制数
|
`4'd-4`|非法，数值不能为负
`-4'd4`|合法
|
`8 'h 2A`|合法，在位长和 `'` 之间、基数和数值之间允许出现空格
`3' b001`|非法，`'` 和基数之间不允许出现空格
`(2+3)'b10`|非法，位长不能够为表达式
|
`9'o721`|9位二进制显示的八进制数
`8'hAF`|8位二进制显示的十六进制数

对于一个 `x` 和 `z`，在不同基数的长度也不同：在二进制中长度为 1，八进制中长度为 3，十六进制中长度为 4。

描述|值
-|-
`4'b100x`|即二进制的 `100x`
`8'h1x`|即二进制的 `0001xxxx`

当数字序列 `<number>` 的长度小于 `<size>` 时，就会用 `0`、`x`、或`z` 来填充。具体用谁填充，取决于最高位是 `x`、`z`、还是其他。

描述|值
-|-
`7'Hx`|7位 `x`，即 `xxxxxxx`
`4'hZ`|4位 `z`，即 `zzzz`
`10'b10`|左边添 `0` 占位，即`0000000010`
`10'bx0x1`|左边添 `x` 占位，即 `xxxxxxx0x1`

当数字序列 `<number>` 的长度大于 `<size>` 时，就会取 `<size>` 的位宽而把 `<number>` 的高位截断。

`3'b10010011` == `3'b011`  
`5'H0FFF` == `5'H1F`

> 无聊的部分结束。

还有实数、字符串类型，但是不考，故删掉了。

### 数据类型

数据类型上，分为 `net`（线网型）和 `reg`（寄存器型）。

`reg` 类型，是使用寄存器实现，用于存储数据，类似于电脑 CPU 的寄存器、内存等等。

> 寄存器型变量与网络络数据的区别主要在于：寄存器型变量保持最后一次的赋值，而 `wire` 型数据需要有连续的驱动。  
> 寄存器型变量只能在 `initial` 或 `always` 内部被赋值。

而 `net` 分为 `wire`、`wand`、`wor` 等等，由于 `wire` 类型的线网声明最常用，所以 `net` 和 `wire` 概念经常互换使用。

而 `wire` 是什么呢？翻译成 `连线` 非常抽象，让人难以理解。其实呢，`wire` 是个很常见的东西：

想象一个“与门”，它有两个输入 `A` 和 `B`，输出 `F`。  
在这里 `A`、`B`、`F` 都是电线，他们也就是所谓的 `线网` 或 `wire`。

合理猜测，对于线网型和寄存器型，将是两种风格的编程；前者是描述各种“门”，后者是类似于 C 语言的赋值、赋值、再赋值的编程。

确实如此。[概述](#概述)的第 5 点提到，

> **行为描述方式**——使用过程化结构建模；
> **数据流方式**——使用连续赋值语句方式建模；  
> **结构化方式**——使用门和模块实例语句描述建模。

* `行为描述方式`即是使用赋值、寄存器、`if`、`for` 等流程的 C 语言风格。（面向过程编程）  
* `结构化`即是描述各个门，使用线网类型的结构化风格（面向门结构编程）。  
* 至于`数据流`，是使用 `out=~(A&B)` 这种赋值形式替代了门结构的描述（面向数据编程），也是使用线网类型编程

当然也可以混合编程。

等我学完这一章以后再来看看是不是这样。

> 2019.12.4 更新：改掉了不对的地方。。。顺便总结了面向xx编程。

最后稍微提一下整数 `integer` 类型。

> 在算术运算中被视为二进制补码形式的有符号数。整型数据与 32 位的寄存器型数据在实际意义上相同，只是寄存器型数据被当做无符号数来处理。  
> 需要注意的是虽然 `interger` 有位宽度的声明，但是 `integer` 型变量不能作为位向量访问。`D[6]` 和 `D[16:0]` 的声明都是非法的。  
> 在综合时，`integer` 型变量的初始值是 `x`

其实用的不多，毕竟只是很简略的讲一下 Verilog，寄存器已经够入门使用了。

另外还有实数型、时间型变量，用的不多，就这么提一笔就了了。

### 变量声明

用到变量前需要声明。

顺便再提一遍，要是没有写类型，默认为 `wire`。

示例：

```v

integer i,j;
integer[31:0] D;

reg cout; //定义信号 cout 的数据类型为 reg
reg[7:0] out; //定义信号 out 的数据类型为8位 reg

wire A,B,C,D,F; //定义信号 A,B,C,D,F 为 wire（连线）型
wire [7:0] data; //声明一个 8bit 宽的网络型
```

示例：寄存器变量的声明及使用

```v
module mult(clk, rst, A_IN, B_OUT);

input clk,rst,A_IN;	
output B_OUT;
reg arb_onebit = 1'b0;

always @(posedge clk or posedge rst)
begin
    if (rst)
        arb_onebit <= 1'b1;
    else
        arb_onebit <= A_IN;
    end
end
    B_OUT <= arb_onebit;
endmodule
```

看不懂代码的更多细节，可以暂时放一下。

### 参数

类似于 C 语言的 `#define` 宏定义。

> 参数不是变量，而是常量。用参数声明一个可变常量，常用于定义延时及宽度等参数。

参数定义的例子：

```v
parameter BUS_WIDTH=8;
reg [BUS_WIDTH-1:0] my_reg;
```

示例：参数的声明及使用

```v
module lpm_reg (out, in, en, reset, clk);

    parameter SIZE=1;
    input in, en, reset, clk;
    output out;
    wire [SIZE-1:0] in;
    reg [SIZE-1:0] out;

    always @(posedge clk or negedge reset)
    begin
        if (!reset)  out<=1’b0;
        else
            if(en)  out<=in;
            else  out <= out;
    end
endmodule
```

### 向量

向量就是数组。

向量的声明示例：

```v
wire [7:0] array1 [0:255][0:15];
```

> 该声明表示一个 256*16 的 `wire` 型数据，其中的每个数据是 8 位的宽度。只能在结构化描述的 Verilog HDL 中分配。

```v
reg [63:0] array2 [255:0][7:0]
```

> 该声明表示一个 256*8 的 `reg` 型数据，其中的每个数据是 64 位宽度。只能在行为化描述的 Verilog HDL 中分配。

```v
wire [7:0] array3 [0:15][0:255][0:15]
```

> 该声明表示一个三维的向量，表示 16 个 256*16 的 `wire` 型数据，每个数据 8 位宽度。只能在结构化描述的 Verilog HDL 中分配。

看了几个例子，应该比较懂了。数组用的不多，倒是变量的位数用的比较多。

**声明变量位数是从高到0！！！**

## Verilog 表达式

### 操作符

> Verilog HDL 中的操作符按功能可以分为下述类型：算术操作符、关系操作符、相等操作符、逻辑操作符、按位操作符、归约操作符、移位操作符、条件操作符、连接和复制操作符；  
> 按运算符所带操作数的个数可分为三类：单目操作符、双目操作符和三目操作符。

太长不看。

操作符从高到低的优先级（太长不看）：

操作符|名字
-|-
`+`、`-`|一元加、减
`!`|一元逻辑非
`~`|一元按位求反
`*`、`\`、`%`|乘、除、取模
`+`、`-`|二元加、二元减
`<<`、`>>`|左移、右移
`<`、`<=`、`>`、`>=`|小于、小于等于、大于、大于等于
`==`、`!=`|逻辑相等、逻辑不等
`===`、`!==`|全等、非全等
`&`、`^`、`^~`(`~^`)、`\|`|按位与、异或、异或非、或
`&&`、`\|\|`|逻辑与、逻辑或
`? :`|条件操作符

### 延迟表达式

> Verilog HDL 中，延迟表达式的格式为用圆括号括起来的三个表达式，这三个表达式之间用冒号分隔开。  
> 三个表达式一次代表最小、典型、最大延迟时间值。如  
> `(a:b:c)+(d:e:f)`  
> 表示最小延迟值为 `a+d` 的和，典型延迟值为 `b+e` 的和，最大延迟值为 `c+f` 的和。

讲完了。有什么用？不知道。

## Verilog 语言模块描述方式

前面是一堆非常无聊的基础。下面开始重点。

**Verilog 分为三大流派：行为级建模、结构级建模，数据流级建模。**

> 模块大致可以按以下三类抽象级别来进行描述。
> 1. 行为级或算法级的描述方式（行为级建模）；
> 2. 数据流描述方式（数据流级建模）；
> 3. 门级描述方式（门级建模）；

怎么又回到[概述](#概述)第五点了。。。

> **行为描述方式**——使用过程化结构建模；
> **数据流方式**——使用连续赋值语句方式建模；  
> **结构化方式**——使用门和模块实例语句描述建模。

* `行为描述方式`即是使用`过程语句`、`赋值`、`寄存器`、`if`、`for` 等流程的 C 语言风格。（**面向过程编程**）  
* `结构化`即是描述各个`门`，使用`线网`类型的结构化风格（**面向（门）结构编程**）。  
* 至于`数据流`，是使用 `out=~(A&B)` 这种`连续赋值`形式替代了门结构的描述（**面向数据编程**），也是使用线网类型编程

这便是 Verilog 三种不同流派的语法。下面，我们就用三个大标题，分别来聊这三种不同的模块。

## 模块的结构级描述

结构级就相当于把每个`元件`描述好，具体仿真以后会发生什么，得看元件的搭配。如下面的直接以`逻辑门`为单位描述。

### 门级赋值语句

门单元赋值的 Verilog HDL 描述像下面这样：

```v
nand(y,a,b,c,d);
```

该语句实现了与非门 `y=(a·b·c·d)'`。

**注意Verilog 门级赋值语句的输出在前面，输入在后面**

Verilog HDL中提供下列内置基本门：
* 多输入门：`and`,`nand`,`or`,`nor`,`xor`,`xnor`
* 多输出门：`buf`,`not`
* 三态门：`bufif0`,`bufif1`,`notif0`,`notif1`（略）
* 上拉、下拉电阻：`pullup`,`pulldown`（略）

语法格式如下：

```v
gate_type [instance_name1] (term11,term12,...,term1N)

类型 [命名](参数)
```

其中 `命名` 是可省的。

#### 多输入门

顾名思义，多输入、一个输出的门。

有 `and`,`nand`,`or`,`nor`,`xor`,`xnor`。

注意，参数的**输出在前，输入在后！！！**

一堆示例：

```v
and RBX (Sty,Rib,Bro,Qit,Fi);
```

该门实例语句是四输入与门，单元名为 `RBX`，输出为 `Sty`，4 个输入为 `Rib`、`Bro`、`Qit` 和 `Fix`。

```v
xor (Bar,Bud[0],Bud[1],Bud[2]);
```

该门实例语句是异或门的具体实例，没有单元名。它的输出是 `Bar`，三个输入分别为 `Bud[0]`、`Bud[1]` 和 `Bud[2]`。

#### 多输出门

一堆示例：

```v
buf B1 (Fan[0],Fan[1],Fan[2],Fan[3],Clk);
```

该门实例语句中，Clk是缓冲门的输入，门B1有4个输出：Fan[0]到Fan[3]。

```
not N1 (PhA,PhB,Ready);
```

该门实例语句中，Ready是非门的唯一输入端口。门N1有两个输出：PhA和PhB。

### 示例

```v
`include "full_add_1.v"
module add4_1(sum,cout,a,b,cin);
    input cin;
    input[3:0] a,b;
    output[3:0] sum;
    output cout;

    full_add1 f0(a[0],b[0],cin,sum[0],cin1);
    full_add2 f1(a[1],b[1],cin1,sum[1],cin2);
    full_add3 f2(a[2],b[2],cin2,sum[2],cin3);
    full_add4 f3(a[3],b[3],cin3,sum[3],cout);
endmodule
```

示例：一位半加器：

```
module halfadd (X, Y, C, S);
    input X, Y;
    output C, S;
    wire S1, S2, S3;

    nand NANDA(S3,X,Y);
    nand NANDB(S1,X,S3);
    nand NANDC(S2,S3,Y);
    nand NANDD(S,S1,S2);
    assign C=S3;
endmodule
```

## 模块的数据流级描述

> 数据流描述方式，也称为RTL（寄存器传输级）描述方式。  
> 数据流描述方式**类似于布尔方程**，它能够比较直观地表达低层逻辑行为。  
> 用数据流描述方式对一个设计建模的最基本的机制就是使用**连续赋值语句**。在连续赋值语句中，某个值**被指派给网络变量**。 

### 连续赋值语句

也可以使用连续赋值语句实现相同的与非功能：

```v
assign [delay] LHS_net=RHS_expression;

assign y = ~(a&b&c&d); // y 必须是 wire 型变量
```

为什么叫连续赋值语句？

> 该连续赋值语句表示，输出 `y` 的变化跟随输入 `a`、`b`、`c`、`d` 的变化而变化，反映了信号变化的连续性。   
> 右边表达式使用的操作数无论何时发生变化, **左边表达式都重新计算**, 并且在指定的**时延后被赋予左边的网络变量**。  
> 时延定义了右边表达式操作数变化与赋值给左边表达式之间的持续时间。如果没有定义时延值, 默认时延为 0。

示例： 2-4 解码器的 Verilog HDL 数据流描述

```v
`timescale 1ns/1ns
module Decoder2x4(A,B,EN,Z);
    input A,B,EN;
    output [0:3] Z;
    wire Abar,Bbar;

    assign #1 Abar =~A;
    assign #1 Bbar =~B;
    assign #2 Z[0]=~(Abar & Bbar & EN);
    assign #2 Z[1]=~(Abar & B & EN);
    assign #2 Z[2]=~(A & Bbar & EN);
    assign #2 Z[3]=~(A & B & EN);
endmodule
```

> 以反引号 `` ` `` 开始的第一条语句是编译器指令。  
> 编译器指令`` `timescale ``将模块中所有时延的单位设置为 1ns，时间精度为 1ns。  
> 例如，在连续赋值语句中时延值 `#1` 和 `#2` 分别对应时延 1ns 和 2ns。  
> 
> 模块 `Decoder2x4` 有 3 个输入端口和 1 个 4 位输出端口。  
> 网络类型说明了两个连线型变量 `Abar` 和 `Bbar` 。
> 此外，模块包含 6 个连续赋值语句。

示例的详细说明（太长不看）：

> 当EN在第5ns变化时,语句3、4、5和6执行。这是因为EN是这些连续赋值语句中右边表达式的操作数。  
> Z[0]在第7ns时被赋予新值0。  
> 当A在第15ns变化时, 语句1、5和6执行。  
> 执行语句5和6不影响Z[0]和Z[1]的取值。  
> 执行语句5导致Z[2]值在第17ns变为0。  
> 执行语句1导致Abar在第16ns被重新赋值。  
> 由于Abar的改变，反过来又导致Z[0]值在第18ns变为1。

更多的关于 `#t` 的解释，请看[initial 语句](#initial-语句)的时延控制部分。

## 模块的行为级描述

先给一个示例：8 位计数器的 Verilog HDL 行为级描述

```
module counter8(clk,clr,out);
    input clk,clr;
    output reg[7:0] out;
    always @(posedge clk or posedge clr)
    begin 
        if(clr) out<=0;
        else out<=out+1; 
    end
endmodule
```

### 语句块

> 语句块提供将两条或更多条语句组合成语法结构上相当于一条语句的机制。在 Verilog HDL 中有两类语句块，即：  
> 1. 顺序语句块 `begin`...`end`：语句块中的语句按给定次序顺序执行。  
> 2. 并行语句块 `fork`...`join`：语句块中的语句并行执行。（不常用）

注意，`begin`...`end` 或 `fork`...`join` 相当于 C 语言的 `{`...`}`（毕竟都是叫代码块），他们俩一个是顺序、一个是并行。

示例：顺序语句块的 Verilog HDL 描述

```v
begin
#2 Stream=1;
#5 Stream=0;
#3 Stream=1;
#4 Stream=0;
#2 Stream=1;
#5 Stream=0;
end
```

> 假定顺序语句块在第 10 个时间单位开始执行。两个时间单位后第 1 条语句执行，即第 12 个时间单位。  
> 此执行完成后，下 1 条语句在第 17 个时间单位执行（延迟 5 个时间单位）。然后下 1 条语句在第 20 个时间单位执行，以此类推。

示例：

```v
begin
    Pat=Mask|Mat;
    @ (negedge Clk)
        FF=& Pat;
end
```

> 在该例中，第 1 条语句首先执行，然后执行第 2 条语句。  
> 当然，第 2 条语句中的赋值只有在 Clk 上出现负沿时才执行。

这么说来 `negedge Clk` 就是在 `Clk` 上出现负沿时才执行。相对应的 `posedge Clk` 就是在 `Clk` 上出现正沿时才执行。

### 过程语句

> Verilog HDL 中的多数过程模块都从属于以下两种过程语句：
> * `initial` 语句
> * `always` 语句
> 一个模块中可以包含任意多个 `initial`或 `always` 语句。  
> 这些语句相互并行执行，即这些语句的执行顺序与其在模块中的顺序无关。  
> 一个 `initial` 语句或 `always` 语句的执行产生一个单独的控制流，所有的 `initial` 和 `always` 语句在 0 时刻开始并行执行。 

所有语句（除一开始的声明）都必须包含在 `initial` 或 `always` 里。

#### initial 语句

从英文上看也知道，`initial`（初始化）语句只在最开始执行一次，即在0时刻开始执行。

`initial` 语句的语法如下：

```v
initial 
begin
    statement1;  //描述语句1
    statement2;  //描述语句2
    //...
end
```

即使像下面这么写， `a` 在 0 时刻会被赋值为 2。

```v
a;
//...
initial
    a=2;
```

当然，`initial` 语句也可以带有时延控制：

```v
reg Curt;
...
initial
    #2 a = 1;
```

寄存器变量 `a` 在时刻 2 被赋值为 1。`initial` 语句在 0 时刻开始执行，在时刻 2 完成执行。

顺便提一句，这里的 `2` 可以用变量替代，还可以用[延迟表达式](#延迟表达式)。

`#t` 的含义应为：等待 `t` 个单位时间以后执行（而不是在 `t` 时刻执行）。  
也就是说，如果有两个 `#` 叠加，后者语句的执行时间应是二者时间的叠加。在[语句块](#语句块)里会有一个例子说明。在[连续赋值语句](#连续赋值语句)有一个更详细的例子说明。

> `initial` 语句通常用于仿真模块对激励向量的描述，或用于给寄存器变量赋初值，它是面向模拟仿真过程的语句，不能被综合。

顺便一提，顺序过程 `begin`、`end` 最常使用在进程语句中。

下面是更复杂的、带有顺序过程的 `initial` 语句：

```v
parameter SIZE = 1024;

reg [7:0] RAM [ 0:SIZE- 1 ];
reg RibReg;

initial
begin: SEQ_BLK_A
    integer Index;
    RibReg = 0;
    for (Index = 0; Index < SIZE; Index = Index + 1)
        RAM [Index] = 0;
end
```

这一 `initial`语句在执行时将所有的内存初始化为 0。

`SEQ_BLK_A` 是顺序过程的标记；如果过程中没有局部说明部分，不要求这一标记。

#### always 语句

> 与 `initial` 语句相反，`always` 语句重复执行。

与 `initial` 语句类似，`always` 语句语法如下：

```v
always @(敏感信号表达式)
begin
    //过程赋值
    //if-else,case语句
    //while,repeat,for循环语句
    //task,function调用
end
```

`always` 在功能上类似于无条件的 `while`，而 `always @()` ；类似于有条件的 `while`。

`always` 本身只影响到下面的一句话，配合 `begin`...`end` （即代码块）才能够实现装很多句话。

示例：`always` 过程实现计数器的过程

```v
always @(posedge clk)
begin
    if(reset) out<=0;
    else out<=out+1;
end
```

示例：`always` 实现时钟信号（[源代码链接](https://blog.csdn.net/qq_33929689/article/details/51842606)）

```v
module clock(output reg clock)
//在零时刻把clock变量初始化
initial
    clock = 1'b0;
//每半个周期把clock信号翻转一次
always
    #10 clock=~clock;
initial 
    #1000 $finish;
    //1000个时间单位后，停止仿真

endmodule
```

> `always` 语句有一个过程性赋值。因为 `always` 语句重复执行，并且在此例中没有时延控制，过程语句将在 0 时刻无限循环。因此，`always` 语句的执行必须带有某种时序控制。 

示例：`always` 语句用于 4 选 1 开关

```v
module mux4 (sel, a, b, c, d, outmux);
input [1:0] sel;
input [1:0] a, b, c, d;
output [1:0] outmux;
reg [1:0] outmux;
always @(sel or a or b or c or d)
begin
    case (sel)
        2'b00: outmux = a;
        2'b01: outmux = b;
        2'b10: outmux = c;
        default: outmux = d;
    endcase
end
endmodule
```

这里涉及到了 [case](#case) 语句。也是和 C 语言比较类似。

示例：敏感信号为时钟沿的 `always` 语句的 Verilog HDL 描述

```v
module EXAMPLE (DI, CLK, RST, DO);
input [7:0] DI;
input CLK, RST;
output [7:0] DO;
reg [7:0] DO;
always @(posedge CLK or posedge RST)
    if (RST==1'b1)
        DO<=8'b00000000;
    else
        DO<=DI;
endmodule
```

### 过程赋值语句（行为级）

一段话分了五页 ppt 预警

> 过程赋值语句的硬件实现是：从赋值语句右边提取出的逻辑，用于驱动赋值语句左边的变量（必须是 `reg`型）。有两种类型的过程赋值语句：  
> * 阻塞赋值语句（Blocking Assignment Statement）  
> * 非阻塞赋值语句（Non-blocking Assignment Statement）

#### 阻塞赋值语句

> 以赋值操作符 `=` 来标识的赋值的操作称为阻塞型过程赋值语句，阻塞赋值语句可以简述为：在一个 `always` 块中，语句是按从上到下顺序执行的。它具有如下特点：  
> 1. 顺序块内的各条阻塞语句以它们在顺序块中的排列先后次序依次得到执行；而并行块中的各条阻塞赋值语句则是同时得到执行。  
> 2. 阻塞赋值语句的执行过程是：首先计算右端赋值表达式的取值，然后立即将计算结果赋值给 `=` 左端的被赋值变量。 这种语句更多的用在行为仿真和时序仿真的过程中。

#### 非阻塞赋值语句

> 以赋值操作符 `<=` 来标识的赋值操作的也是出现在 `initial` 和 `always` 块语句中，在非阻塞赋值语句中，赋值号 `<=` 左边的赋值变量也必须是 `reg` 型变量，其值不象在过程赋值语句那样，语句结束时即刻得到，而在该块语句结束才可得到。
> 
> 非阻塞赋值语句的特点如下：  
> 1. 在 `begin-end` 顺序语句块中，一条非阻塞赋值语句块的执行不会阻塞下一条语句的执行，即在本条非阻塞赋值语句对应的赋值操作执行完毕之前，下一条语句才可以开始执行。   
> 2. 仿真过程在遇到非阻塞型赋值语句后，首先计算其右端赋值表达式的值，然后要等到当前仿真时间结束时再将该计算结果赋值给被赋值变量，即非阻塞赋值操作时在同一仿真时刻上的其他普通操作结束之后才得到执行的。  
> 因此非阻塞赋值语句的这个特点是不同于阻塞型赋值语句的执行时序特点的。

这写的什么玩意。看不懂看不懂。

例子：非阻塞赋值的 Verilog HDL 描述

```v
module block(a3,a2,a1,clk);
input clk,a1; output reg a3,a2;
always @(posedge clk)
begin
  a2<=a1;
  a3<=a2;
end 
endmodule
```

例子：阻塞赋值的 Verilog HDL 描述

```v
module block(a3,a2,a1,clk);
input clk,a1; output reg a3,a2;
always @(posedge clk)
begin
  a2=a1;
  a3=a2;
end 
endmodule
```

只有赋值符号不同。

~~在这里第一次使用了 Xilinx 编程测试~~

测试的内容是：

```v
initial begin
    a1 = 1;
    clk = 0;

    #100;
    clk = 1;
end
```

测试的结果显示：
> 对于非阻塞型的 `<=`，100ns 后 `a2` 变为 1，而 `a3` 仍为 `x`。  
> 阻塞型的 `=`，100ns 后 `a2` 和  `a3` 都变为 1。

这很好的解释了二者的区别，简单的来说就是：

> `<=` 是并行执行的，`=` 是顺序执行的。

并行的那个是阻塞，顺序执行的是非阻塞。记一下就行。

顺便，`<=` 和 `=` 这些赋值都是 `reg` 的玩意，`wire` 得使用门。如果想对 `wire` 类型赋初值，请使用 `wire a; a = 1'b1`。

### 流程控制

#### if-else

写法和 C++ 一样，只是判断执行标准时，如果是 `0zx` 之一，就不执行。

示例：使用 `if-else` 实现 D 触发器

```v
module v_registers_2 (C,D,CLR,Q);
    input C, D, CLR;
    output Q;
    reg Q;
    always @(negedge C or posedge CLR)
    begin
        if (CLR)  Q<=1'b0;
        else      Q<=D;
    end
endmodule
```

#### case

和 C 语言的写法稍微有点不同，用法一样。不需要 `break`，有 `default`。

示例：`case` 语句实现多路选择器的 Verilog HDL 语句

```v
module mux4 (sel, a, b, c, d, outmux);
	input [1:0] sel,a,b.c,d;
	output reg [1:0] outmux;
	always @(sel or a or b or c or d)
	begin
        case (sel)
            2'b00: outmux=a;
            2'b01: outmux=b;
            2'b10: outmux=c;
            default: outmux=d;
        endcase
	end
endmodule
```

示例：`case` 语句实现 3-8 译码器的 Verilog HDL 语句

```v
module v_decoders_1 (sel, res);
    input [2:0] sel;
    output [7:0] res;
    reg [7:0] res;

    always @(sel or res)
    begin
        case (sel)
            3'b000 : res=8'b00000001;
            3'b001 : res=8'b00000010;
            3'b010 : res=8'b00000100;
            3'b011 : res=8'b00001000;
            3'b100 : res=8'b00010000;
            3'b101 : res=8'b00100000;
            3'b110 : res=8'b01000000;
            default : res=8'b10000000;
        endcase
    end
endmodule
```

~~居然是枚举。。。~~

> 单篇笔记 1000 行纪念。

对于 `z` 和 `x`，还有 `casex` 和 `casez`。用法和上面一样。示例：

```v
casez(Mask)
    4'b1??? : Dbus[4] = 0;
    4'b01?? : Dbus[3] = 0;
    4'b001? : Dbus[2] = 0;
    4'b0001 : Dbus[1] = 0;
endcase
```

`casez` 语句表示：
* 如果 `Mask` 的第 1 位是 1（忽略其它位），那么将 `Dbus[4]` 赋值为0；  
* 如果 `Mask` 的第 1 位是 0 ，并且第 2 位是 1（忽略其它位），那么 `Dbus[3]` 被赋值为 0；
* 依此类推。

`casex` 和 `casez`的区别在于：

> `casez` treats all the z values in the case expression as don't cares while `casex` treats all the x and z values in the case expression as don't cares.

#### forever

字如其人。

示例：`forever` 实现时钟

```v
initial begin
    Clock=0;
    #5 forever
        #10 Clock = ~Clock;
end
```

> 这一实例产生时钟波形：时钟首先初始化为 0 ，并一直保持到第 5 个时间单位。  
此后每隔 10 个时间单位，`Clock` 反相一次。

> 注意，在过程语句中必须使用某种形式的时序控制（如 `#10`），否则， `forever` 循环将在 0 时后永远死循环下去。

它和 `always` 的区别是，`always` 的级别更高，但功能上貌似可以互相替代。

#### repeat

循环的时候直接指定了重复次数。`xz` 被视为 0。

示例：

```v
repeat (Count)
    Sum=Sum+10;
repeat (Shift By)
    P_Reg=P_Reg << 1;
```

`forever` 相当于 `repeat(infinity)`（当然，是没有这种写法的）

#### while

和 C 语言一样。另外，`xz` 被视为 0。

示例：（顺序查找 `0`？）

```v
parameter P = 4;
always @(ID_complete)
begin : UNIDENTIFIED
    integer i;
    reg found;
    unidentified=0;
    i=0;
    found = 0;
    while (!found && (i < P))
    begin
        found = !ID_complete[i];
        unidentified[i] = !ID_complete[i];
        i=i+1;
    end
end
```

#### for

和 C 语言一样。

示例：

```v
module countzeros (a, Count);
    input [7:0] a;
    output reg[2:0] Count;
    reg [2:0] Count_Aux;
    integer i;

    always @(a)
    begin
        Count_Aux = 3'b0;
        for (i = 0; i < 8; i = i+1)
        begin
            if (!a[i]) Count_Aux = Count_Aux+1;
        end
        Count = Count_Aux;
    end
endmodule
```

## 用户自定义基本元件

PPT 第 128-144 页。感觉不会考这么难。

## Verilog 系统任务和函数

PPT 第 145-147 页。感觉不会考这么难。

## Verilog 用户定义任务和函数

PPT 第 148-163 页。感觉不会考这么难。

完结撒花。