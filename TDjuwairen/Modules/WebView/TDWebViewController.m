//
//  TDWebViewController.m
//  TDjuwairen
//
//  Created by zdy on 16/7/28.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "TDWebViewController.h"
#import <WebKit/WebKit.h>

@interface TDWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation TDWebViewController

- (id)initWithURLString:(NSString *)urlString
{
    if (self = [super init]) {
        _urlString = urlString;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebView];
    [self loadWebViewData];
}

- (void)setupNavigation
{
    UIButton*leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupWebView
{
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)loadWebViewData
{
    if (!self.urlString.length) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;{
}

@end
