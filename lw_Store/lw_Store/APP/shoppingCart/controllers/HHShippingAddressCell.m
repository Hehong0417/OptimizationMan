//
//  HHShippingAddressCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHShippingAddressCell.h"

@implementation HHShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setShippingAddressModel:(HHMineModel *)shippingAddressModel{
    
    _shippingAddressModel = shippingAddressModel;
    
    self.usernameLabel.text = shippingAddressModel.Recipient;
    self.mobileLabel.text = shippingAddressModel.Moble;
    self.provinceLabel.text =  [NSString stringWithFormat:@"%@%@",shippingAddressModel.City,shippingAddressModel.District];
    self.full_addressLabel.text = shippingAddressModel.FullAddress;
    if ([shippingAddressModel.IsDefault isEqualToString:@"0"]) {
        self.defaultAddressLabel.hidden = YES;
    }else{
        self.defaultAddressLabel.hidden = NO;
    }
    
}
@end
