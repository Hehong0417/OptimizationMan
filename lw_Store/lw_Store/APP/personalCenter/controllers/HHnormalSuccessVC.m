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
    
    self.title_label.text = self.title_label_str;
    if (self.discrib_str.length > 0) {
        self.discrib_label.text = [NSString stringWithFormat:@"恭喜你，正式成为%@商...",self.discrib_str];
    }
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backBtnAction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KPersonCter_Refresh_Notification object:nil];
    if (self.enter_Num ==1) {
        if (self.backBlock) {
            self.backBlock();
        }
        [self.navigationController popVC];

    }else{
        [self.navigationController popToRootVC];
    }
    
}
- (IBAction)backAction:(UIButton *)sender {
    
    [self backBtnAction];
}



@end
