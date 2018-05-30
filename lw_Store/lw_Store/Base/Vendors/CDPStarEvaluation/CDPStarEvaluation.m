//
//  CDPStarEvaluation.m
//  CDPStarEvaluation
//
//  Created by MAC on 15/4/20.
//  Copyright (c) 2015年 com.xuezi.CDP. All rights reserved.
//

#import "CDPStarEvaluation.h"

@implementation CDPStarEvaluation

-(id)initWithFrame:(CGRect)frame onTheView:(UIView *)view{
    if (self=[super init]) {
        _commentText=@"无";
        //空星级imageView
        UIImage *starEmptyImag = [UIImage imageNamed:@"stoke_star"];
        _starEmptyImageView=[[UIImageView alloc] initWithImage:starEmptyImag];
        _starEmptyImageView.frame = CGRectMake(frame.origin.x, frame.origin.y,starEmptyImag.size.width, frame.size.height);
        _starEmptyImageView.contentMode=UIViewContentModeLeft;
        _starEmptyImageView.userInteractionEnabled=YES;
        
        [view addSubview:_starEmptyImageView];
        //满星级imageView(之前等比例适配出现问题，因为赶时间，采用了以下解决方法适配...)
        _starImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"solid_start"]];
        _starImageView.frame=CGRectMake(frame.origin.x,frame.origin.y,0,frame.size.height);
        _starImageView.contentMode=UIViewContentModeLeft;
        _starImageView.clipsToBounds=YES;
        [view addSubview:_starImageView];
        //单击手势
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [_starEmptyImageView addGestureRecognizer:tapGR];
        //拖动手势
        UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)];
        [_starEmptyImageView addGestureRecognizer:panGR];
    }
    
    return self;
}

#pragma mark 手势
//单击手势
-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint tapPoint=[tapGR locationInView:_starEmptyImageView];
    _width=tapPoint.x/_starEmptyImageView.bounds.size.width;
    
    if (_width<=1/5.0) {
        //差
        _commentText=@"差";
    _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width/5,_starEmptyImageView.bounds.size.height);

    }
    else if(_width<=2/5.0&&_width>1/5.0){
        //一般
        _commentText=@"一般";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*2/5,_starEmptyImageView.bounds.size.height);

    }
    else if(_width<=3/5.0&&_width>2/5.0){
        //好
    _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*3/5,_starEmptyImageView.bounds.size.height);

        _commentText=@"好";
    }
    else if(_width<=4/5.0&&_width>3/5.0){
        //很好
        _commentText=@"很好";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*4/5,_starEmptyImageView.bounds.size.height);

    }
    else{
        //非常好
        _commentText=@"非常好";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*5/5,_starEmptyImageView.bounds.size.height);

    }
    
    if (_delegate) {
        [_delegate theCurrentCommentText:_commentText starEvaluation:self];
    }
}
//拖动手势
- (void)panGR:(UIPanGestureRecognizer *)panGR
{
    CGPoint panPoint = [panGR locationInView:_starEmptyImageView];
    if (panPoint.x<0||panPoint.x>_starEmptyImageView.bounds.size.width) {
        return;
    }
    _width=panPoint.x/_starEmptyImageView.bounds.size.width;
    
    
    if (_width<=1/5.0) {
        //差
        _commentText=@"差";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*1/5,_starEmptyImageView.bounds.size.height);

    }
    else if(_width<=2/5.0&&_width>1/5.0){
        //一般
        _commentText=@"一般";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*2/5,_starEmptyImageView.bounds.size.height);

    }
    else if(_width<=3/5.0&&_width>2/5.0){
        //好
        _commentText=@"好";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*3/5,_starEmptyImageView.bounds.size.height);

    }
    else if(_width<=4/5.0&&_width>3/5.0){
        //很好
        _commentText=@"很好";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*4/5,_starEmptyImageView.bounds.size.height);

    }
    else{
        //非常好
        _commentText=@"非常好";
        _starImageView.frame=CGRectMake(_starEmptyImageView.frame.origin.x,_starEmptyImageView.frame.origin.y,_starEmptyImageView.bounds.size.width*5/5,_starEmptyImageView.bounds.size.height);
    }
    
    if (_delegate) {
        [_delegate theCurrentCommentText:_commentText starEvaluation:self];
    }
}







@end
