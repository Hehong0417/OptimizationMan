//
//  HHFansListCell.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHFansListCell.h"

@implementation HHFansListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bg_view lh_setCornerRadius:3 borderWidth:1 borderColor:[UIColor colorWithHexString:@"DDDDDD"]];
    [self addShadowToView:self.bg_view withOpacity:0.3 shadowRadius:3 andCornerRadius:3 shadowColor:[UIColor colorWithHexString:@"#BBBBBB"] shadow_height:self.bg_view.size.height shadow_width:self.bg_view.size.width shadowOffset:CGSizeMake(8, 10)];
    
    [self.iconView lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
}
- (void)setModel:(HHMineModel *)model{
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.Icon]];
    self.nameLbel.text = model.UserName;
    self.fans_countLAbel.text = model.AgentName;
}

@end
