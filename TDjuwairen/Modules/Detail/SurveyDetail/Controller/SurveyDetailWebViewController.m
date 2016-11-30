//
//  SurveyDetailWebViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailWebViewController.h"

@interface SurveyDetailWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation SurveyDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self.view addSubview:self.webView];
}

- (void)loadWebWithUrl:(NSString *)url {
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat documentHeight = [result doubleValue];
        self.webView.frame = CGRectMake(0, 0, kScreenWidth, documentHeight);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(contentWebView:withHeight:)]) {
            [self.delegate contentWebView:webView withHeight:documentHeight];
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}
@end
