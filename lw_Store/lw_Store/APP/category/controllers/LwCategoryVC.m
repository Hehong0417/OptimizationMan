//
//  CategoryVC.m
//  CredictCard
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#define tableViewH  100

/** 顶部Nav高度+指示器 */
#define DCTopNavH  44

#import "LwCategoryVC.h"
#import "HHSGSegmentedControl.h"
#import "DCClassCategoryCell.h"
#import "HHClassCategoryCell.h"
#import "DCClassGoodsItem.h"
#import "HHCategoryCollectionHead.h"
#import "HHGoodListVC.h"
#import "HHCategoryAPI.h"
#import "HHCategoryModel.h"
#import "SearchView.h"

@interface LwCategoryVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HHSGSegmentedControlDelegate,SearchViewDelegate>
{
    SearchView *searchView;
}
@property(nonatomic,strong)   HHSGSegmentedControl *SG;
@property (nonatomic, strong)   NSMutableArray *title_arr;

/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* collectionView */
@property (strong , nonatomic)UICollectionView  *collectionView;

/* 左边数据 */
@property (strong , nonatomic)NSMutableArray<DCClassGoodsItem *> *titleItem;
/* 右边数据 */
@property (strong , nonatomic)NSMutableArray<HHsubGoodsItem *> *mainItem;

@property (strong , nonatomic)NSNumber *type;

@end


static NSString *const DCClassCategoryCellID = @"DCClassCategoryCell";
static NSString *const DCGoodsSortCellID = @"HHClassCategoryCell";

@implementation LwCategoryVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self getDatasWithType:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    HJUser *user = [HJUser sharedUser];
    user.category_selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [user write];
    //title
    UILabel *qestionTitle = [[UILabel alloc]initWithFrame:CGRectMake(WidthScaleSize_W(15), 0, SCREEN_WIDTH - WidthScaleSize_W(15), WidthScaleSize_H(50))];
    qestionTitle.text = @"分类";
    qestionTitle.textAlignment = NSTextAlignmentCenter;
    qestionTitle.font = FONT(20);
    qestionTitle.textColor = kWhiteColor;
    self.navigationItem.titleView = qestionTitle;
    
    [self setUpTab];
    
    [self setUpData];
    
    //搜索条
    UIView *search_head = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:APP_COMMON_COLOR];
    [self.view addSubview:search_head];
    searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 30)];
    searchView.textField.text = @"";
    searchView.delegate = self;
    searchView.userInteractionEnabled = YES;
    [search_head addSubview:searchView];
}

#pragma mark- SearchViewDelegate

- (void)searchButtonWasPressedForSearchView:(SearchView *)searchView{
    
    HHGoodListVC *vc = [HHGoodListVC new];
    vc.enter_Type = HHenter_category_Type;
    [self.navigationController pushVC:vc];
}
#pragma mark - initizliz

- (void)setUpTab
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
}
- (NSMutableArray<DCClassGoodsItem *> *)titleItem{
    
    if (!_titleItem) {
        _titleItem = [NSMutableArray array];
    }
    return _titleItem;
}
#pragma mark - 加载数据
- (void)setUpData
{
    //获取数据
     [self getDatasWithType:nil];
//    _titleItem = [DCClassGoodsItem mj_objectArrayWithFilename:@"ClassifyTitles.plist"];
//    _mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods01.plist"];
    
}
- (void)getDatasWithType:(NSNumber *)type{
    
    [[[HHCategoryAPI GetCategoryListWithType:type] netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                [self.titleItem removeAllObjects];

                NSArray *arr = api.Data[@"CategoryList"];
                
                self.titleItem = [DCClassGoodsItem mj_objectArrayWithKeyValuesArray:arr];
             
                [self.tableView reloadData];
                
                HJUser *user = [HJUser sharedUser];

                //默认选择第一行（注意一定要在加载完数据之后）
                [self.tableView selectRowAtIndexPath:user.category_selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                if (self.titleItem.count>0) {
                    DCClassGoodsItem *item = self.titleItem[user.category_selectIndexPath.row];
                    self.mainItem =  [HHsubGoodsItem mj_objectArrayWithKeyValuesArray:item.NextProductCategoryList];
                    [self.collectionView reloadData];
                }
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
                
            }
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
}

#pragma mark - LazyLoad

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 50, tableViewH, SCREEN_HEIGHT - Status_HEIGHT-44-49-50);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCClassCategoryCell class] forCellReuseIdentifier:DCClassCategoryCellID];
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 3; //X
        layout.minimumLineSpacing = 5;  //Y
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.frame = CGRectMake(tableViewH + 5, 50, SCREEN_WIDTH - tableViewH - DCMargin, SCREEN_HEIGHT - Status_HEIGHT-44);
        //注册Cell
        [_collectionView registerNib:[UINib nibWithNibName:@"HHClassCategoryCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HHClassCategoryCell"];
        //        //注册Header
        [_collectionView registerClass:[HHCategoryCollectionHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHCategoryCollectionHead"];
    }
    return _collectionView;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCClassCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:DCClassCategoryCellID forIndexPath:indexPath];
    if (self.titleItem.count>0) {
        cell.titleItem = self.titleItem[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCClassGoodsItem *item = self.titleItem[indexPath.row] ;
    
    self.mainItem =  [HHsubGoodsItem mj_objectArrayWithKeyValuesArray:item.NextProductCategoryList];
    
    HJUser *user = [HJUser sharedUser];
    user.category_selectIndexPath = indexPath;
    [user write];
    
    [self.collectionView reloadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.mainItem.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        HHClassCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsSortCellID forIndexPath:indexPath];
        HHsubGoodsItem *subItem = self.mainItem[indexPath.row];
        cell.titleLab.text = subItem.Name;
        [cell.goodIcon sd_setImageWithURL:[NSURL URLWithString:subItem.IconUrl] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
        return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake((SCREEN_WIDTH - tableViewH - DCMargin*4)/3, 115);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(DCMargin, DCMargin, DCMargin, 0);
}
#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 45);
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        HHCategoryCollectionHead *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHCategoryCollectionHead" forIndexPath:indexPath];

        reusableview = headerView;
    }
    return reusableview;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    HHGoodListVC *vc = [HHGoodListVC new];
    vc.enter_Type = HHenter_itself_Type;
    vc.type = nil;
    HHsubGoodsItem *item = self.mainItem[indexPath.row];
    vc.categoryId = item.CategoryId;
    vc.name = nil;
    vc.orderby = nil;
    [self.navigationController pushVC:vc];
}

@end
