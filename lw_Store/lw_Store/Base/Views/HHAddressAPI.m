//
//  HHAddressAPI.m
//  Store
//
//  Created by User on 2018/1/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAddressAPI.h"

@implementation HHAddressAPI

//省份
+ (instancetype)GetProVince{
    HHAddressAPI *api = [self new];
    api.subUrl = API_GetProvinces;
    api.parametersAddToken = NO;
    return api;
}
//获取城市或地区
+ (instancetype)GetChildsWithId:(NSString *)Id{
    HHAddressAPI *api = [self new];
    api.subUrl = API_GetChilds;
    if (Id) {
        [api.parameters setObject:Id forKey:@"pId"];
    }
    api.parametersAddToken = NO;
    return api;
}
@end
