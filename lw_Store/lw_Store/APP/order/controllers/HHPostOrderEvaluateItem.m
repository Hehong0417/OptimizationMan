
//
//  HHPostOrderEvaluateItem.m
//  lw_Store
//
//  Created by User on 2018/8/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPostOrderEvaluateItem.h"

@implementation HHPostOrderEvaluateItem

singleton_m(PostOrderEvaluateItem)

- (instancetype)init {
    
    HHPostOrderEvaluateItem *localUser = [HHPostOrderEvaluateItem read];
    
    if (localUser) {
        _instance = localUser;
    } else {
        
        _instance = [super init];
    }
    
    return _instance;
}

- (NSMutableArray *)productEvaluate{
    if (!_productEvaluate) {
        _productEvaluate = [NSMutableArray array];
    }
    return _productEvaluate;
}
@end

@implementation HHproductEvaluateModel

@end
