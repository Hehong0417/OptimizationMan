//
//  HHSubmitOrdersVC.h
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHaddress_type_add_cart,
    HHaddress_type_add_productDetail,
    HHaddress_type_Spell_group,
    HHaddress_type_package,
    HHaddress_type_another
    
} HHenter_type;

@interface HHSubmitOrdersVC : UIViewController
@property(nonatomic,strong) NSString *ids_Str;
@property(nonatomic,assign) HHenter_type enter_type;
@property(nonatomic,strong) NSNumber *mode;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSNumber *sendGift;
@property(nonatomic,strong) NSString *gbId;
//购物车id
@property(nonatomic,strong) NSString *cartIds_str;

//商品id-->支付成功猜你喜欢接口需要使用到
@property(nonatomic,strong) NSString *pids;

@end

