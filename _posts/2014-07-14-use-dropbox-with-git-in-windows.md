---

layout: post
title: Use dropbox with Git in windows
date: 14-07-14 17:51:32
tags: [git, dropbox, sync, windows]
categories: [code]

---

### Use command line

![Git]({{site.url}}/assets/blog_img/2014-07-14-use-dropbox-with-git-in-windows/gitdropbox.png) 

#### Add bare repository in dropbox folder

Open command line in dropbox project folder (eg: `E:\Dropbox\git` )

```bash
Run 'git help git' to display the help index.
Run 'git help <command>' to display help for specific commands.
Administrator@PC-CHENHANLIN /E/Dropbox/git
$ git --bare init
Initialized empty Git repository in e:/Dropbox/git/
```

#### add remote in your project

assume project in `E:\DeskTop\project`

```bash
Administrator@PC-CHENHANLIN /E/DeskTop/project (master)
$ git remote add origin E:\\Dropbox\\git
Administrator@PC-CHENHANLIN /E/DeskTop/project (master)
$ git remote
origin
```

### Remark

Clone to local

```bash
git clone E:\\Dropbox\\git
```

> This approach is only suitable for a small team (two in my case) where people can just shout over their cubicle walls: "Hey! Nobody push! I'm pushing now!"

>  –  [Ates Goral](https://stackoverflow.com/questions/1960799/using-git-and-dropbox-together-effectively#comment3906000_1961515)


### Reference

[Using Git and Dropbox together effectively?][^0]

[^0]: https://stackoverflow.com/questions/1960799/using-git-and-dropbox-together-effectively