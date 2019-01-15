//
//  HHPaySucessVC.h
//  Store
//
//  Created by User on 2018/1/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHenter_type_cart,
    HHenter_type_order,
    HHenter_type_productDetail,
    HHenter_type_activity
} HHSucessEnter_type;

@interface HHPaySucessVC : UIViewController

@property(nonatomic,assign) HHSucessEnter_type enter_type;

@property(nonatomic,copy) voidBlock backBlock;

@property(nonatomic,strong) NSString *pids;

@property(nonatomic,strong) NSString *oid;


@end
