//
//  HHBaseTableViewVC.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBaseTableViewVC.h"

@interface HHBaseTableViewVC ()

@end

@implementation HHBaseTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
