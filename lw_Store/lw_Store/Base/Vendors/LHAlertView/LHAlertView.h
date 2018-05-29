//
//  LHAlertView.h
//  Transport
//
//  Created by IMAC on 15/12/8.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHAlertViewContentViewProtocol <NSObject>

@required

- (UIView *)alertViewContentView;

@end

/// 弹出视图
@interface LHAlertView : UIView <LHAlertViewContentViewProtocol>

/// 内容
@property (strong, nonatomic) UIView *contentView;

/// 是否启用动画
@property (assign, nonatomic) BOOL animated;

/**
 *  显示
 *
 *  @param animated 是否启用动画
 */
- (void)showAnimated:(BOOL)animated;

/**
 * 上移
 *
 *  @param animated 是否启用动画
 */
- (void)contentViewUpperShift:(BOOL)animated;

/**
 *  隐藏
 *
 *  @param completionBlock 完成block
 */
- (void)hideWithCompletion:(void(^)())completionBlock;


- (void)av_addSuperViews;
- (void)av_removeSubviews;

@end
