//
//  HHUserInfoModel.m
//  lw_Store
//
//  Created by User on 2018/12/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHUserInfo.h"

@implementation HHUserInfo

singleton_m(UserInfo)
- (instancetype)init {
    
    HHUserInfo *localUser = [HHUserInfo read];
    
    if (localUser) {
        _instance = localUser;
    }else {
        _instance = [super init];
    }
    
    return _instance;
}

@end
@implementation HHUserModel

@end

