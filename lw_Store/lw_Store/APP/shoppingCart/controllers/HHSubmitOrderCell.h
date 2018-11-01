//
//  HHSubmitOrderCell.h
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSubmitOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *StandardLab;
@property (nonatomic, strong) HHproductsModel *productsModel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *sku_nameLabel;

@property (nonatomic, strong) HHproductsModel *orderProductsModel;

@end
