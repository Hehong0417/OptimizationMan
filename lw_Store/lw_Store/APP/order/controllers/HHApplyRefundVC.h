//
//  HHApplyRefundVC.h
//  lw_Store
//
//  Created by User on 2018/5/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyRefundDelegate <NSObject>

- (void)backActionWithBtn:(UIButton *)btn;

@end

@interface HHApplyRefundVC : UITableViewController

@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *order_id;
@property (strong, nonatomic)  NSString *title_str;
@property (strong, nonatomic)  NSString *nav_title;

@property(nonatomic,weak) id<ApplyRefundDelegate> delegate;

@end
