//
//  HHCartAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHCartAPI : BaseAPI

#pragma mark - get

//获取购物车中商品
+ (instancetype)GetCartProducts;

//获得结算订单
+ (instancetype)GetConfirmOrderWithids:(NSString *)ids;

//热门搜索
+ (instancetype)GetHotSearchWithtop:(NSNumber *)top;
//用户历史搜索
+ (instancetype)GetUserSearchWithtop:(NSNumber *)top;
//是否存在收货地址
+ (instancetype)IsExistOrderAddress;

#pragma mark - post
//添加购物车数量
+ (instancetype)postAddQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity;
//减少购物车数量
+ (instancetype)postminusQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity;
//加入购车
+ (instancetype)postAddProductsWithsku_id:(NSString *)sku_id quantity:(NSString *)quantity;

//删除购物车
+ (instancetype)postShopCartDeleteWithcart_id:(NSString *)cart_id;

//去支付订单，提交订单
+ (instancetype)postCreateOrderWithids:(NSString *)ids address_id:(NSString *)address_id shop_userid:(NSString *)shop_userid remark:(NSString *)remark pay_mode:(NSNumber *)pay_mode channe:(NSNumber *)channe;


@end
