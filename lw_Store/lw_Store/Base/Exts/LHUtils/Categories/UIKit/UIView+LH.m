//
//  UIView+LH.m
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIView+LH.h"

@implementation UIView (LH)

/**
 *  初始化
 *
 *  @param rect      大小
 *  @param backColor 背景颜色
 *
 *  @return 实例
 */
+ (UIView *)lh_viewWithFrame:(CGRect)rect backColor:(UIColor *)backColor
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    return view;
}

/**
 *  将视图转为图片
 *
 *  @return 图片
 */
- (UIImage *)lh_toImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  拨打电话号码，弹出提示框
 *
 *  @param phoneNumber 电话号码
 *  @param view        指定视图
 */
- (void)telWithPhoneNumber:(NSString *)phoneNumber {
    NSString *str = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}

/**
 *  重设x起点
 *
 *  @param x        新的x坐标
 *  @param animated 是否允许动画
 */
- (void)lh_resetOriginX:(float)x animated:(BOOL)animated {
    CGRect rect = self.frame;
    rect.origin.x = x;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = rect;
        }];
    }
    else {
        self.frame = rect;
    }
}

/**
 *  重设y起点
 *
 *  @param y        新的y坐标
 *  @param animated 是否允许动画
 */
- (void)lh_resetOriginY:(float)y animated:(BOOL)animated {
    CGRect rect = self.frame;
    rect.origin.y = y;
    
    if(animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = rect;
        }];
    }
    else {
        self.frame = rect;
    }
}


@end


#pragma mark - 圆角

@implementation UIView (CornerRadius)

/**
 *  设置顶部两个圆角
 *
 *  @param radii 圆角大小
 */
- (void)lh_setUpRadii:(int)radii {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

/**
 *  设置底部两个圆角
 *
 *  @param radii 圆角大小
 */
- (void)lh_setDownRadii:(int)radii {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

/**
 *  设置左边两个圆角
 *
 *  @param radii 圆角大小
 */
- (void)lh_setLeftRadii:(int)radii {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}
/**
 *  设置右边两个圆角
 *
 *  @param radii 圆角大小
 */
- (void)lh_setRightRadii:(int)radii {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}
/**
 *  设置头像圆角
 *
 *
 */
- (void)lh_setRadii{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.bounds.size];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

/**
 *  设置4个圆角
 *
 */
- (void)lh_setRadii:(int)radii borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}


/**
 *  设置四个圆角大小，边框宽度，边框颜色，-1 和 nil表示不设置
 *
 *  @param cornerRadius      圆角大小
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
- (void)lh_setCornerRadius:(float)cornerRadius borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor {
    if (cornerRadius != -1) {
        self.layer.cornerRadius = cornerRadius;
    }
    if(borderWidth != -1) {
        self.layer.borderWidth = borderWidth;
    }
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
    
    self.layer.masksToBounds = YES;
}

- (CAShapeLayer *)lh_addStokeLineWithColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth lineCap:(NSString *)lineCap lineDashPattern:(NSArray *)lineDashPattern{

    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = strokeColor.CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = lineWidth;
    
    border.lineCap = lineCap;
    
    border.lineDashPattern = lineDashPattern;

    return border;
}

@end

#pragma mark - 阴影

@implementation UIView (Shadow)

/**

 周边加阴影，并且同时圆角
 */
- (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = CGRectMake(view.layer.frame.origin.x, view.layer.frame.origin.y, view.layer.frame.size.width, view.layer.frame.size.height);
    
    shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 5);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}
- (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadow_height:(CGFloat)shadow_height shadow_width:(CGFloat)shadow_width shadowOffset:(CGSize)shadowOffset{
    
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = CGRectMake(view.layer.frame.origin.x, view.layer.frame.origin.y, shadow_width, shadow_height);
    
    shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
    
}
@end

#pragma mark - 动画

@implementation UIView (Animation)

/**
 *  震动
 */
- (void)lh_shake {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}

@end


#pragma mark - 视图坐标扩展 -

@implementation UIView (ViewGeometry)

/**
 *  rect移动到中心点
 *
 *  @param rect   原矩形
 *  @param center 中心点
 *
 *  @return 新的矩形
 */
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x - CGRectGetMidX(rect);
    newrect.origin.y = center.y - CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

/// 坐标
- (CGPoint)lh_origin {
    return self.frame.origin;
}
- (void)setLh_origin:(CGPoint)lh_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = lh_origin;
    self.frame = newFrame;
}

// 大小
- (CGSize)lh_size {
    return self.frame.size;
}
- (void)setLh_size:(CGSize)lh_size {
    CGRect newFrame = self.frame;
    newFrame.size = lh_size;
    self.frame = newFrame;
}

/// x坐标
- (CGFloat)lh_left {
    return CGRectGetMinX(self.frame);
}
- (void)setLh_left:(CGFloat)lh_left {
    CGRect newFrame = self.frame;
    newFrame.origin.x = lh_left;
    self.frame = newFrame;
}

/// y坐标
- (CGFloat)lh_top{
    return CGRectGetMinY(self.frame);
}
- (void)setLh_top:(CGFloat)lh_top {
    CGRect newFrame = self.frame;
    newFrame.origin.y = lh_top;
    self.frame = newFrame;
}

/// 宽度
- (CGFloat)lh_width{
    return CGRectGetWidth(self.frame);
}
- (void)setLh_width:(CGFloat)lh_width {
    CGRect newFrame = self.frame;
    newFrame.size.width = lh_width;
    self.frame = newFrame;
}

/// 高度
- (CGFloat)lh_height{
    return CGRectGetHeight(self.frame);
}
- (void)setLh_height:(CGFloat)lh_height {
    CGRect rect = self.frame;
    rect.size.height = lh_height;
    self.frame = rect;
}

/// 右面
- (CGFloat)lh_right {
    return CGRectGetMaxX(self.frame);
}
- (void)setLh_right:(CGFloat)lh_right {
    CGFloat delta = lh_right - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

/// 下面
- (CGFloat)lh_bottom {
    return CGRectGetMaxY(self.frame);
}
- (void)setLh_bottom:(CGFloat)lh_bottom {
    CGRect newframe = self.frame;
    newframe.origin.y = lh_bottom - self.frame.size.height;
    self.frame = newframe;
}

/// y中心
- (CGFloat)lh_centerY {
    return CGRectGetMidY(self.frame);
}
- (void)setLh_centerY:(CGFloat)lh_centerY {
    CGPoint newCenter = self.center;
    newCenter.y = lh_centerY;
    self.center = newCenter;
}

/// 左下角
- (CGPoint)lh_bottomLeft {
    CGFloat x = CGRectGetMinX(self.frame);
    CGFloat y = CGRectGetMaxY(self.frame);
    return CGPointMake(x, y);
}

/// 右下角
- (CGPoint)lh_bottomRight {
    CGFloat x = CGRectGetMaxX(self.frame);
    CGFloat y = CGRectGetMaxY(self.frame);
    return CGPointMake(x, y);
}

/// 右上角
- (CGPoint)lh_topRight {
    CGFloat x = CGRectGetMaxX(self.frame);
    CGFloat y = CGRectGetMinY(self.frame);
    return CGPointMake(x, y);
}


/**
 *  根据传入的子视图与当前视图计算出水平中心开始点
 *
 *  @param subView 子视图
 *
 *  @return 水平中心开始点
 */
- (CGFloat)lh_centerHorizontalWithSubView:(UIView *)subView {
    return (self.lh_width - subView.lh_width) / 2;
}

/**
 *  根据传入的子视图与当前视图计算出垂直中心开始点
 *
 *  @param subView 子视图
 *
 *  @return 垂直中心开始点
 */
- (CGFloat)lh_centerVerticalWithSubView:(UIView *)subView {
    return (self.lh_height - subView.lh_height) / 2;
}

/**
 *  根据传入的子视图与当前视图计算出中心点
 *
 *  @param subView 子视图
 *
 *  @return 中心点
 */
- (CGPoint)lh_centerWithSubView:(UIView *)subView {
    return CGPointMake([self lh_centerHorizontalWithSubView:subView],[self lh_centerVerticalWithSubView:subView]);
}


/**
 *  居中增加子视图
 *
 *  @param subView 子视图
 */
- (void)lh_addSubViewToCenter:(UIView *)subView {
    CGRect rect = subView.frame;
    rect.origin = [self lh_centerWithSubView:subView];
    subView.frame = rect;
    [self addSubview:subView];
}

/**
 *  水平居中增加子视图
 *
 *  @param subView 子视图
 */
- (void)lh_addSubViewToHorizontalCenter:(UIView *)subView {
    CGRect rect = subView.frame;
    rect.origin.x = [self lh_centerHorizontalWithSubView:subView];
    subView.frame = rect;
    [self addSubview:subView];
}

/**
 *  垂直居中增加子视图
 *
 *  @param subView 子视图
 */
- (void)lh_addSubViewToVerticalCenter:(UIView *)subView {
    CGRect rect = subView.frame;
    rect.origin.y = [self lh_centerVerticalWithSubView:subView];
    subView.frame = rect;
    [self addSubview:subView];
}

@end


#pragma mark - 视图层次扩展 -

@implementation UIView (ZOrder)

/**
 *  获取当前视图在父视图中的索引
 *
 *  @return 索引值
 */
- (NSUInteger)lh_getSubviewIndex {
    return [self.superview.subviews indexOfObject:self];
}

/**
 *  将视图置于父视图最上面
 */
- (void)lh_bringToFront {
    [self.superview bringSubviewToFront:self];
}

/**
 *  将视图置于父视图最下面
 */
- (void)lh_sendToBack {
    [self.superview sendSubviewToBack:self];
}

/**
 *  视图层次上移一层
 */
- (void)lh_bringOneLevelUp
{
    int currentIndex = (int)[self lh_getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

/**
 *  视图层次下移一层
 */
- (void)lh_sendOneLevelDown {
    int currentIndex = (int)[self lh_getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

/**
 *  是否在最上面
 *
 *  @return 最上层视图 → YES
 */
- (BOOL)lh_isInFront {
    return [self.superview.subviews lastObject] == self;
}

/**
 *  是否在最下面
 *
 *  @return 最下层视图 → YES
 */
- (BOOL)lh_isAtBack {
    return [self.superview.subviews objectAtIndex:0] == self;
}

/**
 *  视图交换层次
 *
 *  @param swapView 交换的视图
 */
- (void)lh_swapDepthsWithView:(UIView *)swapView {
    [self.superview exchangeSubviewAtIndex:[self lh_getSubviewIndex] withSubviewAtIndex:[swapView lh_getSubviewIndex]];
}

@end
