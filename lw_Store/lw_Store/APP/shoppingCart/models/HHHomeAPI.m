//
//  HHHomeAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHHomeAPI.h"

@implementation HHHomeAPI

#pragma mark - get

//首页商品列表
+ (instancetype)getCategoryProductListWithtype:(NSString *)type isExperience:(NSString *)isExperience{
    
    HHHomeAPI *api = [self new];
    api.subUrl = API_GetHomeProductList;
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    if (isExperience) {
        [api.parameters setObject:isExperience forKey:@"isExperience"];
    }
    api.parametersAddToken = NO;
    
   return api;
    
}
//商品详情
+ (instancetype)GetProductDetailWithId:(NSString *)Id{
    
    HHHomeAPI *api = [self new];
    api.subUrl = API_GetProductDetail;
    if (Id) {
        [api.parameters setObject:Id forKey:@"id"];
    }
   
    api.parametersAddToken = NO;
    
    return api;
    
}
//评论列表
+ (instancetype)GetProductEvaluateWithId:(NSString *)Id page:(NSNumber *)page  pageSize:(NSNumber *)pageSize hasImage:(NSNumber *)hasImage{
    
    HHHomeAPI *api = [self new];
    api.subUrl = API_GetProductEvaluate;
    if (Id) {
        [api.parameters setObject:Id forKey:@"pid"];
    }
    if (hasImage) {
        [api.parameters setObject:@"true" forKey:@"hasImage"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    
    return api;
    
}

//月成交记录
+ (instancetype)GetFinishLogId:(NSString *)Id page:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    HHHomeAPI *api = [self new];
    api.subUrl = API_GetFinishLog;
    if (Id) {
        [api.parameters setObject:Id forKey:@"id"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    api.parametersAddToken = NO;
    
    return api;
    
}
#pragma mark - post





@end
