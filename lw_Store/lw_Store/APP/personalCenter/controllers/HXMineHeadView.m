

//
//  HXMineHeadView.m
//  mengyaProject
//
//  Created by n on 2017/6/16.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HXMineHeadView.h"
//#import "HXUserLoginVC.h"

@implementation HXMineHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        UIImageView *imagV = [UIImageView lh_imageViewWithFrame:self.bounds image:[UIImage imageNamed:@"img_bg_user"]];
        [self addSubview:imagV];
        //登录后状态底视图
        self.loginContentView = [UIView lh_viewWithFrame:frame backColor:kClearColor];
        [self addSubview:self.loginContentView];
        self.teacherImageIcon.centerX = SCREEN_WIDTH/2;
        self.nameLabel.centerX = SCREEN_WIDTH/2;

        [self.loginContentView addSubview:self.teacherImageIcon];
        [self.loginContentView addSubview:self.nameLabel];
        
        //底部图
        [self.loginContentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.IDLabel];
        [self.bottomView addSubview:self.titleLabel];

    }
    return self;
}

//累计
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2+1, 0, WidthScaleSize_W(160), WidthScaleSize_H(50))];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = BoldFONT(14);
    }
    return _titleLabel;
    
}

//用户头像
- (UIImageView *)teacherImageIcon {
    
    if (!_teacherImageIcon) {
        _teacherImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WidthScaleSize_W(20), WidthScaleSize_H(20), WidthScaleSize_W(100), WidthScaleSize_W(100))];
        _teacherImageIcon.backgroundColor = KVCBackGroundColor;
        [_teacherImageIcon lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
    }
    return _teacherImageIcon;
    
}
//姓名
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.teacherImageIcon.frame)+20, WidthScaleSize_W(200), WidthScaleSize_H(25))];
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = BoldFONT(16);
    }
    return _nameLabel;
    
}
//ID
- (UILabel *)IDLabel {
    
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WidthScaleSize_W(200), WidthScaleSize_H(50))];
        _IDLabel.textColor = kWhiteColor;
        _IDLabel.textAlignment = NSTextAlignmentCenter;
        _IDLabel.font = BoldFONT(14);
    }
    return _IDLabel;
    
}
// 底图
- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mj_h-WidthScaleSize_H(50), SCREEN_WIDTH, WidthScaleSize_H(50))];
        _bottomView.backgroundColor = kBlackColor;
    }
    return _bottomView;
    
}
@end
