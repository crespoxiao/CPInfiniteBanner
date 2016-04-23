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

//duration of auto scroll
@property (nonatomic, assign) CFTimeInterval                duration;


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
