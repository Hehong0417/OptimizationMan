//
//  HHCouponItem.m
//  lw_Store
//
//  Created by User on 2018/6/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCouponItem.h"

@implementation HHCouponItem

singleton_m(CouponItem)

- (instancetype)init {
    
    HHCouponItem *localUser = [HHCouponItem read];
    
    if (localUser) {
        _instance = localUser;
    } else {
        
        _instance = [super init];
    }
    
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    
    return copy;
}
- (NSMutableArray *)selectItems{
    
    if (!_selectItems) {
        _selectItems = [NSMutableArray array];
    }
    return _selectItems;
}
@end
