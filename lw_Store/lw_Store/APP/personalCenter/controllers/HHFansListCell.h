//
//  HHFansListCell.h
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHFansListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbel;
@property (weak, nonatomic) IBOutlet UILabel *fans_countLAbel;

@property(nonatomic,strong) HHMineModel *model;

@end
