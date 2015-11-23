---

layout: post
date: 14-09-11 13:47:37
title: md2resume on windows
tags: [markdown, code, ruby, resume, php]
categories: [code]

---

### Markdown Resume Generator

use git

```bash
git clone https://github.com/there4/markdown-resume.git
```
or download directly

[https://codeload.github.com/there4/markdown-resume/zip/master](https://codeload.github.com/there4/markdown-resume/zip/master) 
  
另外 `Windows` 上必须要有 `PHP` 环境，使用 `php md2resume` ， 即可监测是否有正常的环境。

这个时候使用以下命令就已经可以使用 `markdown -> html` 的功能了


```bash
php md2resume html sample.md outputpath
```

### Markdown to pdf

> PDF generation via wkhtmltopdf

要使用转换成 `PDF` 的功能还需要安装一些其他的东西。

#### Installing wkhtmltopdf

[下载](http://wkhtmltopdf.org/downloads.html)合适的 `wkhtmltopdf` 版本并安装

将 `wkhtmltopdf` 的安装路径写入到系统环境变量当中去

然后执行

```bash
php md2resume pdf sample.md outputpath
```

就可以在 `outputpath` 目录下生成 `sample.pdf` 文件

### Reference

- [Markdown Resume Generator](https://github.com/there4/markdown-resume)