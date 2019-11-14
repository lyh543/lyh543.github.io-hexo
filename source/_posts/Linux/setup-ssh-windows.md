---
title: Windows 使用 ssh
date: 2019-11-06 11:18:51
tags:
- Windows
- ssh
- 服务器
- frp
category:
- Linux
mathjax: true
---

和 Linux 一样，Windows 10 （博主为 Win 10 1909）上也可以使用 ssh 客户端和服务器。对 Windows 进行 ssh 的效果就是 `cmd`，当然你也可以在里面输入 `powershell` 或 `wsl` 使用其他的命令行。

~~这就是这篇文章归类于 Linux 的原因吗~~

## Windows 安装 ssh 客户端

其实可以直接使用 wsl 的 ssh 客户端的。

但是既然 Windows 提供了这个功能，那就还是提一笔。

在 `Windows 设置`(按 `Windows徽标键+I`) 直接搜索 `添加可选功能` 并进入。 添加功能，找到 `OpenSSH 客户端` 并安装。

安装好以后就可以使用 `ssh` `ssh-keygen` `ssh-agent` `ssh-add` `scp` 等功能了。

## Windows 安装并配置 ssh 服务器

同样是在上面的 `添加可选功能` 找到 `OpenSSH 服务器` 并安装。

以管理员权限的 Powershell 执行 `net start sshd` 即可。

本地测试：在 cmd 执行 `ssh 微软账户@127.0.0.1`(我的是 `ssh lxl361429916@live.com@127.0.0.1`，虽然两个 `@` 确实有点蠢)，密码是微软账户的密码。  
被问及是否要信任的时候选 `yes`。

如果需要外网链接该服务器，需要有一个公网 ip 或进行内网穿透，可参考 [利用内网穿透进行远程桌面访问](../use-remote-desktop-with-frp/)。这里就不多说了。

### Windows 设置 ssh 公钥


这个地方倒挺麻烦，如果直接使用 Linux 向 Linux 加入公钥的方式 `ssh-copy-id`，在 Windows 服务器上是行不通的，会显示没有 `cat` 等命令。

直接把客户端的公钥复制到服务器的 `%USERPROFILE%\.ssh\authorized_keys` 也不能使用。因为权限不对。

> 参考链接：[Setting up OpenSSH for Windows using public key authentication - Stack Overflow](https://stackoverflow.com/a/50502015)

1. 首先通过 [scp](../download-file-on-server/#scp-命令通过-ssh-在服务器和本地互传文件) 或其他方式（随便瞎搞，鼠标复制粘贴都行），把客户端的公钥复制到服务器的 `%USERPROFILE%\.ssh\authorized_keys`。
2. 用文件资源管理器打开 `%USERPROFILE%\.ssh\`。
3. 右键单击 `authorized_keys`，打开 `属性 - 安全 -高级`。
4. 点击 `禁用继承`，并选择 `将已继承的权限转换为此对象的显式权限`。
5. 最重要的一步，是删除除了 `SYSTEM` 和当前账户以外的所有账户的权限（也就是说，最后只能剩这两个账户，`Administrators` 什么的都得删）。回答中专门提到，某些使用 `Repair-AuthorizedKeyPermission $env:USERPROFILE\.ssh\authorized_keys` 的方法会导致增加 `sshd` 的权限，最后导致失败，所有不建议这么做。
6. 如果 Windows 版本在 `1809` 及以后，还要打开 `C:\ProgramData\ssh\sshd_config` 并注释掉以下两行：

```
# Match Group administrators                                                    
#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys  
```

最后以管理员权限重启 `sshd`：

```cmd
net stop sshd
net start sshd
```

即可。