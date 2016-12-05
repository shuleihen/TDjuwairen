//
//  SurveyDetailWebViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailWebViewController.h"
#import "CocoaLumberjack.h"
#import "NetworkManager.h"

@interface SurveyDetailWebViewController ()<WKNavigationDelegate,UIWebViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation SurveyDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 加载内容
    [self loadContent];
}

- (void)loadContent {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *para = [self contentParmWithTag:self.tag];
    
    [ma POST:@"Survey/survey_show_tag" parameters:para completion:^(id data, NSError *error){
        if (!error && data) {
            NSString *baseUrl = data[@"url"];
            NSString *urlString = [self contenWebUrlWithBaseUrl:baseUrl witTag:self.tag];
            [self loadWebWithUrl:urlString];
        } else {
            // 查询失败
        }
    }];
}


- (void)loadWebWithUrl:(NSString *)url {
    DDLogInfo(@"Survey detail web load url = %@", url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DDLogInfo(@"Survey detail web start load");
    [self.indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DDLogInfo(@"Survey detail web load successed");
    
    NSString *documentHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].offsetHeight;"];
    CGFloat height = [documentHeight floatValue];
    self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    [self.indicatorView stopAnimating];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentDetailController:withHeight:)]) {
        [self.delegate contentDetailController:self withHeight:height];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DDLogError(@"Survey detail web load error = %@",error);
    [self.indicatorView stopAnimating];
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web start load");
    [self.indicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web load successed");
    
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat documentHeight = [result doubleValue];
        self.webView.frame = CGRectMake(0, 0, kScreenWidth, documentHeight);
        [self.indicatorView stopAnimating];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(contentDetailController:withHeight:)]) {
            [self.delegate contentDetailController:self withHeight:documentHeight];
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DDLogError(@"Survey detail web load error = %@",error);
    [self.indicatorView stopAnimating];
}


- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        //        _webView.delegate = self;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(kScreenWidth/2, 100);
        [self.webView addSubview:_indicatorView];
    }
    return _indicatorView;
}
@end
