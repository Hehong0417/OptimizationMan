//
//  HHUrlModel.h
//  lw_Store
//
//  Created by User on 2018/5/22.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHUrlModel : BaseModel

@property (nonatomic, strong)   NSString *Id;
@property (nonatomic, strong)   NSString *cid;
@property (nonatomic, strong)   NSString *coupId;
@property (nonatomic, strong)   NSString *skuId;
@property (nonatomic, strong)   NSNumber *mode;
@property (nonatomic, strong)   NSString *order_id;

@end
