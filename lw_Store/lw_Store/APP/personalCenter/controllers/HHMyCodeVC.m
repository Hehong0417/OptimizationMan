//
//  HHMyCodeVC.m
//  lw_Store
//
//  Created by User on 2018/5/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyCodeVC.h"

@interface HHMyCodeVC ()
{
    UIImageView *_imagV;
}
@end

@implementation HHMyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的二维码";
    
    [self getDatas];
  
    _imagV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_imagV];
}
- (void)getDatas{
    
    [[[HHMineAPI GetMyCode] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {

        if (!error) {
            if (api.State == 1) {
                [_imagV sd_setImageWithURL:[NSURL URLWithString:api.Data]];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
}


@end
