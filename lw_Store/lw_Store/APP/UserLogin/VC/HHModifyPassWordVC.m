//
//  HHLoginVC.m
//  springDream
//
//  Created by User on 2018/9/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHModifyPassWordVC.h"
#import "HHWXLoginVC.h"

@interface HHModifyPassWordVC ()<UITextFieldDelegate>
{
    UIImageView *_code_imagV;
    UIButton *_rigster_button;
    UITextField *_code_textfield;
    UITextField *_pw_textfield;
    UITextField *_cpw_textfield;
    UIButton *_protocol_btn;
}

@end

@implementation HHModifyPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    self.title = @"修改密码";
    
    
    _code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(AdapationLabelHeight(60), AdapationLabelHeight(40), ScreenW-2*AdapationLabelHeight(60), AdapationLabelHeight(30)) placeholder:@"请输入原始密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _code_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _code_textfield.secureTextEntry = YES;
    _code_textfield.delegate = self;
    [self.view addSubview:_code_textfield];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_textfield.mj_x,CGRectGetMaxY(_code_textfield.frame)+AdapationLabelHeight(8), ScreenW-2*AdapationLabelHeight(60), 1) backColor:LineLightColor];
    [self.view addSubview:h_line_1];

    
    _pw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(AdapationLabelHeight(60), CGRectGetMaxY(h_line_1.frame)+AdapationLabelHeight(20), ScreenW-2*AdapationLabelHeight(60), AdapationLabelHeight(30)) placeholder:@"请输入新密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _pw_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _pw_textfield.secureTextEntry = YES;
    _pw_textfield.delegate = self;
    [self.view addSubview:_pw_textfield];
    
    UIView *h_line_2 = [UIView lh_viewWithFrame:CGRectMake(_pw_textfield.mj_x,CGRectGetMaxY(_pw_textfield.frame)+AdapationLabelHeight(8), ScreenW-2*AdapationLabelHeight(60), 1) backColor:LineLightColor];
    [self.view addSubview:h_line_2];
    
    _cpw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(AdapationLabelHeight(60), CGRectGetMaxY(h_line_2.frame)+AdapationLabelHeight(20), ScreenW-2*AdapationLabelHeight(60), AdapationLabelHeight(30)) placeholder:@"再次输入新密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _cpw_textfield.keyboardType = UIKeyboardTypeASCIICapable;
    _cpw_textfield.secureTextEntry = YES;
    _cpw_textfield.delegate = self;
    [self.view addSubview:_cpw_textfield];
    
    UIView *h_line_3 = [UIView lh_viewWithFrame:CGRectMake(_cpw_textfield.mj_x,CGRectGetMaxY(_cpw_textfield.frame)+AdapationLabelHeight(8), ScreenW-2*AdapationLabelHeight(60), 1) backColor:LineLightColor];
    [self.view addSubview:h_line_3];
    
    
    _code_textfield.leftViewMode = UITextFieldViewModeAlways;
    _code_textfield.leftView = [UIView lh_viewWithFrame:CGRectMake(0, 0, 15, 40) backColor:kClearColor];
    _pw_textfield.leftViewMode = UITextFieldViewModeAlways;
    _pw_textfield.leftView = [UIView lh_viewWithFrame:CGRectMake(0, 0, 15, 40) backColor:kClearColor];
    _cpw_textfield.leftViewMode = UITextFieldViewModeAlways;
    _cpw_textfield.leftView = [UIView lh_viewWithFrame:CGRectMake(0, 0, 15, 40) backColor:kClearColor];
    
    _rigster_button = [UIButton lh_buttonWithFrame:CGRectMake(AdapationLabelHeight(60), CGRectGetMaxY(h_line_3.frame)+AdapationLabelHeight(35), ScreenW-2*AdapationLabelHeight(60), AdapationLabelHeight(40)) target:self action:@selector(rigsterAction:) title:@"确认" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_BUTTON_COMMON_COLOR];
    [_rigster_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_rigster_button];
    
    
}
- (void)rigsterAction:(UIButton *)button{
    
    NSString *isValid =  [self isValidWithPwdStr:_code_textfield.text newPwdStr:_pw_textfield.text commitPwdStr:_cpw_textfield.text];
    NSString *old_pw_str = _code_textfield.text;
    NSString *new_pw_str = _pw_textfield.text;
    NSString *commitPwdStr = _cpw_textfield.text;

    if (!isValid) {
        
         [[[HHMineAPI postChangePassWordWitholdPassWord:old_pw_str newPassWord:new_pw_str commitPassWord:commitPwdStr] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showSuccessWithStatus:@"修改密码成功，请重新登录！"];
                    HJUser *user = [HJUser sharedUser];
                    user.token = nil;
                    [user write];
                    kKeyWindow.rootViewController = [[HJNavigationController alloc] initWithRootViewController:[HHWXLoginVC new]];

                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
        }];
        
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:isValid];
    }
    
}

- (NSString *)isValidWithPwdStr:(NSString *)pwdStr  newPwdStr:(NSString *)newPwdStr commitPwdStr:(NSString *)commitPwdStr{
    
     if (pwdStr.length == 0){
        return @"请输入原始密码！";
    }
    else if (newPwdStr.length == 0){
        return @"请输入新密码！";
    }else if (commitPwdStr.length == 0){
        return @"请再次输入新密码！";
    }else if (![commitPwdStr isEqualToString:newPwdStr]){
        return @"两次输入的密码不一致！";
    }
    return nil;
}

#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 20 && range.length!=1){
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    
    return YES;
}
@end
