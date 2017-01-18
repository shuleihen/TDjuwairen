//
//  SubscriptionViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "PaySubscriptionViewController.h"
#import "SubscriptionHistoryViewController.h"
#import "HexColors.h"
#import "NetworkManager.h"
#import "SubscriptionTypeModel.h"
#import <WebKit/WebKit.h>
#import "YXCheckBox.h"
#import "LoginState.h"
#import "LoginViewController.h"

@interface SubscriptionViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSArray *subItems;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"周刊订阅";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"往期购买" style:UIBarButtonItemStylePlain target:self action:@selector(historyPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                    NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#333333"]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    self.buttons = [NSMutableArray arrayWithCapacity:2];
    
    [self querySubscription];
}

- (void)querySubscription  {
    
    __weak SubscriptionViewController *wself = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_SubscriptionInfo parameters:nil completion:^(id data,NSError *error){
        if (!error && data) {
            wself.contentUrl = data[@"url"];
            NSArray *sub = data[@"sub"];
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[sub count]];
            for (NSDictionary *dict in sub) {
                SubscriptionTypeModel *model = [[SubscriptionTypeModel alloc] initWithDict:dict];
                [array addObject:model];
            }
            wself.subItems = array;
            [wself reloadView];
        } else {
            
        }
    }];
}

- (void)reloadView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-110)];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    NSURL *url = [NSURL URLWithString:self.contentUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    UIView *tool = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.webView.frame), kScreenHeight, 110)];
    tool.backgroundColor = [UIColor whiteColor];
    
    int i =0;
    for (SubscriptionTypeModel *type in self.subItems) {
       
        YXCheckBox *check = [[YXCheckBox alloc] initWithCheckImage:[UIImage imageNamed:@"subscription_unchecked.png"]
                                                      checkedImage:[UIImage imageNamed:@"subscription_selected.png"]];
        check.tag = i;
        check.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        [check setTitle:type.subDesc forState:UIControlStateNormal];
        [check setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#333333"] forState:UIControlStateNormal];
        check.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        check.frame = CGRectMake(15+(80+30)*i, 18, 80, 30);
        [tool addSubview:check];
        
        __weak SubscriptionViewController *wself = self;
        check.checkedBoxBlock = ^(YXCheckBox *checkBox){
            wself.selectedIndex = checkBox.tag;
            [wself updateKeyLabe];
        };
    
        [self.buttons addObject:check];
        i++;
    }
    
    self.keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-150, 24, 150-12, 20)];
    self.keyLabel.textAlignment = NSTextAlignmentRight;
    self.keyLabel.font = [UIFont systemFontOfSize:14.0f];
    [tool addSubview:self.keyLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"立即订阅" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    btn.frame = CGRectMake(12, 110-10-34, kScreenWidth-24, 34);
    btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
    [btn addTarget:self action:@selector(subscriptionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:btn];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    sep.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
    [tool addSubview:sep];
    
    [self.view addSubview:tool];
    
    // 默认选择第一个
    self.selectedIndex = 0;
    [self updateKeyLabe];
}

- (void)updateKeyLabe {
    
    for (int i=0; i<[self.buttons count]; i++) {
        YXCheckBox *box = self.buttons[i];
        if (self.selectedIndex == i) {
            box.selected = YES;
        } else {
            box.selected = NO;
        }
    }
    
    if (self.selectedIndex >=0 && self.selectedIndex<[self.subItems count]) {
        SubscriptionTypeModel *type = self.subItems[self.selectedIndex];
        NSString *key = [NSString stringWithFormat:@"%ld",(long)type.keyNum];
        NSString *title = [NSString stringWithFormat:@"需使用%@把金钥匙",key];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#666666"]} range:NSMakeRange(0, title.length)];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexRGBAString:@"#fe6c00"]} range:NSMakeRange(3, key.length)];
        self.keyLabel.attributedText = attr;
    }
}

- (void)historyPressed:(id)sender {
    if (US.isLogIn) {
        SubscriptionHistoryViewController *vc = [[SubscriptionHistoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (IBAction)subscriptionPressed:(id)sender {
    if (self.selectedIndex >=0 && self.selectedIndex<[self.subItems count]) {
        SubscriptionTypeModel *type = self.subItems[self.selectedIndex];
        
        PaySubscriptionViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySubscriptionViewController"];
        vc.typeModel = type;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}
@end

