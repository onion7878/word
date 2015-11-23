---

layout: post
date: 2014-01-16 20:47
title: How pygments support long code
tags: [code, jekyll, css, pygments]
categories: [code]

---

![before]({{site.url}}/assets/blog_img/2014-01-16-jekyll-pygments-support-code-too-long/highlight_raw.png)

最近在用Markdown写文章的时候遇到写代码块的时候遇到当代码过长显示不完成的情况

后来在SOF找到答案，一句CSS就可以解决问题

```css
pre { white-space: pre; overflow: auto; }
```

![after]({{site.url}}/assets/blog_img/2014-01-16-jekyll-pygments-support-code-too-long/highlight_css.png)

### Reference

- [How to support scrolling when using pygments with Jekyll][ref_sof]

[ref_sof]: http://stackoverflow.com/questions/11093233/how-to-support-scrolling-when-using-pygments-with-jekyll