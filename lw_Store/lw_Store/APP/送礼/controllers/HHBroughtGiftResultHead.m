//
//  HHBroughtGiftResultHead.m
//  lw_Store
//
//  Created by User on 2018/5/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBroughtGiftResultHead.h"

@implementation HHBroughtGiftResultHead
{
    UIView *_bg_view;
    UIImageView *_product_imageV;
    UILabel *_product_nameLabel;
    UIImageView *_iconView;
    UILabel *_describ_label;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _bg_view = [UIView new];
        [_bg_view lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        [self addSubview:_bg_view];
        
        _product_imageV = [UIImageView new];
        _product_imageV.image = [UIImage imageNamed:@"icon1"];
        [_bg_view addSubview:_product_imageV];
        
        _product_nameLabel = [UILabel new];
        _product_nameLabel.font = FONT(14);
        [_bg_view addSubview:_product_nameLabel];
        
        
        _iconView = [UIImageView new];
        _iconView.image = [UIImage imageNamed:@"icon0"];
        [self addSubview:_iconView];
        
        
        _describ_label = [UILabel new];
        _describ_label.font = FONT(16);
        [self addSubview:_describ_label];
        
        
        //添加约束
        [self setConstraint];
        
    }
    return self;
}
- (void)setConstraint{
    
    _bg_view.sd_layout.leftSpaceToView(self, 15)
    .topSpaceToView(self, 20)
    .rightSpaceToView(self, 15)
    .heightIs(150);
    
    _product_imageV.sd_layout
    .leftSpaceToView(_bg_view, 30)
    .centerXEqualToView(_bg_view)
    .heightIs(80)
    .widthEqualToHeight();
    
    _product_nameLabel.sd_layout
    .leftSpaceToView(_product_imageV, 25)
    .rightSpaceToView(_bg_view, 25)
    .autoHeightRatio(0)
    .centerXEqualToView(_product_imageV);
    
    _iconView.sd_layout
    .leftSpaceToView(self, 25)
    .heightIs(60)
    .widthEqualToHeight()
    .topSpaceToView(_bg_view, 20);
    
    _describ_label.sd_layout
    .leftSpaceToView(_iconView, 20)
    .rightSpaceToView(self, 30)
    .heightIs(30)
    .centerYEqualToView(_iconView);
}
@end
