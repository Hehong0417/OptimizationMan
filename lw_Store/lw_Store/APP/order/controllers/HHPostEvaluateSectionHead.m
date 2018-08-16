//
//  HHPostEvaluateSectionHead.m
//  lw_Store
//
//  Created by User on 2018/8/16.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPostEvaluateSectionHead.h"

@implementation HHPostEvaluateSectionHead

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        self.product_imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(10), WidthScaleSize_H(10), WidthScaleSize_H(65), WidthScaleSize_H(65)) image:nil];
        self.product_imageV.backgroundColor = KVCBackGroundColor;
        [self addSubview:self.product_imageV];
        
        UILabel *title_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(self.product_imageV.frame)+WidthScaleSize_W(10), WidthScaleSize_H(10), 60, WidthScaleSize_H(45)) text:@"描述相符" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        title_lab.centerY = self.centerY;
        [self addSubview:title_lab];
        
        //CDPStarEvaluation星形评价
        self.starEvaluation=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title_lab.frame)+25,title_lab.mj_y,ScreenW-WidthScaleSize_W(80),WidthScaleSize_H(45)) onTheView:self];
        self.starEvaluation.delegate=self;
        
    }
    return self;
}

- (void)theCurrentCommentText:(NSString *)commentText starEvaluation:(id)starEvaluation{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getEvaluateLevel:)]) {
        [self.delegate getEvaluateLevel:((CDPStarEvaluation *)starEvaluation).grade];
    }
}
@end
