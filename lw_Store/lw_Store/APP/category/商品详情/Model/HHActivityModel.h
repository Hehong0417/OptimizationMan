//
//  HHActivityModel.h
//  lw_Store
//
//  Created by User on 2018/6/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHActivityModel : BaseModel
@property(nonatomic,strong) NSString *Count;
@property(nonatomic,strong) NSNumber *IsJoin;
@property(nonatomic,strong) NSNumber *Price;
@property(nonatomic,strong) NSNumber *Mode;

@end
