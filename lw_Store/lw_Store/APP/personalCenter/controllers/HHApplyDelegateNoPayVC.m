//
//  HHApplyDelegateNoPayVC.m
//  lw_Store
//
//  Created by User on 2018/5/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHApplyDelegateNoPayVC.h"

@interface HHApplyDelegateNoPayVC ()

@end

@implementation HHApplyDelegateNoPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (NSArray *)groupTitles{
    
    return @[@[@"选择申请代理等级",@"申请人手机号",@"申请代理金额",@"申请状态"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@"",@"",@""]];
    
}
- (NSArray *)groupDetials{

    return @[@[@"一级代理",@"13826424459",[NSString stringWithFormat:@"¥%@",self.model.ApplyMoney],@"待付款"]];
}


@end
