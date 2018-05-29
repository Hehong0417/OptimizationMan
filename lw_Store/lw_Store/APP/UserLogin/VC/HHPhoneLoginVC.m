//
//  HHPhoneLoginVC.m
//  CredictCard
//
//  Created by User on 2018/4/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPhoneLoginVC.h"
#import "HHRegisterVC.h"

@interface HHPhoneLoginVC ()

@end

@implementation HHPhoneLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机号登录";
    
    self.view.backgroundColor = RGB(120, 159, 243);
    [self.login_btn lh_setCornerRadius:5 borderWidth:1 borderColor:kWhiteColor];
    [self.login_btn addTarget:self action:@selector(login_btnAction) forControlEvents:UIControlEventTouchUpInside];
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
                }
            }
        }];
        
    }
}
- (IBAction)rigsterAction:(UIButton *)sender {
    
    HHRegisterVC *vc = [HHRegisterVC new];
    [self.navigationController pushVC:vc];
}

@end
