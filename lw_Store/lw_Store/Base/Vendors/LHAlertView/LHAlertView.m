//
//  LHAlertView.m
//  Transport
//
//  Created by IMAC on 15/12/8.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "LHAlertView.h"

@interface LHAlertView () <UIGestureRecognizerDelegate>


@end

@implementation LHAlertView

- (instancetype)init {

    if (self = [super init]) {
        [self setFrame:kMainScreenBounds];
        self.backgroundColor = rgba(0, 0, 0, 0.5);
        UIView *contentView = [self alertViewContentView];
        self.contentView = contentView;
        [self addSubview:contentView];
        //点击回收操作
        WEAK_SELF();
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
                       [weakSelf hideWithCompletion:NULL];

        }];

        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
         
         return NO;
     }
    
    return YES;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self defaulInit];
    }
    return self;   
}

- (void)defaulInit {
    UIView *backView = [UIView lh_viewWithFrame:self.bounds backColor:[UIColor colorWithWhite:0.3 alpha:0.3]];
    [self addSubview:backView];
    //点击回收操作
    WEAK_SELF();
    backView.userInteractionEnabled = YES;
    [backView setTapActionWithBlock:^{
        
        [weakSelf hideWithCompletion:NULL];
    }];
    UIView *contentView = [self alertViewContentView];
    self.contentView = contentView;
    [self addSubview:contentView];
}

#pragma  mark -  <LHAlertViewContentViewProtocol>
-(UIView *)alertViewContentView {
    
    return nil;
}
/**
 *  显示
 *
 *  @param animated 是否启用动画
 */
- (void)showAnimated:(BOOL)animated {
    NSAssert(self.contentView != nil, @"must have conetentView");
    
    self.animated = animated;
    
    [self av_addSuperViews];
    
    if (animated) {
        self.contentView.lh_top = self.lh_bottom;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.lh_bottom = self.lh_bottom;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
   上移
 @param animated 是否启用动画
 */
- (void)contentViewUpperShift:(BOOL)animated{

    self.animated = animated;

    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.lh_top = 75.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 *  隐藏
 *
 *  @param completionBlock 完成block
 */
- (void)hideWithCompletion:(void(^)())completionBlock {
    if (self.animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.lh_top = self.lh_bottom;
        } completion:^(BOOL finished) {
            [self av_removeSubviews];
            
            if (completionBlock) {
                completionBlock();
            }
        }];
    }
    else {
        [self av_removeSubviews];
        
        if (completionBlock) {
            completionBlock();
        }
    }
}

- (void)av_addSuperViews {
    [kKeyWindow addSubview:self];
//    [kKeyWindow addSubview:self.contentView];
}

- (void)av_removeSubviews {
    [self.contentView removeFromSuperview];
    [self removeFromSuperview];
//    self.contentView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
