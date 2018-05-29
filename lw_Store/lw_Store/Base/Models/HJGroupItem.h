//
//  TSGroupItem.h
//  Transport
//
//  Created by zhipeng-mac on 15/11/29.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJGroupItem : NSObject

/** 头部标题 */
@property (strong, nonatomic) NSString * headerTitle;
/** 尾部标题 */
@property (strong, nonatomic) NSString * footerTitle;

/** 组中的行数组 */
@property (strong, nonatomic) NSArray * items;

@end
