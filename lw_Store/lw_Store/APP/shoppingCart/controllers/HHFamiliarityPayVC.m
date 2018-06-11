//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHFamiliarityPayVC.h"
#import <WebKit/WebKit.h>
#import "HHnormalSuccessVC.h"

@interface HHFamiliarityPayVC ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *_webView;
    UIButton *rightBtn;
    NSString *webpageUrl;
    NSString *responseUrl;
}
@end

@implementation HHFamiliarityPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // js配置
    self.title = @"亲密付";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    HJUser *user = [HJUser sharedUser];
    webpageUrl = [NSString stringWithFormat:@"%@/ActivityWeb/IntimatePerson?orderId=%@&token=%@",API_HOST1,self.orderId,user.token];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ActivityWeb/IntimatePerson?orderId=%@&token=%@",API_HOST1,self.orderId,user.token]]];
    
    [_webView loadRequest:req];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];

    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(shareAction) image:[UIImage imageNamed:@"icon-share"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
- (void)backBtnAction{
    
    if ([_webView canGoBack]) {
        if([responseUrl containsString:@"ActivityWeb/IntimatePayList"]){
            rightBtn.hidden = NO;
        }else{
            rightBtn.hidden = YES;
        }
        [_webView goBack];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"亲密付" descr:@"" thumImage:nil];
    
    
    //设置Webpage地址
    shareObject.webpageUrl = webpageUrl;
    
    //分享消息对象设置分享内容对象
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
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Start:%@",navigation);
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Finish:%@",navigation);
    //获取当前页面的title
    [_webView evaluateJavaScript: @"document.title" completionHandler:^(id data, NSError * _Nullable error) {
        self.title = data;
    }];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"Redirect:%@",navigation);
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);
    responseUrl = navigationResponse.response.URL.absoluteString;
    
    if ([responseUrl containsString:@"WeiXin/Pay"]) {
        rightBtn.hidden = YES;
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];
        
        [[[HHMineAPI postOrder_AppPayAddrId:nil orderId:model.order_id money:model.money]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.State == 1) {
                    HHWXModel *model = [HHWXModel mj_objectWithKeyValues:api.Data];
                    [HHWXModel payReqWithModel:model];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.Msg];
                }
            }else {
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
                
            }
        }];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"ActivityWeb/IntimatePayList"]){
        rightBtn.hidden = NO;
        webpageUrl = responseUrl;
        decisionHandler(WKNavigationResponsePolicyAllow);

    }else{
        rightBtn.hidden = YES;
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    
}
#pragma mark-微信支付

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KWX_Pay_Fail_Notification object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //微信支付通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPaySucesscount) name:KWX_Pay_Sucess_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayFailcount) name:KWX_Pay_Fail_Notification object:nil];
    
}
- (void)wxPaySucesscount{
    
    HHnormalSuccessVC *vc = [HHnormalSuccessVC new];
    vc.title_str = @"支付成功";
    vc.discrib_str = @"";
    vc.title_label_str = @"支付成功";
    vc.enter_Num = 1;
    [self.navigationController pushVC:vc];
}

- (void)wxPayFailcount {
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD showErrorWithStatus:@"支付失败～"];
}
@end
