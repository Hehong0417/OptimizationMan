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
#import "HHGoodDealRecordInfoDetailCell.h"
#import "HHAddCartTool.h"
#import "DCFeatureSelectionViewController.h"
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
#import "HHShoppingVC.h"
#import "HHSubmitOrdersVC.h"
#import "HHNotWlanView.h"
#import "HHShopIntroCell.h"
#import "HHEvaluationListCell.h"
#import "HHEvaluationListVC.h"
#import "HHAddAdressVC.h"
#import "HHActivityModel.h"
#import "MLMenuView.h"
#import "CZCountDownView.h"
#import "HHdiscountPackageViewTabCell.h"
#import "HHdiscountPackageVC.h"
#import "HHGuess_you_likeTabCell.h"
#import "HHEvaluationListVC.h"
#import <AVKit/AVKit.h>   //包含类 AVPlayerViewController
#import <AVFoundation/AVFoundation.h>  //包含类 AVPlayer
#import "HHSpellGroupCell.h"
#import "HHActivityWebVC.h"

@interface HHGoodBaseViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,SDCycleScrollViewDelegate,HHCartVCProtocol>
{
    
    AVPlayerViewController *aVPlayerViewController;
}
@property (strong, nonatomic) UIView *tableHeader;
@property (strong, nonatomic) CZCountDownView *countDown;
@property (strong, nonatomic) UILabel *title_label;
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
@property (nonatomic, strong) NSMutableArray *guess_you_like_arr;
@property (nonatomic, strong) NSNumber *Mode;
@property (nonatomic, strong) UIView *countTimeView;
@property (nonatomic, strong)  NSMutableArray *JoinActivity_arr;

@end

//cell
static NSString *lastNum_;
static NSArray *lastSeleArray_;
static NSArray *lastSele_IdArray_;

static NSString *HHDetailGoodReferralCellID = @"HHDetailGoodReferralCell";//商品信息
static NSString *HHShopIntroCellID = @"HHShopIntroCell";//店铺简介
static NSString *HHGoodSpecificationsCellID = @"HHGoodSpecificationsCell";//商品规格
static NSString *HHEvaluationListCellID = @"HHEvaluationListCell";
static NSString *HHdiscountPackageViewTabCellID = @"HHdiscountPackageViewTabCell";
static NSString *HHGuess_you_likeTabCellID = @"HHGuess_you_likeTabCell";//猜你喜欢
static NSString *HHSpellGroupCellID = @"HHSpellGroupCell";


@implementation HHGoodBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //网络监测
    [self setMonitor];
    
    [self setUpViewScroll];
    
    [self setUpInit];
    
    //加入购物车、立即购买
    [self addCartOrBuyAction];
    
    self.tableView.hidden = YES;
//    self.addCartTool.hidden = YES;
    
    //获取数据
    [self getDatas];
    
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

#pragma mark -网络监测

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
#pragma mark - 懒加载

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
- (NSMutableArray *)discribeArr{
    if (!_discribeArr) {
        _discribeArr = [NSMutableArray array];
    }
    return _discribeArr;
}
- (NSMutableArray *)guess_you_like_arr{
    if (!_guess_you_like_arr) {
        _guess_you_like_arr = [NSMutableArray array];
    }
    return _guess_you_like_arr;
}
- (NSMutableArray *)JoinActivity_arr{
    if (!_JoinActivity_arr) {
        _JoinActivity_arr = [NSMutableArray array];
    }
    return _JoinActivity_arr;
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
    
    //tableHeaderView
    _tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW)];
    
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 350, 50)];
    bg_view.backgroundColor = [UIColor blackColor];
    _title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    _title_label.textColor = kWhiteColor;
    _title_label.textAlignment = NSTextAlignmentRight;
    _title_label.text = @"距离活动结束";
    _countDown = [CZCountDownView new];
    _countDown.frame = CGRectMake(CGRectGetMaxX(_title_label.frame),0, 200, 50);
    _countDown.backgroundImageName = @"";
    _countDown.timerStopBlock = ^{
        NSLog(@"时间停止");
    };
    [bg_view addSubview:_title_label];
    [bg_view addSubview:_countDown];
    [self.countTimeView addSubview:bg_view];
    [_tableHeader addSubview:self.countTimeView];
    bg_view.centerX = self.countTimeView.centerX;
    [_tableHeader addSubview:self.cycleScrollView];

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
        
        [self deleteObj];

    }];
    
    WEAK_SELF();
    //选择Item通知
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:SHOPITEMSELECTBACK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSArray *selectArray = note.userInfo[@"Array"];
        NSArray *select_IdArray = note.userInfo[@"id_Array"];
        NSString *num = note.userInfo[@"Num"];
        NSString *buttonTag = note.userInfo[@"Tag"];
        NSString *button_title = note.userInfo[@"button_title"];
        NSString *pid = note.userInfo[@"pid"];

        lastNum_ = num;
        lastSeleArray_ = selectArray;
        lastSele_IdArray_ = select_IdArray;
        
        //更新价格和s积分
        NSString *seleId_str = [NSString stringWithFormat:@"%@_%@",self.gooodDetailModel.Id,[select_IdArray componentsJoinedByString:@"_"]];

        [self.gooodDetailModel.SKUList enumerateObjectsUsingBlock:^(HHproduct_skuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.Id isEqualToString:seleId_str]) {
                self.gooodDetailModel.BuyPrice = obj.SalePrice;
                [self.tableView reloadData];
            }
        }];
          //加入购物车
            if ([button_title isEqualToString:@"加入购物车"]&&[buttonTag isEqualToString:@"0"]) {
                NSLog(@"加入购物车");
               [weakSelf setUpWithAddSuccessWithselect_IdArray:select_IdArray quantity:num pid:pid];
            }else if (([button_title isEqualToString:@"立即购买"]||[button_title isEqualToString:@"参加拼团"]||[button_title isEqualToString:@"参加降价团"]||[button_title isEqualToString:@"砍价"]||[button_title isEqualToString:@"送礼"])&&[buttonTag isEqualToString:@"0"]) {
                NSLog(@"立即购买、活动");
                [weakSelf instanceBuyActionWithselect_IdArray:select_IdArray quantity:num pid:pid];
            }
    }];
    
}
- (void)deleteObj{
    [[NSNotificationCenter defaultCenter]removeObserver:self.dcObj];
}

#pragma mark -加载数据

- (void)getDatas{
    
    //商品详情
    [[[HHHomeAPI GetProductDetailWithId:self.Id] netWorkClient] getRequestInView:self.view finishedBlock:^(HHHomeAPI *api, NSError *error) {
        self.tableView.hidden = NO;
//        self.addCartTool.hidden = NO;
        if (!error) {
            if (api.State == 1) {
                
                self.gooodDetailModel = nil;
                self.gooodDetailModel = [HHgooodDetailModel mj_objectWithKeyValues:api.Data];
                self.cycleScrollView.imageURLStringsGroup = self.gooodDetailModel.ImageUrls;
                
                if (self.gooodDetailModel.VideoUrl.length>0) {
                    self.cycleScrollView.isShowPlay = YES;
                }else{
                    self.cycleScrollView.isShowPlay = NO;
                }
                self.discribeArr =  self.gooodDetailModel.AttributeValueList.mutableCopy;
                self.addCartTool.product_id = self.gooodDetailModel.Id;
                if ([self.gooodDetailModel.IsCollection isEqual:@1]) {
                    self.addCartTool.collectBtn.selected  = YES;
                }else{
                    self.addCartTool.collectBtn.selected = NO;
                }
                self.addCartTool.userInteractionEnabled = YES;
                [self tableView:self.tableView viewForHeaderInSection:1];
                
                [self.tableView reloadData];

                
                [self setUpGoodsWKWebView];
                

                //拼团
               HHActivityModel *GroupBy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.GroupBuy];
               
                //正在拼团列表
               HHJoinActivityModel *act_m = [HHJoinActivityModel mj_objectWithKeyValues:self.gooodDetailModel.GroupBuyActivity];
                if ([act_m.is_exist isEqual:@1]) {
                    self.JoinActivity_arr = @[act_m].mutableCopy;
                    [self.tableView reloadData];
                }
                //降价团
                HHActivityModel *CutGroupBuy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.CutGroupBuy];
                //送礼
                HHActivityModel *SendGift_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SendGift];
                //砍价
                HHActivityModel *CutPrice_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.CutPrice];

                if ([GroupBy_m.IsJoin isEqual:@1]) {
                    
                    [self.alert_Arr addObject:GroupBy_m];
                }
                if ([CutGroupBuy_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:CutGroupBuy_m];
                }
                if ([SendGift_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:SendGift_m];
                }
                if ([CutPrice_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:CutPrice_m];
                }
                
                if (self.alert_Arr.count >0) {
                    self.addCartTool.buyBtn.hidden = NO;
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3;
                    [self.addCartTool.buyBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 75, 5, 10)];
                    [self.addCartTool.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 40)];
                }else{
                    self.addCartTool.buyBtn.hidden = NO;
                    [self.addCartTool.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
                    [self.addCartTool.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,0)];
                    [self.addCartTool.buyBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.addCartTool.buyBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3;
                }
                // 秒杀
                HHActivityModel *SecKill_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SecKill];
                WEAK_SELF();
                if ([SecKill_m.IsSecKill isEqual:@1]) {
                    self.cycleScrollView.frame = CGRectMake(0, 50, ScreenW, ScreenW);
                    weakSelf.tableHeader.frame = CGRectMake(0, 0, ScreenW, ScreenW+50);
                    if (SecKill_m.StartSecond.integerValue>0) {
                        weakSelf.titleLabel.text = @"距离活动开始";
                        _countDown.timestamp = SecKill_m.StartSecond.integerValue;
                    }else{
                        weakSelf.titleLabel.text = @"距离活动结束";
                        _countDown.timestamp = SecKill_m.EndSecond.integerValue;
                    }
                }else{
                    self.cycleScrollView.frame = CGRectMake(0, 0, ScreenW, ScreenW);
                    weakSelf.tableHeader.frame = CGRectMake(0, 0, ScreenW, ScreenW);
                }
                weakSelf.tableView.tableHeaderView = weakSelf.tableHeader;

            }else{
                [self.activityIndicator stopAnimating];
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [self.activityIndicator stopAnimating];
            if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]||[error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }
    }];
    
    //猜你喜欢
    [self getGuess_you_likeData];
    
}
//猜你喜欢
- (void)getGuess_you_likeData{
    
    [[[HHCategoryAPI GetAlliancesProductsWithpids:self.Id]  netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *arr =  api.Data;
                self.guess_you_like_arr = arr.mutableCopy;
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
        }
    }];
    
}
//编码图片
- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
}
#pragma mark - 加入购物车、立即购买
//加入购物车、立即购买
- (void)addCartOrBuyAction{
    
    if(self.isCanReceive){
        UIView *view = [UIView lh_viewWithFrame:CGRectMake(0, ScreenH-45-SafeAreaBottomHeight-NAVBAR_HEIGHT-Status_HEIGHT, ScreenW, 45)  backColor:APP_BUTTON_COMMON_COLOR];

        UIButton *receiveBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, ScreenW, 45) target:self action:@selector(receiveBtnAction:) title:@"领 取" titleColor:kWhiteColor font:FONT(15) backgroundColor:APP_BUTTON_COMMON_COLOR];
        [view addSubview:receiveBtn];
        [self.view addSubview:view];

    }else{
       [self.view addSubview:self.addCartTool];
    }
    
    WEAK_SELF();
    //加入购物车
    
    self.addCartTool.addCartBlock = ^{
        weakSelf.Mode = @1;
        [weakSelf showFeatureSelectionWithActModel:nil isCart:YES Mode:@1];
    };
    //立即购买
    self.addCartTool.buyBlock = ^(UIButton *btn) {
        
        if (self.alert_Arr.count>0) {
            
            [weakSelf showMenuViewWithButton:btn];
        }else{
            [weakSelf showFeatureSelectionWithActModel:nil isCart:NO Mode:@1];
        }
    };

    //****跳转购物车****
    self.addCartTool.cartIconImgV.userInteractionEnabled = YES;
    
    [self.addCartTool.cartIconImgV setTapActionWithBlock:^{

      [[NSNotificationCenter defaultCenter]removeObserver:weakSelf.dcObj];
//        weakSelf.addCartTool.hidden = YES;
        HHShoppingVC *vc = [HHShoppingVC new];
        vc.cartType = HHcartType_goodDetail;
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushVC:vc];
    }];
}
- (void)receiveBtnAction:(UIButton *)btn{
    
    [self showFeatureSelectionWithActModel:nil isCart:NO Mode:@8192];

}
#pragma mark --  活动选择

- (void)showMenuViewWithButton:(UIButton *)button{
    
    MLMenuView *menuView = [[MLMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, SCREEN_HEIGHT-Status_HEIGHT-49-self.alert_Arr.count*50, SCREEN_WIDTH/3, self.alert_Arr.count*50) WithmodelsArr:self.alert_Arr WithMenuViewOffsetTop:Status_HEIGHT WithTriangleOffsetLeft:80 button:button];
    menuView.isHasTriangle = NO;
    WEAK_SELF();
    menuView.didSelectBlock = ^(NSInteger index, HHActivityModel *model) {
        
        [weakSelf showFeatureSelectionWithActModel:model isCart:NO Mode:model.Mode];
    };
    [menuView showMenuEnterAnimation:MLEnterAnimationStyleNone];
    
}
#pragma mark --  属性选择

- (void)showFeatureSelectionWithActModel:(HHActivityModel *)act_m isCart:(BOOL)isCart Mode:(NSNumber *)mode{
    
    //属性选择
    DCFeatureSelectionViewController *dcNewFeaVc = [DCFeatureSelectionViewController new];
    dcNewFeaVc.product_sku_value_arr = self.gooodDetailModel.SKUValues;
    dcNewFeaVc.lastNum = lastNum_.intValue;
    if (self.isCanReceive) {
        dcNewFeaVc.MinBuyCount = 1;
    }else{
        dcNewFeaVc.MinBuyCount = self.gooodDetailModel.MinBuyCount.intValue;
    }
    dcNewFeaVc.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
    dcNewFeaVc.lastSele_IdArray = [NSMutableArray arrayWithArray:lastSele_IdArray_];
    dcNewFeaVc.product_sku_arr = self.gooodDetailModel.SKUList;
    dcNewFeaVc.product_id = self.gooodDetailModel.Id;
    
    self.Mode = mode;
    if ([self.Mode isEqual:@2]) {
        dcNewFeaVc.button_Title = @"参加拼团";
    }else if ([self.Mode isEqual:@8]){
        dcNewFeaVc.button_Title = @"送礼";
    }else if ([self.Mode isEqual:@32]){
        dcNewFeaVc.button_Title = @"参加降价团";
    }else if ([self.Mode isEqual:@4096]){
        dcNewFeaVc.button_Title = @"砍价";
    }else if([self.Mode isEqual:@1]&&(isCart==YES)){
        dcNewFeaVc.button_Title = @"加入购物车";
    }else{
        dcNewFeaVc.button_Title = @"立即购买";
    }
    dcNewFeaVc.product_price = self.gooodDetailModel.BuyPrice;
    dcNewFeaVc.product_stock = self.gooodDetailModel.Stock;
    
    CGFloat  distance;
    if(self.gooodDetailModel.SKUValues.count == 0) {
        distance = ScreenH/2.3;
    }else if (self.gooodDetailModel.SKUValues.count == 1){
        distance = ScreenH/1.75;
    }else{
        distance = ScreenH*2/3;
    }
    dcNewFeaVc.nowScreenH = distance;
    
    if (self.gooodDetailModel.ImageUrls.count>0) {
        dcNewFeaVc.goodImageView = self.gooodDetailModel.ImageUrls[0];
    }
    
    [self setUpAlterViewControllerWith:dcNewFeaVc WithDistance:distance WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
}
#pragma mark - HHCartVCProtocol

- (void)cartVCBackActionHandle{
    
    //接收到通知
    [self acceptanceNote];
    
}
#pragma mark - 加入购物车成功
- (void)setUpWithAddSuccessWithselect_IdArray:(NSArray *)select_IdArray quantity:(NSString *)quantity pid:(NSString *)pid
{
    NSString *select_Id = [select_IdArray componentsJoinedByString:@"_"];
    NSString *sku_id;
    if (select_Id.length>0) {
        sku_id = select_Id;
    }else{
        sku_id = @"0";
    }
    NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",pid,sku_id];
    
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

- (void)instanceBuyActionWithselect_IdArray:(NSArray *)select_IdArray quantity:(NSString *)quantity pid:(NSString *)pid{
    
    NSString *select_Id = [select_IdArray componentsJoinedByString:@"_"];
    NSString *sku_id;
    if (select_Id.length>0) {
        sku_id = select_Id;
    }else{
        sku_id = @"0";
    }
    NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",pid,sku_id];
    NSLog(@"select_Id:%@",sku_id_Str);

    if (sku_id_Str.length>0) {
//      是否存在收货地址
        [self isExitAddressWithsku_id_Str:sku_id_Str quantity:quantity];
    }
}
#pragma mark - 是否存在收货地址

- (void)isExitAddressWithsku_id_Str:(NSString *)sku_id_Str quantity:(NSString *)quantity{
    
    [[[HHCartAPI IsExistOrderAddress] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                if ([api.Data isEqual:@1]) {
                    
                    HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                    vc.enter_type = HHaddress_type_Spell_group;
                    vc.ids_Str = sku_id_Str;
                    vc.pids = self.Id;
                    vc.count = quantity;
                    vc.mode = self.Mode;
                    vc.gbId = self.gbId;
                    if ([self.Mode isEqual:@1]) {
                    vc.enter_type = HHaddress_type_add_productDetail;
                    }
                    [self.navigationController pushVC:vc];
                }else{
                    HHAddAdressVC *vc = [HHAddAdressVC new];
                    vc.titleStr = @"新增收货地址";
                    vc.addressType = HHAddress_settlementType_productDetail;
                    vc.mode = self.Mode;
                    vc.ids_Str = sku_id_Str;
                    vc.pids = self.Id;
                    vc.gbId = self.gbId;
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
        _tableView.estimatedRowHeight = 0;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = KVCBackGroundColor;
        _tableView.tableFooterView = self.tableFooter;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:HHDetailGoodReferralCellID bundle:nil] forCellReuseIdentifier:HHDetailGoodReferralCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHShopIntroCellID bundle:nil] forCellReuseIdentifier:HHShopIntroCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHGoodSpecificationsCellID bundle:nil] forCellReuseIdentifier:HHGoodSpecificationsCellID];
        [_tableView registerClass:[HHdiscountPackageViewTabCell class] forCellReuseIdentifier:HHdiscountPackageViewTabCellID];
        [_tableView registerClass:[HHGuess_you_likeTabCell class] forCellReuseIdentifier:HHGuess_you_likeTabCellID];
        [_tableView registerClass:[HHSpellGroupCell class] forCellReuseIdentifier:HHSpellGroupCellID];


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
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"loadImag_default"];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        [_cycleScrollView setPlaceholderImage:[UIImage imageWithColor:kWhiteColor]];
        
        _cycleScrollView.delegate = self;
    }
    
    return _cycleScrollView;
}
- (UIView *)countTimeView{
    if (!_countTimeView) {
        _countTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _countTimeView.backgroundColor = kBlackColor;
    }
    return _countTimeView;
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
        //店铺介绍
        HHShopIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:HHShopIntroCellID];
        // cell.gooodDetailModel = self.gooodDetailModel;
        gridcell = cell;
    }else if(indexPath.section == 2){
        //拼团
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *h_line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 8) backColor:KVCBackGroundColor];
            [cell.contentView addSubview:h_line];
            HHJoinActivityModel *GroupBy_m = [HHJoinActivityModel mj_objectWithKeyValues:self.gooodDetailModel.GroupBuyActivity];
            UILabel *text_lab = [UILabel lh_labelWithFrame:CGRectMake(20, 8, 200, 42) text:[NSString stringWithFormat:@"%@人在拼团，可直接参与",GroupBy_m.remain_count] textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
            [cell.contentView addSubview:text_lab];
            gridcell = cell;
            
        }else{
            HHSpellGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:HHSpellGroupCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.spellGroup_button  addTarget:self action:@selector(spellGroup_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.model = self.JoinActivity_arr[indexPath.row-1];
            gridcell = cell;
        }
        
    } else if (indexPath.section == 3){
        //商品信息
        HHGoodSpecificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:HHGoodSpecificationsCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, -ScreenW, 0, 0);
        if (indexPath.row < self.discribeArr.count) {
            HHattributeValueModel *model = self.discribeArr[indexPath.row];
            cell.leftTitleLabel.text = [NSString stringWithFormat:@"【%@】",model.ValueName];
            cell.discribeLabel.text = model.ValueStr;
        }
        gridcell = cell;
    }else if (indexPath.section == 4){
        //用户评价
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FONT(14);
        cell.textLabel.text = [NSString stringWithFormat:@"用户评价(%@)",self.gooodDetailModel.EvaluateCount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 5){
            //优惠套餐
            HHdiscountPackageViewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:HHdiscountPackageViewTabCellID];
             cell.packages_model = self.gooodDetailModel.Packages[indexPath.row];
             cell.indexPath = indexPath;
             cell.nav = self.navigationController;
             gridcell = cell;
    }else if (indexPath.section == 6){
        //猜你喜欢
       HHGuess_you_likeTabCell  *cell = [tableView dequeueReusableCellWithIdentifier:HHGuess_you_likeTabCellID];
        cell.guess_you_like_arr =  self.guess_you_like_arr;
        cell.nav = self.navigationController;
        cell.dcObj = self.dcObj;
        gridcell = cell;
    }
    gridcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return gridcell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
  return  7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
     return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return self.JoinActivity_arr.count>0?self.JoinActivity_arr.count+1:0;
    }else if (section == 3) {
     return self.discribeArr.count+1;
    }else if (section == 4) {
        return self.gooodDetailModel.EvaluateCount.integerValue>0?1:0;
    }else if (section == 5){
     return self.gooodDetailModel.Packages.count;
    }else if (section == 6){
        return self.guess_you_like_arr.count>0?1:0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [self.tableView cellHeightForIndexPath:indexPath model:self.gooodDetailModel keyPath:@"gooodDetailModel" cellClass:[HHDetailGoodReferralCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 1) {
        return 90;
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 50;
        }
        return 65;
    }else if (indexPath.section == 3) {
        if(indexPath.row == self.discribeArr.count){
          return  self.discribeArr.count>0?10:0.001;
        }
       return 30;
    }else if (indexPath.section == 4) {
        return 35;
    }else if (indexPath.section == 5) {
        return 130;
    }else if (indexPath.section == 6) {
        return 230+45;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        if (self.discribeArr.count>0) {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
            headView.backgroundColor = kWhiteColor;
            self.titleLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 30) text:@"商品信息" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
            [headView addSubview:self.titleLabel];
            return headView;
        }else{
            return [UIView new];
        }
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.gooodDetailModel.EvaluateCount.integerValue>0&&indexPath.section==4) {
        //用户评价
        HHEvaluationListVC *vc = [HHEvaluationListVC new];
        vc.pid = self.gooodDetailModel.Id;
        [self.navigationController pushVC:vc];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        if (self.discribeArr.count>0) {
            return 3;
        }else{
            return 0.001;
        }
    }else if (section == 4) {
        return self.gooodDetailModel.EvaluateCount.integerValue>0?3:0.001;
    }else if (section == 5){
        return self.gooodDetailModel.Packages.count>0?3:0.001;
    }
    return 3;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 3) {
        if (self.discribeArr.count>0) {
          return 30;
        }else{
            return 0.001;
        }
    }
    return 0.001;
    
}
//去拼团
- (void)spellGroup_buttonAction:(UIButton *)button{
    
    HHSpellGroupCell *cell = (HHSpellGroupCell *)[[button superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHActivityWebVC *vc = [HHActivityWebVC new];
    HHJoinActivityModel  *model = self.JoinActivity_arr[indexPath.row-1];
    vc.gbId = model.Id;
    
    [self.navigationController pushVC:vc];
    
}
#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
//    if (self.gooodDetailModel.VideoUrl.length>0) {
        if (index == 0) {
            aVPlayerViewController = [[AVPlayerViewController alloc]init];
            if (self.gooodDetailModel.VideoUrl.length) {
                aVPlayerViewController.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:self.gooodDetailModel.VideoUrl]];
            }else{
                aVPlayerViewController.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:@"http://9890.vod.myqcloud.com/9890_4e292f9a3dd011e6b4078980237cc3d3.f20.mp4"]];
            }
            [aVPlayerViewController.player play];
            [self presentViewController:aVPlayerViewController animated:YES completion:nil];
        }
//    }
    
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
