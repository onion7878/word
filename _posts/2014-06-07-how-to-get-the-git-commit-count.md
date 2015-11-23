---

layout: post
title: Get the git commit count
date: 14-06-07 18:14:21
tags: [code, git]
categories: [code]

---

#### Solutions #1

```bash
git rev-list HEAD --count
```
#### Solutions #2

```bash
git shortlog -s
```

if you want to get commits number for every contributor.

```bash
git shortlog | grep -E '^[ ]+\w+' | wc -l
```
more way in reference

### Reference

- [How to get the git commit count?](https://stackoverflow.com/questions/677436/how-to-get-the-git-commit-count)

