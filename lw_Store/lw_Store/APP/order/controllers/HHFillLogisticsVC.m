//
//  HHIntegralTransferVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHFillLogisticsVC.h"
#import "HHTextfieldcell.h"

@interface HHFillLogisticsVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSArray *placeHoder_arr;
@property (nonatomic, strong)   HHMineModel *mineModel;
@property (nonatomic, strong)   HXCommonPickView *pickView;
@property (nonatomic, strong)   NSMutableArray *courierName_Arr;
@property (nonatomic, strong)   NSMutableArray *courierCode_Arr;
@property (nonatomic, strong)   NSString *choose_code;

@end

@implementation HHFillLogisticsVC

- (NSMutableArray *)courierCode_Arr{
    if (!_courierCode_Arr) {
        _courierCode_Arr = [NSMutableArray array];
    }
    return _courierCode_Arr;
}

- (NSMutableArray *)courierName_Arr{
    if (!_courierName_Arr) {
        _courierName_Arr = [NSMutableArray array];
    }
    return _courierName_Arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写退货物流";
    
    self.title_arr = @[@"快递公司",@"快递单号"];
    self.placeHoder_arr = @[@"  点击此处选择快递公司",@"  点击此处输入快递单号"];

    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) backColor:kWhiteColor];
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    
    self.tableView.tableFooterView = footView;
    
    //物流编号
    self.choose_code = self.return_goods_express_code;

    
    [self getDatas];
    
    self.pickView = [[HXCommonPickView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    WEAK_SELF();
    self.pickView.completeBlock = ^(NSString *result) {
      NSInteger index = [weakSelf.courierName_Arr indexOfObject:result];
        HHTextfieldcell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.inputTextField.text = result;
        weakSelf.choose_code = weakSelf.courierCode_Arr[index];
    };
    
}
//获取快递列表
- (void)getDatas{
    
    [[[HHMineAPI GetExpressCompany] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *courier_arr = [HHMineModel  mj_objectArrayWithKeyValuesArray:api.Data];
                
                [courier_arr enumerateObjectsUsingBlock:^(HHMineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.courierName_Arr addObject:model.express_name];
                    [self.courierCode_Arr addObject:model.express_abb];
                    *stop = NO;
                }];
                [self.tableView reloadData];
            }
        }
    }];
    
}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *courierNumcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *courierNum  = courierNumcell.inputTextField.text;
    
    NSString *validStr = [self validWithcourier:self.choose_code courierNum:courierNum];
    if (!validStr) {
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
        btn.enabled = NO;
        
        [[[HHMineAPI postSubReturnGoodsExpressWithorderid:self.orderid exp_code:self.choose_code exp_order:courierNum] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
            btn.enabled = YES;

            if (!error) {
                if (api.State == 0) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                    if (self.return_numb_block) {
                        self.return_numb_block(@(self.sg_selectIndex));
                    }
                    [self.navigationController popVC];
                }else{

                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }

        }];
        
    }else{
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (NSString *)validWithcourier:(NSString *)courier courierNum:(NSString *)courierNum{
    
    if (courier.length == 0) {
        return @"请选择快递公司！";
    }else if (courierNum.length == 0) {
        return @"请输入快递单号！";
    }
    return nil;
}

#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 30 && range.length!=1){
        textField.text = [toBeString substringToIndex:50];
        return NO;
    }
    
    return YES;
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    
    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleLabel"];
    }
    cell.inputTextField.delegate = self;
    cell.inputTextField.tag = 100+indexPath.section;
    cell.inputTextField.placeholder = self.placeHoder_arr[indexPath.section];
    cell.titleLabel.text = self.title_arr[indexPath.section];
    [cell.inputTextField lh_setCornerRadius:5 borderWidth:1 borderColor:KVCBackGroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.inputTextField.userInteractionEnabled = NO;
        NSInteger index = [self.courierCode_Arr indexOfObject:self.return_goods_express_code];
        
        cell.inputTextField.text = [self.courierName_Arr objectAtIndex:index];
    }
     if (indexPath.section == 1) {
       cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
       cell.inputTextField.userInteractionEnabled = YES;
       cell.inputTextField.text = self.return_goods_express_order;
       cell.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
     }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选择快递公司
    if (self.courierName_Arr.count>0) {
        [self.pickView setStyle:HXCommonPickViewStyleDIY titleArr:self.courierName_Arr];
        [self.pickView showPickViewAnimation:YES];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WidthScaleSize_H(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}



@end

