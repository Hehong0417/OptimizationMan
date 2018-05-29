//
//  HHBargainingSlider.m
//  lw_Store
//
//  Created by User on 2018/5/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBargainingSlider.h"

@implementation HHBargainingSlider

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
}

@end
