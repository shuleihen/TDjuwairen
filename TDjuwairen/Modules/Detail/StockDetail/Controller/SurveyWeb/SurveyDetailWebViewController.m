//
//  SurveyDetailWebViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailWebViewController.h"
#import "FeedbackViewController.h"
#import "SurveyMoreViewController.h"
#import "LoginViewController.h"
#import "LoginState.h"
#import "CocoaLumberjack.h"
#import "NetworkManager.h"
#import "NotificationDef.h"
#import "PlistFileDef.h"
#import "LoginState.h"
#import <WebKit/WebKit.h>
#import "ShareHandler.h"
#import "StockShareView.h"
#import "HexColors.h"
#import "StockAskView.h"
#import "NSString+Emoji.h"
#import "MBProgressHUD.h"

@interface SurveyDetailWebViewController ()<WKNavigationDelegate,StockShareDelegate,StockAskDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) StockShareView *shareView;
@property (nonatomic, strong) StockAskView *askView;
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
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_more.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(morePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    if (self.tag == 0) {
        self.title = [self.stockName stringByAppendingString:@" 实地篇"];
    } else if (self.tag == 1) {
        self.title = [self.stockName stringByAppendingString:@" 对话篇"];
    } else if (self.tag == 3) {
        self.title = [self.stockName stringByAppendingString:@" 热点篇"];
    }
    
    // 加载内容
    [self reloadData];
}

- (void)AddQuestionButton {
    UIImage *image = [UIImage imageNamed:@"ico_questions.png"];
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [questionBtn setBackgroundImage:image forState:UIControlStateNormal];
    [questionBtn setTitle:@"提问" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [questionBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#333333"] forState:UIControlStateNormal];
    questionBtn.frame = CGRectMake(kScreenWidth-12-image.size.width, kScreenHeight-64-100-image.size.height, image.size.width, image.size.height);
    [questionBtn addTarget:self action:@selector(questionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];
}

- (void)morePressed:(id)sender {
    [self.shareView showInContainView:self.view];
}

- (void)reloadData {
    
    NSString *urlString;
    if (US.isLogIn) {
        urlString = [NSString stringWithFormat:@"%@%@?content_id=%@&survey_tag=%ld&user_id=%@",API_HOST,API_SurveyDetailContent,self.contentId,(long)self.tag,US.userId];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@%@?content_id=%@&survey_tag=%ld",API_HOST,API_SurveyDetailContent,self.contentId,(long)self.tag];
    }

    DDLogInfo(@"Survey detail web load url = %@", urlString);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TextHtml" withExtension:@"html"];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)questionPressed:(id)sender {
    [self.askView showInContainView:self.navigationController.view];
}

#pragma mark - StockAskDelegate
- (void)askSendWithContent:(NSString *)content {
    if (!content.length) {
        return;
    }
    
    NSString *code = self.stockId;
    NSString *emojiCovert = [content stringByReplacingEmojiUnicodeWithCheatCodes];
    
    NSDictionary *para = @{@"code":       code,
                           @"question":   emojiCovert,
                           @"user_id":    US.userId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中";
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_SurveyAddQuestion parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"提交成功";
            [hud hide:YES afterDelay:0.4];
        }
        else {
            hud.labelText = error.localizedDescription;
            [hud hide:YES afterDelay:0.4];
        }
    }];
}

#pragma mark - StockShareDelegate
- (void)sharePressed {
    NSString *urlString = [NSString stringWithFormat:@"https://www.juwairen.net/Survey/%@",self.stockId];
    [ShareHandler shareWithTitle:self.stockName
                           image:self.cover
                             url:[NSURL URLWithString:urlString]];
}

- (void)feedbackPressed {
    if (US.isLogIn) {
        FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedback animated:YES];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web start load");
    [self.indicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web load successed");
    
    __weak SurveyDetailWebViewController *wself = self;
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        [wself.indicatorView stopAnimating];
        
        [wself AddQuestionButton];
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DDLogError(@"Survey detail web load error = %@",error);
    [self.indicatorView stopAnimating];
    
    [self AddQuestionButton];
}

#pragma mark - Getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.configuration.allowsInlineMediaPlayback = YES;
        
        if ([_webView.configuration respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]) {
            _webView.configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        }
        if ([_webView.configuration respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
            _webView.configuration.mediaPlaybackRequiresUserAction = NO;
        }
        if ([_webView.configuration respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
            _webView.configuration.requiresUserActionForMediaPlayback = NO;
        }
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

- (StockShareView *)shareView {
    if (!_shareView) {
        _shareView = [[StockShareView alloc] init];
        _shareView.delegate = self;
    }
    return _shareView;
}

- (StockAskView *)askView {
    if (!_askView) {
        _askView = [[StockAskView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _askView.delegate = self;
    }
    
    return _askView;
}
@end
