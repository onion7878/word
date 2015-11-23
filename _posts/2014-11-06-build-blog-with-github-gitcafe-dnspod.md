---

layout: post
date: 14-11-06 22:44:39
title: Build blog with GitHub, GitCafe, DNSPod
tags: [blog, jekyll, gitcafe, github, dropbox, dnspod]
categories: [code]

---

![git]({{site.url}}/assets/blog_img/2014-11-06-build-blog-with-github-gitcafe-dnspod/GitHubTutorial-Part1_0.jpg) 

上个月的时候在 [IT公论](http://ipn.li/itgonglun/) 上听到的， [Hover](https://www.hover.com/) 上可以注册 `.li` 的域名，想到合适的话可以给泓子注册一个，上去看还真有特别合适的 [hongzi.li](http://hongzi.li/)，看着价钱也不是特别贵（15刀一年）就买了。

域名买了也准备利用起来，但是实在不想去碰之前的 `WordPress` 和虚拟主机了，更何况现在也不怎么熟悉，还是想用静态的。但是又不可能把 `Git` `Ruby` `Jekyll` `Github` `Markdown` 这些都丢给泓子，实在太麻烦了。还好之前知道 [Farbox](https://www.farbox.com/) 这个服务，之前我自己也用过，但是因为自由度太小就没有用了，现在的Farbox已经没有免费版的了，可以试用但是试用期过了就必须象征性的收取费用（5年期Basic对应为￥30），而且Farbox不强制使用 `Markdown` ，用纯文字就可以写，需要插入图片拖放就成。对普通人来说也能很快的上手，甚至比 `WordPress` 后台通过文本编辑器简单上手。

在搭建中发现网页加载的速度好快啊，甚至图片都是瞬间刷出来，突然就想到自己博客，因为图片是放在 `Dropbox` 上的，而 `DropBox` 国内已经被墙了（我最开始使用 Jekyll + Githug + Dropbox 搭建的时候还没有被墙），所以想改善一下，一起认为反正也没有多少人看，到后来每次需要给人去解释需要翻墙才能看到图片也很烦。

后来在 `Jekyll` 的[文档](http://jekyllrb.com/docs/posts/)里面看到可以这样使用图片


```
… which is shown in the screenshot below:
![My helpful screenshot]({{ site.url }}/assets/screenshot.jpg)
```

随后就把图片都放到博客本身里了，又看到国内的 `GitCafe` 也支持 `Jekyll` 就放了一份拷贝在 `GitCafe` 上，这样速度就非常快了，而且正好 `DNSPod` 的免费服务支持解析通个域名解析到多个（两个）ip上，不知道是不是在某种程度上实现了 `CDN` 的效果，总之效果还不错。

但是接下来遇到一个问题就是有些图片太大了（最大的图片超多2M），这样也会导致网页加载很慢，以前博客的配图选择都是越大越好，现在反而开始追求加载速度了。就想着用过一些方法把图片在尺寸和大小上都通过程序处理一遍。但这件事情还没有做，准备把 `Go` 语言学习了，在去实现，也算是一个练手的方式。

回头一想，这些东西真折腾起来还真的没有一个尽头，不过在折腾过程中也算是都少了解、学到点东西吧。

就酱。
