//
//  HHMyIntegralListVC.m
//  lw_Store
//
//  Created by User on 2018/5/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyIntegralListVC.h"
#import "HHMyIntegralCell.h"
#import "HHCommissionTVC.h"
#import "HHSendIntegralVC.h"

@interface HHMyIntegralListVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@end

@implementation HHMyIntegralListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的积分";
    
    [self.tableView registerClass:[HHMyIntegralCell class] forCellReuseIdentifier:@"HHMyIntegralCell"];
    self.page =1;

    [self addHeadRefresh];
    [self addFootRefresh];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.tableView.separatorColor = LineLightColor;
    
    UIButton *rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 60, 44) target:self action:@selector(setBtnAction) image:nil];
    [rightBtn setTitle:@"赠送积分" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(13);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self getDatas];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)setBtnAction{
    
    HHSendIntegralVC *vc = [HHSendIntegralVC new];
    [self.datas removeAllObjects];
    vc.completeBlock = ^{
        
        [self getDatas];
    };
    [self.navigationController pushVC:vc];
}
#pragma mark -加载数据
- (void)getDatas{
    
    [[[HHMineAPI GetIntegralListWithPage:@(self.page)] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self loadDataFinish:api.Data];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_order"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"积分列表为空" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMyIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMyIntegralCell"];
    
    cell.model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}


@end
