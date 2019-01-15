//
//  HHSendIntegralVC.m
//  springDream
//
//  Created by User on 2018/9/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSendIntegralVC.h"

@interface HHSendIntegralVC ()
{
    UITextField *_send_Id_textField;
    UITextField *_send_integral_textfield;
}
@end

@implementation HHSendIntegralVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"赠送积分";
    self.view.backgroundColor = kWhiteColor;
    
    UILabel *send_Id_label = [UILabel lh_labelWithFrame:CGRectMake(25, 35, 90, 35) text:@"赠送会员ID" textColor:KTitleLabelColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.view addSubview:send_Id_label];
    
    _send_Id_textField = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(send_Id_label.frame)+5,send_Id_label.mj_y, ScreenW-CGRectGetMaxX(send_Id_label.frame)-30, 35) placeholder:@"" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    _send_Id_textField.leftView = [UIView lh_viewWithFrame:CGRectMake(0, 0, 5, 35) backColor:kWhiteColor];
    _send_Id_textField.leftViewMode = UITextFieldViewModeAlways;
    
    _send_Id_textField.keyboardType = UIKeyboardTypeNumberPad;
    [_send_Id_textField lh_setCornerRadius:4 borderWidth:1 borderColor:LineLightColor];
    [self.view addSubview:_send_Id_textField];
    
    UILabel *send_integral_label = [UILabel lh_labelWithFrame:CGRectMake(25, CGRectGetMaxY(send_Id_label.frame)+15, 90, 35) text:@"赠送积分数" textColor:KTitleLabelColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.view addSubview:send_integral_label];

    _send_integral_textfield = [UITextField lh_textFieldWithFrame:CGRectMake(CGRectGetMaxX(send_integral_label.frame)+5,send_integral_label.mj_y, ScreenW-CGRectGetMaxX(send_integral_label.frame)-30, 35) placeholder:@"" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [_send_integral_textfield lh_setCornerRadius:4 borderWidth:1 borderColor:LineLightColor];
    _send_integral_textfield.keyboardType = UIKeyboardTypeNumberPad;
    
    _send_integral_textfield.leftView = [UIView lh_viewWithFrame:CGRectMake(0, 0, 5, 35) backColor:kWhiteColor];
    _send_integral_textfield.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_send_integral_textfield];
    
    UIButton *commit_button = [UIButton lh_buttonWithFrame:CGRectMake(15, CGRectGetMaxY(send_integral_label.frame)+45, ScreenW-30, 40) target:self action:@selector(commitSendAction:) image:nil title:@"确定配送" titleColor:kWhiteColor font:FONT(15)];
    [commit_button setBackgroundColor:APP_BUTTON_COMMON_COLOR];
    [self.view addSubview:commit_button];
    
    [commit_button lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
}
- (void)commitSendAction:(UIButton *)button{
    
    if (_send_Id_textField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请先输入赠送的会员ID！"];
    }else if (_send_integral_textfield.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请先输入赠送的积分数！"];
    }else{
        button.enabled = NO;
        [[[HHMineAPI postGiveAwayPointsWithgetUserId:_send_Id_textField.text points:_send_integral_textfield.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        button.enabled = YES;
            if (!error) {
                if (api.State == 1) {
                    if (self.completeBlock) {
                        self.completeBlock();
                    }
                    [SVProgressHUD showSuccessWithStatus:@"赠送成功！"];
                    [self.navigationController popVC];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
            
        }];
        
    }
}
@end
