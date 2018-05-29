//
//  HJStoryBoardItem.m
//  Apws
//
//  Created by zhipeng-mac on 15/12/21.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "HJStoryBoardItem.h"

@implementation HJStoryBoardItem

+ (instancetype)itemWithStroyBoardName:(NSString *)storyBoardName identifier:(NSString *)identifier viewControllerNonExist:(BOOL)viewControllerNonExist{
    
    HJStoryBoardItem *item = [[HJStoryBoardItem alloc]init];
    
    item.storyBoardName = storyBoardName;
    item.Identifier = identifier;
    item.viewControllerNonExist = viewControllerNonExist;
    
    return item;
}

@end
