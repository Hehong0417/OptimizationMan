//
//  HHBroughtGiftResultCell.h
//  lw_Store
//
//  Created by User on 2018/5/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHBroughtGiftResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *top_line;
@property (weak, nonatomic) IBOutlet UILabel *down_line;
@property (weak, nonatomic) IBOutlet UILabel *content_label;
@property (weak, nonatomic) IBOutlet UIView *bg_view;

- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count;

@end
