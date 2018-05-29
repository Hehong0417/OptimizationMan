//
//  UILabel+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LH)

/**
 *  初始化
 *
 *  @param frame           大小
 *  @param text            文本
 *  @param textColor       文本颜色
 *  @param font            字体
 *  @param textAlignment   文本对齐方式
 *  @param backgroundColor 背景颜色
 *
 *  @return 实例
 */
+ (UILabel *)lh_labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor;

/**
 *  创建自适应高度的label，frame的高度将会被忽略
 *
 *  @param frame         大小
 *  @param text          文本
 *  @param textColor     文本颜色
 *  @param font          字体
 *  @param textAlignment 文本对齐方式
 *
 *  @return 实例
 */
+ (UILabel *)lh_labelAdaptionWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

@end

#pragma mark - 对齐样式

@interface UILabel (VerticalAlign)

/**
 *  顶部对齐
 */
- (void)lh_alignTop;

/**
 *  底部对齐
 */
- (void)lh_alignBottom;

#pragma mark - 下划线

/**
   添加下划线

 @param content 内容
 @param rangeStr 需要添加下划线的内容
 */
- (NSMutableAttributedString *)lh_addUnderlineAtContent:(NSString *)content rangeStr:(NSString *)rangeStr color:(UIColor *)color;


@end
