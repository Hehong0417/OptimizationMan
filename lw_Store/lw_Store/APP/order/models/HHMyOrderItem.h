//
//  HHMyOrderItem.h
//  Store
//
//  Created by User on 2018/3/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHMyOrderItem : BaseModel

+ (NSString *)shippingLogisticsStateWithStatus_code:(NSInteger)status_code;

+ (CGFloat)rowHeightWithRow:(NSInteger)row Products_count:(NSInteger )products_count;

@end
