//
//  HHApplyRefundVC.h
//  lw_Store
//
//  Created by User on 2018/5/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHApplyRefundVC : UITableViewController

@property (nonatomic, strong) HHproductsModel *productModel;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, copy) voidBlock  applyRefund_block;

@end
