//
//  HXTabBar.m
//  HXBudsProject
//
//  Created by n on 2017/3/22.
//  Copyright © 2017年 n. All rights reserved.
//

#define kTabBarItemCount 5

#import "HXTabBar.h"

@implementation HXTabBar

- (void)layoutSubviews{

    [super layoutSubviews];
    
    NSInteger count = kTabBarItemCount;
    // 1.设置加号按钮的位置
    CGFloat midBtnViewWidth = self.width / count;
    CGFloat midBtnViewHeight = self.height;
    CGFloat midBtnViewX = (self.width - midBtnViewWidth) * 0.5;
    CGFloat midBtnViewY = 0;

    UIButton *plusBtn = [UIButton lh_buttonWithFrame:CGRectMake(midBtnViewX, midBtnViewY, midBtnViewWidth, midBtnViewHeight) target:self action:@selector(plusBtnAction) image:[UIImage imageNamed:@"center"]];
    [self addSubview:plusBtn];
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.width / count;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        
        Class clas = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:clas]) {
            // 设置x
            child.mj_x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == count - 3) {
                tabBarButtonIndex++;
            }
        }
    }


}

/**
 *  加号按钮点击
 */
- (void)plusBtnAction
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.customDelegate tabBarDidClickPlusButton:self];
    }
}

@end
