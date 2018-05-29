//
//  HHShippingAddressVC.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHenter_type_submitOrder,
    HHenter_type_mine
}HHenter_address_type;
@protocol HHShippingAddressVCProtocol <NSObject>
//选择收货地址
- (void)shippingAddressTableView_didSelectRowWithaddressModel:(HHMineModel *)addressModel;

@end

@interface HHShippingAddressVC : UIViewController

@property (nonatomic, weak) id <HHShippingAddressVCProtocol> delegate;
@property (nonatomic, assign) HHenter_address_type enter_type;

@end
