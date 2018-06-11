//
//  HHMyOrderItem.h
//  Store
//
//  Created by User on 2018/3/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"
#import "HJOrderCell.h"

@interface HHMyOrderItem : BaseModel

+ (void)shippingLogisticsStateWithStatus_code:(NSInteger)status_code cell:(HJOrderCell *)cell;

+ (CGFloat)rowHeightWithRow:(NSInteger)row Products_count:(NSInteger )products_count;

@end
