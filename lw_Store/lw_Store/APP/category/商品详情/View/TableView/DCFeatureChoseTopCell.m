//
//  DCFeatureChoseTopCell.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureChoseTopCell.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCFeatureChoseTopCell ()

/* 取消 */
@property (strong , nonatomic)UIButton *crossButton;


@end

@implementation DCFeatureChoseTopCell

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUpUI
{
    _crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_crossButton setImage:[UIImage imageNamed:@"icon_close_default"] forState:0];
    [_crossButton addTarget:self action:@selector(crossButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_crossButton];
    
    _goodImageView = [UIImageView new];
    _goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_goodImageView lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    [self addSubview:_goodImageView];
    
    _goodPriceLabel = [UILabel new];
    _goodPriceLabel.font = FONT(18);
    _goodPriceLabel.textColor = [UIColor redColor];
    
    [self addSubview:_goodPriceLabel];
    
    
    _inventoryLabel = [UILabel new];
    _inventoryLabel.font = FONT(12);
    [self addSubview:_inventoryLabel];
    
    
    _chooseAttLabel = [UILabel new];
    _chooseAttLabel.numberOfLines = 2;
    _chooseAttLabel.font = FONT(12);
    [self addSubview:_chooseAttLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_crossButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_goodPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_goodImageView.mas_right)setOffset:DCMargin];
        [make.top.mas_equalTo(_goodImageView)setOffset:DCMargin];
    }];
    
    
    [_inventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodPriceLabel);
        make.right.mas_equalTo(_crossButton.mas_left);
        [make.top.mas_equalTo(_goodPriceLabel.mas_bottom)setOffset:5];
    }];
    
    [_chooseAttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_inventoryLabel);
        make.right.mas_equalTo(_crossButton.mas_left);
        [make.top.mas_equalTo(_inventoryLabel.mas_bottom)setOffset:5];
    }];
    
}

- (void)crossButtonClick
{
    !_crossButtonClickBlock ?: _crossButtonClickBlock();
}

#pragma mark - Setter Getter Methods


@end
