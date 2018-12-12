//
//  HHCommissionCell.h
//  lw_Store
//
//  Created by User on 2018/12/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHCommissionCell : UITableViewCell

@property (nonatomic, strong)   UILabel *integral_typeLabel;
@property (nonatomic, strong)   UILabel *integralLabel;
@property (nonatomic, strong)   UILabel *timeLabel;
@property (nonatomic, strong)   UILabel *commissionLabel;
@property (nonatomic, strong)   HHMineModel *model;

@end

NS_ASSUME_NONNULL_END
