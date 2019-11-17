---
title: 配置 LaTeX 开发环境 (TeX Live / CTeX + TeXstudio)
date: 2019-11-12 20:58:41
tags:
- 课程笔记
category:
- LaTeX
mathjax: true
---

相比于 C++、Python 等开发环境的配置，LaTeX 的开发环境就要麻烦的多了。因此也准备水一篇博客，来讲讲我的配置环境的过程。

TeX Live 和 CTeX 都是编译器。其中 CTeX 据说是根据国人优化过的（但是很久没更新了，还会出 bug，有点麻烦，不推荐）。而 TeXstudio 是编辑器。

看网上说，CTeX 和 Tex Live 是二选一的关系。博主本来是全装了的，但是发现经常遇到 bug，而在只装了 TeX Live 的笔记本上却没有这样的 bug，后来就卸载了 CTeX。

## 安装 TeX Live 

[TeX Live 的官网](texlive.org)可谓是相当简洁。。。。

![TeX Live 官网](texlive-org.jpg)

不过根据一般的大软件都会以光盘（iso）的形式提供离线安装包（如 Windows、Office），看到官网上的 DVD 就直接点进去。

点进去好像也没有什么下载的地方，不过下面有一行小字 `downloading the TeX Live ISO image and burning your own DVD`，点进去，再经几番周折就能找到了。

很不错的是，他的链接会根据你的 ip 跳转到最快的服务器，于是在这里如果把代理关掉，就能跳转到中科大 `ustc` 的源，轻松跑满速。

安装的过程不难，不多说了。

### 更改 TeX Live 远程仓库及更新

稍对 LaTeX 工作原理有所了解的人都知道，LaTeX 体系由无数的小的宏包组成，而这些宏包可能并没有默认安装在电脑，而是需要的时候会自动下载。

说到下载，一个不得不提的就是下载的源，某些外国的源到中国的下载速度非常慢，甚至下载不了。因此，切换到镜像站就非常重要。

下面是通过 GUI 等方法（较麻烦），最后还有直接命令行的方法。

安装好 TeX Live 以后，在开始菜单打开 `TeX Live Manager`。

找到 `选项` - `Repositoties...`，选择下面的 `specific mirror` 中的中国的任意一个镜像站（个人喜好中科大 `ustc`），保存。

![更换 TeX Live 仓库源](texlive-choose-repositories.jpg)  

还可以更新 `tlmgr` 之类的，都是非常容易的，自己琢磨一下能弄懂了。

顺便一提，上面的所有操作都可以用命令行（管理员权限）完成：

```cmd
tlmgr option repository http://mirrors.ustc.edu.cn/CTAN/systems/texlive/tlnet
tlmgr update --self
tlmgr update --all
```

## 安装 CTeX

> 2019.11.16 更新：博主在安装了 CTeX 和 TeX Live 的电脑上编译 beamer 幻灯片文件，死活编译不过，也手动下载了安装包，还是无解。  
> 后来偶然发现只安装了 TeX Live 的电脑竟然能编译通过。于是删掉了电脑上的 CTeX，再次编译，通过。  
> 因此，博主不推荐安装 CTeX。

CTeX 的安装也不难，甚至比上面简单。、

问题就在于 CTeX 太老了，最后一次更新是在 2016 年。导致他自带的 MiKTeX 不能链接服务器进行更新，手动更新就会报错 `Data: Get host by name failed in tcp_connect().`。

解决方法可以见 [替换CTeX套装中的MiKTeX、WinEdt和Sumatra PDF组件
](https://blog.csdn.net/pijk55556/article/details/87908328)，这里不再多说。

顺便提一下，文中还提到了替换 CTeX 的另外两个组件。有需求的可以按照上面博客做。

## 安装 TeXstudio

这货的[官网](https://www.texstudio.org/)貌似被墙了。。。

不过他有 GitHub 仓库，去 [releases](https://github.com/texstudio-org/texstudio/releases) 页就能看到下载链接了。（顺便说一句，官网的下载链接也是重定向到 GitHub 的。。。）

博主使用的是 `2.12.16` 版本。

安装也是非常简单，不过安装以后需要配置一下。

首先，TeXstudio  是支持中文的，但他就是不默认使用。在 `Option` 选项卡 - `Configure TeXstudio` - `General` 侧边栏 - `Apprearance` - `Language` 调成 `zh_CN`。

调完以后，标题的宋体就非常引人注目了。（逃

还好这也是可以调的。在刚才的 `语言` 上面有`字体`、`字号`。博主使用的是 `微软雅黑`，字号为 `9`。

如果你使用的是 2K 以上的屏幕，工具栏的图标还是很小。这玩意不适配高分屏吗？？

后来发现还是可以改。。。在刚才的设置的最下面有一个高级设置的复选框，勾上以后，就出现了 GUI 缩放的功能。

![调整 GUI](texstudio-configure-gui.jpg)

选项还是靠拖动的，拖到一个比较好看的地方就可以了。

之后 TeXstudio 也不需要怎么配置了，直接就能调用 CTeX / TeX Live 编译了/
