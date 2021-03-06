//
//  HHSubmitOrdersVC.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrdersVC.h"
#import "HHSubmitOrderTool.h"
#import "HHSubmitOrderCell.h"
#import "HHSubmitOrdersHead.h"
#import "HHShippingAddressVC.h"
//#import "HHGoodBaseViewController.h"
#import "HHPaySucessVC.h"
#import "HHActivityWebVC.h"
#import "HHSendGiftWebVC.h"
#import "HHSaleGroupWebVC.h"
#import "HHFamiliarityPayVC.h"
#import "HHBargainingWebVC.h"
#import "HHPayTypeVC.h"
#import "HHCouponItem.h"
#import "HHOrderIdItem.h"
#import "HHPayWayCell.h"
#import "HHOrderDetailVC.h"

@interface HHSubmitOrdersVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHShippingAddressVCProtocol,payTypeDelegate>
{
    UITextField *noteTF;
    HHSubmitOrdersHead *SubmitOrdersHead;
    UISwitch *swi;
    HXCommonPickView *pickView;
}

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHSubmitOrderTool *submitOrderTool;
@property (nonatomic, strong)   NSArray *leftTitleArr;
@property (nonatomic, strong)   NSArray *leftTitle2Arr;
@property (nonatomic, strong)   NSMutableArray *rightDetailArr;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   NSString *address_id;
@property (nonatomic, strong)   NSNumber *pay_mode;
@property (nonatomic, strong)   NSString *Id;
@property (nonatomic, strong)   HHMineModel *address_model;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,assign) BOOL  familiarityPay;

@property(nonatomic,strong) NSMutableArray *coupons_copys;
@property(nonatomic,strong) HHcouponsModel *select_coupon_model;

@property(nonatomic,strong) NSMutableArray *integralSelecItems;

@property(nonatomic,strong) NSMutableArray  *payWaySelecItems;

@end

@implementation HHSubmitOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HHCouponItem *couponsModel = [HHCouponItem sharedCouponItem];
    couponsModel.coupon_model = nil;
    couponsModel.lastSelectIndex = 0;
    couponsModel.order_total_money = 0.0f;
    couponsModel.last_total_money = 0.0f;
    [couponsModel write];

    HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
    OrderIdItem.order_id = nil;
    OrderIdItem.pids = self.cartIds_str;
    [OrderIdItem write];
    
    self.page = 1;
    self.leftTitleArr  = @[@"快递运费",@"订单总计"];

    NSArray *arr = @[@"包邮",@"¥0.01"];
    self.rightDetailArr  = arr.mutableCopy;
    
    self.title = @"提交订单";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44-50;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSubmitOrderCell" bundle:nil] forCellReuseIdentifier:@"HHSubmitOrderCell"];
    [self.tableView registerClass:[HHPayWayCell class] forCellReuseIdentifier:@"HHPayWayCell"];
    
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //地址栏
    [self addSubmitOrdersHead];
    
    //底部结算条
    [self addSubmitOrderTool];
    
    //获取收货数据
    [self getAddressData];
    
    [self.payWaySelecItems addObjectsFromArray:@[@1,@0]];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)backBtnAction{
   
    if (self.enter_type == HHaddress_type_Spell_group) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.enter_type == HHaddress_type_add_cart){
        [self.navigationController popToRootVC];
    }else if (self.enter_type == HHaddress_type_add_productDetail){
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 2) {
                [self.navigationController popToVC:vc];
            }
        }];
    }else if(self.enter_type == HHaddress_type_another){
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.enter_type == HHaddress_type_package){
        [self.navigationController popViewControllerAnimated:YES];

    }
}
- (NSMutableArray *)datas{
    
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)coupons_copys{
    if (!_coupons_copys) {
        _coupons_copys = [NSMutableArray array];
    }
    return _coupons_copys;
}
- (NSMutableArray *)integralSelecItems{
    if (!_integralSelecItems) {
        _integralSelecItems = [NSMutableArray array];
    }
    return _integralSelecItems;
}
- (NSMutableArray *)payWaySelecItems{
    if (!_payWaySelecItems) {
        _payWaySelecItems = [NSMutableArray array];
    }
    return _payWaySelecItems;
}
//地址列表
- (void)getAddressData{
    
    [[[HHMineAPI GetAddressListWithpage:@(1)] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSArray *arr = (NSArray *)api.Data;
                self.address_model = [HHMineModel mj_objectWithKeyValues:arr[0]];
                self.address_id = self.address_model.AddrId;
                //设置收货地址
                SubmitOrdersHead.topConstraint.constant = 20;
                SubmitOrdersHead.model = self.address_model;
                
                //获取数据
                [self getDatas];
            }
        }
    }];
}
//获取数据
- (void)getDatas{
    
    [[[HHCartAPI GetConfirmOrderWithids:self.address_id mode:self.mode skuId:self.ids_Str quantity:self.count.numberValue gbId:self.gbId cardIds:self.cartIds_str] netWorkClient] getRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.model =  [HHCartModel mj_objectWithKeyValues:api.Data];
                
                if ([self.model.familiarityPay isEqual:@1]) {
                    self.submitOrderTool.closePay_constant_w.constant = 77;
                    self.submitOrderTool.closePay.hidden = NO;
                }else{
                    self.submitOrderTool.closePay_constant_w.constant = 0;
                    self.submitOrderTool.closePay.hidden = YES;
                }
                self.datas = self.model.orders.mutableCopy;
                NSArray *orders_copys = self.model.orders;
                
                [orders_copys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.integralSelecItems addObject:@0];
                }];
                if (self.model.coupons.count>0) {
                    [self.datas addObject:@"优惠券"];
                }
                //设置地址
                SubmitOrdersHead.addressModel = self.model;
                self.address_id = self.model.addrId;
                
                CGFloat money_total = self.model.totalMoney.floatValue;
                self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%.2f",money_total];
                
                [self.tableView reloadData];
                
                //
                HHCouponItem *couponItem = [HHCouponItem sharedCouponItem];
                couponItem.order_total_money = self.model.totalMoney.floatValue;
                NSMutableArray *arr = [NSMutableArray array];
                [self.model.coupons enumerateObjectsUsingBlock:^(HHcouponsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arr addObject:@0];
                    *stop = 0;
                }];
                
                [arr insertObject:@1 atIndex:0];
                couponItem.selectItems = arr.mutableCopy;
                [couponItem write];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }
    }];
    
}
- (void)addSubmitOrdersHead{
    
    SubmitOrdersHead = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrdersHead" owner:nil options:nil] lastObject];
    SubmitOrdersHead.frame = CGRectMake(0, 8, SCREEN_WIDTH, 100);
    SubmitOrdersHead.userInteractionEnabled = YES;
    //收货地址
    WEAK_SELF();
    [SubmitOrdersHead setTapActionWithBlock:^{
       
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
        vc.delegate = weakSelf;
        vc.enter_type = HHenter_type_submitOrder;
        [weakSelf.navigationController pushVC:vc];
        
    }];
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 108) backColor:KVCBackGroundColor];
    [headView addSubview:SubmitOrdersHead];
    self.tableView.tableHeaderView = headView;
    
}
- (void)addSubmitOrderTool{
    
    self.submitOrderTool  = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrderTool" owner:nil options:nil] lastObject];
    self.submitOrderTool.closePay_constant_w.constant = 0;
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-Status_HEIGHT-44-50, SCREEN_WIDTH, 50)];
    self.submitOrderTool.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
    
    //去付款
    self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled = YES;
    
    [self.submitOrderTool.ImmediatePayLabel setTapActionWithBlock:^{
        
        if ([[self.payWaySelecItems firstObject] isEqual:@1]) {
            //微信支付
            if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
                
                [self prepareCreateOrder];
                
            }else{
                
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"你未安装微信，是否安装？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [alertC dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                [alertC addAction:action1];
                [alertC addAction:action2];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }else{
           //支付宝支付
            [self prepareCreateOrder];

        }
    }];
    
    //亲密付
    self.submitOrderTool.closePay.userInteractionEnabled = YES;
    [self.submitOrderTool.closePay setTapActionWithBlock:^{
        self.familiarityPay = YES;
        self.mode = @16;
        [self createOrder];
    }];
    [toolView addSubview:self.submitOrderTool];
    [self.view addSubview:toolView];
}
//创建订单,预备阶段
- (void)prepareCreateOrder{
    
    self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled = NO;
    self.submitOrderTool.closePay.userInteractionEnabled = NO;
    
    if (self.enter_type == HHaddress_type_Spell_group) {
        //活动拼团
        [self createOrder];
        
    }else if (self.enter_type == HHaddress_type_add_cart){
        if ([self.sendGift isEqual:@1]) {
            //送礼
            [self createOrder];
        }else{
            //购物车
            self.mode = @1;
            [self createOrder];
        }
    }else if (self.enter_type == HHaddress_type_package){
        //优惠套餐
        [self createOrder];
    }else if (self.enter_type == HHaddress_type_add_productDetail){
        //商品详情
        [self createOrder];
    }
}

//创建订单
- (void)createOrder{
    
    HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
    if (OrderIdItem.order_id) {
        [self orderPayWithaddress_id:nil orderId:OrderIdItem.order_id];
    }else{
    
    //优惠券
    NSString *coupon_id=nil;
    HHCouponItem *couponsModel = [HHCouponItem sharedCouponItem];
    if (couponsModel.coupon_model) {
        coupon_id = couponsModel.coupon_model.UserCouponId;
    }else{
        coupon_id = nil;
    }
        //积分
        NSString *integralTempIds_str;
        NSMutableArray *integralTempIds_arr = [NSMutableArray array];
        [self.model.orders enumerateObjectsUsingBlock:^(HHordersModel * order_m, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.integralSelecItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:@1]) {
                    
                    [integralTempIds_arr addObject:order_m.freightId];
                }
            }];
            
        }];
        if (integralTempIds_arr.count>0) {
         integralTempIds_str = [integralTempIds_arr mj_JSONString];
        }
    [[[HHMineAPI postOrder_CreateWithAddrId:self.address_id skuId:self.ids_Str count:self.count mode:self.mode cartIds:self.cartIds_str gbId:self.gbId couponId:coupon_id integralTempIds:integralTempIds_str message:nil]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled  = YES;
        self.submitOrderTool.closePay.userInteractionEnabled = YES;
        if (!error) {
            if (api.State == 1) {
                self.order_id = api.Data;
                //亲密付
                if (self.familiarityPay) {
                    HHFamiliarityPayVC *vc = [HHFamiliarityPayVC new];
                    vc.orderId = self.order_id;
                    [self.navigationController pushVC:vc];
                }else if ([self.mode isEqual:@4096]){
                    HHBargainingWebVC *vc = [HHBargainingWebVC new];
                    vc.orderId = self.order_id;
                    [self.navigationController pushVC:vc];
                } else{
                    //保存创建的订单号
                    HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
                    OrderIdItem.order_id = self.order_id;
                    [OrderIdItem write];
                    
                    [self orderPayWithaddress_id:nil orderId:self.order_id];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
                
            }
        }else {

            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
   
    
     }
  
}

//订单支付
-(void)orderPayWithaddress_id:(NSString *)address_id orderId:(NSString *)orderId{
    
    if ([[self.payWaySelecItems firstObject] isEqual:@1]) {
        //微信支付
        [[[HHMineAPI postOrder_AppPayAddrId:address_id orderId:orderId money:nil]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled  = YES;
            if (!error) {
                if (api.State == 1) {
                    HHWXModel *model = [HHWXModel mj_objectWithKeyValues:api.Data];
                    [HHWXModel payReqWithModel:model];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else {
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
        
    }else{
        //支付宝支付
        [[[HHMineAPI postAlipayOrder_AppPayAddrId:address_id orderId:orderId money:nil]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled  = YES;
            if (!error) {
                if (api.State == 1) {
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
   
}

#pragma mark - HHShippingAddressVCProtocol

- (void)shippingAddressTableView_didSelectRowWithaddressModel:(HHMineModel *)addressModel{
   
    self.address_id = addressModel.AddrId;
    //设置收货地址
    SubmitOrdersHead.topConstraint.constant = 20;
    SubmitOrdersHead.model = addressModel;
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"logo_data_disabled"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂时没有数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:KACLabelColor
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -100;
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.datas.count-1&&self.datas.count>self.model.orders.count) {
     //优惠券
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        }
        UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 43, ScreenW, 1) backColor:KVCBackGroundColor];
        [cell1.contentView addSubview:h_line];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.textLabel.font = FONT(14);
        cell1.detailTextLabel.font = FONT(14);
        cell1.textLabel.text = self.datas[indexPath.section];
        cell1.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        return cell1;
        
    }else if(indexPath.section == self.datas.count){
        //支付方式
      HHPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHPayWayCell"];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSArray *arr = @[@"微信",@"支付宝"];
      NSArray *iconArr = @[@"weixin",@"zhi"];
        cell.iconView.image = [UIImage imageNamed:iconArr[indexPath.row]];
      cell.text_label.text = arr[indexPath.row];
      cell.detail_button.userInteractionEnabled = NO;
      cell.detail_button.selected = ((NSNumber *)self.payWaySelecItems[indexPath.row]).boolValue;
      UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 43, ScreenW, 1) backColor:KVCBackGroundColor];
      [cell.contentView addSubview:h_line];
     return cell;

    }else{
        HHordersModel *order_model = self.datas[indexPath.section];
        if (indexPath.row<order_model.products.count) {
            HHSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitOrderCell"];
            HHproductsModel *model = order_model.products[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.productsModel = model;
            UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, AdapationLabelHeight(100)-1, ScreenW, 1) backColor:KVCBackGroundColor];
            [cell.contentView addSubview:h_line];
            return cell;
        }else{
            UITableViewCell *cell1 =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.textLabel.font = FONT(14);
            cell1.detailTextLabel.font = FONT(14);
            UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 43, ScreenW, 1) backColor:KVCBackGroundColor];
            [cell1.contentView addSubview:h_line];
            cell1.textLabel.text = order_model.addtion_arr[indexPath.row-order_model.products.count];
            cell1.detailTextLabel.text = order_model.addtion_value_arr[indexPath.row-order_model.products.count];
            if (order_model.isCanUseIntegral.integerValue == 1&&indexPath.row == order_model.products.count+order_model.addtion_value_arr.count-1) {
                //可用积分
                UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 35, 35) target:self action:@selector(IntegralSelectAction:) image:[UIImage imageNamed:@"icon_sign_default"]];
                [btn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
                btn.tag = indexPath.section+10000;
                cell1.accessoryView = btn;
                btn.selected = ((NSNumber *)self.integralSelecItems[indexPath.section]).boolValue;
                if (btn.selected) {
                    NSInteger  row = indexPath.row-1;
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",order_model.showMoney.floatValue -  order_model.orderIntegralMoney.floatValue];
                }
            }
            return cell1;
        }
    }
    return nil;
}
//积分选择
- (void)IntegralSelectAction:(UIButton *)btn{
    
    NSInteger section = btn.tag-10000;
    UITableViewCell *btn_cell = (UITableViewCell *)btn.superview;
    NSInteger  row = [self.tableView indexPathForCell:btn_cell].row-1;
    
    if (section == self.datas.count-1&&self.datas.count>self.model.orders.count) {
        
    }else{
        
    __block  float totol_Integral=0;
    [self.model.orders enumerateObjectsUsingBlock:^(HHordersModel *order_model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.integralSelecItems enumerateObjectsUsingBlock:^(NSNumber  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:@1]) {
                totol_Integral = totol_Integral+order_model.orderIntegral.floatValue;
            }
            *stop = 0;
        }];
    }];
        if (btn.selected) {
            btn.selected = NO;
        }else{
          if (totol_Integral>self.model.totalIntegral.floatValue) {
            [SVProgressHUD showInfoWithStatus:@"积分不足"];
          }else{
            btn.selected = YES;
          }
        }
        NSLog(@"totol_Integral:%.2f",totol_Integral);

    //订单总计
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    HHordersModel *order_model = self.datas[section];
    if (btn.selected) {
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",order_model.showMoney.floatValue -  order_model.orderIntegralMoney.floatValue];
        
        //总计
        NSString *money_total_str = [self.submitOrderTool.money_totalLabel.text substringFromIndex:3];
        
        CGFloat money_total =  money_total_str.floatValue - order_model.orderIntegralMoney.floatValue;
        self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%.2f",money_total];
        
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",order_model.showMoney.floatValue];
        
        //总计
        NSString *money_total_str = [self.submitOrderTool.money_totalLabel.text substringFromIndex:3];
        
        CGFloat money_total = money_total_str.floatValue + order_model.orderIntegralMoney.floatValue;
        self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%.2f",money_total];
    }

        [self.integralSelecItems replaceObjectAtIndex:section withObject:@(btn.selected)];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.datas.count>self.model.orders.count&&section == self.datas.count-1) {
        return 1;
    }else if(section == self.datas.count){
        //支付方式
        return 2;
    }else{
        HHordersModel *order_model = self.datas[section];
        return order_model.products.count+order_model.addtion_arr.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.datas.count+1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.datas.count-1&&self.datas.count>self.model.orders.count) {
        return 44;
    }else if(indexPath.section == self.datas.count){
        
        return 44;

    }else{
        HHordersModel *order_model = self.datas[indexPath.section];
      if (indexPath.row<order_model.products.count) {
          return AdapationLabelHeight(100);
      }else{
        return 44;
      }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.datas.count>self.model.orders.count&&indexPath.section == self.datas.count-1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        HHPayTypeVC *vc = [HHPayTypeVC new];
        vc.delegate = self;
        self.coupons_copys = self.model.coupons.mutableCopy;
        HHcouponsModel *coupon_m = [HHcouponsModel new];
        coupon_m.CouponValue = 0;
        coupon_m.DisplayName = @"不使用";
        [self.coupons_copys insertObject:coupon_m atIndex:0];
        vc.coupons = self.coupons_copys;
        NSString *money_total_str = [self.submitOrderTool.money_totalLabel.text substringFromIndex:3];
        vc.total_money = money_total_str;
        vc.submitOrderTool = self.submitOrderTool;
        vc.title_str = @"优惠详情";
        vc.btn_title = @"确   定";
        vc.couponCell = cell;
        [self setUpAlterViewControllerWith:vc WithDistance:ScreenH/2 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
    }
    if (indexPath.section == self.datas.count) {
        NSMutableArray *pay_copys = self.payWaySelecItems.mutableCopy;
        [pay_copys enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (indexPath.row == idx) {
                [self.payWaySelecItems replaceObjectAtIndex:idx withObject:@1];
            }else{
                [self.payWaySelecItems replaceObjectAtIndex:idx withObject:@0];
            }
        }];
        if (indexPath.row == 0) {
            self.submitOrderTool.pay_modeLabel.text = @"微信支付";
        }else{
            self.submitOrderTool.pay_modeLabel.text = @"支付宝支付";
        }
        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UIView *sectionHead =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        sectionHead.backgroundColor = KVCBackGroundColor;
    if (self.datas.count>self.model.orders.count&&section == self.datas.count-1) {
      //优惠券
        
    }else if(section == self.datas.count){
        
        return nil;
    } else{
        UILabel *orderNo = [UILabel lh_labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 35) text:[NSString stringWithFormat:@"订单%ld",section+1] textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        [sectionHead addSubview:orderNo];
    }
    return sectionHead;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.datas.count>self.model.orders.count&&section == self.datas.count-1) {
        //优惠券
        return 5;
        
    }else if(section == self.datas.count){
        return 0.01;
    }else{
        return 35;
    }
}
#pragma mark- payTypeDelegate

- (void)commitActionWithBtn:(UIButton *)btn selectIndex:(NSInteger)selectIndex select_model:(HHcouponsModel *)model total_money:(CGFloat )total_money submitOrderTool:(HHSubmitOrderTool *)submitOrderTool couponCell:(UITableViewCell *)couponCell lastConponValue:(CGFloat)lastConponValue last_total_money:(CGFloat)last_total_money {
    
    if (selectIndex == 0) {
        //不使用
        HHCouponItem *coupon_item = [HHCouponItem sharedCouponItem];
        coupon_item.coupon_model = nil;
        coupon_item.lastSelectIndex = 0;
        [coupon_item write];
        CGFloat money_total;
        if (last_total_money<=lastConponValue) {
            money_total = total_money;
        }else{
            money_total = total_money + lastConponValue;
        }
        submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%.2f",money_total>0?money_total:0.01];
        couponCell.detailTextLabel.text = @"不使用";

    }else{
        
        CGFloat money_total = total_money-model.CouponValue.floatValue;
        submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%.2f",money_total>0?money_total:0.01];
        couponCell.detailTextLabel.text = model.DisplayName;
        
        HHCouponItem *coupon_item = [HHCouponItem sharedCouponItem];
        coupon_item.coupon_model = model;
        coupon_item.lastSelectIndex = selectIndex;
        [coupon_item write];
        
    }
}
#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance WithDirection:(XWDrawerAnimatorDirection)vcDirection WithParallaxEnable:(BOOL)parallaxEnable WithFlipEnable:(BOOL)flipEnable
{
    [self dismissViewControllerAnimated:YES completion:nil]; //以防有控制未退出
    XWDrawerAnimatorDirection direction = vcDirection;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = parallaxEnable;
    animator.flipEnable = flipEnable;
    [self xw_presentViewController:vc withAnimator:animator];
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{

    }];
}
#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark-微信支付

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPaySucesscount) name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayFailcount) name:KWX_Pay_Fail_Notification object:nil];
    
}
- (void)wxPaySucesscount{
    
    HHOrderIdItem *OrderIdItem = [HHOrderIdItem sharedOrderIdItem];
    OrderIdItem.order_id = nil;
    [OrderIdItem write];

    if (self.enter_type == HHaddress_type_Spell_group) {
        //活动拼团----订单详情
        [[[HHMineAPI GetOrderDetailWithorderid:self.order_id] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    //发送删除立即购买的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:DELETE_SHOPITEMSELECTBACK object:nil userInfo:nil];
                    
                    self.model = [HHCartModel mj_objectWithKeyValues:api.Data];
                    if ([self.mode isEqual:@2]) {
                        HHActivityWebVC *vc = [HHActivityWebVC new];
                        vc.gbId = self.model.gbid;
                        [self.navigationController pushVC:vc];
                    }else if([self.mode isEqual:@8]){
                        HHSendGiftWebVC *vc = [HHSendGiftWebVC new];
                        vc.gbId = self.model.gbid;
                        vc.orderId = self.order_id;
                        [self.navigationController pushVC:vc];
                    }else if ([self.mode isEqual:@32]){
                        HHSaleGroupWebVC *vc = [HHSaleGroupWebVC new];
                        vc.gbId = self.model.gbid;
                        [self.navigationController pushVC:vc];
                    }
                }else{
                    
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
        
    }else {
        //购物车
//        HHOrderDetailVC *vc = [HHOrderDetailVC new];
//        vc.orderid = self.order_id;
//        [self.navigationController pushVC:vc];
        HHPaySucessVC *vc =[HHPaySucessVC new];
        vc.pids = self.pids;
        vc.oid = self.order_id;
        [self.navigationController pushVC:vc];
    }
}

- (void)wxPayFailcount {

    //购物车
    HHOrderDetailVC *vc = [HHOrderDetailVC new];
    vc.orderid = self.order_id;
    [self.navigationController pushVC:vc];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];

    return copy;
}
@end
