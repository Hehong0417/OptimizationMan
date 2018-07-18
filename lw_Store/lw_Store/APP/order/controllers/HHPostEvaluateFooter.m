//
//  HHPostEvaluateFooter.m
//  lw_Store
//
//  Created by User on 2018/7/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPostEvaluateFooter.h"

@implementation HHPostEvaluateFooter

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //描述相符
        UILabel *left_discrib_lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"描述相符" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self addSubview:left_discrib_lab];
        
        //CDPStarEvaluation星形评价
        self.starEvaluation=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(CGRectGetMaxX(left_discrib_lab.frame),0,ScreenW-WidthScaleSize_W(80),WidthScaleSize_H(45)) onTheView:self];
        self.starEvaluation.delegate=self;
        
        //        self.discrib_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(left_discrib_lab.frame)+WidthScaleSize_W(160), 0, WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        //        [self.contentView addSubview:self.discrib_lab];
        
        //物流服务
        UILabel *left_logistics_lab = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(left_discrib_lab.frame), WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"物流服务" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self addSubview:left_logistics_lab];
        
        //        self.logistics_lab = [UILabel lh_labelWithFrame:CGRectMake(self.discrib_lab.frame.origin.x, CGRectGetMaxY(self.discrib_lab.frame), WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        //        [self.contentView addSubview:self.logistics_lab];
        
        //CDPStarEvaluation
        self.starEvaluation2=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(CGRectGetMaxX(left_logistics_lab.frame),CGRectGetMaxY(left_discrib_lab.frame),ScreenW-WidthScaleSize_W(80),WidthScaleSize_H(45)) onTheView:self];
        self.starEvaluation2.delegate= self;
        
        UIButton *addAddressBtn = [UIButton lh_buttonWithFrame:CGRectMake(60, CGRectGetMaxY(left_logistics_lab.frame)+20, SCREEN_WIDTH-120, WidthScaleSize_H(35)) target:self action:@selector(pushEvulation:) image:nil];
        [addAddressBtn setBackgroundColor:kBlackColor];
        [addAddressBtn setTitle:@"发布评价" forState:UIControlStateNormal];
        [addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [addAddressBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        [self addSubview:addAddressBtn];
        
    }
    
    return self;
}
-(void)theCurrentCommentText:(NSString *)commentText starEvaluation:(id)starEvaluation{
    
    if(starEvaluation == self.starEvaluation){
        
        self.discrib_lab.text = commentText;
        
    }else if(starEvaluation == self.starEvaluation){
        
        self.logistics_lab.text = commentText;
        
    }
}
//发布评价
- (void)pushEvulation:(UIButton *)btn{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postEvaluateBtnClick:)]) {
        [self.delegate postEvaluateBtnClick:btn];
    }
}
@end
