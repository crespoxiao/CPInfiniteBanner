# CPInfiniteBanner

## 功能简介

CPInfiniteBanner是一个循环播放的组件，可以左右无缝滑动和自动切换图片。

## 使用方法

```  
    CPInfiniteBannerView *banner = [[CPInfiniteBannerView alloc]initWithContainerView:self.view responseBlock:nil];
    banner.frame = CGRectMake(20, 30, self.view.frame.size.width-40, 90);
    banner.placeHolder = [UIImage imageNamed:@"3.jpg"];
    banner.duration = 3.0;
    banner.imageArray = [NSMutableArray arrayWithArray:array];
```
## 安装

目前都使用cocoapods安装，在Podfile中加入

``` 
pod "CPInfiniteBanner" 
```


## 设计思路
3个imageView放在scrollview上，左右2个imageview用于过渡，借助scrollview的deleagte来实现轮播逻辑。

## 维护者

CrespoXiao <http://weibo.com/crespoxiao>

## 版权声明

CPInfiniteBanner is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
