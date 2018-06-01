//
//  HHWXModel.h
//  CredictCard
//
//  Created by User on 2018/3/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHWXModel : BaseModel
@property (strong, nonatomic) NSString *nonceStr;
@property (strong, nonatomic) NSString *package;
@property (strong, nonatomic) NSString *partnerId;
@property (strong, nonatomic) NSString *prepayId;
@property (strong, nonatomic) NSString *paySign;
@property (strong, nonatomic) NSString *timeStamp;
@property (strong, nonatomic) NSString *tradeNo;

+ (void)payReqWithModel:(HHWXModel *)model;

@end
