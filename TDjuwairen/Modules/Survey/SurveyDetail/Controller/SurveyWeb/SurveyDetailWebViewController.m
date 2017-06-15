//
//  SurveyDetailWebViewController.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailWebViewController.h"
#import "FeedbackViewController.h"
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
#import "AlivePublishViewController.h"
#import "AliveListModel.h"
#import "SurveyDownLoadHintViewController.h"
#import "STPopup.h"
#import "UIViewController+STPopup.h"
#import <WebKit/WebKit.h>

@interface SurveyDetailWebViewController ()<WKNavigationDelegate,StockShareDelegate,StockAskDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) StockShareView *shareView;
@property (nonatomic, strong) StockAskView *askView;
@property (strong, nonatomic) NSMutableDictionary *surveyInfoDictM;


@end

@implementation SurveyDetailWebViewController

- (void)dealloc {
    self.webView.navigationDelegate = nil;
    [self.webView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_more.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(morePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    
    UIButton *downLoadButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,45,30)];
    [downLoadButton setTitle:@"下载" forState:UIControlStateNormal];
    downLoadButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [downLoadButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#333333"] forState:UIControlStateNormal];
    [downLoadButton addTarget:self action:@selector(downLoadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *downLoadButtonItem = [[UIBarButtonItem alloc]initWithCustomView:downLoadButton];
    
    switch (self.surveyType) {
        case kSurveyTypeSpot:
            self.title = [self.stockName stringByAppendingString:@" 实地篇"];
            self.navigationItem.rightBarButtonItem= rightItem;
            break;
        case kSurveyTypeDialogue:
            self.title = [self.stockName stringByAppendingString:@" 对话篇"];
            self.navigationItem.rightBarButtonItem= rightItem;
            break;
        case kSurveyTypeHot:
            self.title = [self.stockName stringByAppendingString:@" 热点篇"];
            self.navigationItem.rightBarButtonItem= rightItem;
            break;
        case kSurveyTypeShengdu:
            self.title = [self.stockName stringByAppendingString:@" 深度篇"];
            self.navigationItem.rightBarButtonItem= rightItem;
            break;
        case kSurveyTypeComment:
            self.title = [self.stockName stringByAppendingString:@" 评论篇"];
            self.navigationItem.rightBarButtonItem= rightItem;
            break;
        case kSurveyTypeAnnounce:
            self.title = [self.stockName stringByAppendingString:@" 公告"];
            self.navigationItem.rightBarButtonItem= downLoadButtonItem;
            break;
        default:
            break;
    }
    
    [self loadSurveyInfoData];
    // 加载内容
    [self reloadData];
}

- (void)AddQuestionButton {
    if (self.surveyType == kSurveyTypeAnnounce) {
        // 公告
        return;
    }
    
    UIImage *image = [UIImage imageNamed:@"ico_questions.png"];
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [questionBtn setBackgroundImage:image forState:UIControlStateNormal];
    [questionBtn setTitle:@"提问" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [questionBtn setTitleColor:TDTitleTextColor forState:UIControlStateNormal];
    questionBtn.frame = CGRectMake(kScreenWidth-12-image.size.width, kScreenHeight-64-100-image.size.height, image.size.width, image.size.height);
    [questionBtn addTarget:self action:@selector(questionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];
}

- (void)morePressed:(id)sender {
    [self.shareView showInContainView:self.view];
}

- (void)downLoadButtonClick:(UIButton *)hintBtn {
    SurveyDownLoadHintViewController *hintVC = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"SurveyDownLoadHintViewController"];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:hintVC];
    popupController.containerView.layer.cornerRadius = 4;
    popupController.topViewController.contentSizeInPopup = CGSizeMake(kScreenWidth-120, 200);
    popupController.navigationBarHidden = YES;
    [popupController presentInViewController:self];
}

- (void)reloadData {
    
    NSString *urlString = self.url;
    
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
    
    NSString *code = self.stockCode;
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

#pragma mark - loadSurveyInfoData
- (void)loadSurveyInfoData {
    NSDictionary *para = @{@"content_id": self.contentId,
                           @"survey_tag": @(self.surveyType)};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager POST:API_SurveyGetShareInfo parameters:para completion:^(id data, NSError *error) {
        if (!error) {
            self.surveyInfoDictM = [NSMutableDictionary dictionaryWithDictionary:data];
            self.shareView.isCollection = [data[@"is_collected"] boolValue];
        }
    }];
    
}

#pragma mark - StockShareDelegate
- (void)sharePressed {
    
    NSString *title = self.surveyInfoDictM[@"survey_title"];
    NSString *author = self.surveyInfoDictM[@"survey_author"];
    NSString *cover = self.surveyInfoDictM[@"survey_cover"];
    NSString *url = self.surveyInfoDictM[@"share_url"];
    
    NSArray *images;
    if (cover.length) {
        images = @[cover];
    }
    
    __weak SurveyDetailWebViewController *wself = self;
    AliveListModel *model = [[AliveListModel alloc] init];
    model.aliveTitle = title;
    model.aliveImgs = images;
    model.shareUrl = url;
    model.aliveId = self.contentId;
    model.aliveType = (NSInteger)self.surveyType;
    model.masterNickName = author;
    
    void (^shareBlock)(BOOL state) = ^(BOOL state) {
        if (state) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.animationType = MBProgressHUDAnimationZoomIn;
            hud.labelText = @"分享成功";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.6];
        }
    };
    
    
    [ShareHandler shareWithTitle:self.stockName image:images url:url selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 转发
            AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            vc.aliveListModel = model;
            vc.publishType = kAlivePublishShare;
            vc.shareBlock = shareBlock;
            [wself.navigationController pushViewController:vc animated:YES];
        }
    } shareState:nil];
    
    
    
}


- (void)feedbackPressed {
    if (US.isLogIn) {
        FeedbackViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfoSetting" bundle:nil] instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}


/// 收藏
- (void)collectionPressed {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    NSDictionary *showDict = nil;
    NSDictionary *dic ;

    if ([self.surveyInfoDictM[@"is_collected"] boolValue] == YES) {
        showDict = @{@"showMess1":@"取消收藏",@"showMess2":@"取消成功",@"showMess3":@"取消失败",@"apiStr":API_DelCollection,@"changeValue":@0};
        dic = @{@"module_id":@(5),
                @"module_type":@(self.surveyType),
                @"delete_ids":self.contentId};
    }else {
        showDict = @{@"showMess1":@"添加收藏",@"showMess2":@"收藏成功",@"showMess3":@"收藏失败",@"apiStr":API_AddCollection,@"changeValue":@1};
        dic = @{@"module_id":@(5),
                @"module_type":@(self.surveyType),
                @"item_id":self.contentId};
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showDict[@"showMess1"];
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    [manager POST:showDict[@"apiStr"] parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText =showDict[@"showMess2"];
            [hud hide:YES afterDelay:0.2];
            self.surveyInfoDictM[@"is_collected"] = showDict[@"changeValue"];
            self.shareView.isCollection = [data[@"is_collected"] boolValue];
        } else {
            hud.labelText = showDict[@"showMess3"];
            [hud hide:YES afterDelay:0.2];
        }
    }];
    
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web start load");
    [self.indicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DDLogInfo(@"Survey detail web load successed");
    
    [self.indicatorView stopAnimating];
    
    __weak SurveyDetailWebViewController *wself = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *string, NSError *error){
        if (string.length) {
            wself.title = string;
        }
    }];
    
    [self AddQuestionButton];
    
    /*
     __weak SurveyDetailWebViewController *wself = self;
     [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
     
     
     }];
     */
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
