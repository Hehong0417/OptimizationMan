//
//  HHDetailGoodReferralCell.h
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHgooodDetailModel.h"

@interface HHDetailGoodReferralCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_min_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_s_intergralLabel;
@property (weak, nonatomic) IBOutlet UILabel *package_lab;
@property (weak, nonatomic) IBOutlet UILabel *priceTag_label;
@property (weak, nonatomic) IBOutlet UILabel *rewardShow_label;
@property (weak, nonatomic) IBOutlet UILabel *shareReward_label;

@property (nonatomic, strong)  HHgooodDetailModel *gooodDetailModel;

@end
