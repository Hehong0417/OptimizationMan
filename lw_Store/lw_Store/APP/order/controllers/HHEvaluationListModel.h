//
//  HHEvaluationListModel.h
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHEvaluationListModel : BaseModel

@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *proper;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *imagesModelArray;
@property (nonatomic, strong) NSString *replyContent;

@property (nonatomic, strong) NSString *addition_time;
@property (nonatomic, strong) NSString *addition_comment;

@end
