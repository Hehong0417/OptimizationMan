//
//  HHCartModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHproductsModel,HHordersModel,HHskuidModel,HHproducts_item_Model,HHcouponsModel;

@interface HHCartModel : BaseModel
//购物车
@property(nonatomic,strong) NSString *count;
@property (nonatomic, strong) NSNumber *sendGift;

@property(nonatomic,strong) NSArray <HHproductsModel*>*products;
@property(nonatomic,strong) NSArray <HHproductsModel*>*prodcuts;

//提交订单
@property(nonatomic,strong) NSString *shop_card_ids;
@property(nonatomic,strong) NSString *addrId;
//@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *cityId;
@property(nonatomic,strong) NSString *fullAddress;
@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) NSString *region;
@property(nonatomic,strong) NSString *regionId;
@property(nonatomic,strong) NSString *totalFreight;
@property(nonatomic,strong) NSString *totalMoney;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSNumber *familiarityPay;
@property(nonatomic,strong) NSString *familiarityPayMoney;
@property(nonatomic,strong) NSString *totalIntegral;

//优惠券模型
@property(nonatomic,strong) NSArray <HHcouponsModel*>*coupons;
//订单模型
@property(nonatomic,strong) NSArray <HHordersModel*>*orders;

//我的订单
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *order_date;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,strong) NSString *status_name;
@property(nonatomic,strong) NSString *total;
@property(nonatomic,strong) NSNumber *order_mode;
@property(nonatomic,strong) NSString *order_mode_name;
@property(nonatomic,strong) NSArray <HHproductsModel*>*items;
@property(nonatomic,assign) CGFloat footHeight;

//订单详情
@property(nonatomic,strong) NSString *buyerName;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *orderDate;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *paymode;
@property(nonatomic,strong) NSString *orderid;
@property(nonatomic,strong) NSString *payDate;
@property(nonatomic,strong) NSString *payTotal;
@property(nonatomic,strong) NSString *freight;
@property(nonatomic,strong) NSString *gbid;
@property(nonatomic,strong) NSString *statusName;

@end
@interface HHordersModel : BaseModel

//提交订单
@property(nonatomic,strong) NSArray <HHproductsModel*>*products;
@property(nonatomic,strong) NSString *freight;
@property(nonatomic,strong) NSString *freightId;
@property(nonatomic,strong) NSString *money;
@property(nonatomic,strong) NSString *showMoney;
@property(nonatomic,strong) NSString *derateMoney;//满减活动
@property(nonatomic,strong) NSArray *addtion_arr;//[@"快递运费"，@“满减活动”，@“订单总计”]数组
@property(nonatomic,strong) NSArray *addtion_value_arr;//[@"快递运费"，@“满减活动”，@“订单总计”]对应的值数组
@property(nonatomic,strong) NSString *integralDisplayName;
@property(nonatomic,strong) NSString *isCanUseIntegral;
@property(nonatomic,strong) NSString *orderIntegral;
@property(nonatomic,strong) NSString *orderIntegralMoney;

@end

@interface HHproductsModel : BaseModel

//订单
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *item_id;
@property(nonatomic,strong) NSString *quantity;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *total;
@property(nonatomic,strong) NSString *sku_name;
@property(nonatomic,strong) NSString *prodcut_name;
@property(nonatomic,strong) NSString *item_status;
@property(nonatomic,strong) NSArray <HHproducts_item_Model*>*product_item;

//购物车
@property(nonatomic,strong) NSString *pid;
@property(nonatomic,strong) NSString *skuId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *cartid;
@property(nonatomic,strong) NSString *skuName;

//提交订单
@property(nonatomic,strong) NSString *money;
@property(nonatomic,strong) NSString *pId;
@property(nonatomic,strong) NSString *pname;

//订单详情
@property(nonatomic,strong) NSString *orderid;
@property(nonatomic,strong) NSString *region;
@property(nonatomic,strong) NSString *statusName;
@property(nonatomic,strong) NSArray <HHskuidModel*>*skuid;
//@property(nonatomic,strong) NSString *pname;
@end


@interface HHskuidModel : BaseModel
@property(nonatomic,strong) NSString *Price;
@property(nonatomic,strong) NSString *Value;
@property(nonatomic,strong) NSString *Quantity;
@end

//订单里的商品
@interface HHproducts_item_Model : BaseModel
@property(nonatomic,strong) NSString *product_item_id;
@property(nonatomic,strong) NSString *product_item_price;
@property(nonatomic,strong) NSString *product_item_quantity;
@property(nonatomic,strong) NSString *product_item_sku_name;
@property(nonatomic,strong) NSString *product_item_status;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *prodcut_name;
@end


//优惠券模型
@interface HHcouponsModel : BaseModel
@property(nonatomic,strong) NSString *CouponId;
@property(nonatomic,strong) NSString *CouponValue;
@property(nonatomic,strong) NSString *DisplayName;
@property(nonatomic,strong) NSString *UserCouponId;
@end

