//
//  HHMyIntegralCell.m
//  lw_Store
//
//  Created by User on 2018/5/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCommissionCell.h"

@implementation HHCommissionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //单号
        self.integralLabel = [UILabel new];
        self.integralLabel.font = FONT(13);
        self.integralLabel.contentMode = UIViewContentModeRight;
        [self.contentView addSubview:self.integralLabel];
        
        //金额
        self.integral_typeLabel = [UILabel new];
        self.integral_typeLabel.font = FONT(13);
        self.integral_typeLabel.contentMode = UIViewContentModeRight;
        [self.contentView  addSubview:self.integral_typeLabel];
        
        //时间
        self.timeLabel = [UILabel new];
        self.timeLabel.font = FONT(13);
        self.timeLabel.contentMode = UIViewContentModeRight;
        [self.contentView  addSubview:self.timeLabel];
        
        //时间
        self.commissionLabel = [UILabel new];
        self.commissionLabel.font = FONT(13);
        self.commissionLabel.contentMode = UIViewContentModeRight;
        [self.contentView  addSubview:self.commissionLabel];
        [self setConstaints];
    }
    return self;
}

- (void)setConstaints{
    
    CGFloat width = (ScreenW - 15*3)/2;
    
    self.integralLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 10)
    .heightIs(25)
    .widthIs(width);
    
    self.integral_typeLabel.sd_layout
    .leftSpaceToView(self.integralLabel, 15)
    .topSpaceToView(self.contentView, 10)
    .heightIs(25)
    .widthIs(width);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.integralLabel, 10)
    .heightIs(25)
    .widthIs(width);
    
    self.commissionLabel.sd_layout
    .leftSpaceToView(self.timeLabel, 15)
    .topSpaceToView(self.integral_typeLabel,10)
    .heightIs(25)
    .widthIs(width);
}
- (void)setModel:(HHMineModel *)model{
    _model = model;
    self.integralLabel.text = [NSString stringWithFormat:@"单号：%@",model.OrderInfo_Id.length>0?model.OrderInfo_Id:@""];
    self.integral_typeLabel.text = [NSString stringWithFormat:@"时间：%@",model.TradeTime.length>0?model.TradeTime:@"0000-00-00 00:00:00"];
    self.timeLabel.text = [NSString stringWithFormat:@"买家昵称：%@",model.ReferralUserName.length>0?model.ReferralUserName:@"买家未设置姓名"];
    self.commissionLabel.text = model.CommTotal.doubleValue>0?[NSString stringWithFormat:@"佣金：%.2f",model.CommTotal.doubleValue]:[NSString stringWithFormat:@"佣金：0.00"];

}
@end
