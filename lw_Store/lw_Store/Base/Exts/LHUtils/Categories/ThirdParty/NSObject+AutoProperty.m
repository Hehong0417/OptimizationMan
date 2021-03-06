//
//  NSObject+AutoProperty.m
//  RuntimeDemo
//
//  Created by 邱学伟 on 16/9/8.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "NSObject+AutoProperty.h"

@implementation NSObject (AutoProperty)
/**
 *  自动生成属性列表
 *
 *  @param dict JSON字典/模型字典
 */
+(void)printPropertyWithDict:(NSDictionary *)dict{
    NSMutableString *allPropertyCode = [[NSMutableString alloc]init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *oneProperty = [[NSString alloc]init];
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        }
        [allPropertyCode appendFormat:@"\n%@",oneProperty];
    }];
    NSLog(@"%@",allPropertyCode);
}
@end
