//
//  CartVC.h
//  Store
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHCartVCProtocol <NSObject>

- (void)cartVCBackActionHandle;

@end
typedef enum : NSUInteger {
    HHcartType_home,
    HHcartType_goodDetail,
} HHcartType;

@interface HHShoppingVC : UIViewController

@property (nonatomic, assign)  HHcartType  cartType;

@property (nonatomic, weak) id <HHCartVCProtocol> delegate;

@end
