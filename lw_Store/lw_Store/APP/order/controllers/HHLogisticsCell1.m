//
//  HHLogisticsCell1.m
//  Store
//
//  Created by User on 2018/1/31.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHLogisticsCell1.h"

@implementation HHLogisticsCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupAutoHeightWithBottomView:self.express_messageLabe bottomMargin:10];
}

- (void)setModel:(HHExpress_message_list *)model{
    _model = model;
    
    NSArray *times = [model.time componentsSeparatedByString:@" "];
    self.yearLabel.text = times[0]?times[0]:@"";
    self.timeLabel.text = times[1]?times[1]:@"";
    self.express_messageLabe.text = model.context?model.context:@"";
    
}
@end
