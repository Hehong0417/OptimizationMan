//
//  HHCartFootView.m
//  Store
//
//  Created by User on 2017/12/30.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHCartFootView.h"

@implementation HHCartFootView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.selectBtn setImage:[UIImage imageNamed:@"icon_sign_default"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
    
}


- (IBAction)selectBtnAction:(UIButton *)sender {
    
    self.selectBtn.selected = !self.selectBtn.selected;
    NSNumber *selected = [NSNumber numberWithBool:sender.selected];
    self.allChooseBlock(selected);
}

@end
