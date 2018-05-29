//
//  UIView+Utils.m
//  Borrowed from Three20
//
//  Copyright (c) 2013 iOS. No rights reserved.
//

#import "UIView+Utils.h"

#import <objc/runtime.h>

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerLongPressBlockKey;
static char kDTActionHandlerLongPressGestureKey;
static char KDTActionHandlerSwipeBlockKey;
static char KDTActionHandlerSwipeGestureKey;

@implementation UIView (Utils)


- (CGFloat)left_x {
    return self.frame.origin.x;
}



- (void)setLeft_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}



- (CGFloat)top_x {
    return self.frame.origin.y;
}



- (void)setTop_x:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}



- (CGFloat)right_x {
    return self.frame.origin.x + self.frame.size.width;
}



- (void)setRight_x:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}



- (CGFloat)bottom_x {
    return self.frame.origin.y + self.frame.size.height;
}



- (void)setBottom_x:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}



- (CGFloat)center_X {
    return self.center.x;
}



- (void)setCenter_X:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}



- (CGFloat)center_Y {
    return self.center.y;
}



- (void)setCenter_Y:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}



- (CGFloat)width_x {
    return self.frame.size.width;
}



- (void)setWidth_x:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}



- (CGFloat)height_x {
    return self.frame.size.height;
}



- (void)setHeight_x:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}



- (CGFloat)screen_x {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left_x;
    }
    return x;
}



- (CGFloat)screen_y {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top_x;
    }
    return y;
}



- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left_x;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}



- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top_x;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}



- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width_x, self.height_x);
}



- (CGPoint)origin {
    return self.frame.origin;
}



- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}



- (CGSize)size {
    return self.frame.size;
}



- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}



- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.height_x : self.width_x;
}



- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.width_x : self.height_x;
}



- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}



- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

-(void)exclusiveTouchForAllButtons
{
    for (UIView * subview in [self subviews]) {
        if([subview isKindOfClass:[UIButton class]])
            [((UIButton *)subview) setExclusiveTouch:YES];
        else if ([subview isKindOfClass:[UIView class]]){
            [subview exclusiveTouchForAllButtons];
        }
    }
}


- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}



- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0.0f, y = 0.0f;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left_x;
        y += view.top_x;
    }
    return CGPointMake(x, y);
}


- (void)setTapActionWithBlock:(void (^)(void))block
{
	UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
	if (!gesture)
	{
		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
    
	objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
		if (action)
		{
			action();
		}
	}
}

- (void)setLongPressActionWithBlock:(void (^)(void))block
{
	UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);
    
	if (!gesture)
	{
		gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
    
	objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);
        
		if (action)
		{
			action();
		}
	}
}

-(void)setSwipeActionWithBlock:(void (^)(void))block{
    UISwipeGestureRecognizer *gesture = objc_getAssociatedObject(self, &KDTActionHandlerSwipeGestureKey);
    
    if (!gesture) {
        gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForSwipeGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &KDTActionHandlerSwipeGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &KDTActionHandlerSwipeBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForSwipeGesture:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        void(^action)(void) = objc_getAssociatedObject(self, &KDTActionHandlerSwipeBlockKey);
        
        if (action) {
            action();
        }
    }
}
@end
