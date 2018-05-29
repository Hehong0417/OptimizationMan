//
//  HHOrderDetailCellOne.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderDetailCellOne.h"

@implementation HHOrderDetailCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setAddressModel:(HHCartModel *)addressModel{
    _addressModel = addressModel;
    self.usernameAndmobileLabel.text = [NSString stringWithFormat:@"%@       %@",addressModel.buyerName?addressModel.buyerName:@"",addressModel.mobile?addressModel.mobile:@""];
    self.addressLabel.text = addressModel.address;
    
}
@end
