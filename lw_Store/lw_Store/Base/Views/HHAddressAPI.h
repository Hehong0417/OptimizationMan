//
//  HHAddressAPI.h
//  Store
//
//  Created by User on 2018/1/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHAddressAPI : BaseAPI
//省份
+ (instancetype)GetProVince;
//获取城市或地区
+ (instancetype)GetChildsWithId:(NSString *)Id;
@end
