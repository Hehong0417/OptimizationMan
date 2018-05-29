//
//  HXTableViewHead.h
//  mengyaProject
//
//  Created by n on 2017/8/5.
//  Copyright © 2017年 n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXTableViewHead : UIView

@property(nonatomic,copy)NSString *headtitle;
@property(nonatomic,copy)NSString *discribText;
@property(nonatomic,copy)NSString *rightBtnTitle;
@property(nonatomic,assign)ContentType contentType;
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *rightImageName;
@property(nonatomic,assign)NSInteger labFont;
@property(nonatomic,strong) FontAttributes *btnFontAttributes;
@property(nonatomic,strong)XYQButton *rightBtn;
//分类图片
@property(nonatomic,strong)UIImageView *categoryImageV;

@property(nonatomic,strong)UILabel *headTitleLab;
@property(nonatomic,strong)UILabel *discribLab;

@property(nonatomic,assign)CGRect headtitleFrame;

@end
