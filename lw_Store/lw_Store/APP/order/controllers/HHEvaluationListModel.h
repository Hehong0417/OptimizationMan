//
//  HHEvaluationListModel.h
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHEvaluationListModel : BaseModel

@property (nonatomic, strong) NSString *userImage;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *describeScore;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *skuName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, strong) NSString *adminReply;
@property (nonatomic, strong) NSString *addition_time;
@property (nonatomic, strong) NSString *addition_comment;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *productIcon;
@property (nonatomic, strong) NSString *bigPictures;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productId;


@end
