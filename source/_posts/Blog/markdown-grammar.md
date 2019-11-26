---
title: Markdown 语法
date: 2019-6-17
tags: 
- Markdown
category: 
- Blog
---

本文除了 Google 能搜到的大量相似的 (Github Flavored) Markdown 语法文档提到的东西外，还有一些骚语法（HTML 或 markdown），如文字的下标、代码中含有反引号 `` ` `` 的处理方法。

## 锚点（Anchor）

> 参考链接: https://www.zhihu.com/question/58630229/answer/191984051

Github Markdown 支持目录/页内跳转。只需要在网页链接以后加 `#` 和标题，如：

`[“图片链接”标题](#图片链接)`

[“图片链接”标题](#图片链接)

但是并不是直接复制标题这么简单。它的语法有

1. 把标题中大写字母变为小写；
2. 删掉除了字母、汉字、数字、空格、连字符 `-` 外的字符；
3. 把空格变为连字符 `-`；
4. 如果标题不唯一，则在标题后加 `-1`，`-2`，……

如对博主的另一篇博客的的 `MSVC 下获取本程序运行的时间（μs 级）` 标题，应使用

`[MSVC 下获取本程序运行的时间（μs 级）](/cpp/cpp-grammar/time/#msvc-下获取本程序运行的时间μs-级)`

[MSVC 下获取本程序运行的时间（μs 级）](/cpp/cpp-grammar/time/#msvc-下获取本程序运行的时间μs-级)

其实这公式也不用记，如果你的博客有 toc(table of contents，即目录) 的功能，直接复制对应标题的目录的链接就可以了。

## 图片链接

`![image](https://gitee.com/uploads/images/2019/0424/194736_1331e2af_551056.jpeg)`

![image](https://gitee.com/uploads/images/2019/0424/194736_1331e2af_551056.jpeg)

想要修改图片大小，必须使用 HTML 语法~~不会~~。所以还是本地用 PS 改图片大小吧。

## 超链接

```markdown
[超链接](https://cn.bing.com/)；
引用式 [博客][1] 链接。
引用式 [GitHub][2] 链接，带 title。

[1]: https://mazhuang.org
[2]: https://github.com/mzlogin "我的 GitHub 主页"
```

[超链接](https://cn.bing.com/)；  
引用式 [博客][1] 链接。  
引用式 [GitHub][2] 链接，带 title。

[1]: https://mazhuang.org
[2]: https://github.com/mzlogin "我的 GitHub 主页"

## 富文本格式

```markdown
* 这是<b>加粗</b>
* 这也是**加粗**
* 这是<sub>下</sub>标
* 这是<del>删除线</del>
* 这也是~~删除线~~
* Emoji :laughing: :joy:
    - 这是第一个小点
    - 这是第二个小点
```

* 这是<b>加粗</b>
* 这也是**加粗**
* 这是<sub>下</sub>标
* 这是<del>删除线</del>
* 这也是~~删除线~~
* Emoji :laughing: :joy:
    - 这是第一个小点
    - 这是第二个小点

## 表格

```
| 1 | 2 | 3 |
| -- | -- | -- |
| 4 | 5 | 6 |
| | | |
| |9 | |
| | | |
```

| 1 | 2 | 3 |
|-|-|-|
| 4 | 5 | 6 |
| | | |
| |9 | |
| | | |

使用`:---------:`居中  
使用`:----------`居左  
使用`----------:`居右  
表格中换行可以使用`<br>`  
表格中代码间换行：可以将代码按行分段用`` ` ``包含，然后在每段间加入`<br>`

## 行内、段间代码

### 行内代码

行内代码 markdown 写法：

```
`代码`
```

效果：`代码`。

### 段间代码

段间代码 Markdown 写法：

````markdown
```c++
#include<iostream>
int main()
{
    std::cout << "Hello world!";
}
```
````

效果如下：

```c++
#include<iostream>
int main()
{
    std::cout << "Hello world!";
}
```

## 代码包含反引号 `` ` ``的情况

行内代码包含 `` ` `` 时，需要改用一对 ``` `` ``` 将代码括起来。

段间代码包含 `` ``` `` 时，需要改用一对 ````` ```` ````` 将代码括起来。

貌似**代码内无论有多少个反引号，只需要比最多的多一个反引号即可用代码括起来**。挺有意思的。

## 引用及嵌套引用

```
> `#include`是什么？一条预处理指令。于是你就需要搞清楚预处理在c++程序的编译过程中大约发生在什么环节。以下引用 cppreference.com:  
>
> > The preprocessor is executed at translation phase 4, before the compilation. The result of preprocessing is a single file which is then passed to the actual compiler.  
>
> C++ 的预处理器在编译之前执行，它看到 `#include` 指令，就会把那个文件的内容替换到当前位置。其它的预处理指令例如`#define`, `#ifdef`, 等也在这个阶段被执行、并产生相应的内容。预处理器执行完成后，所有的预处理指令都会被移除。其结果是一个单个头的大文件（我猜测这文件只存在于内存里），这个文件才会被进一步传给编译器做编译。
```

**注意被嵌套段落的上下都有空行，不然无法嵌套。**

> `#include`是什么？一条预处理指令。于是你就需要搞清楚预处理在c++程序的编译过程中大约发生在什么环节。以下引用 cppreference.com:  
>
> > The preprocessor is executed at translation phase 4, before the compilation. The result of preprocessing is a single file which is then passed to the actual compiler.  
>
> C++ 的预处理器在编译之前执行，它看到 `#include` 指令，就会把那个文件的内容替换到当前位置。其它的预处理指令例如`#define`, `#ifdef`, 等也在这个阶段被执行、并产生相应的内容。预处理器执行完成后，所有的预处理指令都会被移除。其结果是一个单个头的大文件（我猜测这文件只存在于内存里），这个文件才会被进一步传给编译器做编译。

## 折叠代码

使用的是 HTML 语法。

```html
<details>
    <summary>折叠文本</summary>
    可以写文本。
    但是回车不能换行。<br>
    得用 br
</details>

<details>
    <summary>折叠代码，但是不能进行染色</summary>
    
    int main()
    {
        printf("folded code");
    }

</details>
```

<details>
    <summary>折叠文本</summary>
    可以写文本。
    但是回车不能换行。<br>
    得用 br
</details>

<details>
    <summary>折叠代码，但是不能进行染色</summary>
    
    int main()
    {
        printf("folded code");
    }

</details>

## LaTeX 公式

原生 Markdown 不支持 LaTeX 数学公式，要想使用，请移步 Mathjax。

