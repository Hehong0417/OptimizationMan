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
}

- (void)setModel:(HHExpress_message_list *)model{
    _model = model;
    
    self.yearLabel.text = model.express_date?model.express_date:@"";
    self.timeLabel.text = model.express_time?model.express_time:@"";
    self.express_messageLabe.text = model.express_message?model.express_message:@"";
    
}
@end
