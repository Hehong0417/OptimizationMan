//
//  HHMyEvaluationGoodsCell.h
//  lw_Store
//
//  Created by User on 2019/2/12.
//  Copyright © 2019年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHEvaluationListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHMyEvaluationGoodsCell : UITableViewCell
@property (nonatomic, strong)   UIImageView *iconImageV;
@property (nonatomic, strong)   UILabel *nameLabel;
@property (nonatomic, strong) HHEvaluationListModel *model;

@end

NS_ASSUME_NONNULL_END
