//
//  LwHomeVC.m
//  lw_Store
//
//  Created by User on 2018/4/23.
//  Copyright © 2018年 User. All rights reserved.
//

#import "LwHomeVC.h"
#import <WebKit/WebKit.h>
#import "HHGoodBaseViewController.h"
#import "HHUrlModel.h"
#import "HHGoodListVC.h"

@interface LwHomeVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
{
    WKWebView *_webView;
}
@end

@implementation LwHomeVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"closeMe"];

    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
     config.userContentController = userContentController;

    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-49) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;

    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];

    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/MiniPrograms/Index?cid=12",API_HOST1]]];
    [_webView loadRequest:req];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Start:%@",navigation);

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Finish:%@",navigation);

}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"Redirect:%@",navigation);

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);
    
     decisionHandler(WKNavigationResponsePolicyAllow);
}
#pragma mark-WKScriptMessageHandler


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    [self allowTurnAroundWithUsrlStr:message.body[@"url"]];
    
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"closeMe"];

}
//跳转
- (void)allowTurnAroundWithUsrlStr:(NSString *)urlStr{
    
    HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[urlStr lh_parametersKeyValue]];
    //允许跳转
    if ([urlStr containsString:@"detail"]) {
        
        HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
        vc.Id = model.Id;
        [self.navigationController pushVC:vc];
        
    }
    
}

@end
