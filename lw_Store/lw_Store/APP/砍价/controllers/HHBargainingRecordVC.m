//
//  HHBargainingRecordVC.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBargainingRecordVC.h"
#import "HHBargainingRecordCell.h"
#import "HHBargainingHead.h"

@interface HHBargainingRecordVC ()

@end

@implementation HHBargainingRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"砍价";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHBargainingRecordCell" bundle:nil] forCellReuseIdentifier:@"HHBargainingRecordCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    HHBargainingHead *head_view = [[HHBargainingHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(370)+100+40)];
    self.tableView.tableHeaderView = head_view;
    
    
    UIView *foot_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(100))];
    UIButton *foot_btn = [UIButton lh_buttonWithFrame:CGRectMake(WidthScaleSize_W(30), 0, ScreenW - 2*WidthScaleSize_W(30), WidthScaleSize_H(35)) target:self action:@selector(bargainingAction:) title:@"喊朋友一起砍" titleColor:kWhiteColor font:FONT(14) backgroundColor:kBlackColor];
    [foot_btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    foot_btn.centerY = foot_view.centerY;
    [foot_view addSubview:foot_btn];
    self.tableView.tableFooterView = foot_view;
}
- (void)bargainingAction:(UIButton *)btn{
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHBargainingRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHBargainingRecordCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setIndexPath:indexPath count:4];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return WidthScaleSize_H(85);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
@end
