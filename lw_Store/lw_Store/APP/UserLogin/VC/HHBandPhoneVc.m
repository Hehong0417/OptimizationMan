//
//  HHBandPhoneVc.m
//  CredictCard
//
//  Created by User on 2017/12/21.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHBandPhoneVc.h"
#import "LHVerifyCodeButton.h"

@interface HHBandPhoneVc ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField  *tF;
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;

@end

@implementation HHBandPhoneVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleStr;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.tableView];
    
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(saveAction) backgroundImage:nil title:@"保存"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableView.tableFooterView = footView;
    
}
- (void)saveAction{
    //绑定手机号
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *phoneTf = cell.contentView.subviews[0];
    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *codeTf =  cell1.contentView.subviews[0];;
    if (phoneTf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号"];
    }else  if (codeTf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写验证码"];
    }else{
//        [[[HHPerCenterDataAPI postEditUserPhoneWithPhone:phoneTf.text code:codeTf.text] netWorkClient] postRequestInView:nil finishedBlock:^(HHPerCenterDataAPI *api, NSError *error) {
//
//            if (!error) {
//
//                if (api.code == 0) {
//
//                    kKeyWindow.rootViewController = [[HJTabBarController alloc] init];
//
//                }else {
//                    if ([api.msg isEqualToString:@"短信验证码不存在"]) {
//
//                        [SVProgressHUD showInfoWithStatus:@"验证码不正确"];
//                    }else{
//                        [SVProgressHUD showInfoWithStatus:api.msg];
//                    }
//
//                }
//
//            }else{
//
//                if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
//                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//                    [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了"];
//
//                }
//            }
//
//        }];
        
    }
    
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 11 && range.length!=1){
        textField.text = [toBeString substringToIndex:11];
        return NO;
    }
    
    return YES;
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        NSArray *placeholders = @[@"请输入手机号",@"请输入验证码"];
        tF = [UITextField lh_textFieldWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, WidthScaleSize_H(50)) placeholder:placeholders[indexPath.row] font:FONT(14)  textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        tF.keyboardType = UIKeyboardTypeNumberPad;
        tF.tag = indexPath.row;
        [cell.contentView addSubview:tF];
        
        if (indexPath.row == 1) {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WidthScaleSize_W(110), WidthScaleSize_H(50))];
            self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(0, 0, WidthScaleSize_W(110), WidthScaleSize_H(30))];
            [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
            [self.verifyCodeBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
            [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
            [self.verifyCodeBtn setTitle:@"点击发送验证码" forState:UIControlStateNormal];
            [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            self.verifyCodeBtn.centerY = view.centerY;
            self.verifyCodeBtn.titleLabel.font = FONT(14);
            [view addSubview:self.verifyCodeBtn];
            tF.rightView = view;
            tF.rightViewMode = UITextFieldViewModeAlways;
            tF.secureTextEntry = NO;
            
        }
        
    }
    tF.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WidthScaleSize_H(50);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
- (void)sendVerifyCode{
    
     //发送验证码
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *phoneTf = cell.contentView.subviews[0];
    if (phoneTf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号"];
    }else{
        //验证手机号
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
      BOOL  isValid =  [NSString valiMobile:phoneTf.text];
        if (isValid) {
        self.verifyCodeBtn.enabled = NO;
//        [[[HHUserLoginAPI postSendCodeWithPhone:phoneTf.text] netWorkClient] postRequestInView:nil finishedBlock:^(HHUserLoginAPI *api, NSError *error) {
//            self.verifyCodeBtn.enabled = YES;
//            if (!error) {
//
//                if (api.code == 0) {
//
//                    [self.verifyCodeBtn startTimer:60];
//                }
//
//            }else{
//
//                [SVProgressHUD showInfoWithStatus:api.msg];
//
//            }
//
//        }];
        }else{
            
            [SVProgressHUD showInfoWithStatus:@"请填写正确的手机号"];

        }
        
    }
    
}


@end
