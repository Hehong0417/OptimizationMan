//
//  HHMessageVC.m
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMessageVC.h"
#import "HHMessageCell.h"
#import "HHMessageDetailVC.h"

@interface HHMessageVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong) UIButton *currentSelectBtn;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   NSNumber *isRead;

@end

@implementation HHMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息列表";
    [self.tableView registerClass:[HHMessageCell class]  forCellReuseIdentifier:@"HHMessageCell"];
    
    [self setupHeadView];
    self.page =1;
    
    [self addHeadRefresh];
    [self addFootRefresh];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.backgroundColor = KVCBackGroundColor;

    self.isRead = nil;
    
    [self getDatas];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KPersonCter_Refresh_Notification object:nil];

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - 加载数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserNoticeWithPage:@(self.page) isRead:self.isRead] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
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
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_message_list"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"消息列表为空" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 20;
    
}
#pragma mark - 刷新控件
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
- (void)setupHeadView{
    
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(40)) backColor:KVCBackGroundColor];
    NSArray *titles = @[@"  只显示未读消息",@"  全部已读"];
    for (NSInteger i =0; i<2; i++) {
        
        UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(i*ScreenW/2, 0, ScreenW/2, WidthScaleSize_H(40)) target:self action:@selector(selectBtnAction:) image:[UIImage imageNamed:@"icon_checkbox_default"] title:titles[i] titleColor:kGrayColor  font:FONT(13)];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
        [headView addSubview:btn];
    }
    
    self.tableView.tableHeaderView = headView;
}
- (void)selectBtnAction:(UIButton *)btn{
    self.currentSelectBtn.selected = NO;
    btn.selected = YES;
    self.currentSelectBtn = btn;
    
    [self.datas removeAllObjects];
    
    self.page = 1;
    
    if (self.currentSelectBtn.tag == 0) {
        //未读消息
        self.isRead = @1;
        [self getDatas];

    }else{
        //设置全部已读
        [[[HHMineAPI postSetReadNotice] netWorkClient] postRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    self.isRead = nil;
                    [self getDatas];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
    }

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMessageCell" forIndexPath:indexPath];
    cell.model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHMessageDetailVC *vc = [HHMessageDetailVC new];
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    vc.Id = model.Id;
    [self.navigationController pushVC:vc];
    
}

@end
