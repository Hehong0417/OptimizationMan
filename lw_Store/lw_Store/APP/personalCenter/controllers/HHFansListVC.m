//
//  HHFansListVC.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHFansListVC.h"
#import "HHFansListCell.h"
#import "HHsearchBarView.h"

@interface HHFansListVC ()<UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    HHsearchBarView *search_view;
}
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSString *userName;
@end

@implementation HHFansListVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"粉丝列表";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHFansListCell" bundle:nil] forCellReuseIdentifier:@"HHFansListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.page = 1;
    [self  getDatas];
    
    [self addHeadRefresh];
    [self addFootRefresh];
    
    search_view = [[[NSBundle mainBundle] loadNibNamed:@"HHsearchBarView" owner:nil options:nil] firstObject];
    search_view.frame = CGRectMake(0, 0, ScreenW, 90);
    self.tableView.tableHeaderView = search_view;
    self.tableView.backgroundColor = KVCBackGroundColor;

    search_view.search_tf.delegate = self;
    
    [search_view.search_btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
-(void)getDatas{
    
    [[[HHMineAPI GetAgentListWithPage:@(self.page) userName:self.userName] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {

                [self loadDataFinish:api.Data[@"List"]];

            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
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
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_fans"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"粉丝列表为空" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
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
    
    HHFansListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHFansListCell"];
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}
//搜索
- (void)searchAction:(UIButton *)btn{
    
    self.userName = search_view.search_tf.text;
    [self.datas removeAllObjects];
    [self getDatas];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length==0) {

        self.userName = textField.text;
        [self.datas removeAllObjects];
        [self getDatas];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
 
    self.userName = nil;
    [self.datas removeAllObjects];
    [self getDatas];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.userName = search_view.search_tf.text;
    [self.datas removeAllObjects];
    [self getDatas];
    
    return YES;
}
@end
