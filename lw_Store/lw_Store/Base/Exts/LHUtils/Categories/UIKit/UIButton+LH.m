//
//  UIButton+LH.m
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIButton+LH.h"

@implementation UIButton (LH)

/**
 *  初始化
 *
 *  @param frame  大小
 *  @param target 对象
 *  @param action 事件
 *  @return 实例
 */
+ (UIButton *)private_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/**
 *  初始化，无图无字
 *
 *  @param frame           大小
 *  @param target          对象
 *  @param action          事件
 *  @param backgroundColor 背景颜色
 *
 *  @return 实例
 */
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action backgroundColor:(UIColor *)backgroundColor
{
    UIButton *button = [self private_buttonWithFrame:frame target:target action:action];
    button.backgroundColor = backgroundColor;
    
    return button;
}

/**
 *  初始化，背景图片
 *
 *  @param frame           大小
 *  @param target          对象
 *  @param action          事件
 *  @param backgroundImage 背景图片
 *
 *  @return 实例
 */
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action backgroundImage:(UIImage *)backgroundImage
{
    UIButton *button = [self private_buttonWithFrame:frame target:target action:action];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    return button;
}

/**
 *  初始化，文字
 *
 *  @param frame           大小
 *  @param target          对象
 *  @param action          事件
 *  @param title           标题
 *  @param titleColor      标题颜色
 *  @param font            字体
 *  @param backgroundColor 背景颜色
 *
 *  @return 实例
 */
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor
{
    UIButton *button = [self private_buttonWithFrame:frame target:target action:action];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.backgroundColor = backgroundColor;
    
    return button;
}

/**
 *  初始化，背景图 + 文字
 *
 *  @param frame           大小
 *  @param target          对象
 *  @param action          事件
 *  @param backgroundImage 背景图片
 *  @param title           标题
 *  @param titleColor      标题颜色
 *  @param font            字体
 *
 *  @return 实例
 */
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action backgroundImage:(UIImage *)backgroundImage title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font
{
    UIButton *button = [self private_buttonWithFrame:frame target:target action:action];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    return button;
}

/**
 *  初始化，图片 + 文字
 *
 *  @param frame      大小
 *  @param target     对象
 *  @param action     事件
 *  @param image      图片
 *  @param title      标题
 *  @param titleColor 标题颜色
 *  @param font       字体
 *
 *  @return 实例
 */
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action image:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font {
    UIButton *button = [self private_buttonWithFrame:frame target:target action:action];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    return button;
}

/**
 *  初始化，图片
 *
 *  @param frame  大小
 *  @param target 对象
 *  @param action 事件
 *  @param image  图片
 *
 *  @return 实例
 */
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action image:(UIImage *)image {
    UIButton *button = [self private_buttonWithFrame:frame target:target action:action];
    [button setImage:image forState:UIControlStateNormal];
    
    return button;
}

@end


#pragma mark - 不同状态的背景颜色

@implementation UIButton (BackgroundState)

/**
 *  设置不同状态的背景颜色，实际上是设置背景图片
 *
 *  @param backgroundColor 背景颜色
 *  @param state           不同状态
 */
- (void)lh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage lh_imageWithColor:backgroundColor] forState:state];
}

@end


