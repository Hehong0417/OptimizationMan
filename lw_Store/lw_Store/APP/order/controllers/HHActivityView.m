//
//  HHActivityView.m
//  lw_Store
//
//  Created by User on 2019/1/9.
//  Copyright © 2019年 User. All rights reserved.
//

#import "HHActivityView.h"
#import "HHReceiveAlertView.h"

@implementation HHActivityView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp:frame];
    
    }
    return self;
}
- (void)setUp:(CGRect)frame{
    
    self.backgroundColor = kWhiteColor; ;
    self.titleLabel = [UILabel lh_labelWithFrame:CGRectMake(0, AdapationLabelHeight(10),ScreenW, AdapationLabelHeight(30)) text:@"本次支付获得" textColor:KTitleLabelColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    [self addSubview:self.titleLabel];
    
    self.contentImageView = [UIView lh_viewWithFrame:CGRectMake(35, CGRectGetMaxY(self.titleLabel.frame)+AdapationLabelHeight(8), ScreenW-70, frame.size.height-2*AdapationLabelHeight(10)-CGRectGetMaxY(self.titleLabel.frame)) backColor:kWhiteColor];
    [self.contentImageView lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self addSubview:self.contentImageView];
    UIImageView *imageV = [UIImageView lh_imageViewWithFrame:self.contentImageView.bounds image:[UIImage imageNamed:@"giftBgImg"]];
    [self.contentImageView addSubview:imageV];
    
    self.namelabel = [UILabel lh_labelWithFrame:CGRectMake(30, 0, self.contentImageView.mj_w-60, self.contentImageView.mj_h*2/3-10) text:nil textColor:kWhiteColor font:BoldFONT(30) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    [self.contentImageView  addSubview:self.namelabel];
    
    self.ReceiveButton = [UIButton lh_buttonWithFrame:CGRectMake(self.contentImageView.mj_w/2-60, CGRectGetMaxY(self.namelabel.frame), 120, self.contentImageView.mj_h/3-10) target:self action:@selector(ReceiveButtonAction:) title:@"立即领取" titleColor:RGB(255, 125, 152) font:FONT(14) backgroundColor:kWhiteColor];
    [self.ReceiveButton lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    [self.contentImageView  addSubview:self.ReceiveButton];
    
}
- (void)setGift_Model:(HHCategoryModel *)gift_Model{
    _gift_Model = gift_Model;
    self.namelabel.text = gift_Model.name;

}
- (void)ReceiveButtonAction:(UIButton *)button{
    
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    
    [[[HHCategoryAPI PostReceiveGiftWithgift_id:self.gift_Model.gift_id] netWorkClient] postRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                HHReceiveAlertView *reAlertView = [[HHReceiveAlertView alloc] init];
                [reAlertView showAnimated:NO];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
        
        
    }];
    
}
@end
