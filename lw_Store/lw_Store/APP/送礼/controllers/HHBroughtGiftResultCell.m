//
//  HHBroughtGiftResultCell.m
//  lw_Store
//
//  Created by User on 2018/5/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBroughtGiftResultCell.h"

@implementation HHBroughtGiftResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bg_view setupAutoHeightWithBottomView:self.content_label bottomMargin:15];
    [self setupAutoHeightWithBottomView:self.bg_view bottomMargin:5];
}
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count{
    
    if (indexPath.row == 0) {
        self.top_line.hidden = YES;
        self.down_line.hidden = NO;
    }else{
        self.top_line.hidden = NO;
        self.down_line.hidden = NO;
        if (indexPath.row == count-1) {
            self.down_line.hidden = YES;
        }
    }
}

@end
