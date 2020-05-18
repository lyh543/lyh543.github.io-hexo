---
title: MATLAB GUIDE（萌新向）
date: 2020-05-15 20:47:50
tags:
- MATLAB
- GUI
category:
- MATLAB
mathjax: true
---

第一次从命令行到 GUI，总是不那么顺利的，尤其是 GUIDE 快被 MATLAB 弃用了，导致一向以文档详细著称的 MATLAB，也没有花多少笔墨在 GUIDE 上。

博主因为数模需要速成 GUI，无奈没有很好的教程，走了很多弯路。因此博主在数模交完论文之后，简单理一下速成 GUI 的思路。

## 实例代码

MATLAB 为 GUIDE 编写的 Hello World 级别教程：https://ww2.mathworks.cn/help/matlab/creating_guis/about-the-simple-guide-gui-example.html

## 简单概念

### fig 和 m 的关系

按上面的教程，打开 guide 并绘制了图形，就会自动生成一个 m 文件。简单的来说，fig 文件保存了 GUI 的窗口的样子，而 m 将会保存程序的逻辑。

### 各类函数的意义

接着上文说，你会看到创建了一堆函数，那么具体是什么呢？

现在假设我们想创建一个加法器（不是），具有两个按钮 `+` 和 `-` 和一个文本框，前者会使文本框内内容 +1，后者会 -1。

通过在 `guide` 命令新建的 fig 文件上，我们能很快糊出下面的图，并且把两个按钮改名为 `+` 和 `-`：

![fig 文件](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/8ecbacbfa2c19457b2e24d9783601dc23468d54ba6adcd63bcaa99d23b1e5f4f.png)

然后保存，得到 m 文件，虽然代码有很多注释，但为读者方便对比差异（如果有），我还是完整贴一下代码如下：

```m
function varargout = test_gui(varargin)
% TEST_GUI MATLAB code for test_gui.fig
%      TEST_GUI, by itself, creates a new TEST_GUI or raises the existing
%      singleton*.
%
%      H = TEST_GUI returns the handle to a new TEST_GUI or the handle to
%      the existing singleton*.
%
%      TEST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_GUI.M with the given input arguments.
%
%      TEST_GUI('Property','Value',...) creates a new TEST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_gui

% Last Modified by GUIDE v2.5 17-May-2020 22:18:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @test_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before test_gui is made visible.
function test_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_gui (see VARARGIN)

% Choose default command line output for test_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
```

~~这博客真好水，放一段全是注释的代码，87 行就有了~~

注意 27 行到 44 行被 `Begin initialization code - DO NOT EDIT` 和 `End initialization code - DO NOT EDIT` 字样的注释包围了，这便是我们的函数的主函数。只是做了一些看不懂的初始化。确实，虽然他对于 GUI 的实现非常重要，但是我们的重点不在这里。

#### OpeningFcn

```m
% --- Executes just before test_gui is made visible.
function test_gui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);
```

这个函数。。。`Fcn` 是 function 的意思，看起来是 test_gui 这个文件的什么重要开场函数。确实，就相当于一个 init 函数，在程序运行时就会执行。

这个。。。`guidata`，`hObject` 和 `handles` 是个啥。不知道不知道，后面再说。

#### OutputFcn

```m
% --- Outputs from this function are returned to the command line.
function varargout = test_gui_OutputFcn(hObject, eventdata, handles) 
```

这个函数看说明，应该就是程序的返回值用的，比如正常返回 0，错误返回非 0 之类的。

#### pushbutton1_Callback

好了！这个是重点！

`pushbutton`，按钮？是我们刚才弄的两个之一吗？


![picture 2](https://lyh543.coding.net/p/pic-bed/d/pic-bed/git/raw/master/f02fc3a7bc07c3a8279c6efdc9d831d440e9fe4eca3d3c67753b337a0bbfb526.png)  

确实，在 `fig` 上双击先创建的按钮，会弹出上面的窗口。除了字体、字号、String 等设置以外，我们看到了他！`Tag: pushbutton1`。

啊所以这个函数名是靠 Tag 名绑定窗口按钮的？是的！这是 MATLAB 设定。所以，你可以同时把 tag 和函数名的 `pushbutton1` 改为 `plus_button`。

那这个 `Callback`？啊其实就是当按钮被按下时，会调用的 `回调`（`Callback`）函数。

那那那那那个静态窗口是不是就没有 `Callback` 函数呢，而还有一个 `pushbutton2_Callback` 函数呢？

确实！

**总结一下，`handlebutton1` 关联了 `Tag` 叫这个名字的控件，而 `Callback` 是指这个函数是会在控件被触发时调用的 `回调函数`。**

### handles

既然我们知道 1. `OpeningFcn` 在开场时会执行；2. 当 `+` 按钮被按下，`pushbutton1_Callback` 会被触发，那我会写了！

```m
function test_gui_OpeningFcn(hObject, eventdata, handles, varargin)
counter = 0;

function pushbutton1_Callback(hObject, eventdata, handles)
counter = counter + 1;
disp(counter);
```

咦？有点问题？

根据 MATLAB 知识，两个函数的 `counter` 是不互通的。他们之间貌似也没有相互调用啊。那那那那咋办呢？

声明为全局变量？不会吧，要是 GUI 程序不用全局变量就没法写，那也太蠢了吧？

确实有别的办法，因为有一个东西，能沟通程序的控件的所有内容，她就是，`handles`。

handle （此处非 `handles`）是句柄，也就是一个类似于指针的东西。如果你也不知道指针，那……那就不管了。

简单的理解，MATLAB 的 `handles` 就是一个结构体，装了各种各样的数据，包括 GUI 的，包括你的程序需要使用的。

为什么要搞这个东西呢？因为从上面来看，MATLAB GUI 的实现方式是将所有东西都包装成函数，主函数没有什么存在意义。而没有主函数，如果不使用全局变量，数据就很难交互（比如，这个 `pushbutton1` 按下时，想读取那个输入框的内容时，就需要跨函数交互了）。

因此，如果将所有数据存在一个**结构体**下面，同时将这个结构体作为所有 `Callback` 函数的参数，问题就解决了！还真是，这个**结构体**就叫 `handles`！

所以如果想保存数据/更新数据以供其他函数读取，就可以保存到 `handles` 下面。

但是但是！并不是说 `handles.value = 1;` 就是上面说的把数据保存在 `handles` 下面了。因为根据 MATLAB 知识，你修改的是你的函数下的 `handles`，并不是系统给你的 `handles` 了。

因此，引入一个新的语句：

```m
guidata(hObject, handles);
```

该句将你函数内的这个 `handles` 传给“系统”。至于为什么要 `hObject`，别问，问就是不知道，你能要求一天速成的人完全明白这一切的一切吗？会用就行了。（这是竞赛交卷以后马上写的，防杠标签）

`传给了系统`，这句话的意思，是指当别的 `Callback` 函数被调用时，它的 `handles` 应该是你在这个函数 `guidata` 传给“系统”，“系统”调用 `Callback` 函数时，就会把你的这个 `handles` 复制一份给它。至于这个“系统”是什么，请参照上一段。

https://ww2.mathworks.cn/matlabcentral/answers/47189-purpose-of-guidata-hobject-handles


#### 读取、写入 handles 值

因此，写入 handles 的语句应该如下：

```m
handles.counter = 0;
guidata(hObject, handles);
```

读取则是由 `Callback` 函数得来。其实也可以手动获取：

```m
handles = guidata(hObject);
```

你会发现，读写原来是一个函数！

~~有毒吧，用 `ReadGUIData` 和 `WriteGUIData` 不好吗？~~


### 修改静态文本框

于是，你觉得你又会了！~~（总觉得有问题）~~

```m
function test_gui_OpeningFcn(hObject, eventdata, handles, varargin)
counter = 0;
guidata(hObject, handles);

function pushbutton1_Callback(hObject, eventdata, handles)
counter = counter + 1;
disp(counter);
```

当你准备运行这段代码时，

`disp`？那不是命令行的东西吗？

哦哦，突然想起我要输出在静态文本框里。

静态文本框？输出？静态的东西不能修改，怎么能用来输出？

是的，我被骗了。我还以为有一种动态文本框的存在。然而 Google 很久都没有——直到我发现了下面的代码：

```m
set(handles.text1,'String','Hello World');
% 别忘了 guidata(hObject, handles);
```

嗯？

突然意识到什么。

赶紧看看我的静态文本框的属性。

（植物）！这个静态文本框的 `Tag` 为 `text1`，而且属性 `String` 的值正是正在屏幕上显示的 `静态文本`！

原来这都是可以直接 set 的啊。。。。

顺便一提，还有 `get`。

get:

```m
str = get(handles.text, 'String');
```

由于某些原因（一天速成就不要求这些了叭），不推荐通过直接查询/修改 `handles.text` 的成员，而是推荐 `get` 和 `set` 其属性。

## 加法器（不是）

那我是不是用 `handles` 存 `counter` 数据，用 `set(handles.text1,'String',counter);` 输出就可以了？

于是你又觉得你好了！

---------------------

确实。这次是真的好了（？）。运用上面提到的内容，以及 MATLAB 基础知识，你就能实现一个加法器（不是）了。

一段非常简单的代码。复制保存为 `test_gui.m`，并且下载 [`test_gui.fig`](test_gui.fig)，在 MATLAB 中运行 `test_gui.m` 即可看到一个加减按钮和即时显示结果的简单小程序。

```m
function varargout = test_gui(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @test_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before test_gui is made visible.
function test_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.counter = 0;
set(handles.text2, 'String', handles.counter);
handles.output = hObject;
guidata(hObject, handles);

function varargout = test_gui_OutputFcn(hObject, eventdata, handles) 
guidata(hObject, handles);
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
handles.counter = handles.counter + 1;
set(handles.text2,'String',handles.counter);
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
handles.counter = handles.counter - 1;
set(handles.text2,'String',handles.counter);
guidata(hObject, handles);
```

## 结语

如果你能独立写出加法器（不是），那么你应该能算是入门了。至于 `popupmenu` 等控件的使用方法和其他一些细枝末节，相信聪明的你一定也可以的！

~~有毒的结尾~~

顺便，最后说一句，将控制台 MATLAB 代码改成带有 GUI 的，推荐前者尽量使用函数，主函数几乎只用于调用函数。
