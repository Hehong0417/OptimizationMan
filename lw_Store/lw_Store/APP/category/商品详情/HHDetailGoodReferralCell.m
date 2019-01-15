//
//  HHDetailGoodReferralCell.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDetailGoodReferralCell.h"

@implementation HHDetailGoodReferralCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.product_nameLabel.font = BoldFONT(15);
    
    [self setupAutoHeightWithBottomView:self.priceTag_label bottomMargin:10];
}

- (void)setGooodDetailModel:(HHgooodDetailModel *)gooodDetailModel{

    _gooodDetailModel = gooodDetailModel;
    if ([gooodDetailModel.IsNewProduct isEqual:@0]) {
        
        NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",gooodDetailModel.ProductName]];
        //添加图片
        UIImage *attach_Image = [UIImage imageNamed:@"new_pro"];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = attach_Image;
        attach.bounds = CGRectMake(0, -3, attach_Image.size.width, attach_Image.size.height);
        
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 insertAttributedString:attributeStr2 atIndex:0];
        
        self.product_nameLabel.attributedText = attributeStr1;
    }else{
        self.product_nameLabel.text = gooodDetailModel.ProductName;
    }
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %@",gooodDetailModel.BuyPrice?gooodDetailModel.BuyPrice:@""];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",gooodDetailModel.MarketPrice]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.product_s_intergralLabel.attributedText = newPrice;
    self.package_lab.text = gooodDetailModel.StrFreightModey;

//    if ([gooodDetailModel.IsRewardShow isEqual:@1]) {
//        self.rewardShow_label.hidden = NO;
//        self.rewardShow_label.text = [NSString stringWithFormat:@"自购省%@元，分享省%@元",gooodDetailModel.BuyCheapMoney,gooodDetailModel.ShareMakeMoney];
//        NSString *ewardShow_text =  [NSString stringWithFormat:@"自购省%@元，分享省%@元",gooodDetailModel.BuyCheapMoney,gooodDetailModel.ShareMakeMoney];
//        CGSize mode_size = [ewardShow_text lh_sizeWithFont:FONT(13)  constrainedToSize:CGSizeMake(MAXFLOAT,AdapationLabelFont(20))];
//        UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(0,0, mode_size.width+AdapationLabelFont(20), AdapationLabelFont(20)) text:ewardShow_text textColor:RGB(251, 75, 77) font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
//
//        [label lh_setCornerRadius:5 borderWidth:1 borderColor:RGB(251, 75, 77)];
//        [self.rewardShow_label addSubview:label];
//    }else{
//        self.rewardShow_label.hidden = YES;
//        self.rewardShow_label.text = @"";
//    }
    self.shareReward_label.text = (gooodDetailModel.CommissionTotal.intValue==0)?@"":[NSString stringWithFormat:@"分享总奖励：%@%%",gooodDetailModel.CommissionTotal];
}
@end

