---
title: Git笔记
tags: 
- Git
category: 
- Blog
top: false
---

## git 新建库

```bash
mkdir lyh543.github.io
cd lyh543.github.io
git init
```

然后就可以按照下面的[常规三连](#git-常规三连)了

## git 常规三连

```bash
# 如果本地、服务器端不一致，需要 git pull
$ git add --all
$ git commit -m "upload 2 files."
$ git push
```

## git 使用 ssh 密钥

### 在 Linux 下给 git 使用 ssh

大概分为三步走：

1. 本地生成密钥对；
2. 设置github上的公钥；
3. 修改git的remote url为git协议。

#### Linux 下本地生成密钥对

`$ ssh-keygen -t rsa -C "lyh543@github.com"`

passphrase 可留空~~因为太懒，不然以后每次 push 都要输这个 passphrase~~

`The key fingerprint is:
SHA256:QtXXXXXXXXXXXXXXXXXXXXXXXXXXXXlk lyh543@github.com`

#### 设置 github 上的公钥

1. 查看你的公钥

```
$ cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXmp lyh543@github.com
```

2. 登陆你的`github`帐户。然后 `Account Settings` -> 左栏点击 `SSH Keys` -> 点击 `Add SSH key`
3. 然后你复制上面的公钥内容，粘贴进“Key”文本域内。 `title`域，你随便填一个都行。
4. 完了，点击 `Add key`。
5. 测试一下这个key。

```bash
$ ssh -T git@github.com
The authenticity of host 'github.com (52.74.223.119)' can't be established.
RSA key fingerprint is SHA256:nTXXXXXXXXXXXXXXXXXXXXXXX8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,52.74.223.119' (RSA) to the list of known hosts.
Hi lyh543! You've successfully authenticated, but GitHub does not provide shell access.
```

看到最后一句就是OK了。

#### 修改git的 remote url 从 `https` 改为 `ssh`

查看当前（git仓库下的）的remote url

```
# 需要到仓库根目录下
$ git remote -v
origin  https://github.com/lyh543/lyh543.github.io.git (fetch)
origin  https://github.com/lyh543/lyh543.github.io.git (push)
```

修改 remote url

```
git remote set-url origin git@github.com:lyh543/lyh543.github.io.git
```

### Windows 下 git 使用 ssh 密钥

Windows 下也可以生成 ssh 密钥对，但是需要使用第三方软件：PuTTYgen，在 Tortoise Git 中自带。由于方法不同，可以在 Windows 和 Linux 使用不同的 ssh Key。

1. 本地生成密钥对；
2. 设置github上的公钥；
3. 设置本地git使用的密钥。

#### Windows 下本地生成密钥对

进入软件，点`Generate`，然后就开始生成。由于生成时的随机数据是采集鼠标指针的移动，因此务必在生成过程中移动鼠标。

![PuTTYgen_1](/img/PuTTYgen_1.jpg)

大约1分钟以后，生成完成，如图2。

![PuTTYgen_2](/img/PuTTYgen_2.jpg)

然后 `Save Private Key` 把密钥文件存下来。  
文本框中的内容是公钥，按照[上面的方法](#设置github上的公钥)设置github上的密钥。

#### 设置本地 git 使用的密钥

由于笔者使用 Tortoise Git，在一个 reporisitory 中 push 的时候选中`自动加载 PuTTY密钥`即可。

命令行 Git 另有实现方法。

## 时光机穿梭

> 参考链接：https://www.liaoxuefeng.com/wiki/896043488029600/896954074659008#0

```bash
git log
git reset --hard HEAD^
git reset --hard HEAD^^
git reset --hard HEAD~100
git reset --hard 236c
git reflog
```
