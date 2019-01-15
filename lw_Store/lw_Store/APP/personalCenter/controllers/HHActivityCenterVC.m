//
//  HHActivityCenterVC.m
//  lw_Store
//
//  Created by User on 2018/12/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHActivityCenterVC.h"
#import "HHWebVC.h"

@interface HHActivityCenterVC ()

@end

@implementation HHActivityCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"活动中心";
    self.tableV.separatorColor = LineLightColor;

}
- (NSArray *)groupTitles{
    
    return @[@[@"拼团商品",@"降价团商品",@"秒杀商品",@"砍价商品"]];
}
- (NSArray *)groupDetials{
    
    return @[@[@"",@"",@"",@""]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        //拼团
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"拼团";
        vc.url_str = [NSString stringWithFormat:@"%@/ActivityWeb/spellGroupGoodsList?cid=%@",API_HOST1,Cid];
        [self.navigationController pushVC:vc];
    }else if (indexPath.row == 1) {
        //降价团
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"降价团";
        vc.url_str = [NSString stringWithFormat:@"%@/Personal/CutGroup?cid=%@",API_HOST1,Cid];
        [self.navigationController pushVC:vc];
        
    }else if (indexPath.row == 2) {
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"秒杀";
        vc.url_str = [NSString stringWithFormat:@"%@/ActivityWeb/secKillGoodsList?cid=%@",API_HOST1,Cid];
        [self.navigationController pushVC:vc];
    }else if (indexPath.row == 3) {
        //砍价
        HHWebVC *vc = [HHWebVC new];
        vc.title_str = @"砍价";
        vc.url_str = [NSString stringWithFormat:@"%@/ActivityWeb/bargainGoodsList?cid=%@",API_HOST1,Cid];
        [self.navigationController pushVC:vc];
    }
}

@end
