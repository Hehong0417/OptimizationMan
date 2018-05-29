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
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.product_icon]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",productsModel.product_min_price];
    self.product_s_intergralLabel.text = [NSString stringWithFormat:@"%@积分",productsModel.product_s_intergral];

}
- (void)setGoodsModel:(HHCategoryModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    self.product_nameLabel.text = goodsModel.ProductName;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImageUrl1]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.MinShowPrice];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",goodsModel.MarketPrice]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];

    self.product_s_intergralLabel.attributedText = newPrice;
   
}


@end
