SRouter2
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/angelcs1990/SRouter/master/LICENSE)&nbsp;
[![](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](http://cocoapods.org/?q=SRouter)&nbsp;
[![support](https://img.shields.io/badge/support-iOS6.0%2B-blue.svg)](https://www.apple.com/nl/ios/)&nbsp;

#安装
##CocoaPods
暂不支持

#介绍
SRouter2是SRouter的升级加强版
#用法
主要用到的是SR2Config，SR2Manager两个类  
SR2Config是常用的配置文件  
SR2Manager是具体的接口调用（在使用前记得先调用router_InitWithHandler方法初始化）  

SR2Default.plist为默认文件，记录各个模块的plist  
模块.plist 记录模块信息，详情见demo（<font color=#ff0000>注：plist的文件非必要，如果是远程调用就一定需要</font>）

####更详细的见项目中的demo 

#许可证
使用MIT许可证，详情见LICENSE文件
