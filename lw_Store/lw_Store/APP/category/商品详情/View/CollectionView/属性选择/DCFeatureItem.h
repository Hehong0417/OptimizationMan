//
//  DCFeatureItem.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCFeatureTitleItem,DCFeatureList;
@interface DCFeatureItem : BaseModel

//规格ID
@property (strong , nonatomic)NSString *sku_name_id;
//规格名称
@property (strong , nonatomic)NSString *sku_name_name;


/* 名字 */
@property (strong , nonatomic)DCFeatureTitleItem *attr;
/* 数组 */
@property (strong , nonatomic)NSArray<DCFeatureList *> *sku_name_value;

@end
