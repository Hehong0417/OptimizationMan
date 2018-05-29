//
//  HHCouponListVC.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCouponSuperVC.h"
#import "HHCouponUnusedVC.h"
#import "HHCouponUsedVC.h"
#import "HHCouponFailureVC.h"

@interface HHCouponSuperVC ()<UIScrollViewDelegate,SGSegmentedControlDelegate,UISearchBarDelegate>

@property(nonatomic,strong)   SGSegmentedControl *SG;
@property (nonatomic, strong)   UIScrollView *mainScrollView;
@property (nonatomic, strong)   NSMutableArray *title_arr;

@end

@implementation HHCouponSuperVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"优惠券";
    
    self.view.backgroundColor = kWhiteColor;
    
    self.title_arr = [NSMutableArray arrayWithArray:@[@"未使用",@"已使用",@"已失效"]];
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    
    [self setupSegmentedControl];
    
}
- (NSMutableArray *)title_arr {
    
    if (!_title_arr) {
        _title_arr = [NSMutableArray array];
    }
    return _title_arr;
}

- (void)setupSegmentedControl {
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.title_arr.count, 0);
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    if (self.title_arr.count < 5) {
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    }else{
        
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:self.title_arr];
    }
    self.SG.titleColorStateNormal = APP_COMMON_COLOR;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = FONT(14);
    self.SG.backgroundColor = kWhiteColor;
    self.SG.indicatorColor = APP_COMMON_COLOR;
    [self.view addSubview:self.SG];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.SG.height - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = LineLightColor ;
    [self.SG addSubview:line];
    
}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}
// 添加所有子控制器
- (void)setupChildViewController {
    
    HHCouponUnusedVC *vc1 = [HHCouponUnusedVC new];
    [self addChildViewController:vc1];
    
    HHCouponUsedVC *vc2 = [HHCouponUsedVC new];
    [self addChildViewController:vc2];
    
    HHCouponFailureVC *vc3 = [HHCouponFailureVC new];
    [self addChildViewController:vc3];
    
    
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    //    if (vc.isViewLoaded) return;
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    [self.SG titleBtnSelectedWithScrollView:scrollView];
}

@end
