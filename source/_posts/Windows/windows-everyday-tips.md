---
title: Windows 使用小技巧
category:
- Windows
tags:
- Visual Studio Code
- Excel
mathjax: true
---

也不只是 Windows 的，也可能是某款软件如 Chrome 或 VS Code 的，这样就不局限于 Windows 系统了。

## 快捷键集合

快捷键|作用|说明
-|-|-
`Ctrl +Shift + T`|重新打开关闭的标签页|在 Visual Studio Code 和 Chrome 等可用

### Home 和 End 按键

对于大多数小白，键盘上的这两个键形同摆设，但是在纯键盘流/处理大文件（千行以上）时，这两个键就很香了。

在文本编辑器中，`Home` 跳到本行开头；`End` 跳到本行结尾；  
如果想到跳到全文开头/结尾，加 `Ctrl` 就可以了。

#### Excel 中的 End 按键

对于处理大量数据的 Excel 表格，有些时候拖滚动条都要拖好久。我们知道，`Home` 和 `End` 在其他应用能跳到同行的开头和结尾，但是貌似不能解决几千甚至几万行的 Excel。

所以，Excel 对 `End` 进行了“魔改”，按了 `End` 以后，并没有立即跳转到行末，而是等待输入一个方向键，**即可跳转到该方向的最后一个位置**。

### Shift 高级菜单

在某些地方按住 `Shift`，能发现某些地方多了一些选项。

如，右键单击任务栏时，按住 `Shift`，发现多了一个 `关闭资源管理器` 的选项。（不过貌似也没什么用，没有任务管理器的直接重启 `explorer` 进程好用）；

![按住 Shift 右键单击任务栏](shift-taskbar.jpg)

又如，在文件资源管理器中任意地方按住 `Shift` 右键单击，可以看到多了两个选项：`在此处打开 Powershell` 和 `在此处打开 Linux Shell`。类似于 Linux 资源管理器。

![按住 Shift右键单击文件资源管理器](shift-explorer.jpg)

### 管理员身份 Ctrl + Shift

在几乎所有地方地方都适用，如文件资源管理器、开始菜单、任务栏、“运行”菜单等。

## 开启 ping 回显

在局域网里可以 ping 自己的 Windows 电脑，而互联网里却 ping 不了。这是因为 Windows 强大的防火墙默认关闭了 ping 的回显。

打开回显，可以通过防火墙的 GUI 点点点找到，但是也可以只需要一行命令行（命令行还是香，再怎么说，教程里面复制粘贴也太方便了）。

参考链接：[微软官方文档](https://support.microsoft.com/en-us/help/947709/how-to-use-the-netsh-advfirewall-firewall-context-instead-of-the-netsh)。

在 Windows 10 上（准确的说，在 Windows Vista 及以上），以管理员身份打开 cmd 或 Powershell，然后输入

```cmd
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
```

看到 `确定。` 即可。