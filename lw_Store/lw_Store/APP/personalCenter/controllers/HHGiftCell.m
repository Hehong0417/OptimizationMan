//
//  HHGiftCell.m
//  lw_Store
//
//  Created by User on 2019/1/8.
//  Copyright © 2019年 User. All rights reserved.
//

#import "HHGiftCell.h"

@implementation HHGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.receiveBtn lh_setCornerRadius:2 borderWidth:0 borderColor:nil];

}
- (void)setPrizeModel:(HHMineModel *)prizeModel{
    _prizeModel = prizeModel;
    self.pNameLabel.text = prizeModel.product_name;
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:prizeModel.product_icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.dateTimeLabel.text = prizeModel.create_date;
    if (prizeModel.status.integerValue == 0) {
        self.receiveDate.text = @"";
        self.dateTimeLabel.text = [NSString stringWithFormat:@"过期时间：%@",prizeModel.expire];
        [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.receiveBtn setBackgroundColor:APP_COMMON_COLOR];
    }else if (prizeModel.status.integerValue == 1) {
        self.receiveDate.text = [NSString stringWithFormat:@"领取时间：%@",prizeModel.receive_date];
        self.dateTimeLabel.text = [NSString stringWithFormat:@"订单号：%@",prizeModel.order_id];
        [self.receiveBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:KTitleLabelColor forState:UIControlStateNormal];
        self.receiveBtn.userInteractionEnabled = NO;
        [self.receiveBtn setBackgroundColor:kWhiteColor];

    }else if (prizeModel.status.integerValue == 2) {
        self.receiveDate.text = @"";
        self.dateTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",prizeModel.expire];
        [self.receiveBtn setTitle:@"已失效" forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:KTitleLabelColor forState:UIControlStateNormal];
        self.receiveBtn.userInteractionEnabled = NO;
        [self.receiveBtn setBackgroundColor:kWhiteColor];
    }
}

@end
