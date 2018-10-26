//
//  HHLogisticsCell1.h
//  Store
//
//  Created by User on 2018/1/31.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHLogisticsCell1 : UITableViewCell
@property (nonatomic, strong)   HHExpress_message_list *model;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *express_messageLabe;
@end
