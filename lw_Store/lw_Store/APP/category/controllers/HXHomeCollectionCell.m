//
//  HXHomeCollectionCell.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HXHomeCollectionCell.h"
#import "HHHomeAPI.h"

@implementation HXHomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.goodImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    [self.collectButton setImage:[UIImage imageNamed:@"tip_03"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"tip_02"] forState:UIControlStateSelected];
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

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%@",goodsModel.MarketPrice] rangeStr:[NSString stringWithFormat:@"¥%@",goodsModel.MarketPrice] color:KA0LabelColor];
    
   
}
- (void)setGuess_you_likeModel:(HHGuess_you_likeModel *)guess_you_likeModel{
    
    _guess_you_likeModel = guess_you_likeModel;
    
    self.product_min_priceLabel.textColor = kBlackColor;

    self.product_nameLabel.text = guess_you_likeModel.name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:guess_you_likeModel.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%@",guess_you_likeModel.sale_price];

    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%@",guess_you_likeModel.market_price] rangeStr:[NSString stringWithFormat:@"¥%@",guess_you_likeModel.market_price] color:KA0LabelColor];
    
}

- (void)setCollectModel:(HHCategoryModel *)collectModel{
    
    _collectModel = collectModel;
    
    self.product_nameLabel.text = collectModel.product_name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:collectModel.product_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",collectModel.product_cost_price?collectModel.product_cost_price.doubleValue:0.00];
    
    self.product_s_intergralLabel.attributedText = [self.product_s_intergralLabel lh_addtrikethroughStyleAtContent:[NSString stringWithFormat:@"¥%@",collectModel.product_market_price?collectModel.product_market_price:@"0"] rangeStr:[NSString stringWithFormat:@"¥%@",collectModel.product_market_price?collectModel.product_market_price:@"0"] color:KA0LabelColor];
    self.collectButton.selected = YES;
    
}
- (IBAction)collectbuttonAction:(UIButton *)sender {
    
    if (sender.selected == YES) {
        //取消收藏
        NSString *pids =nil;
         pids = self.collectModel.product_id;
        
        [[[HHHomeAPI postDeleteProductCollectionWithpids:pids] netWorkClient] postRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    sender.selected = NO;
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showSuccessWithStatus:api.Msg];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(collectHandleComplete)]&&self.collectModel.product_id) {
                        [self.delegate collectHandleComplete];
                    }
                }else{
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];
    }else{
        
        //添加收藏
        NSString *pids =nil;
        pids = self.collectModel.product_id;

        [[[HHHomeAPI postAddProductCollectionWithpids:pids] netWorkClient] postRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    
                    sender.selected = YES;
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    [SVProgressHUD showSuccessWithStatus:api.Msg];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(collectHandleComplete)]&&self.collectModel.product_id) {
                        [self.delegate collectHandleComplete];
                    }
                    
                }else{
                    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
                    
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];
    }
    
    
}


@end
