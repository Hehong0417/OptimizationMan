//
//  HHtEditCarItem.h
//  Store
//
//  Created by User on 2018/1/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHtEditCarItem : BaseModel

@property (nonatomic, assign) BOOL settleAllSelect;
@property (nonatomic, assign) CGFloat total_Price;
@property (nonatomic, assign) CGFloat  s_integral_total;


+(instancetype)shopCartGoodsList:(NSArray *)shopCartGoodsList selectionArr:(NSArray *)selectionArr;

@end
