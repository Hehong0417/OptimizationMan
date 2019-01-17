//
//  HHActivityModel.m
//  lw_Store
//
//  Created by User on 2018/6/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHActivityModel.h"

@implementation HHActivityModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"JoinActivity": [HHJoinActivityModel class]};
}
@end

@implementation HHJoinActivityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"Id":@"id"};
}

@end

