---
title: HTML（萌新向）
date: 2020-03-06 16:52:32
tags:
- HTML
- 计算机科学
category:
- 计算机科学
mathjax: true
---

[一个 HTML 在线测试网站](https://www.w3school.com.cn/tiy/t.asp)

## 注释

```html
<!-- this is a comment -->
```

## 显示一张图片

将一行代码保存为 `index.html`：

```html
<img src="maomao.gif">
```

既可以使用（服务器的）本地图片，也可以使用网上的图片。

### 调整图片显示尺寸

可以按照像素进行放缩，如下面调整宽度为 320 像素，高度为 240 像素：

```html
<img src="maomao.gif" width=320px height=240px>
```

也可以按照浏览器窗口的比例显示，如下面是宽度调整为浏览器的 `50%`，高度调整为浏览器窗口的 `30%`：

```html
<img src="maomao.gif" width=50% height=30%>
```

如果只填写 `width` 或 `height`， 图片会按比例缩放。

### 从列表随机选择一张图片显示

> 参考：https://ouuan.github.io/post/html实现随机图片/

## 用 HTML 5 控件播放视频

```html
<video width="320" height="240" controls>
  <source src="movie.mp4" type="video/mp4">
  <source src="movie.ogg" type="video/ogg">
您的浏览器不支持 Video 标签。
</video>
```

打开网页时，网页会由上往下依次检索是否支持这种 video。如果都不支持，就会显示 `您的浏览器不支持 Video 标签`。

不过感觉大多数浏览器都支持在线播放 mp4 格式吧，只提供一个 mp4 应该也可以了。
