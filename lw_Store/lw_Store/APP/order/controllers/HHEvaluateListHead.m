//
//  HHEvaluateListHead.m
//  lw_Store
//
//  Created by User on 2018/8/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHEvaluateListHead.h"


@interface HHEvaluateListHead ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    UIImageView *_gradeEmptyImgV;
    UIImageView *_gradeImgV;
    UILabel *_goodEvaluateProportion_label;
    UILabel *_score_label;
}
@end
@implementation HHEvaluateListHead

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _score_label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 40, 25)];
        _score_label.text = @"评分";
        _score_label.font = FONT(14);
        _score_label.textColor = kGrayColor;
        [self addSubview:_score_label];
        
        //星形评价
        UIImage *gradeImage = [UIImage imageNamed:@"stoke_star"];

        _gradeEmptyImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_score_label.frame)+10, 10, gradeImage.size.width, 20)];
        _gradeEmptyImgV.image = [UIImage imageNamed:@"stoke_star"];
        _gradeEmptyImgV.hidden = NO;
        [self addSubview:_gradeEmptyImgV];

        _gradeImgV = [[UIImageView alloc] init];
        _gradeImgV.contentMode = UIViewContentModeLeft;
        _gradeImgV.clipsToBounds = YES;
        _gradeImgV.image = [UIImage imageNamed:@"solid_start"];
        _gradeImgV.hidden = NO;
        [self addSubview:_gradeImgV];

        
        //好评率
        _goodEvaluateProportion_label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gradeEmptyImgV.frame)+10, 10, 100, 25)];
        _goodEvaluateProportion_label.font = FONT(12);
        _goodEvaluateProportion_label.textColor = kGrayColor;
        [self addSubview:_goodEvaluateProportion_label];

        //全部 有图 追评
        NSArray *titles = @[@"全部",@"有图"];
        for (NSInteger i=0; i<2; i++) {
            UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(15+i*70+i*10, CGRectGetMaxY(_score_label.frame)+12, 70, 25) target:self action:@selector(sortBtn:) title:titles[i] titleColor:kGrayColor font:FONT(13) backgroundColor:kClearColor];
            [btn setTitleColor:kRedColor forState:UIControlStateSelected];
            [btn lh_setCornerRadius:0 borderWidth:1 borderColor:kGrayColor];
            btn.tag = 10000+i;
            if (i == 0) {
                [self sortBtn:btn];
            }
            [self addSubview:btn];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.mj_h-1, ScreenW, 1)];
        line.backgroundColor = KVCBackGroundColor;
        [self addSubview:line];

    }
    return self;
}
- (void)setEvaluateStatictis_m:(HHMineModel *)evaluateStatictis_m{
    
    _evaluateStatictis_m = evaluateStatictis_m;
    
    _goodEvaluateProportion_label.text = evaluateStatictis_m.goodEvaluateProportion.integerValue>0?[NSString stringWithFormat:@"%@%%好评",evaluateStatictis_m.goodEvaluateProportion]:@"";
    UIButton *btn1 = [self viewWithTag:10000];
    [btn1 setTitle:[NSString stringWithFormat:@"全部(%@)",evaluateStatictis_m.totalCount] forState:UIControlStateNormal];
    UIButton *btn2 = [self viewWithTag:10001];
    [btn2 setTitle:[NSString stringWithFormat:@"有图(%@)",evaluateStatictis_m.hasImageCount] forState:UIControlStateNormal];
   
    UIImage *gradeImage = [UIImage imageNamed:@"stoke_star"];
    CGFloat w = gradeImage.size.width/5;
    _gradeImgV.frame = CGRectMake(CGRectGetMaxX(_score_label.frame)+10, 10, _evaluateStatictis_m.describeScore.integerValue*w, 20);

}
- (void)sortBtn:(UIButton *)button{
    [button lh_setCornerRadius:0 borderWidth:1 borderColor:kRedColor];
    [self.currentSelectBtn lh_setCornerRadius:0 borderWidth:1 borderColor:kGrayColor];
    self.currentSelectBtn.selected = NO;
    button.selected = YES;
    self.currentSelectBtn = button;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sortBtnSelectedWithSortBtnType:)]) {
        [self.delegate sortBtnSelectedWithSortBtnType:button.tag-10000];
    }
}
@end
