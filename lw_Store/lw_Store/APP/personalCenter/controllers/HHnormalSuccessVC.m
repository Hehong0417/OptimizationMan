//
//  HHnormalSuccessVC.m
//  lw_Store
//
//  Created by User on 2018/5/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHnormalSuccessVC.h"

@interface HHnormalSuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *discrib_label;
@end

@implementation HHnormalSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.title_str;

    [self.back_btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
}
- (IBAction)backAction:(UIButton *)sender {
    
    
    
}



@end
