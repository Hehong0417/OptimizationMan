

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
        //img_bg_user
        UIImageView *imagV = [UIImageView lh_imageViewWithFrame:self.bounds image:[UIImage imageNamed:@""]];
        imagV.backgroundColor = APP_COMMON_COLOR;
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
        
        UIView *down_line = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 1, self.bottomView.mj_h-20)];
        down_line.backgroundColor = kWhiteColor;
        [self.bottomView addSubview:down_line];
        down_line.centerX = self.bottomView.centerX;

    }
    return self;
}

//累计
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2+1, 0, AdapationLabelHeight(160), self.bottomView.mj_h)];
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
        _teacherImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(AdapationLabelHeight(20), AdapationLabelHeight(20), AdapationLabelHeight(100), AdapationLabelHeight(100))];
        _teacherImageIcon.backgroundColor = KVCBackGroundColor;
        [_teacherImageIcon lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
    }
    return _teacherImageIcon;
    
}
//姓名
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.teacherImageIcon.frame)+10, AdapationLabelHeight(200), AdapationLabelHeight(25))];
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = BoldFONT(16);
    }
    return _nameLabel;
    
}
//ID
- (UILabel *)IDLabel {
    
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AdapationLabelHeight(200), self.bottomView.mj_h)];
        _IDLabel.textColor = kWhiteColor;
        _IDLabel.textAlignment = NSTextAlignmentCenter;
        _IDLabel.font = BoldFONT(14);
    }
    return _IDLabel;
    
}
// 底图
- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mj_h-AdapationLabelHeight(40), SCREEN_WIDTH, AdapationLabelHeight(40))];
        _bottomView.backgroundColor = APP_COMMON_COLOR;
        ;
    }
    return _bottomView;
    
}
@end
