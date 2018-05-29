//
//  HHApplyDelegateVC.m
//  lw_Store
//
//  Created by User on 2018/5/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHApplyDelegateVC.h"
#import "HHApplyDelegateCell.h"
#import "HHPayTypeVC.h"
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
#import "HHApplyDelegateNoPayVC.h"

@interface HHApplyDelegateVC ()<UICollectionViewDataSource,payTypeDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode_tf;
@property (weak, nonatomic) IBOutlet LHVerifyCodeButton *sendCodeBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant;
@property (strong, nonatomic)  NSMutableArray *selectItems;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UITextField *codeImage_tf;
@property (strong, nonatomic)  NSMutableArray *datas;
@property (strong, nonatomic)  HHMineModel *model;

@end

@implementation HHApplyDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"申请代理";
    self.view.backgroundColor = kWhiteColor;
    self.collectionView.backgroundColor = kWhiteColor;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HHApplyDelegateCell" bundle:nil] forCellWithReuseIdentifier:@"HHApplyDelegateCell"];
    
    [self.phone_tf lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
    [self.verifyCode_tf lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
    [self.sendCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.codeImage_tf lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];

 
    self.constant.constant = (SCREEN_WIDTH - 4*15 )*4/15+WidthScaleSize_H(15);
    
    [self getDatas];
    
    [self getRandom];
    
    self.codeImage.userInteractionEnabled = YES;
    [self.codeImage  setTapActionWithBlock:^{
       
        [self getRandom];

    }];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)getDatas{
    
    [[[HHMineAPI GetApplyAgent] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                self.datas  = api.Data[@"AgentsName"];
                self.model = [HHMineModel mj_objectWithKeyValues:api.Data];
                
                [self.datas enumerateObjectsUsingBlock:^(NSDictionary  *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.selectItems addObject:@0];
                }];
                [self.collectionView reloadData];
                
                NSNumber *IsApply = api.Data[@"IsApply"];
                if ([IsApply isEqual:@1]) {
                    HHApplyDelegateNoPayVC *vc = [HHApplyDelegateNoPayVC new];
                    vc.model = self.model;
                    [self addChildViewController:vc];
                    [self.view addSubview:vc.view];
                    [vc didMoveToParentViewController:self];
                }
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
}
//获取随机数
- (int)getRandom{
    
    srand((unsigned)time(0));
    int i = arc4random() % 500;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 开始请求
    NSString *api_url = [NSString stringWithFormat:@"http://dm-client.elevo.cn/Admin/Login/GetCode?%d",i];
    [manager GET:api_url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIImage *image = [UIImage imageWithData:responseObject];
        self.codeImage.image = image;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    return i;
}
- (NSMutableArray *)selectItems{
    if (!_selectItems) {
        _selectItems = [NSMutableArray array];
    }
    return _selectItems;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HHApplyDelegateCell *cell = (HHApplyDelegateCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btn_selected = YES;
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@1];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.JoinMoney.length>0?model.JoinMoney:@"0"];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HHApplyDelegateCell *cell = (HHApplyDelegateCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btn_selected = NO;
    [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@0];
    self.priceLabel.text = [NSString stringWithFormat:@"¥0"];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HHApplyDelegateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHApplyDelegateCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model =  [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
//    WEAK_SELF();
//    cell.delegate_btnSelectAction = ^(NSIndexPath *indexPath, BOOL leftButtonSelected) {

//    };
//
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 4*15 )/3,(SCREEN_WIDTH - 4*15 )*4/15);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(WidthScaleSize_H(15), WidthScaleSize_W(15), WidthScaleSize_H(0), WidthScaleSize_W(15));
    
}

- (IBAction)sendCodeActiion:(LHVerifyCodeButton *)sender {
    
    if (self.phone_tf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先填写手机号"];
    }else{
        //验证手机号
        [self VerifyMobile];
    }
}
//支付
- (IBAction)payBtnAction:(UIButton *)sender {
    
    
       __block  HHMineModel *model;

        [self.selectItems enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:@1]) {

                model = [HHMineModel mj_objectWithKeyValues:self.datas[idx]];

            }
        }];

    NSString *vari_str = [self varifyDelegateName:model.AgentName phoneNum:self.phone_tf.text imageCode:self.codeImage_tf.text smsCode:self.verifyCode_tf.text];
    if (!vari_str) {
        //

        //支付
        if (model.JoinMoney.floatValue<=0||model.JoinMoney.length==0) {
            [[[HHMineAPI postApplyAgentWithagnetId:model.Id smsCode:self.verifyCode_tf.text mobile:self.phone_tf.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                if (!error) {
                    if (api.State == 1) {


                    }else{
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }else{

                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }


            }];
        }else{
            [[[HHMineAPI postAgentApplyPayWithagnetId:model.Id smsCode:self.verifyCode_tf.text mobile:self.phone_tf.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                if (!error) {
                    if (api.State == 1) {
                        
                        HHPayTypeVC *vc = [HHPayTypeVC new];
                        vc.delegate = self;
                        [self setUpAlterViewControllerWith:vc WithDistance:ScreenH/2.2 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];

                    }else{
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }else{

                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }


            }];
        }

        }else{
            [SVProgressHUD showInfoWithStatus:vari_str];
        }
}
#pragma mark- payTypeDelegate

- (void)commitActionWithBtn:(UIButton *)btn{
    
    //调支付
    
}
- (NSString *)varifyDelegateName:(NSString *)delegateName phoneNum:(NSString *)phoneNum imageCode:(NSString *)imageCode smsCode:(NSString *)smsCode{
    
    if (delegateName.length == 0) {
        return @"请选择代理等级";
    }else if (phoneNum.length == 0) {
        return @"请填写手机号";
    }else if (imageCode.length == 0) {
        return @"请填写图片验证码";
    }else if (smsCode.length == 0) {
        return @"请填写短信验证码";
    }
    return nil;
}
//验证手机号
- (void)VerifyMobile{
    
    [[[HHMineAPI postVerifyMobile:self.phone_tf.text] netWorkClient] postRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                  NSString *vari_str = [self varifyDelegateName:@"1" phoneNum:self.phone_tf.text imageCode:self.codeImage_tf.text smsCode:@"1"];
                  if (!vari_str) {
                        //发送验证码
                      [self sendCodeReq];
                            
                    }else{
                        [SVProgressHUD showInfoWithStatus:vari_str];
                    }
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
}
- (void)sendCodeReq{
    
    [[[HHMineAPI postSms_SendCode:self.phone_tf.text code:self.codeImage_tf.text] netWorkClient] postRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                
                [self.sendCodeBtn startTimer:120];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
    
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


    
   
@end