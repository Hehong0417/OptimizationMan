//
//  HHPersonCenterView.m
//  lw_Store
//
//  Created by User on 2018/4/25.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPersonCenterView.h"

@implementation HHPersonCenterView

+(HHPersonCenterView *)personViewWithFrame:(CGRect)frame btn_imageName:(NSString *)btn_imageName btn_titleName:(NSString *)btn_titleName lab_titleName:(NSString *)lab_titleName{
    
    HHPersonCenterView *view = [[HHPersonCenterView alloc]initWithFrame:frame];
    
    XYQButton  *top_btn_part = [XYQButton ButtonWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height/2-10) imgaeName:btn_imageName titleName:btn_titleName contentType:LeftImageRightTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:KLightTitleColor fontsize:AdapationLabelHeight(11)] tapAction:nil];
    top_btn_part.userInteractionEnabled = NO;
    [view addSubview:top_btn_part];
    
    UILabel  *bottom_label_part = [UILabel lh_labelWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width,frame.size.height/2-10) text:lab_titleName textColor:KLightTitleColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    [view addSubview:bottom_label_part];
    bottom_label_part.userInteractionEnabled = NO;
    return view;

}
@end
