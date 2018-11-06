//
//  HHMyOrderVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHOrderVC.h"
#import "SGSegmentedControl.h"
#import "HJOrderCell.h"
#import "HHOrderTwoCell.h"
#import "HHSubmitOrdersVC.h"
#import "HHOrderDetailVC.h"
#import "HHMyOrderItem.h"
#import "HHPostEvaluationVC.h"
#import "HHEvaluationListVC.h"
#import "HHApplyRefundVC.h"
#import "HHOrderItemModel.h"
#import "HHMyOrderItem.h"
#import "HHFamiliarityPayVC.h"
#import "HHPaySucessVC.h"
#import "HHLogisticsVC.h"
#import "HHSelectChannelAlertView.h"

@interface HHOrderVC ()<UIScrollViewDelegate,SGSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ApplyRefundDelegate>

@property(nonatomic,strong)   SGSegmentedControl  *SG;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   NSMutableArray *items_arr;
@property (nonatomic, assign)   NSInteger sg_selectIndex;
@property (nonatomic, assign)   BOOL isFooterRefresh;
@property (nonatomic, assign)   BOOL isHeaderRefresh;
@property(nonatomic,assign)   BOOL  isLoading;
@property(nonatomic,assign)   BOOL  isWlan;
@property(nonatomic,strong) HHSelectChannelAlertView *alertView;

@end
@implementation HHOrderVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单";
    self.view.backgroundColor = KVCBackGroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.page = 1;
    self.title_arr = @[@"全部",@"待付款",@"待发货",@"待收货",@"交易成功"];
    //UI
    [self setUI];
    //全部
    [self getDatasWithIndex:@0];
    

}
#pragma mark - UI
- (void)setUI{
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44 - 44 - 10;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+5, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //registerCell
    [self.tableView registerNib:[UINib nibWithNibName:@"HHOrderTwoCell" bundle:nil] forCellReuseIdentifier:@"HHOrderTwoCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderCell" bundle:nil] forCellReuseIdentifier:@"HJOrderCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderOneCell" bundle:nil] forCellReuseIdentifier:@"HJOrderOneCell"];
    
    //SG
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    self.SG.title_fondOfSize = FONT(14);
    self.SG.titleColorStateNormal = KTitleLabelColor;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.indicatorColor = APP_COMMON_COLOR;
    [self.view addSubview:_SG];
    
    //headdRefresh
    [self addHeadRefresh];
    [self addFootRefresh];

}
#pragma mark - 懒加载
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)items_arr{
    if (!_items_arr) {
        _items_arr = [NSMutableArray array];
    }
    return _items_arr;
}

#pragma mark - 刷新控件
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isFooterRefresh = NO;
        self.isHeaderRefresh = YES;
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
        self.isHeaderRefresh = NO;
        if (self.sg_selectIndex == 0) {
            [self getDatasWithIndex:@(self.sg_selectIndex)];
        }else if(self.sg_selectIndex == 4){
            
            [self getDatasWithIndex:@(self.sg_selectIndex+1)];
            
        }else{
            [self getDatasWithIndex:@(self.sg_selectIndex)];
        }
    }];
    refreshfooter.stateLabel.textColor = KTitleLabelColor;
    self.tableView.mj_footer = refreshfooter;
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        if (self.isWlan) {
            return [UIImage imageNamed:@"no_order"];
        }else{
            return [UIImage imageNamed:@"img_network_disable"];
        }
    }else{
        //没加载过
        return [UIImage imageNamed:@""];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{

    NSString *titleStr;
    if (self.isLoading) {
        if (self.isWlan) {
        titleStr = @"订单列表为空";
        }else{
        titleStr = @"";
        }
    }else{
        //没加载过
        titleStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);

    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];

    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {

    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 20;
}
#pragma mark - NetWork
- (void)getDatasWithIndex:(NSNumber *)index{
    
    [[[HHMineAPI GetOrderListWithstatus:index page:@(self.page)] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        self.isLoading = YES;
        
        if (self.isHeaderRefresh ==YES) {
            [self.datas removeAllObjects];
            [self.items_arr removeAllObjects];
        }
        if (!error) {
            if (api.State == 1) {
                self.isWlan = YES;
                [self.items_arr  removeAllObjects];
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
#pragma mark - 刷新数据处理
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    //处理数据
    [self.datas enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        HHCartModel *cart_m = [HHCartModel mj_objectWithKeyValues:dic];

        HHOrderItemModel *orderItem_m = [HHOrderItemModel new];
        orderItem_m.order_id = cart_m.order_id;
        orderItem_m.order_date = cart_m.order_date;
        orderItem_m.status = cart_m.status;
        orderItem_m.status_name = cart_m.status_name;
        orderItem_m.order_can_evaluate = cart_m.order_can_evaluate;
        orderItem_m.total = cart_m.total;

        [cart_m.items enumerateObjectsUsingBlock:^(HHproductsModel *productsM, NSUInteger idx, BOOL * _Nonnull stop) {

            [productsM.product_item enumerateObjectsUsingBlock:^(HHproducts_item_Model * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HHproducts_item_Model *products_item_m = [HHproducts_item_Model new];
                products_item_m.prodcut_name = productsM.prodcut_name;
                products_item_m.icon = productsM.icon;
                products_item_m.product_item_id = obj.product_item_id;
                products_item_m.product_item_price = obj.product_item_price;
                products_item_m.product_item_quantity = obj.product_item_quantity;
                products_item_m.product_item_status = obj.product_item_status;
                products_item_m.product_item_sku_name = obj.product_item_sku_name;
                products_item_m.product_item_refund_id = obj.product_item_refund_id;
                products_item_m.product_id = productsM.product_id;

                [orderItem_m.items addObject:products_item_m];
                [orderItem_m.pids addObject:obj.product_item_id];
            }];
        }];
        [self.items_arr addObject:orderItem_m];
    }];
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
    self.tableView.mj_footer.hidden = NO;

    if (noMoreData) {
        if (self.datas.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    }
    //刷新界面
    [self.tableView reloadData];
    
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }

}
#pragma mark --- SGSegmentedControl delegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    
    self.isFooterRefresh = YES;
    self.sg_selectIndex = index;
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark --- ApplyRefundDelegate

- (void)backActionWithBtn:(UIButton *)btn{
    [self.items_arr removeAllObjects];
    [self.datas removeAllObjects];
    if (self.sg_selectIndex == 0) {
        [self getDatasWithIndex:@0];
    }else{
        [self getDatasWithIndex:@(self.sg_selectIndex)];
    }
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    HHOrderItemModel *orders_m = self.items_arr[indexPath.section];

    UITableViewCell *grideCell;
    if (indexPath.row == orders_m.items.count){
        //订单总计
        HHOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderTwoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderTotalModel = orders_m;
        grideCell = cell;

    }else{
        //商品
            HJOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HJOrderCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.productModel =  orders_m.items[indexPath.row];
            cell.nav = self.navigationController;
            [self setStandardLabWith:orders_m.items[indexPath.row] cell:cell];
             
            grideCell = cell;
          [cell.StandardLab setTapActionWithBlock:^{
              
          [self pushVCWith:orders_m.items[indexPath.row] orders_m:orders_m];
           
        }];
    }
    grideCell.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    
    return grideCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) backColor:kWhiteColor];
    
    UIButton *oneBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-160-30, 10, 80, 30) target:self action:@selector(oneAction:) title:@"取消" titleColor:APP_COMMON_COLOR font:FONT(14) backgroundColor:kWhiteColor];
    oneBtn.tag = section+100;
    [oneBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:oneBtn];

    UIButton *twoBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 80, 30) target:self action:@selector(twoAction:) title:@"去评价" titleColor:kWhiteColor font:FONT(14) backgroundColor:APP_COMMON_COLOR];
    twoBtn.tag = section+1000;
    [twoBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:twoBtn];
    
    //分割线Y坐标
    CGFloat down_y = 50;
    if (self.datas.count>0) {
        HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
        NSString *status = model.status;
        if ([status isEqualToString:@"1"]) {
            //待付款
            down_y = 50;
            //oneBtn
            [self setBtnAttrWithBtn:oneBtn Title:@"取消订单" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            //twoBtn
            NSString *twoBtn_title = @"去支付";
            if ([model.order_mode isEqual:@16]) {
                twoBtn_title = @"亲密付";
            }else{
                twoBtn_title = @"去支付";
            }
            [self setBtnAttrWithBtn:twoBtn Title:twoBtn_title CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:kWhiteColor backgroundColor:APP_COMMON_COLOR];
        }else if([status isEqualToString:@"2"]){
            //待发货
             down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:YES];
        }else if([status isEqualToString:@"3"]){
            //待收货
            down_y = 50;
            [self setBtnAttrWithBtn:oneBtn Title:@"查看物流" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            [self setOneBtn:oneBtn WithOneBtnState:NO twoBtn:twoBtn twoBtnState:NO];
            [self setBtnAttrWithBtn:twoBtn Title:@"确认收货" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
        }else if([status isEqualToString:@"4"]){
            //订单关闭
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:YES];

        }else if([status isEqualToString:@"5"]){
            // @"交易成功";
            down_y = [model.order_can_evaluate isEqual:@1]?50:0;
            BOOL twoBtnState =  [model.order_can_evaluate isEqual:@1]?NO:YES;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:twoBtnState];
            //twoBtn
            [self setBtnAttrWithBtn:twoBtn Title:@"去评价" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
        }else if([status isEqualToString:@"6"]){
            // 申请退款
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"7"]){
            // 申请退货
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"8"]){
            // 申请换货
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"9"]){
            // 已退款
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }else if([status isEqualToString:@"10"]){
            // 已退货
            down_y = 0;
            [self setOneBtn:oneBtn WithOneBtnState:YES twoBtn:twoBtn twoBtnState:NO];
        }
    }
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(0, down_y, SCREEN_WIDTH, 5) backColor:KVCBackGroundColor];
    [footView addSubview:downLine];

    return footView;
    
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
//设置按钮隐藏或显示
- (void)setOneBtn:(UIButton *)oneBtn WithOneBtnState:(BOOL)oneBtnSate twoBtn:(UIButton *)twoBtn twoBtnState:(BOOL)twoBtnState{
    oneBtn.hidden = oneBtnSate;
    twoBtn.hidden = twoBtnState;
}
//设置退款退货按钮状态
-(void)setStandardLabWith:(HHproducts_item_Model *)productModel cell:(HJOrderCell *)cell{
    cell.StandardLab.hidden = NO;
    [HHMyOrderItem shippingLogisticsStateWithStatus_code:productModel.product_item_status.integerValue cell:cell];
}
//跳转对应控制器
-(void)pushVCWith:(HHproducts_item_Model *)productModel orders_m:(HHOrderItemModel *)orders_m{
    WEAK_SELF();
    [HHMyOrderItem pushVCWithStatus_code:productModel.product_item_status.integerValue navC:weakSelf.navigationController VC:weakSelf product_m:productModel order_id:orders_m.order_id];
}

//设置段尾按钮属性和标题
- (void)setBtnAttrWithBtn:(UIButton *)btn Title:(NSString *)title CornerRadius:(NSInteger)cornerRadius borderColor:(UIColor *)borderColor titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor{
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn lh_setCornerRadius:cornerRadius borderWidth:1 borderColor:borderColor];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:backgroundColor];
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
                HHLogisticsVC *vc = [HHLogisticsVC new];
                vc.orderid = model.order_id;
                vc.express_order =  model.return_goods_express_order;
                vc.express_name =  model.return_goods_express_name;
                vc.type = @1;
                [self.navigationController pushVC:vc];

    }else if([status isEqualToString:@"5"]){
        //交易成功-->删除订单

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
                [btn lh_setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
                if (!error) {
                    if (api.State == 1) {
                        [self.datas removeAllObjects];
                        [self.items_arr removeAllObjects];
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"取消订单成功！"];
                        [self getDatasWithIndex:@(self.sg_selectIndex)];
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
                [btn lh_setBackgroundColor:kWhiteColor forState:UIControlStateNormal];

                if (!error) {
                    if (api.State == 1) {
                        
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"确认收货成功！"];
                        self.page = 1;
                        [self.datas removeAllObjects];
                        [self.items_arr removeAllObjects];
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
- (void)payOrderWithorderid:(NSString *)orderid btn:(UIButton *)btn pid:(NSString *)pid{

    self.alertView = [[HHSelectChannelAlertView alloc]init];
    self.alertView.close_btn.hidden = NO;
    [self.alertView showAnimated:NO];
    WEAK_SELF();
    self.alertView.commitBlock = ^(NSString *channel) {
        btn.enabled = NO;
        if ([channel isEqualToString:@"0"]) {
            //----->微信支付
                [[[HHMineAPI postOrder_AppPayAddrId:nil orderId:orderid money:nil]netWorkClient]postRequestInView:weakSelf.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                    [weakSelf.alertView hideWithCompletion:nil];
                    btn.enabled = YES;
                    if (!error) {
                        if (api.State == 1) {
                            HHWXModel *model = [HHWXModel mj_objectWithKeyValues:api.Data];
                            HJUser *user = [HJUser sharedUser];
                            user.pids = pid;
                            [user write];
                            [HHWXModel payReqWithModel:model];
                        }else{
                            [SVProgressHUD showInfoWithStatus:api.Msg];
                        }
                    }else {
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }];
        }else{
            //----->支付宝支付
            [[[HHMineAPI postAlipayOrder_AppPayAddrId:nil orderId:orderid money:nil]netWorkClient]postRequestInView:weakSelf.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                [weakSelf.alertView hideWithCompletion:nil];
                btn.enabled = YES;
                if (!error) {
                    if (api.State == 1) {
                        HJUser *user = [HJUser sharedUser];
                        user.pids = pid;
                        [user write];
                        HHAlipayModel *model = [HHAlipayModel mj_objectWithKeyValues:api.Data];
                        if (model.sign) {
                            [[AlipaySDK defaultService] payOrder:model.sign fromScheme:Alipay_appScheme callback:^(NSDictionary *resultDic) {
                                
                            }];
                        }
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }else {
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }];
        }
        
    };

}
- (void)twoAction:(UIButton *)btn{
    
    NSInteger section = btn.tag - 1000;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    HHOrderItemModel *orders_m = self.items_arr[section];

    NSString *status = model.status;
    if ([status isEqualToString:@"1"]) {
        //待付款--->去支付
        if ([model.order_mode isEqual:@16]) {
            //亲密付
            HHFamiliarityPayVC *vc = [HHFamiliarityPayVC new];
            vc.orderId = model.order_id;
            [self.navigationController pushVC:vc];
        }else{
            NSString *pid_str = [orders_m.pids componentsJoinedByString:@","];
           [self payOrderWithorderid:model.order_id btn:btn pid:pid_str];
        }
    }else if([status isEqualToString:@"3"]){
//        //待收货--->确认收货
        [self handleOrderWithorderid:model.order_id status:HHhandle_type_Confirm btn:btn title:@"确认收货？"];
        
    }else if([status isEqualToString:@"5"]){
        //交易成功-->追加评价
        HHPostEvaluationVC *vc = [HHPostEvaluationVC new];
        HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
        HHOrderItemModel *itemModel = self.items_arr[section];
        vc.orderItem_m = itemModel;
        vc.orderId = model.order_id;
        [self.navigationController pushVC:vc];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) backColor:kWhiteColor];
    UILabel *textLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, 60, 40) text:model.status_name textColor:kRedColor font:[UIFont boldSystemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:textLabel];
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+5, 0,1, 40) backColor:KVCBackGroundColor];
    [headView addSubview:downLine];

    CGSize order_date_size = [model.order_date lh_sizeWithFont:[UIFont systemFontOfSize:14]  constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    UILabel *orderLabel = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+20, 0,order_date_size.width+1, 40) text:model.order_date textColor:kBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    orderLabel.centerY = headView.centerY;
    [headView addSubview:orderLabel];
    if (![model.order_mode isEqual:@1]) {
      CGSize mode_size = [model.order_mode_name lh_sizeWithFont:[UIFont systemFontOfSize:14]  constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        UILabel *activityLabel = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(orderLabel.frame)+5, 0,mode_size.width+10, 20) text:model.order_mode_name textColor:kWhiteColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor colorWithHexString:@"#F7BC4B"]];
        activityLabel.centerY = headView.centerY;
        [headView addSubview:activityLabel];
    }
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HHOrderItemModel *orders_m = self.items_arr[section];
    return orders_m.items.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHOrderItemModel *orders_m = self.items_arr[indexPath.section];
    if (indexPath.row == orders_m.items.count) {
        return AdapationLabelHeight(35);
    }else{
        return AdapationLabelHeight(85);
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    return model.footHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return AdapationLabelHeight(40);
}
#pragma mark-微信支付
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KWX_Pay_Fail_Notification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView.mj_header beginRefreshing];
    
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPaySucesscount) name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayFailcount) name:KWX_Pay_Fail_Notification object:nil];
}
- (void)wxPaySucesscount{

    HJUser *user = [HJUser sharedUser];
    HHPaySucessVC *vc = [HHPaySucessVC new];
    vc.pids = user.pids;
    [self.navigationController pushVC:vc];
    
}

- (void)wxPayFailcount {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showErrorWithStatus:@"支付失败～"];
        
    });

}
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    return copy;
}
@end
