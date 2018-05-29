//
//  HHCategoryCollectionHead.m
//  Store
//
//  Created by User on 2017/12/20.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHCategoryCollectionHead.h"

@implementation HHCategoryCollectionHead

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIButton *recommendBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, self.mj_w, 50) target:self action:nil image:[UIImage imageNamed:@"icon_class_recommend_default"] title:@"" titleColor:APP_Deep_purple_Color font:FONT(15)];
        [self addSubview:recommendBtn];
    }
    return self;
}
@end
