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
@property (strong, nonatomic)  YYTextView *reason_tv;
@property (weak, nonatomic) IBOutlet UILabel *price_label;

@end

@implementation HHApplyRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请退款";
    self.tableView.backgroundColor = KVCBackGroundColor;

    self.price_label.text = [NSString stringWithFormat:@"¥%.2f",self.productModel.price.floatValue*self.productModel.quantity.integerValue];
    
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
        self.reason_tv = [[YYTextView alloc] initWithFrame:CGRectMake(16, 26, 340, 150)];
        [self.reason_tv  lh_setCornerRadius:5 borderWidth:1 borderColor:kBlackColor];
        self.reason_tv.placeholderText = @"请输入您的退款原因...";
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
- (IBAction)addbuttonAction:(UIButton *)sender {
    
    NSInteger value = self.quantity_tf.text.integerValue;
    if (value == self.productModel.quantity.integerValue) {
        return;
    }
    self.quantity_tf.text = [NSString stringWithFormat:@"%ld",value++];
    self.price_label.text = [NSString stringWithFormat:@"¥%.2f",self.productModel.price.floatValue*self.quantity_tf.text.integerValue];

}
- (IBAction)minusBtnAction:(UIButton *)sender {
    
    NSInteger value = self.quantity_tf.text.integerValue;
    if (value == 1) {
        return;
    }
    self.quantity_tf.text = [NSString stringWithFormat:@"%ld",value--];
    self.price_label.text = [NSString stringWithFormat:@"¥%.2f",self.productModel.price.floatValue*self.quantity_tf.text.integerValue];

}
- (void)commitAction:(UIButton *)btn{
    
    [[[HHMineAPI postConfirmOrderWithorderid:self.order_id orderItemId:self.productModel.item_id quantity:self.quantity_tf.text comments:self.reason_tv.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (api.State == 1) {

            [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
            if (self.applyRefund_block) {
                self.applyRefund_block();
            }
            [self.navigationController popVC];
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }

    }];
    
}

@end
