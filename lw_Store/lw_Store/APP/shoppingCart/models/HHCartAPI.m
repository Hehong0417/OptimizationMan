//
//  HHCartAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCartAPI.h"

@implementation HHCartAPI

#pragma mark - get

//获取购物车中商品
+ (instancetype)GetCartProducts{
    HHCartAPI *api = [self new];
    api.subUrl = API_GetProducts;
    api.parametersAddToken = NO;
    return api;
}
//是否存在收货地址
+ (instancetype)IsExistOrderAddress{
    HHCartAPI *api = [self new];
    api.subUrl = API_IsExistOrderAddress;
    api.parametersAddToken = NO;
    return api;
}

//获得结算订单
+ (instancetype)GetConfirmOrderWithids:(NSString *)ids mode:(NSNumber *)mode skuId:(NSString *)skuId quantity:(NSNumber *)quantity{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_GetConfirmOrder;
    if (ids) {
        [api.parameters setObject:ids forKey:@"addrId"];
    }
    if (mode) {
        [api.parameters setObject:mode forKey:@"mode"];
    }
    if (skuId) {
        [api.parameters setObject:skuId forKey:@"skuId"];
    }
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    api.parametersAddToken = NO;
    return api;
}

//热门搜索
+ (instancetype)GetHotSearchWithtop:(NSNumber *)top{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_GetHotSearch;
    if (top) {
        [api.parameters setObject:top forKey:@"top"];
    }
    api.parametersAddToken = NO;
    return api;
}
//用户历史搜索
+ (instancetype)GetUserSearchWithtop:(NSNumber *)top{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_GetUserSearch;
    if (top) {
        [api.parameters setObject:top forKey:@"top"];
    }
    api.parametersAddToken = NO;
    return api;
}
#pragma mark - post

//添加购物车数量
+ (instancetype)postAddQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_AddQuantity;
    if (cart_id) {
        [api.parameters setObject:cart_id forKey:@"sku"];
    }
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    api.parametersAddToken = NO;
    return api;
}
//减少购物车数量
+ (instancetype)postminusQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_minusQuantity;
    if (cart_id) {
        [api.parameters setObject:cart_id forKey:@"cartId"];
    }
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    api.parametersAddToken = NO;
    return api;
}

//加入购物车
+ (instancetype)postAddProductsWithsku_id:(NSString *)sku_id quantity:(NSString *)quantity{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_AddProducts;
    if (sku_id) {
        [api.parameters setObject:sku_id forKey:@"sku"];
    }
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    api.parametersAddToken = NO;
    return api;
}
//删除购物车
+ (instancetype)postShopCartDeleteWithcart_id:(NSString *)cart_id{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_ShopCart_Delete;
    if (cart_id) {
        [api.parameters setObject:cart_id forKey:@""];
    }
    api.parametersAddToken = NO;
    return api;
}

@end
