//
//  HXHomeCollectionCell.h
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHHomeModel.h"

@interface HXHomeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodImageV;
@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_min_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_s_intergralLabel;

//首页商品列表
@property(nonatomic,strong) HHhomeProductsModel *productsModel;

//分类商品列表
@property(nonatomic,strong) HHCategoryModel *goodsModel;

@end


