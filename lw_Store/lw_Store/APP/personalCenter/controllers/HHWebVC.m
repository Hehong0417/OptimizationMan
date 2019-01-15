//
//  HHWebVC.m
//  springDream
//
//  Created by User on 2018/10/6.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWebVC.h"
#import <WebKit/WebKit.h>
#import "HHGoodBaseViewController.h"

@interface HHWebVC ()<WKUIDelegate,WKNavigationDelegate>
{
    MBProgressHUD *_hud;
}
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HHWebVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.title_str;
    
    // js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //    [userContentController addScriptMessageHandler:self name:@"closeMe"];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    [self loadData];
    
    [self addHeadRefresh];
}
- (void)loadData{
    //
    NSString  *url = self.url_str;
    
    WEAK_SELF();
        weakSelf.htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        if(weakSelf.htmlString == nil ||weakSelf.htmlString.length == 0){
            NSLog(@"load failed!");
        }else{
            [weakSelf.webView loadHTMLString:weakSelf.htmlString baseURL:[NSURL URLWithString:url]];
        }
    
    if (_webView.scrollView.mj_header.isRefreshing) {
        [_webView.scrollView.mj_header endRefreshing];
    }
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

#pragma mark - webView Delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Start:%@",navigation);
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Finish:%@",navigation);
    [_hud hideAnimated:YES];
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    [_hud hideAnimated:YES];
    
    NSString *responseUrl = navigationResponse.response.URL.absoluteString;
    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);
    
    if ([responseUrl containsString:@"productDetail"]) {
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[responseUrl lh_parametersKeyValue]];
        HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
        vc.Id = model.Id;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([responseUrl containsString:@"ActivityWeb/CouponDetail"]) {
        //当前页
        decisionHandler(WKNavigationResponsePolicyAllow);
        
    }else if ([responseUrl containsString:self.url_str]){
        
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else{
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
    
}

@end
