//
//  HHWXLoginVC.m
//  CredictCard
//
//  Created by User on 2017/12/21.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHWXLoginVC.h"
#import "HHBandPhoneVc.h"
#import "HHPhoneLoginVC.h"

@interface HHWXLoginVC ()
@property(nonatomic,strong) MBProgressHUD  *hud;

@end

@implementation HHWXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = APP_COMMON_COLOR;
    
    self.wxLoginView.userInteractionEnabled = YES;
        
         if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
             
          //已安装微信
//             [self.loginBtn setImage:[UIImage imageNamed:@"login_icon_button_default"] forState:UIControlStateNormal];
             self.login_label.text = @"微信登录";
             
             [self.wxLoginView setTapActionWithBlock:^{
                 [self getAuthWithUserInfoFromWechat];

                }];
        }else{
            
          //未安装微信
            [self.loginBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
            self.login_label.text = @"登 录";
            [self.wxLoginView setTapActionWithBlock:^{
                
                HHPhoneLoginVC *vc = [[HHPhoneLoginVC alloc] initWithNibName:@"HHPhoneLoginVC" bundle:nil];
                [self.navigationController pushVC:vc];
            }];
        }
}
#pragma mark - 微信授权，获取微信信息

- (void)getAuthWithUserInfoFromWechat
{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];

    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        
        if (error) {
            DLog(@"error--error--%@",error);
            
        } else {
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.color = KA0LabelColor;
            self.hud.detailsLabelText = @"授权中，请稍后...";
            self.hud.detailsLabelColor = kWhiteColor;
            self.hud.detailsLabelFont = FONT(14);
            self.hud.activityIndicatorColor = kWhiteColor;
            [self.hud showAnimated:YES];
            
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat unionId: %@", resp.unionId);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);

            //账户是否存在 ？登录:注册

                            //***************//
                            [[[HHUserLoginAPI postApiLoginWithopenId:resp.openid] netWorkClient] postRequestInView:nil finishedBlock:^(HHUserLoginAPI *api, NSError *error) {

                                if (!error) {
                                    
                                    if (api.State == 1) {
                                        NSString *token = api.Data;
                                        HJUser *user = [HJUser sharedUser];
                                        user.token = token;
                                        [user write];
//                                        HHBandPhoneVc *vc = [HHBandPhoneVc new];
//                                        vc.token = token;
//                                        [self.navigationController pushVC:vc];
                                        kKeyWindow.rootViewController = [[HJTabBarController alloc] init];
                                    }else if (api.State == 0) {
                                        NSString *token = api.Data;
                                        HJUser *user = [HJUser sharedUser];
                                        user.token = token;
                                        [user write];
                                        //是否绑定手机
                                        HHBandPhoneVc *vc = [HHBandPhoneVc new];
                                        vc.token = token;
                                        [self.navigationController pushVC:vc];
                                        [self.hud hideAnimated:YES];

//                                         kKeyWindow.rootViewController = [[HJTabBarController alloc] init];
                                        
                                    } else if (api.State == -99) {
                                        
                                        [self registerWithName:resp.name image:resp.iconurl openid:resp.openid unionId:resp.unionId];
                                    }else{
                                        [self.hud hideAnimated:YES];
                                        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                                    }
                                }else{
                                    [self.hud hideAnimated:YES];
                                    if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
                                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                                        [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了～"];
                                    }
                                }
                            }];
                            //*********************//
            
        }
        
    }];
    

    
}
#pragma mark - 注册

- (void)registerWithName:(NSString *)name image:(NSString *)image openid:(NSString *)openid  unionId:(NSString *)unionId{
    
    //注册
    [[[HHUserLoginAPI postRegsterWithopenId:openid name:name image:image unionId:unionId] netWorkClient] postRequestInView:nil finishedBlock:^(HHUserLoginAPI *api, NSError *error) {

            if (!error) {
            if (api.State == 1) {
                NSString *token = api.Data;
                HJUser *user = [HJUser sharedUser];
                user.token = token;
                [user write];
                kKeyWindow.rootViewController = [[HJTabBarController alloc] init];

            }else if (api.State == 0) {
                //是否绑定手机
                HHBandPhoneVc *vc = [HHBandPhoneVc new];
                NSString *token = api.Data;
                vc.token = token;
                [self.navigationController pushVC:vc];
                [self.hud hideAnimated:YES];

            } else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
                [self.hud hideAnimated:YES];

               }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                [self.hud hideAnimated:YES];
            }
    }];
    
}

- (IBAction)PhoneLogin:(UIButton *)sender {
    
    HHPhoneLoginVC *vc = [HHPhoneLoginVC new];
    [self.navigationController pushVC:vc];
    
}
@end
