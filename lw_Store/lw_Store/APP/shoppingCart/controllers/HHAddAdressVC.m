//
//  HHAddAdressVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHAddAdressVC.h"
#import "HHTextfieldcell.h"
#import "GFAddressPicker.h"
#import "HHSubmitOrdersVC.h"

@interface HHAddAdressVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSArray *placeHolder_arr;
@property (nonatomic, strong)    GFAddressPicker *addressPick;
@property (nonatomic, strong)    NSString *address_Str;
@property (nonatomic, strong)    UISwitch *swi;
@property (nonatomic, assign)    BOOL isOn;

@property (nonatomic, strong)   NSString *username;

@property (nonatomic, strong)   NSString *mobile;

@property (nonatomic, strong)   NSString *district_id;

@property (nonatomic, strong)   NSString *address;

@end

@implementation HHAddAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
        
    //获取数据
    if (self.addressType == HHAddress_editType) {
        [self getDatas];
    }
    self.title_arr = @[@"*  收货人：",@"*  手机号码：",@"*  所在地区",@"*  详细地址："];
    self.placeHolder_arr = @[@"请使用真实姓名",@"点击编辑手机号码",@"点击选择所在地区",@"点击编辑详细地址"];
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;

    [self.view addSubview:self.tableView];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:KVCBackGroundColor];
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    self.tableView.tableFooterView = footView;

}

- (void)getDatas{
    
    [[[HHMineAPI GetAddressWithId:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
        
                HHMineModel *model =  [HHMineModel mj_objectWithKeyValues:api.Data];
                if (model.RegionId) {
                    self.district_id = model.RegionId;
                }else if (model.CityId){
                    self.district_id = model.CityId;
                }else{
                    self.district_id = model.AddrId;
                }
                  self.username = model.Recipient;
                  self.mobile = model.Moble;
                //详细地址
                  self.address = model.Address;
                //选择的地址
                self.address_Str = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.region];
                if ([model.IsDefault isEqualToString:@"1"]) {
                    self.isOn = YES;
                }else{
                    self.isOn = NO;
                }
                [self.tableView reloadData];
            }
            
        }
    }];
    
}
- (void)saveBtnAction{
    
    HHTextfieldcell *usernameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *usernameStr = usernameCell.inputTextField.text;
    HHTextfieldcell *mobileCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *mobileStr = mobileCell.inputTextField.text;
    
    HHTextfieldcell *addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *addressStr = addressCell.inputTextField.text;
    
    NSString *validStr = [self validWithusername:usernameStr mobile:mobileStr district_id:self.district_id address:addressStr];
    if (!validStr) {
        
      if (self.addressType == HHAddress_editType){
           
            [[ [HHMineAPI  postEditAddressWithId:self.Id district_id:self.district_id address:addressStr username:usernameStr mobile:mobileStr is_default:[NSString stringWithFormat:@"%d",self.swi.isOn]] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                if (!error) {
                    if (api.State == 1) {
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"编辑成功！"];
                        [self.navigationController popVC];
                    }else{
                        
                        [SVProgressHUD showInfoWithStatus:api.Msg];
                    }
                }
            }];
            
      }else {
          
          [[[HHMineAPI postAddAddressWithdistrict_id:self.district_id address:addressStr username:usernameStr mobile:mobileStr is_default:[NSString stringWithFormat:@"%d",self.swi.isOn]] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
              if (!error) {
                  if (api.State == 1) {
                      if (self.addressType == HHAddress_addType) {
                          [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                          [SVProgressHUD showSuccessWithStatus:@"添加成功!"];
                          [self.navigationController popVC];
                          
                      }else if(self.addressType == HHAddress_settlementType_cart){
                          //提交订单页面
                          HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                          vc.cartIds_str = self.cartIds_str;
                          if ([self.sendGift isEqual:@1]) {
                              vc.enter_type = HHaddress_type_Spell_group;
                              vc.mode = @8;
                          }else{
                              vc.enter_type = HHaddress_type_add_cart;
                              vc.mode = nil;
                          }
                          vc.sendGift = self.sendGift;
                          [self.navigationController pushVC:vc];
                          
                      }else if (self.addressType == HHAddress_settlementType_productDetail){
                          
                          HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                          vc.enter_type = HHaddress_type_add_productDetail;
                          vc.mode = self.mode;
                          vc.ids_Str = self.ids_Str;
                          vc.cartIds_str = self.cartIds_str;
                          [self.navigationController pushVC:vc];
                      }
                      
                  }else{
                      
                      [SVProgressHUD showInfoWithStatus:api.Msg];
                  }
              }
          }];
      }
        
    }else{
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (NSString *)validWithusername:(NSString *)username mobile:(NSString *)mobile district_id:(NSString *)district_id address:(NSString *)address {
    
    if (username.length == 0) {
        return @"请填写姓名！";
    }else  if (mobile.length == 0) {
        return @"请填写手机号吗！";
    }else  if (district_id.length == 0) {
        return @"请选择所在地区！";
    }else  if (address.length == 0) {
        return @"请填写详细地址！";
    }
    return nil;
    
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 10000) {
        if (toBeString.length > 15 && range.length!=1){
         //收货人姓名
            textField.text = [toBeString substringToIndex:15];
            return NO;
        }
    }else  if (textField.tag == 10001) {
        //手机号
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
  
    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    }
    cell.inputTextField.tag = indexPath.row+10000;
    if (indexPath.row == 0) {
        [NSString lh_attriStrWithprotocolStr:@"*" content:self.title_arr[indexPath.row] protocolStrColor:kRedColor contentColor:kBlackColor commonFont:FONT(14)];
        cell.inputTextField.text = self.username;
        cell.inputTextField.delegate = self;
    }else{
         [NSString lh_attriStrWithprotocolStr:@"*" content:self.title_arr[indexPath.row] protocolStrColor:kRedColor contentColor:kBlackColor commonFont:FONT(14)];
        if (indexPath.row == 1){
            cell.inputTextField.delegate = self;
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputTextField.text = self.mobile;
        }
     if (indexPath.row == 2){
         cell.inputTextField.enabled = NO;
         cell.inputTextField.text = self.address_Str;
        }
        if (indexPath.row == 3){
            cell.inputTextField.text = self.address;
        }
//    if (indexPath.row == 4) {
//        cell.titleLabel.frame = CGRectMake(15, 0, ScreenW - 60 - 22, 44);
//        cell.titleLabel.attributedText =  [NSString lh_attriStrWithprotocolStr:@"(注：每次下单时都会使用该地址)" content:@"设为默认地址(注：每次下单时都会使用该地址)" protocolFont:FONT(12) contentFont:FONT(14) protocolStrColor:KACLabelColor contentColor:kBlackColor];
//
//        self.swi = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 10, 60, 44)];
//        [self.swi setOn:self.isOn];
//        [cell.contentView addSubview:self.swi];
//      }
    }
    cell.inputTextField.placeholder = self.placeHolder_arr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
       
        self.addressPick = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.addressPick.font = [UIFont systemFontOfSize:WidthScaleSize_H(19)];
        [self.addressPick showPickViewAnimation:YES];
        WEAK_SELF();
        self.addressPick.completeBlock = ^(NSString *result, NSString *district_id) {
            weakSelf.district_id = district_id;
            weakSelf.address_Str = result;
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
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


@end
