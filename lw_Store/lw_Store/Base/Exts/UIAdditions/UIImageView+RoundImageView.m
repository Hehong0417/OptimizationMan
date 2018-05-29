//
//  UIImageView+RoundImageView.m
//  Moto
//
//  Created by zhipeng-mac on 15/11/13.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "UIImageView+RoundImageView.h"

@implementation UIImageView (RoundImageView)

- (void)setRoundImageViewWithBorderWidth:(CGFloat)borderWidth {
    
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
