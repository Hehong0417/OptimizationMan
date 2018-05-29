//
//  HHMessageWeb.m
//  lw_Store
//
//  Created by User on 2018/5/14.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMessageWeb.h"

@interface HHMessageWeb ()

@end

@implementation HHMessageWeb

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:req];
    
}

@end
