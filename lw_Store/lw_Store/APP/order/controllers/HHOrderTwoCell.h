//
//  HHOrderTwoCell.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHOrderItemModel.h"

@interface HHOrderTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *express_orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *express_nameLabel;

@property (nonatomic, strong) HHCartModel *orderModel;
@property (nonatomic, strong) HHOrderItemModel *orderTotalModel;

@end
