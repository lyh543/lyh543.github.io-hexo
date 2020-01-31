---
title: Hexo 使用 Gitalk 评论
date: 2019-9-17
tags:
- Hexo
category:
- Blog
mathjax: true
---

> 2019.10.29 更新：由于 Gitalk 对 GitHub 之外的网站支持不好（在 `github.io` 以外的域名下都不能进行评论），现已迁移至 Valine。
> Valine 的博客推送做的不是很好，不过有第三方实现方案。可查阅 [官方网站](https://valine.js.org/notify.html)。
>
> 2019.11.6 更新：由于 GitHub OAuth API 限制，只能有一个回调网页`Authorization callback URL`，但是没有限制为 `github.io`。可在 https://github.com/settings/developers 对应的地方修改。
> gitalk 真香。邮件是由 GitHub 发的，稳定性比自己邮箱发会稳定得多。

阅读 [Material 主题](https://github.com/viosey/hexo-theme-material/) 的主题配置文件以后，可以发现，Material 主题的配置文件是自带了评论区的功能，但是给的几个网站都不是很好用。（disqus国内用不了，changyan需要备案，gitment作者~~删库跑路了~~停更并把服务器关了）。  

在 Material 的 github 网站的 issue 下找到了关于新增 [gitalk](https://github.com/gitalk/gitalk/blob/master/readme-cn.md) 的 pull request。  
所以按照 [pull request](https://github.com/viosey/hexo-theme-material/pull/554/files) 修改、添加对应的文件就可以了。（注意在本地不应该修改`_config.template.yml`，而应该直接修改主题配置文件`_config.yml`）。其他 Hexo 主题的添加方式同理。

其中`_config.yml`的内容需要到 [Github New OAuth Application](https://github.com/settings/applications/new)注册申请。申请需要填的东西有：

标题|内容
-|-
Application name|随便写，建议填你的网站名`<username>.github.io`
Homepage URL|博客域名`https://<username>.github.io/`
Application description|随意，可不填
Authorization callback URL|博客域名`https://<username>.github.io/`

register 以后会得到一个`Client ID`和`Client Secret`。需要分别填进主题配置文件。

`主题配置文件`需要作如下修改：

```yml
comment:
    use: gitalk

    gitment_client_secret:
    valine_leancloud_appId:
    valine_leancloud_appKey:
    gitalk_owner: # 你的github用户名，如lyh543
    gitalk_repo: # 你的github仓库名，如lyh543.github.io
    gitalk_client_id: # 刚才获取的 Client ID
    gitalk_client_secret : # 刚才获取的 Client secret
```

配置好并 `hexo d -g` 以后，打开一篇文章，发现“未找到相关的 issues 进行评论”。使用 Github 登录以后，就会显示 `Error: Validation Failed`。

去 Gitalk 的 Issues 下还真找到了这个 [Issue]https://github.com/gitalk/gitalk/issues/102], 还是被置顶了的。

看样子 bug 是因为 Gitalk 是默认用文章标题作 issue 的 `lable`，并以此作为该评论区的唯一识别码。Github 限制了 issue 的 `lable` 长度不超过 50，如果使用中文，在链接中一个中文等于三个字符，导致 `label` 过长，无法正常生成评论。

该 Issues 下有一条评论给出了[一个方案](https://github.com/gitalk/gitalk/issues/102#issuecomment-364930067)，使用标题的 Hash 值的前 50 位作为 `label`。

但是博主尝试以后发现仍然不行，不懂 Javascript 的博主猜测是 Javascript 的函数名引用错了。经 Google 以后，找到了一个[可用的 Javascript](https://github.com/viosey/hexo-theme-material/issues/622#issuecomment-373307046)。

但是还有一个问题是，他不会为每一篇博客自动生成 issue，也就是初始化评论。

解决方案有不少，但是感觉挺麻烦的，做的话有点力不从心。在这里抛几个链接把：

[（`ruby`脚本，Gitalk 官方）评论初始化](https://github.com/gitalk/gitalk/wiki/%E8%AF%84%E8%AE%BA%E5%88%9D%E5%A7%8B%E5%8C%96)  
[（`Nodejs`）自动初始化Gitalk评论](http://edisonxu.com/2018/10/31/gitalk-auto-init.html)  
[（`ruby`脚本）自动初始化 Gitalk 和 Gitment 评论](https://draveness.me/git-comments-initialize)

大概就这样结帖了。
