//
//  HHSubmitOrdersHead.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrdersHead.h"

@implementation HHSubmitOrdersHead

- (void)setAddressModel:(HHCartModel *)addressModel{
    _addressModel = addressModel;
   
    self.usernameLabel.text = [NSString stringWithFormat:@"收货人：%@    %@",addressModel.userName,addressModel.mobile];
    self.full_addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",addressModel.fullAddress];
}
- (void)setModel:(HHMineModel *)model{
    
    _model = model;
    self.usernameLabel.text = [NSString stringWithFormat:@"收货人：%@    %@",model.Recipient,model.Moble];
    self.full_addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",model.FullAddress];
}
@end
