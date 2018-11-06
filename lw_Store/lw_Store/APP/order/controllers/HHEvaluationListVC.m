//
//  HHEvaluationListVC.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHEvaluationListVC.h"
#import "HHEvaluationListCell.h"
#import "HHEvaluationListModel.h"
#import "HHEvaluateListHead.h"

@interface HHEvaluationListVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHEvaluateListHeadDelegate>
{
    HHEvaluateListHead *table_head;
}
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, assign)   NSInteger pageSize;

@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHMineModel *evaluateStatictis_m;
@property (nonatomic, strong)   NSNumber *hasImage;

@end

@implementation HHEvaluationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"评价";
    
    [self.tableView registerClass:[HHEvaluationListCell class] forCellReuseIdentifier:[HHEvaluationListCell className]];
    self.tableView.backgroundColor = KVCBackGroundColor;

    self.page =1;
    self.pageSize = 10;
    [self addHeadRefresh];
    [self addFootRefresh];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.hasImage = nil;
    [self setUpTableHead];

    [self getDatas];
//  [self setupDatas];
    
}
#pragma mark - 加载数据
- (void)getDatas{
    
    [[[HHHomeAPI GetProductEvaluateWithId:self.pid page:@(self.page) pageSize:@(self.pageSize) hasImage:self.hasImage] netWorkClient] getRequestInView:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
       
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
    
    
    [[[HHMineAPI GetProductEvaluateStatictisWithpid:self.pid] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.evaluateStatictis_m = [HHMineModel mj_objectWithKeyValues:api.Data];
                
                table_head.evaluateStatictis_m = self.evaluateStatictis_m;

            }else{
            }
        }else{
        }
    }];

}
#pragma mark - tableHead

- (void)setUpTableHead{
    
    table_head = [[HHEvaluateListHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 90)];
    table_head.delegate = self;
    table_head.backgroundColor = kWhiteColor;
    self.tableView.tableHeaderView = table_head;
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
    
    [self.tableView reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHEvaluationListCell *cell = [tableView dequeueReusableCellWithIdentifier:[HHEvaluationListCell className]];
    cell.indexPath = indexPath;
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    cell.model =  [HHEvaluationListModel mj_objectWithKeyValues:self.datas[indexPath.row]];
//    cell.model =  self.dataArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = [HHEvaluationListModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHEvaluationListCell class] contentViewWidth:[self cellContentViewWith]];
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
