//
//  CPInfiniteBannerView.h
//  Pods
//
//  Created by CrespoXiao on 04/23/2016.
//  Copyright (c) 2016 CrespoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CPInfiniteBannerResponseBlock)(NSString * link);



@interface CPInfiniteBannerView : UIControl

//placeholder of banner
@property (nonatomic, strong) UIImage                       *placeHolder;

//image arrays of banner
@property (nonatomic, strong) NSMutableArray                *imageArray;

//duration of auto scroll, default is 3
@property (nonatomic, assign) CFTimeInterval                duration;

//enable auto scroll, default is Yes
@property (nonatomic, assign) BOOL enableAutoScroll;
/**
 *  init method
 *
 *  @param contianer
 *  @param block
 *
 *  @return
 */
- (instancetype)initWithContainerView:(UIView *)contianer responseBlock:(CPInfiniteBannerResponseBlock)block;

@end
