//
//  SMNavigationViewController.h
//  ShopingMall
//
//  Created by zhipeng-mac on 15/9/30.
//  Copyright (c) 2015年 zhipeng-mac. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  @author hejing
 *
 *  跳转时animated默认为YES
 */

@interface UINavigationController (Extension)


- (void)pushViewControllerWithStoryBoardName:(NSString *)storyBoardName identifier:(NSString *)identifier;

- (void)pushVC:(UIViewController *)viewController;

- (void)popVC;

- (void)popToVC:(UIViewController *)viewController;

- (void)popToRootVC;

@end

@interface HJNavigationController : UINavigationController


//**************视频屏幕旋转相关********************//


@property (strong ,nonatomic) NSMutableArray *arrayScreenshot;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;


//**********************************************//



+ (void)setupNavigationBarTheme ;

@end
