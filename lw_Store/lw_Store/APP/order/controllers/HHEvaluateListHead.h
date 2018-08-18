//
//  HHEvaluateListHead.h
//  lw_Store
//
//  Created by User on 2018/8/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPStarEvaluation.h"

@protocol HHEvaluateListHeadDelegate<NSObject>

- (void)sortBtnSelectedWithSortBtnType:(NSInteger)sortBtnType;

@end

@interface HHEvaluateListHead : UIView

@property (nonatomic, strong) CDPStarEvaluation *starEvaluation;//星形评价

@property (nonatomic, strong)   HHMineModel *evaluateStatictis_m;

@property (nonatomic, strong)   UIButton *currentSelectBtn;

@property (nonatomic, assign)   id<HHEvaluateListHeadDelegate> delegate;

@end
