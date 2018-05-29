//
//  UserNoLoginManager.m
//  mengyaProject
//
//  Created by n on 2017/9/22.
//  Copyright © 2017年 n. All rights reserved.
//

#import "UserNoLoginManager.h"

@implementation UserNoLoginManager

+ (instancetype)shareManager{

    static UserNoLoginManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manager = [[self alloc] init];
        
    });

    return _manager;
}
- (UIAlertController *)showNologinAlertWithMessage:(NSString *)message{
    
    return [self showNologinAlertWithMessage:message completeBlock:nil];

}


- (UIAlertController *)showNologinAlertWithMessage:(NSString *)message completeBlock:(voidBlock)completeBlock{
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
      
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    
    return alertC;

}

@end
