//
//  HHNotWlanView.m
//  Store
//
//  Created by User on 2018/1/27.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHNotWlanView.h"

@implementation HHNotWlanView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
       
        self.notWlan_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, 100) image:[UIImage imageNamed:@"img_network_disable"]];
        self.notWlan_imagV.contentMode = UIViewContentModeCenter;
        [self addSubview:self.notWlan_imagV];
        self.notWlan_imagV.centerY = self.centerY - 30;
        self.describeLabel = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.notWlan_imagV.frame), ScreenW, 40) text:@"网络竟然崩溃了～" textColor:KACLabelColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        [self addSubview:self.describeLabel];

    }
    return self;
}

@end

