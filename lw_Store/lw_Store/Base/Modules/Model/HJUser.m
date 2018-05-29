//
//  HJUser.m
//  Bsh
//
//  Created by IMAC on 15/12/25.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "HJUser.h"

#define kHJUserFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"HJUser"]

@implementation HJLoginModel


@end

@implementation HJUser

singleton_m(User)

- (instancetype)init {
    
    HJUser *localUser = [HJUser read];
    
    if (localUser) {
        _instance = localUser;
    } else {
        
        _instance = [super init];
    }
    
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    
    return copy;
}

//- (HJLoginModel *)userModel {
//    if (!_userModel) {
//        _userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kHJUserFilePath];
//    }
//    return _userModel;
//}
//
//- (void)setUserModel:(HJLoginModel *)userModel {
//    _userModel = userModel;
//    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:userModel toFile:kHJUserFilePath];
//    if (isSuccess) {
//        DDLogInfo(@"个人信息归档成功：%@", kHJUserFilePath);
//    }
//}


@end
