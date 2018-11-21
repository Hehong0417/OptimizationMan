//
//  HWNEWfeatureViewController.m
//  HXBudsProject
//
//  Created by n on 2017/5/14.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HWNEWfeatureViewController.h"
#import "HJTabBarController.h"

#define HWNEWfeatureCount 3

@interface HWNEWfeatureViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageCtrol;

@end

@implementation HWNEWfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(HWNEWfeatureCount*self.view.frame.size.width, 0);
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview: _scrollView];
    
    for (NSInteger i=0; i<HWNEWfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"L_0%ld",i+1]];
        [_scrollView addSubview:imageView];
        
        if (i == HWNEWfeatureCount -1) {
            [self setupLastImageView:imageView];
        }
    }
    _scrollView.delegate = self;
}
- (void)setupLastImageView:(UIImageView *)imageView{

    imageView.userInteractionEnabled = YES;
    [imageView setTapActionWithBlock:^{
      

        
    }];

}

@end
