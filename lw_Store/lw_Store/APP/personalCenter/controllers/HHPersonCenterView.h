//
//  HHPersonCenterView.h
//  lw_Store
//
//  Created by User on 2018/4/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPersonCenterView : UIView

@property (nonatomic, strong)  XYQButton  *top_btn_part;

@property (nonatomic, strong)  UILabel  *bottom_label_part;

+ (HHPersonCenterView *)personViewWithFrame:(CGRect)frame btn_imageName:(NSString *)btn_imageName btn_titleName:(NSString *)btn_titleName  lab_titleName:(NSString *)lab_titleName;

@end
