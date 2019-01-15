//
//  HHPhoneLoginVC.m
//  CredictCard
//
//  Created by User on 2018/4/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPhoneLoginVC.h"
#import "HHRegisterVC.h"
#import "HHForgetPasswordVC.h"

@interface HHPhoneLoginVC ()

@end

@implementation HHPhoneLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机号登录";
    
    self.view.backgroundColor = kWhiteColor;
    [self.login_btn lh_setCornerRadius:5 borderWidth:1 borderColor:kWhiteColor];
    [self.login_btn addTarget:self action:@selector(login_btnAction) forControlEvents:UIControlEventTouchUpInside];
    

    self.forgetPassword.userInteractionEnabled = YES;
    [self.forgetPassword setTapActionWithBlock:^{
        HHForgetPasswordVC *vc = [HHForgetPasswordVC new];
        [self.navigationController pushVC:vc];
    }];
    
    self.phone.leftViewMode = UITextFieldViewModeAlways;
    self.phone.leftView = [UIView lh_viewWithFrame:CGRectMake(0, 0, 15, 40) backColor:kClearColor];
    self.pwd.leftViewMode = UITextFieldViewModeAlways;
    self.pwd.leftView = [UIView lh_viewWithFrame:CGRectMake(0, 0, 15, 40) backColor:kClearColor];
    
    UIView *line1 = [UIView lh_viewWithFrame:CGRectMake(0, self.phone.mj_h-1, ScreenW-120, 1) backColor:LineLightColor];
    [self.phone addSubview:line1];
    UIView *line2 = [UIView lh_viewWithFrame:CGRectMake(0, self.pwd.mj_h-1, ScreenW-120, 1) backColor:LineLightColor];
    [self.pwd addSubview:line2];
   
}
- (void)login_btnAction{
    
    if (self.phone.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号！"];
    }else if(self.pwd.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请填写密码！"];
    }else{
        
        [[[HHUserLoginAPI postIOSAuthenticationLoginWithphone:self.phone.text psw:self.pwd.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    NSString *token = api.Data;
                    HJUser *user = [HJUser sharedUser];
                    user.token = token;
                    [user write];
                    HJTabBarController *tabBarVC = [[HJTabBarController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
                }else{
                    [self lh_showHudInView:self.view labText:api.Msg];
                }
            }else{
                [self lh_showHudInView:self.view labText:error.localizedDescription];
            }
        }];
    }
}
- (IBAction)rigsterAction:(UIButton *)sender {
    
    HHRegisterVC *vc = [HHRegisterVC new];
    [self.navigationController pushVC:vc];
}

@end
