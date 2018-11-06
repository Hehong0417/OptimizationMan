//
//  HHApplyRefundVC.m
//  lw_Store
//
//  Created by User on 2018/5/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHApplyRefundVC.h"

@interface HHApplyRefundVC ()
@property (weak, nonatomic) IBOutlet UITextField *quantity_tf;
@property (weak, nonatomic) IBOutlet UIImageView *tick_imgv;
@property (strong, nonatomic)  UITextView *reason_tv;
@property (weak, nonatomic) IBOutlet UILabel *price_label;

@end

@implementation HHApplyRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.nav_title;
    self.tableView.backgroundColor = KVCBackGroundColor;
   
    
    self.price_label.text = [NSString stringWithFormat:@"¥%.2 f",self.price.floatValue*self.count.integerValue];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 60, 45) target:self action:@selector(commitAction:) backgroundImage:nil title:@"提  交"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = kBlackColor;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableView.tableFooterView = footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 2) {
        self.reason_tv = [[UITextView alloc] initWithFrame:CGRectMake(16, 26, ScreenW-32, 150)];
        [self.reason_tv  lh_setCornerRadius:5 borderWidth:1 borderColor:kBlackColor];
        [cell.contentView addSubview:self.reason_tv];
        
    }else{
        
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = KA0LabelColor;
    header.textLabel.font = FONT(15);
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.title_str;
    }else if (section == 1){
        return @"退款方式";
    }else{
    return @"退款原因";
    }
}

- (IBAction)addbuttonAction:(UIButton *)sender {
    
    NSInteger value = self.quantity_tf.text.integerValue;
    if (value == self.count.integerValue) {
        return;
    }
    self.quantity_tf.text = [NSString stringWithFormat:@"%ld",value++];
    self.price_label.text = [NSString stringWithFormat:@"¥%.2f",self.price.floatValue*self.quantity_tf.text.integerValue];

}
- (IBAction)minusBtnAction:(UIButton *)sender {
    
    NSInteger value = self.quantity_tf.text.integerValue;
    if (value == 1) {
        return;
    }
    self.quantity_tf.text = [NSString stringWithFormat:@"%ld",value--];
    self.price_label.text = [NSString stringWithFormat:@"¥%.2f",self.price.floatValue*self.quantity_tf.text.integerValue];

}
- (void)commitAction:(UIButton *)btn{
    
    [[[HHMineAPI postConfirmOrderWithorderid:self.order_id orderItemId:self.item_id quantity:self.quantity_tf.text comments:self.reason_tv.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (api.State == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(backActionWithBtn:)]) {
                [self.navigationController popVC];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }

    }];
    
}

@end
