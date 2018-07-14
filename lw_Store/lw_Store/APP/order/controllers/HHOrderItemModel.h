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

@end
