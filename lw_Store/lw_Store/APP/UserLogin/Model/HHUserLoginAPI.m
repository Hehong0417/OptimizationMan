//
//  HHGetAccess_TokenAPI.m
//  CredictCard
//
//  Created by User on 2017/12/22.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHUserLoginAPI.h"

@implementation HHUserLoginAPI


//登录
+ (instancetype)postApiLoginWithopenId:(NSString *)openId{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_Login;
    api.parametersAddToken = NO;
    if (openId) {
        [api.parameters setObject:openId forKey:@"openId"];
    }
    [api.parameters setObject:@"4" forKey:@"type"];

    return api;
}
//注册
+ (instancetype)postRegsterWithopenId:(NSString *)openId name:(NSString *)name image:(NSString *)image unionId:(NSString *)unionId{
    
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_Register;
    api.parametersAddToken = NO;
    if (openId) {
        [api.parameters setObject:openId forKey:@"openId"];
    }
    if (name) {
        [api.parameters setObject:name forKey:@"name"];
    }
    if (image) {
        [api.parameters setObject:image forKey:@"image"];
    }
    if (unionId) {
        [api.parameters setObject:unionId forKey:@"unionId"];
    }
    [api.parameters setObject:@"4" forKey:@"type"];
    [api.parameters setObject:Cid forKey:@"cid"];

    return api;
    
}
//手机号登录
+ (instancetype)postIOSAuthenticationLoginWithphone:(NSString *)phone psw:(NSString *)psw{
    HHUserLoginAPI *api = [self new];
    api.subUrl = API_PhoneLogin;
    api.parametersAddToken = NO;
    if (phone) {
        [api.parameters setObject:phone forKey:@"phone"];
    }
    if (psw) {
        [api.parameters setObject:psw forKey:@"psw"];
    }
    [api.parameters setObject:Cid forKey:@"cid"];

    return api;
}
@end
