//
//  HHMyIntegralCell.m
//  lw_Store
//
//  Created by User on 2018/5/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyIntegralCell.h"

@implementation HHMyIntegralCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.integralLabel = [UILabel new];
        self.integralLabel.font = FONT(14);
        [self.contentView  addSubview:self.integralLabel];
        
        self.integral_typeLabel = [UILabel new];
        self.integral_typeLabel.font = FONT(14);
        [self.contentView  addSubview:self.integral_typeLabel];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.font = FONT(13);
        self.timeLabel.textColor = KACLabelColor;
        self.timeLabel.contentMode = UIViewContentModeRight;
        [self.contentView  addSubview:self.timeLabel];
        
        [self setConstaints];
    }
    return self;
}

- (void)setConstaints{
    
    self.integral_typeLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .heightIs(25)
    .widthIs(200);
    
    self.integralLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.integral_typeLabel, 10)
    .heightIs(25)
    .widthIs(200);
    
    self.timeLabel.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 10)
    .heightIs(25)
    .widthIs(100);
    
}
- (void)setModel:(HHMineModel *)model{
    _model = model;
    self.integral_typeLabel.text = [NSString stringWithFormat:@"积分类型：%@",model.integraType.length>0?model.integraType:@""];
    self.integralLabel.text = [NSString stringWithFormat:@"积分：%ld",model.integra];
    self.timeLabel.text = model.datetime;

}
@end
