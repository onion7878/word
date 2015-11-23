---

layout: post
title: Lifelike fake progress bar
date: 15-01-19 14:01:06
tags: [code, math, delphi]
categories: [movie]

---

![estimation]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/estimation.png)

*via [xkcd.com](http://xkcd.com/612/)*

最近需要做一个进度不可控制的进度条，说它不可控是指没有办法通过具体数字去控制它；一般进度条类似于需要复制 100 个文件，那么整个进度就是 100 ，每复制完一个文件后，进度就增加一，这样整个过程就会相对精确；而不可控的进度一般是指整个过程没有办法分割成可以度量的状态，只有两个状态，开始和结束；但一般会有一个大概的时间，或者说超时限制，所以这种进度条整个状态就是开始一直跑，当检查到**结果完成**时或者**超时**的时候完成整个进度并且退出。举个例子来说，现在需要复制一个大文件，并且假设无法得知当前复制了多少，但大概知道复制整个文件需要多少分钟；那么整个过程就是：不断检测到当前文件是否已经复制完成或者复制的时间已经超时了，完成了或者超时了就让整个过程完成。所以问题来了，如何让这样的过程看起来像真是的一样平滑，自然。

<!-- more -->

## 大体想法

 - 确定一个大概完成的时间
 - 进度条开始跑的快，越到后面越慢，并且这是一个在一定程度上可控的参数
 - 当达到完成条件时平滑的完成剩余的进度

## 指数函数

$$y = k^x$$

更直观一点把 `k` 设为 `2`

$$y = 2^x$$

下图为该函数的曲线图

![2^x]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/2x.png)

通过变化可以转换成这样的图形

![4func]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/4func.png)

红色的函数为

$$y = 2^x$$

蓝色的函数为

$$y = 2^{-x}$$

绿色的函数为

$$y = -2^{-x}$$

最终我们需要的函数为紫色函数

$$y = 1 -2^{-x}$$

如果把该函数放大了看，可以看到当 `X` 无限大时 `Y` 是无限趋近于 `1` 的，所以得到的函数为

$$y = 1 -k^{-x}$$

当 `k` 的取值范围在 `1~10` 时的动态图如下

![dfunc]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/dfunc.gif)

这就是之前提到进度开始跑的快慢程度就是可以通过整个 `k` 值控制。

## SHOW ME THE CODE

```delphi
function Exp(X : Double) : Double;
const
  K = 2;
begin
  Result := 1 - Power(K, -X);
end;
```

应用到进度条上


```delphi
function SimuProc(const MaxTime, CostTime : Cardinal) : Double;
const
  MAX_X_VALUE = 5; // X = 5; Y = 0.969
var
  X : Double;
begin
  X := (MAX_X_VALUE * CostTime) / MaxTime;
  Result := Exp(X);
end;
```

这函数通过最大时间和消耗的时间算出一个百分比，这里的 `MAX_X_VALUE = 5` 是人为的设定

![25]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/25.png)

可以看到当 `X = 5` 时 `Y` 已经很接近 `1` 了，近似的可以看作 `1`

算出百分比后就可以通过整个函数来控制进度条了


```delphi
procedure Foo;
const
  TIMEOUT  = 1000 * 7;
  MAX_TIME = 1000 * 10;
var
  I        : Integer;
  StrtTime : Cardinal;
  CostTime : Cardinal;
begin
  StrtTime := GetTickCount;
  ProgressBar.Max := MAX_TIME;
  for I := 1 to ProgressBar.Max do
  begin
    CostTime := GetTickCount - StrtTime;
    ProgressBar.Position := Trunc(SimuProc(ProgressBar.Max, CostTime) * ProgressBar.Max);
    Application.ProcessMessages;
    Sleep(10);
    if CostTime >= TIMEOUT then Break;
  end;
  ProgressBar.Position := 0;
end;
```

到这，基本可以得到一个可用且可控的进度条的 `99%`

## %1

![raw]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/raw.gif)

可以看到当 `CostTime >= TIMEOUT` 时整个进度条就直接跳到 `0` 了。

修改代码如下：

```delphi
if CostTime >= TIMEOUT then
begin
  ProgressBar.Position := ProgressBar.Max;
  Sleep(10);
  Break;
end;
```

![optm1]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/optm1.gif)

修改后可以看到在最后，进度条会一下跳到最后，然后再复原，相对来说比之前好一些，但是也不完美。可以让后面的部分更平滑一些。

这里专门构建一个函数来达到这个效果。

```delphi
procedure ReachTheEnd(ImageProgress : TImageProgress);
var
  I    : Integer;
  Rest : Integer;
begin
  Rest := ImageProgress.Max - ImageProgress.Position;
  for I := 1 to Rest do
  begin
    ImageProgress.Position := ImageProgress.Position + 1;
    Application.ProcessMessages;
    Sleep(1);
  end;
end;
```

替换跳出条件中的代码

```delphi
if CostTime >= TIMEOUT then
begin
  ReachTheEnd(ProgressBar);
  Break;
end;
```

![optm2]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/optm2.gif)

终于有点像样子了，但是还是存在问题，当前设置的跳出时间是 `7s` 总时间时 `10s` ，相对来说当跳出后进度条 `ReachTheEnd` 所用的时间相对较短，如果把 `TIMEOUT` 设为 `1s` 就会呈现这样的效果：

![optm3]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/optm3.gif)

虽然已经跳出了，但是后面的进度并没有很快的结束；一方面的原因时由于当进度条增加时都会 `Sleep(1)` 一定程度上延缓了显示的效果，而主要原因是当还剩下很大一部分进度需要快速跑完时，这次根据 `Rest := ImageProgress.Max - ImageProgress.Position` 循环前进的方法就很不靠谱。

假设在 `1%` 的时候就跳出，按照之前的函数曲线，这时进度条的 `Position` 大概等于 `Max * 29%` ，所以剩下还有 `70%` 的进度没有跑完，如果 `Max = 10000` ，那么安装上述的函数快速跑完进度条的循环次数差不多在 `7000` 次左右，这就存在一个问题：当进度条向前跑的时候其实就是一个像素一个像素的向前，一般请客下基本不可能达到 `7000` 个像素，这解释了以上面的方法来快速跑完进度条会显示很慢的原因，实际上没有必要循环那么多次

修改 `ReachTheEnd` 函数：

```delphi
procedure ReachTheEnd(ImageProgress : TImageProgress);
var
  I             : Integer;
  RestPixel     : Cardinal;
  PixelPerCount : Cardinal;
begin
  with ImageProgress do
  begin
    RestPixel     := Trunc((Width * (Max - Position)) / Max);
    PixelPerCount := Trunc(Max / Width);
  end;
  for I := 1 to RestPixel do
  begin
    ImageProgress.Position := ImageProgress.Position + PixelPerCount;
    Application.ProcessMessages;
    Sleep(1);
  end;
end;
```

修改后的效果如下（TIMEOUT = 3s）：

![optm4]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/optm4.gif)

修改跳出后的进度条明显快了许多，但因为快了又出现了点不平滑的感觉，这次就可以通过修改 `ReachTheEnd` 函数中的 `Sleep()` 的值来调整：

*（TIMEOUT = 3s; Sleep(5)）*

![optm5]({{site.url}}/assets/blog_img/2015-01-12-lifelike-fake-progress-bar/optm5.gif)

这样差不多看起来就像一个正常点的**假**进度条了。

## Reference

- [Exponential_function](http://en.wikipedia.org/wiki/Exponential_function)
- [function curve](https://www.desmos.com/calculator/odwj10a016)

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>