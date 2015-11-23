---

layout: post
title: Hungarian notation
date: 14-08-21 16:57:41
tags: [code, wiki]
categories: [code]

---

### Hungarian notation

> The original Hungarian notation, which would now be called Apps Hungarian, was invented by Charles Simonyi, a programmer who worked at Xerox PARC circa 1972–1981, and who later became Chief Architect at Microsoft.

> The notation is a reference to Simonyi's nation of origin

> 这种命名法的灵感，可能是受波兰表示法的启发。


#### Systems Hungarian notation

> In Systems Hungarian notation, **the prefix encodes the actual data type** of the variable. For example:

> - lAccountNum : variable is a long integer ("l");

> - arru8NumberList : variable is an array of unsigned 8-bit integers ("arru8");

> - szName : variable is a zero-terminated string ("sz"); this was one of Simonyi's original suggested prefixes.

#### Apps Hungarian notation

> Apps Hungarian notation strives to encode the logical data type rather than the physical data type; in this way, it gives a hint as to what the variable's purpose is, or what it represents.

> rwPosition : variable represents a row ("rw");

> strName : Variable represents a string ("str") containing the name, but does not specify how that string is implemented.


### Hungarian notation in delphi

因为工作的原因一直在用 `Delphi` 编码，以下是我对匈牙利命名法的一些看法：

- 一般情况下不使用 `系统匈牙利命名法` ，因为编译器做类型检查时就会指出来，更多的时候其实并不需要通过前缀来识别变量的类型(在IDE中可以通过代码跳转到定义及鼠标悬停在变量上都可以确定变量类型)

- 在同一个代码块中，出现包含相同内容但是不同类型的变量是可以考虑使用 `系统匈牙利命名法` 来识别，例如一个函数返回一个字符串类型的版本信息，即可以记作 `sVersion` ，但是在另一个函数中需要传入的版本参数却是一个整形，即可记作 `nVersion` 。

- 在使用全局变量的时候最好使用 `匈牙利应用命名法` 即在变量面前面加上 `g` 或者 `g_` ，因为全局变量会在多个单元里使用，加上前缀容易肉眼识别。

- 在使用特定类型的时候，可以使用 `匈牙利应用命名法` ，假设一个工程里面定义了一个枚举的状态类型，那里面的枚举常量可以加上前缀以示区别

```pascal 
type
  TWebStatus = (wstInit, wstStart, wstError, wstTimeOut, wstEnd);
  // w for Web, st for Status
```

- 在多个内嵌循环当中使用 `匈牙利应用命名法` 便于识别，减少错位

```pascal 
var
  ListBar  : TStringList;
  ListFoo  : TStringList;
  nListBar : Integer;
  nListFoo : Integer;
  n, m     : Integer;
begin
  for n := 0 to ListBar.Count - 1 do
  begin
    for m := 0 to ListFoo.Count - 1 do
    begin
      // do something with ListBar[n] and ListFoo[m]
    end;
  end;

  for nListBar := 0 to ListBar.Count - 1 do
  begin
    for nListFoo := 0 to ListFoo.Count - 1 do
    begin
      // do something with ListBar[nListBar] and ListFoo[nListFoo]
    end;
  end;
end;  
```

在上面的例子中，显然在两层循环嵌套中使用 `ListBar[nListBar]` 和 `istFoo[nListFoo]` 的识别度要高于 `ListBar[n]` 和 `ListFoo[m]` ， 而一旦不小心把 `n` 和 `m` 颠倒了，也是很难找bug的；如果嵌套的层数再高些，出错的几率还要高些。

### Reference

- [WIKI Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation)