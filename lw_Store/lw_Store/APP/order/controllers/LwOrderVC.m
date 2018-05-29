//
//  HHMyOrderVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "LwOrderVC.h"
#import "SGSegmentedControl.h"
#import "HJOrderCell.h"
#import "HHOrderTwoCell.h"
//#import "HHLogisticsVC.h"
#import "HHSubmitOrdersVC.h"
#import "HHOrderDetailVC.h"
//#import "HHReturnGoodsVC.h"
//#import "HHCategoryVC.h"
#import "HHPaySucessVC.h"
//#import "HHFillLogisticsVC.h"
#import "HHMyOrderItem.h"
#import "HHPostEvaluationVC.h"
#import "HHEvaluationListVC.h"


@interface LwOrderVC ()<UIScrollViewDelegate,SGSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)   SGSegmentedControl *SG;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger sg_selectIndex;
@property (nonatomic, assign)   BOOL isFooterRefresh;
@property(nonatomic,assign)   BOOL  isLoading;
@property(nonatomic,assign)   BOOL  isWlan;

@end

@implementation LwOrderVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单";
    self.view.backgroundColor = KVCBackGroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.page = 1;
    self.datas = [NSMutableArray array];
    self.title_arr = @[@"全部",@"待付款",@"待发货",@"待收货",@"交易成功"];
    //UI
    [self setUI];
    self.isFooterRefresh = NO;

    //全部
    [self getDatasWithIndex:@0];
    
}
#pragma mark - UI
- (void)setUI{
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44 - 44 - 10;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+8, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    //registerCell
    [self.tableView registerNib:[UINib nibWithNibName:@"HHOrderTwoCell" bundle:nil] forCellReuseIdentifier:@"HHOrderTwoCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderCell" bundle:nil] forCellReuseIdentifier:@"HJOrderCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderOneCell" bundle:nil] forCellReuseIdentifier:@"HJOrderOneCell"];
    
    //SG
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    self.SG.title_fondOfSize = FONT(14);
    self.SG.titleColorStateNormal = APP_COMMON_COLOR;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.indicatorColor = APP_COMMON_COLOR;
    [self.view addSubview:_SG];
    
    //headdRefresh
    [self addHeadRefresh];
    
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isFooterRefresh = YES;
        [self.datas removeAllObjects];
        if (self.sg_selectIndex == 0) {
            [self getDatasWithIndex:@(self.sg_selectIndex)];
        }else if(self.sg_selectIndex == 4){
            
            [self getDatasWithIndex:@(self.sg_selectIndex+1)];

        }else{
            [self getDatasWithIndex:@(self.sg_selectIndex)];
        }
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        if (self.sg_selectIndex == 0) {
            [self getDatasWithIndex:@(self.sg_selectIndex)];
        }else if(self.sg_selectIndex == 4){
            
            [self getDatasWithIndex:@(self.sg_selectIndex+1)];
            
        }else{
            [self getDatasWithIndex:@(self.sg_selectIndex)];
        }
    }];
    self.tableView.mj_footer = refreshfooter;
}
#pragma mark - DZNEmptyDataSetDelegate

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    if (self.isLoading) {
//        if (self.isWlan) {
//            return [UIImage imageNamed:@"img_list_disable"];
//        }else{
//            return [UIImage imageNamed:@"img_network_disable"];
//        }
//    }else{
//        //没加载过
//        return [UIImage imageNamed:@""];
//    }
//}
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
//
//    NSString *titleStr;
//    if (self.isLoading) {
//        if (self.isWlan) {
//        titleStr = @"订单是空的";
//        }else{
//        titleStr = @"";
//        }
//    }else{
//        //没加载过
//        titleStr = @"";
//    }
//    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(18),NSForegroundColorAttributeName:APP_purple_Color}];
//}
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//
//    NSString *titleStr;
//    if (self.isLoading) {
//        if (self.isWlan) {
//            titleStr = @"赶紧把你喜欢的宝贝带回家";
//        }else{
//            titleStr = @"网络竟然崩溃了～";
//        }
//     }else{
//        //没加载过
//        titleStr = @"";
//    }
//    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
//}
//
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//
//    NSString *titleStr;
//    if (self.isLoading) {
//        if (self.isWlan) {
//        titleStr = @"去下单";
//        }else{
//        titleStr = @"刷新试试";
//        }
//    }else{
//        //没加载过
//        titleStr = @"";
//    }
//    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:BoldFONT(18),NSForegroundColorAttributeName:kWhiteColor}];
//
//}
//- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
//    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);
//
//    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];
//
//    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
//}
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//
//    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
//    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
//    return -offset;
//}
//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
//    return 20;
//}
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
//    if (self.isWlan) {
////     HHCategoryVC *vc = [HHCategoryVC new];
////     [self.navigationController pushVC:vc];
//    }else{
//        [self.tableView.mj_header beginRefreshing];
//    }
//}

#pragma mark - NetWork

- (void)getDatasWithIndex:(NSNumber *)index{
    
    [[[HHMineAPI GetOrderListWithstatus:index page:@(self.page)] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        self.isLoading = YES;
        if (!error) {
            if (api.State == 1) {
                [self addFootRefresh];
                self.isWlan = YES;
                [self loadDataFinish:api.Data];
            }else{
                self.isWlan = YES;
                [SVProgressHUD showInfoWithStatus:api.Msg];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
                [self.tableView reloadData];
            }
        }else{
                self.isWlan = NO;
                self.tableView.mj_footer.hidden = YES;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
        }
    }];
}

/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {

    [self.datas addObjectsFromArray:arr];
    
    if (arr.count < 10) {
        [self endRefreshing:YES];
        
    }else{
        [self endRefreshing:NO];
    }
}

/**
 *  结束刷新
 */
- (void)endRefreshing:(BOOL)noMoreData {
    // 取消刷新
    if (noMoreData) {
        if (self.datas.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    }
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    //刷新界面
       [self.tableView reloadData];
}
#pragma mark --- SGSegmentedControl delegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    
    self.isFooterRefresh = YES;
    self.sg_selectIndex = index;
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    UITableViewCell *grideCell;
    if (indexPath.row == model.items.count){
        //订单总计
        HHOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderTwoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderTotalModel = model;
        grideCell = cell;

    }else{
        //商品
            HJOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HJOrderCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.productModel =  model.items[indexPath.row];
            cell.nav = self.navigationController;
            grideCell = cell;
    }
   
    grideCell.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    
    return grideCell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) backColor:kWhiteColor];
    
    UIButton *oneBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-160-20, 10, 80, 30) target:self action:@selector(oneAction:) title:@"取消" titleColor:APP_COMMON_COLOR font:FONT(14) backgroundColor:kWhiteColor];
    oneBtn.tag = section+100;
    [oneBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:oneBtn];

    UIButton *twoBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-90, 10, 80, 30) target:self action:@selector(twoAction:) title:@"去评价" titleColor:kWhiteColor font:FONT(14) backgroundColor:APP_COMMON_COLOR];
    twoBtn.tag = section+1000;
    [twoBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:twoBtn];
    
    //最左边按钮
//    UIButton *leftBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-160-20-90, 10, 80, 30) target:self action:@selector(leftBtnAction:) title:@"填写物流" titleColor:APP_COMMON_COLOR font:FONT(14) backgroundColor:kWhiteColor];
//    leftBtn.tag = section+1001;
//    [leftBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
//    [footView addSubview:leftBtn];
//    leftBtn.hidden = YES;
    
    //分割线Y坐标
    CGFloat down_y = 52;
    if (self.datas.count>0) {
        HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
        NSString *status = model.status;
        if ([status isEqualToString:@"1"]) {
            //待付款
            down_y = 52;
            //oneBtn
            [self setBtnAttrWithBtn:oneBtn Title:@"取消订单" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            //twoBtn
            [self setBtnAttrWithBtn:twoBtn Title:@"去支付" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:kWhiteColor backgroundColor:APP_COMMON_COLOR];
        }else if([status isEqualToString:@"2"]){
            //待发货
             down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
        }else if([status isEqualToString:@"3"]){
            //待收货
            down_y = 52;
            oneBtn.hidden = NO;
            [self setBtnAttrWithBtn:oneBtn Title:@"查看物流" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            //twoBtn
            twoBtn.hidden = NO;

            [self setBtnAttrWithBtn:twoBtn Title:@"确认收货" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            
        }else if([status isEqualToString:@"4"]){
            //订单关闭
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"5"]){
            // @"交易成功";
            down_y = 52;
            //oneBtn
            oneBtn.hidden = NO;
            //twoBtn
            twoBtn.hidden = NO;
            [self setBtnAttrWithBtn:oneBtn Title:@"删除订单" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            
            //twoBtn
            [self setBtnAttrWithBtn:twoBtn Title:@"追加评价" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            
        }else if([status isEqualToString:@"6"]){
            // 申请退款
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"7"]){
            // 申请退货
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"8"]){
            // 申请换货
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"9"]){
            // 已退款
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"10"]){
            // 已退货
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
            
        }
    }
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(0, down_y, SCREEN_WIDTH, 8) backColor:KVCBackGroundColor];
    [footView addSubview:downLine];

    return footView;
    
}
- (void)setBtnAttrWithBtn:(UIButton *)btn Title:(NSString *)title CornerRadius:(NSInteger)cornerRadius borderColor:(UIColor *)borderColor titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor{
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn lh_setCornerRadius:cornerRadius borderWidth:1 borderColor:borderColor];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:backgroundColor];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];

  if (indexPath.row == model.items.count){
        //订单总计

    }else{
        //商品
        HHOrderDetailVC *vc = [HHOrderDetailVC new];
        vc.orderid = model.order_id;
        [self.navigationController pushVC:vc];
        
    }

}
- (void)oneAction:(UIButton *)btn{
    NSInteger section = btn.tag - 100;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    NSString *status = model.status;
    if ([status isEqualToString:@"1"]) {
        //待付款--->取消订单
        [self handleOrderWithorderid:model.order_id status:HHhandle_type_cancel btn:btn title:@"确定取消订单吗？"];
        
    }else if([status isEqualToString:@"2"]){
        //待发货
        
    }else if([status isEqualToString:@"3"]){
        //待收货--->查看物流

                //查看物流
//                HHLogisticsVC *vc = [HHLogisticsVC new];
//                vc.orderid = model.orderid;
//                vc.express_order = model.return_goods_express_order;
//                vc.express_name = model.return_goods_express_name;
//                vc.type = @1;
//                [self.navigationController pushVC:vc];

    }else if([status isEqualToString:@"5"]){
        //交易成功-->删除订单
        [self handleOrderWithorderid:model.order_id status:HHhandle_type_cancel btn:btn title:@"确定删除订单吗？"];

    }
}
//处理订单
- (void)handleOrderWithorderid:(NSString *)orderid status:(HHhandle_type)handle_type btn:(UIButton *)btn  title:(NSString *)titleStr{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titleStr message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn.enabled = NO;
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
        if (handle_type == HHhandle_type_cancel) {
            //取消订单
            [[[HHMineAPI postOrder_CloseWithorderid:orderid] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                btn.enabled = YES;
                [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
                
                if (!error) {
                    if (api.State == 1) {
                        [self.datas removeAllObjects];
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"取消订单成功！"];
                        if (self.sg_selectIndex == 0) {
                            [self getDatasWithIndex:nil];
                        }else{
                            [self getDatasWithIndex:@(self.sg_selectIndex)];
                        }
                    }else{
                        
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }
            }];
            
        }else if (handle_type == HHhandle_type_delete){
            //删除订单
            
        }else if (handle_type == HHhandle_type_Confirm){
            //确认收货
            [[[HHMineAPI postConfirmOrderWithorderid:orderid]netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                btn.enabled = YES;
                [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
                
                if (!error) {
                    if (api.State == 1) {
                        
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"确认收货成功！"];
                        self.page = 1;
                        [self.datas removeAllObjects];
                        [self getDatasWithIndex:@(self.sg_selectIndex)];
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }else {
                    
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                    
                }
            }];
        }
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

//支付订单
- (void)payOrderWithorderid:(NSString *)orderid btn:(UIButton *)btn{
//
//    HHPostEvaluationVC *vc =[HHPostEvaluationVC  new];
//    [self.navigationController pushVC:vc];
//    HHEvaluationListVC *vc = [HHEvaluationListVC new];
//    [self.navigationController pushVC:vc];

//    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.color = KA0LabelColor;
//    hud.detailsLabelText = @"付款中...";
//    hud.detailsLabelColor = kWhiteColor;
//    hud.detailsLabelFont = FONT(14);
//    hud.activityIndicatorColor = kWhiteColor;
//    [hud showAnimated:YES];
//    btn.enabled = NO;
    //----->微信支付
//    [[[HHMineAPI postPayOrderWithorderid:orderid] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
//        btn.enabled = YES;
//        if (!error) {
//            if (api.State == 1) {
//                //-->支付成功
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                    HHPaySucessVC *vc = [HHPaySucessVC new];
//                    [self.navigationController pushVC:vc];
//                    [hud hideAnimated:YES];
//                });
//            }else{
//                [hud hideAnimated:YES];
//
//                [SVProgressHUD showInfoWithStatus:api.Msg];
//            }
//        }else{
//            [hud hideAnimated:YES];
//        }
//    }];
}

- (void)twoAction:(UIButton *)btn{
    
    NSInteger section = btn.tag - 1000;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];    NSString *status = model.status;

    if ([status isEqualToString:@"1"]) {
        //待付款--->去支付
        [self payOrderWithorderid:model.order_id btn:btn];
        
    }else if([status isEqualToString:@"3"]){
//        //待收货--->确认收货
        [self handleOrderWithorderid:model.order_id status:HHhandle_type_Confirm btn:btn title:@"确认收货吗？"];
        
    }else if([status isEqualToString:@"5"]){
        //交易成功-->追加评价
        HHPostEvaluationVC *vc = [HHPostEvaluationVC new];
        [self.navigationController pushVC:vc];
        
    }

}
//填写物流
//- (void)leftBtnAction:(UIButton *)btn{
//    NSInteger section = btn.tag - 1001;
//    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
//    if ([model.is_exist_reeturn_goods_Express isEqualToString:@"1"]) {
//        //查看退货物流
//        HHLogisticsVC *vc = [HHLogisticsVC new];
//        vc.orderid = model.orderid;
//        vc.express_order = model.return_goods_express_order;
//        vc.express_name = model.return_goods_express_name;
//        vc.type = @1;
//        [self.navigationController pushVC:vc];
//    }else{
//        //填写物流
//        HHFillLogisticsVC *vc = [HHFillLogisticsVC new];
//        vc.orderid = model.orderid;
//        vc.return_goods_express_code = model.return_goods_express_code;
//        vc.return_goods_express_order = model.return_goods_express_order;
//        vc.return_numb_block = ^(NSNumber *result) {
//            self.page = 1;
//            [self.datas removeAllObjects];
//            [self getDatasWithIndex:@(self.sg_selectIndex-1)];
//        };
//        [self.navigationController pushVC:vc];
//    }
    
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) backColor:kWhiteColor];
    
//    NSString *status =  [HHMyOrderItem shippingLogisticsStateWithStatus_code:model.status.integerValue];

    UILabel *textLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, 60, 40) text:model.status_name textColor:kRedColor font:[UIFont boldSystemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:textLabel];
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+5, 0,1, 40) backColor:KVCBackGroundColor];
    [headView addSubview:downLine];

    UILabel *orderLabel = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+20, 0,200 , 40) text:model.order_date textColor:kBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:orderLabel];
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];

    return model.items.count+1;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
 
    if (indexPath.row == model.items.count) {
        return 44;
    }else{
        return 85;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    return model.footHeight;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}
@end
