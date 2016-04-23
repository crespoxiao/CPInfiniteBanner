//
//  CPInfiniteBannerSingleItem.m
//  Pods
//
//  Created by CrespoXiao on 04/23/2016.
//  Copyright (c) 2016 CrespoXiao. All rights reserved.
//

#import "CPInfiniteBannerSingleItem.h"
#import <Masonry/Masonry.h>
#import <libextobjc/EXTScope.h>


@implementation CPInfiniteBannerSingleItem

- (void)dealloc {
    _imageView = nil;
    _placeHolderImageView =nil;
    _placeHolderImage = nil;
    _link = nil;
}


- (instancetype)initWithFrame:(CGRect)frame placeHolder:(UIImage *)placeHolder {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.placeHolderImageView];
        [self makeConstraints];
        
        self.placeHolderImage = placeHolder;
    }
    return self;
}


- (void)setImage:(UIImage *)image {
    self.hasSetImage = YES;
    [self.placeHolderImageView setHidden:YES];
    [self.imageView setImage:image];
}

#pragma mark - lazy load

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.userInteractionEnabled = YES;
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIImageView *)placeHolderImageView {
    if (!_placeHolderImageView) {
        _placeHolderImageView = [[UIImageView alloc]init];
        [_placeHolderImageView setContentMode:UIViewContentModeScaleToFill];
    }
    return _placeHolderImageView;
}

#pragma mark - setter

- (void)setPlaceHolderImage:(UIImage *)placeHolderImage {
    if (!placeHolderImage) {
        return;
    }
    _placeHolderImage = placeHolderImage;
    [self.placeHolderImageView setImage:_placeHolderImage];
}

#pragma mark - constraints

- (void)makeConstraints {
    @weakify(self);
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
    
    [self.placeHolderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
}


@end
