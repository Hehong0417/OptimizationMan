//
//  DCLIRLButton.m
//  CDDMall
//
//  Created by apple on 2017/6/27.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCLIRLButton.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCLIRLButton ()



@end

@implementation DCLIRLButton

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.mj_w * 0.55;
    self.imageView.mj_x = self.titleLabel.mj_x - self.imageView.mj_w - 5;
}

#pragma mark - Setter Getter Methods

@end
