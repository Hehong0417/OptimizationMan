//
//  UIViewController+Create.h
//  StartUp4iPhone
//
//  Created by Ron on 14-2-24.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(Create)

+ (id)create;

+ (id)createFromStoryboardName:(NSString *)name WithIdentifier:(NSString *)identifier;

@end
