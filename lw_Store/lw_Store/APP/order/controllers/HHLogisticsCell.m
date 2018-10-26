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
    
    self.yearLabel.text = model.express_date?model.express_date:@"";
    self.timeLabel.text = model.express_time?model.express_time:@"";
    self.express_messageLabe.text = model.express_message?model.express_message:@"";

}

@end
