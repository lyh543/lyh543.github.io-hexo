---
title: C++ 面向对象——继承、派生和多态
date: 2019-09-29 15:03:12
tags:
- 课程笔记
category:
- C++
- C++语法
mathjax: true
---

## 继承和派生

派生，就是从原来的大类，通过增加新的东西、特性、条件，变成了新的小类。如，从哺乳动物通过增加特性（汪汪叫、喵喵叫），派生到狗、猫。

狗和猫，都继承了哺乳动物的特点（胎生等），派生的时候，狗、猫都会自动继承哺乳动物有的特点，无需重复声明。

名称上，被派生的（哺乳动物）叫基类（父类），派生出来的猫、狗叫做派生类（子类）。他们间的继承关系，是由派生类到大类。

（貌似继承和派生是反义词）

在 C++ 中，除了单继承，还可以多继承（狗同时继承了哺乳动物和岸生动物的特点）。

派生类的功能：

1. 继承了基类的所有成员；
2. 可以改造基类的成员；
3. 添加新的成员。

### 继承类的定义

定义继承类的语法格式如下：

```cpp
class Dog: <继承方式> Terrestrial, <继承方式> Mammalia
{
    //定义派生新增加的成员
};
```

继承方式分为：公有继承（public）、私有继承（private，默认）、保护继承（private），后面有详细解释。

### 保护成员 和 继承方式：公有继承、私有继承、保护继承

无论使用那种继承，基类的对象及其成员都会成为派生类的一部分，但是成员的属性可能发生变化。
**但是，无论使用哪种继承，基类的私有成员在派生类不能直接访问**，必须通过基类提供的公有函数、保护函数访问。

于是产生了保护成员：

`公有成员` 对于 派生类 和 类外部 都是可见的；
`私有成员` 对于 派生类 和 类外部 都是不可见的；
`保护成员` 是二者的一个中和，他对于 派生类 是可见的，对于 类外部 是不可见的。

说完保护成员，三种继承的区别就很简短了：

* 公有继承（public）：公有继承是 `is a` 的关系，基类的 `public` 和 `protected` 成员属性都不会改变。这是最常用的。
* 私有继承（private）：他是一个 `has a` 的关系。基类的 `public` 和 `protected` 成员都会变为 `private`。
* 保护继承（protected）：是私有继承的变体。基类的 `public` 和 `protected` 成员都会变为 `public`。

#### 私有继承和类的组合

私有继承和[类的组合](../class-and-object#类的组合)都有一个类（下称 Y 类）能用到另一个类（下称 X
类）的 `public` 成员和函数，而不能使用 `private` 成员的特性，开发时，具体选择哪个使用呢？

一般来说，C++ 程序员更喜欢类的组合，一是理解起来容易，二是 Y 类可以使用 X 类的多个对象（继承不能）。

但是，如果有使用 X 类的 `private` 成员，或者需要2使用 [虚函数](#虚函数)，就需要使用私有继承。

个人感觉，如果有继承的层次感（如哺乳动物 -> 狗）的结构，建议使用继承；否则使用类的组合（线段有两个点 `class Point`）。

### 派生类的构造和析构

派生类的构造函数理论上只需要给新的成员提供初始化顺序，而父类的成员只需要用父类的构造函数即可（如果是私有成员，是必须使用构造函数）。具体语法如下：

> 简要介绍背景：一个 `ShoppingCard` 类，存了用户的钱钱数；  
> 有一个 `MemberCard` 类继承了 `ShoppingCard`，并增加了一个 `cardid` 成员。

```c++
class MemberCard : public ShoppingCard
{
public:
    char* cardid;
	int score;
    MemberCard(const char* _cardid, float _money) : ShoppingCard(_money) //, <更多的父类>(<参数>)
    {
        strcpy(cardid,_cardid);
    }
};
```

在 `<更多的父类>` 处，除了写更多的父类，还可以写：

1. 对象成员（即成员是另一个类的对象），这样就可以也把对象成员初始化了；
2. 甚至，可以写基本数据类型的变量（如 `score(0)`），因为 C++ 可以使用类似的方法对他们赋初值。

调用构造函数的时候，成员初始化列表 `ShoppingCard(_money)` 先被执行，再执行派生类的构造函数 `strcpy(cardid,_cardid);`。相反地，调用析构函数时，先调用派生类的析构函数，再按**逆序**调用父类的析构函数。

如果省略基类构造函数，则默认调用基类的默认构造函数 `ShoppingCard()`。

### 派生类重载基类的成员函数

一句话，其实直接重定义（写一个和父类函数的名字、参数完全相同的函数），即可覆盖父类继承来的函数。  
而如果又想调用基类里已经被重定义的函数，那么调用时加 `基类名::函数名()` 即可。如：

```cpp
class MemberCard : public ShoppingCard
{
public:
    consume(int money){..1}
}A;

A.consume(100);     //调用继承类MemberCard::consume()
A.ShoppingCard::consume(100);    //调用父类ShoppingCard::consume()
```

### 使用不同基类的同名对象

`基类名::成员` 同样适用于不同类的对象的同名成员。

```c++
class Test1 { public: int a; };

class Test2 {public: int a; };

class Inheri : public Test1, public Test2 {} B;

B.a; //编译错误：有歧义
B.Test1::a; //正确
```

## 多继承

多继承才是混乱的开始。（逃

### 多继承类的定义、构造函数、析构函数

定义多继承类、构造及析构函数的语法上面已经提到过了。只是再强调一下构造和析构函数的执行顺序：

* 构造函数：顺序执行 `:` 后面的所有构造函数、再执行 `{ }` 里的部分（即**从上往下执行**）  
* 析构函数：先顺序执行 `{ }` 里的部分，再**逆序**执行 `:` 后的所有构造函数。

### 多继承的二义性 虚基类

上面提到，不同基类的同名对象，可以通过 `基类名::函数名()` 准确调用。可是，如果是同一个类的同名对象呢？

这个问题的产生，还和 C/C++ 编译有关。C/C++ 编译类的时候，实际上是把类的内容全部复制了一份到对象里面（详见另一篇[博客](../C语言程序程序设计课程/#多文件编写)）。

因此，如果有下图的继承结构，编译以后 `AMCar` 里就会出现两份 `Car` 的成员。

![AMCar](AMCar.svg)

虽然我们知道两个 `Car` 等价的，但是编译器却认为这是不等价的。（摊手）

于是，就引入了一个新概念，叫 `虚基类`。

虚基类要实现的效果是这样的。

![虚基类 AMCar](AMCar_2.png)

实现的时候，要修改 `ACar` 和 `MCar` 的代码，将公共父类 `Car` 声明为 `virtual` 虚基类。

```c++
class MCar : public virtual Car { /* */ };
class ACar : virtual public Car { /* */ };
class AMCar : public ACar, public MCar {};
```

`public` 和 `virtual` 的顺序无关紧要。

这样以后，就会只存在一个 `Car` 了。但是继承路径是怎样的呢（`Car` 是谁的真基类呢）？  
这取决于 `AMCar` 声明 `ACar` 和 `MCar` 的顺序。`Car` 是第一个声明它的真基类。对于上面的情况，`Car` 是 `ACar` 的真基类，是 `MCar` 的假基类。

对于构造函数执行时的顺序，同层次虚基类先于非虚基类。  
不同层次的，遵守“先生成基类，再生成派生类”的规定。

## 多态

> 在许多情况下，我们希望同一个函数的行为随调用的上下文而有所不同，这种情况称为多态。  
> 如果“调用的上下文”是在程序编译阶段确定下来，这叫静态多态；如果“调用的上下文”在程序运行阶段才能确定，这叫动态多态。
>
> 在编译的阶段，编译器的一个重要的工作就是解释函数调用语句，要把这句函数调用语句和某个可执行代码块绑定起来，这个过程叫做绑定（Binding）。

说了一堆看不懂的话。

不过看样子，静态多态就是函数重载，这又分为根据参数不同的函数重载，和派生类中对基类的同名函数的重载。  
另外提一句，由于运算符重载属于成员函数重载，于是也属于静态多态。

运算符重载更多内容可见另一篇[博客](../struct/#运算符重载)。

### 赋值兼容规则

通常情况下，C++不允许不同类型的变量的指针、引用赋值给其他类型的指针、引用。

但是，继承类是个特例。只要兼容一定规则，就可以在基类和派生类之间赋值。这种规则被称为赋值兼容规则。

1. 可以把派生类的对象赋给基类的对象
2. 可以把基类的指针、引用指向派生类

在~~猫猫狗狗~~继承的意思上理解的话，可以把猫猫狗狗的信息当做普通动物的信息用，而不能反过来把普通动物的信息当做猫猫狗狗用（不然问起来这个动物一天吃多少鱼就很奇怪了啊）；  
在代码实现层面上理解，是可以舍弃派生类额外的数据实现转换；而如果反过来了，派生类的新增的变量就没有定义了。

戴波老师用一句很精炼的话来总结：所有的狗都是动物，但不是所有的动物都是狗——所有的派生类对象都是基类的对象。

以上转化是由派生类向基类的强制转换，叫做向上强制转换 `Upcasting`。由于其合理性，可以进行**隐式转换**。  
反过来，如果先把基类转为派生类，这叫向下强制转换 `Downcasting`。虽然不大合理，但是可以**显式转换**。但转换以后，应当格外小心，不要访问到一些未初始化的成员。


### 动态多态——虚函数

虚函数的产生，其实是因为上面，指针居然可以指向不同于指针类型的类型。这就会产生一个问题，我就想用基类指针指向的派生对象的派生函数，那咋办嘛。

于是，虚函数，就是在执行的时候，才会根据其指针指向的对象是基类还是派生类，来进行对应的重载。这也正是动态重载的定义——在执行的时候，再进行重载。

### 多态的意义

说了那么多，那动态多态有什么用嘛，还搞得好复杂，甚至还可能出现漏洞。

于是我去知乎搜了一下：

> 首先需要明确多态性的用途，是为了**接口的最大程度复用**，以及其定义：
> 
> 多态性的定义，可以简单地概括为“**一个接口，多种方法**”，程序在运行时才决定调用的函数，它是面向对象编程领域的核心概念。多态(polymorphism)，字面意思多种形状。多态分为静态多态和动态多态。  
> 静态多态是通过重载和模板技术实现，在编译的时候确定。  
> 动态多态通过虚函数和继承关系来实现，执行动态绑定，在运行的时候确定。
> ——https://zhuanlan.zhihu.com/p/47057750

静态多态能实现接口的很大程度的复用，而动态多态就可以最大化复用的程度吧。
