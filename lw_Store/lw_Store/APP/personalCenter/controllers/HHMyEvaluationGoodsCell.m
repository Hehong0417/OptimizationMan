//
//  HHMyEvaluationGoodsCell.m
//  lw_Store
//
//  Created by User on 2019/2/12.
//  Copyright © 2019年 User. All rights reserved.
//

#import "HHMyEvaluationGoodsCell.h"

@implementation HHMyEvaluationGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageV = [UIImageView new];
        self.iconImageV.backgroundColor = APP_COMMON_COLOR;
        [self.contentView  addSubview:self.iconImageV];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.font = FONT(14);
        self.nameLabel.textColor = kBlackColor;
        self.nameLabel.contentMode = UIViewContentModeRight;
        self.nameLabel.text = @"名品优质菊花茶";
        [self.contentView  addSubview:self.nameLabel];
        
        [self setConstaints];
    }
    return self;
}
- (void)setConstaints{
    
    self.iconImageV.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .bottomSpaceToView(self.contentView, 15)
    .widthEqualToHeight();
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.iconImageV, 20)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(25)
    .centerYEqualToView(self.iconImageV);
    
}
- (void)setModel:(HHEvaluationListModel *)model{
    _model = model;
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:model.productIcon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.nameLabel.text = model.productName;
    
}
@end
