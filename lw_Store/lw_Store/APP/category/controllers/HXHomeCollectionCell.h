//
//  HXHomeCollectionCell.h
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHHomeModel.h"
#import "HHgooodDetailModel.h"


@protocol HXHomeCollectionCellDelegate<NSObject>

- (void)collectHandleComplete;

@end

@interface HXHomeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodImageV;
@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_min_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *product_s_intergralLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

//首页商品列表
@property(nonatomic,strong) HHhomeProductsModel *productsModel;

//分类商品列表
@property(nonatomic,strong) HHCategoryModel *goodsModel;

//首页商品列表
@property(nonatomic,strong) HHGuess_you_likeModel *guess_you_likeModel;

@property(nonatomic,strong) HHCategoryModel *collectModel;

@property(nonatomic,weak)  id<HXHomeCollectionCellDelegate> delegate;

@end


