//
//  HHMyOrderItem.m
//  Store
//
//  Created by User on 2018/3/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyOrderItem.h"

@implementation HHMyOrderItem

+ (NSString *)shippingLogisticsStateWithStatus_code:(NSInteger)status_code{
    
    NSString *stutus;
    if (status_code == 1) {
        stutus = @"待付款";
    }else if (status_code == 2){
        stutus = @"待发货";
    }else if (status_code == 3){
        stutus = @"待收货";
    }else if(status_code == 4){
        stutus = @"订单关闭";
    }
    //            stutus = @"待收货";
    //            stutus = @"交易成功";
    //            stutus = @"已退款";
    //            stutus = @"已退货";
    //            stutus = @"订单关闭";

    return stutus;
}
+ (CGFloat)rowHeightWithRow:(NSInteger)row Products_count:(NSInteger )products_count{
    
    if (row == products_count){
        //商品
        return 44;
    }else {
        return 85;
    }
}
@end
