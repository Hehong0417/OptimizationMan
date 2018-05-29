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

@interface HHSubmitOrdersVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHShippingAddressVCProtocol>
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

@end

@implementation HHSubmitOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSubmitOrderCell" bundle:nil] forCellReuseIdentifier:@"HHSubmitOrderCell"];
    
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    //地址栏
    [self addSubmitOrdersHead];
    
    //底部结算条
    [self addSubmitOrderTool];
    
    //获取收货数据
    [self getAddressData];
    
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
   
    if (self.enter_type == HHaddress_type_another) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.enter_type == HHaddress_type_add_cart){
        [self.navigationController popToRootVC];
    }else if (self.enter_type == HHaddress_type_add_productDetail){
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 2) {
                [self.navigationController popToVC:vc];
            }
        }];
    }
}
- (NSMutableArray *)datas{
    
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)addSubmitOrdersHead{
    
    SubmitOrdersHead = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrdersHead" owner:nil options:nil] lastObject];
    SubmitOrdersHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    SubmitOrdersHead.userInteractionEnabled = YES;
    //收货地址
    WEAK_SELF();
    [SubmitOrdersHead setTapActionWithBlock:^{
       
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
        vc.delegate = weakSelf;
        vc.enter_type = HHenter_type_submitOrder;
        [weakSelf.navigationController pushVC:vc];
        
    }];
    self.tableView.tableHeaderView = SubmitOrdersHead;
    
}
- (void)addSubmitOrderTool{
    
    self.submitOrderTool  = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrderTool" owner:nil options:nil] lastObject];
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-Status_HEIGHT-44-50, SCREEN_WIDTH, 50)];
    self.submitOrderTool.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
    
    //去付款
    self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled = YES;
    [self.submitOrderTool.ImmediatePayLabel setTapActionWithBlock:^{
//        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.color = KA0LabelColor;
//        hud.detailsLabelText = @"付款中...";
//        hud.detailsLabelColor = kWhiteColor;
//        hud.detailsLabelFont = FONT(14);
//        hud.activityIndicatorColor = kWhiteColor;
//        [hud showAnimated:YES];
//
//        HJUser *user = [HJUser sharedUser];
//        NSString *ids = [self.ids_Arr componentsJoinedByString:@","];
        HHPaySucessVC *vc = [HHPaySucessVC new];
        [self.navigationController pushVC:vc];
        
    }];
    [toolView addSubview:self.submitOrderTool];
    [self.view addSubview:toolView];
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

//获取数据
- (void)getDatas{
    
        [[[HHCartAPI GetConfirmOrderWithids:self.address_id] netWorkClient] getRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
                if (!error) {
            
                    if (api.State == 1) {
                        
                        self.model =  [HHCartModel mj_objectWithKeyValues:api.Data];
                        
                        self.datas = self.model.orders.mutableCopy;
                        
                        //设置地址
                        SubmitOrdersHead.addressModel = self.model;
                        self.address_id = self.model.addrId;
                        
                        
                        CGFloat money_total = self.model.totalMoney.floatValue;
                        self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%.2f",money_total];
                        [self.tableView reloadData];
                        
                    }else{
                        
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }
        }];

    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHordersModel *model = self.model.orders[indexPath.section];
    
    if (indexPath.row == self.model.orders[indexPath.section].products.count||indexPath.row == self.model.orders[indexPath.section].products.count+1) {
        
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.textLabel.font = FONT(14);
        cell1.detailTextLabel.font = FONT(14);
        cell1.textLabel.text = self.leftTitleArr[indexPath.row-self.model.orders[indexPath.section].products.count];
        if (indexPath.row == self.model.orders[indexPath.section].products.count) {
            cell1.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model.freight];
        }else{
            cell1.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model.money];
        }
        
        return cell1;
        
    }else{
        
        HHSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitOrderCell"];
        HHordersModel *order_m = self.datas[indexPath.section];
        HHproductsModel *model = order_m.products[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.productsModel = model;
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return self.model.orders[section].products.count+2;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.model.orders.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.model.orders[indexPath.section].products.count||indexPath.row == self.model.orders[indexPath.section].products.count+1) {
        return 44;
    }else{
        return 95;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
//        HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
//        HHproductsModel *model = self.datas[indexPath.row];
//        vc.Id = model.pid;
//        [self.navigationController pushVC:vc];
        
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UIView *sectionHead =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        sectionHead.backgroundColor = KVCBackGroundColor;
        UILabel *orderNo = [UILabel lh_labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 35) text:[NSString stringWithFormat:@"订单%ld",section+1] textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
        [sectionHead addSubview:orderNo];
        
        return sectionHead;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return 35;
}



@end
