//
//  UIImageView+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LH)

/**
 *  初始化
 *
 *  @param frame 大小
 *  @param image 图片
 *
 *  @return 实例
 */
+ (UIImageView *)lh_imageViewWithFrame:(CGRect)frame image:(UIImage *)image;

/**
 *  初始化
 *
 *  @param frame                  大小
 *  @param image                  图片
 *  @param userInteractionEnabled 是否用户交互
 *
 *  @return 实例
 */
+ (UIImageView *)lh_imageViewWithFrame:(CGRect)frame image:(UIImage *)image userInteractionEnabled:(BOOL)userInteractionEnabled;

- (void)lh_setRoundImageViewWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


@end
