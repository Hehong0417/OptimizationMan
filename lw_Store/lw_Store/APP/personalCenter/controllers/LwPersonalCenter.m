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
#import "HHMyIntegralListVC.h"
#import "HHMyCodeVC.h"
#import "HHApplyDelegateVC.h"
#import "HHnormalSuccessVC.h"
#import "HHSetVC.h"
#import "HHMyActivityWebVC.h"
#import "HHMySaleGroupWebVC.h"
#import "HHMySendGiftWebVC.h"
#import "HHExtraBonusVC.h"

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
@property(nonatomic,strong) NSNumber *isExtraBonus;

@end

@implementation LwPersonalCenter

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

  _obj =  [[NSNotificationCenter defaultCenter] addObserverForName:KPersonCter_Refresh_Notification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
      
      [self getDatas];
      [[NSNotificationCenter defaultCenter]removeObserver:_obj];
      
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:_obj];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableV.tableHeaderView = self.mineHeadView;
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 60, 44) target:self action:@selector(setBtnAction) image:[UIImage imageNamed:@"no_message"]];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -15)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self getDatas];
    
    [self addHeadRefresh];
}
#pragma mark - 刷新控件
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableV.mj_header = refreshHeader;
}
- (void)setBtnAction{
    
    HHMessageVC *vc = [HHMessageVC new];
    [self.navigationController pushVC:vc];
    
}
#pragma mark - 获取数据
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
                self.isExtraBonus = api.Data[@"isExtraBonus"];

                [self setGroups];
                
                if ([self.isAgent isEqual:@1]) {
                    if ([self.isJoinAgent isEqual:@1]) {
                        //已申请
                        HJSettingItem *item0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                        item0.detailTitle = self.mineModel.Points;
                        HJSettingItem *item1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                        item1.detailTitle = [NSString stringWithFormat:@"%@   %@折",api.Data[@"userLevelName"],api.Data[@"userLevelDiscount"]];
                    }else{
                        HJSettingItem *item0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                        item0.detailTitle = self.mineModel.Points;
                        HJSettingItem *item1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
                        item1.detailTitle = [NSString stringWithFormat:@"%@   %@折",api.Data[@"userLevelName"],api.Data[@"userLevelDiscount"]];
                    }
                }else{
                    HJSettingItem *item0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                    item0.detailTitle = self.mineModel.Points;
                    
                    HJSettingItem *item1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                    item1.detailTitle = [NSString stringWithFormat:@"%@   %@折",api.Data[@"userLevelName"],api.Data[@"userLevelDiscount"]];
                    
                }
                HJSettingItem *item = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                if (self.mineModel.ReferralUserName) {
                    item.title = [NSString stringWithFormat:@"您是由【%@】推荐的",self.mineModel.ReferralUserName];
                }
                self.mineHeadView.nameLabel.text = self.mineModel.UserName;
                self.mineHeadView.IDLabel.text = self.mineModel.Id?[NSString stringWithFormat:@"ID:%@",self.mineModel.Id]:@"";
                self.mineHeadView.titleLabel.text = self.mineModel.BuyTotal?[NSString stringWithFormat:@"累计:¥%.2f",self.mineModel.BuyTotal.floatValue]:@"0.00";
                [self.mineHeadView.teacherImageIcon sd_setImageWithURL:[NSURL URLWithString:self.mineModel.UserImage] placeholderImage:nil];
                [self.tableV reloadData];
                
                NSNumber  *hasUnReadyMessage = api.Data[@"hasUnReadyMessage"];
                if ([hasUnReadyMessage isEqual:@1]) {
                    [rightBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
                }else{
                    [rightBtn setImage:[UIImage imageNamed:@"no_message"] forState:UIControlStateNormal];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
               [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
#pragma mark - tableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    
    if (indexPath.section == 0 &&indexPath.row == 1) {
        LwPersonCenterCell *cell = [[LwPersonCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LwPersonCenterCell"];
        [cell setCellWithUsableComm:self.usableComm fanscount:self.fanscount saletotal:[NSString stringWithFormat:@"%.2f",self.saletotal.floatValue]];
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
                  HHMyIntegralListVC *vc = [HHMyIntegralListVC new];
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
        HHMyActivityWebVC *vc = [HHMyActivityWebVC new];
        [self.navigationController pushVC:vc];
  
    }else if (indexPath.section == 3&&indexPath.row == 1){
        HHMySaleGroupWebVC *vc = [HHMySaleGroupWebVC new];
        [self.navigationController pushVC:vc];

    }else if (indexPath.section == 3&&indexPath.row == 2){
        
        HHCouponSuperVC *vc = [HHCouponSuperVC new];
        [self.navigationController pushVC:vc];
      
    }else if (indexPath.section == 3&&indexPath.row == 3){
        
        HHMySendGiftWebVC *vc = [HHMySendGiftWebVC new];
        [self.navigationController pushVC:vc];
    
    }else if (indexPath.section == 3&&indexPath.row == 4){
     //额外奖励
        HHExtraBonusVC *vc = [HHExtraBonusVC new];
        [self.navigationController pushVC:vc];

    }else if (indexPath.section == 4){
        
        //设置
        HHSetVC *vc = [HHSetVC new];
        [self.navigationController pushVC:vc];
    }
    
}
#pragma mark - 控制器设置

- (NSArray *)groupTitles{

    if ([self.isAgent isEqual:@1]) {
        //************************//
        if ([self.isJoinAgent isEqual:@1]) {
            //已申请
            if (self.mineModel.ReferralUserName) {
                
                if ([self.isExtraBonus isEqual:@1]) {
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"额外奖励"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼"],@[@"设置"]];
                }
                
            }else{
                if ([self.isExtraBonus isEqual:@1]) {
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"额外奖励"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼"],@[@"设置"]];
                }
            }
            
            
        }else{
            
            if (self.mineModel.ReferralUserName) {
                
                if ([self.isExtraBonus isEqual:@1]) {
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价 团",@"优惠券",@"送礼",@"额外奖励"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼"],@[@"设置"]];
                }
                
            }else{
                if ([self.isExtraBonus isEqual:@1]) {
                    
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"额外奖励"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼"],@[@"设置"]];
                }
            }
            
        }
        //************************//
      
    }else{
        //**********
        if (self.mineModel.ReferralUserName) {
            if ([self.isExtraBonus isEqual:@1]) {
                return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"额外奖励"],@[@"设置"]];
            }else{
                return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼"],@[@"设置"]];
            }
            
        }else{
            if ([self.isExtraBonus isEqual:@1]) {
                return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼",@"额外奖励"],@[@"设置"]];
                
            }else{
                return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"优惠券",@"送礼"],@[@"设置"]];
                
            }
            
        }
        //***************
    }

}
- (NSArray *)groupIcons {
    
    if ([self.isAgent isEqual:@1]) {
        //********************//
        if ([self.isJoinAgent isEqual:@1]) {
            //已申请
            if (self.mineModel.ReferralUserName) {
                
                return @[@[@"",@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }else{
                return @[@[@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }
            
        }else{
            if (self.mineModel.ReferralUserName) {
                return @[@[@"",@"",@""],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }else{
                return @[@[@"",@""],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }
        }
        //********************//
        
    }else{
        //********************//
        if (self.mineModel.ReferralUserName) {
            return @[@[@"",@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
        }else{
            return @[@[@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
        }
        //********************//
    }

}
- (NSArray *)groupDetials{
    if ([self.isAgent isEqual:@1]) {
        //********************//
        if ([self.isJoinAgent isEqual:@1]) {
            //已申请
            if (self.mineModel.ReferralUserName) {
                return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }else{
                return @[@[@"推广二维码",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }
        }else{
            
            if (self.mineModel.ReferralUserName) {
                return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }else{
                return @[@[@"推广二维码",@" "],@[@""],@[@"",@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
            }
        }
        //********************//
       

    }else{
        //********************//
        if (self.mineModel.ReferralUserName) {
            return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
        }else{
            return @[@[@"推广二维码",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
        }
        //********************//
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
