//
//  HHOrderDetailVC.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderDetailVC.h"
#import "HHSubmitOrderCell.h"
#import "HHOrderDetailCellOne.h"
#import "HHOrderDetailHead.h"
#import "HHOrderDetailTableHead.h"
#import "HHMyOrderItem.h"
#import "HHOrderItemModel.h"


@interface HHOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *orderIdLabel;
    UILabel *createdateLabel;
    HHOrderDetailTableHead *subhead;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   UILabel *orderIdLabel;
@property (nonatomic, strong)   UILabel *createdateLabel;

@end

@implementation HHOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT - 44 ;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSubmitOrderCell" bundle:nil] forCellReuseIdentifier:@"HHSubmitOrderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHOrderDetailCellOne" bundle:nil] forCellReuseIdentifier:@"HHOrderDetailCellOne"];
//    20w   2 + 10 + 4
    //添加头部
    [self addTableHeader];
    
    //获取数据
    [self getDatas];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - 加载数据
- (void)getDatas{
    
    [[[HHMineAPI GetOrderDetailWithorderid:self.orderid] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
        
                    self.model = [HHCartModel mj_objectWithKeyValues:api.Data];
                    orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.model.orderid];
                    createdateLabel.text = [NSString stringWithFormat:@"下单时间：%@",self.model.orderDate];
                    subhead.order_status_label.text = self.model.statusName;
                  [self.model.prodcuts enumerateObjectsUsingBlock:^(HHproductsModel *  product_model, NSUInteger idx, BOOL * _Nonnull stop) {
                    [product_model.skuid  enumerateObjectsUsingBlock:^(HHskuidModel *  sku_model, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        HHproductsModel *model = [HHproductsModel new];
                        model.icon = product_model.icon;
                        model.pname = product_model.pname;
                        model.price = sku_model.Price;
                        model.quantity = sku_model.Quantity;
                        model.sku_name = sku_model.Value;
                        model.OrderItemStatus = sku_model.OrderItemStatus;
                        model.RefundId = sku_model.RefundId;
                        model.item_id = sku_model.OrdetItemId;

                        [self.datas addObject:model];
                        
                    }];
                    
                }];
                    [self.tableView reloadData];
                
                    
            }else{

                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];

        }
    }];
    
}
- (void)addTableHeader{
    
    UIView *tableHead = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 100) backColor:KVCBackGroundColor];
    tableHead.backgroundColor = KVCBackGroundColor;

    subhead = [[[NSBundle mainBundle] loadNibNamed:@"HHOrderDetailTableHead" owner:self options:nil] lastObject];
    orderIdLabel = [UILabel lh_labelWithFrame:CGRectMake(41,35 , ScreenW, 30) text:@"订单编号：" textColor:kBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
    createdateLabel = [UILabel lh_labelWithFrame:CGRectMake(41,65 , ScreenW, 30) text:@"下单时间：" textColor:kBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
    [tableHead addSubview:subhead];
    [tableHead addSubview:orderIdLabel];
    [tableHead addSubview:createdateLabel];

    self.tableView.tableHeaderView = tableHead;
}
- (void)addPayBtn{
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, ScreenH - 50-Status_HEIGHT-44, SCREEN_WIDTH, 50) backColor:kWhiteColor];
    
    UIButton *oneBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-140, 10, 60, 30) target:self action:@selector(oneAction:) title:@"取消" titleColor:APP_COMMON_COLOR font:FONT(16) backgroundColor:kWhiteColor];
    [oneBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:oneBtn];
    
    UIButton *twoBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 60, 30) target:self action:@selector(twoAction:) title:@"去支付" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_COMMON_COLOR];
    [twoBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:twoBtn];
    
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) backColor:KVCBackGroundColor];
    [footView addSubview:downLine];
    
    [self.view addSubview:footView];
    
}
- (void)oneAction:(UIButton *)btn{
    
    
}
- (void)twoAction:(UIButton *)btn{
    
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    
    if (indexPath.section == 0) {
        
        HHOrderDetailCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderDetailCellOne"];
        cell.addressModel = self.model;
        gridCell = cell;
        
    }else if (indexPath.section == 1){
        
        HHSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitOrderCell"];
        cell.productsModel =  self.datas[indexPath.row];
        [self setStandardLabWith:self.datas[indexPath.row] cell:cell];
        [cell.StandardLab setTapActionWithBlock:^{
            [self pushVCWith:self.datas[indexPath.row]];
        }];
        gridCell = cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.font = FONT(14);
        cell.detailTextLabel.font = FONT(14);
        if (indexPath.row == 0) {
            cell.textLabel.text = @"快递运费";
            NSString *detailText;
            if ([self.model.freight isEqualToString:@"0"]) {
                detailText  = @"包邮";
            }else{
                detailText  = self.model.freight;
            }
            cell.detailTextLabel.text = detailText;
            
        }else  if (indexPath.row == 1){
            cell.textLabel.text = @"订单总计";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.model.payTotal?self.model.payTotal:@""];

        }else {
            cell.textLabel.text = @"实付";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.model.payTotal?self.model.payTotal:@""];
        }

        gridCell = cell;
    }
    
    gridCell.selectionStyle = UITableViewCellSelectionStyleNone;
    gridCell.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    return gridCell;
}
//设置退款退货按钮状态
-(void)setStandardLabWith:(HHproductsModel *)productModel cell:(HHSubmitOrderCell *)cell{
    cell.StandardLab.hidden = NO;
    [HHMyOrderItem shippingLogisticsStateWithStatus_code:productModel.OrderItemStatus.integerValue submitCell:cell];
}
//跳转对应控制器
-(void)pushVCWith:(HHproductsModel *)productModel{
    WEAK_SELF();
    [HHMyOrderItem orderDetailpushVCWithStatus_code:productModel.OrderItemStatus.integerValue navC:weakSelf.navigationController VC:weakSelf product_m:productModel order_id:self.model.orderid];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0){
        return 1;
    }else if (section == 1)
   {
        return self.datas.count;
    }else  {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 80;
    }else  if(indexPath.section == 1){
        return 110;
    }else{
        return 50;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    headView.backgroundColor = kWhiteColor;
    HHOrderDetailHead *head = [[[NSBundle mainBundle] loadNibNamed:@"HHOrderDetailHead" owner:self options:nil] lastObject];
    if (section == 0) {
        head.iconImageV.image = [UIImage imageNamed:@"icon_address_default"];
        head.titleLabel.text = @"收货信息";
    }else if (section == 1){
        head.iconImageV.image = [UIImage imageNamed:@"icon_mark_default"];
        head.titleLabel.text = @"商品信息";
    }else{
        head.iconImageV.image = [UIImage imageNamed:@""];
        head.titleLabel.text = @"";
    }
    [headView addSubview:head];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.01;
    }else{
      return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }else{
      return 40;
    }
}

@end
