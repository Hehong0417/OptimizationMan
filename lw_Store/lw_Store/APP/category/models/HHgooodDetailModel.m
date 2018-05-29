//
//  HHgooodDetailModel.m
//  Store
//
//  Created by User on 2018/1/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHgooodDetailModel.h"

@implementation HHgooodDetailModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"SKUValues": [HHproduct_sku_valueModel class],@"SKUList": [HHproduct_skuModel class],
             @"AttributeValueList" :[HHattributeValueModel class]};
}


@end
@implementation HHproduct_sku_valueModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"ItemList": [HHsku_name_valueModel class]};
}

@end
@implementation HHsku_name_valueModel

@end
@implementation HHproduct_skuModel

@end

@implementation HHattributeValueModel

@end


