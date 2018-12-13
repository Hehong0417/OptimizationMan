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
#import "LSPaoMaView.h"
#import "HHMyCollectionVC.h"
#import "HHCommissionTVC.h"

@interface LwPersonalCenter ()
@property(nonatomic,strong) HXMineHeadView *mineHeadView;
@property(nonatomic,strong) HHMineModel  *mineModel;
@property(nonatomic,strong) NSString  *usableComm;
@property(nonatomic,strong) NSString  *fanscount;
@property(nonatomic,strong) NSString  *saletotal;

@property(nonatomic,strong) NSNumber *isAgent;
@property(nonatomic,strong) NSNumber *isJoinAgent;
@property(nonatomic,strong) id obj;
@property(nonatomic,strong) NSNumber *isExtraBonus;
@property(nonatomic,strong) UIButton *rightBtn;

@end

@implementation LwPersonalCenter

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WEAK_SELF();
    _obj = [[NSNotificationCenter defaultCenter] addObserverForName:KPersonCter_Refresh_Notification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
      [self getDatas];
      [[NSNotificationCenter defaultCenter]removeObserver:weakSelf.obj];
      
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
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 60, 44) target:self action:@selector(setBtnAction) image:[UIImage imageNamed:@"no_message"]];
    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -15)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
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
                
                HHUserInfo *userInfo = [HHUserInfo sharedUserInfo];
                userInfo.userModel = [HHUserModel mj_objectWithKeyValues:api.Data[@"user"]];
                userInfo.regioninfo = api.Data[@"regioninfo"];
                [userInfo write];
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
                        item0.detailTitle = [NSString stringWithFormat:@"%@分",self.mineModel.Points];
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
                WEAK_SELF();
                NSNumber  *hasUnReadyMessage = api.Data[@"hasUnReadyMessage"];
                if ([hasUnReadyMessage isEqual:@1]) {
                    [weakSelf.rightBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
                }else{
                    [weakSelf.rightBtn setImage:[UIImage imageNamed:@"no_message"] forState:UIControlStateNormal];
                }
                
                self.mineHeadView.titleLabel.userInteractionEnabled = YES;
                [self.mineHeadView.titleLabel setTapActionWithBlock:^{
                    //分佣明细
                    HHCommissionTVC *vc = [HHCommissionTVC new];
                    [weakSelf.navigationController pushVC:vc];
                }];
                
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
        UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0,WidthScaleSize_H(70)-1, ScreenW, 1) backColor:KVCBackGroundColor];
        [cell.contentView addSubview:h_line];
        gridCell = cell;

    }else{
    
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0,WidthScaleSize_H(50)-1, ScreenW, 1) backColor:KVCBackGroundColor];
        [cell.contentView addSubview:h_line];
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
                  //申请代理
                  HHMyIntegralListVC *vc = [HHMyIntegralListVC new];
                  [self.navigationController pushVC:vc];
              }else{
                //申请代理
                HHApplyDelegateVC *vc = [HHApplyDelegateVC new];
                [self.navigationController pushVC:vc];
              }
         }else{
             HHMyIntegralListVC *vc = [HHMyIntegralListVC new];
             [self.navigationController pushVC:vc];
         }
    }else if (indexPath.section == 2&&indexPath.row==1){
        if ([self.isAgent isEqual:@1]) {
        //我的积分
        HHMyIntegralListVC *vc = [HHMyIntegralListVC new];
        [self.navigationController pushVC:vc];
        }
    }else if (indexPath.section == 3&&indexPath.row == 0){
        //拼团
        HHMyActivityWebVC *vc = [HHMyActivityWebVC new];
        [self.navigationController pushVC:vc];
  
    }else if (indexPath.section == 3&&indexPath.row == 1){
        //降价团
        HHMySaleGroupWebVC *vc = [HHMySaleGroupWebVC new];
        [self.navigationController pushVC:vc];

    }else if (indexPath.section == 3&&indexPath.row == 2){
        //送礼
        HHMySendGiftWebVC *vc = [HHMySendGiftWebVC new];
        [self.navigationController pushVC:vc];

    }else if (indexPath.section == 3&&indexPath.row == 3){
        //额外奖励
        HHExtraBonusVC *vc = [HHExtraBonusVC new];
        [self.navigationController pushVC:vc];
    
    }else if (indexPath.section == 4&&indexPath.row == 0){
        //优惠券
        HHCouponSuperVC *vc = [HHCouponSuperVC new];
        [self.navigationController pushVC:vc];
        
    }else if (indexPath.section == 4&&indexPath.row == 1){
        //我的收藏
        HHMyCollectionVC *vc = [HHMyCollectionVC new];
        [self.navigationController pushVC:vc];
        
    }else if (indexPath.section == 5){
        //设置
        HHSetVC *vc = [HHSetVC new];
        [self.navigationController pushVC:vc];
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
//        UIView *head_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
//        NSString* text = @"两块钱,你买不了吃亏,两块钱,你买不了上当！";
//        LSPaoMaView* paomav = [[LSPaoMaView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) title:text];
//        [head_view addSubview:paomav];
//        return head_view;
        return nil;
    }else{
      UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
      return v;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
//        return 40;
        return WidthScaleSize_H(5);
    }else{
        return WidthScaleSize_H(5);
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
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼",@"额外奖励"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }
                
            }else{
                if ([self.isExtraBonus isEqual:@1]) {
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼",@"额外奖励"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }
            }
            
            
        }else{
            
            if (self.mineModel.ReferralUserName) {
                
                if ([self.isExtraBonus isEqual:@1]) {
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼",@"额外奖励"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }
                
            }else{
                if ([self.isExtraBonus isEqual:@1]) {
                    
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼",@"额外奖励"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }else{
                    return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"申请代理",@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                }
            }
            
        }
        //************************//
      
    }else{
        //**********
        if (self.mineModel.ReferralUserName) {
            if ([self.isExtraBonus isEqual:@1]) {
                return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼",@"额外奖励"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
            }else{
                return @[@[@"分享赚钱",@"",@"您是由【德玛西亚】推荐的"],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
            }
            
        }else{
            if ([self.isExtraBonus isEqual:@1]) {
                return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼",@"额外奖励"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                
            }else{
                return @[@[@"分享赚钱",@""],@[@"地址管理"],@[@"我的积分",@"会员等级"],@[@"我的拼团",@"降价团",@"送礼"],@[@"优惠券",@"我的收藏"],@[@"设置"]];
                
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
                
                return @[@[@"",@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }else{
                return @[@[@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }
            
        }else{
            if (self.mineModel.ReferralUserName) {
                return @[@[@"",@"",@""],@[@""],@[@"",@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }else{
                return @[@[@"",@""],@[@""],@[@"",@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }
        }
        //********************//
        
    }else{
        //********************//
        if (self.mineModel.ReferralUserName) {
            return @[@[@"",@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
        }else{
            return @[@[@"",@""],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
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
                return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }else{
                return @[@[@"推广二维码",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }
        }else{
            
            if (self.mineModel.ReferralUserName) {
                return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }else{
                return @[@[@"推广二维码",@" "],@[@""],@[@"",@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
            }
        }
        //********************//
       
    }else{
        //********************//
        if (self.mineModel.ReferralUserName) {
            return @[@[@"推广二维码",@" ",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
        }else{
            return @[@[@"推广二维码",@" "],@[@""],@[@"",@""],@[@"",@"",@"",@""],@[@"",@""],@[@""]];
        }
        //********************//
    }
}
- (NSArray *)indicatorIndexPaths{
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:2]];
    
    return indexPaths;
}
- (HXMineHeadView *)mineHeadView {
    
    if (!_mineHeadView) {
        _mineHeadView = [[HXMineHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScaleSize_H(160)+WidthScaleSize_H(50))];
    }
    
    return _mineHeadView;
}



@end
