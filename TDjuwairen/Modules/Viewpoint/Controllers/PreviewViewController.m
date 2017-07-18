//
//  PreviewViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PreviewViewController.h"

@import WebKit;
@interface PreviewViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong) WKWebView *webview;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWithNavigation];
    [self setupWithWkWebview];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{    
    self.title = @"预览";
}

- (void)setupWithWkWebview{
    self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.webview.navigationDelegate = self;
    self.webview.UIDelegate = self;
    [self.webview loadHTMLString:self.html baseURL:nil];
    
    [self.view addSubview:self.webview];
    
}

@end
