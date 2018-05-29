//
//  UserNoLoginManager.h
//  mengyaProject
//
//  Created by n on 2017/9/22.
//  Copyright © 2017年 n. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol UserNoLoginManagerDelegate <NSObject>

- (void)loginCompeleteRefresh;

@end

@interface UserNoLoginManager : NSObject

@property(nonatomic,strong) HJNavigationController  *nav;

@property(nonatomic,weak) id<UserNoLoginManagerDelegate>delegate;


+ (instancetype)shareManager;

- (UIAlertController *)showNologinAlertWithMessage:(NSString *)message;

- (UIAlertController *)showNologinAlertWithMessage:(NSString *)message completeBlock:(voidBlock)completeBlock;


@end
