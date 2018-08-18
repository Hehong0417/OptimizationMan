//
//  HHPostEvaluateSectionHead.h
//  lw_Store
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPStarEvaluation.h"

@interface HHPostEvaluateSectionHead : UIView<CDPStarEvaluationDelegate>

@property (nonatomic, strong) CDPStarEvaluation *starEvaluation;//星形评价
@property (nonatomic, strong) UIImageView *product_imageV;//星形评价
@property (nonatomic, assign) NSInteger section;

@end
