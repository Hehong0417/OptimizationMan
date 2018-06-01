//
//  HHCartModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHproductsModel,HHordersModel,HHskuidModel,HHproducts_item_Model;

@interface HHCartModel : BaseModel
//购物车
@property(nonatomic,strong) NSString *count;

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

@property(nonatomic,strong) NSArray <HHordersModel*>*orders;

//我的订单
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *order_date;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,strong) NSString *status_name;
@property(nonatomic,strong) NSString *total;
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

@end
@interface HHordersModel : BaseModel

//提交订单
@property(nonatomic,strong) NSArray <HHproductsModel*>*products;
@property(nonatomic,strong) NSString *freight;
@property(nonatomic,strong) NSString *freightId;
@property(nonatomic,strong) NSString *money;

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

//提交订单
//@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *money;
@property(nonatomic,strong) NSString *pId;
@property(nonatomic,strong) NSString *pname;
//@property(nonatomic,strong) NSString *price;
//@property(nonatomic,strong) NSString *quantity;

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
