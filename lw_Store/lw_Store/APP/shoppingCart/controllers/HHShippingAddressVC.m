//
//  HHShippingAddressVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHShippingAddressVC.h"
#import "HHShippingAddressCell.h"
#import "HHAddAdressVC.h"

@interface HHShippingAddressVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@end

@implementation HHShippingAddressVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //获取数据
    [self.datas removeAllObjects];
    [self getDatas];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收货地址";
    
    self.page =1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44 ;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHShippingAddressCell" bundle:nil] forCellReuseIdentifier:@"HHShippingAddressCell"];
    
    UIButton *addAddressBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50-Status_HEIGHT-44, SCREEN_WIDTH, 50) target:self action:@selector(addAddressAction) image:nil];
    [addAddressBtn setBackgroundColor:kWhiteColor];
    [addAddressBtn setTitle:@"+新增收货地址" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [self.view addSubview:addAddressBtn];
    
    [self addHeadRefresh];
    [self addFootRefresh];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    self.tableView.separatorColor = LineLightColor;

}

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_address"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"收货地址为空" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//
//    return [[NSAttributedString alloc] initWithString:@"别让自己的宝贝无家可归" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
//
//}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 20;
    
}

- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.datas removeAllObjects];
        self.page = 1;
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        
        [self getDatas];
    }];
    refreshfooter.stateLabel.textColor = KACLabelColor;
    self.tableView.mj_footer = refreshfooter;
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if (self.datas.count == 0) {
        self.tableView.mj_footer.hidden = YES;
    }
    
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
        
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
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
- (void)getDatas{
    
    [[[HHMineAPI GetAddressListWithpage:@(self.page)] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self loadDataFinish:api.Data];
            }
        }
    }];
    
}
- (void)addAddressAction{
    
    HHAddAdressVC *vc = [HHAddAdressVC new];
    vc.titleStr = @"新增收货地址";
    vc.addressType = HHAddress_addType;
    [self.navigationController pushVC:vc];
    
}
- (void)editAddressBtnAction:(UIButton *)btn{
    HHAddAdressVC *vc = [HHAddAdressVC new];
    vc.titleStr = @"编辑收货地址";
    vc.addressType = HHAddress_editType;
    NSIndexPath *indexPath =  [self.tableView indexPathForCell:(HHShippingAddressCell *)btn.superview.superview];
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    vc.Id = model.AddrId;
    vc.province = model.Province;
    vc.city = model.City;
    vc.region = model.District;
    [self.navigationController pushVC:vc];
    
}
- (void)deleteAddressBtnAction:(UIButton *)btn{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除收货地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger section = btn.tag - 100;
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[section]];
        
        [[[HHMineAPI postDeleteAddressWithId:model.AddrId] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [self.datas removeObjectAtIndex:section];
                    [self.tableView reloadData];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
            
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHShippingAddressCell"];
    cell.shippingAddressModel =  [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    [cell.editAddressBtn addTarget:self action:@selector(editAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteAddressBtn.tag = indexPath.section+100;
    [cell.deleteAddressBtn addTarget:self action:@selector(deleteAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.enter_type == HHenter_type_submitOrder) {
        cell.editAddressBtn.hidden = YES;
        cell.deleteAddressBtn.hidden = YES;
    }else if (self.enter_type == HHenter_type_mine){
        cell.editAddressBtn.hidden = NO;
        cell.deleteAddressBtn.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHMineModel *shippingAddressModel = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    if (self.enter_type == HHenter_type_submitOrder) {
        [self.navigationController popVC];
    }
    if ([self.delegate respondsToSelector:@selector(shippingAddressTableView_didSelectRowWithaddressModel:)
         ]) {
        [self.delegate shippingAddressTableView_didSelectRowWithaddressModel:shippingAddressModel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
//- (id)copyWithZone:(NSZone *)zone
//{
//    id copy = [[[self class] alloc] init];
//
//
//    return copy;
//}

@end
