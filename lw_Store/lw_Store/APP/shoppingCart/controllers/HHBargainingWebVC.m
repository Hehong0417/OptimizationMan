//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBargainingWebVC.h"
#import <WebKit/WebKit.h>

@interface HHBargainingWebVC ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *_webView;
    UIButton *rightBtn;
    NSString *webpageUrl;
    NSString *responseUrl;
}
@end

@implementation HHBargainingWebVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //js配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    HJUser *user = [HJUser sharedUser];
    webpageUrl = [NSString stringWithFormat:@"%@/ActivityWeb/CutPriceShare?orderId=%@",API_HOST1,self.orderId];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ActivityWeb/CutPriceShare?orderId=%@&token=%@",API_HOST1,self.orderId,user.token]]];
    
    [_webView loadRequest:req];   
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(shareAction) image:[UIImage imageNamed:@"icon-share"]];
    rightBtn.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
- (void)shareAction{
    
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"不好意思打扰了，帮我砍下价可以么，拜托拜托！" descr:@"这是力沃官方为回馈用户提供的福利" thumImage:nil];
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
- (void)backBtnAction{
    
    if ([responseUrl containsString:@"ActivityWeb/CutPriceShare"]||[responseUrl containsString:@"ActivityWeb/CutPriceMessage"]) {
        [self.view resignFirstResponder];
        [self.navigationController popToRootVC];
    }else if([responseUrl containsString:@"ActivityWeb/CutPriceDetail"]&&(![responseUrl containsString:@"ActivityWeb/CutPriceDetail?cut=0"])){
        [self.view resignFirstResponder];
        [self.navigationController popToRootVC];
    }else if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
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

    if ([responseUrl containsString:@"ActivityWeb/CutPriceShare"]) {
        rightBtn.hidden = NO;
    }else if ([responseUrl containsString:@"ActivityWeb/CutPriceMessage"]) {
        rightBtn.hidden = NO;
        webpageUrl = navigationResponse.response.URL.absoluteString;
    }else if ([responseUrl containsString:@"ActivityWeb/CutPriceDetail"]&&(![responseUrl containsString:@"ActivityWeb/CutPriceDetail?cut=0"])) {
        rightBtn.hidden = NO;
        webpageUrl = navigationResponse.response.URL.absoluteString;
    }else{
        rightBtn.hidden = NO;
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}



@end


