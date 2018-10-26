//
//  HHFillLogisticsVC.h
//  Store
//
//  Created by User on 2018/3/29.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHFillLogisticsVC : UIViewController

@property (nonatomic, strong)   NSString *orderid;
@property(nonatomic,strong) NSString *return_goods_express_code;
@property(nonatomic,strong) NSString *return_goods_express_order;
@property(nonatomic,assign) NSInteger sg_selectIndex;
@property(nonatomic,strong) NSString *product_item_refund_id;

@property(nonatomic,copy) numberBlock  return_numb_block;

@end
