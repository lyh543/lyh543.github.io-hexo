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

## 类和对象

类的定义：

```py
class Student(object): # object 表示被继承的类，如果没有继承类，就写 object

    def __init__(self, name, score):
        self.name = name;
        self.score = score;
    
    def print_score(self):
        print('%s: %s' % (self.name, self.score))
```

创建对象（也可以叫 `实例`），并调用对象对应的关联函数（关联函数被称为对象的方法 `Method`）：

```py
bart = Student('Bart Simpson', 59)
lisa = Student('Lisa Simpson', 87)
bart.print_score()
lisa.print_score()
```

从第一段代码还可以看出，类的构造函数是 `__init__`。

另外，在定义类的时候，每个函数无论在声明、还是在使用时，都要写明第一个参数是 `self`（C++ 只在静态成员函数的时候需要写明）

和 C++ 不同的是，外部代码在使用对象的时候，Python 还可以创建成员：

```py
bart.grade = 'A'
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
>>> bart.print_score()
bart: 95
>>> bart.__name
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute '__name'
```

https://www.liaoxuefeng.com/wiki/1016959663602400/1017496679217440