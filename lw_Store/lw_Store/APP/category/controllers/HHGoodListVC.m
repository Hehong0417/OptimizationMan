//
//  HHGoodListVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodListVC.h"
#import "HXHomeCollectionCell.h"
#import "SGSegmentedControl.h"
#import "SearchView.h"
#import "SearchDetailViewController.h"
#import "HHGoodBaseViewController.h"
#import "LwCategoryVC.h"
#import "HHPaySucessVC.h"

@interface HHGoodListVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SGSegmentedControlDelegate,SearchViewDelegate,SearchDetailViewControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    SearchView *searchView;
    
}
@property (nonatomic, strong)   UICollectionView *collectionView;
@property(nonatomic,strong)     SGSegmentedControl *SG;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property(nonatomic,assign)    NSInteger page;
@property(nonatomic,assign)   NSInteger pageSize;
@property(nonatomic,strong)   NSMutableArray *datas;
@property(nonatomic,assign)   NSInteger  orderState;
@property(nonatomic,assign)   BOOL  isFooterRefresh;
@property(nonatomic,strong)   NSURLSessionDataTask *task;
@property(nonatomic,assign)   BOOL  isCategory;

@end

@implementation HHGoodListVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //商品列表
    self.page = 1;
    self.pageSize = 10;
    
    self.isCategory = YES;
    
    //collectionView
    self.collectionView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];
    
    //搜索
    [self setupSGSegmentedControl];

    [self setupSearchView];

    [self addFootRefresh];
    //获取数据
    [self addHeadRefresh];
    
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
#pragma mark - SGSegmentedControl init

- (void)setupSGSegmentedControl{
    
    self.title_arr = [NSMutableArray arrayWithArray:@[@"价格",@"上架",@"浏览量",@"销量"]];
    
    if (self.title_arr.count < 5) {
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    }else{
        
        self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:self.title_arr];
    }
    self.SG.titleColorStateNormal = APP_COMMON_COLOR;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = FONT(14);
    //  self.SG.showsBottomScrollIndicator = YES;
    self.SG.backgroundColor = kWhiteColor;
    self.SG.indicatorColor = APP_COMMON_COLOR;
    [self.view addSubview:_SG];
    
    
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    
}
#pragma 加载数据

- (void)getDatas{
    
    self.task =  [[[HHCategoryAPI GetProductListWithType:self.type categoryId:self.isCategory?self.categoryId:nil name:self.name orderby:self.orderby page:@(self.page) pageSize:@(self.pageSize)] netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        
        if (!error) {
            
            if (api.State == 1) {

                if (self.isFooterRefresh) {
                    [self loadDataFinish:api.Data];
                }else{
                   [self.datas removeAllObjects];
                    [self loadDataFinish:api.Data];
                }
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
            
        }else{
            if ([error.localizedDescription isEqualToString:@"已取消"]) {
                
            }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                
            }
        }
    }];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"img_list_disable"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [[NSAttributedString alloc] initWithString:@"还没有相关的宝贝，先看看其他的吧～" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
#pragma mark - 刷新控件

- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isFooterRefresh = NO;
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.collectionView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        [self getDatas];
    }];
    refreshfooter.stateLabel.textColor = KACLabelColor;
    self.collectionView.mj_footer = refreshfooter;

}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];

    if (arr.count < self.pageSize) {
        
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
    self.collectionView.mj_footer.hidden = NO;

    if (noMoreData) {
        if (self.datas.count == 0) {
            self.collectionView.mj_footer.hidden = YES;
        }else {
            [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        
        [self.collectionView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.collectionView.mj_header.isRefreshing) {
        [self.collectionView.mj_header endRefreshing];
    }
   
    if (self.collectionView.mj_footer.isRefreshing) {
        [self.collectionView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.collectionView reloadData];
    
}

#pragma mark - SearchView

- (void)setupSearchView {
    searchView = [[SearchView alloc] initWithFrame:CGRectMake(15, 3, self.view.frame.size.width-30, 30)];
    searchView.textField.text = @"";
    searchView.delegate = self;
    searchView.userInteractionEnabled = YES;
   
    if (self.enter_Type == HHenter_category_Type ||self.enter_Type == HHenter_home_Type ) {
        
        [self searchButtonWasPressedForSearchView:searchView];
        
    }else{
      
    }
    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(-15, 3, 30, 30) target:self action:@selector(backAction) backgroundColor:kClearColor];
    backBtn.highlighted = NO;
    [searchView addSubview:backBtn];
    [self.navigationController.navigationBar addSubview:searchView];
}
- (void)backAction{

    [self.navigationController popVC];
}
#pragma mark - SearchViewDelegate

- (void)searchButtonWasPressedForSearchView:(SearchView *)searchView {
    
    SearchDetailViewController *searchViewController = [[SearchDetailViewController alloc] init];
    searchViewController.textFieldText = self.name;
    searchViewController.placeHolderText = searchView.textField.text;
    searchViewController.delegate = self;
    searchViewController.enter_Type = self.enter_Type;

    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navigationController
                       animated:NO
                     completion:nil];
    
}
#pragma mark - SearchDetailViewControllerDelegate

- (void)tagViewButtonDidSelectedForTagTitle:(NSString *)title{
    //热门搜索/历史搜索标题
    self.page = 1;
    self.name = title;
    if (title.length>0) {
        self.isCategory = NO;
    }else{
        self.isCategory = YES;
    }
    [self.datas removeAllObjects];
    [self getDatas];
    
}
- (void)dismissButtonWasPressedForSearchDetailView:(id)searchView{
    
    [self.navigationController popToRootVC];
    
}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index{
    
    [self.task cancel];
    
    if (index == 0){
        //价格
        if (self.orderState==1) {
            self.orderState = 2;
        }else{
            self.orderState = 1;
        }
        self.orderby = @(self.orderState);
        
        [self getDatas];

    }else if (index == 1){
        //上架
        if (self.orderState==3) {
            self.orderState = 4;
        }else{
            self.orderState = 3;
        }
        self.orderby = @(self.orderState);
        [self getDatas];
        
    }else if (index == 2){
        //浏览量
        if (self.orderState==5) {
            self.orderState = 6;
        }else{
            self.orderState = 5;
        }
        self.orderby = @(self.orderState);
        [self getDatas];
    }else if (index == 3){
        //销量量
        if (self.orderState==7) {
            self.orderState = 8;
        }else{
            self.orderState = 7;
        }
        self.orderby = @(self.orderState);
        [self getDatas];
    }
    
}

#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HXHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXHomeCollectionCell" forIndexPath:indexPath];
    cell.goodsModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    cell.collectButton.hidden = YES;
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 30)/2 , 230);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return  CGSizeMake(0.001, 0.001);

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return  CGSizeMake(0.001, 0.001);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCategoryModel *goodsModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
    vc.Id = goodsModel.Id;
    [self.navigationController pushVC:vc];

}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - Status_HEIGHT-40-44) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    searchView.hidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    searchView.hidden = YES;
}
@end
