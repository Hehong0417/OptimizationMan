//
//  HHEvaluationHeadView.m
//  lw_Store
//
//  Created by User on 2018/5/2.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHEvaluationHeadView.h"
#import "HHEvaluationListVC.h"
#import "HHGoodListVC.h"
#import "HHOrderVC.h"

@implementation HHEvaluationHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
    
        UIImageView *success_imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, AdapationLabelHeight(50), 150, AdapationLabelHeight(80)) image:[UIImage imageNamed:@"icon_paysuccess_default"]];
        success_imageV.contentMode = UIViewContentModeCenter;
        success_imageV.centerX = self.centerX;
        [self addSubview:success_imageV];
        self.success_lab = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(success_imageV.frame), 150, AdapationLabelHeight(30)) text:@"评价成功" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
        self.success_lab.centerX = self.centerX;

        [self addSubview:self.success_lab];
      
        //按钮
        for(NSInteger i =0;i<2;i++){
            CGFloat btn_W = (ScreenW - 2*AdapationLabelHeight(40) - AdapationLabelHeight(35))/2;
            UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(AdapationLabelHeight(40)+(btn_W+AdapationLabelHeight(35))*i, CGRectGetMaxY(self.success_lab.frame)+WidthScaleSize_H(40), btn_W, AdapationLabelHeight(35)) target:self action:@selector(evaluateAction:) title:self.btn_titles[i] titleColor:kWhiteColor font:FONT(14) backgroundColor:kBlackColor];
            [btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
            btn.tag = i+1000;
            [self addSubview:btn];
        }
        //活动
        self.actView = [[HHActivityView alloc] initWithFrame:CGRectMake(0, frame.size.height- AdapationLabelHeight(140)-AdapationLabelHeight(10) -AdapationLabelHeight(50), ScreenW, AdapationLabelHeight(150))];
        [self addSubview:self.actView];
        
        //猜你喜欢
        self.title_lab = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.actView.frame)+AdapationLabelHeight(10), ScreenW, AdapationLabelHeight(40)) text:@"——  猜你喜欢  ——"  textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self addSubview:self.title_lab];
     
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(!self.giftModel.is_exist.boolValue){
        self.actView.frame = CGRectMake(0, 0, 0, 0);
        self.actView.hidden = YES;
    }else{
        self.actView.gift_Model = self.giftModel;
    }
}
- (void)setGiftModel:(HHCategoryModel *)giftModel{
    
    _giftModel = giftModel;
}

- (void)setIsPay:(BOOL)isPay{
    _isPay = isPay;
    
    if (isPay) {
        self.success_lab.text = @"支付成功";
        UIButton *btn0 = (UIButton *)[self viewWithTag:1000];
        [btn0 setTitle:@"去逛逛" forState:UIControlStateNormal];
        UIButton *btn1 = (UIButton *)[self viewWithTag:1001];
        [btn1 setTitle:@"查看订单" forState:UIControlStateNormal];
    }else{
        self.success_lab.text = @"评价成功";
        UIButton *btn0 = (UIButton *)[self viewWithTag:1000];
        [btn0 setTitle:@"去逛逛" forState:UIControlStateNormal];
        UIButton *btn1 = (UIButton *)[self viewWithTag:1001];
        [btn1 setTitle:@"查看我的评价" forState:UIControlStateNormal];
    }
}
- (NSArray *)btn_titles{
    if(!_btn_titles){
        _btn_titles = @[@"去逛逛",@"查看我的评价"];
    }
    return _btn_titles;
}
- (void)evaluateAction:(UIButton *)btn{
    
    if(btn.tag == 1000){
        //去逛逛
        HHGoodListVC  *vc = [HHGoodListVC new];
        vc.enter_Type = HHenter_itself_Type;
        [self.nav pushVC:vc];
    }else{
        if (self.isPay) {
            //查看我的订单
            HHOrderVC  *vc = [HHOrderVC new];
            [self.nav pushVC:vc];
        }else{
            HHEvaluationListVC *vc = [HHEvaluationListVC new];
            vc.pid = self.pid;
            [self.nav pushVC:vc];
        }
    }
    
}
@end
