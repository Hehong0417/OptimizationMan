//
//  HHSelectChannelAlertView.m
//  Store
//
//  Created by User on 2018/3/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSelectChannelAlertView.h"

@implementation HHSelectChannelAlertView

- (UIView *)alertViewContentView{
    
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, ScreenW-120, 210)];
    alertView.backgroundColor = kWhiteColor;
    [alertView lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
    CGFloat height = 35;
    CGFloat width = (ScreenW - 120 - 60)/2;

    self.close_btn = [UIButton lh_buttonWithFrame:CGRectMake(ScreenW-120-40, 0, 40, 40) target:self action:@selector(close_btnAction:) image:[UIImage imageNamed:@"icon_close_default"]];
    [alertView addSubview:self.close_btn ];
    
    //title
    
    UILabel *titleLabel = [UILabel lh_labelWithFrame:CGRectMake(40, 15, ScreenW-120-80, 35) text:@"选择支付方式" textColor:kBlackColor font:FONT(16) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    [alertView addSubview:titleLabel];

    
    for (NSInteger i = 0; i<2; i++) {
        XYQButton *headquartersbtn = [XYQButton ButtonWithFrame:CGRectMake(30,i*height+CGRectGetMaxY(titleLabel.frame)+10, width, height) imgaeName:@"icon_sign_default" titleName:i?@"  微信 ":@"  支付宝" contentType:LeftImageRightTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:KACLabelColor fontsize:AdapationLabelHeight(16)] tapAction:nil];
        [headquartersbtn addTarget:self action:@selector(headquartersbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headquartersbtn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
        headquartersbtn.tag = 10000+i;
        if (i==0) {
            [self headquartersbtnAction:headquartersbtn];
        }
        [alertView addSubview:headquartersbtn];
    }
    alertView.centerY = (ScreenH - Status_HEIGHT-44)/2;

    UIButton *commit_btn = [UIButton lh_buttonWithFrame:CGRectMake(30, 155, ScreenW-120-60, 35) target:self action:@selector(commit_btnAction:) image:nil title:@"确认" titleColor:kWhiteColor font:FONT(15)];
    [commit_btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    commit_btn.backgroundColor = APP_Deep_purple_Color;;
    [alertView addSubview:commit_btn];
    
    return alertView;
}
- (void)headquartersbtnAction:(UIButton *)btn{
    self.currentSelectBtn.selected = NO;
    btn.selected = YES;
    
    if ([btn.titleLabel.text containsString:@"支付宝"]) {
        self.channel = @"1";
    }else if ([btn.titleLabel.text containsString:@"微信"]){
        self.channel = @"0";
    }
    self.currentSelectBtn = btn;
}
//gua
- (void)close_btnAction:(UIButton *)btn{
    
    [self hideWithCompletion:nil];
}
//确认
- (void)commit_btnAction:(UIButton *)btn{
    
    btn.userInteractionEnabled = NO;
    if(self.commitBlock){
        self.commitBlock(self.channel);
    }
   
}
@end
