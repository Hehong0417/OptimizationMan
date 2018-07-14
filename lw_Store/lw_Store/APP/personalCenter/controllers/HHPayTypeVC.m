//
//  HHPayTypeVC.m
//  lw_Store
//
//  Created by User on 2018/5/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPayTypeVC.h"
#import "HHPayTypeCell.h"
#import "HHCouponItem.h"

@interface HHPayTypeVC ()
{
    NSInteger _selectIndex;
    BOOL _isSelect;//是否进行了选择
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
    
    HHCouponItem *couponItem = [HHCouponItem sharedCouponItem];
    [couponItem.selectItems enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == couponItem.lastSelectIndex) {
            [couponItem.selectItems replaceObjectAtIndex:idx withObject:@1];
        }else{
            [couponItem.selectItems replaceObjectAtIndex:idx withObject:@0];
        }
        *stop = 0;
    }];
    [couponItem write];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
//确认支付
- (void)commitAction:(UIButton *)btn{
    
    //申请代理
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commitActionWithBtn:selectIndex:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate commitActionWithBtn:btn selectIndex:_selectIndex];
    }
    
    //优惠券
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commitActionWithBtn: selectIndex: select_model: total_money: submitOrderTool: couponCell: lastConponValue: last_total_money:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        CGFloat couponValue;
        CGFloat total_money;
        
        HHCouponItem *coupon_item = [HHCouponItem sharedCouponItem];

        if (_selectIndex == 0) {
            if (_isSelect == YES) {
                //选择不使用
                HHcouponsModel *model = self.coupons[coupon_item.lastSelectIndex];
                couponValue = model.CouponValue.floatValue;
                _selectIndex = 0;
                if (coupon_item.last_total_money<=model.CouponValue.floatValue) {
                    //
                    total_money = coupon_item.order_total_money;
                }else{
                    total_money =  self.total_money.floatValue;
                }
            }else{
                //未选择选项，默认上次
                HHcouponsModel *model = self.coupons[coupon_item.lastSelectIndex];
                couponValue = model.CouponValue.floatValue;
                _selectIndex = coupon_item.lastSelectIndex;
                if (coupon_item.last_total_money<=model.CouponValue.floatValue) {
                    total_money = coupon_item.last_total_money;
                }else{
                    total_money =  self.total_money.floatValue + couponValue;
                }
            }
        }else{
            //选择了其他的选项
            HHcouponsModel *model = self.coupons[coupon_item.lastSelectIndex];
            couponValue = model.CouponValue.floatValue;
            if (coupon_item.last_total_money<=model.CouponValue.floatValue) {
                //    如果上次的支付金额<上一次优惠券  那么改变选择之后 总价格为最开始价格
                total_money = coupon_item.order_total_money;
            }else{
               //    1.加上上一次选择的优惠劵值
                total_money =  self.total_money.floatValue + couponValue;
            }
        }
        [self.delegate commitActionWithBtn:btn selectIndex:_selectIndex select_model:self.coupons[_selectIndex] total_money:total_money submitOrderTool:self.submitOrderTool couponCell:self.couponCell lastConponValue:couponValue last_total_money:coupon_item.last_total_money];
        
        //记录已选择索引
        
        
        HHCouponItem *couponItem = [HHCouponItem sharedCouponItem];
        [couponItem.selectItems enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == _selectIndex) {
                [couponItem.selectItems replaceObjectAtIndex:idx withObject:@1];
            }else{
                [couponItem.selectItems replaceObjectAtIndex:idx withObject:@0];
            }
            *stop = 0;
        }];
        couponItem.last_total_money = self.total_money.floatValue;
        [couponItem write];
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
     cell  = [[HHPayTypeCell alloc] createCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HHPayTypeCell" contentType:HHPayTypeCellContentType_rightSelectBtn haveIconView:NO];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.couponsModel = self.coupons[indexPath.row];
    HHCouponItem *couponItem = [HHCouponItem sharedCouponItem];
    cell.btnSelected = ((NSNumber *)couponItem.selectItems[indexPath.row]).boolValue;
    cell.selected = YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        HHCouponItem *couponItem = [HHCouponItem sharedCouponItem];
        [couponItem.selectItems enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == indexPath.row) {
                [couponItem.selectItems replaceObjectAtIndex:idx withObject:@1];
            }else{
                [couponItem.selectItems replaceObjectAtIndex:idx withObject:@0];
            }
            *stop = 0;
        }];
        [couponItem write];
        _selectIndex = indexPath.row;
        _isSelect = YES;
        [self.tableV reloadData];

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
