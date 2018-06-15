//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyActivityWebVC.h"
#import <WebKit/WebKit.h>
#import "HHSubmitOrdersVC.h"
#import "HHOrderDetailVC.h"
#import "HHGoodBaseViewController.h"

@interface HHMyActivityWebVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
{
    WKWebView *_webView;
    UIButton *rightBtn;
    NSString *url;
    NSString *webpageUrl;
    NSString *responseUrl;

}
@end

@implementation HHMyActivityWebVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"拼团";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    
    HJUser *user = [HJUser sharedUser];
    url = [NSString stringWithFormat:@"%@/SpellGroup/SpellGroupList?token=%@",API_HOST1,user.token];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:req];

    [_webView loadRequest:req];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44) target:self action:@selector(shareAction) image:[UIImage imageNamed:@"icon-share"]];
    rightBtn.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
- (void)backBtnAction{
    
    if ([responseUrl containsString:@"SpellGroup/SpellGroupList"]) {
        
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([_webView canGoBack]) {
        if ([responseUrl containsString:@"SpellGroup/Index"]) {
            rightBtn.hidden = YES;
        }
        [_webView goBack];
    } else{
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
    if ([navigationResponse.response.URL.absoluteString containsString:@"SpellGroup/Index"]) {
        rightBtn.hidden = NO;
        webpageUrl = navigationResponse.response.URL.absoluteString;
        
        decisionHandler(WKNavigationResponsePolicyAllow);
    }else if([navigationResponse.response.URL.absoluteString containsString:@"MyOrder/MyOrderDetail"]){
        rightBtn.hidden = YES;
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];
        HHOrderDetailVC *vc = [HHOrderDetailVC new];
        vc.orderid = model.orderId;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if([navigationResponse.response.URL.absoluteString containsString:@"SpellGroup/SpellGroupList"]){
        
        rightBtn.hidden = YES;
        decisionHandler(WKNavigationResponsePolicyAllow);
        
    }else if([navigationResponse.response.URL.absoluteString containsString:@"ShopCarWeb/PreviewOrder"]){
        rightBtn.hidden = YES;
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];
        HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
        vc.enter_type = HHaddress_type_Spell_group;
        vc.ids_Str = model.skuId;
        vc.count = @"1";
        vc.mode = @2;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if([navigationResponse.response.URL.absoluteString containsString:@"ProductWeb/ProductDetail"]){
        rightBtn.hidden = YES;
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];
        HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
        vc.Id = model.Id;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if ([navigationResponse.response.URL.absoluteString containsString:@"HttpError"]){
        
        [SVProgressHUD showInfoWithStatus:@"服务器出现错误"];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }  else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
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
    
    
}

@end


