//
//  HHGoodListVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyCollectionVC.h"
#import "HXHomeCollectionCell.h"
#import "HHGoodBaseViewController.h"
#import "HHGoodListVC.h"

@interface HHMyCollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HXHomeCollectionCellDelegate>

@property (nonatomic, strong)   UICollectionView *collectionView;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property(nonatomic,assign)    NSInteger page;
@property(nonatomic,assign)   NSInteger pageSize;
@property(nonatomic,strong)   NSMutableArray *datas;
@property(nonatomic,assign)   NSInteger  orderState;
@property(nonatomic,assign)   BOOL  isFooterRefresh;
@property(nonatomic,strong)   NSURLSessionDataTask *task;
@property(nonatomic,assign)   BOOL  isCategory;
@property (nonatomic,assign)   NSInteger isLoaded;
@end

@implementation HHMyCollectionVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    //商品列表
    self.page = 1;
    self.pageSize = 20;
    
    self.isCategory = YES;
    
    //collectionView
    self.collectionView.backgroundColor = KVCBackGroundColor;
    
    self.collectionView.hidden = YES;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];
    
    [self getDatas];
    
    //获取数据
    [self addHeadRefresh];
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

#pragma 加载数据

- (void)getDatas{
    
    [[[HHHomeAPI GetProductCollectionWithpage:@(self.page) pageSize:@(self.pageSize)] netWorkClient] getRequestInView:self.isFooterRefresh?nil:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
        self.isLoaded = YES;
        self.collectionView.hidden = NO;

        if (!error) {
            
            if (api.State == 1) {
                [self addFootRefresh];
                
                if (self.isFooterRefresh) {
                    [self loadDataFinish:api.Data];
                }else{
                    [self.datas removeAllObjects];
                    [self loadDataFinish:api.Data];
                }
                
            }else{
                
                if ([api.Msg isEqualToString:@"cancelled"]) {
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
                
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
    return [UIImage imageNamed:self.isLoaded?@"no_collect":@""];
}
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
//
//    NSAttributedString *attrStr = self.isLoaded?[NSString lh_attriStrWithprotocolStr:@"去逛逛 >" content:@"收藏夹还没商品哦～ 去逛逛 >" protocolStrColor:APP_COMMON_COLOR contentColor:KACLabelColor commonFont:FONT(14)]:[[NSAttributedString alloc] initWithString:@""];
//    return  attrStr;
//}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    
    NSAttributedString *attrStr = self.isLoaded?[NSString lh_attriStrWithprotocolStr:@"去逛逛 >" content:@"收藏夹还没商品哦～ 去逛逛 >" protocolStrColor:APP_COMMON_COLOR contentColor:KACLabelColor commonFont:FONT(14)]:[[NSAttributedString alloc] initWithString:@""];
    return  attrStr;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    
    HHGoodListVC  *vc = [HHGoodListVC new];
    vc.enter_Type = HHenter_itself_Type;
    [self.navigationController pushVC:vc];
    
}
//- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
//    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);
//
//    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];
//
//    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
//}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 20;
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

#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HXHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXHomeCollectionCell" forIndexPath:indexPath];
    cell.collectModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    cell.delegate = self;
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 2)/2 , 230);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 1, 1, 0);
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
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
- (void)collectHandleComplete{
    
    self.isFooterRefresh = NO;
    self.page = 1;
    [self getDatas];

}
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-Status_HEIGHT-NAVBAR_HEIGHT) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}

@end
