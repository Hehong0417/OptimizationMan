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
    
    HJUser *user = [HJUser sharedUser];
    user.token = nil;
    [user write];
    self.title = @"绑定手机号";
    
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
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(saveAction) backgroundImage:nil title:@"确认"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_BUTTON_COMMON_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableView.tableFooterView = footView;
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    HJUser *user = [HJUser sharedUser];
    user.token = nil;
    [user write];
        [self.navigationController popVC];
}
//绑定手机号
- (void)saveAction{

    HJUser *user = [HJUser sharedUser];
    user.token = self.token;
    [user write];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *phoneTf = cell.contentView.subviews[0];
    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *codeTf =  cell1.contentView.subviews[0];
    UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *pswTf =  cell2.contentView.subviews[0];
    if (phoneTf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号"];
    }else  if (codeTf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写验证码"];
    }else  if (pswTf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写验证码"];
    }else{
        [[[HHMineAPI postBindMobile:phoneTf.text smsCode:codeTf.text Password:pswTf.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if(!error){
                if(api.State == 1){
                    kKeyWindow.rootViewController = [[HJTabBarController alloc] init];
                }else{
                    [self lh_showHudInView:self.view labText:api.Msg];
                }
            }else{
                [self lh_showHudInView:self.view labText:error.localizedDescription];
            }
            
        }];
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
        NSArray *placeholders = @[@"请输入手机号",@"请输入验证码",@"请设置密码"];
        tF = [UITextField lh_textFieldWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, AdapationLabelHeight(50)) placeholder:placeholders[indexPath.row] font:FONT(14)  textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        tF.keyboardType = UIKeyboardTypeNumberPad;
        if (indexPath.row ==2) {
            tF.keyboardType = UIKeyboardTypeASCIICapable;
        }
        tF.tag = indexPath.row;
        [cell.contentView addSubview:tF];
        
        if (indexPath.row == 1) {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AdapationLabelHeight(110), AdapationLabelHeight(50))];
            self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(0, 0, AdapationLabelHeight(110), AdapationLabelHeight(30))];
            [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
            [self.verifyCodeBtn lh_setBackgroundColor:APP_BUTTON_COMMON_COLOR forState:UIControlStateNormal];
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
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return AdapationLabelHeight(50);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
#pragma mark-发送验证码

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
            
            [[[HHMineAPI postSms_SendCodeWithmobile:phoneTf.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
               
                if(!error){
                    if(api.State == 1){
                        NSInteger expires = api.Expires.integerValue;
                        [self.verifyCodeBtn startTimer:expires];
                    }else{
                        [self lh_showHudInView:self.view labText:api.Msg];
                    }
                }else{
                    [self lh_showHudInView:self.view labText:error.localizedDescription];
                }
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请填写正确的手机号"];
        }
        
    }
    
}


@end
