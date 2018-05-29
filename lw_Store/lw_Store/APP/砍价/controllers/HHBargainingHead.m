//
//  HHBargainingHead.m
//  lw_Store
//
//  Created by User on 2018/5/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBargainingHead.h"
#import "HHBargainingSlider.h"

@implementation HHBargainingHead
{
    UIImageView *_product_ImageV;
    UILabel *_product_nameLabel;
    UILabel *_product_min_valueLabel;
    UILabel *_product_max_valueLabel;
    UILabel *_product_valueLabel;
    HHBargainingSlider *_slider;

}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        _product_ImageV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(370)) image:[UIImage imageNamed:@"icon0"]];
        [self addSubview:_product_ImageV];
        _product_nameLabel = [UILabel lh_labelWithFrame:CGRectMake(15, CGRectGetMaxY(_product_ImageV.frame), ScreenW-30, 50) text:@"七夕单身狗粮产品" textColor:kBlackColor font:FONT(15) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [self addSubview:_product_nameLabel];
        _slider = [[HHBargainingSlider alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(_product_nameLabel.frame)+40, ScreenW-120, 15)];
        [self addSubview:_slider];
        //
        _slider.minimumValue = 200;
        _slider.maximumValue = 300;
        _slider.value = 225;
        _slider.userInteractionEnabled = NO;
        _product_valueLabel = [UILabel lh_labelWithFrame:CGRectMake((_slider.value - _slider.minimumValue)/(_slider.maximumValue -_slider.minimumValue)*(ScreenW-120)+40,  CGRectGetMaxY(_product_nameLabel.frame), 40, 25) text:[NSString stringWithFormat:@"%.f",_slider.value] textColor:kBlueColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:_product_valueLabel];
   
        _product_min_valueLabel = [UILabel lh_labelWithFrame:CGRectMake(40,  CGRectGetMaxY(_slider.frame), 40, 15) text:[NSString stringWithFormat:@"%.f",_slider.minimumValue] textColor:kGrayColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:_product_min_valueLabel];
        
        _product_max_valueLabel = [UILabel lh_labelWithFrame:CGRectMake(ScreenW-120+40,  CGRectGetMaxY(_slider.frame), 40, 15) text:[NSString stringWithFormat:@"%.f",_slider.maximumValue] textColor:kGrayColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:_product_max_valueLabel];
        
        [_slider setThumbImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateNormal];

    }
    
    return self;
}

@end
