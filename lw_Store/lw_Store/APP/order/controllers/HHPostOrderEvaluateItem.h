//
//  HHPostOrderEvaluateItem.h
//  lw_Store
//
//  Created by User on 2018/8/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"


@interface HHPostOrderEvaluateItem : BaseModel

singleton_h(PostOrderEvaluateItem)

@property(nonatomic,strong)   NSString *orderId;
@property(nonatomic,strong)   NSNumber *level;
@property(nonatomic,strong)   NSNumber *logisticsScore;
@property(nonatomic,strong)   NSNumber *serviceScore;
@property(nonatomic,strong)   NSMutableArray *productEvaluate;
@end
//子单模型
@interface HHproductEvaluateModel : BaseModel
@property(nonatomic,strong)   NSString *orderItemId;
@property(nonatomic,strong)   NSNumber *describeScore;
@property(nonatomic,strong)   NSString *content;
@property(nonatomic,strong)   NSArray *pictures;
@end
