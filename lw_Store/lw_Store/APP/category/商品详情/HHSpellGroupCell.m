//
//  HHSpellGroupCell.m
//  springDream
//
//  Created by User on 2018/9/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSpellGroupCell.h"

@implementation HHSpellGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.icon_imagV = [UIImageView new];
        self.icon_imagV.image = [UIImage imageNamed:@"icon0"];
        self.name_label = [UILabel new];
        self.name_label.text = @"";
        self.name_label.font = FONT(14);
        
        self.personNumber_label = [UILabel new];
        self.personNumber_label.font = FONT(12);
        self.personNumber_label.text = @"";
        self.personNumber_label.textAlignment = NSTextAlignmentRight;
        
        self.spellGroup_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.spellGroup_button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.spellGroup_button setTitle:@"去拼团" forState:UIControlStateNormal];
        self.spellGroup_button.titleLabel.font = FONT(13);
        [self.spellGroup_button setBackgroundColor:APP_COMMON_COLOR];
        [self.spellGroup_button lh_setCornerRadius:2 borderWidth:0 borderColor:nil];
        
        
        [self.contentView addSubview:self.icon_imagV];
        [self.contentView addSubview:self.name_label];
        [self.contentView addSubview:self.personNumber_label];
        [self.contentView addSubview:self.spellGroup_button];

        [self addConstaint];
    }
    
    return self;
    
}
- (void)addConstaint{
    
    self.icon_imagV.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .widthIs(40)
    .heightIs(40)
    .centerYEqualToView(self.contentView);
    
    self.name_label.sd_layout
    .leftSpaceToView(self.icon_imagV, 10)
    .widthIs(130)
    .heightIs(20)
    .centerYEqualToView(self.contentView);
    
    self.spellGroup_button.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .widthIs(60)
    .heightIs(25)
    .centerYEqualToView(self.contentView);
    
    self.personNumber_label.sd_layout
    .rightSpaceToView(self.spellGroup_button, 10)
    .leftSpaceToView(self.name_label, 10)
    .heightIs(20)
    .centerYEqualToView(self.contentView);
    
    [self.icon_imagV lh_setRoundImageViewWithBorderWidth:1 borderColor:kLightGrayColor];

}
- (void)setModel:(HHJoinActivityModel *)model{
    
    _model = model;
    
    [self.icon_imagV sd_setImageWithURL:[NSURL URLWithString:model.user_icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    self.name_label.text = model.user_name;
    self.personNumber_label.text = [NSString stringWithFormat:@"还差%@人拼成",model.remain_count];
}
@end
