//
//  HHEvaluationListCell.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHEvaluationListCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "HHCellCommentView.h"
#import "HHAdditionalCommentView.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@implementation HHEvaluationListCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UIImageView *_gradeEmptyImgV;
    UIImageView *_gradeImgV;
    UILabel *_timeLabel;
    UILabel *_propertyLabel;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UIButton *_operationButton;
    HHCellCommentView *_commentView;
    HHAdditionalCommentView *_additionalCommentView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup
{

    _iconView = [UIImageView new];
    [_iconView lh_setCornerRadius:20 borderWidth:0 borderColor:nil];

    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    UIImage *gradeImage = [UIImage imageNamed:@"评价1.png"];
    _gradeEmptyImgV = [[UIImageView alloc] init];
    _gradeEmptyImgV.image = [UIImage imageNamed:@"评价1.png"];
    _gradeEmptyImgV.hidden = YES;
    
    _gradeImgV = [[UIImageView alloc] init];
    _gradeImgV.contentMode = UIViewContentModeLeft;
    _gradeImgV.clipsToBounds = YES;
    _gradeImgV.image = [UIImage imageNamed:@"评价2.png"];
    _gradeImgV.hidden = YES;

    _timeLabel = [UILabel new];
    _timeLabel.textColor = KA0LabelColor;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _propertyLabel = [UILabel new];
    _propertyLabel.textColor = KA0LabelColor;
    _propertyLabel.font = [UIFont systemFontOfSize:13];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _commentView = [HHCellCommentView new];
    
    _additionalCommentView = [HHAdditionalCommentView new];
    
    NSArray *views = @[_iconView, _nameLable,_gradeEmptyImgV,_gradeImgV, _contentLabel, _picContainerView, _timeLabel,_propertyLabel, _commentView,_additionalCommentView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);

    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .centerYEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:100];
    
    _gradeEmptyImgV.sd_layout
    .leftSpaceToView(_nameLable, margin)
    .centerYEqualToView(_nameLable)
    .widthIs(gradeImage.size.width)
    .heightIs(gradeImage.size.height);
    
    _gradeImgV.sd_layout
    .leftSpaceToView(_nameLable, margin)
    .centerYEqualToView(_nameLable)
    .widthIs(0)
    .heightIs(gradeImage.size.height);
    
    _timeLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, margin)
    .widthIs(100)
    .heightIs(20);
    
    _propertyLabel.sd_layout
    .leftSpaceToView(_timeLabel, margin)
    .centerYEqualToView(_timeLabel)
    .widthIs(100)
    .heightIs(20);
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_timeLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 10); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_picContainerView, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
    //追评
    _additionalCommentView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_commentView, 10)
    .rightSpaceToView(contentView, margin);
    
}
- (void)setModel:(HHEvaluationListModel *)model{
    _model = model;
    _iconView.image = [UIImage imageNamed:model.icon_url];
    _nameLable.text = model.name;
    _timeLabel.text = model.dateTime;
    _propertyLabel.text = model.proper;
    _contentLabel.text = model.content;
    _picContainerView.picPathStringsArray = model.imagesModelArray;
    
    NSInteger grade = model.grade.integerValue;
    CGFloat width = _gradeEmptyImgV.frame.size.width/5;
    UIImage *gradeImage = [UIImage imageNamed:@"评价1.png"];
    _gradeImgV.sd_resetLayout
    .leftSpaceToView(_nameLable, 10)
    .centerYEqualToView(_nameLable)
    .widthIs(grade*width)
    .heightIs(gradeImage.size.height);
    
    [_commentView setupWithCommentItems:model.replyContent];
    
    [_additionalCommentView setupAddition_time:model.addition_time addition_comment:model.addition_comment];
    if (model.replyContent.length==0) {
        _additionalCommentView.sd_resetLayout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_picContainerView, 10)
        .rightSpaceToView(self.contentView, 10);
    }else{
        _additionalCommentView.sd_resetLayout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_commentView, 5)
        .rightSpaceToView(self.contentView, 10);
    }

    UIView *bottomView;
    if (model.addition_comment.length == 0&&model.replyContent.length==0) {
        bottomView = _picContainerView;
    }else if (model.addition_comment.length == 0&&model.replyContent.length>0){
        bottomView = _commentView;
    }else if (model.addition_comment.length>0){
        bottomView = _additionalCommentView;

    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];

}

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}
@end
