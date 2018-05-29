//
//  UIViewController+AOP.h
//  Bsh
//
//  Created by IMAC on 15/12/16.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYQButton.h"

@interface UIViewController (AOP)

/**
 *  AOP返回按钮
 *
 *  @return button
 */
+ (XYQButton *)aopBackButton;

@end
