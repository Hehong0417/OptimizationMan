//
//  HHCategoryAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHCategoryAPI : BaseAPI

#pragma mark - get

//获取商品分类列表
+ (instancetype)GetCategoryListWithType:(NSNumber *)type;

//获取商品列表
+ (instancetype)GetProductListWithType:(NSNumber *)type categoryId:(NSString *)categoryId name:(NSString *)name orderby:(NSNumber *)orderby page:(NSNumber *)page pageSize:(NSNumber *)pageSize;
@end
