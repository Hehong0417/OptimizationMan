//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHExtraBonusVC.h"
#import <WebKit/WebKit.h>

@interface HHExtraBonusVC ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *_webView;
    NSString *url;
    NSString *webpageUrl;
    NSString *responseUrl;
    MBProgressHUD *_hud;
}
@end

@implementation HHExtraBonusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"额外奖励";
      
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-Status_HEIGHT-44) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    [self loadData];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addHeadRefresh];
    
}
#pragma mark - 刷新控件

- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    _webView.scrollView.mj_header = refreshHeader;
}
- (void)backBtnAction{
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)loadData{
    
    HJUser *user = [HJUser sharedUser];
    url = [NSString stringWithFormat:@"%@/Personal/RewardList?token=%@&cid=12",API_HOST1,user.token];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
    if (_webView.scrollView.mj_header.isRefreshing) {
        [_webView.scrollView.mj_header endRefreshing];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Start:%@",navigation);
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Finish:%@",navigation);
    
    [_hud hideAnimated:YES];
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
    
    [_hud hideAnimated:YES];

    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);
    
    [_hud hideAnimated:YES];

    responseUrl =navigationResponse.response.URL.absoluteString;
    if ([navigationResponse.response.URL.absoluteString containsString:@"ActivityWeb/SendGiftList"]) {
        
        webpageUrl = navigationResponse.response.URL.absoluteString;
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    decisionHandler(WKNavigationResponsePolicyCancel);

}


@end



