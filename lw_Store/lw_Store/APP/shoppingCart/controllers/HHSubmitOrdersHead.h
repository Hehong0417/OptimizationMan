//
//  HHSubmitOrdersHead.h
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSubmitOrdersHead : UIView
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *full_addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property(nonatomic,strong) HHCartModel *addressModel;
@property(nonatomic,strong) HHMineModel *model;


@end
