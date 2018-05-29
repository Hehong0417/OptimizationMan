//
//  HHShippingAddressCell.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHShippingAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *defaultAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteAddressBtn;

@property(nonatomic,strong) HHMineModel *shippingAddressModel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *full_addressLabel;


@end
