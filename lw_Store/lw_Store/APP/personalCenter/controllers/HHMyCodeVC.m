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
    UIButton *rightBtn;
    NSString *webpageUrl;
}
@end

@implementation HHMyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的二维码";
    
    [self getDatas];
  
    _imagV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_imagV];
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(shareAction) image:[UIImage imageNamed:@"icon-share"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - 加载数据

- (void)getDatas{
    
    [[[HHMineAPI GetMyCode] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {

        if (!error) {
            if (api.State == 1) {
                [_imagV sd_setImageWithURL:[NSURL URLWithString:api.Data]];
                webpageUrl = api.Data;
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
}

-(void)shareAction{
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareVedioToPlatformType:platformType];
        
    }];
}
//分享到不同平台
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建Webpage内容对象
    
//    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"扫一扫" descr:@"" thumImage:nil];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:webpageUrl]];
//    shareObject.shareImage = data;
    //设置Webpage地址
    //分享消息对象设置分享内容对象
    //创建Webpage内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"邀请好友参团" descr:@"" thumImage:nil];
    //设置Webpage地址
    shareObject.webpageUrl = webpageUrl;
    
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            
        }
    }];
}

@end
