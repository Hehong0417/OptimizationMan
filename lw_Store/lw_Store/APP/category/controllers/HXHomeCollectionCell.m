//
//  HXHomeCollectionCell.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HXHomeCollectionCell.h"

@implementation HXHomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.goodImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    
}
- (void)setProductsModel:(HHhomeProductsModel *)productsModel{
    _productsModel = productsModel;
    
    self.product_nameLabel.text = productsModel.product_name;
    
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.product_icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",productsModel.product_min_price];
    self.product_s_intergralLabel.attributedText =  [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%@",productsModel.product_s_intergral] rangeStr:[NSString stringWithFormat:@"¥%@",productsModel.product_s_intergral] color:KA0LabelColor];

}
- (void)setGoodsModel:(HHCategoryModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    self.product_nameLabel.text = goodsModel.ProductName;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImageUrl1] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.MinShowPrice];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%@",goodsModel.MarketPrice] rangeStr:[NSString stringWithFormat:@"¥%@",goodsModel.MarketPrice] color:KA0LabelColor];;
   
}


@end
