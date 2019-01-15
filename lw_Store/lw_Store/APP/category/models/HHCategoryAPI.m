//
//  HHCategoryAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCategoryAPI.h"

@implementation HHCategoryAPI

#pragma mark - get
//获取商品分类列表
+ (instancetype)GetCategoryListWithType:(NSNumber *)type{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetCategoryList;
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取商品列表
+ (instancetype)GetProductListWithType:(NSNumber *)type categoryId:(NSString *)categoryId name:(NSString *)name orderby:(NSNumber *)orderby page:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_Product_search;
//    if (type) {
//        [api.parameters setObject:type forKey:@"type"];
//    }
    if (categoryId) {
        [api.parameters setObject:categoryId forKey:@"categoryId"];
    }
    if (name) {
        [api.parameters setObject:name forKey:@"name"];
    }
    if (orderby) {
        [api.parameters setObject:orderby forKey:@"order"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
//    if (pageSize) {
//        [api.parameters setObject:pageSize forKey:@"pageSize"];
//    }
    api.parametersAddToken = NO;
    
    return api;
}
//猜你喜欢
+ (instancetype)GetAlliancesProductsWithpids:(NSString *)pids{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetAlliancesProducts;
    if (pids) {
        [api.parameters setObject:pids forKey:@"pids"];
    }
    
    api.parametersAddToken = NO;
    
    return api;
}

//获得支付有礼
+ (instancetype)GetPaymentGiftWithoid:(NSString *)oid{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetPaymentGift;
    if (oid) {
        [api.parameters setObject:oid forKey:@"oid"];
    }
    
    api.parametersAddToken = NO;
    
    return api;
}

#pragma mark - post

//领取礼品
+ (instancetype)PostReceiveGiftWithgift_id:(NSString *)gift_id{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_ReceiveGift;
    if (gift_id) {
        [api.parameters setObject:gift_id forKey:@"gift_id"];
    }
    api.parametersAddToken = NO;
    
    return api;
    
}
@end
