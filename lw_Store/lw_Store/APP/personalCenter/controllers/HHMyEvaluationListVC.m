//
//  HHEvaluationListVC.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyEvaluationListVC.h"
#import "HHEvaluationListCell.h"
#import "HHEvaluationListModel.h"
#import "HHEvaluateListHead.h"
#import "HHMyEvaluationGoodsCell.h"

@interface HHMyEvaluationListVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHEvaluateListHeadDelegate>

@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, assign)   NSInteger pageSize;

@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHMineModel *evaluateStatictis_m;
@property (nonatomic, strong)   NSNumber *hasImage;
@property (nonatomic, strong)   NSMutableArray *dataArray;
@property (nonatomic, strong)   UITableView *tabView;

@end

@implementation HHMyEvaluationListVC

- (void)loadView {
    
    self.view = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:KVCBackGroundColor];
    self.tabView = [UITableView lh_tableViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT-Status_HEIGHT) tableViewStyle:UITableViewStyleGrouped delegate:self dataSourec:self];
    self.tabView.backgroundColor = kClearColor;
    self.tabView.estimatedSectionHeaderHeight = 0;
    self.tabView.estimatedSectionFooterHeight = 0;
    self.tabView.estimatedRowHeight = 0;
    
    [self.view addSubview:self.tabView];
    self.tabView.tableFooterView = [UIView new];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的评价";
    
    [self.tabView registerClass:[HHEvaluationListCell class] forCellReuseIdentifier:[HHEvaluationListCell className]];
    [self.tabView registerClass:[HHMyEvaluationGoodsCell class] forCellReuseIdentifier:[HHMyEvaluationGoodsCell className]];

    self.tabView.backgroundColor = KVCBackGroundColor;
    
    self.page =1;
    self.pageSize = 10;
    [self addHeadRefresh];
    [self addFootRefresh];
    self.hasImage = nil;

    [self getDatas];
    //  [self setupDatas];
}
#pragma mark - 加载数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserEvaluateWithpage:@(self.page) pageSize:@(self.pageSize)] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                [self loadDataFinish:api.Data];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
        
    }];
    

}
- (void)setupDatas{
    
    NSArray *icon_urls = @[@"http://119.23.217.22:13336/image/show?fid=%2fImages%2fClient%2f12%2f0%2f020180817164458926.png*150&isCache=False"];
    NSArray *names = @[@"icon0.jpg"];
    NSArray *grades = @[@"1"];
    NSArray *times =  @[@"2018.10.1"];
    NSArray *contents =  @[@"那年，我们21  习近平的“五四”寄语  十句箴言"];
    NSArray *imagesModelArray = @[@"icon0.jpg"];
    NSArray *replyContent =  @[@"五四五四五四五四五四五四"];
    //    NSArray *addition_time =  @[@""];
    //    NSArray *addition_comment =  @[@""];
    
    [self.dataArray removeAllObjects];
    for (NSInteger i = 0; i<1; i++) {
        HHEvaluationListModel *model = [HHEvaluationListModel new];
        model.userImage = icon_urls[i];
        model.userName = names[i];
        model.createDate = times[i];
        model.skuName = @"15/1包";
        model.describeScore = grades[i];
        model.content = contents[i];
        model.pictures = imagesModelArray;
        model.adminReply = replyContent[i];
        //        model.addition_time = addition_time[i];
        //        model.addition_comment = addition_comment[i];
        [self.dataArray addObject:model];
    }
    
    [self.tabView reloadData];
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
    return [UIImage imageNamed:@"no_message_list"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"评论列表为空" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
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
    self.tabView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        
        [self getDatas];
    }];
    refreshfooter.stateLabel.textColor = KACLabelColor;
    self.tabView.mj_footer = refreshfooter;
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if (self.datas.count == 0) {
        self.tabView.mj_footer.hidden = YES;
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
        
        [self.tabView.mj_footer setState:MJRefreshStateNoMoreData];
    }else{
        
        [self.tabView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.tabView.mj_header.isRefreshing) {
        [self.tabView.mj_header endRefreshing];
    }
    
    if (self.tabView.mj_footer.isRefreshing) {
        
        [self.tabView.mj_footer endRefreshing];
        
    }
    //刷新界面
    [self.tabView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.datas.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HHEvaluationListCell *cell = [tableView dequeueReusableCellWithIdentifier:[HHEvaluationListCell className]];
        cell.indexPath = indexPath;
        
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        ///////////////////////////////////////////////////////////////////////
        
        cell.model =  [HHEvaluationListModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        
        return cell;
    }else{
        
        HHMyEvaluationGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[HHMyEvaluationGoodsCell className]];
        cell.model = [HHEvaluationListModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0){
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = [HHEvaluationListModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    return [self.tabView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHEvaluationListCell class] contentViewWidth:[self cellContentViewWith]];
    }else{
        return 75;
    }
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

#pragma mark - HHEvaluateListHeadDelegate

- (void)sortBtnSelectedWithSortBtnType:(NSInteger)sortBtnType{
    
    if (sortBtnType == 0) {
        self.hasImage = nil;
    }else{
        self.hasImage = @1;
    }
    [self.datas removeAllObjects];
    //获取数据
    [self getDatas];
}
@end
