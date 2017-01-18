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
#import "NotificationDef.h"
#import "PlistFileDef.h"
#import "LoginState.h"
#import <WebKit/WebKit.h>

@interface SurveyDetailWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation SurveyDetailWebViewController

- (void)dealloc {
    self.webView.navigationDelegate = nil;
    [self.webView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    // 加载内容
    [self reloadData];
}

- (void)reloadData {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?content_id=%@&survey_tag=%ld",API_HOST,API_SurveyDetailContent,self.contentId,(long)self.tag];

    DDLogInfo(@"Survey detail web load url = %@", urlString);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}


#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web start load");
    [self.indicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web load successed");
    
    __weak SurveyDetailWebViewController *wself = self;
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        [wself.indicatorView stopAnimating];
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DDLogError(@"Survey detail web load error = %@",error);
    [self.indicatorView stopAnimating];
}


- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
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
