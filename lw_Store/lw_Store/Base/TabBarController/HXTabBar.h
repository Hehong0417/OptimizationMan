//
//  HXTabBar.h
//  HXBudsProject
//
//  Created by n on 2017/3/22.
//  Copyright © 2017年 n. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXTabBar;

@protocol HXTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(HXTabBar *)tabBar;

@end


@interface HXTabBar : UITabBar

@property (nonatomic, weak) id<HXTabBarDelegate> customDelegate;


@end
