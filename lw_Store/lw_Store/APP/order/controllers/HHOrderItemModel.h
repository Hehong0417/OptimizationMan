//
//  HHOrderItemModel.h
//  lw_Store
//
//  Created by User on 2018/5/31.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHOrderItemModel : BaseModel

@property(nonatomic,strong) NSMutableArray *items;

@property(nonatomic,strong) NSMutableArray *pids;
@property(nonatomic,strong) NSNumber *order_can_evaluate;
@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,strong) NSString *order_date;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *status_name;
@property(nonatomic,strong) NSString *total;

@end
