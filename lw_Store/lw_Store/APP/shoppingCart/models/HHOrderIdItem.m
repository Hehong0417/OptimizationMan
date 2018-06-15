//
//  HHOrderIdItem.m
//  lw_Store
//
//  Created by User on 2018/6/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderIdItem.h"

@implementation HHOrderIdItem

singleton_m(OrderIdItem)

- (instancetype)init {
    
    HHOrderIdItem *localUser = [HHOrderIdItem read];
    
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
@end
