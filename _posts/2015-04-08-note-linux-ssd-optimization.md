---

layout: post
title: "NOTE : Linux SSD Optimization"
date: 15-04-08 15:32:06
tags: [linux, ssd, optimization, note]
categories: [code]

---

```bash
# 是否支持 TRIM
hdparm -I /dev/sda | grep TRIM

# 修改 /etc/fstab Flag (discard, noatime) 
# e.g.
/dev/sda1  /       ext4   defaults,noatime,discard   0  1
/dev/sda2  /home   ext4   defaults,noatime,discard   0  2
```

<!-- more -->   

### discard

在操作系统中，当删除一个文件时，并没有删除物理硬盘上的实际数据，而仅仅是在文件系统中标记该数据块为删除、可写入，下次再有数据写入的时候直接覆盖之前的数据块就行了。

在传统硬盘中，写入空数据块和覆盖数据块的操作是完全相同，但是在 SSD 中只有空数据块才能执行写入操作，对于非空数据块，需要先执行擦除操作之后才能进行写入。

> 乍看之下，SSD和传统硬盘的区别仅仅是多了一步擦除操作而已，但实际上并非如此，更要命的还在后头。在SSD中，数据存储的最小单位是页面（page），一个页面的大小一般是4KB，若干个页面又被组合成块（block），一个块的大小一般是512KB。由于硬件方面的限制，SSD单独对某个页面进行读/写的操作，但擦除操作却只能对整个块进行，也就是说，一旦擦除就必须一次性擦除整个块。想想看，如果操作系统要让SSD改写某个页面的数据，SSD需要执行怎样的操作呢：

> 将要改写的目标页面所在的整个块的数据读取到缓存。
在缓存中修改目标页面的数据。
对整个块执行擦除操作。
将缓存中的数据重新写入整个块中。
这就意味着，如果我要修改某个4KB大小的页面，就必须把512KB大小的整个块都折腾一遍，大家应该可以想象出这将带来何等巨大的性能和寿命上的损失。

> 正是出于上述原因，SSD中提供了一个TRIM命令，操作系统在删除文件时可以通过向SSD发送TRIM命令告诉它哪些数据块中的数据已经不再使用了。SSD在收到TRIM命令后，通常会在定期的垃圾收集操作中重新组织这些区块，为将来写入数据做好准备，不过每一款SSD在底层对TRIM命令的执行机制都不尽相同，但无论如何，通过TRIM能够显著改善SSD的性能和寿命。当然，大家可能已经发现了，有了TRIM，删除的文件数据会被SSD自动回收，这意味着以往在传统硬盘上能够使用的一些数据恢复（反删除）软件，在SSD上可能就不再管用了。

而 `discard` Flag 即是开启 TRIM 功能 

### noatime

> The `atime` option updates the `atime` of the files every time they are accessed. This is more purposeful when Linux is used for servers; it does not have much value for desktop use. The drawback about the `atime` option is that even reading a file from the page cache (reading from memory instead of the drive) will still result in a write!

`atime` 在每次打开文件时候都回去更新，且这对大多数普通用户是没有用的，而大量的写入操作会减少 SSD 使用寿命，所以如果没有特殊的需求还是建议使用 `noatime` 关掉这个功能。

### Reference

- [Solid State Drives - ArchWiki](https://wiki.archlinux.org/index.php/Solid_State_Drives)
- [fstab - ArchWiki](https://wiki.archlinux.org/index.php/Fstab#atime_options)
- [固态硬盘（SSD）为什么需要TRIM？](http://www.solaluna.cn/2013/10/06/1686/)