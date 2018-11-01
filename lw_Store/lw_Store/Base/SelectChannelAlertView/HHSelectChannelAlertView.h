//
//  HHSelectChannelAlertView.h
//  Store
//
//  Created by User on 2018/3/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "LHAlertView.h"

@interface HHSelectChannelAlertView : LHAlertView

@property(nonatomic,strong) UIButton *currentSelectBtn;
@property(nonatomic,strong) NSString *channel;
@property(nonatomic,copy) idBlock commitBlock;
@property(nonatomic,strong) UIButton *close_btn;

- (void)headquartersbtnAction:(UIButton *)btn;
@end
