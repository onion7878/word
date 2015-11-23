---

layout: post
title: "NOTE : pacman"
date: 15-04-09 22:11:21
tags: [linux, arch, pacman, note]
categories: [code]

---

## Configuration

```
/etc/pacman.conf
```

## Usage

```bash
# install a single package or list of packages (including dependencies
pacman -S package_name1 package_name2 ...
# install specified package 
pacman -S extra/package_name
# installing package groups
pacman -S gnome
# remove a single package, leaving all of its dependencies installed
pacman -R package_name
# remove a package and its dependencies which are not required by any other installed package
pacman -Rs package_name
# synchronize the repository databases and update the system's packages
pacman -Syu
# search for packages in the database
pacman -Ss string1 string2 ...
# search for already installed packages:
pacman -Qs string1 string2 ...
```

## Cleaning the package cache

> pacman stores its downloaded packages in /var/cache/pacman/pkg/ and does not remove the old or uninstalled versions automatically, therefore it is necessary to deliberately clean up that folder periodically to prevent such folder to grow indefinitely in size.

```bash
# remove all the cached packages that are not currently installed
pacman -Sc
```

> It is also possible to completely empty the cache folder with `pacman -Scc`, but doing it is considered bad practice, as, in addition to the above, it also prevents from reinstalling a package directly from the cache folder in case of need, thus forcing to redownload it. You should never use it unless there is a desperate need for more disk space.

使用 `pacman -Sc` 或 `pacman -Scc` 命令会删除安装的包，但这不利于回滚及降级，如果删除过后只有通过 [Arch Rollback Machine](https://wiki.archlinux.org/index.php/Arch_Rollback_Machine) 来实现降级，所以官方不推荐使用以上两个清理命令，推荐使用 `paccache` 来清理缓存文件。

```bash
# deletes all the cached versions of each package except for the most recent 3
paccache -r
# removing all the cached versions of uninstalled packages
paccache -ruk0	
```

## Other

> Take care when using the `--force` switch (for example `pacman -Syu --force`) as it can cause major problems if used improperly. It is highly recommended to only use this option when the Arch news instructs the user to do so.

## Reference

- [pacman - ArchWiki](https://wiki.archlinux.org/index.php/Pacman)
