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
             @"AttributeValueList" :[HHattributeValueModel class],@"Packages":[HHPackagesModel class]};
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
//商品信息
@implementation HHattributeValueModel

@end

//优惠套餐模型
@implementation HHPackagesModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"Products": [HHPackagesProductsModel class]};
}
@end
@implementation HHPackagesProductsModel

@end
@implementation HHGuess_you_likeModel

@end

