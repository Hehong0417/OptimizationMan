//
//  TSSettingItem.m
//  Transport
//
//  Created by zhipeng-mac on 15/11/29.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "HJSettingItem.h"

@implementation HJSettingItem

+ (instancetype)itemWithtitle:(NSString *)title image:(NSString *)image{
    
    HJSettingItem *item = [[HJSettingItem alloc]init];
    
    item.title = title;
    
    item.image = image;
    
    return item;
}

@end
