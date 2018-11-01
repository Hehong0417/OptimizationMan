//
//  CartVC.m
//  Store
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHShoppingVC.h"
#import "HHCartCell.h"
#import "HHCartFootView.h"
#import "HHSubmitOrdersVC.h"
#import "HHGoodBaseViewController.h"
#import "HHtEditCarItem.h"
#import "HHGoodListVC.h"
#import "HHAddAdressVC.h"

@interface HHShoppingVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger  count;
    NSInteger  subcount;
    UILabel *tipLabel;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHCartFootView *settleAccountView;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   NSString *money_total;
@property (nonatomic, strong)   NSString *s_integral_total;
@property (nonatomic, strong)   NSMutableArray *selectItems;

@end

@implementation HHShoppingVC

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //是否登录
    [self isLoginOrNot];
    
    //获取数据
    [self getDatas];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    self.title = @"购物车";
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //返回按钮
    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 30, 45) target:self action:@selector(backBtnAction) image:[UIImage imageNamed:@"icon_return_default"]];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    //tableView

    CGFloat tableHeight;
    if (self.cartType == HHcartType_goodDetail) {
        tableHeight = SCREEN_HEIGHT-Status_HEIGHT-44 - 50;
        backBtn.hidden = NO;
        
    }else{
        tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44 - 50 - 49;
        backBtn.hidden = YES;

    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHCartCell" bundle:nil] forCellReuseIdentifier:@"HHCartCell"];
    
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    //顶部提示条
    [self addTipHeadView];

    //底部结算条
    [self addSettleAccountView];
    

}
- (void)backBtnAction{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cartVCBackActionHandle)]) {
        
        [self.delegate cartVCBackActionHandle];
    }
    
    [self.navigationController popVC];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_cart"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{

  return [[NSAttributedString alloc] initWithString:@"购物车列表为空" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//
//    return [[NSAttributedString alloc] initWithString:@"再忙也要犒劳下自己" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
//
//}
//
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//
//    return [[NSAttributedString alloc] initWithString:@"去逛逛" attributes:@{NSFontAttributeName:BoldFONT(18),NSForegroundColorAttributeName:kWhiteColor}];
//
//}
//
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
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
//
//    HHGoodListVC *vc = [HHGoodListVC new];
//    vc.type = nil;
//    vc.categoryId = nil;
//    vc.name = nil;
//    vc.orderby = nil;
//    [self.navigationController pushVC:vc];
//
//}

- (void)isLoginOrNot{
    //
    
//    HJUser *user = [HJUser sharedUser];
//    if (user.token.length == 0) {
//        //判断是否登录
//        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
//        vc.tabBarVC = self.tabBarController;
//        vc.tabSelectIndex = 2;
//        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
//    }else{
//        //获取数据
//        [self getDatas];
//    }
}
//获取数据
- (void)getDatas{
    
    [[[HHCartAPI GetCartProducts] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {

        if (!error) {
            if (api.State == 1) {

                self.model  =  [HHCartModel mj_objectWithKeyValues:api.Data];
                if ([self.model.sendGift isEqual:@1]) {
                    self.settleAccountView.sendGift_label.hidden = NO;
                    self.settleAccountView.sendGift_widthConstant.constant = 80;
                }else{
                    self.settleAccountView.sendGift_label.hidden = YES;
                    self.settleAccountView.sendGift_widthConstant.constant = 0;
                }
                
                [self getShopCartListFinsih:self.model];

            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{

            [SVProgressHUD showInfoWithStatus:api.Msg];
        }

    }];
}
- (void)getShopCartListFinsih:(HHCartModel *)data {
    NSArray *arr = [data.products mutableCopy];
    
    self.datas = [data.products mutableCopy];
    if (self.datas.count ==0) {
        tipLabel.hidden = YES;
        if (self.cartType == HHcartType_goodDetail) {
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-Status_HEIGHT-44);
        }else{
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-49-Status_HEIGHT-44);
        }
        self.settleAccountView.hidden = YES;
    }else{
        self.settleAccountView.hidden = NO;
        tipLabel.hidden = NO;

        if (self.cartType == HHcartType_goodDetail) {
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-50-Status_HEIGHT-44);
        }else{
           self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-49-50-Status_HEIGHT-44);
        }
    }
    self.settleAccountView.selectBtn.selected = NO;
    
    //全选左边点击数据源
    self.selectItems = [NSMutableArray array];
    [self.datas enumerateObjectsUsingBlock:^(HHproductsModel *productsModel, NSUInteger idx, BOOL *stop) {
        [self.selectItems addObject:@0];
    }];
    //新增
    [self.tableView reloadData];
}
- (void)addTipHeadView{
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    tipLabel.font = FONT(13);
    tipLabel.text = @"提示：请尽快提交订单，避免现有商品售完无法下单！";
    tipLabel.backgroundColor = kWhiteColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = tipLabel;
    
}
- (void)addSettleAccountView{
    
    self.settleAccountView  = [[[NSBundle mainBundle] loadNibNamed:@"HHCartFootView" owner:self options:nil] lastObject];
    self.settleAccountView.sendGift_label.hidden = YES;
    self.settleAccountView.sendGift_widthConstant.constant = 0;
    CGFloat settleView_y;
    if (self.cartType == HHcartType_goodDetail) {
        settleView_y = SCREEN_HEIGHT- 49-Status_HEIGHT -44;
    }else{
        settleView_y = SCREEN_HEIGHT-49-50-Status_HEIGHT-44;
    }
    UIView *settleView = [[UIView alloc] initWithFrame:CGRectMake(0, settleView_y, SCREEN_WIDTH, 50)];
    self.settleAccountView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.settleAccountView.settleBtn.userInteractionEnabled = YES;

    [settleView addSubview:self.settleAccountView];
    [self.view addSubview:settleView];
    
    //全选
    WEAK_SELF();
    self.settleAccountView.allChooseBlock = ^(NSNumber *allSelected) {
        [weakSelf caculateSettleGoodsListBaseLeftSelectArrIsAllSelected:allSelected.boolValue];
    };

    //送礼
    self.settleAccountView.sendGift_label.userInteractionEnabled = YES;
    [self.settleAccountView.sendGift_label setTapActionWithBlock:^{
       
        if ([self.selectItems containsObject:@1]) {
            [self isExitAddressWithSendGift:@1];
        }else{
            [SVProgressHUD showInfoWithStatus:@"您还没有选择宝贝哦～"];
        }

    }];
    
    //提交订单
    [self.settleAccountView.settleBtn setTapActionWithBlock:^{

        if ([self.selectItems containsObject:@1]) {
            [self isExitAddressWithSendGift:@0];
        }else{
            [SVProgressHUD showInfoWithStatus:@"您还没有选择宝贝哦～"];
        }
    }];
}
//是否存在收货地址
- (void)isExitAddressWithSendGift:(NSNumber *)sendGiftBtnSelected{
    
    [[[HHCartAPI IsExistOrderAddress] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *cartIds = [self getNewSelect_cartids];
                NSString *cartIds_str = [cartIds componentsJoinedByString:@","];
                
                if ([api.Data isEqual:@1]) {
                    HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                    vc.cartIds_str = cartIds_str;
                    
                    if ([self.model.sendGift isEqual:@1]) {
                        if ([sendGiftBtnSelected isEqual:@1]) {
                            vc.enter_type = HHaddress_type_Spell_group;
                            vc.sendGift = self.model.sendGift;
                            vc.mode = @8;
                        }else{
                            vc.mode = @1;
                            vc.enter_type = HHaddress_type_add_cart;
                        }
                    }else{
                        vc.mode = @1;
                        vc.enter_type = HHaddress_type_add_cart;
                    }
                    [self.navigationController pushVC:vc];
                }else{
                    HHAddAdressVC *vc = [HHAddAdressVC new];
                    vc.addressType = HHAddress_settlementType_cart;
                    vc.cartIds_str = cartIds_str;
                    if ([self.model.sendGift isEqual:@1]) {
                        if ([sendGiftBtnSelected isEqual:@1]) {
                          vc.mode = @8;
                          vc.sendGift = self.model.sendGift;
                        }else{
                          vc.mode = @1;

                        }
                    }else{
                          vc.mode = @1;
                    }
                    vc.titleStr = @"新增收货地址";
                    [self.navigationController pushVC:vc];
                }
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];

}
//加
- (void)plusBtnAction:(UIButton *)btn{
    
    HHCartCell *cell = (HHCartCell *)btn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHproductsModel *model = self.model.products[indexPath.section];

    if (model.quantity.integerValue>1) {
        cell.minusBtn.enabled = YES;
    }
    NSInteger  quantity = model.quantity.integerValue;
    quantity++;
    
    [self plusQuantityWithcart_id:model.skuId quantity:@"1" cartCell:cell];
    
}
//减
- (void)minusBtnAction:(UIButton *)btn{

     HHCartCell *cell = (HHCartCell *)btn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHproductsModel *model = self.model.products[indexPath.section];
    if (model.quantity.integerValue<=1) {
        btn.enabled = NO;
    }else{
        
        NSInteger   quantity = model.quantity.integerValue;
        quantity--;
        [self minusQuantityWithcart_id:model.cartid quantity:@"-1"  cartCell:cell];
      
    }
}
- (void)plusQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity cartCell:(HHCartCell *)cartCell{
   
    [[[HHCartAPI postAddQuantityWithcart_id:cart_id quantity:quantity] netWorkClient] postRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self refreshData];

            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
}
- (void)minusQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity cartCell:(HHCartCell *)cartCell{
    
    [[[HHCartAPI postminusQuantityWithcart_id:cart_id quantity:quantity] netWorkClient] postRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self refreshData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}

- (void)refreshData{
    
    [[[HHCartAPI GetCartProducts] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                [self.datas removeAllObjects];
                self.model  =  [HHCartModel mj_objectWithKeyValues:api.Data];
                self.datas = [self.model.products mutableCopy];
                HHtEditCarItem *editCarItem  = [HHtEditCarItem shopCartGoodsList:self.datas selectionArr:self.selectItems];
                self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
                self.settleAccountView.selectBtn.selected = editCarItem.settleAllSelect;
//                self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥%@",self.model.total?self.model.total:@"0.00"];

                [self.tableView reloadData];
            }
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}
- (void)caculateSettleGoodsListBaseLeftSelectArrIsAllSelected:(BOOL )allSelect{
    
    [self.selectItems removeAllObjects];
    [self.datas enumerateObjectsUsingBlock:^(HHproductsModel *productsModel, NSUInteger idx, BOOL *stop) {
        [self.selectItems addObject:@(allSelect)];
    }];
    [self caculateSettleGoodsListBaseLeftSelectArr];
    
}
- (void)caculateSettleGoodsListBaseLeftSelectArr {
    
    HHtEditCarItem *editCarItem = [HHtEditCarItem shopCartGoodsList:self.datas selectionArr:self.selectItems];
    self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
    
    [self.tableView reloadData];
}
//cartid数组
- (NSMutableArray *)getNewSelect_cartids{
    
    NSMutableArray *cartIds_arr = [NSMutableArray array];
    
    [self.datas enumerateObjectsUsingBlock:^(HHproductsModel *productsModel, NSUInteger idx1, BOOL * _Nonnull stop) {
        [self.selectItems enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx2, BOOL * _Nonnull stop) {
            if ([obj isEqual:@1] && (idx1 == idx2)) {
                [cartIds_arr addObject:productsModel.cartid];
            }
        }];
    }];
    return cartIds_arr;
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHCartCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HHproductsModel *model = self.model.products[indexPath.section];
    cell.productModel = model;
    [cell.plusBtn addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusBtn addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (model.quantity.integerValue <= 1) {
        cell.minusBtn.enabled = NO;
    }else{
        cell.minusBtn.enabled = YES;
    }
    cell.indexPath = indexPath;
    cell.leftSelected = ((NSNumber *)self.selectItems[indexPath.section]).boolValue;
    WEAK_SELF();
    cell.ChooseBtnSelectAction = ^(NSIndexPath *indexPath, BOOL chooseBtnSelected) {
        [weakSelf.selectItems replaceObjectAtIndex:indexPath.section withObject:@(chooseBtnSelected)];

        HHtEditCarItem *editCarItem  = [HHtEditCarItem shopCartGoodsList:weakSelf.datas selectionArr:weakSelf.selectItems];
        self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
        self.settleAccountView.selectBtn.selected = editCarItem.settleAllSelect;
    };
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.model.products.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HHproductsModel *model = self.model.products[indexPath.section];

    HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
    vc.Id = model.pid;
    [self.navigationController pushVC:vc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HHproductsModel *model = self.model.products[indexPath.section];
        [[[HHCartAPI postShopCartDeleteWithcart_id:model.cartid] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [self.datas removeAllObjects];
                    [self deleteGetData];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)deleteGetData{
    
    [self getDatas];
 
}
@end
