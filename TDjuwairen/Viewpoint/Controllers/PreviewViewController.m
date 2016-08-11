//
//  PreviewViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/8/11.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PreviewViewController.h"
#import "UIdaynightModel.h"

@import WebKit;
@interface PreviewViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) WKWebView *webview;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    [self setupWithNavigation];
    [self setupWithWkWebview];
    // Do any additional setup after loading the view.
}

- (void)setupWithNavigation{
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    
    self.title = @"预览";
    
    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
}

- (void)setupWithWkWebview{
    self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.webview.navigationDelegate = self;
    self.webview.UIDelegate = self;
    NSLog(@"%@",self.html);
    [self.webview loadHTMLString:self.html baseURL:nil];
    
    [self.view addSubview:self.webview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
