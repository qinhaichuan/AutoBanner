//
//  BannerView.h
//  Banner
//
//  Created by QHC on 5/27/16.
//  Copyright © 2016 秦海川. All rights reserved.
//

typedef NS_ENUM(NSInteger) {
    BannerPageAlignmetCenter,
    BannerPageAlignmetNone,
    BannerPageAlignmetLeft,
    BannerPageAlignmetRight
}BannerPageAlignment;


typedef void(^ClickBlcok)(NSInteger imageIndex);


#import <UIKit/UIKit.h>

@interface BannerView : UIView

@property(nonatomic, assign) BannerPageAlignment pageAlignment;
@property(nonatomic, assign) NSInteger currentIndex;

//- (instancetype)initWithUrls:(NSArray *)urlArray clickBlock:(ClickBlcok)clickBlock;
//- (instancetype)initWithUrls:(NSArray *)urlArray target:(id)target action:(SEL)action;
//- (instancetype)initWithImages:(NSArray *)imageArray clickBlock:(ClickBlcok)clickBlock;
//- (instancetype)initWithImages:(NSArray *)imageArray target:(id)target action:(SEL)action;

/**
 *  timerInterval 设置为0不自动切换
 */
- (instancetype)initWithUrls:(NSArray *)urlArray timerInterval:(NSTimeInterval)timerInterval clickBlock:(ClickBlcok)clickBlock;
- (instancetype)initWithUrls:(NSArray *)urlArray timerInterval:(NSTimeInterval)timerInterval target:(id)target action:(SEL)action;
- (instancetype)initWithImages:(NSArray *)imageArray timerInterval:(NSTimeInterval)timerInterval clickBlock:(ClickBlcok)clickBlock;
- (instancetype)initWithImages:(NSArray *)imageArray timerInterval:(NSTimeInterval)timerInterval target:(id)target action:(SEL)action;

@end
