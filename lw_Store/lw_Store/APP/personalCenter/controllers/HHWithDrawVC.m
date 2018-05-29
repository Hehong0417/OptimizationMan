//
//  HHWithDrawVC.m
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWithDrawVC.h"
#import "HHCommissionWithdrawalVC.h"

@interface HHWithDrawVC ()
@property (strong, nonatomic)  HHMineModel *model;
@end

@implementation HHWithDrawVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";
    
    self.canWithdrawTf.leftViewMode = UITextFieldViewModeAlways;
    self.canWithdrawTf.font = FONT(22);
    self.canWithdrawTf.leftView = [UILabel lh_labelWithFrame:CGRectMake(0, 0, 41, 41) text:@"¥" textColor:kWhiteColor font:FONT(22) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    
    self.canWithdrawTf2.font = FONT(22);
    self.canWithdrawTf2.leftViewMode = UITextFieldViewModeAlways;
    self.canWithdrawTf2.leftView = [UILabel lh_labelWithFrame:CGRectMake(0, 0, 41, 41) text:@"¥" textColor:kBlackColor font:FONT(22) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    
}
-(void)getDatas{
    
    [[[HHMineAPI GetUserApplyMessage] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            
            if (api.State == 1) {
                HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.Data];
                self.model = model;
                self.canWithdrawTf.text = model.MaxBalance;
                self.canWithdrawTf2.text = model.HadBalance;
                if ([model.IsBusiness isEqualToString:@"1"]) {
                    if ([model.IsExistApply isEqualToString:@"1"]) {
                        [self.withDrawBtn setTitle:[NSString stringWithFormat:@"有¥%@提现申请中...",model.ApplyMoney] forState:UIControlStateNormal];
                        self.withDrawBtn.userInteractionEnabled = NO;
                    }else{
                        
                        if (model.MaxBalance.floatValue<model.MinBalance.floatValue) {
                            [self.withDrawBtn setTitle:[NSString stringWithFormat:@"可提现金额不能小于¥%@",model.MinBalance] forState:UIControlStateNormal];
                            self.withDrawBtn.userInteractionEnabled = NO;
                        }else{
                            [self.withDrawBtn setTitle:@"申请提现" forState:UIControlStateNormal];
                            self.withDrawBtn.userInteractionEnabled = YES;
                        }
                    }
                }else{
                    [self.withDrawBtn setTitle:@"成为消费商之后才能提现" forState:UIControlStateNormal];
                    self.withDrawBtn.userInteractionEnabled = NO;

                }
             
   
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
        
    }];
}
- (IBAction)withDrawAction:(UIButton *)sender {
    
    HHCommissionWithdrawalVC *vc = [HHCommissionWithdrawalVC new];
    vc.model = self.model;
    [self.navigationController pushVC:vc];
    
}
@end
