---

layout: post
title: Create .gitignore file on windows
date: 2014-02-19 17:47:38
tags: [code, git]
categories: [code]

---

> If you're using Windows it will not let you create a file without a filename in Windows Explorer. It will give you the error "You must type a file name" if you try to rename a text file as .gitignore

> To get around this I used the following steps

```
 - Create the text file gitignore.txt
 - Open it in a text editor and add your rules, then save and close
 - Hold SHIFT, right click the folder you're in, then select Open command window here
 - Then rename the file in the command line, with ren gitignore.txt .gitignore
```

### Reference

- [How to create .gitignore file](http://stackoverflow.com/a/12298593/724897)