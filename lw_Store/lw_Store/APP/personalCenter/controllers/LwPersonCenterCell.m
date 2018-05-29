//
//  LwPersonCenterCell.m
//  lw_Store
//
//  Created by User on 2018/4/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import "LwPersonCenterCell.h"
#import "HHWithDrawVC.h"
#import "HHFansListVC.h"

@implementation LwPersonCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
    }
    return self;
}
- (void)setCellWithUsableComm:(NSString *)usableComm fanscount:(NSString *)fanscount saletotal:(NSString *)saletotal{
    
    self.section1  = [HHPersonCenterView personViewWithFrame:CGRectMake(0, 0, ScreenW/3, WidthScaleSize_H(70)) btn_imageName:@"tab_icon_home_default" btn_titleName:@"奖励" lab_titleName:[NSString stringWithFormat:@"%@元",usableComm?usableComm:@"0"]];
    [self.contentView addSubview:self.section1];
    UIView *line1 = [UIView lh_viewWithFrame:CGRectMake(ScreenW/3, WidthScaleSize_H(70)/2, 1, WidthScaleSize_H(70)/3) backColor:KVCBackGroundColor];
    line1.centerY = self.section1.centerY;
    
    [self.contentView addSubview:line1];
    
    self.section2  = [HHPersonCenterView personViewWithFrame:CGRectMake(ScreenW/3+1, 0, ScreenW/3, WidthScaleSize_H(70)) btn_imageName:@"tab_icon_shop_default" btn_titleName:@"粉丝" lab_titleName:[NSString stringWithFormat:@"%@人",fanscount?fanscount:@"0"]];
    [self.contentView addSubview:self.section2];
    UIView *line2 = [UIView lh_viewWithFrame:CGRectMake(ScreenW*2/3, WidthScaleSize_H(70)/2-20, 1, WidthScaleSize_H(70)/3) backColor:KVCBackGroundColor];
    line2.centerY = self.section2.centerY;
    
    [self.contentView addSubview:line2];
    
    self.section3  = [HHPersonCenterView personViewWithFrame:CGRectMake(ScreenW*2/3+1, 0, ScreenW/3-1, WidthScaleSize_H(70)) btn_imageName:@"tab_icon_user_default" btn_titleName:@"销售额" lab_titleName:[NSString stringWithFormat:@"%@元",saletotal?saletotal:@"0"]];
    [self.contentView addSubview:self.section3];
    
    self.section1.userInteractionEnabled = YES;
    self.section2.userInteractionEnabled = YES;
    self.section3.userInteractionEnabled = YES;
    WEAK_SELF();
    [self.section1 setTapActionWithBlock:^{
        HHWithDrawVC *vc = [HHWithDrawVC new];
        [weakSelf.nav pushVC:vc];
    }];
    [self.section2 setTapActionWithBlock:^{
        HHFansListVC *vc = [HHFansListVC new];
        [weakSelf.nav pushVC:vc];
    }];
    [self.section3 setTapActionWithBlock:^{
       
    }];
}

@end
