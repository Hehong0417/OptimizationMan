//
//  HHCommissionWithdrawalVC.h
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHCommissionWithdrawalVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *desCribLabel;
@property (weak, nonatomic) IBOutlet UITextField *money_tf;
@property (strong, nonatomic) HHMineModel *model;


@end
