---

layout: post
date: 2014-01-16 16:48
title: Setup Sublime Text 3	
tags: [code, st3]
categories: [code]

---

### Windows下设置默认打开方式

删除 `HKEY_CURRENT_USER\Software\Classes\Applications` 下的 `Sublime_Text.exe` 项

### Windows下右键关联及图标

![Text]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/context-menu-2.png)  

右键关联 : 添加 `HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text\command` 值为 `..\Sublime Text 3\sublime_text.exe %1`

![Text]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/context-menu-1.png)

图标 : 在新建字符串值命名为 `Icon`，值为 `..\Sublime Text 3\sublime_text.exe,0`


### 中文乱码问题

![test_cn]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/cn_test.png)  

#### 安装 Package Control

Press `Ctrl + ~` to open the command line, and then enter the following line of code

  ```
  import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())
  ```

#### 安装 ConvertToUTF8 

![Install_pk]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/Install_pk.png)  

Press `Ctrl + Shift + P` (Windows) to open the universal search box, then enter the install package return, this time will load a list of all packges. 

![ConvertToUTF8]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/ConvertToUTF8.png)  

See the list after re-enter ConvertToUTF8 Enter, it will download and install this package.

再次打开之前的文件会显示提示，选择即可。

![select_cn]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/select_cn.png)  


### IME不跟随问题

![IME]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/ime.png)

使用Package Control安装IMESupport

![IMESupport]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/IMESupport.png)

使用后输入法就可以正常的跟随了。

在 `%APPDATE%Sublime Text 3\Packages\IMESupport\IMESupport.sublime-settings` 文件中可以修改对应的一些参数。


### 修改显示字体

Press `Ctrl + Shift + P` (Windows) to open the universal search box, 

![User]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/user.png)

输入 `user` 选中 `Preference: Setting - User` 

根据官方的文档直接写入配置文件然后保存就可以立即生效了。以下是我的配置文件

```
	"font_face": "YaHei Consolas Hybrid",
	"font_size": 10,
	"ignored_packages":
	[
		"Vintage"
	]
```

配置前后的效果，Windows平台下分辨率不是很高的，还是非村线字体看起舒服一点

![font_raw]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/font_raw.png)

<!-- more -->

![font_set]({{site.url}}/assets/blog_img/2014-01-16-sublime-text-3/font_set.png)

### Reference

- [Sublime Text 2/3 GBK Encoding Support and Input Chinese with ibus on Ubuntu][ref_st_cn]
- [Windows 平台下 Sublime Text 2/3 支持中文输入法候选词窗口跟随][ref_ime]
- [Font Settings][ref_font]

[ref_ime]: http://radarnyan.moe9th.com/index.php/2013/02/windows-%E5%B9%B3%E5%8F%B0%E4%B8%8B-sublime-text-2-%E6%94%AF%E6%8C%81%E4%B8%AD%E6%96%87%E8%BE%93%E5%85%A5%E6%B3%95%E5%80%99%E9%80%89%E8%AF%8D%E7%AA%97%E5%8F%A3%E8%B7%9F%E9%9A%8F/
[ref_st_cn]: http://www.mrxuri.com/2013/04/28/sublime-text-gbk-support-and-input-chinese-with-ibus-on-ubuntu.html
[ref_font]: http://www.sublimetext.com/docs/2/font.html