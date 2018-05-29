//
//  HHCellCommentView.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCellCommentView.h"


@interface HHCellCommentView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation HHCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
        self.backgroundColor = kGreenColor;
    }
    return self;
}
- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _bgImageView.image = bgImage;
    [self addSubview:_bgImageView];
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _commentLabel = [UILabel new];
    _commentLabel.font = FONT(13);
    _commentLabel.textColor = kGrayColor;
    [self addSubview:_commentLabel];
    
    _commentLabel.sd_layout
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .topSpaceToView(self, 10)
    .autoHeightRatio(0);
    
}
- (void)setupWithCommentItems:(NSString *)commentItems{
    
    if (commentItems.length>0) {
        self.fixedHeight = nil;
        self.fixedWidth = nil;
        _commentLabel.text = [NSString stringWithFormat:@"店家回复：%@",commentItems];
        
    }else{
        _commentLabel.text = nil;
        self.height = 0;
        self.fixedHeight = @(0);
        self.fixedWidth = @(0);
        
        return;
    }
    [self setupAutoHeightWithBottomView:_commentLabel bottomMargin:6];

}
@end
