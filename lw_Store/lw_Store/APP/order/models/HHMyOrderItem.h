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

+ (void)pushVCWithStatus_code:(NSInteger)status_code navC:(UINavigationController *)navC VC:(UIViewController *)vc product_m:(HHproducts_item_Model *)product_m order_id:(NSString *)order_id;

@end
