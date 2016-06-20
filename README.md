#
singleNet(之前由于字符编码导致pin3错误已经修复)
----


## 须知
ok , maybe you are looking for it now .unfortunately, it may not work for you.
- 你需要根据你的路由器更改一下这个脚本.
- 这是一个试验项目,验证我可以写出这个东西,实际应用场景可能也就只有我自己在使用
- 目前有了粗糙的图形界面
- 如果你需要任何帮助,我很乐意和你讨论
- 拒绝未经许可,将其用于商业行为
- 没有任何担保
- 有任何问题,欢迎提issue

## 运行环境

- linux Mac Windows :请百度或google,`Drracket`,下载相应平台的`Drracket`安装包

## 现有功能
- 计算出账号
- 将账号密码交给路由器
- 可以有GUI了
- 可以用于不同的路由器,不用再自己去改包头了

## 如果你想要使用它
- 你至少可以看懂一点源代码
- 如果你全都做好了,那么理论上就可以成功的拨号了

## ToDo

- 心跳功能(你可以用mac先登录闪讯15分钟以上,就可以不用心跳包了(据说虚拟机也可以),或者伪装成mac的闪讯客户端)
- 亲测高贵的mac用户是心跳的终极杀手

## 原理
------
可以参考github上其他的有关闪讯拨号的源代码,原理推荐openwrt实现的闪讯的拨号模块,代码可以参考python版本的和powershell版本的实现
------

# MIT
Copyright © 2016 richard

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


