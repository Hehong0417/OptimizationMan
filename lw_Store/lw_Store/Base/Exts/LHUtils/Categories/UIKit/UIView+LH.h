//
//  UIView+LH.h
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LH)

/**
 *  初始化
 *
 *  @param rect      大小
 *  @param backColor 背景颜色
 *
 *  @return 实例
 */
+ (UIView *)lh_viewWithFrame:(CGRect)rect backColor:(UIColor *)backColor;

/**
 *  将视图转为图片
 *
 *  @return 图片
 */
- (UIImage *)lh_toImage;

/**
 *  拨打电话号码，弹出提示框
 *
 *  @param phoneNumber 电话号码
 */
- (void)telWithPhoneNumber:(NSString *)phoneNumber;

/**
 *  重设x起点
 *
 *  @param x        新的x坐标
 *  @param animated 是否允许动画
 */
- (void)lh_resetOriginX:(float)x animated:(BOOL)animated;

/**
 *  重设y起点
 *
 *  @param y        新的y坐标
 *  @param animated 是否允许动画
 */
- (void)lh_resetOriginY:(float)y animated:(BOOL)animated;


@end


#pragma mark - 圆角

@interface UIView (CornerRadius)

/**
 *  设置顶部两个圆角
 *
 *  @param radii 圆角大小
 */
- (void)lh_setUpRadii:(int)radii;

/**
 *  设置底部两个圆角
 *
 *  @param radii 圆角大小
 */
- (void)lh_setDownRadii:(int)radii;



/**
  设置左边两个圆角
 @param radii 圆角大小
 */
- (void)lh_setLeftRadii:(int)radii;



/**
 设置右边两个圆角

 @param radii 圆角大小
 */
- (void)lh_setRightRadii:(int)radii;



/**
 *  设置头像圆角
 *
 *  @param radii 圆角大小
 */
- (void)lh_setRadii;


/**
 *  设置4个圆角
 *
 *
 */
- (void)lh_setRadii:(int)radii borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  设置四个圆角大小，边框宽度，边框颜色，-1 和 nil表示不设置
 *
 *  @param Radius      圆角大小
 *  @param Width 边框宽度
 *  @param BorderColor 边框颜色
 */
- (void)lh_setCornerRadius:(float)Radius borderWidth:(float)Width borderColor:(UIColor *)BorderColor;


/**
 设置虚线框
 
 @param lineWidth 线框
 @param lineCap 虚线形状
 @param lineDashPattern  lineDashPattern description
 */
- (CAShapeLayer *)lh_addStokeLineWithColor:(UIColor *)strokerColor lineWidth:(CGFloat)lineWidth lineCap:(NSString *)lineCap lineDashPattern:(NSArray *)lineDashPattern;


@end

#pragma mark -  阴影

@interface UIView (Shadow)

/**
 *  阴影
 */
- (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor;

- (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadow_height:(CGFloat)shadow_height shadow_width:(CGFloat)shadow_width shadowOffset:(CGSize)shadowOffset;
@end


#pragma mark - 动画

@interface UIView (Animation)

/**
 *  震动
 */
- (void)lh_shake;

@end


#pragma mark - 视图坐标扩展

@interface UIView (ViewFrameGeometry)

/**
 *  rect移动到中心点
 *
 *  @param rect   原矩形
 *  @param center 中心点
 *
 *  @return 新的矩形
 */
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

/// 坐标
@property (assign, nonatomic) CGPoint lh_origin;
/// 大小
@property (assign, nonatomic) CGSize lh_size;

/// x坐标
@property (assign, nonatomic) CGFloat lh_left;
/// y坐标
@property (assign, nonatomic) CGFloat lh_top;
/// 宽度
@property (assign, nonatomic) CGFloat lh_width;
/// 高度
@property (assign, nonatomic) CGFloat lh_height;

/// 右面
@property (assign, nonatomic) CGFloat lh_right;
/// 下面
@property (assign, nonatomic) CGFloat lh_bottom;

/// y中心
@property (assign, nonatomic) CGFloat lh_centerY;

/// 左下角
@property (assign, nonatomic, readonly) CGPoint lh_bottomLeft;
/// 右下角
@property (assign, nonatomic, readonly) CGPoint lh_bottomRight;
/// 右上角
@property (assign, nonatomic, readonly) CGPoint lh_topRight;


/**
 *  根据传入的子视图与当前视图计算出水平中心开始点
 *
 *  @param subView 子视图
 *
 *  @return 水平中心开始点
 */
- (CGFloat)lh_centerHorizontalWithSubView:(UIView *)subView;

/**
 *  根据传入的子视图与当前视图计算出垂直中心开始点
 *
 *  @param subView 子视图
 *
 *  @return 垂直中心开始点
 */
- (CGFloat)lh_centerVerticalWithSubView:(UIView *)subView;

/**
 *  根据传入的子视图与当前视图计算出中心点
 *
 *  @param subView 子视图
 *
 *  @return 中心点
 */
- (CGPoint)lh_centerWithSubView:(UIView *)subView;


/**
 *  居中增加子视图
 *
 *  @param subView 子视图
 */
- (void)lh_addSubViewToCenter:(UIView *)subView;

/**
 *  水平居中增加子视图
 *
 *  @param subView 子视图
 */
- (void)lh_addSubViewToHorizontalCenter:(UIView *)subView;

/**
 *  垂直居中增加子视图
 *
 *  @param subView 子视图
 */
- (void)lh_addSubViewToVerticalCenter:(UIView *)subView;

@end



#pragma mark - 视图层次扩展 -

@interface UIView (ZOrder)

/**
 *  获取当前视图在父视图中的索引
 *
 *  @return 索引值
 */
- (NSUInteger)lh_getSubviewIndex;

/**
 *  将视图置于父视图最上面
 */
- (void)lh_bringToFront;

/**
 *  将视图置于父视图最下面
 */
- (void)lh_sendToBack;

/**
 *  视图层次上移一层
 */
- (void)lh_bringOneLevelUp;

/**
 *  视图层次下移一层
 */
- (void)lh_sendOneLevelDown;

/**
 *  是否在最上面
 *
 *  @return 最上层视图 → YES
 */
- (BOOL)lh_isInFront;

/**
 *  是否在最下面
 *
 *  @return 最下层视图 → YES
 */
- (BOOL)lh_isAtBack;

/**
 *  视图交换层次
 *
 *  @param swapView 交换的视图
 */
- (void)lh_swapDepthsWithView:(UIView*)swapView;

@end
