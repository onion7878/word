---

layout: post
title: A Brief History of Delphi Strings [cn]
date: 14-11-12 22:22:13
tags: [code. delphi, theory, reference-counting]
categories: [code]

---

原文 [A Brief History of Delphi Strings](http://www.codexterity.com/delphistrings.htm)

## 深入理解 Delphi 中的字符串类型

对于很多Delphi开发者来说字符串类型多少有一些神秘，事实上即使每个新版本新添加的特性可能都没有解决这个问题。例如，很少的开发者知道 `string`, `ShortStrings`, `long strings`, `AnsiStrings`, `WideStrings`, `openstrings` 之间的区别。

### ShortString

我们从头说起，在 Delphi 的老祖宗 Turbo Pascal 时期，只有一种字符串：`ShortString` 类型，尽管现在我们也这样称它，但是在 Turbo Pascal 时期它是默认的字符串类型，直接被称作 `string`。`ShortString` 被分配在栈上（除非手动的分配），而不是堆上（[这里](http://www.codexterity.com/memmgr.htm#heapsidebar)可以看到更多关于堆的讨论），从内存分配的角度来看，`ShortString` 和其他静态分配的类型（`integers`, `booleans`, `records` and `enumerated types`）没有区别。从它被静态分配开始，显然不能被动态的改变大小。所以类似于插入（insertion），连接（concatenation）等操作会造成问题。为了避免它，Turbo Pascal (and Delphi)，预先给每一个字符串实例分配了256字节的内存，因为第一个元素（astring[0]）被用作存放它的实际长度，所以 `ShortString` 实际上有255个字节可以使用，255也是能够内索引到的最大的长度。例如变量被这样声明

```pascal
var s: shortstring;
```

这实际在栈上消耗了256个字节，`shortstring` 变量无论实际使用了多少长度在局部变量、全局变量，还是结构体中的变量都消耗256个字节。为了更好的理解 `shortstring` 的结构，现在我们展示一种语义上等价的 `shortstring` 类型，这能让你能在没有内建  `shortstring` 类型时知道如何去声明它。声明一个 `shortstring` 变量语义上等价于以下的代码：

```pascal
var s: array [0..255] of char;
```

`shortstring` 的操作：

```pascal
s := 'abc'; // 1
s := s + t; // 2
```

语义上等价于以下的代码：

```pascal
s[1] := 'a'; // 1 
s[2] := 'b'; // 1
s[3] := 'c'; // 1
s[0] := #3; // 1

Move( s[1], s[ord(s[0])+1], ord(t[0]) ); //2
s[0] := chr( ord(s[0]) + ord(t[0]) ); // 2
```

事实上你可以在以上的代码中使用 `s[0]` 并实验一下是 `shortstring` 在内存中的形态，*n* 代表在 `shortstring` 中实际存储的长度

![shortstring]({{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/shortstring_layout.gif)  

`shortstring` 默认的最长度是255，也不允许超过255个字符，而然这样的定义实际上有时是浪费了大量没有使用的空间，这个问题是可以被部分解决的。Turbo Pasca 和 Delphi 都允许字符串在声明的时候指定最大长度，例如：

```pascal
var s: string[20];  // maximum 20 characters
```

定义了长度为20的字符串，但实际还是保留一位用于存放长度，所以实际上21个字节被分配了。但是这样做会产生新的问题。因为强类型检查的缘故，Turbo Pascal 不允许不同长度的字符串参数被传到函数中：

```pascal
// 'strict var strings' turned on
type
	String20 = string[20];
	String30 = string[30];

procedure Foo( var aString: String20 );
	...
var s: String30;
Foo(s); // error: incompatible types
```

从技术上来讲是因为在Turbo Pascal 中把不同长度的字符串当作不同的参数来对待才造成这样的问题，字符串是分配在栈上的，而函数期望得到固定长度的字符串以在栈上分配合适的空间，所以不同长度的字符串就会造成这样的问题。为了解决这样的问题，`openstring` 被引入了，它是一种字符串的泛型可以接受任意长度的字符串：

```pascal
type
	String20 = string[20];
	String30 = string[30];

procedure Bar( var aString: openstring )

var s: String20;
    t: String30;

Bar(s); // OK
Bar(t); // OK
```

需要注意的是这只适用于变量参数（`variable (var) parameters.`），对于值参数（`value parameters`），字符串参数需要放在栈上，并且编译器为了hold住字符串参数始终分配最大长度的s字符串，另外还有 `"strict var strings"` 设置，当关闭时将不再对string类型检查。在Delphi中所以被指定最大长度的string都被认为是  `shortstring` ，当然最大的长度还是限制为255

```pascal
var s: string[256]; // error
```

### PChar

即使 `shortstring` 有很多优点，但是依旧不能突破最大长度（255）的限制，这在真实的软件开发环境中是很严重的问题，而对于 `Windows API` 友好的 C 语言，支持字符指针类型（`char *`），它允许任意长度的字符串，唯一限制它的是原生指针的寻址空间，当然也被实际的内存大小所限制。因为每次函数的调用都会遍历所有字符串的长度，开发者必须严格的管理字符串的内存分配和释放，这就会导致很多细小的错误和很多无用的操作。

Delphi 1 引入了 `PChar` 类型，等价于 C 语言中的字符指针，在16位的 Delphi 1 中因为16位的 Windows 操作系统内存管理的缘故，`PChar` 的长度被限制为65535个字符，和 C 语言一样 `PChar` 类型也需要显式的去分配和销毁内存（意外的是默认的字符串还是  `shortstring` ），同 `shortstring` 不同的是， `PChar` 实际上就是指针。很多开发者还是曲解了它，一个常见的错误是：

```pascal
var s: PChar;

s := 'Hello'; // danger: pointer to static data; no memory allocated
s := s + ' World'; // error: memory corrupted; may be undetected
```

在这个例子中，没有内存被分配，它仅仅是指向了常量字符串 `Hello` 的地址。需要牢记的是 `PChar` 不是可以任意替换默认的字符串类型的，不像 `ShortString` ， `PChar` 仅有4个字节（`(sizeof(PChar) = 4`)）的空间，而这里的字符串实际上是字符数组。

另外， `ShortString` 的索引起始于1（由于长度位占1个字节），而 `PChar` 是从0开始的，没有长度位，直接从 C 语言中借鉴而来的。通常使用 `StrAlloc/StrDispose` 或者 `GetMem/FreeMem` 方法为 `PChar` 分配内存，也可以通过字符数组来替换显式的分配内存：

```pascal
var 
  s: PChar;
  arr: array [0..20] of char; // space for 20 chars, plus null
s := @arr;
```

但是这样却会造成问题：

```pascal
// this function is FLAWED; do not use

function Combine( s1, s2: PChar ): PChar;
(* returns concatenated strings, leaves sources intact *)
var buf: array [0..1024] of char;
begin
     Result := @buf;
     StrCopy( Result, s1 );
     StrCat( Result, s2 );
end; // error: will return random stack data
```

错误依据当前函数栈上的内存范围，但这函数甚至可以正常的工作。一方面使用静态内存分配会造成危险，另一方面显示的分配内存开发者可能又会忘记销毁它。那些提供以空字符结尾的字符串的函数一定要用 `PChar` 类型，这些函数通常以 `Str` 开头（`StrCopy`, `StrCat`, `StrLen`），和 C-library 中的函数同名。

我们在用语义上相等的解释一下 `PChar` 相关的操作：

```pascal
var p: PChar; // 1
p := StrAlloc(4); // 2
StrCopy(p, 'abc'); // 3
StrCat(p, t); // 4
StrDispose(p); // 5
```

语义上等价于：

```pascal
var p: ^char; // 1

GetMem( p, 4 ) // 2

p^[0] := 'a'; // 3
p^[1] := 'b'; // 3
p^[2] := 'c'; // 3
p^[3] := #0; // 3

// somehow find index of first zero char from start of p, store in temporary variable _p
// somehow find index of first zero char from start of t, store in temporary variable _t
Move( p^[_p], t^[0], _t ); //4
p^[_p + _t] := #0; //4

FreeMem( p ); //5
```

我们知道 `PChar` 实际上就是指针，在 Delphi 中，我们可以简单的使用 `p[1]` 代替 `p^[1]` 。需要注意的是第4个步骤（`somehow find index of first zero char`），这个例子中的性能问题在于每次都要去调用 `StrLen()`，目前为止还没有一个简单的方法可以获取 `PChar` 的长度，必须从整个字符串中一步一步去寻找空字符，而它的索引值就是这个字符串的长度。

在内存中，`PChar` 是这样子的：

![Text]({{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/pchar_layout.gif) 

通常数组使用一些动态分配的函数（`StrAlloc`, `GetMem`）部分被分配在堆上，但是数据也会在栈上，事实上 Delphi ，可以这样使用数组：

```pascal
var
	arr: array [0..20] of char;
	p: PChar;
	p := arr;
```

没有使用地址操作和类型转换，在某些情况 Delphi 甚至允许用字符数组替换 `PChar`，就像C语言那样自由(emulating, no doubt, the syntactical permissiveness of C.)。


## Long String (AnsiString)

为了提供一个低维护性（low-maintenance），高效快速并且可以容纳多字符的字符串类型，32位的 Delphi 2 引入了 `long string`，通常也被称作 `AnsiString`，事实上，它只占用一个字节。并且也是被自动管理的，这意味着它很像 `ShortString` 但是不用显式的分配和释放内存。 `AnsiString` 因为 Win32 的缘故使用32位的值存放长度，并且允许增长到 2G 长，当然也被实际物理内存所限制。然而 `AnsiString` 的优点并不止这些，和C语言一样，它也是以非零结尾的，这意味这 Delphi 为自动的在最后添加一个零位（实际上是两个），和Java中的类一样，每一个 `AnsiString` 除了长度位，还包含一个引入计数位。这需要 Delphi 内部去管理它，当它不需要时自动释放它。这样 `AnsiString` 就两全其美了， `ShortString` 的效率和 `PChar` 动态的空间大小，却没有 `PChar` 的缺点。和 `ShortString` 一样 `AnsiString` 索引起始于1。当对它进行复制，修改或者函数返回时不用担心发生错误和内存泄露：

```pascal
var s: AnsiString;
	...
s := 'Hello';
s := s + 'World'; // OK, memory automatically managed.
```

当前版本的 Delphi 字符串类型就是 `AnsiString` ，尽管可以被编译开关改变，事实上在未来默认的字符串很有可能变成 `WideString` 

在内存中 `AnsiString` 是这样的：

![AnsiString]({{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/ansistring_layout.gif)  

`AnsiString` 变量在内存中实际上是指向第一个字符的指针，需要特别强调的是，指向的是第一个**字符**，而不是第一个元素。这看起来或许有些奇怪，但在运行时定位 `AnsiString` 时不会造成问题（仅仅是使用负差值（negative offsets）退回到第一元素）。空字符串实际上就是空指针：

![Text]({{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/ansistring_nil.gif) 

这就是为什么访问空字符串是会造成非法访问（access violation）；因为是以空值结尾（null-terminated）的，所以 `PChar` 非常的高效，Delphi可以仅仅传递变量本身代替 `PChar`（尽管Delphi会多做一些检查工作）。

为了更好的理解，我们还是用语义上相等的方法来展示：

```pascal
var s: AnsiString;
```

语义上等价于：

```pascal
type
  TAnsiStrRec = packed record
      RefCount: longint;
      Length: longint;
  end;
  
  TAnsiStrChars = array [1..MaxInt-8] of char;
  TAnsiString = ^TAnsiStrChars;

var s: TAnsiString;
```

一下的操作：


```pascal
s := ''; // 1
s := 'abc'; // 2
s := s + t; // 3
```

语义上等价于：

```pascal
s := nil; // 1

GetMem( s, sizeof(TAnsiStrHeader) + 4 ); // 2
PAnsiStrHeader(integer(s)-8)^.RefCount := 1; // 2
PAnsiStrHeader(integer(s)-8)^.Length := 3; // 2
s[1] := 'a'; // 2
s[2] := 'b'; // 2
s[3] := 'c'; // 2
s[4] := #0; // 2

// allocate
GetMem( t,
	sizeof(TAnsiStrHeader) +
	PAnsiStrHeader(integer(u)-8)^.Length +
	PAnsiStrHeader(integer(v)-8)^.Length + 1 ); // 3 

// copy
Move( u^, t^[1], PAnsiStrHeader(integer(u)-8)^.Length ); // 3
Move( v^,
     t^[PAnsiStrHeader(integer(u)-8)^.Length + 1],
     PAnsiStrHeader(integer(v)-8)^.Length ); // 3

// header
PAnsiStrHeader(integer(t)-8)^.RefCount := 1; // 3
PAnsiStrHeader(integer(u)-8)^.Length :=
       PAnsiStrHeader(integer(u)-8)^.Length +
       PAnsiStrHeader(integer(v)-8)^.Length; // 3	
```

事实上Delphi运行时会在底层做类似上面的事情，可以在 `System.pas` 找到相关代码，在上面的例子中，为了保持简单我们选择那些需要操作引用计数的实例。引用计数对于 `AnsiString` 类型是区别于之前的字符串类型是非常重要的特性。关于引用计数（reference-counting）和写时拷贝（copy-on-write）我们之后再讨论。

### WideString

`WideString` 上最新条件到Delphi字符串家族的，它是为了适用多平台 `Unicode` 而被创造的，也是唯一支持 `Unicode` 的类型。`Windows 2000`, `Windows XP`, `Java` and the new `.NET` 架构都被重写来支持 `Unicode` 。最新的 `Windows API` 内部实际上也转换 `ANSI` 字符串成 `Unicode` 字符串。有理由相信在未来 `WideString` 会代替其他字符串类型。

![WideString]({{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/widestring_layout.gif)

`WideString` 就是 `AnsiString`，自动内存管理，引用计数。唯一的区别是 `WideString` 中的每一个字符是 `WideChar`，新的字符类型支持 `Unicode` 。`WideString` 也支持 `OLE type`。 `Unicode` 是一个原因，你为什么不应该在你的代码中假设 `sizeof(char)=1`，在做大小运算时应该一直使用 `sizeof()` 操作。当 Delphi 中 `sizeof(char)=2` 时你的代码可以自动适用。

### 赋值语句

这些字符串类型有核心的不同点：它们的赋值语法。弄清楚这些不同的地方对使用它们来说至关重要。赋值语句处理了隐藏在底层的赋值建构细节。这个话题很少被开发者们思考，由于缺乏理解经常会变的没有效率而且漏洞百出。我们从 `ShortString` 开始，之前提到过 `ShortString` 是静态分配的，所以赋值语法同 `integers`, `booleans` and `records` 一致。 `ShortString` 始终从另一个字符串中拷贝完整内容：

```pascal
var s, t: ShortString;

s := 'Foo';
t := s;     // entire contents copied
s[1] := 'B' // t still contains 'Foo'
```

对于 `PChar` 来说则是指向字符数组的指针（通常是动态分配的），赋值语句和其他指针一样，赋值只是复制了指针而不是字符数组，直接赋值后两个指针都指向同一个数组：

```pascal
var s, t: PChar;

s := 'Foo';
t := s;        // pointer copied
s[0] := 'B';   // both contain 'Boo'
```

通常情况下，我们实际上想要的是字符串的内容，而不是上面代码所展示的。这是我们需要用到 `Str` 开头的那些函数。例如可以使用 `StrCopy` 来复制 `PChar` 中的内容：

```pascal
var s, t: array [0..50] of char;

StrCopy( s, 'Foo' );
StrCopy( t, s );  // contents copied
s[0] := 'B';      // t still contains 'Foo'
```

`PChar` 相对于 `ShortString` 的一个优点是，当一个字符串是严格只读的时候，指针的拷贝可以用来提升性能，因为每一个字符串只用拷贝4个字节。坏处是开发者必须记得哪些字符串是只读的，并且一直保持这样的形式。

```pascal
var s, t: AnsiString;

s := 'Foo';
t := s;  // only pointers copied; reference count incremented
```

通常需要注意的是，除了拷贝缓冲（buffer）地址，`AnsiString` 还会自增引用计数，这个计数记录着当前的 `AnsiString` 有多少客户（clients），当其中一个需要修改是，拷贝操作随之而完成，当然还会减少一次引用计数，最终被应用到新的缓冲区（buffer）中  


```pascal
var s, t: AnsiString;

s := 'Foo';
t := s;      // only pointers copied; reference count incremented
s[1] := 'B'; // buffer refcount > 1: copy made, original string's refcount decremented
```

下图简单的描述了 `long string` 的引用计数是这么工作的：

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;margin: 0 auto;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
</style>
<table class="tg">
  <tr>
    <th class="tg-031e">s := 'Foo';<br>New string buffer allocated.<br>Reference Count set to 1.<br>Length set to 3.<br>Variable s pointed to address of buffer.</th>
    <th class="tg-031e"><img src="{{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/asem1.gif"></th>
  </tr>
  <tr>
    <td class="tg-031e">t := s;<br>Variable s copied to t (pointer copy).<br>Buffer Reference Count incremented.</td>
    <td class="tg-031e"><img src="{{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/asem2.gif"></td>
  </tr>
  <tr>
    <td class="tg-031e">s[1] := 'B';<br>Is Reference Count &gt; 1?<br>Yes, new string buffer allocated.<br>New buffer's reference count set to 1.<br>Old buffer Reference Count decremented.<br>Variable t pointed to new buffer.<br>Edit performed on new buffer.</td>
    <td class="tg-031e"><img src="{{site.url}}/assets/blog_img/2014-11-10-a-brief-history-of-delphi-strings/asem3.gif"></td>
  </tr>
</table>

这就是所谓的引用计数及写时拷贝，从这里开始 `long string` 吸取了 `ShortString` （方便，不用手动分配，直接拷贝）和 `PChar` （快速拷贝，高效，非指定大小）共同的优点。

> *C treats you like a consenting adult. Pascal treats you like a naughty child. Ada treats you like a criminal.*

<i style="display: inline-block; width: 100%; text-align: right;">--Bruce Powel Douglass</i>