//
//  HHAboutUsVC.m
//  lw_Store
//
//  Created by User on 2018/5/27.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAboutUsVC.h"

@interface HHAboutUsVC ()

@end

@implementation HHAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    UIImageView *logo_imgv = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 40, ScreenW, 100) image:[UIImage imageNamed:@"you_logo"]];
    logo_imgv.contentMode = UIViewContentModeCenter;
    [self.view addSubview:logo_imgv];
    
    UILabel *versionLab = [UILabel lh_labelAdaptionWithFrame:CGRectMake(0, CGRectGetMaxY(logo_imgv.frame), ScreenW, 30) text:[NSString stringWithFormat:@"优选君v%@",kAppCurrentVersion] textColor:KACLabelColor font:FONT(14) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:versionLab];
    
    UILabel *copyrightLab = [UILabel lh_labelAdaptionWithFrame:CGRectMake(0, ScreenH-64-50, ScreenW, 30) text:@"Copyright©️力沃科技 版权所有" textColor:KACLabelColor font:FONT(13) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:copyrightLab];

}


@end
