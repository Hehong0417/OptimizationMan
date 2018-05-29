//
//  HHHomeAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHHomeAPI : BaseAPI

#pragma mark - get

//首页商品列表
+ (instancetype)getCategoryProductListWithtype:(NSString *)type isExperience:(NSString *)isExperience;

//商品详情
+ (instancetype)GetProductDetailWithId:(NSString *)Id;

//月成交记录
+ (instancetype)GetFinishLogId:(NSString *)Id page:(NSNumber *)page pageSize:(NSNumber *)pageSize;


#pragma mark - post


@end
