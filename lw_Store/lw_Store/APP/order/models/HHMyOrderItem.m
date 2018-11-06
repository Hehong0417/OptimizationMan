//
//  HHMyOrderItem.m
//  Store
//
//  Created by User on 2018/3/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyOrderItem.h"
#import "HHApplyRefundVC.h"
#import "HHLogisticsVC.h"
#import "HHFillLogisticsVC.h"

@implementation HHMyOrderItem

+ (void)shippingLogisticsStateWithStatus_code:(NSInteger)status_code cell:(HJOrderCell *)cell{
    cell.StandardLab.userInteractionEnabled = YES;
    if (status_code == 6) {
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退款申请中 ";
        cell.StandardLab.userInteractionEnabled = NO;
    }else if (status_code == 7){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退货申请中 ";
        cell.StandardLab.userInteractionEnabled = NO;
    }else if (status_code == 9){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退款成功 ";
    }else if(status_code == 10){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退货成功 ";
    }else if(status_code == 13){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        cell.StandardLab.text = @" 填写物流单号";
    }else if(status_code == 14){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        cell.StandardLab.text = @" 查看退货物流 ";
    }else if(status_code == 2){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];

        cell.StandardLab.text = @" 申请退款 ";
    }else if(status_code == 3){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        cell.StandardLab.text = @" 申请退货 ";
    }else{
        cell.StandardLab.text = @"";
        cell.StandardLab.hidden = YES;
        cell.StandardLab.userInteractionEnabled = NO;
    }
}
+ (void)shippingLogisticsStateWithStatus_code:(NSInteger)status_code submitCell:(HHSubmitOrderCell *)cell{
    
    cell.StandardLab.userInteractionEnabled = YES;
    if (status_code == 6) {
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退款申请中 ";
        cell.StandardLab.userInteractionEnabled = NO;
    }else if (status_code == 7){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退货申请中 ";
        cell.StandardLab.userInteractionEnabled = NO;
    }else if (status_code == 9){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退款成功 ";
    }else if(status_code == 10){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.StandardLab.text = @" 退货成功 ";
    }else if(status_code == 13){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        cell.StandardLab.text = @" 填写物流单号";
    }else if(status_code == 14){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        cell.StandardLab.text = @" 查看退货物流 ";
    }else if(status_code == 2){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        
        cell.StandardLab.text = @" 申请退款 ";
    }else if(status_code == 3){
        [cell.StandardLab lh_setCornerRadius:5 borderWidth:1 borderColor:KA0LabelColor];
        cell.StandardLab.text = @" 申请退货 ";
    }else{
        cell.StandardLab.text = @"";
        cell.StandardLab.hidden = YES;
        cell.StandardLab.userInteractionEnabled = NO;
    }
    
}

+ (CGFloat)rowHeightWithRow:(NSInteger)row Products_count:(NSInteger )products_count{
    
    if (row == products_count){
        //商品
        return 44;
    }else {
        return 85;
    }
}
+ (void)pushVCWithStatus_code:(NSInteger)status_code navC:(UINavigationController *)navC VC:(UIViewController *)vc product_m:(HHproducts_item_Model *)product_m order_id:(NSString *)order_id{
    
    if (status_code == 6) {
//        退款申请中
    }else if (status_code == 7){
//        退货申请中
    }else if (status_code == 9){
//        退款成功
    }else if(status_code == 10){
//        退货成功
    }else if(status_code == 13){
//        填写物流单号
        HHFillLogisticsVC *fill_vc = [HHFillLogisticsVC new];
        fill_vc.orderid = order_id;
        fill_vc.product_item_refund_id = product_m.product_item_refund_id;
        fill_vc.return_numb_block = ^(NSNumber *result) {
        
        };
        [navC pushVC:fill_vc];
    }else if(status_code == 14){
//        查看退货物流
        HHLogisticsVC *log_vc = [HHLogisticsVC new];
        log_vc.refundId = product_m.product_item_refund_id;
//        log_vc.express_order = product_m.return_goods_express_order;
//        log_vc.express_name = product_m.return_goods_express_name;
        log_vc.type = @2;
        [navC pushVC:log_vc];
    }else if(status_code == 2){
//        申请退款
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
        HHApplyRefundVC *refunVc = [board instantiateViewControllerWithIdentifier:@"HHApplyRefundVC"];
        refunVc.delegate = vc;
        refunVc.item_id = product_m.product_item_id;
        refunVc.order_id = order_id;
        refunVc.count = product_m.product_item_quantity;
        refunVc.price = product_m.product_item_price;
        refunVc.title_str = product_m.prodcut_name;
        refunVc.nav_title = @"申请退款";
        [navC pushVC:refunVc];

    }else if(status_code == 3){
//       申请退货
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
        HHApplyRefundVC *refunVc = [board instantiateViewControllerWithIdentifier:@"HHApplyRefundVC"];
        refunVc.delegate = vc;
        refunVc.item_id = product_m.product_item_id;
        refunVc.order_id = order_id;
        refunVc.count = product_m.product_item_quantity;
        refunVc.price = product_m.product_item_price;
        refunVc.title_str = product_m.prodcut_name;
        refunVc.nav_title = @"申请退货";
        [navC pushVC:refunVc];
        
    }else{
  
    }
}
+ (void)orderDetailpushVCWithStatus_code:(NSInteger)status_code navC:(UINavigationController *)navC VC:(UIViewController *)vc product_m:(HHproductsModel *)product_m order_id:(NSString *)order_id{
    
    if (status_code == 6) {
        //        退款申请中
    }else if (status_code == 7){
        //        退货申请中
    }else if (status_code == 9){
        //        退款成功
    }else if(status_code == 10){
        //        退货成功
    }else if(status_code == 13){
        //        填写物流单号
        HHFillLogisticsVC *fill_vc = [HHFillLogisticsVC new];
        fill_vc.orderid = order_id;
        fill_vc.product_item_refund_id = product_m.RefundId;
        fill_vc.return_numb_block = ^(NSNumber *result) {
            
        };
        [navC pushVC:fill_vc];
    }else if(status_code == 14){
        //        查看退货物流
        
        HHLogisticsVC *log_vc = [HHLogisticsVC new];
        log_vc.refundId = product_m.RefundId;
        //        log_vc.express_order = product_m.return_goods_express_order;
        //        log_vc.express_name = product_m.return_goods_express_name;
        
        log_vc.type = @1;
        [navC pushVC:log_vc];
    }else if(status_code == 2){
        //        申请退款
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
        HHApplyRefundVC *refunVc = [board instantiateViewControllerWithIdentifier:@"HHApplyRefundVC"];
        refunVc.delegate = vc;
        refunVc.item_id = product_m.item_id;
        refunVc.order_id = order_id;
        refunVc.count = product_m.quantity;
        refunVc.price = product_m.price;
        refunVc.title_str = product_m.pname;
        refunVc.nav_title = @"申请退款";
        [navC pushVC:refunVc];
        
    }else if(status_code == 3){
        //       申请退货
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
        HHApplyRefundVC *refunVc = [board instantiateViewControllerWithIdentifier:@"HHApplyRefundVC"];
        refunVc.delegate = vc;
        refunVc.item_id = product_m.item_id;
        refunVc.order_id = order_id;
        refunVc.count = product_m.quantity;
        refunVc.price = product_m.price;
        refunVc.title_str = product_m.pname;
        refunVc.nav_title = @"申请退货";
        [navC pushVC:refunVc];
        
    }else{
        
    }
}
@end
