---
title: Markdown 语法
date: 2019-6-17
tags: 
- Markdown
- Blog
category: 
- Blog
---

> 入门 Markdown 推荐：http://younghz.github.io/Markdown/
> Markdown Cheatsheet: https://bit.ly/mdcheat

本文主要记录 Markdown（如有必要，也会提到 HTML）中**不常见的语法**，如文字的下标、代码中含有反引号 `` ` `` 的处理方法等。

## 标题中出现了井号

标题出现了 `#` 号，该怎么写呢？

第一反应，用 `\` 转义，但是也不行。

```
## C\#
```

经过搜索，在 [Stack Overflow](https://stackoverflow.com/questions/32196555/how-to-escape-the-hash-sign-in-a-github-markdown-header-backslash-is-not-w) 上找到了类似的问题。正确的语法是：

```
## C# #
```

效果见 [C#](/Computer-Science/verbatim-strings-literal-grammar/#C-1)。

当然，不同的渲染方式可能有不同的结果。

顺便吐槽一下，Google 搜索 `markdown sharp in title` 的前两条都是相关问题，搜索 `markdown 标题出现井号` 就没有相关问题，有些问题真得用英文问才有结果。

~~百度搜索中英文都没有，搜索中文的结果全是 Markdown 入门教程~~

## 锚点（Anchor）

> 参考链接: https://www.zhihu.com/question/58630229/answer/191984051

锚（máo）点是什么呢？

我们知道，每个网站有一个链接。而你会发现这篇博客里，每个标题也有其链接。将鼠标放在这节的标题上（就在上面三行），你会看到一个 `#`，将鼠标放到 `#` 上，你就可以看到这个标题对应的链接。

```
https://lyh543.xyz/Blog/markdown/#锚点（Anchor）
```

顺便一提，网站右边的 TOC 的目录跳转也是由这个东西实现的。

Github Flavored Markdown 支持目录/页内跳转。只需要在网页链接以后加 `#` 和标题，如：

```md
[“图片链接”标题](#图片链接)
```

[“图片链接”标题](#图片链接)

但是并不是直接复制标题这么简单。它的语法有:

1. 把标题中的所有大写字母变为小写；
2. 删掉除了字母、汉字、数字、空格、连字符 `-` 外的字符；
3. 把空格变为连字符 `-`；
4. 如果标题不唯一，则在标题后加 `-1`，`-2`，……

但是有些地方有点区别，如对博主的另一篇博客的的 `MSVC 下获取本程序运行的时间（μs 级）` 标题，应使用

```md
[MSVC 下获取本程序运行的时间（μs 级）](/cpp/cpp-grammar/time/#MSVC-下获取本程序运行的时间（μs-级）)
```

[MSVC 下获取本程序运行的时间（μs 级）](/cpp/cpp-grammar/time/##MSVC-下获取本程序运行的时间（μs-级）)

其实这公式也不用记，如果你的博客有 toc(table of contents，即目录) 的功能，直接复制对应标题的目录的链接就可以了。

## 图片链接

`![image](https://gitee.com/uploads/images/2019/0424/194736_1331e2af_551056.jpeg)`

![image](https://gitee.com/uploads/images/2019/0424/194736_1331e2af_551056.jpeg)

想要修改图片大小，必须使用 HTML 语法~~不会~~。所以还是本地用 PS 改图片大小吧。

另外，Markdown 插入本地图片一直是个很恼火的东西，这使得它比印象笔记、CSDN、WordPress 麻烦。

但是不少 Markdown 编辑器有图床的功能，能将剪贴板里的图片上传到某个云端，然后在编辑器中加入图片的链接。如 VS Code 的 [Coding 图床](https://marketplace.visualstudio.com/items?itemName=hancel.coding-picture-bed) 插件，能将图片上传至 `coding.net`（一个使用 Git 的国内云仓库）。

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
| :- | --- | --: |
| 4 | 5 | 6 |
| | | |
| |9 | |
| | | |
```

| 1 | 2 | 3 |
| :- | --- | --: |
| 4 | 5 | 6 |
| | | |
| |9 | |
| | | |

* 在第二行使用 `:---------:` 居中
* 使用 `:----------` 居左
* 使用 `----------:` 居右

* 表格中换行可以使用 `<br>`  
* 表格中代码间换行：可以将代码按行分段用 `` ` `` 包含，然后在每段间加入 `<br>`

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

## 代码包含反引号 `` ` `` 的情况

行内代码包含一个反引号时，需要改用（一对）两个反引号将代码括起来。

段间代码包含两个反引号时，需要改用（一对）三个反引号将代码括起来。

貌似**代码内包含 n 个反引号，即可用 n+1 个反引号代码括起来**。挺有意思的。

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

原生 Markdown 不支持 LaTeX 数学公式，但诸如 Typora 等软件支持在 Markdown 中调用 MathJax 从而实现 LaTeX 公式。另外，Chrome 插件 [MathJax Plugin for Github](https://chrome.google.com/webstore/detail/mathjax-plugin-for-github/ioemnmodlmafdkllaclgeombjnmnbima) 支持渲染网页上的 LaTeX 公式。

[LaTeX 公式语法](/LaTeX/LaTeX-math-equation/)

