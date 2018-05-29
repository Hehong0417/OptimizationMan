//
//  HHOrderDetailCellOne.h
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHOrderDetailCellOne : UITableViewCell

@property (nonatomic, strong) HHCartModel *addressModel;

@property (weak, nonatomic) IBOutlet UILabel *usernameAndmobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end
