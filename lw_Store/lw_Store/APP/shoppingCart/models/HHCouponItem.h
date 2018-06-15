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

@end
