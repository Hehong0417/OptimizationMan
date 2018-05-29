//
//  UITableViewCell+LH.m
//  Transport
//
//  Created by IMAC on 15/12/3.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "UITableViewCell+LH.h"

@implementation UITableViewCell (LH)

/**
 *  设置分割线为0，iOS8以上在代理方法 willDisplayCell 执行
 */
- (void)lh_setSeparatorInsetZero {
    // iOS7
    self.separatorInset = UIEdgeInsetsZero;
    
    if (IOS_VERSION_8_OR_ABOVE) {// iOS8 以上
        // Prevent the cell from inheriting the Table View's margin settings
        self.preservesSuperviewLayoutMargins = NO;;
        // Explictly set your cell's layout margins
        self.layoutMargins = UIEdgeInsetsZero;
    }
}

@end
