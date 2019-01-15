//
//  HHEvaluteStarCell.m
//  lw_Store
//  Created by User on 2018/5/2.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHEvaluteStarCell.h"

@implementation HHEvaluteStarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        //描述相符
        UILabel *left_discrib_lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, AdapationLabelHeight(80), AdapationLabelHeight(45)) text:@"描述相符" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self.contentView addSubview:left_discrib_lab];
        
        //CDPStarEvaluation星形评价
        self.starEvaluation=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(CGRectGetMaxX(left_discrib_lab.frame),0,ScreenW-AdapationLabelHeight(80),AdapationLabelHeight(45)) onTheView:self.contentView];
        self.starEvaluation.delegate=self;
        
//        self.discrib_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(left_discrib_lab.frame)+AdapationLabelHeight(160), 0, AdapationLabelHeight(80), AdapationLabelHeight(45)) text:@"" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
//        [self.contentView addSubview:self.discrib_lab];
        
        //物流服务
        UILabel *left_logistics_lab = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(left_discrib_lab.frame), AdapationLabelHeight(80), AdapationLabelHeight(45)) text:@"物流服务" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self.contentView addSubview:left_logistics_lab];
        
//        self.logistics_lab = [UILabel lh_labelWithFrame:CGRectMake(self.discrib_lab.frame.origin.x, CGRectGetMaxY(self.discrib_lab.frame), AdapationLabelHeight(80), AdapationLabelHeight(45)) text:@"" textColor:kGrayColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
//        [self.contentView addSubview:self.logistics_lab];
        
        //CDPStarEvaluation
        self.starEvaluation2=[[CDPStarEvaluation alloc] initWithFrame:CGRectMake(CGRectGetMaxX(left_logistics_lab.frame),CGRectGetMaxY(left_discrib_lab.frame),ScreenW-AdapationLabelHeight(80),AdapationLabelHeight(45)) onTheView:self.contentView];
        self.starEvaluation2.delegate= self;
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


@end
