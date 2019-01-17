//
//  HHReceiveAlertView.m
//  lw_Store
//
//  Created by User on 2019/1/9.
//  Copyright © 2019年 User. All rights reserved.
//

#import "HHReceiveAlertView.h"

@implementation HHReceiveAlertView

- (UIView *)alertViewContentView {
    
    UIImageView *imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(60, 0, ScreenW-120, 220) image:[UIImage imageNamed:@"receiveSucess"]];
    imageV.center = CGPointMake(ScreenW/2, ScreenH/2);
    imageV.contentMode = UIViewContentModeCenter;
    imageV.backgroundColor = kClearColor;
    
    return imageV;
}

@end
