---
title: npm笔记
date: 
tags: 
- npm
category: 
 - Blog
---

npm是随同NodeJS一起安装的包管理工具。

**除了-g的全局命令以外，所有`npm`命令都要在工程目录执行！！！！**

## 常用命令

### 安装 npm

#### 检测版本号

`npm -v`

#### 升级 npm

`sudo npm install npm -g`

### 安装模块

`npm install <Module Name>`

安装好之后，express 包就放在了工程目录下的 node_modules 目录中

参数 `-g` 全局安装

**给当前工程安装插件的时候需要注意**：

**一定要加`npm install <package name> --save`参数，这样该插件才会被加入该项目的`dependencies`中，下次生成主工程的时候才会被编译。**

#### 查看模块

`npm list -g`

查看某个特定模块

`npm list <Module Name>`

#### 更新模块

`npm install <Module Name>@latest -g`

#### 卸载模块

`npm unistall grunt`

#### 使用淘宝 NPM 镜像

`npm install -g cnpm --registry=https://registry.npm.taobao.org`
`cnpm install [name]`
