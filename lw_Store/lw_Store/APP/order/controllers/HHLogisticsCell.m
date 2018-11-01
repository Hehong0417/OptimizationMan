//
//  HHLogisticsCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHLogisticsCell.h"

@implementation HHLogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HHExpress_message_list *)model{
    _model = model;
    
    NSArray *times = [model.time componentsSeparatedByString:@" "];
    self.yearLabel.text = times[0]?times[0]:@"";
    self.timeLabel.text = times[1]?times[1]:@"";
    self.express_messageLabe.text = model.context?model.context:@"";
}

@end
