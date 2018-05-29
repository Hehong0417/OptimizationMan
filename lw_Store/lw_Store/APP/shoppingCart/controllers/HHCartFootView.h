//
//  HHCartFootView.h
//  Store
//
//  Created by User on 2017/12/30.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHCartFootView : UIView

@property (weak, nonatomic) IBOutlet UILabel *settleBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *money_totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *sintegral_totalLabel;

@property (nonatomic, strong) idBlock allChooseBlock;

@end
