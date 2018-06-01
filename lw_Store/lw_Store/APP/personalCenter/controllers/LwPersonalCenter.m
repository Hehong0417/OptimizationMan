//
//  PersenCenterVC.m
//  CredictCard
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#import "LwPersonalCenter.h"
#import "HXMineHeadView.h"
#import "LwPersonCenterCell.h"
#import "HHShippingAddressVC.h"
#import "HHMessageVC.h"
#import "HHFansListVC.h"
#import "HHCouponSuperVC.h"
#import "HHBargainingVC.h"
#import "HHMyIntegralListVC.h"
#import "HHMyCodeVC.h"
#import "HHApplyDelegateVC.h"
#import "HHnormalSuccessVC.h"
#import "HHSetVC.h"

@interface LwPersonalCenter ()
{
    UIButton *rightBtn;
}
@property(nonatomic,strong) HXMineHeadView *mineHeadView;
@property(nonatomic,strong) HHMineModel  *mineModel;
@property(nonatomic,strong) NSString  *usableComm;
@property(nonatomic,strong) NSString  *fanscount;
@property(nonatomic,strong) NSString  *saletotal;

@property(nonatomic,strong) NSNumber *isAgent;
@property(nonatomic,strong) NSNumber *isJoinAgent;
@property(nonatomic,strong) id obj;

@end

@implementation LwPersonalCenter

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

  _obj =  [[NSNotificationCenter defaultCenter] addObserverForName:KPersonCter_Refresh_Notification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
      
      [self getDatas];

      [[NSNotificationCenter defaultCenter]removeObserver:_obj];
      
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableV.tableHeaderView = self.mineHeadView;
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(setBtnAction) image:[UIImage imageNamed:@"no_message"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self getDatas];
    
    [self addHeadRefresh];
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableV.mj_header = refreshHeader;
}
- (void)setBtnAction{
    
//    HHModifyInfoVC *vc = [HHModifyInfoVC new];
//    vc.username = self.mineModel.username;
//    vc.userIcon = self.mineModel.usericon;
//    [self.navigationController pushVC:vc];
    HHMessageVC *vc = [HHMessageVC new];
    [self.navigationController pushVC:vc];
    
}
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (self.tableV.mj_header.isRefreshing) {
            [self.tableV.mj_header endRefreshing];
        }
        
        if (!error) {
            if (api.State == 1) {

                self.mineModel = [HHMineModel mj_objectWithKeyValues:api.Data[@"user"]];
                self.usableComm = api.Data[@"usableComm"];
                self.fanscount = api.Data[@"fanscount"];
                self.saletotal = api.Data[@"saletotal"];
                self.isAgent = api.Data[@"isAgent"];
                self.isJoinAgent = api.Data[@"isJoinAgent"];
                HJSettingItem *item = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                if (self.mineModel.ReferralUserName) {
                    item.title = [NSString stringWithFormat:@"您是由【%@】推荐的",self.mineModel.ReferralUserName];
                }
                self.isJoinAgent = api.Data[@"isJoinAgent"];
                if ([self.isAgent isEqual:@0]) {
                    HJSettingItem *item1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                    item1.detailTitle = [NSString stringWithFormat:@"%@   %@折",api.Data[@"userLevelName"],api.Data[@"userLevelDiscount"]];
                }else{
                HJSettingItem *item1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
                item1.detailTitle = [NSString stringWithFormat:@"%@   %@折",api.Data[@"userLevelName"],api.Data[@"userLevelDiscount"]];
                }
                self.mineHeadView.nameLabel.text = self.mineModel.UserName;
                self.mineHeadView.IDLabel.text = self.mineModel.Id?[NSString stringWithFormat:@"ID:%@",self.mineModel.Id]:@"";
                self.mineHeadView.titleLabel.text = self.mineModel.BuyTotal?[NSString stringWithFormat:@"累计:¥%@",self.mineModel.BuyTotal]:@"";
                [self.mineHeadView.teacherImageIcon sd_setImageWithURL:[NSURL URLWithString:self.mineModel.UserImage]];
                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
               [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    
    if (indexPath.section == 0 &&indexPath.row == 1) {
        LwPersonCenterCell *cell = [[LwPersonCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LwPersonCenterCell"];
        [cell setCellWithUsableComm:self.usableComm fanscount:self.fanscount saletotal:self.saletotal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nav = self.navigationController;
        gridCell = cell;
        
    }else{
    
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        gridCell = cell;
    }
    return gridCell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 &&indexPath.row == 1) {
        
        return WidthScaleSize_H(70);

    }
        return WidthScaleSize_H(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return WidthScaleSize_H(5);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        HHMyCodeVC *vc =[HHMyCodeVC  new];
        [self.navigationController pushVC:vc];
    }
    if (indexPath.section == 1) {
        
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
        vc.enter_type = HHenter_type_mine;
        [self.navigationController pushVC:vc];
        
    }else if (indexPath.section == 2&&indexPath.row==0){
        
          if ([self.isAgent isEqual:@1]) {
              if ([self.isJoinAgent isEqual:@1]) {
//                  已加入代理
                  HHnormalSuccessVC *vc = [HHnormalSuccessVC new];
                  vc.title_str = @"申请成功";
                  vc.discrib_str = @"";
                  vc.title_label_str = @"申请成功";
                  [self.navigationController pushVC:vc];
              }else{
                  HHApplyDelegateVC *vc = [HHApplyDelegateVC new];
                  [self.navigationController pushVC:vc];
              }
         }else{
             HHMyIntegralListVC *vc = [HHMyIntegralListVC new];
             [self.navigationController pushVC:vc];
         }
    }else if (indexPath.section == 2&&indexPath.row==1){
        if ([self.isAgent isEqual:@1]) {
        HHMyIntegralListVC *vc = [HHMyIntegralListVC new];
        [self.navigationController pushVC:vc];
        }
    }else if (indexPath.section == 3&&indexPath.row == 0){
        
  
    }else if (indexPath.section == 3&&indexPath.row == 1){
        
        HHBargainingVC  *vc =  [[HHBargainingVC alloc] initWithNibName:@"HHBargainingVC" bundle:nil];
        vc.vcType = bargaining_vcType;
        [self.navigationController pushVC:vc];

    }else if (indexPath.section == 3&&indexPath.row == 2){
        
        HHCouponSuperVC *vc = [HHCouponSuperVC new];
        [self.navigationController pushVC:vc];
      
    }else if (indexPath.section == 3&&indexPath.row == 3){
        
   
    }else if (indexPath.section == 3&&indexPath.row == 4){
        //设置
        HHSetVC *vc = [HHSetVC new];
        [self.navigationController pushVC:vc];
    }
    
}
- (NSArray *)groupTitles{
    
    if ([self.isAgent isEqual:@0]) {
        
        if (self.mineModel.ReferralUserName) {
                return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"设置"]];
            }else{
                return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"设置"]];
            }
    }
    if (self.mineModel.ReferralUserName) {

       return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"设置"]];
    }else{
        return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"设置"]];
    }

}
- (NSArray *)groupIcons {
    
    if ([self.isAgent isEqual:@0]) {
        if (self.mineModel.ReferralUserName) {
        return @[@[@"",@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""]];
        }else{
            return @[@[@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""]];
        }
    }
    if (self.mineModel.ReferralUserName) {
       return @[@[@"",@"",@""],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""]];
    }else{
        return @[@[@"",@""],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""]];
    }
}
- (NSArray *)groupDetials{
    if ([self.isAgent isEqual:@0]) {
        if (self.mineModel.ReferralUserName) {
        return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""]];
        }else{
            return @[@[@"推广二维码",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""]];
        }
    }else{
        if (self.mineModel.ReferralUserName) {
            return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""]];
        }else{
            return @[@[@"推广二维码",@" "],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""]];
        }
    }
}
- (NSArray *)indicatorIndexPaths{
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    
    return indexPaths;
}
- (HXMineHeadView *)mineHeadView {
    
    if (!_mineHeadView) {
        _mineHeadView = [[HXMineHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScaleSize_H(180)+WidthScaleSize_H(50))];
    }
    
    return _mineHeadView;
}



@end
