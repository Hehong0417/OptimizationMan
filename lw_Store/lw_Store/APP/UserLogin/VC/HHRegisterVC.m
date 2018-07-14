//
//  HXRegisterVC.m
//  mengyaProject
//
//  Created by n on 2017/6/23.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HHRegisterVC.h"
#import "HHTextfieldcell.h"
#import "LHVerifyCodeButton.h"


@interface HHRegisterVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong) NSArray *inputArr;


@property(nonatomic,strong) NSArray *placeHolderArr;

@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong)NSString *verifyCode;

@end

@implementation HHRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.tableView.backgroundColor  = KVCBackGroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    self.inputArr = @[@"姓名",@"手机号",@"验证码",@"密码",@"确认密码"];
    self.placeHolderArr = @[@"请输入用户名",@"请输入手机号码",@"请输入验证码",@"请输入密码",@"请确认密码"];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) backColor:kClearColor];
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(registerAction) backgroundImage:nil title:@"注册" titleColor:kWhiteColor font:FONT(17)];
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];

    [footView addSubview:finishBtn];
    
    self.tableView.tableFooterView = footView;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    
    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inputTextField.placeholder = self.placeHolderArr[indexPath.row];
    cell.titleLabel.text = self.inputArr[indexPath.row];
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#5F5F5F"];
    if (indexPath.row == 0) {
        //用户名
        cell.inputTextField.secureTextEntry = NO;
        cell.inputTextField.delegate = self;
    }
    if (indexPath.row == 1) {
//        cell.inputTextField.text = @"13826424459";
        cell.inputTextField.secureTextEntry = NO;
        cell.inputTextField.delegate = self;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }else if (indexPath.row == 2){
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, WidthScaleSize_H(50))];
        
        self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(0, 0, WidthScaleSize_W(100), WidthScaleSize_H(30))];
        [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [self.verifyCodeBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
        [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        [self.verifyCodeBtn setTitle:@"点击发送验证码" forState:UIControlStateNormal];
        [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.verifyCodeBtn.centerY = view.centerY;
        self.verifyCodeBtn.titleLabel.font = FONT(13);
        [view addSubview:self.verifyCodeBtn];
        
        cell.inputTextField.rightView = view;
        cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputTextField.secureTextEntry = NO;
        
    }else if (indexPath.row == 3){
        
        cell.inputTextField.secureTextEntry = YES;
//        cell.inputTextField.text = @"123456";
        
    }else if (indexPath.row == 4){
        
//        cell.inputTextField.text = @"123456";
        cell.inputTextField.secureTextEntry = YES;
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WidthScaleSize_H(50);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.inputArr.count;
    
}
#pragma mark- 注册

- (void)registerAction {
    
    HHTextfieldcell *cell1 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *phoneStr = cell1.inputTextField.text;
    
    HHTextfieldcell *cell2 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *verifyCodeStr = cell2.inputTextField.text;
    
    HHTextfieldcell *cell3 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *newPwdStr = cell3.inputTextField.text;
    
    HHTextfieldcell *cell4 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *commitPwdStr = cell4.inputTextField.text;
    
    NSString *isValid =  [self isValidWithphoneStr:phoneStr verifyCodeStr:verifyCodeStr newPwdStr:newPwdStr commitPwdStr:commitPwdStr];
    
    if (!isValid) {
        
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        
        [SVProgressHUD showInfoWithStatus:isValid];
    }
    

}
- (void)loginSuccessWithPhonstr:(NSString *)phoneStr{
    

}

//获取验证码
- (void)sendVerifyCode {
    
    //判断手机号是否填写--手机号是否存在
    [self checkPhoneOnly];

}

#pragma mark-手机号唯一性验证
- (void)checkPhoneOnly
{
    HHTextfieldcell *cell1 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell1.inputTextField.text.length == 0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        
        
        [SVProgressHUD showInfoWithStatus:@"请先填写手机号"];
    }else{
        //判断是否为有效的手机号
        BOOL isvalidPhone = [NSString valiMobile:cell1.inputTextField.text];
        
        if (!isvalidPhone) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        }else {
            [self.verifyCodeBtn startTimer:60];
        
        }
        
    }
}
#pragma mark-发送验证码请求

- (void)sendverifyCodeRequest:(NSString *)phoneNum
{

}

- (NSString *)isValidWithphoneStr:(NSString *)phoneStr verifyCodeStr:(NSString *)verifyCodeStr  newPwdStr:(NSString *)newPwdStr commitPwdStr:(NSString *)commitPwdStr{
    
    if (phoneStr.length == 0) {
        return @"请输入手机号！";
    }else if (verifyCodeStr.length == 0){
        return @"请输入验证码！";
    }else if (![verifyCodeStr isEqualToString:self.verifyCode]){
        return @"验证码输入不正确！";
    }else if (newPwdStr.length == 0){
        return @"请输入密码！";
    }else if (commitPwdStr.length == 0){
        return @"请输入确认密码！";
    }else if (![commitPwdStr isEqualToString:newPwdStr]){
        return @"两次输入的密码不一致！";
    }
    return nil;
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

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

@end
