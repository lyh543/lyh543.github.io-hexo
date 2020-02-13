---
title: 服务器下载文件
date: 2019-10-23 12:39:17
tags:
- 服务器
category:
- Linux
mathjax: true
---

## 前言

某些国外网站，虽然没有被墙，但是下载个东西，几十 KB 的网速很难顶。

于是想把东西下载服务器上，然后本地从服务器满速下载。这也就是离线下载的原理。

## 基础知识

后台运行也是非常重要的，博主就一笔带过，将原本的命令改为 `nohup <命令> &` 即可后台执行（此时可以按 `Ctrl+C` 关掉 `nohup` 的前端）。

另外，如果服务器显示了“可以通过 `127.0.0.1:8080` 访问……”，表示的是服务器本机的 8080 端口，就可以在你的电脑访问 `[服务器ip]:8080`（如 `39.1.2.3:8080`）来访问对应的网站。后文不再赘述。

## 服务器下载文件

服务器下载 http(s) 直链，最常用、也是最无脑的就是 `wget <Link>` 了。  
对付非直链的情况，我们有非直链的解决方案；  
对于种子/磁力链，我们可以使用

### wget 下载 Google Drive 文件

在时断时续的梯子上，Google Drive 的下载不是很方便，特别是需要下载一个大文件的时候。

但是 Google Drive 是可以获取直链的。很香。

服务器用 wget 从 Google Drive 下载小文件的命令为（需要替换链接中的 `FILEID`）：

```
wget --no-check-certificate ‘https://docs.google.com/uc?export=download&id=FILEID’
```

对于大文件，无法通过安全查杀，所以要用别的命令（注意 `FILEID` 有两处）：

```
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=FILEID" && rm -rf /tmp/cookies.txt
1
```

其中，需要替换其中的 `FILEID` 为公开分享的文件 ID，下面是实例：

```
https://drive.google.com/open?id=FILEID
https://drive.google.com/file/d/1_wnCdMKB4_GQM9dtA4AOHxZ21NCGFNm9/edit
```

第二条的 `1_wnCdMKB4_GQM9dtA4AOHxZ21NCGFNm9` 即为 `FILEID`。

就可以感受国外连服务器的 60M/s 的网速了。

### wget 下载 mediafire.com 的文件

> 参考链接：https://moeclub.org/2018/04/11/609/?spm=23.8

这个网站就属于一开始说那种的网站，没有被墙，但是国内访问速度平均不到 100 K/s。

不过这个网站又不像 Google Drive，可以直接找到直链，而是需要你访问网站，然后生成一个直链网页中（这些网站都挺良心，直接把直链放网站上，不像国内某云）。但是不同端登录给的直链时不一样的，所以我们要在服务器访问网站。

具体来说，就是在服务器用 `wget` 下载他分享的链接对应的 html，然后从 html 里面找到链接即可用 wget 下载。

假设我们的直链如下（注意统一用 https）：

```
https://www.mediafire.com/file/yrd1py7od5911zt/Catalina_Virtual_Disk_Image_by_Techsviewer.rar/file
```

可以用以下命令：

```bash
LINE=https://www.mediafire.com/file/yrd1py7od5911zt/Catalina_Virtual_Disk_Image_by_Techsviewer.rar/file

Index_data="$(wget --no-check-certificate -qO- "$LINE" | grep -o 'https://download.*.mediafire.com/.*/.*"' | cut -d'"' -f1
# 通过分享的链接获取页面 html，并通过正则表达式抓到下载链接
```

得到类似下面的 `Index_data`。其中 `download` 后的 `2331` 就是每个直链不同的地方。

```
https://download2331.mediafire.com/chmg33d4airg/yrd1py7od5911zt/Catalina+Virtual+Disk+Image+by+Techsviewer.rar 
```

然后就可以 `wget "$Index_data"` 或手动 `wget <网址>` 进行下载。

如果需要后台下载，当然是用 nohup 了。这样，即使是几十 kb 的下载速度，服务器下个三天三夜，然后就可以以满速下到本地了。

```bash
nohup wget "$Index_data" &
```

下载的进度可以 `tail nohup.out` 查看输出文件的最后几行。

### qbittorrent 下载磁力链/种子

```bash
apt install qbittorrent
qbittorent-nox
```

安装 qbittorrent 以后，提供了两条命令 `qbittorrent` 和 `qbittorrent-nox` 的。前者是提供 GUI 的，后者是给命令行使用的（所谓 `no X`）。

输入 `qbittorent-nox` 以后，就可以在本地通过访问对应的网站来管理服务器的 qbittorent 下载种子了。

如果需要后台执行，可以使用 `qbittorrent-nox -d`。

## 服务器、本机互传文件

### scp 命令：通过 ssh 在服务器和本地互传文件

```bash
scp /home/work/source.txt work@192.168.0.10:/home/work/
#把本地的source.txt文件拷贝到192.168.0.10机器上的/home/work目录下

scp work@192.168.0.10:/home/work/source.txt /home/work/
#把192.168.0.10机器上的source.txt文件拷贝到本地的/home/work目录下

scp work@192.168.0.10:/home/work/source.txt work@192.168.0.11:/home/work/
#把192.168.0.10机器上的source.txt文件拷贝到192.168.0.11机器的/home/work目录下

scp -r /home/work/sourcedir work@192.168.0.10:/home/work/
#拷贝文件夹，加-r参数

# 更改端口用 -P 参数
```
### http 传输文件

#### python3 http.server 一行建立 http 文件服务器（不支持断点续传、密码验证）

```bash
sudo apt-get install python3

python3 -m  http.server 8000
```

需要更多的选项，可以使用 `python3 -m  http.server --help`

看到 `Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...` 以后即可。

就可以在互联网上通过打开访问到当前文件夹了。后台运行同样是 `nohup`。

注意这是没有密码验证的，也不支持断点续传（毕竟 `simple` ），所以**不要长期开放！！！**

#### npm http-server 一行建立 http 文件服务器（支持断点续传，不支持密码验证）

```bash
apt install npm
npm install http-server -g

http-server
```

其中 `http-server` 的常用参数为 `http-server [path] [-p port]`。`port` 默认为 8080。

另外，实现同样功能的还有：https://github.com/lwsjs/local-web-server

### 通过 SMB

如果能使用 SMB，就可以把服务器的某个文件夹当做（Windows）本机的一个硬盘，上传下载都是非常的方便。

然而，SMB 配置起来比较麻烦，一是 SMB 通常用于局域网内，在外网使用会麻烦一点；二是 SMB 的默认端口 445 被阿里云、腾讯云等封禁了，需要使用别的端口。但是确实有人实现过。我还是老老实实使用 scp 吧。