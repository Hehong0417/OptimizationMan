//
//  HHBargainingRecordCell.m
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBargainingRecordCell.h"

@implementation HHBargainingRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.ng_view lh_setCornerRadius:5 borderWidth:1 borderColor:[UIColor colorWithHexString:@"#DDDDDD"]];
    [self.iconView lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count{
    
    if (indexPath.row == 0) {
        self.topLine.hidden = YES;
        self.downLine.hidden = NO;
    }else{
        self.topLine.hidden = NO;
        self.downLine.hidden = NO;
        if (indexPath.row == count-1) {
            self.downLine.hidden = YES;
        }
    }
}

@end
