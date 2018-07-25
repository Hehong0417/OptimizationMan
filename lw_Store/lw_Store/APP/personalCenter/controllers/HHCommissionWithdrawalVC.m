//
//  HHCommissionWithdrawalVC.m
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCommissionWithdrawalVC.h"
#import "HHWithDrawVC.h"

@interface HHCommissionWithdrawalVC ()

@end

@implementation HHCommissionWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"佣金提现申请";
    
    self.desCribLabel.text = [NSString stringWithFormat:@"提示：您此次可提现的最大金额为%@元",self.model.MaxBalance];
    
    [self.withDrawBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];

}
- (IBAction)commitWithdrawAction:(UIButton *)sender {
    
    if (self.money_tf.text.floatValue>=self.model.MinBalance.floatValue) {
        
        [[[HHMineAPI postCommissionApplyWithCommission:self.money_tf.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"提现申请成功"];
                    [self.navigationController popVC];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }];
    }else if(self.money_tf.text.floatValue>self.model.MaxBalance.floatValue){
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"提现金额不能大于¥%@",self.model.MaxBalance]];

    }else{
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"提现金额不能小于¥%@",self.model.MinBalance]];
    }
    
}



@end
