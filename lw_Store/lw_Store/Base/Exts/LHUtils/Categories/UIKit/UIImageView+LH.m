//
//  UIImageView+LH.m
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIImageView+LH.h"

@implementation UIImageView (LH)

/**
 *  初始化
 *
 *  @param frame 大小
 *  @param image 图片
 *
 *  @return 实例
 */
+ (UIImageView *)lh_imageViewWithFrame:(CGRect)frame image:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

/**
 *  初始化
 *
 *  @param frame                  大小
 *  @param image                  图片
 *  @param userInteractionEnabled 是否用户交互
 *
 *  @return 实例
 */
+ (UIImageView *)lh_imageViewWithFrame:(CGRect)frame image:(UIImage *)image userInteractionEnabled:(BOOL)userInteractionEnabled {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.userInteractionEnabled = userInteractionEnabled;
    return imageView;
}
- (void)lh_setRoundImageViewWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
}

@end
