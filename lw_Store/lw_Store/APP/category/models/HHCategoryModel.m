//
//  HHCategoryModel.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCategoryModel.h"

@implementation HHCategoryModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"sub_category": [HHsub_categoryModel class]};
}

@end
@implementation HHsub_categoryModel

@end
