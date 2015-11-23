---

layout: post
date: 2014-01-21 14:02
title: Sublime with Markdown
tags: [code, markdown, st3]
categories: [code]

---

![View]({{site.url}}/assets/blog_img/2014-01-17-sublime-text-with-markdown/preview_md.png) 

在接触Markdown之后，博客上的文章就完全是用Markdown格式写的了。之前的博客是用Wordpress搭建的，要想备份自己的文章是一件很麻烦的事情，备份后很多是用的图片都是不能用的，即使备份数据库，对于一般的用户简直就是噩梦。

后来花了半天的时间，就大概了解的Markdown的基本语法，在搭配上Sublime Text的一些Package和Snippet，写起东西来真的是很畅快。下面是我自己用的一些Package和Snippet。

Package
---

### Markdown Preview

[GitHub地址](https://github.com/revolunet/sublimetext-markdown-preview)

这个Package可以在浏览器里预览你当前写的Markdwon文章，当前的版本已经支持了GFM样式预览了。另外还提供复制Markdown成HTML的功能。

### Markdown Extended

[GitHub地址](https://github.com/jonschlinkert/sublime-markdown-extended)

`Markdown Extended` 可以使你在Markdown中的代码块显示高亮，而ST3默认的Markdown是无法高亮的。

可以看看官方的对比截图：

![Before]({{site.url}}/assets/blog_img/2014-01-17-sublime-text-with-markdown/markdown-ex-raw.png) 

<!-- more -->

![After]({{site.url}}/assets/blog_img/2014-01-17-sublime-text-with-markdown/markdown-ex-after.png) 

`Markdown Extended` 支持YAML Front Matter

![Before]({{site.url}}/assets/blog_img/2014-01-17-sublime-text-with-markdown/ymal_raw.png) 

<!-- more -->

![After]({{site.url}}/assets/blog_img/2014-01-17-sublime-text-with-markdown/ymal_after.png) 

### Monokai Extended

> Extends Monokai from Soda with new syntax highlighting for Markdown, LESS, and Handlebars and improved syntax highlighting for RegEx, HTML, LESS, CSS, JavaScript and more.


Snippet
---

我自己写了一些适用于Markdown的一些Snippets，放在了[GitHub](https://github.com/onion7878/sublime2-snippets/tree/master/MarkDown%20Snippet)上面。