//
//  HHSetVC.m
//  lw_Store
//
//  Created by User on 2018/5/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSetVC.h"
#import "HHAboutUsVC.h"
#import "GFAddressPicker.h"

@interface HHSetVC ()
@property (nonatomic, strong)   GFAddressPicker *addressPick;
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
    return @[@[@""],@[@"",@""],@[@""]];

}
- (NSArray *)groupTitles{

    return @[@[@"会员所在地区"],@[@"关于我们",@"清除缓存"],@[@"小程序"]];
}
- (NSArray *)groupDetials{
    
    return @[@[@""],@[@"",@""],@[@""]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        //选择地址
        self.addressPick = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.addressPick.font = [UIFont systemFontOfSize:WidthScaleSize_H(19)];
        [self.addressPick showPickViewAnimation:YES];
        WEAK_SELF();
        self.addressPick.completeBlock = ^(NSString *result, NSString *district_id) {
            
            [weakSelf saveAddressWithDistrict_id:district_id result:result indexPath:indexPath];
            
        };
        
    }else if (indexPath.section == 1) {
    
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
    
   }else if (indexPath.section == 2) {
       //跳转小程序
       
       WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
       launchMiniProgramReq.userName = @"gh_48856d410d9e";  //拉起的小程序的username
       //        launchMiniProgramReq.path = path;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
       launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
       
       BOOL sucess =  [WXApi sendReq:launchMiniProgramReq];
       
       NSLog(@"sucess--%d",sucess);
       
   }
}
//保存地址
- (void)saveAddressWithDistrict_id:(NSString *)district_id result:(NSString *)result indexPath:(NSIndexPath *)indexPath{
    
    HJSettingItem *item = [self settingItemInIndexPath:indexPath];
    item.detailTitle = result;
    
    [[[HHMineAPI UpdateUserInfoOfCityWithRegionId:district_id] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                [self.tableV reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
        
    }];
    
}
@end
