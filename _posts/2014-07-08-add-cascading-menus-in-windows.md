---

layout: post
title: Add Cascading Menus in windows
date: 14-07-08 14:01:15
tags: [code, windows, delphi, registry]
categories: [code]

---

## Use registry

eg : add `C:\foo.exe` and `C:\bar.exe` to all file right click cascading menus

the reg file should be like this

```
Windows Registry Editor Version 5.00
; add foo.exe to commandstore
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\foo]
; add description
@="Foo something"
; set icon if need
"icon"="C:\\foo.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\foo\command]
@=""C:\\foo.exe""

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\bar]
; add description
@="Bar something"
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\bar\command]
; bar.exe use param
@="C:\\bar.exe  \"%1\""


; start add to cascading menus
[HKEY_CLASSES_ROOT\*\shell\Kits]
"MUIVerb"="Kit"
"icon"="IconPath"
"SubCommands"="foo;bar"
```

## Remark

> Windows XP and Vista dont support cascading menus feature.

