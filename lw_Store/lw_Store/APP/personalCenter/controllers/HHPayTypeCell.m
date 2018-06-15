//
//  HHPayTypeCell.m
//  lw_Store
//
//  Created by User on 2018/5/21.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPayTypeCell.h"

@implementation HHPayTypeCell

- (instancetype)createCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentType:(HHPayTypeCellContentType)contentType haveIconView:(BOOL)haveIconView {
    
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.ishaveIconView = haveIconView;
        self.ContentType = contentType;
        
        self.leftSelect_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftSelect_btn setImage:[UIImage imageNamed:@"icon_sign_default"] forState:UIControlStateNormal];
        [self.leftSelect_btn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
        self.leftSelect_btn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.leftSelect_btn];
        
        self.icon_View = [UIImageView new];
        self.icon_View.image = [UIImage imageNamed:@"icon1"];
        [self.contentView addSubview:self.icon_View];
        
        self.payType_label = [UILabel new];
        self.payType_label.font = FONT(14);
        [self.contentView addSubview:self.payType_label];
        
        self.rightSelect_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightSelect_btn setImage:[UIImage imageNamed:@"icon_sign_default"] forState:UIControlStateNormal];
        [self.rightSelect_btn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
        self.rightSelect_btn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.rightSelect_btn];
        
        [self setConstaints];
    }
    return self;
}
- (void)setConstaints{
    
    CGFloat icon_width;
    if (self.ishaveIconView) {
        icon_width = 40;
        
    }else{
        icon_width = 0;
        
    }
    CGFloat leftSelect_btn_width;

    if (self.ContentType == HHPayTypeCellContentType_leftSelectBtn) {
        self.rightSelect_btn.hidden = YES;
        self.leftSelect_btn.hidden = NO;
        leftSelect_btn_width = 40;
   }else{
        self.rightSelect_btn.hidden = NO;
        self.leftSelect_btn.hidden = YES;
        leftSelect_btn_width = 10;
    }
    self.leftSelect_btn.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView,0)
    .widthIs(leftSelect_btn_width);
    
    self.icon_View.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.leftSelect_btn, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthIs(icon_width);
    
    self.payType_label.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.icon_View, 20)
    .bottomSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 40);
    
    self.rightSelect_btn.sd_layout
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 20)
    .bottomSpaceToView(self.contentView,0)
    .widthIs(40);

}
- (void)setSelected:(BOOL)selected{

    self.leftSelect_btn.selected = selected;
    self.rightSelect_btn.selected = selected;
}
- (void)setCouponsModel:(HHcouponsModel *)couponsModel{
    _couponsModel = couponsModel;
    self.payType_label.text = couponsModel.DisplayName;
}
@end
