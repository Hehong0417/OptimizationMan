//
//  HHApplyDelegateNoPayVC.m
//  lw_Store
//
//  Created by User on 2018/5/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHApplyDelegateNoPayVC.h"
#import "HHnormalSuccessVC.h"

@interface HHApplyDelegateNoPayVC ()

@end

@implementation HHApplyDelegateNoPayVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPaySucesscount) name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayFailcount) name:KWX_Pay_Fail_Notification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(payAction:) backgroundImage:nil title:@"去支付"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = kBlackColor;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableV.tableFooterView = footView;
    
}

- (NSArray *)groupTitles{
    
    return @[@[@"选择申请代理等级",@"申请人手机号",@"申请代理金额",@"申请状态"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@"",@"",@""]];
    
}
- (NSArray *)groupDetials{

    return @[@[self.model.AgentName,@"13826424459",[NSString stringWithFormat:@"¥%@",self.model.JoinMoney],@"待付款"]];
}
- (void)payAction:(UIButton *)btn{
    
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
    
        //获取支付信息接口
        [[[HHMineAPI postAgentApplyPayWithagnetId:nil smsCode:nil mobile:nil] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            
            if (!error) {
                if (api.State == 1) {
                    //微信支付
                   HHWXModel *wxModel = [HHWXModel mj_objectWithKeyValues:api.Data];
                   [HHWXModel payReqWithModel:wxModel];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
            
            
        }];
        
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"您未安装微信，是否安装？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {


        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[KWX_APPStore_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

        }];

        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];

    }
}
#pragma mark - 微信支付

- (void)wxPaySucesscount{
    
    HHnormalSuccessVC *vc = [HHnormalSuccessVC new];
    vc.title_str = @"支付成功";
    vc.discrib_str = self.model.AgentName;
    vc.title_label_str = @"支付成功";
    [self.navigationController pushVC:vc];

}

- (void)wxPayFailcount {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showErrorWithStatus:@"支付失败～"];
        
    });
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];

}

@end
