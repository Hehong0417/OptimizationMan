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
{
    NSInteger _selectIndex;
}
@property (nonatomic, strong) UITableView *tableV;

@end

@implementation HHPayTypeVC

- (void)loadView {
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tableV = [UITableView lh_tableViewWithFrame:CGRectMake(0,50, SCREEN_WIDTH,ScreenH/2-50-50) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tableV.backgroundColor = kClearColor;
    self.tableV.estimatedSectionHeaderHeight = 0;
    self.tableV.estimatedSectionFooterHeight = 0;
    self.tableV.estimatedRowHeight = 0;
    [self.view addSubview:self.tableV];
    self.tableV.tableFooterView = [UIView new];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    [self setUpFeatureAlterView];
    
    self.tableView.backgroundColor = KVCBackGroundColor;

    UIView *header = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:kWhiteColor];
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 50) text:self.title_str?self.title_str:@"支付方式" textColor:kBlackColor font:BoldFONT(16) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    [header addSubview:lab];
    UIButton *close_btn = [UIButton lh_buttonWithFrame:CGRectMake(ScreenW-50, 0, 50, 50) target:self action:@selector(closeAction:) image:[UIImage imageNamed:@"icon_close_default"]];
    [header addSubview:close_btn];
    UIView *line = [UIView lh_viewWithFrame:CGRectMake(0, 49, ScreenW, 1) backColor:KVCBackGroundColor];
    [header addSubview:line];
    [self.view addSubview:header];
    
    UIView *footer = [UIView lh_viewWithFrame:CGRectMake(0, ScreenH/2-60, ScreenW, 60) backColor:kWhiteColor];
    UIButton *commit_btn = [UIButton lh_buttonWithFrame:CGRectMake(30, 10, ScreenW-60, 35) target:self action:@selector(closeAction:) image:nil];
    [commit_btn setBackgroundColor:kBlackColor];
    commit_btn.titleLabel.font = FONT(14);
    [commit_btn setTitle:self.btn_title forState:UIControlStateNormal];
    [commit_btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [commit_btn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:commit_btn];
    [self.view addSubview:footer];
    
}
-(void)closeAction:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
//确认支付
- (void)commitAction:(UIButton *)btn{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commitActionWithBtn: selectIndex:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate commitActionWithBtn:btn selectIndex:_selectIndex];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commitActionWithBtn: selectIndex: select_model: total_money: submitOrderTool: couponCell:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate commitActionWithBtn:btn selectIndex:_selectIndex select_model:self.coupons[_selectIndex] total_money:self.total_money submitOrderTool:self.submitOrderTool couponCell:self.couponCell];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.coupons.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.subtitle_str) {
        return 40;
    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHPayTypeCell"];
    if (!cell) {
      cell = [[HHPayTypeCell alloc] createCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HHPayTypeCell" contentType:HHPayTypeCellContentType_rightSelectBtn haveIconView:NO];
    }
    cell.couponsModel = self.coupons[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHPayTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    _selectIndex = indexPath.row;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHPayTypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.subtitle_str) {

    UIView *header = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 40) backColor:kWhiteColor];
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 40) text:self.subtitle_str?self.subtitle_str:@"请选择支付方式" textColor:KA0LabelColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [header addSubview:lab];
     return header;
     }
    return nil;
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
