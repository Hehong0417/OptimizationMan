//
//  UIImage+LH.m
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIImage+LH.h"

@implementation UIImage (LH)

/**
 *  截取图中某部分小图
 *
 *  @param rect 矩形区域
 *
 *  @return 截取的图片
 */
- (UIImage *)lh_captureImageWithRect:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    
    CGSize size = CGSizeMake(rect.size.width, rect.size.height);
    
    // 创建一个新图像上下文
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, rect, subImageRef);
    
    //    CGImageRelease(imageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}

/**
 *  缩放图片
 *
 *  @param size 指定大小
 *
 *  @return 缩放后的图片
 */
- (UIImage *)lh_scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context，并把它设置成为当前正在使用的context
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
//等比例压缩
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    
        UIImage *newImage = nil;
    
        CGSize imageSize = sourceImage.size;
    
        CGFloat width = imageSize.width;
    
        CGFloat height = imageSize.height;
    
        CGFloat targetWidth = size.width;
    
        CGFloat targetHeight = size.height;
    
        CGFloat scaleFactor = 0.0;
    
        CGFloat scaledWidth = targetWidth;
    
        CGFloat scaledHeight = targetHeight;
    
        CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
        if(CGSizeEqualToSize(imageSize, size) == NO){
        
                CGFloat widthFactor = targetWidth / width;
        
                CGFloat heightFactor = targetHeight / height;
        
                if(widthFactor > heightFactor){
            
                        scaleFactor = widthFactor;
            
                    }
        
                else{
            
                        scaleFactor = heightFactor;
            
                    }
        
                scaledWidth = width * scaleFactor;
        
                scaledHeight = height * scaleFactor;
        
                if(widthFactor > heightFactor){
            
                        thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
                    }else if(widthFactor < heightFactor){
                
                            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                
                        }
        
            }
    
        
    
        UIGraphicsBeginImageContext(size);
    
        
    
        CGRect thumbnailRect = CGRectZero;
    
        thumbnailRect.origin = thumbnailPoint;
    
        thumbnailRect.size.width = scaledWidth;
    
        thumbnailRect.size.height = scaledHeight;
    
        [sourceImage drawInRect:thumbnailRect];
    
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    
        
    
        if(newImage == nil){
        
                NSLog(@"scale image fail");
        
            }
    
        
    
        UIGraphicsEndImageContext();
    
        
    
        return newImage;
     
    
}
+ (UIImage *)lh_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(UIImage *)lh_getContentImageWithName:(NSString *)name{

    NSString *path   = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    
    return [UIImage imageWithContentsOfFile:path];
}
@end
