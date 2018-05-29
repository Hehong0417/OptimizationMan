//
//  HHBargainingVC.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBargainingVC.h"
#import "HHBargainingRecordVC.h"
#import "HHBroughtGiftResultVC.h"

@interface HHBargainingVC ()
@property (weak, nonatomic) IBOutlet UILabel *vc_title;


@end

@implementation HHBargainingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.vcType == bargaining_vcType) {
        self.title = @"砍价";
        self.howToPlayBtn.hidden = NO;
        self.deseBtn.hidden = YES;
        self.bargainingBtn.hidden = NO;
        self.rightBargainingBtn.hidden = NO;

    }else{
        self.title = @"送礼";
        self.howToPlayBtn.hidden = YES;
        self.deseBtn.hidden = NO;
        self.bargainingBtn.hidden = YES;
        self.rightBargainingBtn.hidden = YES;
    }
    [self.howToPlayBtn lh_setCornerRadius:self.howToPlayBtn.mj_h/2 borderWidth:0 borderColor:nil];
    [self.bg_view lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.bargainingBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.rightBargainingBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.deseBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
    [self.deseBtn addTarget:self action:@selector(deseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
//砍价
- (IBAction)leftBtnAction:(UIButton *)sender {
    
    HHBargainingRecordVC *vc = [HHBargainingRecordVC new];
    [self.navigationController pushVC:vc];
    
}
//朋友砍
- (IBAction)rightBtnAction:(UIButton *)sender {
    
    HHBroughtGiftResultVC *vc = [HHBroughtGiftResultVC new];
    [self.navigationController pushVC:vc];
    
}
//怎么玩
- (IBAction)howToplayAction:(UIButton *)sender {
    
}
//开始嘚瑟
-(void)deseBtnAction:(UIButton *)btn{
    
    
    
}
@end
