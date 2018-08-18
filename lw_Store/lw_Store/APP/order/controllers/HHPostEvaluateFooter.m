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
        
        
        UIImageView *order_evaluate_ico = [UIImageView lh_imageViewWithFrame:CGRectMake(15,10, 40, 40) image:[UIImage imageNamed:@"order_icon"]];
        order_evaluate_ico.contentMode = UIViewContentModeCenter;
        [self addSubview:order_evaluate_ico];
        
        //订单评价
        UILabel *order_evaluate_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(order_evaluate_ico.frame), 0, WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"订单评价" textColor:kBlackColor font:FONT(15) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self addSubview:order_evaluate_lab];
        
        //好评 中评 差评 bg_view
        UIView *grageView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(order_evaluate_lab.frame)+10, ScreenW-40, 30)];
        [self addSubview:grageView];
       
        [self addBtns:grageView];
        
        //描述相符
        UILabel *left_discrib_lab = [UILabel lh_labelWithFrame:CGRectMake(15, CGRectGetMaxY(grageView.frame), WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"物流服务" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self addSubview:left_discrib_lab];
        
        //CDPStarEvaluation星形评价
        self.starEvaluation=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(CGRectGetMaxX(left_discrib_lab.frame),CGRectGetMaxY(grageView.frame),ScreenW-WidthScaleSize_W(80),WidthScaleSize_H(45)) onTheView:self];
        self.starEvaluation.delegate=self;
        
        //        self.discrib_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(left_discrib_lab.frame)+WidthScaleSize_W(160), 0, WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        //        [self.contentView addSubview:self.discrib_lab];
        
        //物流服务
        UILabel *left_logistics_lab = [UILabel lh_labelWithFrame:CGRectMake(15, CGRectGetMaxY(left_discrib_lab.frame), WidthScaleSize_W(80), WidthScaleSize_H(45)) text:@"服务态度" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
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
- (void)theCurrentCommentText:(NSString *)commentText starEvaluation:(id)starEvaluation{

    NSNumber *describeScore =  ((CDPStarEvaluation *)starEvaluation).grade;
    
    HHPostOrderEvaluateItem *oEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
    
    if(starEvaluation == self.starEvaluation){

        oEvaluateItem.logisticsScore = describeScore;

    }else if(starEvaluation == self.starEvaluation2){

        oEvaluateItem.serviceScore = describeScore;
    }
    [oEvaluateItem write];
}
//发布评价
- (void)pushEvulation:(UIButton *)btn{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postEvaluateBtnClick:)]) {
        [self.delegate postEvaluateBtnClick:btn];
    }
}
- (void)addBtns:(UIView *)grageView{
    
    NSArray *images = @[@"good",@"bad",@"bad"];
    NSArray *select_images = @[@"good_select",@"bad_select",@"bad_select"];

    NSArray *titles = @[@"好评",@"中评",@"差评"];
    CGFloat grageView_w = grageView.mj_w;
    for (NSInteger i = 0; i<3; i++) {
        UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(i*grageView_w/3, 0, 65, 30) target:self action:@selector(gradeBtnAction:) image:[UIImage imageNamed:images[i]] title:titles[i]  titleColor:kBlackColor font:FONT(14)];
        [btn setImage:[UIImage imageNamed:select_images[i]] forState:UIControlStateSelected];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        btn.tag = 10000+i;
        if (i==0) {
            [self gradeBtnAction:btn];
        }
        [grageView addSubview:btn];
    }
    
}
- (void)gradeBtnAction:(UIButton *)gradeBtn{
    
    self.currentSelectBtn.selected = NO;
    gradeBtn.selected = YES;
    self.currentSelectBtn = gradeBtn;
    HHPostOrderEvaluateItem *oEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
    oEvaluateItem.level = [NSNumber numberWithInteger:gradeBtn.tag-9999];
    [oEvaluateItem write];
}
@end
