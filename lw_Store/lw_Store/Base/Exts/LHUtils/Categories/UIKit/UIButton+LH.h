//
//  UIButton+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LH)

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
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action backgroundColor:(UIColor *)backgroundColor;

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
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action backgroundImage:(UIImage *)backgroundImage;

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
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor;

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
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action backgroundImage:(UIImage *)backgroundImage title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

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
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action image:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

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
+ (UIButton *)lh_buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action image:(UIImage *)image;

@end


#pragma mark - 不同状态的背景颜色

@interface UIButton (BackgroundState)

/**
 *  设置不同状态的背景颜色，实际上是设置背景图片
 *
 *  @param backgroundColor 背景颜色
 *  @param state           不同状态
 */
- (void)lh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end


