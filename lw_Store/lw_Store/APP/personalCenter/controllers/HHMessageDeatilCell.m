//
//  HHMessageDeatilCell.m
//  lw_Store
//
//  Created by User on 2018/5/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMessageDeatilCell.h"
#import "HHMessageWeb.h"
#import "HHCouponSuperVC.h"

@implementation HHMessageDeatilCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.msg_titleLabel = [UILabel new];
        self.msg_titleLabel.font = FONT(15);
        self.msg_titleLabel.textAlignment = NSTextAlignmentCenter;
        self.line = [UILabel new];
        self.line.backgroundColor = KVCBackGroundColor;
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        self.msg_contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        self.msg_contentWebView.scrollView.scrollEnabled = NO;
        self.msg_contentWebView.UIDelegate = self;
        self.msg_contentWebView.backgroundColor = kClearColor;
        self.msg_contentWebView.navigationDelegate = self;
        self.msg_contentWebView.opaque = NO;
        self.dateTimeLabel = [UILabel new];
        self.dateTimeLabel.textAlignment = NSTextAlignmentRight;
        self.dateTimeLabel.font = FONT(13);

        [self.contentView addSubview:self.msg_titleLabel];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.msg_contentWebView];
        [self.contentView addSubview:self.dateTimeLabel];

        [self setConstains];
        
        self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(15, 15, 0, 15));
        self.contentView.backgroundColor = kWhiteColor;
        [self.contentView lh_setCornerRadius:5 borderWidth:1 borderColor:[UIColor colorWithHexString:@"#DDDDDD"]];
        
        [self setupAutoHeightWithBottomView:self.dateTimeLabel bottomMargin:30];
        
        
    }
    return self;
}
- (void)setConstains{
    
    self.msg_titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(40);
    
    self.line.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.msg_titleLabel, 10)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    self.msg_contentWebView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.line,5)
    .rightSpaceToView(self.contentView,10);

    self.dateTimeLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.msg_contentWebView, 10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(10);
}
- (void)setModel:(HHMineModel *)model{
    
    _model = model;
    self.msg_titleLabel.text = model.Title;
    NSString *htmlStr = [NSString stringWithFormat:@"<div style=word-wrap:break-word;font-size:30px; width:20px;>%@</div>",model.Memo];
    [self.msg_contentWebView loadHTMLString: htmlStr baseURL:nil];
    self.dateTimeLabel.text = model.AddTime;
    
    CGRect rect = [model.Memo boundingRectWithSize:CGSizeMake(ScreenW-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    NSLog(@"rectheight:%.f",rect.size.height);
        CGFloat height = rect.size.height+20;
        self.msg_titleLabel.sd_resetLayout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(40);
        self.line.sd_resetLayout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(self.msg_titleLabel, 10)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1);
    
        self.msg_contentWebView.sd_resetLayout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.line,5)
        .rightSpaceToView(self.contentView,10)
        .heightIs(height);
    
        self.dateTimeLabel.sd_resetLayout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.msg_contentWebView, 10)
        .rightSpaceToView(self.contentView,10)
        .heightIs(20);
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSString *reqStr = navigationResponse.response.URL.absoluteString;
    if ([reqStr containsString:@"http"]) {
        if ([reqStr containsString:@"CouponsList"]) {
            HHCouponSuperVC *vc = [HHCouponSuperVC new];
            [self.nav pushVC:vc];

        }else{
          HHMessageWeb *vc = [HHMessageWeb new];
          vc.url = reqStr;
          [self.nav pushVC:vc];
        }
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}
- (void)setShadowWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(HHMineModel *)model{
    
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[self class] contentViewWidth:[self cellContentViewWith]];
    
    [self addShadowToView:self.contentView withOpacity:0.3 shadowRadius:2 andCornerRadius:1 shadowColor:[UIColor colorWithHexString:@"#BBBBBB"] shadow_height:height-10 shadow_width:ScreenW-20 shadowOffset:CGSizeMake(12, 15)];

    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
@end
