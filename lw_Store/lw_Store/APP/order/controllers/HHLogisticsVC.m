//
//  HHLogisticsVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHLogisticsVC.h"
#import "HHLogisticsCell.h"
#import "HHLogisticsCell1.h"

@interface HHLogisticsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   HHMineModel *model;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   UILabel *detail1;
@property (nonatomic, strong)   UILabel *detail2;
@property (nonatomic, strong)   UILabel *message_label;


@end

@implementation HHLogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物流信息";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64 ;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHLogisticsCell" bundle:nil] forCellReuseIdentifier:@"HHLogisticsCell"];
       [self.tableView registerNib:[UINib nibWithNibName:@"HHLogisticsCell1" bundle:nil] forCellReuseIdentifier:@"HHLogisticsCell1"];
    
    UIView *headView= [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90) backColor:kWhiteColor];
    UILabel *title1 = [UILabel lh_labelWithFrame:CGRectMake(20, 15, 65, 25) text:@"物流公司" textColor:KLightTitleColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:title1];
    UILabel *title2 = [UILabel lh_labelWithFrame:CGRectMake(20, CGRectGetMaxY(title1.frame)+10, 65, 25) text:@"物流单号" textColor:KLightTitleColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:title2];
    
    self.detail1 = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(title1.frame)+10, 15, SCREEN_WIDTH - CGRectGetMaxX(title1.frame)-20, 25) text:@"" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:self.detail1];
    self.detail2 = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(title2.frame)+10, CGRectGetMaxY(self.detail1.frame)+10, SCREEN_WIDTH - CGRectGetMaxX(title2.frame)-20, 25) text:@"" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:self.detail2];
    self.tableView.tableHeaderView = headView;
    
    self.message_label = [UILabel lh_labelWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-100, 100) text:@"" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:KVCBackGroundColor];
    self.message_label.numberOfLines = 4;
    self.message_label.centerY = self.view.centerY-50;
    self.message_label.centerX = self.view.centerX;

    self.message_label.hidden = YES;
    [self.view addSubview:self.message_label];
    
    [self getDatas];
    
}
- (NSMutableArray *)datas{
    
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)getDatas{
    
    if ([self.type isEqual:@1]) {
        //查看物流
        [self GetOrderLogistics];
        
    }else{
        //退货物流
        [self GetRefundIdOrderExpress];
    }
    
}
//查看物流
- (void)GetOrderLogistics{
    [[[HHMineAPI GetOrderLogisticsWithOrderId:self.orderid] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.model = [HHMineModel mj_objectWithKeyValues:api.Data];
                self.detail1.text = self.model.express_company;
                self.detail2.text = self.model.order_number;
                self.datas = [HHExpress_message_list mj_objectArrayWithKeyValuesArray:self.model.express[@"data"]];
                NSString *message = self.model.express[@"message"];
                if (![message isEqualToString:@"ok"]) {
                    self.message_label.hidden = NO;
                    self.message_label.text = message;
                }else{
                    self.message_label.hidden = YES;
                }
                [self.tableView reloadData];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}
//退货物流
- (void)GetRefundIdOrderExpress{
    [[[HHMineAPI GetOrderExpressWithRefundId:self.refundId] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                self.model = [HHMineModel mj_objectWithKeyValues:api.Data];
                self.detail1.text = self.model.express_company;
                self.detail2.text = self.model.order_number;
                self.datas = [HHExpress_message_list mj_objectArrayWithKeyValuesArray:self.model.express[@"data"]];
                NSString *message = self.model.express[@"message"];
                if (![message isEqualToString:@"ok"]) {
                    self.message_label.hidden = NO;
                    self.message_label.text = message;
                }else{
                    self.message_label.hidden = YES;
                }
                [self.tableView reloadData];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
}
- (void)addAddressAction{
    
    
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    
    if (indexPath.row == 0) {
        HHLogisticsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"HHLogisticsCell1"];
        cell.model =  self.datas[indexPath.row];
        gridCell = cell;
    }else{
        HHLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHLogisticsCell"];
        cell.model =  self.datas[indexPath.row];
        gridCell = cell;
    }
    return gridCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WidthScaleSize_H(95);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

@end
