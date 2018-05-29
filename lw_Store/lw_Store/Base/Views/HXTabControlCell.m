//
//  HXTabControlCell.m
//  HXBudsProject
//
//  Created by n on 2017/5/10.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HXTabControlCell.h"

@implementation HXTabControlCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.moneyLab.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 2*50 - 2*25)/3, 35);
        [self.contentView addSubview:self.moneyLab];
    }

    return self;
}
- (UILabel *)moneyLab {

    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.font = FONT(15);
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.textColor = APP_COMMON_COLOR;
    }
    return _moneyLab;

}

@end
