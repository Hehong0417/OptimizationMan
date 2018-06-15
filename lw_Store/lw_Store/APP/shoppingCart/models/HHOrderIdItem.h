//
//  HHOrderIdItem.h
//  lw_Store
//
//  Created by User on 2018/6/15.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHOrderIdItem : BaseModel

singleton_h(OrderIdItem)

@property(nonatomic,strong) NSString *order_id;

@end
