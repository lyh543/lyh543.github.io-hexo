---
title: Hexo 写作
date: 2019-06-23 16:33:03
tags:
- Hexo
- Visual Studio Code
category:
- Blog
top: false
---

Hexo写作支持Markdown。  
不懂就查[文档](https://hexo.io/zh-cn/docs/writing)
下面是一些区别于[常规Markdown](../markdown-grammar)的点。

## 即时预览

由于 Hexo 博客不全是使用Markdown语法，常规Markdown编辑器无法提供效果完全相同的预览。但是 Hexo 提供了本地网页即时预览博客的功能。

在命令行中输入`Hexo server`（简写`hexo s`），即可在`127.0.0.1:4000`即时预览博客。  
Microsoft Edge似乎只能在`localhost:4040`中预览。

![blog_preview](blog_preview.jpg)

## 文章信息

文章放在`\source\_post`的目录里面，`md`文件随便放。

下面是开头的格式`front-matter`。

```json
---
title: Test Post
date: 2019-06-23 16:33:03
tags:
- ACM
- 图论
category:
- C++
top: false
---
```

一些其他参数：

参数|描述|默认值
-|-|-
layout|布局|
date|创建日期|
updated|更新日期|文件更新日期
comments|开启文章的评论功能|true
permalink|覆盖文章网址|

这些文本使用 `hexo new [draft] xxx` 会自动按照 `/Scaffold/post.md` （或 `/Scaffold/draft.md`）的模板生成。下面是我的 `post.md`：  

```
---
title: {{ title }}
date: {{ date }}
---
```

由于 hexo 在 wsl 上有十秒的延迟，加上每次新建博客会顺便创建文件夹，不是很喜欢，我在 VSCode 上使用的是一个叫 [psioniq File Header](https://marketplace.visualstudio.com/items?itemName=psioniq.psi-header) 的插件，安装插件以后，编辑新文件前，按 `Ctrl+Alt+H` 两次即可按照 Visual Studio Code 的配置文件 `settings.json` 模板就可以创建开头。我的 `settings.json` 的相关部分长这个样子：

```json
   "psi-header.templates": [
		{
			"language": "*",
			"template": [
                "---",
                "title: <<filename>>",
                "date: <<dateformat('YYYY-MM-DD H:mm:ss')>>",
                "tags:",
                "- 杂谈",
                "category:",
                "- C++",
                "- C++语法",
                "mathjax: true",
                "---"
			]
		}
	],
```

## 插入图片

> 资源（Asset）代表 `source` 文件夹中除了文章以外的所有文件，例如图片、CSS、JS 文件等。比方说，如果你的Hexo项目中只有少量图片，那最简单的方法就是将它们放在 `source/images` 文件夹中。然后通过类似于 `![](/images/image.jpg)` 的方法访问它们。
> 通过常规的 markdown 语法和相对路径来引用图片和其它资源可能会导致它们在存档页或者主页上显示不正确（文章中会显示正确）。

注意所有资源都不能以`_`开头。

推荐使用的方法：

1. 在markdown文件同目录下创建一个同名文件夹，保存要应用的图片（如`hello_hexo.jpg`）  
2. 用下面的方式引用图片

```
{% asset_img hello_hexo.jpg %}
```

代替

```
![](/example.jpg)
```

但是好像感觉并没有什么用，而且重名文件夹会使目录变得更冗杂。还是用常规的方法吧。

## HTML间的相对路径

HTML间的常规引用：

> 上一级文件夹的某文件：`../index/`  
> 上两级文件夹的某文件：`../../index/`

Hexo 中，文章间的引用使用常规方法好像容易炸，因为 Hexo 创建文章是按日期创建的，如`https://lyh543.github.io:4000/2019/06/26/Testblog/`，不同日期的文件夹就会炸。  
Google 了一下，据说 Hexo 3.0 可以使用

```{% post_link hexo-writing hexo-writing %}```

的形式引用，但测了一下还是不行。
于是是用另一种方式，通过修改`站点配置文件`，修改文章的命名方式，改为只由`title`命名。

```yml
root: /
permalink: :title/
permalink_defaults:
```

然后就可以按HTML的常规引用了。  
同文件夹文章的相互引用：`../hexo-building-blog/`（最后的`/`是可选的）  
链接到[某个标题](#文章信息)：`../hexo-writing#文章信息` 或 `#文章信息`  
链接到标题的更详细的语法可以看[Markdown 语法：锚点](../markdown-grammar#锚点anchor)。

对`_posts`上一级的文件就写绝对路径吧，如 `/img/test.jpg`。  
注意从根目录开始引用博客不加 `_posts`，如 `/cpp/Blog/hexo-writing`

## 引入LaTeX 公式—— [Mathjax](../../LaTeX/Hexo插入LaTeX公式)

为此单写了一篇博客。详见那一篇博客。
