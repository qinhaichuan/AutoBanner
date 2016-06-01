//
//  BannerView.m
//  Banner
//
//  Created by QHC on 5/27/16.
//  Copyright © 2016 秦海川. All rights reserved.
//

#import "BannerView.h"

@interface BannerScroll : UIScrollView

@end

@implementation BannerScroll

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

@end


@interface BannerView()<UIScrollViewDelegate>
{
    SEL _action;
    id _target;
}
@property(nonatomic, strong) NSMutableArray *urlsArr;
@property(nonatomic, strong) NSMutableArray *imageNameArr;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, assign) NSTimeInterval timerInterval;
@property(nonatomic, strong) BannerScroll *scrollV;
@property(nonatomic, copy) ClickBlcok clickBlock;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, weak) UIView *contentView;
@property(nonatomic, weak) NSTimer *timer;

@end

@implementation BannerView

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
        
    }
    return _timer;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.pageCount;
        _pageControl.hidden = self.pageCount <= 1;
//        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl setValue:[UIImage imageNamed:@"current"] forKeyPath:@"_currentPageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"other"] forKeyPath:@"_pageImage"];
//        [_pageControl addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pageControl;
}

- (BannerScroll *)scrollV
{
    if (!_scrollV) {
        _scrollV = [[BannerScroll alloc] initWithFrame:self.bounds];
        _scrollV.pagingEnabled = YES;
        _scrollV.bounces = NO;
        _scrollV.alwaysBounceHorizontal = NO;
        _scrollV.alwaysBounceVertical = NO;
        _scrollV.showsVerticalScrollIndicator = NO;
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.delegate = self;
        _scrollV.backgroundColor = [UIColor greenColor];
    }
    return _scrollV;
}

- (instancetype)initWithUrls:(NSArray *)urlArray timerInterval:(NSTimeInterval)timerInterval clickBlock:(ClickBlcok)clickBlock
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor blueColor];
        self.urlsArr = [NSMutableArray arrayWithArray:urlArray];
        self.pageCount = self.urlsArr.count;
        self.clickBlock = clickBlock;
        self.timerInterval = timerInterval;
        self.pageAlignment = BannerPageAlignmetCenter;

        [self addSubviews];

    }
    return self;

}


- (instancetype)initWithImages:(NSArray *)imageArray timerInterval:(NSTimeInterval)timerInterval clickBlock:(ClickBlcok)clickBlock
{
    if (self = [super init]) {
        
        self.imageNameArr = [NSMutableArray arrayWithArray:imageArray];
        self.pageCount = self.imageNameArr.count;
        self.clickBlock = clickBlock;
        self.timerInterval = timerInterval;
        self.pageAlignment = BannerPageAlignmetCenter;
        
        [self addSubviews];
        
        
    }
    return self;


}

- (instancetype)initWithUrls:(NSArray *)urlArray timerInterval:(NSTimeInterval)timerInterval target:(id)target action:(SEL)action
{
    if (self = [super init]) {

        _target = target;
        _action = action;
    
        self.backgroundColor = [UIColor blueColor];
        self.urlsArr = [NSMutableArray arrayWithArray:urlArray];
        self.pageCount = self.urlsArr.count;
        self.timerInterval = timerInterval;
        self.pageAlignment = BannerPageAlignmetCenter;
        
        [self addSubviews];
        
        
    }
    return self;
}

- (instancetype)initWithImages:(NSArray *)imageArray timerInterval:(NSTimeInterval)timerInterval target:(id)target action:(SEL)action
{
    if (self = [super init]) {
        
        
        
        
    }
    return self;

}

- (void)addSubviews
{
    [self addSubview:self.scrollV];
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [self.scrollV addSubview:self.contentView];
    
    [self addImageView];
    [self addSubview:self.pageControl];
    
    [self.scrollV makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.offset(0);
    }];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollV);
        make.height.equalTo(self.scrollV);
    }];
    
    // 默认显示第二页, 第一页为最后一页
    if (self.pageCount > 1) {
        [self.scrollV setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
        self.pageControl.currentPage = 0;
    }
    
    [self beginScroll];
}

- (void)addImageView
{
   // 显示顺序 412341
    // 第一屏: 显示最后一张
    UIImageView *lastView = [self addImageViewAtIndex:self.pageCount - 1 especialView:nil];
    
    for (NSInteger index = 0; index < self.pageCount; index++) {
        lastView = [self addImageViewAtIndex:index especialView:lastView];
    }
    
    // 最后一屏: 显示第一张
    lastView = [self addImageViewAtIndex:0 especialView:lastView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.right);
    }];
    

}

- (UIImageView *)addImageViewAtIndex:(NSInteger)index especialView:(UIImageView *)especialView
{
    UIImageView *imageV = [[UIImageView alloc] init];
//    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageV];
    
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(especialView ? especialView.right : @0);
        make.top.equalTo(self.scrollV).offset(0);
        make.width.equalTo(self.scrollV.width);
        make.height.equalTo(self.scrollV.height);
        
    }];
    
    if (self.urlsArr.count > 0) {
        [imageV sd_setImageWithURL:[NSURL URLWithString:[self.urlsArr objectAtIndex:index]]];
    }else if(self.imageNameArr.count > 0) {
        [imageV setImage:[UIImage imageNamed:[self.imageNameArr objectAtIndex:index]]];
    }
    
    
    
    return imageV;
}

- (void)beginScroll
{
    if (self.pageCount < 1) return;
    if (self.timerInterval == 0) return;
    
    [self.timer fire];
}

- (void)endScroll
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

}

- (void)scrollImage
{
    NSInteger currentIndex = (int)self.scrollV.contentOffset.x / self.scrollV.frame.size.width;
    
    if (currentIndex < self.pageCount + 1) {
        currentIndex ++;
    }
    
    [UIView animateWithDuration:1.0f animations:^{
        [self.scrollV setContentOffset:CGPointMake(self.scrollV.frame.size.width * currentIndex, 0)];
        
    } completion:^(BOOL finished) {
        
        if (currentIndex == (self.pageCount + 1)) {
            [self.scrollV setContentOffset:CGPointMake(self.scrollV.frame.size.width, 0)];
        }
    }];
    
    if (currentIndex == 0) {
        currentIndex = self.pageCount - 1;
    }else if (currentIndex == (self.pageCount + 1)){
        currentIndex = 0;
    }else{
        currentIndex--;
    }
    
    
    self.pageControl.currentPage = currentIndex;
}

- (void)setPageAlignment:(BannerPageAlignment)pageAlignment
{
    _pageAlignment = pageAlignment;
    
    self.pageControl.hidden = NO;
    if (pageAlignment == BannerPageAlignmetNone) {
        self.pageControl.hidden = YES;
    }else if (pageAlignment == BannerPageAlignmetCenter) {
        
        // masonry布局出现问题, 暂时无法解决
//       [self.pageControl remakeConstraints:^(MASConstraintMaker *make) {
//           make.height.offset(20);
//           make.centerX.equalTo(self);
//           make.bottom.equalTo(self).offset(0);
//       }];
        
        CGRect pageFrame = self.pageControl.frame;
        pageFrame.size.height = 20;
        // 用到项目中需重新修改布局
        pageFrame.origin.y = 230;
        self.pageControl.frame = pageFrame;
        
    }else if (pageAlignment == BannerPageAlignmetLeft) {
        [self.pageControl remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.left.offset(10);
            make.bottom.equalTo(self).offset(0);
        }];
    }else if (pageAlignment == BannerPageAlignmetRight) {
        [self.pageControl remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.right.offset(-10);
            make.bottom.equalTo(self).offset(0);
        }];
    }

}


#pragma mark ------ UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / self.scrollV.frame.size.width;
    
    if (currentIndex == 0) {
        currentIndex = self.pageCount - 1;
        [self.scrollV setContentOffset:CGPointMake(self.scrollV.frame.size.width * self.pageCount, 0)];
    }else if (currentIndex == self.pageCount + 1) {
        currentIndex = 0;
        [self.scrollV setContentOffset:CGPointMake(self.scrollV.frame.size.width, 0)];
    }else{
        currentIndex--;
    }
    self.pageControl.currentPage = currentIndex;
    [self beginScroll];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSInteger currentIndex = self.scrollV.contentOffset.x / self.scrollV.frame.size.width;
    
    if (currentIndex == 0) {
        currentIndex = self.pageCount - 1;
    }else if (currentIndex == self.pageCount + 1) {
        currentIndex = 0;
    }else {
        currentIndex--;
    }
    
    if (self.clickBlock) {
        self.clickBlock(currentIndex);
    }

    self.currentIndex = currentIndex;
    // 添加target-Action
    if (_target) {
        [_target performSelectorOnMainThread:_action withObject:nil waitUntilDone:YES];
    }
 }

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}









@end
