//
//  TDWebViewController.m
//  TDjuwairen
//
//  Created by zdy on 16/7/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "TDWebViewController.h"
#import <WebKit/WebKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "TDRechargeViewController.h"

@interface TDWebViewController ()<WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@end

@implementation TDWebViewController

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        _url = url;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebView];
    [self loadWebViewData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

- (void)setupNavigation
{
    UIButton*leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [leftButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [configuration.userContentController addScriptMessageHandler:self name:@"com_jwr_membercenter_upgrade"];
    [configuration.userContentController addScriptMessageHandler:self name:@"com_jwr_rechargevip"];
}

- (void)loadWebViewData
{
    if (!self.url.absoluteString.length) {
        return;
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.webView reload];
}

- (void)back:(UIButton *)sender
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"body:%@", message.body);
    
    if ([message.name isEqualToString:@"com_jwr_membercenter_upgrade"] ||
        [message.name isEqualToString:@"com_jwr_rechargevip"]) {
        TDRechargeViewController *vc = [[TDRechargeViewController alloc] init];
        vc.isVipRecharge = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak TDWebViewController *wself = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *string, NSError *error){
        wself.title = string;
    }];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;{
}

@end
