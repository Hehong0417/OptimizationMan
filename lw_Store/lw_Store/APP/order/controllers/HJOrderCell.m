
//
//  HJOrderCell.m
//  Mcb
//
//  Created by IMAC on 15/12/25.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "HJOrderCell.h"

@interface HJOrderCell ()
@property (strong, nonatomic) IBOutlet UIImageView *goodsIco;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *quantityLab;

@end

@implementation HJOrderCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.goodsIco lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    [self.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
    [self.StandardLab setTapActionWithBlock:^{
       
        
    }];
}

- (void)setProductModel:(HHproductsModel *)productModel{
    _productModel = productModel;

    [self.goodsIco sd_setImageWithURL:[NSURL URLWithString:productModel.icon]];
    self.goodsNameLab.text = productModel.prodcut_name;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",productModel.price.floatValue];
    if (productModel.item_status.integerValue == 6) {
        //退款中
        self.StandardLab.text = @"退款中";
        self.StandardLab.userInteractionEnabled = NO;
    }else if (productModel.item_status.integerValue == 7){
        self.StandardLab.text = @"退货中";
        self.StandardLab.userInteractionEnabled = NO;
    }else if (productModel.item_status.integerValue == 9){
        self.StandardLab.text = @"已退款";
        self.StandardLab.userInteractionEnabled = NO;
    }else if (productModel.item_status.integerValue == 10){
        self.StandardLab.text = @"已退货";
        self.StandardLab.userInteractionEnabled = NO;
    }else if (productModel.item_status.integerValue == 2){
        self.StandardLab.text = @"申请退款";
        self.StandardLab.userInteractionEnabled = YES;
    }else if (productModel.item_status.integerValue == 3){
        self.StandardLab.text = @"申请退货";
        self.StandardLab.userInteractionEnabled = YES;
    }else{
        self.StandardLab.text = @"";
        self.StandardLab.hidden = YES;
        self.StandardLab.userInteractionEnabled = NO;
    }
    self.quantityLab.text = [NSString stringWithFormat:@"X%@",productModel.quantity];
    self.sku_nameLab.text = [NSString stringWithFormat:@"%@",productModel.sku_name?productModel.sku_name:@""];

}

@end
