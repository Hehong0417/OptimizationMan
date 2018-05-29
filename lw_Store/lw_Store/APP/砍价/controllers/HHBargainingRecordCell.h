//
//  HHBargainingRecordCell.h
//  lw_Store
//
//  Created by User on 2018/5/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHBargainingRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *ng_view;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *downLine;

- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count;

@end
