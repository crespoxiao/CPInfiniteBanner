# CPInfiniteBanner

## 功能简介

简明扼要的描述功能

## 使用方法&Demo
### Demo Code
`通过demo code 展示此pod的主要功能，使用者阅读了demo code应该可以了解pod的大部分功能，API设计应尽量简洁易懂`

``` objective-c
//demo code here
```
## 安装

目前都使用cocoapods安装，在Podfile中加入

``` ruby
pod "CPInfiniteBanner" 
```

### 公开类、API说明

介绍主要类的功能职责，例如：

``` objective-c
AFNetworkReachabilityManager：监听网络状态变化

[[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

	NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));

}];

[[AFNetworkReachabilityManager sharedManager] startMonitoring];
```


### 注意事项(可选)




## 设计思路

## 主要类图（或模块图）（可选）

## 核心代码说明（可选）
解释核心代码  
遇到了哪些坑，如何解决的，或如何绕过的


## 已知问题（可选）
列出jira连接
如何填bug

## 维护者

xiaochengfei <xiaochengfei@didichuxing.com>

## 版权声明

CPInfiniteBanner 是滴滴内部项目，默认不对外开源。
