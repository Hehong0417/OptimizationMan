//
//  HHEvaluteStarCell.h
//  lw_Store
//
//  Created by User on 2018/5/2.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPStarEvaluation.h"

@interface HHEvaluteStarCell : UITableViewCell<CDPStarEvaluationDelegate>

@property (nonatomic, strong) CDPStarEvaluation *starEvaluation;//星形评价
@property (nonatomic, strong) UILabel *discrib_lab;//描述相符
@property (nonatomic, strong) UILabel *logistics_lab;//物流服务
@property (nonatomic, strong) CDPStarEvaluation *starEvaluation2;//星形评价

@end
