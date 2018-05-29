//
//  HHGetAccess_TokenAPI.h
//  CredictCard
//
//  Created by User on 2017/12/22.
//  Copyright © 2017年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHUserLoginAPI : BaseAPI

#pragma mark - post

//登录
+ (instancetype)postApiLoginWithopenId:(NSString *)openId;
//注册
+ (instancetype)postRegsterWithopenId:(NSString *)openId name:(NSString *)name image:(NSString *)image unionId:(NSString *)unionId;
//手机号登录
+ (instancetype)postIOSAuthenticationLoginWithphone:(NSString *)phone psw:(NSString *)psw;

@end
