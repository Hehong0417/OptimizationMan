//
//  HHGoodBaseViewController.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodBaseViewController.h"
#import <WebKit/WebKit.h>
#import "HHDetailGoodReferralCell.h"
#import "HHGoodSpecificationsCell.h"
#import "HHGoodDealRecordCell.h"
#import "HHGoodDealRecordInfoCell.h"
#import "HHGoodDealRecordInfoDetailCell.h"
#import "HHAddCartTool.h"
#import "DCFeatureSelectionViewController.h"
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
#import "HHShoppingVC.h"
#import "HHSubmitOrdersVC.h"
#import "HHTransactionRecordVC.h"
#import "HHNotWlanView.h"
#import "HHShopIntroCell.h"
#import "HHEvaluationListCell.h"
#import "HHEvaluationListVC.h"
#import "HHAddAdressVC.h"
#import "HHActivityModel.h"
#import "MLMenuView.h"

@interface HHGoodBaseViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,SDCycleScrollViewDelegate,HHCartVCProtocol>

@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong)   SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)   HHAddCartTool *addCartTool;
@property (nonatomic, strong)   NSMutableArray *discribeArr;
@property (nonatomic, strong)   UILabel *tableFooter;
@property (nonatomic, strong)  NSMutableArray *datas;
@property (nonatomic, strong)  NSMutableArray *evaluations;
@property (nonatomic, strong)  HHgooodDetailModel *gooodDetailModel;
@property (nonatomic, assign)   BOOL status;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *headTitle;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSMutableArray *alert_Arr;
@property (nonatomic, strong) NSNumber *Mode;


/* 通知 */
@property (weak ,nonatomic) id dcObj;

/* 删除加入购物车何立即购买的通知 */
@property (weak ,nonatomic) id deleteDcObj;

@end

//cell
static NSString *lastNum_;
static NSArray *lastSeleArray_;
static NSArray *lastSele_IdArray_;

static NSString *HHDetailGoodReferralCellID = @"HHDetailGoodReferralCell";//商品信息
static NSString *HHShopIntroCellID = @"HHShopIntroCell";//店铺简介
static NSString *HHGoodSpecificationsCellID = @"HHGoodSpecificationsCell";//商品规格
static NSString *HHGoodDealRecordCellID = @"HHGoodDealRecordCell";//月成交记录跳转
static NSString *HHGoodDealRecordInfoCellID = @"HHGoodDealRecordInfoCell";//月成交记录信息
static NSString *HHGoodDealRecordInfoDetailCellID = @"HHGoodDealRecordInfoDetailCell";//月成交记录信息详情
static NSString *HHEvaluationListCellID = @"HHEvaluationListCell";//月成交记录信息详情



@implementation HHGoodBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.addCartTool.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获取数据
    [self getDatas];
    
    //网络监测
    [self setMonitor];
    
    [self setUpViewScroll];
    
    [self setUpInit];
    
    //加入购物车、立即购买
    [self addCartOrBuyAction];
    
    //接收到通知
    [self acceptanceNote];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//网络监测
- (void)setMonitor{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if(status == 1 || status == 2)
        {
            self.status = NO;
            NSLog(@"有网");
        }else
        {
            NSLog(@"没有网");
            self.status = YES;
            [self.tableView reloadData];
            
        }
    }];
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)alert_Arr{
    if (!_alert_Arr) {
        _alert_Arr = [NSMutableArray array];
    }
    return _alert_Arr;
}

- (NSMutableArray *)evaluations{
    if (!_evaluations) {
        _evaluations = [NSMutableArray array];
    }
    return _evaluations;
}
#pragma mark - initialize

- (void)setUpInit
{
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    //初始化
    lastSeleArray_ = [NSArray array];
    lastSele_IdArray_ = [NSArray array];
    lastNum_ = 0;
    
}
- (NSMutableArray *)discribeArr{
    if (!_discribeArr) {
        _discribeArr = [NSMutableArray array];
    }
    return _discribeArr;
}
#pragma mark - 记载图文详情
- (void)setUpGoodsWKWebView
{
    NSString *content =   [NSString stringWithFormat:@"<style>img{width:100%%;}</style>%@",self.gooodDetailModel.Description];
    [self.webView loadHTMLString:content baseURL:nil];
    
}

#pragma mark - 接受通知
- (void)acceptanceNote
{
    //删除通知
    _deleteDcObj = [[NSNotificationCenter defaultCenter] addObserverForName:DELETE_SHOPITEMSELECTBACK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];
        
    }];
    WEAK_SELF();
    //选择Item通知
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:SHOPITEMSELECTBACK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSArray *selectArray = note.userInfo[@"Array"];
        NSArray *select_IdArray = note.userInfo[@"id_Array"];
        NSString *num = note.userInfo[@"Num"];
        NSString *buttonTag = note.userInfo[@"Tag"];
        NSString *button_title = note.userInfo[@"button_title"];

        lastNum_ = num;
        lastSeleArray_ = selectArray;
        lastSele_IdArray_ = select_IdArray;
        
        //更新价格和s积分
        NSString *seleId_str = [NSString stringWithFormat:@"%@_%@",self.gooodDetailModel.Id,[select_IdArray componentsJoinedByString:@"_"]];

        [self.gooodDetailModel.SKUList enumerateObjectsUsingBlock:^(HHproduct_skuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.Id isEqualToString:seleId_str]) {
                self.gooodDetailModel.MinShowPrice = obj.SalePrice;
                [self.tableView reloadData];
            }
        }];

        
        if ([buttonTag isEqualToString:@"0"]) { //加入购物车

            if ([button_title isEqualToString:@"加入购物车"]) {

           [weakSelf setUpWithAddSuccessWithselect_IdArray:select_IdArray quantity:num];
                NSLog(@" 加入购物车");

            }else{
                NSLog(@"参加拼团");

                [weakSelf instanceBuyActionWithselect_IdArray:select_IdArray quantity:num];


            }

        }

    }];
    
}

//获取数据
- (void)getDatas{

    UIView *hudView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kWhiteColor];
    [self.tableView addSubview:hudView];
    
    HHNotWlanView *notAlanView = [[HHNotWlanView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [hudView addSubview:notAlanView];
    notAlanView.hidden = YES;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    self.activityIndicator.frame= CGRectMake(0, 0, 30, 30);
     self.activityIndicator.center = self.tableView.center;
    self.activityIndicator.color = KACLabelColor;
    self.activityIndicator.hidesWhenStopped = YES;
    [hudView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];

    //商品详情
    [[[HHHomeAPI GetProductDetailWithId:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
            
                self.gooodDetailModel = [HHgooodDetailModel mj_objectWithKeyValues:api.Data];
                
                self.cycleScrollView.imageURLStringsGroup = self.gooodDetailModel.ImageUrls;
                self.discribeArr =  self.gooodDetailModel.AttributeValueList.mutableCopy;
                
                //HK香港区域商品
                if (self.gooodDetailModel.tip.length>0) {
                    
                    [self alertMessageWithTip];
                }
                
                [self.tableView reloadData];
                
                self.headTitle = @"商品信息";
                [self.activityIndicator stopAnimating];
                [hudView removeFromSuperview];
                [self tableView:self.tableView viewForHeaderInSection:1];
                
                [self setUpGoodsWKWebView];
                
                
//                self.addCartTool
                //拼团
               HHActivityModel *GroupBy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.GroupBuy];
                //降价团
                HHActivityModel *CutGroupBuy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.CutGroupBuy];
                //送礼
                HHActivityModel *SendGift_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SendGift];

                if ([GroupBy_m.IsJoin isEqual:@1]) {
                    
                    [self.alert_Arr addObject:GroupBy_m];
                }
                if ([CutGroupBuy_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:CutGroupBuy_m];
                }
                if ([SendGift_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:SendGift_m];
                }
                
                if (self.alert_Arr.count >0) {
                    self.addCartTool.buyBtn.hidden = NO;
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3;
                }else{
                    self.addCartTool.buyBtn.hidden = YES;
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3*2;
                }
                
//                //评价
//                [self  getFinishLogData];
                
       
            }else{
                [self.activityIndicator stopAnimating];
                
                [SVProgressHUD showInfoWithStatus:api.Msg];

            }

        }else{
            [self.activityIndicator stopAnimating];
            if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]||[error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
                notAlanView.hidden = NO;
            }else{
                notAlanView.hidden = YES;
                [hudView removeFromSuperview];
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];

            }
            
        }
    }];

    
}
#pragma mark-猜你喜欢

- (void)getFinishLogData{
    
    [[[HHCategoryAPI GetAlliancesProductsWithpids:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
            
            if (!error) {
                if (api.State == 1) {
                    NSArray  *arr = api.Data;
                    self.datas = arr.mutableCopy;
                    [self.tableView reloadData];

                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
            
        }];
    
}
#pragma mark-用户评价

//编码图片
- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64Encoding]];
    return [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
}
//加入购物车、立即购买
- (void)addCartOrBuyAction{
    
    [self.view addSubview:self.addCartTool];
    
    WEAK_SELF();
    //加入购物车
    HJUser *user = [HJUser sharedUser];

    self.addCartTool.addCartBlock = ^{
        
//        if (user.token.length <=0) {
//            //去登录
//            [weakSelf alertView];
//
//        }else{
            DCFeatureSelectionViewController *dcNewFeaVc = [DCFeatureSelectionViewController new];
            dcNewFeaVc.product_sku_value_arr = weakSelf.gooodDetailModel.SKUValues;
            dcNewFeaVc.lastNum = lastNum_;
            dcNewFeaVc.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
            dcNewFeaVc.lastSele_IdArray = [NSMutableArray arrayWithArray:lastSele_IdArray_];
            dcNewFeaVc.product_sku_arr = weakSelf.gooodDetailModel.SKUList;
            dcNewFeaVc.button_Title = @"加入购物车";
            dcNewFeaVc.product_price = weakSelf.gooodDetailModel.MinShowPrice;
            dcNewFeaVc.product_id = weakSelf.gooodDetailModel.Id;
            dcNewFeaVc.product_stock = weakSelf.gooodDetailModel.Stock;
            if (self.gooodDetailModel.ImageUrls.count>0) {
                dcNewFeaVc.goodImageView = weakSelf.gooodDetailModel.ImageUrls[0];
            }
            CGFloat  distance;
            if (weakSelf.gooodDetailModel.SKUValues.count == 0) {
                distance = ScreenH/2.3;
            }else if (weakSelf.gooodDetailModel.SKUValues.count == 1){
                distance = ScreenH/1.75;
            }else{
                distance = ScreenH*2/3;
            }
            dcNewFeaVc.nowScreenH = distance;
            [weakSelf setUpAlterViewControllerWith:dcNewFeaVc WithDistance:distance WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
//        }
       
    };
    //立即购买
    self.addCartTool.buyBlock = ^{
        
        MLMenuView *menuView = [[MLMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, SCREEN_HEIGHT-Status_HEIGHT-49-weakSelf.alert_Arr.count*50, SCREEN_WIDTH/3, weakSelf.alert_Arr.count*50) WithmodelsArr:weakSelf.alert_Arr WithMenuViewOffsetTop:Status_HEIGHT WithTriangleOffsetLeft:80];
        
        menuView.isHasTriangle = NO;
        
        menuView.didSelectBlock = ^(NSInteger index, HHActivityModel *model) {

            //属性选择
            DCFeatureSelectionViewController *dcNewFeaVc = [DCFeatureSelectionViewController new];
            dcNewFeaVc.product_sku_value_arr = weakSelf.gooodDetailModel.SKUValues;
            dcNewFeaVc.lastNum = lastNum_;
            dcNewFeaVc.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
            dcNewFeaVc.lastSele_IdArray = [NSMutableArray arrayWithArray:lastSele_IdArray_];
            dcNewFeaVc.product_sku_arr = weakSelf.gooodDetailModel.SKUList;
            dcNewFeaVc.product_id = weakSelf.gooodDetailModel.Id;
            
            weakSelf.Mode = model.Mode;
            if ([model.Mode isEqual:@2]) {
                dcNewFeaVc.button_Title = @"参加拼团";
            }else if ([model.Mode isEqual:@8]){
                dcNewFeaVc.button_Title = @"送礼";
            }else if ([model.Mode isEqual:@32]){
                dcNewFeaVc.button_Title = @"参加降价团";
            }else{
                dcNewFeaVc.button_Title = @"立即购买";
            }
            dcNewFeaVc.product_price = weakSelf.gooodDetailModel.MinShowPrice;
            dcNewFeaVc.product_stock = weakSelf.gooodDetailModel.Stock;
            
            CGFloat  distance;
            if (weakSelf.gooodDetailModel.SKUValues.count == 0) {
                distance = ScreenH/2.3;
            }else if (weakSelf.gooodDetailModel.SKUValues.count == 1){
                distance = ScreenH/1.75;
            }else{
                distance = ScreenH*2/3;
            }
            dcNewFeaVc.nowScreenH = distance;
            
            if (self.gooodDetailModel.ImageUrls.count>0) {
                dcNewFeaVc.goodImageView = weakSelf.gooodDetailModel.ImageUrls[0];
            }
            
            [weakSelf setUpAlterViewControllerWith:dcNewFeaVc WithDistance:distance WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];

        };
        
        [menuView showMenuEnterAnimation:MLEnterAnimationStyleNone];
        
    };
    
    
    //跳转首页
    self.addCartTool.homeIconImgV.userInteractionEnabled = YES;
    [self.addCartTool.homeIconImgV setTapActionWithBlock:^{
        
        [[NSNotificationCenter defaultCenter]removeObserver:weakSelf.dcObj];

        kKeyWindow.rootViewController = [HJTabBarController new];
    }];
    
    //跳转购物车
    self.addCartTool.cartIconImgV.userInteractionEnabled = YES;
    
    [self.addCartTool.cartIconImgV setTapActionWithBlock:^{
        if (user.token.length <=0) {
            //去登录
            [weakSelf alertView];
            
        }else{
        
      [[NSNotificationCenter defaultCenter]removeObserver:weakSelf.dcObj];

        weakSelf.addCartTool.hidden = YES;
        HHShoppingVC *vc = [HHShoppingVC new];
        vc.cartType = HHcartType_goodDetail;
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushVC:vc];
            
        }
    }];
}
-(void)alertView{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"您还没有登录哦～" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
//        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
//        [self  presentViewController:nav animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)alertMessageWithTip{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"注意" message:self.gooodDetailModel.tip preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark - HHCartVCProtocol

- (void)cartVCBackActionHandle{
    
    //接收到通知
    [self acceptanceNote];
    
}
#pragma mark - 加入购物车成功
- (void)setUpWithAddSuccessWithselect_IdArray:(NSArray *)select_IdArray quantity:(NSString *)quantity
{
    NSString *select_Id = [select_IdArray componentsJoinedByString:@"_"];
    NSString *sku_id;
    if (select_Id.length>0) {
        sku_id = select_Id;
    }else{
        sku_id = @"0";
    }
    NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",self.gooodDetailModel.Id,sku_id];
    
    //加入购物车
    [[[HHCartAPI postAddProductsWithsku_id:sku_id_Str quantity:quantity] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                [SVProgressHUD showSuccessWithStatus:@"加入购物车成功～"];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];

}
#pragma mark - 立即购买
- (void)instanceBuyActionWithselect_IdArray:(NSArray *)select_IdArray quantity:(NSString *)quantity{
    
    NSString *select_Id = [select_IdArray componentsJoinedByString:@"_"];
    NSString *sku_id;
    if (select_Id.length>0) {
        sku_id = select_Id;
    }else{
        sku_id = @"0";
    }
    NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",self.gooodDetailModel.Id,sku_id];
    NSLog(@"select_Id:%@",sku_id_Str);

    if (sku_id_Str.length>0) {
        //立即购买
//      是否存在收货地址
        [self isExitAddressWithsku_id_Str:sku_id_Str quantity:quantity];
    }
}
//是否存在收货地址
- (void)isExitAddressWithsku_id_Str:(NSString *)sku_id_Str quantity:(NSString *)quantity{
    
    [[[HHCartAPI IsExistOrderAddress] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                if ([api.Data isEqual:@1]) {
                    HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                    vc.enter_type = HHaddress_type_Spell_group;
                    vc.ids_Str = sku_id_Str;
                    vc.count = quantity;
                    vc.mode = self.Mode;
                    [self.navigationController pushVC:vc];
                }else{
                    HHAddAdressVC *vc = [HHAddAdressVC new];
                    vc.titleStr = @"新增收货地址";
                    vc.addressType = HHAddress_settlementType_productDetail;
                    vc.mode = self.Mode;
                    vc.ids_Str = sku_id_Str;
                    [self.navigationController pushVC:vc];
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
- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollerView.frame = self.view.bounds;
        _scrollerView.contentSize = CGSizeMake(ScreenW, (ScreenH - 50) * 2);
        _scrollerView.pagingEnabled = YES;
        _scrollerView.scrollEnabled = NO;
        [self.view addSubview:_scrollerView];
    }
    return _scrollerView;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenH - 64-35) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = KVCBackGroundColor;
        //轮播图
        _tableView.tableHeaderView = self.cycleScrollView;
        _tableView.tableFooterView = self.tableFooter;
        
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:HHDetailGoodReferralCellID bundle:nil] forCellReuseIdentifier:HHDetailGoodReferralCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHShopIntroCellID bundle:nil] forCellReuseIdentifier:HHShopIntroCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHGoodSpecificationsCellID bundle:nil] forCellReuseIdentifier:HHGoodSpecificationsCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHGoodDealRecordCellID bundle:nil] forCellReuseIdentifier:HHGoodDealRecordCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHGoodDealRecordInfoCellID bundle:nil] forCellReuseIdentifier:HHGoodDealRecordInfoCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHGoodDealRecordInfoDetailCellID bundle:nil] forCellReuseIdentifier:HHGoodDealRecordInfoDetailCellID];
        [_tableView registerClass:[HHEvaluationListCell class] forCellReuseIdentifier:HHEvaluationListCellID];

        [self.scrollerView addSubview:_tableView];
    }
    return _tableView;
    
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.frame = CGRectMake(-5,ScreenH-50 , ScreenW+10, ScreenH - 50);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(DCTopNavH, 0, 0, 0);
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollerView addSubview:_webView];
    }
    return _webView;
}
- (HHAddCartTool *)addCartTool{
    if (!_addCartTool) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat y = statusRect.size.height+44;
        _addCartTool = [[HHAddCartTool alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50-y, SCREEN_WIDTH, 50)];
        _addCartTool.nav = self.navigationController;
        UIView *line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 1) backColor:RGB(220, 220, 220)];
        [_addCartTool addSubview:line];
    }
    return _addCartTool;
    
}
//头部
- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) imageNamesGroup:@[@""]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        [_cycleScrollView setPlaceholderImage:[UIImage imageWithColor:kWhiteColor]];
        
        _cycleScrollView.delegate = self;
    }
    
    return _cycleScrollView;
}
- (UILabel *)tableFooter{
    
    if (!_tableFooter) {
        _tableFooter = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW, 30) text:@"——————   继续向上拖动，查看图文详情   ——————" textColor:KACLabelColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    }
    return _tableFooter;
}
#pragma mark - 视图滚动
- (void)setUpViewScroll{
    WEAK_SELF();
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(YES);
            weakSelf.scrollerView.contentOffset = CGPointMake(0, ScreenH);
        } completion:^(BOOL finished) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }];
    
    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.8 animations:^{
//            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(NO);
            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.webView.scrollView.mj_header endRefreshing];
        }];
        
    }];
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        
        HHDetailGoodReferralCell *cell = [tableView dequeueReusableCellWithIdentifier:HHDetailGoodReferralCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.gooodDetailModel = self.gooodDetailModel;
        gridcell = cell;
        
    }else if (indexPath.section == 1) {

        HHShopIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:HHShopIntroCellID];
        // cell.gooodDetailModel = self.gooodDetailModel;
        gridcell = cell;
    }else if (indexPath.section == 2){
        HHGoodSpecificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:HHGoodSpecificationsCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, -ScreenW, 0, 0);
        HHattributeValueModel *model = self.discribeArr[indexPath.row];
        cell.leftTitleLabel.text = [NSString stringWithFormat:@"【%@】",model.ValueName];
        cell.discribeLabel.text = model.ValueStr;
        gridcell = cell;
    }else if (indexPath.section == 3){
        
        if (indexPath.row == 0) {
            HHGoodDealRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:HHGoodDealRecordCellID];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
           
//            if(self.evaluations.count == 0){
//                cell.recordTitleLabel.text = @"暂无用户评价";
//            }else{
                cell.recordTitleLabel.text = [NSString stringWithFormat:@"用户评价(%@)",self.count?self.count:@"0"];
//            }
            gridcell = cell;
        }else if (indexPath.row == 1){
            HHEvaluationListCell *cell = [tableView dequeueReusableCellWithIdentifier:HHEvaluationListCellID];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            HHEvaluationListModel *model = [HHEvaluationListModel new];
            model.icon_url = @"icon0";
            model.name = @"小帅****";
            model.dateTime = @"2018.12.1";
            model.proper = @"15/1包";
            model.grade = @"1";
            model.content = @"";
            model.imagesModelArray = @[@"icon1",@"icon2",@"icon3"];
            model.replyContent = @"";
            model.addition_time = @"";
            model.addition_comment = @"";
            cell.model = model;
//            if(self.datas.count == 0){
//                cell.hidden = YES;
//            }
            gridcell = cell;
        }
        if (self.datas.count>0) {
            if (indexPath.row == self.datas.count+1){
                HHGoodDealRecordInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:HHGoodDealRecordInfoDetailCellID];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                HHHomeModel *model = [HHHomeModel mj_objectWithKeyValues:self.datas[0]];
                cell.model = model;
                gridcell = cell;
            }
        }
    }
    gridcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return gridcell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
     return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
     return self.discribeArr.count;
    }else if (section == 3){
     return self.datas.count+2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1) {
        return 90;
    }else if (indexPath.section == 2) {
        
        return 30;
        
    }else if (indexPath.section == 3){
        if (indexPath.row == 1) {
//            if(self.datas.count == 0){
//                return 0.01;
//            }else{
            HHEvaluationListModel *model = [HHEvaluationListModel new];
            model.icon_url = @"icon0";
            model.name = @"小帅****";
            model.dateTime = @"2018.12.1";
            model.proper = @"15/1包";
            model.grade = @"1";
            model.content = @"";
            model.imagesModelArray = @[@"icon1",@"icon2",@"icon3"];
            model.replyContent = @"";
            model.addition_time = @"";
            model.addition_comment = @"";
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHEvaluationListCell class] contentViewWidth:[self cellContentViewWith]];
                
//            }
        }
        if (indexPath.row == 2) {
            return 85;
        }

       return 30;
    }
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3&&indexPath.row == 0) {
        //用户评价
        HHEvaluationListVC *vc = [HHEvaluationListVC new];
        [self.navigationController pushVC:vc];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
        headView.backgroundColor = kWhiteColor;
        self.titleLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 30) text:self.headTitle textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        [headView addSubview:self.titleLabel];
        return headView;
    }

    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return 30;
    }
    return 0.001;
    
}
#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance WithDirection:(XWDrawerAnimatorDirection)vcDirection WithParallaxEnable:(BOOL)parallaxEnable WithFlipEnable:(BOOL)flipEnable
{
    [self dismissViewControllerAnimated:YES completion:nil]; //以防有控制未退出
    XWDrawerAnimatorDirection direction = vcDirection;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = parallaxEnable;
    animator.flipEnable = flipEnable;
    [self xw_presentViewController:vc withAnimator:animator];
//    WEAK_SELF();
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
//        [weakSelf selfAlterViewback];
    }];
}
#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];

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

@end
