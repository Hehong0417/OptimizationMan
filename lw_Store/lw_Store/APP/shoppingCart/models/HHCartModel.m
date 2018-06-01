//
//  HHCartModel.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCartModel.h"

@implementation HHCartModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"products": [HHproductsModel class],@"items": [HHproductsModel class],@"orders": [HHordersModel class],@"prodcuts":[HHproductsModel class]};
}
//我的订单
- (void)mj_keyValuesDidFinishConvertingToObject {
    
    NSInteger status_code = self.status.integerValue;
    if (status_code == 1) {
//        @"待付款"
        self.footHeight = 60;
    }else if (status_code == 2){
//        @"待发货"
        self.footHeight = 8;
    }else if (status_code == 3){
//        @"待收货
        self.footHeight = 60;
    }else if (status_code == 4){
        //        @"订单关闭
        self.footHeight = 8;
    }else if (status_code == 5){
        //        @"交易完成
        self.footHeight = 60;
        
    }else if (status_code == 6){
        //        @"申请退款
        self.footHeight = 8;
    }else if (status_code == 7){
        //        @"申请退货
        self.footHeight = 8;
    }else if (status_code == 8){
        //        @"申请换货
        self.footHeight = 8;
    }else if (status_code == 9){
        //        @"已退款
        self.footHeight = 8;
    }else if (status_code == 8){
        //        @"已退货
        self.footHeight = 10;
    }
}
@end
@implementation HHproductsModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"skuid":[HHskuidModel class],@"product_item":[HHproducts_item_Model class]};
}

@end
@implementation HHordersModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"products": [HHproductsModel class]};
}
@end
@implementation HHskuidModel

@end
@implementation HHproducts_item_Model

@end

