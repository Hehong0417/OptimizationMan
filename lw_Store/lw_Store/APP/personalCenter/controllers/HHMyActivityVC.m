//
//  HHMyActivityVC.m
//  lw_Store
//
//  Created by User on 2018/12/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyActivityVC.h"
#import "HHMyActivityWebVC.h"
#import "HHMySaleGroupWebVC.h"
#import "HHMySendGiftWebVC.h"
#import "HHGiftTVC.h"

@interface HHMyActivityVC ()

@end

@implementation HHMyActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的活动";
    self.tableV.separatorColor = LineLightColor;
}
- (NSArray *)groupTitles{
    
    return @[@[@"我的拼团",@"我的降价团",@"我的送礼",@"赠品列表"]];
}
- (NSArray *)groupDetials{
    
    return @[@[@"",@"",@"",@""]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        //拼团
        HHMyActivityWebVC *vc = [HHMyActivityWebVC new];
        [self.navigationController pushVC:vc];
    }else if (indexPath.row == 1) {
        //降价团
        HHMySaleGroupWebVC *vc = [HHMySaleGroupWebVC new];
        [self.navigationController pushVC:vc];
        
    }else if (indexPath.row == 2) {
        //送礼
        HHMySendGiftWebVC *vc = [HHMySendGiftWebVC new];
        [self.navigationController pushVC:vc];
    }else if (indexPath.row == 3) {
        //赠品
        HHGiftTVC *vc = [HHGiftTVC new];
        [self.navigationController pushVC:vc];
    }

}
@end
