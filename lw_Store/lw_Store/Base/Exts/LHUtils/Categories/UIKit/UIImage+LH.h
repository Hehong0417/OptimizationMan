//
//  UIImage+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LH)

/**
 *  截取图中某部分小图
 *
 *  @param rect 矩形区域
 *
 *  @return 截取的图片
 */
- (UIImage *)lh_captureImageWithRect:(CGRect)rect;

/**
 *  缩放图片
 *
 *  @param size 指定大小
 *
 *  @return 缩放后的图片
 */
- (UIImage *)lh_scaleToSize:(CGSize)size;

/**
 *  通过颜色返回图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *)lh_imageWithColor:(UIColor *)color;



/**
 通过图片名字返回图片

 @param name 名字
 @return 图片
 */
+ (UIImage *)lh_getContentImageWithName:(NSString *)name;


@end
