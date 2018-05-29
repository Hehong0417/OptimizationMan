//
//  UITableViewCell+LH.h
//  Transport
//
//  Created by IMAC on 15/12/3.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (LH)

/**
 *  设置分割线为0，iOS8以上在代理方法 willDisplayCell 执行
 */
- (void)lh_setSeparatorInsetZero;

@end
