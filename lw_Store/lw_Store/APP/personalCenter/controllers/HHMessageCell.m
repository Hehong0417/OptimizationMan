//
//  HHMessageCell.m
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMessageCell.h"

@implementation HHMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupViews];
    }
    return self;
}
- (void)setupViews{
    
    self.meassageLabel = [[UILabel alloc] init];
    self.timeLabel = [[UILabel alloc]init];
    self.meassageLabel.font = FONT(14);
    self.timeLabel.font = FONT(12);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.meassageLabel];
    [self.contentView addSubview:self.timeLabel];
    
    self.meassageLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 5)
    .bottomSpaceToView(self.contentView, 5)
    .widthIs(ScreenW/2);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.meassageLabel, 10)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 5)
    .bottomSpaceToView(self.contentView,5);
}
- (void)setModel:(HHMineModel *)model{
    _model = model;
    self.meassageLabel.text = model.Title;
    self.timeLabel.text = model.AddTime;
    
}
@end
