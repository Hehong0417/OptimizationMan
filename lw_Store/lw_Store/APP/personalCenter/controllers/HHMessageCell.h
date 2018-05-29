//
//  HHMessageCell.h
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMessageCell : UITableViewCell

@property(nonatomic,strong) UILabel *meassageLabel;

@property(nonatomic,strong) UILabel *timeLabel;

@property(nonatomic,strong) HHMineModel *model;

@end
