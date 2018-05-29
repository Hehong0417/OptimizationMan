//
//  HHPayTypeVC.m
//  lw_Store
//
//  Created by User on 2018/5/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPayTypeVC.h"
#import "HHPayTypeCell.h"

@interface HHPayTypeVC ()

@end

@implementation HHPayTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    [self setUpFeatureAlterView];
    
    [self.tableView registerClass:[HHPayTypeCell class] forCellReuseIdentifier:@"HHPayTypeCell"];
    
    UIView *header = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:kWhiteColor];
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 50) text:@"支付方式" textColor:kBlackColor font:BoldFONT(16) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    [header addSubview:lab];
    UIButton *close_btn = [UIButton lh_buttonWithFrame:CGRectMake(ScreenW-50, 0, 50, 50) target:self action:@selector(closeAction:) image:[UIImage imageNamed:@"icon_close_default"]];
    [header addSubview:close_btn];
    UIView *line = [UIView lh_viewWithFrame:CGRectMake(0, 49, ScreenW, 1) backColor:KVCBackGroundColor];
    [header addSubview:line];

    self.tableView.tableHeaderView = header;
    
    
    UIView *footer = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 80) backColor:kWhiteColor];
    UIButton *commit_btn = [UIButton lh_buttonWithFrame:CGRectMake(30, 20, ScreenW-60, 35) target:self action:@selector(closeAction:) image:nil];
    [commit_btn setBackgroundColor:kBlackColor];
    commit_btn.titleLabel.font = FONT(14);
    [commit_btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [commit_btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [commit_btn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:commit_btn];
    self.tableView.tableFooterView = footer;
    
}
-(void)closeAction:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
//确认支付
- (void)commitAction:(UIButton *)btn{
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commitActionWithBtn:)]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate commitActionWithBtn:btn];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHPayTypeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHPayTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHPayTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 40) backColor:kWhiteColor];
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 40) text:@"请选择支付方式" textColor:KA0LabelColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [header addSubview:lab];
    return header;
}

#pragma mark - 弹出弹框
- (void)setUpFeatureAlterView
{
    XWInteractiveTransitionGestureDirection direction = XWInteractiveTransitionGestureDirectionDown;
    WEAK_SELF();
    [self xw_registerBackInteractiveTransitionWithDirection:direction transitonBlock:^(CGPoint startPoint){
        [weakSelf dismissViewControllerAnimated:YES completion:^{

        }];
    } edgeSpacing:0];
}

@end
