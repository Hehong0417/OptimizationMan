//
//  HXMineHeadView.h
//  mengyaProject
//
//  Created by n on 2017/6/16.
//  Copyright © 2017年 n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMineHeadView : UIView

@property(nonatomic,strong) UIImageView *teacherImageIcon;

@property(nonatomic,strong) UILabel *nameLabel;

@property(nonatomic,strong) UILabel *IDLabel;

//登录后底视图
@property(nonatomic,strong) UIView *loginContentView;

//累计
@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UINavigationController *nav;

@property(nonatomic,strong) UIView *bottomView;

@end
