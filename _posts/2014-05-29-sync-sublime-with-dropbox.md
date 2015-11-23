---

layout: post
date: 14-05-29 16:02:10
title: Sync Sublime Text with Dropbox
tags: [st3, dropbox, sync, code]
categories: [code]

---

### Package Control Sync

> To properly sync your installed packages across different machines, you actually do not want to sync the whole Packages/ and Installed Packages/ folders. The reason for this is that some packages have different versions for different operating systems. By syncing the actual package contents across operating systems, you will possibly run into broken packages.

<!-- more -->

> The proper solution is to sync only the Packages/User/ folder. This folder contains the Package Control.sublime-settings file, which includes a list of all installed packages. If this file is copied to another machine, the next time Sublime Text is started, Package Control will install the correct version of any missing packages.

只用同步 `Packages/User/` 文件夹，`Sublime Text` 会根据文件 `Package Control.sublime-settings` 自动的同步下载最新的插件

#### Windows

在Windows中使用命令

`mklink /D "../Packages/User/" "E:\Dropbox\Data\Sync\Sublime\User"` 

来是两个文件夹建立关联，从而通过 `Dropbox` 达到同步的目的

#### OS X

```bash
cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/
ln -s ~/Dropbox/Sublime/User
```

`~/Dropbox/Sublime/User` 为你在 `Dropbox` 中的文件路径

### Package Syncing

这是一个用于同步Package的Package，具体内容 [Package Syncing](https://sublime.wbond.net/packages/Package%20Syncing)

原理应该和上面的一样，但是它会选择性的同步，比如我自己写了个 `python` 脚本也需要同步，这个包目前还没发做到。


### Git

我自己在 `~/Dropbox/Sublime/User` 里面建立了Git来控制那些文件改变了，改变了些什么，算是一个备份和加强控制。

以下是 `Package Control` 给出可以 Ignore 的文件

 - Package Control.last-run
 - Package Control.ca-list
 - Package Control.ca-bundle
 - Package Control.system-ca-bundle
 - Package Control.cache/
 - Package Control.ca-certs/

### Reference

- [Package Control Sync](https://sublime.wbond.net/docs/syncing)