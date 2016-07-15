//
//  CPInfiniteBannerView.m
//  Pods
//
//  Created by CrespoXiao on 04/23/2016.
//  Copyright (c) 2016 CrespoXiao. All rights reserved.
//

#import "CPInfiniteBannerView.h"
#import "CPInfiniteBannerSingleItem.h"

#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <Masonry/Masonry.h>
#import <libextobjc/EXTScope.h>


#define ITEM_WIDTH                         (self.frame.size.width)
#define CP_SafeBlockRun(block, ...)        block ? block(__VA_ARGS__) : nil



@interface CPInfiniteBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView                  *scrollView;
@property (nonatomic, strong) UIPageControl                 *pageControl;
@property (nonatomic, strong) NSTimer                       *timer;
@property (nonatomic, copy  ) CPInfiniteBannerResponseBlock responseBlock;
@property (nonatomic, weak  ) UIView                        *container;
@end



@implementation CPInfiniteBannerView


- (void)dealloc {
    _scrollView.delegate = nil;
    _scrollView = nil;
    _pageControl = nil;
    _placeHolder = nil;
    _container = nil;

    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
    
    if (_responseBlock) {
        _responseBlock = nil;
    }
}

- (instancetype)initWithContainerView:(UIView *)contianer responseBlock:(CPInfiniteBannerResponseBlock)block {
    self = [super init];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self makeConstraints];
        _responseBlock = [block copy];
        _enableAutoScroll = YES;
        
        if (contianer) {
            _container = contianer;
            [contianer addSubview:self];
        }
    }
    return self;
}

#pragma mark - lazy load

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(clickOnScrollView:)];
        [_scrollView addGestureRecognizer:tapGesture];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        // 总页数
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

#pragma mark - constraints

- (void)makeConstraints {
    @weakify(self);
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
    
    [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.scrollView.mas_right).offset(-5);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
}


#pragma mark - setter

- (void)setPlaceHolder:(UIImage *)placeHolder {
    if (placeHolder) {
        _placeHolder = placeHolder;
    }
}

- (void)setDuration:(CFTimeInterval)duration {
    _duration = duration;
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    
    if (!imageArray || (imageArray && ![imageArray count])) {
        return;
    }
    _imageArray = imageArray;
    
    if (_imageArray.count) {
        
        //首尾各加一张图片
        self.pageControl.hidden = YES;
        self.scrollView.contentSize	 = CGSizeMake(ITEM_WIDTH * (_imageArray.count+2), self.frame.size.height);
        //set center view
        for (NSInteger i = 0; i < _imageArray.count; i ++) {
            NSInteger tag = 100+i;
            [self buildSubViewOfScrollViewWithTag:tag andImageData:[_imageArray objectAtIndex:i]];
        }
        
        //set head view
        NSInteger tag_head = 99;
        [self buildSubViewOfScrollViewWithTag:tag_head andImageData:[_imageArray lastObject]];
        
        //set tail view
        NSInteger tag_tail = 100 + [_imageArray count];
        [self buildSubViewOfScrollViewWithTag:tag_tail andImageData:[_imageArray firstObject]];
        
        //move to the first item
        [self gotoStartPostionAfterSetData];
    }
}

- (void)setEnableAutoScroll:(BOOL)enableAutoScroll {
    _enableAutoScroll = enableAutoScroll;
    enableAutoScroll ? [self fireTimer]:[self stopTimer];
}
#pragma mark - build view

- (void)buildSubViewOfScrollViewWithTag:(NSInteger)tag andImageData:(id)imageData {
    if ([self.scrollView viewWithTag:tag]) {
        [[self.scrollView viewWithTag:tag] removeFromSuperview];
    }
    
    NSInteger position;
    if (tag == 99) {
        position = 0;
    }else if (tag == (100 + [_imageArray count])){
        position = [_imageArray count]+1;
    }else{
        position = (tag - 100) + 1;
    }
    CPInfiniteBannerSingleItem *singleItemView = [[CPInfiniteBannerSingleItem alloc] initWithFrame:
                                   CGRectMake(ITEM_WIDTH * position, 0, ITEM_WIDTH, self.frame.size.height)
                                                                                       placeHolder:_placeHolder];
    singleItemView.tag = tag;
    [self.scrollView addSubview:singleItemView];
    
    
    if ([imageData isKindOfClass:[UIImage class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            singleItemView.link = nil;
            [singleItemView setImage:(UIImage*)imageData];
            if (self.pageControl.hidden) {
                self.pageControl.hidden = NO;
            }
        });
    }else if ([imageData isKindOfClass:[NSString class]]){
        @weakify(self);
        [self downloadImageWithUrl:imageData relatedLink:imageData downloadImageCallBack:^(UIImage *image, NSString *link) {
            @strongify(self);
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    singleItemView.link = link;
                    [singleItemView setImage:image];
                    if (self.pageControl.hidden) {
                        self.pageControl.hidden = NO;
                    }
                });
            }
        }];
    }
}

- (void)gotoStartPostionAfterSetData {
    self.pageControl.numberOfPages = [_imageArray count];
    self.pageControl.currentPage = 0;
    [self scrollToIndex:0];
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    targetX = (NSInteger)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
}


#pragma mark - press image

- (void)clickOnScrollView:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.scrollView];
    NSInteger page = (NSInteger)point.x / (NSInteger)self.frame.size.width;

    CPInfiniteBannerSingleItem *itemView;
    NSInteger currentTag;
    if (page == 0) {//head
        currentTag = 99;
    }else if (page == [self.imageArray count]+1){//tail
        currentTag = (100 + [_imageArray count]);
    }else{//center
        currentTag = (page-1+100);
    }
             
    if ([self.scrollView viewWithTag:currentTag] &&
        [[self.scrollView viewWithTag:currentTag]isKindOfClass:[CPInfiniteBannerSingleItem class]]) {
        itemView = (CPInfiniteBannerSingleItem *)[self.scrollView viewWithTag:currentTag];
        
        if (_responseBlock) {
            if (itemView.link && [itemView.link length]) {
                CP_SafeBlockRun(_responseBlock,itemView.link);
            }
        }
    }
}


#pragma mark - timer methods

- (void)fireTimer {
    if (!self.enableAutoScroll) {
        return;
    }
    [self stopTimer];
    _duration = _duration ? _duration:3;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(go2Next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)go2Next {
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    targetX = (NSInteger)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
}

- (void)stopTimer {
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
    }
}


#pragma mark -scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self stopTimer];

    CGFloat targetX = scrollView.contentOffset.x;
    if ([self.imageArray count] >= 1){
        if (targetX >= ITEM_WIDTH * ([self.imageArray count] + 1)) {
            targetX = ITEM_WIDTH;
            [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }else if(targetX <= 0){
            targetX = ITEM_WIDTH *[self.imageArray count];
            [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    NSInteger page = (self.scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;

    if ([self.imageArray count] > 1){
        page --;
        if (page >= self.pageControl.numberOfPages){
            page = 0;
        }else if(page <0){
            page = self.pageControl.numberOfPages -1;
        }
    }
    self.pageControl.currentPage = page;

    [self fireTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate){
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (NSInteger)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self.scrollView setContentOffset:CGPointMake((NSInteger)targetX, 0) animated:YES];
    }
}


- (void)scrollToIndex:(NSInteger)aIndex {
    if ([self.imageArray count]>1){
        if (aIndex >= ([self.imageArray count])){
            aIndex = [self.imageArray count]-1;
        }
        [self.scrollView setContentOffset:CGPointMake(ITEM_WIDTH*(aIndex+1), 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [self scrollViewDidScroll:self.scrollView];
}



#pragma mark - download image

- (void)downloadImageWithUrl:(NSString *)url
                 relatedLink:(NSString *)relatedlink
       downloadImageCallBack:(void (^)(UIImage *image,NSString *link))block {
    if (url && ([url isKindOfClass:[NSString class]] && [url length])) {
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
            if (!image) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (finished) {
                        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:url]];
                        CP_SafeBlockRun(block,image,relatedlink?:@"");
                    }
                }];
            }else{
                CP_SafeBlockRun(block,image,relatedlink?:@"");
            }
        }];
    }
}

@end
