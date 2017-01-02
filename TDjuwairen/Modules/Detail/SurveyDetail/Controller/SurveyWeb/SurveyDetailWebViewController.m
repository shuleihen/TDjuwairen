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

@interface SurveyDetailWebViewController ()<WKNavigationDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation SurveyDetailWebViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFontSize:) name:kSurveyContentFontSizeChanged object:nil];
    
    // 加载内容
    [self loadContent];
}

- (void)updateFontSize:(NSNotification *)notifi {
    [self adjustFont];
}

- (void)adjustFont {
    NSArray *fonts = @[@"140%",@"120%",@"100%",@"80%"];
    NSInteger currentFont = [[NSUserDefaults standardUserDefaults] integerForKey:kSurveyContentFontSize];
    if (currentFont == 0) {
        currentFont = 3;
    }
    NSInteger i = currentFont - 1;
    
    if (i >= 0 && i < [fonts count]) {
        NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",fonts[i]];
        [self.webView stringByEvaluatingJavaScriptFromString:jsZiti];
        
        DDLogInfo(@"Survey detail changed font size = %@",fonts[i]);
    }
    
    
    NSString *documentHeight = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].offsetHeight;"];
    CGFloat height = [documentHeight floatValue];
    self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentDetailController:withHeight:)]) {
        DDLogInfo(@"Survey detail changed height of sub controller, and notification super tableview reload");
        
        [self.delegate contentDetailController:self withHeight:height];
    }
}

- (void)loadContent {
    NetworkManager *ma = [[NetworkManager alloc] init];
    NSDictionary *para = [self contentParmWithTag:self.tag];
    
    [ma POST:API_SurveyDetail parameters:para completion:^(id data, NSError *error){
        if (!error && data) {
            NSString *baseUrl = data[@"url"];
            NSString *urlString = [self contenWebUrlWithBaseUrl:baseUrl witTag:self.tag];
            [self loadWebWithUrl:urlString];
        } else {
            // 查询失败
        }
    }];
}

- (CGFloat)contentHeight {
    return CGRectGetHeight(self.webView.bounds);
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
    
    [self.indicatorView stopAnimating];
    
    [self adjustFont];
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


- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.delegate = self;
//        _webView.navigationDelegate = self;
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
