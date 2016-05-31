//
//  ViewController.m
//  Banner
//
//  Created by QHC on 5/17/16.
//  Copyright © 2016 秦海川. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"

@interface ViewController ()

@property(nonatomic, weak) BannerView *urlBannerView;
@property(nonatomic, weak) BannerView *imageBannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"BannerEndless";
    
    NSArray *urlArr = @[
                        @"http://p18.qhimg.com/bdr/__85/d/_open360/design0313/13.jpg",
                        @"http://images.sports.cn/Image/2014/07/29/0810272642.jpg",
                        @"http://img2.3lian.com/2014/f5/97/d/48.jpg",
                        @"http://files.17173.com/forum/fz_tele-02/files/2014/01/28/232608p03s11dd0hsbsghm.jpg",
                        @"http://imgsrc.baidu.com/forum/pic/item/77ab08fa513d2697d8d0e6d155fbb2fb4216d887.jpg"
                        ];
    
    NSArray *imageArr = @[
                          @"1.jpg",
                          @"2.jpg"
                          ];
    
    
    BannerView *urlBannerView = [[BannerView alloc] initWithUrls:urlArr timerInterval:2.0 target:self action:@selector(urlBannerClick)];
//    BannerView *urlBannerView = [[BannerView alloc] initWithUrls:urlArr timerInterval:2.0 clickBlock:^(NSInteger imageIndex) {
//        NSLog(@"imageIndex====%zd", imageIndex);
//    }];
    self.urlBannerView = urlBannerView;
    [self.view addSubview:urlBannerView];
    urlBannerView.pageAlignment = BannerPageAlignmetCenter;
    [urlBannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(250.0f);
        
    }];
    
//    BannerView *imageBannerView = [[BannerView alloc] initWithImages:imageArr timerInterval:3.0 target:self action:@selector(imageBannerClick:)];
    BannerView *imageBannerView = [[BannerView alloc] initWithImages:imageArr timerInterval:2.0 clickBlock:^(NSInteger imageIndex) {
        NSLog(@"imageIndex====%zd", imageIndex);
        
    }];
    self.imageBannerView = imageBannerView;
    [self.view addSubview:imageBannerView];
    imageBannerView.pageAlignment = BannerPageAlignmetRight;
    [imageBannerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(urlBannerView.bottom).offset(50.0f);
        make.height.equalTo(250.0f);
    }];
    
    
}

- (void)urlBannerClick
{
    NSLog(@"------%zd", _urlBannerView.currentIndex);

}

- (void)imageBannerClick
{
    NSLog(@"=====%zd", _urlBannerView.currentIndex);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
