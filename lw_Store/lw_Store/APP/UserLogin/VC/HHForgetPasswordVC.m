//
//  HHForgetPasswordVC.m
//  springDream
//
//  Created by User on 2018/10/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHForgetPasswordVC.h"

@interface HHForgetPasswordVC ()<UITextFieldDelegate>
{
    UIButton *_rigster_button;
    UITextField *_code_textfield;
    UITextField *_pw_textfield;
    UITextField *_cpw_textfield;
    UIButton *_protocol_btn;
}
@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;

@end

@implementation HHForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"忘记密码";
    self.view.backgroundColor = kWhiteColor;
    
    _code_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(AdapationLabelHeight(60), AdapationLabelHeight(40), ScreenW-2*AdapationLabelHeight(60), AdapationLabelHeight(30)) placeholder:@"请输入手机号" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _code_textfield.keyboardType = UIKeyboardTypeNumberPad;
    _code_textfield.delegate = self;
    [self.view addSubview:_code_textfield];
    
    UIView *h_line_1 = [UIView lh_viewWithFrame:CGRectMake(_code_textfield.mj_x,CGRectGetMaxY(_code_textfield.frame)+AdapationLabelHeight(8), ScreenW-2*AdapationLabelHeight(60), 1) backColor:LineLightColor];
    [self.view addSubview:h_line_1];
    
    _pw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(_code_textfield.mj_x, CGRectGetMaxY(h_line_1.frame)+AdapationLabelHeight(20),ScreenW-2*AdapationLabelHeight(60)-AdapationLabelHeight(100), AdapationLabelHeight(30)) placeholder:@"请输入验证码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _pw_textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_pw_textfield];
    
    UIView *h_line_2 = [UIView lh_viewWithFrame:CGRectMake(_pw_textfield.mj_x,CGRectGetMaxY(_pw_textfield.frame)+AdapationLabelHeight(8), ScreenW-2*AdapationLabelHeight(60), 1) backColor:LineLightColor];
    [self.view addSubview:h_line_2];
    
    self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(h_line_1.frame)-AdapationLabelHeight(15)-AdapationLabelHeight(100), CGRectGetMaxY(h_line_1.frame)+AdapationLabelHeight(10), AdapationLabelHeight(100), AdapationLabelHeight(30))];
    [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn lh_setBackgroundColor:APP_BUTTON_COMMON_COLOR forState:UIControlStateNormal];
    [self.verifyCodeBtn lh_setBackgroundColor:KDCLabelColor forState:UIControlStateSelected];
    [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.verifyCodeBtn.titleLabel.font = FONT(13);
    [self.view addSubview:self.verifyCodeBtn];

    
    _cpw_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(AdapationLabelHeight(60), CGRectGetMaxY(h_line_2.frame)+AdapationLabelHeight(20), ScreenW-2*AdapationLabelHeight(60), AdapationLabelHeight(30)) placeholder:@"请输入新密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
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
    
    _rigster_button = [UIButton lh_buttonWithFrame:CGRectMake(AdapationLabelHeight(60), CGRectGetMaxY(h_line_3.frame)+AdapationLabelHeight(35), ScreenW-2*AdapationLabelHeight(60), AdapationLabelHeight(40)) target:self action:@selector(forgetAction:) title:@"重置密码" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_BUTTON_COMMON_COLOR];
    [_rigster_button lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:_rigster_button];
    
}
- (void)forgetAction:(UIButton *)button{
    
    NSString *isValid =  [self isValidWithPhoneStr:_code_textfield.text v_codeStr:_pw_textfield.text pwdStr:_cpw_textfield.text];
    NSString *phone_str = _code_textfield.text;
    NSString *verification_str = _pw_textfield.text;
    NSString *password_str = _cpw_textfield.text;

    if (!isValid) {
        
                 [[[HHMineAPI postForgetPassWordWithmobile:phone_str newPassWord:password_str smsCode:verification_str] netWorkClient] postRequestInView:self.view finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
                    if (!error) {
                        if (api.State == 1) {
                            
                            [self.navigationController popVC];
                            [SVProgressHUD showSuccessWithStatus:@"重置密码成功，请重新登录！"];
        
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

- (NSString *)isValidWithPhoneStr:(NSString *)phoneStr  v_codeStr:(NSString *)v_codeStr pwdStr:(NSString *)pwdStr{
    
    if (phoneStr.length == 0){
        return @"请输入手机号！";
    } else if (v_codeStr.length == 0){
        return @"请输入验证码！";
    }else if (pwdStr.length == 0){
        return @"请输入新密码！";
    }
    return nil;
}

#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _code_textfield) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    if (textField == _code_textfield||textField == _cpw_textfield) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 20 && range.length!=1){
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    
    return YES;
}
- (void)sendVerifyCode:(LHVerifyCodeButton *)button{
    if (_code_textfield.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请先填写手机号"];
    }else{
        [[[HHMineAPI postSms_SendCodeWithmobile:_code_textfield.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    NSInteger expires = api.Expires.integerValue;
                    [self.verifyCodeBtn startTimer:expires];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }
        }];
    }
}
@end
