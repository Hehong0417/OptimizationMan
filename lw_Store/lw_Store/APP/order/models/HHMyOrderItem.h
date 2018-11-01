//
//  HHMyOrderItem.h
//  Store
//
//  Created by User on 2018/3/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"
#import "HJOrderCell.h"
#import "HHSubmitOrderCell.h"

@interface HHMyOrderItem : BaseModel

+ (void)shippingLogisticsStateWithStatus_code:(NSInteger)status_code cell:(HJOrderCell *)cell;

+ (void)shippingLogisticsStateWithStatus_code:(NSInteger)status_code submitCell:(HHSubmitOrderCell *)cell;

+ (CGFloat)rowHeightWithRow:(NSInteger)row Products_count:(NSInteger )products_count;

+ (void)pushVCWithStatus_code:(NSInteger)status_code navC:(UINavigationController *)navC VC:(UIViewController *)vc product_m:(HHproducts_item_Model *)product_m order_id:(NSString *)order_id;
+ (void)orderDetailpushVCWithStatus_code:(NSInteger)status_code navC:(UINavigationController *)navC VC:(UIViewController *)vc product_m:(HHproductsModel *)product_m order_id:(NSString *)order_id;
@end
