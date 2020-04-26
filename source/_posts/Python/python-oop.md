---
title: Python 面向对象编程
date: 2020-04-22 22:29:15
tags:
- Python
- 面向对象编程
category:
- Python
mathjax: true
---

在学 Python OOP 之前，我在想，怎么还没到结构体，后来才恍然大悟，结构体是 C 的东西，C++ 有了类以后，（不考虑效率问题）就不需要结构体了，而 Python 也是这样，有了类，还需要结构体做什么呢？

该篇博客默认读者曾学过至少一门 OOP 语言。

Python 和 C++ 的对同一个概念的称呼的简单对照表：

Python|C++
-|-
类 `class`|类 `class`
实例 `instance`|对象 `object`
方法 `methods`|成员函数 `member functions`
属性 `attributes`|成员变量 `member variables`

## 类和实例

类的定义：

```py
class Student(object): # object 表示被继承的类，如果没有继承类，就写 object

    def __init__(self, name, score):
        self.name = name
        self.score = score
    
    def print_score(self):
        print('%s: %s' % (self.name, self.score))
```

由类生成的东西，在 C++ 中叫对象 `object`，但是在 Python 中叫实例 `instance`。可能是因为 Python 的对象被用来指代`东西`了吧，比如`类对象`、`方法对象`。

创建 `实例`，并调用实例对应的关联函数（关联函数被称为实例的方法 `Method`）：

```py
bart = Student('Bart Simpson', 59)
lisa = Student('Lisa Simpson', 87)
bart.print_score()
lisa.print_score()
```

从第一段代码还可以看出，类的构造方法是 `__init__`。

另外，在定义类的时候，每个函数无论在声明、还是在使用时，都要写明第一个参数是 `self`（C++ 只在静态成员函数的时候需要写明）

和 C++ 不同的是，外部代码在使用对象的时候，Python 还可以创建成员：

```py
bart.grade = 'A'
```

## 类属性

由于 C++ 需要初始化变量，所以 C++ 类一般先是一堆变量声明，再是成员函数。

到了 Python 这里，不需要声明，直接就是几个方法，反而有点不习惯。

如果想要给类弄一个属性（类似于 C++ 的静态成员），也是可以的，而且方法也浅显易懂：

```py
class Student(object):
    course = 'Chinese'

    def __init__(self, name, score):
        self.name = name
        self.score = score
    
    def print_score(self):
        print('%s: %s' % (self.name, self.score))
```

类属性是可以被实例属性覆盖的。并且，如果删除了示例的属性，会还原为类属性。

```py
print(Student.course)       # 显示 Chinese
bart = Student('Bart', 95)
print(bart.course)          # 显示 Chinese
bart.course = 'Math'        # 示例属性覆盖类属性
print(bart.course)          # 显示 Math
print(Student.course)       # 显示 Chinese
del bart.course             # 删除示例实心
print(bart.course)          # 显示 Math
```

## 私有成员

如上，Python 并没有 C++ 一样的，必须写明对象是 `public`，否则就是私有 `private` 的。而 Python 如何在类中创造私有成员呢：

```py
class Student(object):
    def __init__(self, name, score):
        self.__name = name
        self.__score = score

    def print_score(self):
        print('%s: %s' % (self.__name, self.__score))
```

此时能够正常执行 `print_score` 函数，但无法访问 `__name` 了：

```py
>>> bart = Student('bart', 95)
>>> bart.print_score()
bart: 95
>>> bart.__name
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute '__name'
```

此时，如果需要获取 `name`、修改 `name` 时，就需要在类里面添加 `getName` 和 `setName`。这是面向对象编程的经典操作。

需要注意的是：

1. 形如 `__xxx__` 的变量名是特殊变量，可以直接访问；
2. 其实也可以通过访问 `_Student__name` 来访问 `__name`，Python 解释器也只是改了一个名字。仅限从一个对象内部访问的“私有”实例变量在 Python 中并不存在。当然还是强烈建议不要访问。
3. 大多数 Python 代码还遵循这样一个约定：带有一个下划线的名称 (例如 `_spam`) 应该被当作是 API 的非公有部分 (无论它是函数、方法或是数据成员)。也就是说，不应该去访问它，虽然他并不是私有成员。

## 继承

继承：

```py
class Animal(object):
    def run(self):
        print('Animal is running...')

class Dog(Animal):
    pass

class Cat(Animal):
    pass

Dog().run()
# 输出 Animal is running...
```

注意：如果基类定义在另一个模块中，可以使用：

```py
class DerivedClassName(modname.BaseClassName):
```

### 多继承

多继承的语法没什么好说的。

```py
class DerivedClassName(Base1, Base2, Base3):
    <statement-1>
    .
    .
    .
    <statement-N>
```

但是多继承涉及到的问题就挺麻烦了（C++ 对多继承问题的处理可以参考博客 [C++ 面向对象——继承、派生和多态][1]）：

[1]:(/cpp/cpp-grammar/cpp-inheritance-derive-polymorphism/#多继承的二义性-虚基类)

1. 如果有两个不同父类有同一个属性

你可以理解为 Python 的处理办法是深度优先、从左至右地搜索父类的属性，搜到了第一个，就不会管后面的同名属性了。简单粗暴。

> 真实情况比这个更复杂一些；方法解析顺序会动态改变以支持对 `super()` 的协同调用。 这种方式在某些其他多重继承型语言中被称为后续方法调用，它比单继承型语言中的 `super` 调用更强大。

2. 如果出现了菱形关联，如同在 C++ 那篇博客题到的下图左边的情况（右边是 C++ 默认的实现）：

![AMCar](/cpp/cpp-grammar/cpp-inheritance-derive-polymorphism/AMCar.svg)

但是 Python 的 `动态改变的方法解析顺序` 可以保证只调用每个父类一次。（用 C++ 的话来说就是，所有基类都是虚基类 `virtual base`）

> 只调用每个父类一次，并且保持单调（即一个类可以被子类化而不影响其父类的优先顺序）

后面这句不大明白。

## 多态

多态，即子类重载父类的同名方法：

```py
class Dog(Animal):
    def run(self):
        print('Dog is running...')

Dog().run()
# 输出 Dog is running...
```

所有函数默认都是虚函数的。

## 运算符重载

Python 也支持运算符重载，但是和 C++ 的不一样，C++ 可以对任意运算符进行重载，Python 只能通过重载系统给定的的对应的函数，来重载部分运算符。

方法名|重载说明|运算符调用方式
-|-|-
`__init__`|构造函数|对象创建: `X = Class(args)`
`__del__`|析构函数|`X` 对象收回
`__add__`/`__sub__`|加减运算| `X+Y`，`X+=Y/X-Y`，`X-=Y`
`__or__`|运算符`|`|`X|Y`，`X|=Y`
`_repr__`／`__str__`|打印／转换|`print(X)`、`repr(X)`／`str(X)`
`__call__`|函数调用|`X(*args, **kwargs)`
`__getattr__`|属性引用|`X.undefined`
`__setattr__`|,属性赋值|`X.any=value`
`__delattr__`|属性删除|`del X.any`
`__getattribute__`|属性获取|`X.any`
`__getitem__`|索引运算|`X[key]`，`X[i:j]`
`__setitem__`|索引赋值|`X[key]`，`X[i:j]=sequence`
`__delitem__`|索引和分片删除|`del X[key]`，`del X[i:j]`
`__len__`|长度|`len(X)`
`__bool__`|布尔测试|`bool(X)`
`__lt__`，`__gt__`|特定的比较|依次为`X<Y`，`X>Y`
`__le__`，`__ge__`||`X<=Y`，`X>=Y`
`__eq__`，`__ne__`||`X==Y`，`X!=Y`
`__radd__`|右侧加法|`other+X`
`__iadd__`|实地（增强的）加法|`X+=Y`(or else `__add__`)
`__iter__`，`__next__`|迭代|`I=iter(X)`，`next()`
`__contains__`|成员关系测试|`item in X`(X为任何可迭代对象)
`__index__`|整数值|`hex(X)`，`bin(X)`,  `oct(X)`
`__enter__`，`__exit__`|环境管理器|`with obj as var:`
`__get__`，`__set__`，`__delete__`|描述符属性|`X.attr`，`X.attr=value`，`del X.attr`
`__new__`|创建|在`__init__`之前创建对象

更多的数学符号重载请看 [Python 文档|模拟数字类型](https://docs.python.org/zh-cn/3.7/reference/datamodel.html#emulating-numeric-types)。
