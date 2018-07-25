//
//  HHAddCartTool.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAddCartTool.h"
#import "HHShoppingVC.h"

@implementation HHAddCartTool

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.cartIconBg];
        [self.cartIconBg addSubview:self.homeIconImgV];
        [self.cartIconBg addSubview:self.cartIconImgV];

        UIView *line = [UIView lh_viewWithFrame:CGRectMake(self.cartIconImgV.mj_x, 0, 1, self.homeIconImgV.mj_h) backColor:RGB(220, 220, 220)];
        [self.cartIconBg addSubview:line];
        
        //购物车
        WEAK_SELF();
        [self.cartIconImgV setTapActionWithBlock:^{
            HHShoppingVC *shop_vc = [HHShoppingVC new];
            shop_vc.cartType = HHcartType_goodDetail;
            [weakSelf.nav pushVC:shop_vc];
        }];
        self.buyBtn.hidden=YES;
        [self addSubview:self.buyBtn];

        [self addSubview:self.addCartBtn];

    }
    
    return self;
    
}

- (void)addCartBtnAction{
    
    if (self.addCartBlock) {
        self.addCartBlock();
    }
}
- (void)buyCartBtnAction:(UIButton *)btn{
    if (self.buyBlock) {
        self.buyBlock(btn);
    }
}
//购物车图标底图
- (UIView *)cartIconBg{
    
    if (!_cartIconBg) {
        
        _cartIconBg = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 50) backColor:kWhiteColor];
        
    }
    return _cartIconBg;
}
//首页图标
- (UIImageView *)homeIconImgV {
    
    if (!_homeIconImgV) {
        
        _homeIconImgV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3/2, 50) image:[UIImage imageNamed:@"tab_icon_home_default"]];
        _homeIconImgV.contentMode = UIViewContentModeCenter;
        _homeIconImgV.userInteractionEnabled = YES;
    }
    return _homeIconImgV;
    
}
//购物车图标
- (UIImageView *)cartIconImgV {
  
    if (!_cartIconImgV) {
        
        _cartIconImgV = [UIImageView lh_imageViewWithFrame:CGRectMake(SCREEN_WIDTH/3/2, 0, SCREEN_WIDTH/3/2, 50) image:[UIImage imageNamed:@"tab_icon_shop_default"]];
        _cartIconImgV.contentMode = UIViewContentModeCenter;
        _cartIconImgV.userInteractionEnabled = YES;

    }
    return _cartIconImgV;
    
}
- (UIButton *)addCartBtn{
    
    if (!_addCartBtn) {
        
        _addCartBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3*2, 50) target:self action:@selector(addCartBtnAction) image:nil title:@"加入购物车" titleColor:kWhiteColor font:FONT(15)];
        [_addCartBtn setBackgroundColor:kBlackColor];
    }
    return _addCartBtn;
    
}
- (UIButton *)buyBtn{
    
    if (!_buyBtn) {
        
        _buyBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50) target:self action:@selector(buyCartBtnAction:) image:nil title:@"活动" titleColor:kWhiteColor font:FONT(15)];
        [_buyBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 75, 5, 10)];
        [_buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 40)];
        [_buyBtn setImage:[UIImage imageNamed:@"triangle2"] forState:UIControlStateSelected];
        [_buyBtn setImage:[UIImage imageNamed:@"triangle1"] forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:kDarkGrayColor];

    }
    return _buyBtn;
    
}

@end
