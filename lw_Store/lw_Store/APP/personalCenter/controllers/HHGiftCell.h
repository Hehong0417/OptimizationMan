//
//  HHGiftCell.h
//  lw_Store
//
//  Created by User on 2019/1/8.
//  Copyright © 2019年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHGiftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *pNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *receiveDate;
@property (strong, nonatomic) HHMineModel *prizeModel;

@end

NS_ASSUME_NONNULL_END
