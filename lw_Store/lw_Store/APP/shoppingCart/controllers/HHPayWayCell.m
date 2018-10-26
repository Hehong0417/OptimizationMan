//
//  HHPayWayCell.m
//  lw_Store
//
//  Created by User on 2018/10/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPayWayCell.h"

@implementation HHPayWayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.text_label = [UILabel new];
        self.text_label.textAlignment = NSTextAlignmentLeft;
        self.iconView = [UIImageView new];
        self.detail_button = [UIButton lh_buttonWithFrame:CGRectZero target:self action:@selector(paywaySelectAction:) image:[UIImage imageNamed:@"icon_sign_default"]];
        [self.detail_button setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
        
        [self.contentView addSubview:self.text_label];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.detail_button];

        [self addConstraint];
    }
    
    return self;
}
- (void)addConstraint{
    
    self.iconView.contentMode = UIViewContentModeCenter;
    self.iconView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 10)
    .widthIs(30)
    .heightIs(30);
    
    self.text_label.font = FONT(14);
    self.text_label.sd_layout
    .leftSpaceToView(self.iconView, 10)
    .topSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 10)
    .widthIs(150);
    
    self.detail_button.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 10)
    .widthIs(60)
    .heightIs(30);
    
    
}
- (void)paywaySelectAction:(UIButton *)button{
    
    
    
}

@end
