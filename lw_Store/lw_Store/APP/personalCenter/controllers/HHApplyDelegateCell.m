//
//  HHApplyDelegateCell.m
//  lw_Store
//
//  Created by User on 2018/5/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHApplyDelegateCell.h"

@implementation HHApplyDelegateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.delegate_btn lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
    
    [self.delegate_btn  lh_setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
    [self.delegate_btn setTitleColor:KTitleLabelColor forState:UIControlStateNormal];
    
    [self.delegate_btn  lh_setBackgroundColor:kBlackColor forState:UIControlStateSelected];
    [self.delegate_btn setTitleColor:kWhiteColor forState:UIControlStateSelected];
}
- (IBAction)delegateAction:(UIButton *)sender {
    
//    if (self.delegate_btnSelectAction) {
//    self.delegate_btnSelectAction(self.indexPath, sender.selected);
//    }
    
}
- (void)setBtn_selected:(BOOL)btn_selected{
    
    _btn_selected = btn_selected;
    self.delegate_btn.selected = btn_selected;
    if (btn_selected) {
        [self.delegate_btn  lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        self.price_label.textColor = kRedColor;
    }else{
        [self.delegate_btn  lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        self.price_label.textColor = kBlackColor;
    }
}
- (void)setModel:(HHMineModel *)model{
    _model = model;
   
    [self.delegate_btn setTitle:model.AgentName forState:UIControlStateNormal];
    self.price_label.text = [NSString stringWithFormat:@"¥%@", model.JoinMoney];
}

@end
