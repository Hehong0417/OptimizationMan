//
//  HHOrderItemModel.m
//  lw_Store
//
//  Created by User on 2018/5/31.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderItemModel.h"

@implementation HHOrderItemModel

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
@end
