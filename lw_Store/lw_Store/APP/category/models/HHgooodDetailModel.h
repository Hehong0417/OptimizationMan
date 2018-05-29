//
//  HHgooodDetailModel.h
//  Store
//
//  Created by User on 2018/1/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHsku_name_valueModel,HHattributeValueModel,HHproduct_sku_valueModel,HHproduct_skuModel;

@interface HHgooodDetailModel : BaseModel

@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *ProductName;
@property(nonatomic,strong) NSString *MarketPrice;
@property(nonatomic,strong) NSString *MinShowPrice;
@property(nonatomic,strong) NSString *Stock;
@property(nonatomic,strong) NSString *SaleCounts;
@property(nonatomic,strong) NSString *Description;
//属性值
@property(nonatomic,strong) NSArray <HHattributeValueModel *>*AttributeValueList;


@property(nonatomic,strong) NSArray *ImageUrls;

//规格数组
@property(nonatomic,strong) NSArray <HHproduct_sku_valueModel *>*SKUValues;

//规格查询数组
@property(nonatomic,strong) NSArray <HHproduct_skuModel *>*SKUList;


@property(nonatomic,strong) NSString *tip;

@end
//属性父模型
@interface HHproduct_sku_valueModel : BaseModel
@property(nonatomic,strong) NSString *ValueId;
@property(nonatomic,strong) NSString *ValueName;
@property(nonatomic,strong) NSArray <HHsku_name_valueModel*> *ItemList;
//*是否点击选择了某一组
@property (nonatomic,assign)BOOL isSelect;

@end
//属性子模型
@interface HHsku_name_valueModel : BaseModel
@property(nonatomic,strong) NSString *ValueItemId;
@property(nonatomic,strong) NSString *ValueItemName;

//*是否点击 (自己添加的属性)
@property (nonatomic,assign)BOOL isSelect;

//*属性是否能选
@property (nonatomic,assign)BOOL modelLocked;

@end

//规格查询模型
@interface HHproduct_skuModel : BaseModel
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *ProductInfo_Id;
@property(nonatomic,strong) NSString *SalePrice;
@property(nonatomic,strong) NSString *Stock;
@property(nonatomic,strong) NSString *CostPrice;
@property(nonatomic,strong) NSString *Weight;
@property(nonatomic,strong) NSString *imgUrl;

@end

@interface HHattributeValueModel : BaseModel
@property(nonatomic,strong) NSString *Attribute_Id;
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *ValueName;
@property(nonatomic,strong) NSString *ValueStr;

@end