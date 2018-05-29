//
//  TSSettingItem.h
//  Transport
//
//  Created by zhipeng-mac on 15/11/29.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJSettingItem : NSObject

@property (strong, nonatomic) NSString * title;/**< 标题 */

@property (strong, nonatomic) NSString * detailTitle;/**< 标题 */

@property (strong, nonatomic) NSString * image;/**< 图片 */

//DEFINE_PROPERTY(copy, NSString *, inputString);

//DEFINE_PROPERTY(unsafe_unretained, BOOL, rightViewSelected);

+ (instancetype)itemWithtitle:(NSString *)title image:(NSString *)image;/**< 设置标题值 类方法 */

@end
