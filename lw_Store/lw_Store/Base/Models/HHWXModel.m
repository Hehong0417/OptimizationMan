//
//  HHWXModel.m
//  CredictCard
//
//  Created by User on 2018/3/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWXModel.h"

@implementation HHWXModel

+ (void)payReqWithModel:(HHWXModel *)model{
    
    //微信支付
    PayReq * req = [[PayReq alloc] init];
    req.partnerId           = model.partnerId;
    req.prepayId            = model.prepayId;
    req.nonceStr            = model.nonceStr;
    NSString *timeStamp = model.timeStamp;
    req.timeStamp           = timeStamp.intValue;
    req.package             = model.package;
    req.sign                = model.paySign;
    BOOL success =  [WXApi sendReq:req];
    //日志输出
    DLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\n sign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    DLog(@"success--%d",success);
    
}
@end
