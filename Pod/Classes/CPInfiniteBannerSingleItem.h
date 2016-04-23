//
//  CPInfiniteBannerSingleItem.h
//  Pods
//
//  Created by CrespoXiao on 04/23/2016.
//  Copyright (c) 2016 CrespoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPInfiniteBannerSingleItem : UIView

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIImageView *placeHolderImageView;
@property (nonatomic,strong) UIImage     *placeHolderImage;

@property (nonatomic,strong) NSString    *link;
@property (nonatomic,assign) BOOL        hasSetImage;


- (instancetype)initWithFrame:(CGRect)frame placeHolder:(UIImage *)placeHolder;

- (void)setImage:(UIImage *)image;

@end
