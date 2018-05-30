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

@interface LwHomeVC ()<WKUIDelegate,WKNavigationDelegate>
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

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
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
    NSString *urlStr = navigationResponse.response.URL.absoluteString;
    HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[urlStr lh_parametersKeyValue]];
    //允许跳转

    if ([navigationResponse.response.URL.absoluteString containsString:@"ProductDetail"]) {
        
        HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
        vc.Id = model.Id;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);

    }else if ([navigationResponse.response.URL.absoluteString containsString:@"ProductWeb/Search"]){
        
        HHGoodListVC *vc = [HHGoodListVC new];
        vc.enter_Type = HHenter_home_Type;
        [self.navigationController pushVC:vc];
        
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"CategoryList"]){
        //商品分类
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"BrandList"]){
        //商品品牌
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"BrandDetail?bid"]){
        //商品品牌详细
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"ShopCarWeb/MyShopCar"]){
        //购物车
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"PersonalCenter"]){
        //个人中心
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"MyOrder/MyOrder"]){
        //订单
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"CouponDetail?coupId"]){
        //优惠券
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else{
        
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    // decisionHandler(WKNavigationResponsePolicyAllow);
}



@end
