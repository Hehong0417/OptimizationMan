//
//  HHGoodListVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPaySucessVC.h"
#import "HXHomeCollectionCell.h"
#import "HHGoodBaseViewController.h"
#import "HHCategoryAPI.h"
#import "HHEvaluationHeadView.h"

@interface HHPaySucessVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)   UICollectionView *collectionView;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property(nonatomic,assign)    NSInteger page;
@property(nonatomic,assign)   NSInteger pageSize;
@property(nonatomic,strong)   NSMutableArray *datas;
@property(nonatomic,assign)   BOOL  orderPrice;

@end

@implementation HHPaySucessVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"支付成功";
    
    self.datas = [NSMutableArray array];
    
    //商品列表
    self.page = 1;
    self.pageSize = 15;
    
    //头部
    //collectionView
    self.collectionView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];
    
    [self.collectionView registerClass:[HHEvaluationHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHEvaluationHeadView"];
    
    //获取数据
    [self getGuess_you_likeData];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    if (self.enter_type == HHenter_type_cart||self.enter_type == HHenter_type_order) {
        
        [self.navigationController popToRootVC];
        
    }else  if (self.enter_type == HHenter_type_productDetail) {
        
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 2) {
                [self.navigationController popToVC:vc];
            }
        }];
    }else if(self.enter_type == HHenter_type_activity){
        if (self.backBlock) {
            self.backBlock();
        }
        [self.navigationController popVC];
        
    }else{
        [self.navigationController popToRootVC];
    }
    
}
#pragma mark - DZNEmptyDataSetDelegate

//猜你喜欢
- (void)getGuess_you_likeData{
    
    [[[HHCategoryAPI GetAlliancesProductsWithpids:self.pids]  netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *arr =  api.Data;
                self.datas = arr.mutableCopy;
                [self.collectionView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
        }
    }];
    
}

#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HXHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXHomeCollectionCell" forIndexPath:indexPath];
        cell.guess_you_likeModel =  [HHGuess_you_likeModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        return self.datas.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 30)/2 , 220);

}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return  CGSizeMake(ScreenW, WidthScaleSize_H(350));
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return  CGSizeZero;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        HHEvaluationHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHEvaluationHeadView" forIndexPath:indexPath];
        headerView.backgroundColor = KVCBackGroundColor;
        headerView.isPay = 1;
        headerView.nav = self.navigationController;
        if (self.datas.count == 0) {
            headerView.title_lab.hidden = YES;
        }else{
            headerView.title_lab.hidden = NO;
        }
        headerView.backgroundColor = KVCBackGroundColor;
        reusableview = headerView;
    }
    return reusableview;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HHGuess_you_likeModel *goodsModel = [HHGuess_you_likeModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
    vc.Id = goodsModel.pid;
    [self.navigationController pushVC:vc];
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-Status_HEIGHT-44) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

@end


