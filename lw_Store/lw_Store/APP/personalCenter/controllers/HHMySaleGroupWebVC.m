//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMySaleGroupWebVC.h"
#import <WebKit/WebKit.h>
#import "HHSubmitOrdersVC.h"
#import "HHOrderVC.h"
#import "HHPaySucessVC.h"

@interface HHMySaleGroupWebVC ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *_webView;
    UIButton *rightBtn;
    NSString *url;
    NSString *webpageUrl;
    NSString *responseUrl;

}
@end

@implementation HHMySaleGroupWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"降价团";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadData];
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(shareAction) image:[UIImage imageNamed:@"icon-share"]];
    rightBtn.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
- (void)loadData{
    
    HJUser *user = [HJUser sharedUser];
    url = [NSString stringWithFormat:@"%@/Personal/CutGroup?token=%@",API_HOST1,user.token];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}
- (void)backBtnAction{
    
    if ([responseUrl containsString:@"Personal/CutGroup"]) {
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([_webView canGoBack]) {
        if([responseUrl containsString:@"ActivityWeb/CutGroupBuy"]){
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"邀请好友参团" descr:@"" thumImage:nil];
    
    
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
    if ([navigationResponse.response.URL.absoluteString containsString:@"Personal/CutGroup"]) {
        rightBtn.hidden = YES;
        decisionHandler(WKNavigationResponsePolicyAllow);

    }else if([navigationResponse.response.URL.absoluteString containsString:@"ActivityWeb/CutGroupBuy"]){
        
        rightBtn.hidden = NO;
        webpageUrl = navigationResponse.response.URL.absoluteString;
        decisionHandler(WKNavigationResponsePolicyAllow);
       
    }else if([navigationResponse.response.URL.absoluteString containsString:@"WeiXin/Pay"]){
        //微信支付
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];

        [[[HHMineAPI postOrder_AppPayAddrId:nil orderId:model.order_id]netWorkClient]postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
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
        
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"HttpError"]){
        
        [SVProgressHUD showInfoWithStatus:@"服务器出现错误"];
        decisionHandler(WKNavigationResponsePolicyCancel);

    }else{
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
    
    HHPaySucessVC *vc = [HHPaySucessVC new];
    vc.enter_type = HHenter_type_activity;
    vc.backBlock = ^{
        [self loadData];
    };
    [self.navigationController pushVC:vc];
    
}
//88 288 1288
- (void)wxPayFailcount {
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD showErrorWithStatus:@"支付失败～"];
}
@end

