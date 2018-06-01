//
//  HHMessageDetailVC.m
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMessageDetailVC.h"
#import "HHMessageDeatilCell.h"
#import "HHEvaluationListModel.h"
#import "HHMessageCell.h"

@interface HHMessageDetailVC ()
@property(nonatomic,strong) HHMineModel *noticeModel;

@end

@implementation HHMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息详情";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = KVCBackGroundColor;

    [self.tableView registerClass:[HHMessageDeatilCell class] forCellReuseIdentifier:@"HHMessageDeatilCell"];
    
    [self getDatas];
}
- (void)getDatas{
    
    [[[HHMineAPI GetNoticeDetailWithId:self.Id.numberValue] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                self.noticeModel = [HHMineModel mj_objectWithKeyValues:api.Data];
                
                [self.tableView reloadData];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMessageDeatilCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HHMessageDeatilCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = KVCBackGroundColor;
    cell.model = self.noticeModel;
    cell.nav = self.navigationController;
//    [cell setShadowWithTableView:tableView indexPath:indexPath model:self.noticeModel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHMineModel *model =  self.noticeModel;

    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHMessageDeatilCell class] contentViewWidth:[self cellContentViewWith]];
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
@end
