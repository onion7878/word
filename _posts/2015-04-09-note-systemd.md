---

layout: post
title: "NOTE : systemd"
date: 15-04-09 22:12:01
tags: [linux, system, deamon, note]
categories: [code]

---

## Spelling

> Yes, it is written systemd, not system D or System D, or even SystemD. And it isn't system d either. Why? Because it's a system daemon, and under Unix/Linux those are in lower case, and get suffixed with a lower case d. And since systemd manages the system, it's called systemd. It's that simple. But then again, if all that appears too simple to you, call it (but never spell it!) System Five Hundred since D is the roman numeral for 500 (this also clarifies the relation to System V, right?). The only situation where we find it OK to use an uppercase letter in the name (but don't like it either) is if you start a sentence with systemd. On high holidays you may also spell it sÿstëmd. But then again, Système D is not an acceptable spelling and something completely different (though kinda fitting).

<!-- more -->

## Basic systemctl usage

> systemadm is the official graphical frontend for systemctl. It is provided by systemd-ui from the official repositories or by systemd-ui-git from the AUR for the development version.

systemd-ui 无法使用 ： 估计是没有安装 X 或者其他的桌面环境

```bash
# List running units
systemctl
# List failed units
systemctl --failed
#list of the installed unit files
systemctl list-unit-files
```

> The available unit files can be seen in `/usr/lib/systemd/system/` and `/etc/systemd/system/` (the latter takes precedence)

> Some unit names contain an `@` sign (e.g. `name@string.service`): this means that they are instances of a template unit, whose actual file name does not contain the `string` part (e.g. `name@.service`). `string` is called the instance identifier, and is similar to an argument that is passed to the template unit when called with the systemctl command: in the unit file it will substitute the `%i` specifier.

```bash
# start a unit immediately
systemctl start unit
# stop a unit immediately
systemctl stop unit
# restart a unit:
systemctl restart unit
# ask a unit to reload its configuration
systemctl reload unit
# show the status of a unit, including whether it is running or not
systemctl status unit
# check whether a unit is already enabled or not
systemctl is-enabled unit
# enable a unit to be started on bootup
systemctl enable unit
# disable a unit to not start during bootup
systemctl disable unit
# mask a unit to make it impossible to start it
systemctl mask unit
# unmask a unit:
systemctl unmask unit
# reload systemd, scanning for new or changed units
systemctl daemon-reload
```

## Reference

- [systemd System and Service Manager](http://freedesktop.org/wiki/Software/systemd/)
- [systemd - ArchWiki](https://wiki.archlinux.org/index.php/Systemd)