//
//  HHAddCartTool.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAddCartTool.h"

@implementation HHAddCartTool

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.cartIconBg];
        [self.cartIconBg addSubview:self.cartIconImgV];
        [self addSubview:self.addCartBtn];
        [self addSubview:self.buyBtn];

    }
    
    return self;
    
}

- (void)addCartBtnAction{
    
    if (self.addCartBlock) {
        self.addCartBlock();
    }
}
- (void)buyCartBtnAction{
    
    if (self.buyBlock) {
        self.buyBlock();
    }
}
//购物车图标底图
- (UIView *)cartIconBg{
    
    if (!_cartIconBg) {
        
        _cartIconBg = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 50) backColor:kWhiteColor];
        
    }
    return _cartIconBg;
}

//购物车图标
- (UIImageView *)cartIconImgV {
  
    if (!_cartIconImgV) {
        
        _cartIconImgV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 50) image:[UIImage imageNamed:@"icon_shopcars_default"]];
        _cartIconImgV.contentMode = UIViewContentModeCenter;
        
    }
    return _cartIconImgV;
    
}
- (UIButton *)addCartBtn{
    
    if (!_addCartBtn) {
        
        _addCartBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 50) target:self action:@selector(addCartBtnAction) image:nil title:@"加入购物车" titleColor:kWhiteColor font:FONT(15)];
        [_addCartBtn setBackgroundColor:APP_purple_Color];
    }
    return _addCartBtn;
    
}
- (UIButton *)buyBtn{
    
    if (!_buyBtn) {
        
        _buyBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50) target:self action:@selector(buyCartBtnAction) image:nil title:@"立即购买" titleColor:kWhiteColor font:FONT(15)];
        [_buyBtn setBackgroundColor:APP_Deep_purple_Color];

    }
    return _buyBtn;
    
}

@end
