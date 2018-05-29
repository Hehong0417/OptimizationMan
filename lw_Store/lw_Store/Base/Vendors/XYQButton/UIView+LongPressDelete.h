//
//  UIView+LongPressDelete.h
//  Transport
//
//  Created by zhipeng-mac on 15/12/11.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlock)();

@interface UIView (LongPressDelete)

- (void)longPressDeleteWhenTapDelete:(DeleteBlock)deleteBlock;

@end
