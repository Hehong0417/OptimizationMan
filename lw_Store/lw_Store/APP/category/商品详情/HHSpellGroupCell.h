//
//  HHSpellGroupCell.h
//  springDream
//
//  Created by User on 2018/9/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHActivityModel.h"

@interface HHSpellGroupCell : UITableViewCell

@property(nonatomic,strong) UIImageView *icon_imagV;
@property(nonatomic,strong) UILabel *name_label;
@property(nonatomic,strong) UILabel *personNumber_label;
@property(nonatomic,strong) UIButton *spellGroup_button;
@property(nonatomic,strong) HHJoinActivityModel *model;

@end
