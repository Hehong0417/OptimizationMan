
//
//  HHSubmitOrderCell.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrderCell.h"

@implementation HHSubmitOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setProductsModel:(HHproductsModel *)productsModel{
    _productsModel = productsModel;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",productsModel.price];
    self.namelabel.text = [NSString stringWithFormat:@"%@",productsModel.pname];
    self.quantityLabel.text = [NSString stringWithFormat:@"X%@",productsModel.quantity];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.icon]];
    self.sku_nameLabel.text = productsModel.sku_name;

}
- (void)setOrderProductsModel:(HHproductsModel *)orderProductsModel{
    _orderProductsModel = orderProductsModel;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderProductsModel.price];
    self.namelabel.text = [NSString stringWithFormat:@"%@",orderProductsModel.prodcut_name];
    self.quantityLabel.text = [NSString stringWithFormat:@"X%@",orderProductsModel.quantity];
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:orderProductsModel.icon]];
    self.sku_nameLabel.text = orderProductsModel.sku_name;

}



@end
