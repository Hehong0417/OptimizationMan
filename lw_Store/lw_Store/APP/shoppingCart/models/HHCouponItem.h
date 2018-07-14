//
//  HHCouponItem.h
//  lw_Store
//
//  Created by User on 2018/6/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHCouponItem : BaseModel

singleton_h(CouponItem)

@property(nonatomic,strong) HHcouponsModel *coupon_model;
@property(nonatomic,strong) NSMutableArray *selectItems;
@property(nonatomic,assign) NSInteger lastSelectIndex;
@property(nonatomic,assign) CGFloat last_total_money;
//最开始的价格
@property(nonatomic,assign) CGFloat order_total_money;

@end
