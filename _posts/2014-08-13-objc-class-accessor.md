---

layout: post
title: Objective-C class accessor
date: 14-08-13 23:51:53
tags: [iOS, Dev]
categories: [code]

---

iOS 中类的成员变量，可以通过手动的编写 `getter` 和 `setter` 来实现外部访问，也可以通过指定 `@property` 使编译器自动的生成，使用 `(.) dot` 操作符来访问。

### Setter & Getter


```objc
//---- @interface section ----
@interface TItem : NSObject
{
    int _n;
}
- (void)setN:(int)i;
- (int)N;

//---- @implementation section ----
- (void)setN:(int)i
{
    _n = i;
}
- (int)N
{
    return _n;
}

//---- program section ----

TItem *item = [[TItem alloc] init];
item.n = 1024; // use setter
NSLog(@"%i", item.N); // use getter
```
代码中的 `item.N`看起来好像是直接访问了成员变量 `_n` 其实还是调用了函数 `- (int)N`，如果把改函数改个名字 `- (int)showMeTheN;` 那么使用 `NSLog(@"%i", item.showMeTheN);` 也可以访问。函数是可以使用 `dot` 操作符去调用的只是不建议这样做。

> Based on the preceding discussion, realize that although it’s syntactically correct to write a statement such as myFraction.print, it’s not considered good programming style. The dot operator was really intended to be used with properties; typically to set/get the value of an instance variable. Methods that do other work are typically not executed using the dot operator; the traditional bracketed message expression is the preferred syntax.

### Synthesized Accessor Methods


```objc
//---- @interface section ----
@interface TItem : NSObject
{
    int _n;
}
@property NSString *str;

//---- @implementation section ----
@synthesize str;

//---- program section ----

TItem *item = [[TItem alloc] init];
item.str = @"test"; 
NSLog(@"%@", item.str);
```

> If you omit the @synthesize directive, then the compiler will automatically name the underlying instance variables _numerator and _denominator, respectively. In that case implementation section would have to be modified to run correctly.

