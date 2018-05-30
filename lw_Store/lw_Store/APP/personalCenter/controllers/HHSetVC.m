//
//  HHSetVC.m
//  lw_Store
//
//  Created by User on 2018/5/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSetVC.h"
#import "HHAboutUsVC.h"

@interface HHSetVC ()

@end

@implementation HHSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"设置";

    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(exitAction:) backgroundImage:nil title:@"退出登录"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = kBlackColor;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableV.tableFooterView = footView;
    
    
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    CGFloat M = size/1024/1024;
    HJSettingItem *item = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    item.detailTitle = [NSString stringWithFormat:@"%.2fM",M];
   
}
//退出登录
- (void)exitAction:(UIButton *)btn{
    
    HJUser *user = [HJUser sharedUser];
    user.token = nil;
    [user write];
    
    kKeyWindow.rootViewController = [[HJNavigationController alloc] initWithRootViewController:[HHWXLoginVC new]];
    
}
- (NSArray *)groupIcons{
    return @[@[],@[@"",@""]];

}
- (NSArray *)groupTitles{

    return @[@[],@[@"关于我们",@"清除缓存"]];
}
- (NSArray *)groupDetials{
    
    return @[@[],@[@"",@""]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HHAboutUsVC *vc = [HHAboutUsVC new];
        [self.navigationController pushVC:vc];
        
    }else{
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            HJSettingItem *item = [self settingItemInIndexPath:indexPath];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            item.detailTitle = [NSString stringWithFormat:@"0.00M"];
            [self.tableV reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertC dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }
    
}
@end
