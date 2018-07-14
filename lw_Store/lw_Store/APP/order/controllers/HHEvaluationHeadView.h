//
//  HHEvaluationHeadView.h
//  lw_Store
//
//  Created by User on 2018/5/2.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHEvaluationHeadView : UICollectionReusableView

@property(nonatomic,strong)   UINavigationController *nav;

@property(nonatomic,strong)   NSArray *btn_titles;

@property(nonatomic,assign)   BOOL isPay;

@property(nonatomic,strong)   UILabel *success_lab;

@property(nonatomic,strong)   UILabel *title_lab;


@end
