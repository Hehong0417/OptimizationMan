//
//  UIViewController+AOP.m
//  Bsh
//
//  Created by IMAC on 15/12/16.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "UIViewController+AOP.h"
#import <Aspects/Aspects.h>


@implementation UIViewController (AOP)

/**
 *  AOP返回按钮
 *
 *  @return button
 */
+ (XYQButton *)aopBackButton {
    
    XYQButton *backButton = [XYQButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 44)];
    UIImage *image = [UIImage imageNamed:@"icon_return_default"];
    [backButton setImage:image forState:UIControlStateNormal];
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    [backButton setTitleRectForContentRect:CGRectZero imageRectForContentRect:CGRectMake(-5, (backButton.lh_height-imageHeight)/2.0, imageWidth, imageHeight)];
    return backButton;
}
+ (void)load{

    //view did load
    [[self class] aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
        
        UIViewController *controller = [info instance];

        __weak UIViewController *weakController = controller;

        //导航栏返回按钮设置
        if ([NSStringFromClass([controller class]) hasPrefix:@"HH"] &&
            ![controller isKindOfClass:NSClassFromString(@"HHHomePageVC")] &&
            ![controller isKindOfClass:NSClassFromString(@"HHShoppingVC")] &&
            ![controller isKindOfClass:NSClassFromString(@"HHCartVC")] &&
            ![controller isKindOfClass:NSClassFromString(@"HJNavigationController")] &&
            ![controller isKindOfClass:NSClassFromString(@"HHPersenCenterVC")] &&
            ![controller isKindOfClass:NSClassFromString(@"HJTabBarController")]) {
         
            //Log 视图加载
//            DDLogInfo(@"%@-------------视图加载完毕------------",controller);
            
            //tableViewController尾部设置
            if ([controller isKindOfClass:[UITableViewController class]]) {
                
                ((UITableViewController *)controller).tableView.tableFooterView = [UIView new];
            }
            
            // 控制器背景颜色
            [controller.view setBackgroundColor:KVCBackGroundColor];
            
            __weak UIViewController *weakController = controller;
            // 返回按钮
            XYQButton * backButton = [self aopBackButton];
            [backButton bk_addEventHandler:^(id sender) {
                
                [weakController.navigationController popViewControllerAnimated:YES];

            } forControlEvents:UIControlEventTouchUpInside];
                        
            controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        }
        
        
    } error:NULL];

    //view will appear 导航栏隐藏控制
    [[self class] aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, BOOL animated) {
        
        UIViewController *controller = [info instance];
        
        if ([NSStringFromClass([controller class]) hasPrefix:@"HH"] && ([controller isKindOfClass:NSClassFromString(@"HHWXLoginVC")]||[controller isKindOfClass:NSClassFromString(@"HXVideoDetailVC")]||[controller isKindOfClass:NSClassFromString(@"HXTalentVideoDetailVC")]||[controller isKindOfClass:NSClassFromString(@"HXTeacherPersonCenterVC")]||[controller isKindOfClass:NSClassFromString(@"HXTeacherHomePageVC")]||[controller isKindOfClass:NSClassFromString(@"HXUserHomePageVC")])) {
            
            [controller.navigationController setNavigationBarHidden:YES animated:YES];
            
        }else if ([controller isKindOfClass:NSClassFromString(@"HXRecordVideoVC")]){
        
            UINavigationController *nav = (UINavigationController *)controller;
            
            [nav setNavigationBarHidden:YES animated:NO];
            
        }else {

            [controller.navigationController setNavigationBarHidden:NO animated:YES];
        }
        

   } error:NULL];
    
    //dealloc 观察控制器内存释放
    [[self class] aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
        
        UIViewController *controller = [info instance];
        
        if ([NSStringFromClass([controller class]) hasPrefix:@"HX"]) {
            
            //Log 控制器释放
//            DDLogInfo(@"%@-------------控制器释放完毕------------",controller);
        }
        
    } error:NULL];
}

/* Method Swizzling
 + (void)load {   static dispatch_once_t onceToken;  dispatch_once(&onceToken, ^{
 Class class = [self class];    // When swizzling a class method, use the following:
 // Class class = object_getClass((id)self);
 swizzleMethod(class, @selector(viewDidLoad), @selector(aop_viewDidLoad));
 swizzleMethod(class, @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
 swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
 swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
 });
 } void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)   {
 Method originalMethod = class_getInstanceMethod(class, originalSelector);
 Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);BOOL didAddMethod =
 class_addMethod(class,
 originalSelector,
 method_getImplementation(swizzledMethod),
 method_getTypeEncoding(swizzledMethod));if (didAddMethod) {
 class_replaceMethod(class,
 swizzledSelector,
 method_getImplementation(originalMethod),
 method_getTypeEncoding(originalMethod));
 } else {
 method_exchangeImplementations(originalMethod, swizzledMethod);
 }
 }
 - (void)aop_viewDidAppear:(BOOL)animated {
 [self aop_viewDidAppear:animated];
 
 
 }
 
 -(void)aop_viewWillAppear:(BOOL)animated {
 [self aop_viewWillAppear:animated];
 #ifndef DEBUG
 //    [MobClick beginLogPageView:NSStringFromClass([self class])];
 #endif
 }
 -(void)aop_viewWillDisappear:(BOOL)animated {
 [self aop_viewWillDisappear:animated];
 #ifndef DEBUG
 
 //    [MobClick endLogPageView:NSStringFromClass([self class])];
 #endif
 }
 - (void)aop_viewDidLoad {
 [self aop_viewDidLoad];
 if ([self isKindOfClass:[UINavigationController class]]) {
 UINavigationController *nav = (UINavigationController *)self;
 nav.navigationBar.translucent = NO;
 //        nav.navigationBar.barTintColor = GLOBAL_NAVIGATION_BAR_TIN_COLOR;
 nav.navigationBar.tintColor = [UIColor whiteColor];    NSDictionary *titleAtt = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
 [[UINavigationBar appearance] setTitleTextAttributes:titleAtt];
 [[UIBarButtonItem appearance]
 setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
 forBarMetrics:UIBarMetricsDefault];
 }
 //    self.view.backgroundColor = [UIColor whiteColor];self.navigationController.interactivePopGestureRecognizer.delegate = (id<uigesturerecognizerdelegate>)self;
 }
 */


@end
