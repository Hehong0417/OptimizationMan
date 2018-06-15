//
//  HHSubmitOrdersVC.h
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHaddress_type_add_cart,
    HHaddress_type_add_productDetail,
    HHaddress_type_Spell_group,
    HHaddress_type_another
    
} HHenter_type;

@interface HHSubmitOrdersVC : UIViewController
@property(nonatomic,strong) NSString *ids_Str;
@property(nonatomic,assign) HHenter_type enter_type;
@property(nonatomic,strong) NSNumber *mode;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSNumber *sendGift;

@end

