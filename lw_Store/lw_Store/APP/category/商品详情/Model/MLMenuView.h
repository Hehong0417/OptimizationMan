//
//  MLMenuView.h
//  MLMenuDemo
//
//  Created by 戴明亮 on 2018/4/20.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHActivityModel.h"

@class MLMenuView;

@protocol MLMenuViewDelegate <NSObject>
- (void)didselectItemIndex:(NSInteger)index;
@end

typedef NS_ENUM(NSInteger,MLEnterAnimationStyle) {
    MLEnterAnimationStyleNone,
    MLEnterAnimationStyleRight,
    MLEnterAnimationStyleTop,
};

typedef void(^MLDidSelectBlock)(NSInteger index ,HHActivityModel *model);

@interface MLMenuView : UIView


/**
 MenuView 构造器 带有三角形的菜单

 @param frame 位置
 @param modelsArr 模型数组 必传

 @return MenuView
 */
- (instancetype)initWithFrame:(CGRect)frame WithmodelsArr:(NSArray *)modelsArr WithMenuViewOffsetTop:(CGFloat)top WithTriangleOffsetLeft:(CGFloat)left;

/**
 设置背景颜色

 @param backgroundColor backgroundColor description
 */
- (void)setMenuViewBackgroundColor:(UIColor *)backgroundColor;

/**
 设置蒙版层视图颜色

 @param backgroundColor backgroundColor description
 */
- (void)setCoverViewBackgroundColor:(UIColor *)backgroundColor;


@property (nonatomic, weak) id <MLMenuViewDelegate>delegate;


/**
 选中item block 回调
 */
@property (nonatomic, copy) MLDidSelectBlock didSelectBlock;

/**
 设置标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 设置字体大小
 */

@property (nonatomic, strong) UIFont *font;

//
@property (nonatomic, assign) BOOL isHasTriangle;

/**
 线条颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 标题数组
 */
@property (nonatomic, strong) NSArray *titles;


/**
 图片数组
 */
@property (nonatomic, strong) NSArray *imageNames;

/**
 呈现菜单
 */
- (void)showMenuEnterAnimation:(MLEnterAnimationStyle)animationStyle;

/**
 隐藏菜单
 */
- (void)hidMenuExitAnimation:(MLEnterAnimationStyle)animationStyle;

@end
