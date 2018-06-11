//
//  HHMyOrderItem.m
//  Store
//
//  Created by User on 2018/3/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyOrderItem.h"

@implementation HHMyOrderItem

+ (void)shippingLogisticsStateWithStatus_code:(NSInteger)status_code cell:(HJOrderCell *)cell{
    
    if (status_code == 6) {
        cell.StandardLab.text = @" 退款中 ";
        cell.StandardLab.userInteractionEnabled = NO;
        
    }else if (status_code == 7){
        cell.StandardLab.text = @" 退货中 ";
        cell.StandardLab.userInteractionEnabled = NO;
    }else if (status_code == 9){
        cell.StandardLab.text = @" 已退款 ";
        cell.StandardLab.userInteractionEnabled = NO;
    }else if(status_code == 10){
        cell.StandardLab.text = @" 已退货 ";
        cell.StandardLab.userInteractionEnabled = NO;
    }else if(status_code == 2){
        cell.StandardLab.text = @" 申请退款 ";
        cell.StandardLab.userInteractionEnabled = YES;
    }else if(status_code == 3){
        cell.StandardLab.text = @" 申请退货 ";
        cell.StandardLab.userInteractionEnabled = YES;
    }else{
        cell.StandardLab.text = @"";
        cell.StandardLab.hidden = YES;
        cell.StandardLab.userInteractionEnabled = NO;
    }
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
