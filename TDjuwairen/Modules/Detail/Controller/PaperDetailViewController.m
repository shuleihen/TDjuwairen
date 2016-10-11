//
//  PaperDetailViewController.m
//  TDjuwairen
//
//  Created by zdy on 16/10/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PaperDetailViewController.h"
#import "UIButton+WebCache.h"
#import "NetworkManager.h"
#import "LoginState.h"
#import <WebKit/WebKit.h>
#import "PaperAuthorView.h"
#import "SharpModel.h"
#import "PaperTagsView.h"

#define kPaperAuthorViewHeight 70


@interface PaperDetailViewController ()<PaperAuthorViewDelegate,PaperTagsViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) PaperAuthorView *authorView;
@property (nonatomic, strong) SharpModel *sharpInfo;
@property (nonatomic, strong) PaperTagsView *tagsView;
@end

@implementation PaperDetailViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kPaperAuthorViewHeight, kScreenWidth, kScreenHeight)];
//        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        [self.scrollView addSubview:_webView];
    }
    
    return _webView;
}

- (PaperAuthorView *)authorView {
    if (!_authorView) {
        _authorView = [[PaperAuthorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kPaperAuthorViewHeight)];
        _authorView.delegate = self;
        [self.scrollView addSubview:_authorView];
    }
    
    return _authorView;
}

- (PaperTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[PaperTagsView alloc] init];
        _tagsView.delegate = self;
        [self.scrollView addSubview:_tagsView];
    }
    
    return _tagsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (self.paperType) {
        case kPaperTypeSurvey:
            [self querySharpDetail];
            break;
        case kPaperTypeViewpoint:
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark sharp
- (void)querySharpDetail {
    NSString *url = [NSString stringWithFormat:@"index.php/Sharp/sharp_show1_2/id/%@",self.paperId];
    if (US.isLogIn) {
        url = [url stringByAppendingFormat:@"/userid/%@",US.userId];
    }
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:url parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            
            self.sharpInfo = [SharpModel sharpWithDictionary:data];
            [self showSharpDetail];

            NSString *string = [NSString stringWithFormat:@"%@%@",API_HOST,self.sharpInfo.sharpContent];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            
        } else {
//            wself.hudload.labelText = @"加载失败";
//            [wself.hudload hide:YES afterDelay:0.1];
        }
    }];
}

- (void)showSharpDetail {
    if (!self.sharpInfo) {
        return;
    }
    
    [self.authorView.authorAvatarBtn sd_setImageWithURL:[NSURL URLWithString:self.sharpInfo.sharpUserIcon] forState:UIControlStateNormal];
    self.authorView.authorNameLabel.text = self.sharpInfo.sharpUserName;
    self.authorView.publishDateLabel.text = self.sharpInfo.sharpWtime;
}

#pragma mark viewpoint
- (void)queryViewpointDetail {
    
}

#pragma mark PaperAuthorViewDelegate
- (void)authorAvatarPressed {
    
}

- (void)followPressed {
    
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView.isLoading) {
        return;
    }

    //调整字号
    NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= 100%"];
    [webView evaluateJavaScript:jsZiti completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //
    }];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#5B5B5B'";
        
        NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='white';\
        var pNode=document.getElementsByTagName('p');\
        for(var i=0;i<pNode.length;i++){\
        pNode[i].style.backgroundColor='white';\
        }";
        
        [self.webView evaluateJavaScript:textcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        [self.webView evaluateJavaScript:backcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
    }
    else
    {
        NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#CCCCCC'";
        
        NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='#222222';\
        var pNode=document.getElementsByTagName('p');\
        for(var i=0;i<pNode.length;i++){\
        pNode[i].style.backgroundColor='#222222';\
        }";
        
        [self.webView evaluateJavaScript:textcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
        [self.webView evaluateJavaScript:backcolor completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
    }
    
    __weak PaperDetailViewController *wself = self;
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = webView.frame;
        frame.size.height = documentHeight;
        webView.frame = frame;
        
        wself.tagsView.tags = wself.sharpInfo.sharpTags;
        wself.tagsView.frame = CGRectMake(0, CGRectGetMaxY(frame), kScreenWidth, CGRectGetHeight(wself.tagsView.bounds));
        wself.scrollView.contentSize = CGSizeMake(kScreenWidth, kPaperAuthorViewHeight + CGRectGetHeight(frame) + CGRectGetHeight(wself.tagsView.bounds));

        //        websize = frame.size;
        
//        [self.tagList setFrame:CGRectMake(0, 75+titlesize.height+10 + frame.size.height, kScreenWidth, 10+self.tagList.frame.size.height+10)];
        
//        [self didfinishReload];
        
        //停止加载样式
//        wself.hudload.labelText = @"加载完成";
//        [wself.hudload hide:YES afterDelay:0.1];
        
    }];
}
@end
