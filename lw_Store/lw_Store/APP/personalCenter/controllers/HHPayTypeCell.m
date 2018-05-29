//
//  HHPayTypeCell.m
//  lw_Store
//
//  Created by User on 2018/5/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPayTypeCell.h"

@implementation HHPayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.leftSelect_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftSelect_btn setImage:[UIImage imageNamed:@"icon_sign_default"] forState:UIControlStateNormal];
        [self.leftSelect_btn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
        self.leftSelect_btn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.leftSelect_btn];
        
        self.icon_View = [UIImageView new];
        self.icon_View.image = [UIImage imageNamed:@"icon1"];
        [self.contentView addSubview:self.icon_View];
        
        self.payType_label = [UILabel new];
        self.payType_label.text = @"微信支付";
        self.payType_label.font = FONT(14);
        [self.contentView addSubview:self.payType_label];
        
        
        
        [self setConstaints];
    }
    
    return self;
}
- (void)setConstaints{
    
    self.leftSelect_btn.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthIs(40);
    
    self.icon_View.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.leftSelect_btn, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthIs(40);
    
    self.payType_label.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.icon_View, 20)
    .bottomSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 15);
    
}
- (void)setSelected:(BOOL)selected{
    
    self.leftSelect_btn.selected = selected;
}
@end
