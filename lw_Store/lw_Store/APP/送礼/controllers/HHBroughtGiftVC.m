//
//  HHBroughtGiftVC.m
//  lw_Store
//
//  Created by User on 2018/5/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBroughtGiftVC.h"

@interface HHBroughtGiftVC ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *getGiftBtn;

@end

@implementation HHBroughtGiftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"送礼";

    [self.iconView lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
    [self.getGiftBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
}


@end
