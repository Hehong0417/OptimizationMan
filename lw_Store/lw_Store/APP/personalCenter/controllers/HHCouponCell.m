//
//  HHCouponCell.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCouponCell.h"

@implementation HHCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.tagLabel lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.useBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.bg_view lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
}
- (void)setModel:(HHMineModel *)model{

    _model = model;
    self.coupon_title.text =  model.CouponsName;
    NSString *startTime = model.StartTime.length>10?[model.StartTime substringToIndex:10]:model.StartTime;
    NSString *endTime = model.EndTime.length>10?[model.EndTime substringToIndex:10]:model.EndTime;

    self.dateTimeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",startTime,endTime];
    self.money_valueLabel.text = model.CouponValue;
    self.suitConditionLabel.text = [NSString stringWithFormat:@"直减%@",model.CouponValue];
    self.limitLabel.text = [NSString stringWithFormat:@"每人限领%@",@""];
}


@end
