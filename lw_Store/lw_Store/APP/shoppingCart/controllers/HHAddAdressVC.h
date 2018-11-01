//
//  HHAddAdressVC.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHAddress_addType,
    HHAddress_editType,
    HHAddress_settlementType_cart,//购物车结算
    HHAddress_settlementType_productDetail//商品详情结算
} HHAddressType;

@interface HHAddAdressVC : UIViewController

@property (nonatomic, strong)   NSString *titleStr;

@property (nonatomic, assign)   HHAddressType  addressType;

@property (nonatomic, strong)   NSString *Id;

@property (nonatomic, strong)   NSString *province;

@property (nonatomic, strong)   NSString *city;

@property (nonatomic, strong)   NSString *region;

@property (nonatomic, strong)   NSNumber *mode;
@property (nonatomic, strong)   NSNumber *sendGift;

//sku_ids
@property(nonatomic,strong) NSString *ids_Str;

//购物车id
@property(nonatomic,strong) NSString *cartIds_str;

//商品id-->支付成功猜你喜欢接口需要使用到
@property(nonatomic,strong) NSString *pids;

@end
