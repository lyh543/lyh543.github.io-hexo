---
title: Hexo Material 主题配置
date: 2019-8-17
category:
- Blog
mathjax: true
---

[Material 主题](https://github.com/viosey/hexo-theme-material/)是一个基于 Material Design （质感设计）的 [Hexo](https://hexo.io/)主题。  

Hexo 更换主题的方法参见另一篇[博客](../hexo-building-blog)。

在网上找到了一个配置过程非常详实的[博客](https://zhouxiaoyu1994.github.io/2017/04/27/Hexo%E6%B7%B1%E5%9D%91%E4%B9%8B%E6%97%85%EF%BC%885%EF%BC%89%E2%80%94%20Materia%E4%B8%BB%E9%A2%98%E4%BC%98%E5%8C%96/)，而且还修复了一些主题的小 bug，基本上按照这个博客做就好啦。

但是按照这篇博客做了之后，还是有几个小问题：

### bug1：无法本地搜索

要实现本地搜索，除了安装[hexo-generator-search][1]插件外，还要把`主题配置文件`的`search.use`从`google`修改为`local`。

```yml
# Search Systems
# Available value:
#     swiftype | google | local
search:
    use: local
    swiftype_key:
```

### bug2：图表显示不全

原主题配置文件的图标包是从`googleapis`在线获取的，由于众所周知的原因，大陆不能顺利访问。但是主题配置文件中提供了镜像站的选项，把`google`改成中科大的镜像站`ustc`就可以正常显示图标了。

```yml
fonts:
    family: Roboto, "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif
    use: ustc
    custom_font_host:
```

### bug3：代码高亮也有问题

如下图。

![highlight](https://user-images.githubusercontent.com/15999179/34318128-78f404fe-e7fa-11e7-8d66-3d72bf7f6b88.png)

这个在[Material主题的Issues](https://github.com/viosey/hexo-theme-material/issues/601)被大量提及。

解决方法步骤：

- 关掉`主题配置文件`的`hanabi`高亮，并开启`prettify`高亮；

```yml
prettify:
    enable: true
    theme: "github-v2"

hanabi:
    enable: false
    line_number: false
    includeDefaultColors: true
    customColors:
```

- 在`站点配置文件`里，关掉 Hexo 自带的所有 Highlight。

```yml
highlight:
  enable: false
  line_number: false
  auto_detect: false
  tab_replace:
```

- 下一次执行`hexo g`之前先`hexo clean`

放一个我的[主题配置文件](config.yml)

改名以后，直接覆盖`_\themes\material\_config.yml`就可以了，也可以做一些自己的修改。

## 页面计数——不蒜子

Material 里面自带了不蒜子的。在主题配置文件里面打开开关，然后更换一下不蒜子的链接（原服务器倒闭了）就可以了。这个挺简单的。

```yml
# _config.yml
# Busuanzi 不蒜子 Views
busuanzi:
    enable: true
    all_site_uv: true
    post_pv: true
    busuanzi_pure_mini_js: "https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"
```

## 推荐插件

插件等配置可以参照这个

[【持续更新】最全Hexo博客搭建+主题优化+插件配置+常用操作+错误分析](https://juejin.im/post/5bebfe51e51d45332a456de0#heading-29)

一些插件的链接  

[hexo-generator-search][1]  
[hexo-helper-post-top][2]  

但是安装`hexo-helper-post-top`以后，必须要有一个置顶的博客额，不然就会炸。还是卸载吧。

[1]: https://github.com/PaicHyperionDev/hexo-generator-search
[2]: https://www.npmjs.com/package/hexo-helper-post-top

下载安装插件，需要在博客根目录使用下面这句命令

```bash
npm install <package name> --save
```

一定要加`--save`参数，这样该插件才会被加入该项目的`dependencies`中，下次生成hexo的时候才会被编译。

插件具体使用方法建议去看各插件的github项目的`README.MD`文件。
