---

layout: post
title: "NOTE : change login shell"
date: 15-04-09 23:41:20
tags: [linux, note, shell]
categories: [code]

---

```bash
chsh -s $(which zsh)
```

<!-- more -->

## More

在 Arch 上安装 `zsh` 后，使用 `chsh -l` 或者 `cat /etc/shells` 可以看到其实有两个 `zsh`

```bash
/bin/sh
/bin/bash
/bin/zsh
/usr/bin/zsh
```

通过看到 `inode` 可以发现其实这两个 `zsh` 是通过 [hard link](http://en.wikipedia.org/wiki/Hard_link) 直线同一个文件的

```bash
stat -c %i /bin/zsh
stat -c %i /usr/bin/zsh
```

所以可以通过 `which zsh` 来查看当前用户 `$PATH` 变量下使用的是哪个 `zsh`

另外使用 `chsh -s $(which zsh)` 后需要重新登录后才生效，再次登录后可以使用 `echo $SHELL` 查看当前使用的 **Shell**


## Reference

- [How do I change my default shell from bash to zsh?](http://superuser.com/questions/231735/how-do-i-change-my-default-shell-from-bash-to-zsh)
- [zsh is in /usr/bin, but also in /bin, what is the difference?](http://unix.stackexchange.com/questions/71236/zsh-is-in-usr-bin-but-also-in-bin-what-is-the-difference)
- [which (Unix)](http://en.wikipedia.org/wiki/Which_(Unix))