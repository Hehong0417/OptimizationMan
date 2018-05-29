//
//  HHAdditionalCommentView.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAdditionalCommentView.h"

@interface HHAdditionalCommentView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation HHAdditionalCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
    }
    return self;
}
- (void)setupViews
{
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = kRedColor;
    _titleLabel.text = @"追评";
    _titleLabel.font = FONT(13);
    [self addSubview:_titleLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = FONT(10);
    _timeLabel.textColor = KA0LabelColor;
    [self addSubview:_timeLabel];
    
    _commentLabel = [UILabel new];
    _commentLabel.font = FONT(13);
    _commentLabel.textColor = kGrayColor;
    [self addSubview:_commentLabel];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self, 1)
    .rightSpaceToView(self, 1)
    .topSpaceToView(self, 5)
    .heightIs(15);
    
    _timeLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 5)
    .rightSpaceToView(self, 1)
    .heightIs(15);
    
    _commentLabel.sd_layout
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .topSpaceToView(_timeLabel, 5)
    .autoHeightRatio(0);
    
}
- (void)setupAddition_time:(NSString *)addition_time addition_comment:(NSString *)addition_comment{
    
    if (addition_comment.length == 0) {
        _timeLabel.text = nil;
        _commentLabel.text = nil;
        _titleLabel.text = nil;
        self.height = 0;
        self.fixedHeight = @(0);
        self.fixedWidth = @(0);
    }else{
        self.fixedHeight = nil;
        self.fixedWidth = nil;
        _titleLabel.text = @"追评";
        _titleLabel.sd_layout.heightIs(15);
        _timeLabel.sd_layout.heightIs(15);
        _timeLabel.text = addition_time;
        _commentLabel.text = addition_comment;
    }
    [self setupAutoHeightWithBottomView:_commentLabel bottomMargin:6];

}


@end
