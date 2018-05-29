//
//  HHTransactionRecordVC.m
//  Store
//
//  Created by User on 2018/1/26.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHTransactionRecordVC.h"
#import "HHGoodDealRecordInfoDetailCell.h"
#import "HHHomeAPI.h"
#import "HHtransactionRecordView.h"

@interface HHTransactionRecordVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    
}

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@end
static NSString *HHGoodDealRecordInfoDetailCellID = @"HHGoodDealRecordInfoDetailCell";//月成交记录信息详情

@implementation HHTransactionRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"月成交记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KVCBackGroundColor;
    
    self.page = 1;
    self.datas = [NSMutableArray array];
    
    //获取数据
    [self getDatas];
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44 - 40;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHGoodDealRecordInfoDetailCell" bundle:nil] forCellReuseIdentifier:HHGoodDealRecordInfoDetailCellID];
    
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 40) backColor:kWhiteColor];
    HHtransactionRecordView *transactionRecordView = [[[NSBundle mainBundle] loadNibNamed:@"HHtransactionRecordView" owner:self options:nil] lastObject];
    transactionRecordView.frame = CGRectMake(0, 0, ScreenW, 40);
    [self.view addSubview:headView];
    [headView addSubview:transactionRecordView];
    
    [self addHeadRefresh];
    [self addFootRefresh];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
}
- (void)getDatas{
    
    //月成交记录
    [[[HHHomeAPI GetFinishLogId:self.Id page:@(self.page) pageSize:@20] netWorkClient] getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 0) {
                NSArray  *arr = api.Data[@"list"];
                [self loadDataFinish:arr];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
                
            }
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
        
    }];
    

}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"img_list_disable"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"您还没有相关的奖金日志～" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:APP_purple_Color}];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
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
    self.tableView.mj_footer = refreshfooter;
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if (self.datas.count <10) {
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
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHGoodDealRecordInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:HHGoodDealRecordInfoDetailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HHHomeModel *model = [HHHomeModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    cell.model = model;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}


@end
