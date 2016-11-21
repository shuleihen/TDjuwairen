//
//  DetailPageViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/9/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "DetailPageViewController.h"
#import "NaviMoreView.h"
#import "SelectFontView.h"
#import "SharpTags.h"
#import "BackCommentView.h"
#import "TitleforDetailView.h"
#import "DetailTableViewController.h"
#import "LoginViewController.h"
#import "FeedbackViewController.h"
#import "SearchViewController.h"
#import "UserInfoViewController.h"

#import "SharpModel.h"
#import "ViewModel.h"
#import "CommentsModel.h"

#import "LoginState.h"
#import "UIdaynightModel.h"

#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NSString+Ext.h"
#import "HexColors.h"
#import "YXFont.h"
#import "UIStoryboard+MainStoryboard.h"
#import "MJRefresh.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@import WebKit;
@interface DetailPageViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate,NaviMoreViewDelegate,SelectFontViewDelegate,BackCommentViewDelegate,SharpTagsDelegate,ChildTabDelegate>
{
    CGSize titlesize;
    CGSize websize;
    BOOL naviShow;
    
    BOOL timehot;
    BOOL firstLoadComment;
}
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic,strong) NaviMoreView *nmview;
@property (nonatomic,strong) SelectFontView *sfview;
@property (nonatomic,strong) BackCommentView *backcommentview;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) TitleforDetailView *titleView;
@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic,strong) SharpTags *tagList;

@property (nonatomic,strong) MBProgressHUD *hudload;
@property (nonatomic,strong) MBProgressHUD *hudloadCom;

@property (nonatomic,strong) NSArray *sizeArr;

@property (nonatomic,assign) int page;
@property (nonatomic,copy) NSString *fontsize;
@property (nonatomic,copy) NSString *encryptedStr;
@property (nonatomic,strong) SharpModel *sharpInfo;
@property (nonatomic,strong) ViewModel *viewInfo;
@property (nonatomic,strong) NSMutableArray *FirstcommentArr;
@property (nonatomic,strong) NSMutableArray *sharpTagsArray;
@property (nonatomic,copy) NSString *pid;


@end

@implementation DetailPageViewController
- (NaviMoreView *)nmview{
    if (!_nmview) {
        NSString *str ;
        if ([self.pageMode isEqualToString:@"sharp"]) {
            if (self.sharpInfo.sharpIsCollect == YES) {
                str = @"yes";
            }
            else
            {
                str = @"no";
            }
        }
        else
        {
            if (self.viewInfo.viewIsCollect == YES) {
                str = @"yes";
            }
            else
            {
                str = @"no";
            }
        }
        
        _nmview = [[NaviMoreView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kScreenHeight/16*4) withString:str];
        
        _nmview.delegate = self;
        [self.view addSubview:_nmview];
    }
    return _nmview;
}

- (SelectFontView *)sfview{
    if (!_sfview) {
        _sfview = [[SelectFontView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3*2, 300)];
        _sfview.center = self.view.center;
        _sfview.delegate = self;
        [self.view addSubview:_sfview];
    }
    return _sfview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daynightmodel = [UIdaynightModel sharedInstance];
    self.sizeArr = @[@"140%",@"120%",@"100%",@"80%"];
    self.fontsize = @"100%";
    self.page = 1;
    self.pid = @"0";
    
    [self setupWithNavigation];
    
    [self setupWithScrollView];
    
    [self setupWithTableView];
    
    [self setupWithCommentView];
    
    [self requestAction];
    
    [self addRefresh];
    
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)addRefresh{
    self.scrollview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.scrollview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    DetailTableViewController *detailTab = self.childViewControllers[0];
    if ([self.pageMode isEqualToString:@"sharp"]) {
        [detailTab requestCommentDataWithPage:self.page];
    }
    else if([self.pageMode isEqualToString:@"view"])
    {
        [detailTab requestWithCommentDataWithTimeHot];
    }
}

- (void)loadMoreAction {
    self.page ++;
    DetailTableViewController *detailTab = self.childViewControllers[0];
    if ([self.pageMode isEqualToString:@"sharp"]) {
        [detailTab requestCommentDataWithPage:self.page];
    }
    else if([self.pageMode isEqualToString:@"view"])
    {
        [detailTab requestWithCommentDataWithTimeHot];
    }
}

- (void)viewTapped:(UIButton *)sender{
    [self.view endEditing:YES];
    self.nmview.alpha = 0.0;
}

- (void)setupWithNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //设置navigation背景色
    [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
    [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_more@3x.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(naviMore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
}

- (void)setupWithScrollView{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50)];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.delegate = self;
    self.scrollview.backgroundColor = self.daynightmodel.backColor;
    [self.view addSubview:self.scrollview];
}

- (void)setupWithTitleView{
    self.titleView = [[TitleforDetailView alloc]init];
    if ([self.pageMode isEqualToString:@"sharp"]) {
        [self.titleView.userheadImage sd_setImageWithURL:[NSURL URLWithString:self.sharpInfo.sharpUserIcon]];
        
        self.titleView.userheadImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserInfo:)];
        [self.titleView.userheadImage addGestureRecognizer:tap];
        
        self.titleView.usernickname.text = self.sharpInfo.sharpUserName;
        self.titleView.addtime.text = self.sharpInfo.sharpWtime;
        
        NSString *text = self.sharpInfo.sharpTitle;
        UIFont *font = [UIFont systemFontOfSize:20];
        self.titleView.titleLabel.font = font;
        self.titleView.titleLabel.numberOfLines = 0;
        titlesize = CGSizeMake(kScreenWidth-30, 20000.0f);
        titlesize = [text calculateSize:titlesize font:font];
        self.titleView.titleLabel.text = text;
        [self.titleView.titleLabel setFrame:CGRectMake(15, 75, kScreenWidth-30, titlesize.height)];
        
        self.titleView.usernickname.textColor = self.daynightmodel.textColor;
        self.titleView.addtime.textColor = self.daynightmodel.titleColor;
        self.titleView.titleLabel.textColor = self.daynightmodel.textColor;
        self.titleView.backgroundColor = self.daynightmodel.navigationColor;
        
        //添加关注
        __weak DetailPageViewController *wself = self;
        self.titleView.block = ^(UIButton *sender){
            if (US.isLogIn) {
                if (sender.selected == YES) {
                    sender.selected = NO;
                    sender.layer.borderColor = [UIColor darkGrayColor].CGColor;
                    [wself cancelAttention];
                }
                else
                {
                    sender.selected = YES;
                    sender.layer.borderColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0].CGColor;
                    [wself addAttention];
                }
            }
            else
            {
                [wself gotLoginViewController];
            }
        };
    }
    else        //观点
    {
        [self.titleView.userheadImage sd_setImageWithURL:[NSURL URLWithString:self.viewInfo.userinfo_facesmall]];
        self.titleView.usernickname.text = self.viewInfo.view_author;
        self.titleView.addtime.text = self.viewInfo.view_addtime;
        
        self.titleView.userheadImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserInfo:)];
        [self.titleView.userheadImage addGestureRecognizer:tap];
        
        NSString *text = self.viewInfo.view_title;
        UIFont *font = [UIFont systemFontOfSize:20];
        self.titleView.titleLabel.font = font;
        self.titleView.titleLabel.numberOfLines = 0;
        titlesize = CGSizeMake(kScreenWidth-30, 20000.0f);
        titlesize = [text calculateSize:titlesize font:font];
        self.titleView.titleLabel.text = text;
        [self.titleView.titleLabel setFrame:CGRectMake(15, 75, kScreenWidth-30, titlesize.height)];
        
        self.titleView.usernickname.textColor = self.daynightmodel.titleColor;
        self.titleView.addtime.textColor = self.daynightmodel.titleColor;
        self.titleView.titleLabel.textColor = self.daynightmodel.textColor;
        self.titleView.backgroundColor = self.daynightmodel.navigationColor;
        
        NSString *is_attention_author = [NSString stringWithFormat:@"%@",self.viewInfo.is_attention_author];
        if ([is_attention_author isEqualToString:@"0"]) {
            self.titleView.isAttention.selected = NO;
        }
        else
        {
            self.titleView.isAttention.selected = YES;
            self.titleView.isAttention.layer.borderColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0].CGColor;
        }
        
        __weak DetailPageViewController *wself = self;
        self.titleView.block = ^(UIButton *sender){
            if (US.isLogIn) {
                if (sender.selected == YES) {
                    sender.selected = NO;
                    sender.layer.borderColor = [UIColor darkGrayColor].CGColor;
                    [wself cancelAttention];
                }
                else
                {
                    sender.selected = YES;
                    sender.layer.borderColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0].CGColor;
                    [wself addAttention];
                }
            }
            else
            {
                [wself gotLoginViewController];
            }
        };
    }
    [self.titleView setFrame:CGRectMake(0, 0, kScreenWidth, 75+titlesize.height+10)];
    [self.scrollview addSubview:self.titleView];
}

- (void)setupWithWebView{
    self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 75+titlesize.height+10, kScreenWidth, kScreenHeight-64)];
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
    self.webview.scrollView.scrollEnabled = NO;
    [self.scrollview addSubview:self.webview];
}

- (void)setupWithTableView{
    DetailTableViewController *childTab = [[DetailTableViewController alloc]init];
    childTab.delegate = self;
    childTab.pagemode = self.pageMode;
    childTab.tableView.backgroundColor = self.daynightmodel.navigationColor;
    [self addChildViewController:childTab];
    
    if ([self.pageMode isEqualToString:@"sharp"]) {
        childTab.sharp_id = self.sharp_id;
        [childTab requestCommentDataWithPage:self.page];
    }
    else
    {
        childTab.view_id = self.view_id;
        [childTab requestWithCommentDataWithTimeHot];
    }
    [self.scrollview addSubview:childTab.tableView];
}

- (void)updateWithTableView{
    DetailTableViewController *childTab = self.childViewControllers[0];
    childTab.tableView.frame = CGRectMake(0, 75+titlesize.height+10 + websize.height + 10+self.tagList.frame.size.height+10, kScreenWidth, childTab.tableView.contentSize.height);

    self.scrollview.contentSize = CGSizeMake(kScreenWidth, 75+titlesize.height+10 + self.webview.frame.size.height + 10+self.tagList.frame.size.height+10 + childTab.tableView.contentSize.height);
}

- (void)setupWithTagsView{
    self.tagList = [[SharpTags alloc]initWithFrame:CGRectMake(0, 75+titlesize.height+10+kScreenHeight-64, kScreenWidth, 1)];
    self.tagList.delegate = self;
    self.tagList.signalTagColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
    self.tagList.BGColor = self.daynightmodel.navigationColor;
    /* 判断sharpTagsArray是否为空 */
    if ((NSNull *)self.sharpTagsArray != [NSNull null]) {
        NSArray *arr = [NSArray array];
        if (self.sharpTagsArray.count > 4) {
            arr = [self.sharpTagsArray subarrayWithRange:NSMakeRange(0, 4)];
        }else
        {
            arr = self.sharpTagsArray;
        }
        [self.tagList setTagWithTagArray:arr];
    }
    [self.scrollview addSubview:self.tagList];
}

- (void)setupWithCommentView{
    self.backcommentview = [[BackCommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50)];
    self.backcommentview.backgroundColor = self.daynightmodel.backColor;
    self.backcommentview.commentview.backgroundColor = self.daynightmodel.inputColor;
    self.backcommentview.commentview.textColor = self.daynightmodel.textColor;
    self.backcommentview.commentview.layer.borderColor = self.daynightmodel.lineColor.CGColor;
    self.backcommentview.delegate = self;
    self.backcommentview.commentview.delegate = self;
    
    [self.view addSubview:self.backcommentview];
}

#pragma mark - request action
- (void)requestAction{
    if (US.isLogIn) {
        //进行身份验证
        [self requestAuthentication];
    }
    
    if ([self.pageMode isEqualToString:@"sharp"]) {
        [self requestWithSharp];
    }
    else if([self.pageMode isEqualToString:@"view"])
    {
        [self requestWithView];
    }
}

#pragma mark - 身份验证
-(void)requestAuthentication
{
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *para = @{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = data;
            self.encryptedStr = dic[@"str"];
        } else {
            nil;
        }
    }];
}

#pragma mark - 调研请求部分
- (void)requestWithSharp{
    self.hudload = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hudload.labelText = @"加载中...";
    
    NSString *url;
    if (US.isLogIn) {
        url = [NSString stringWithFormat:@"index.php/Sharp/sharp_show1_2/id/%@/userid/%@",self.sharp_id,US.userId];
        
    }
    else
    {
        url = [NSString stringWithFormat:@"index.php/Sharp/sharp_show1_2/id/%@",self.sharp_id];
        
    }
    
    __weak DetailPageViewController *wself = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:url parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            
            wself.sharpInfo = [SharpModel sharpWithDictionary:data];
            /* 判断数组是否为空 */
            if ((NSNull *)wself.viewInfo.tags != [NSNull null]) {
                self.sharpTagsArray = [NSMutableArray arrayWithArray:wself.sharpInfo.sharpTags];
            }
            
            [self setupWithTitleView];
            [self setupWithWebView];
            [self setupWithTagsView];
            
            NSString *string;
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *daynight = [userdefault objectForKey:@"daynight"];
            if ([daynight isEqualToString:@"yes"]) {
                string = [NSString stringWithFormat:@"%@%@/mode/0",API_HOST,self.sharpInfo.sharpContent];
            }
            else
            {
                string = [NSString stringWithFormat:@"%@%@/mode/1",API_HOST,self.sharpInfo.sharpContent];
            }
            
            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            
        } else {
            wself.hudload.labelText = @"加载失败";
            [wself.hudload hide:YES afterDelay:0.1];
        }
    }];
}


#pragma mark - 观点请求部分
- (void)requestWithView{
    
    self.hudload = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hudload.labelText = @"加载中...";
    
    NSString *urlPath ;
    
    if (US.isLogIn) {
        urlPath= [NSString stringWithFormat:@"index.php/View/view_show1_2/id/%@/user_id/%@",self.view_id,US.userId];
    }
    else
    {
        urlPath = [NSString stringWithFormat:@"index.php/View/view_show1_2/id/%@",self.view_id];
    }
    __weak DetailPageViewController *wself = self;
    NetworkManager *ma = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [ma GET:urlPath parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            wself.viewInfo = [ViewModel shareWithDictionary:data];
            /* 判断数组是否为空 */
            if ((NSNull *)wself.viewInfo.tags != [NSNull null]) {
                self.sharpTagsArray = [NSMutableArray arrayWithArray:wself.viewInfo.tags];
            }
            [self setupWithTitleView];
            [self setupWithWebView];
            [self setupWithTagsView];
            
            NSString *string;
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *daynight = [userdefault objectForKey:@"daynight"];
            if ([daynight isEqualToString:@"yes"]) {
                string = [NSString stringWithFormat:@"%@%@/mode/0",API_HOST,self.viewInfo.view_content_url];
            }
            else
            {
                string = [NSString stringWithFormat:@"%@%@/mode/1",API_HOST,self.viewInfo.view_content_url];
            }
            
            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            
        }
        else
        {
            self.hudload.labelText = @"加载失败";
            [self.hudload hide:YES afterDelay:0.1];
        }
    }];
}

- (void)reloadCommentNumber
{
    if (self.FirstcommentArr.count > 0) {
        NSString *text;
        if (self.FirstcommentArr.count >999) {
            text = @"999+";
        }else
        {
            text = [NSString stringWithFormat:@"%lu",(unsigned long)self.FirstcommentArr.count];
        }
        CGSize size = CGSizeMake(50, 200.0f);
        UIFont *font = [UIFont systemFontOfSize:11];
        CGSize btnsize = [text calculateSize:size font:font];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100+28, 8, btnsize.width+10, btnsize.height)];
        btn.titleLabel.font = [UIFont systemFontOfSize: 11];
        btn.layer.cornerRadius = btnsize.height/2;
        [btn setBackgroundColor:[UIColor colorWithRed:27/255.0 green:105/255.0 blue:177/255.0 alpha:1.0]];
        [btn setTitle:text forState:UIControlStateNormal];
        //新增点击滑动
        [btn addTarget:self action:@selector(clickComments:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backcommentview addSubview:btn];
    }
}

#pragma mark - 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView.isLoading) {
        return;
    }
    //调整字号
    
    NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",self.fontsize];
    [webView evaluateJavaScript:jsZiti completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //
    }];
    
    __weak DetailPageViewController *wself = self;
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = webView.frame;
        frame.size.height = documentHeight + 15/*显示不全*/;
        webView.frame = frame;
        websize = frame.size;
        
        [self.tagList setFrame:CGRectMake(0, 75+titlesize.height+10 + frame.size.height, kScreenWidth, 10+self.tagList.frame.size.height+10)];
        
        [self didfinishReload];
        
        //停止加载样式
        wself.hudload.labelText = @"加载完成";
        [wself.hudload hide:YES afterDelay:0.1];
        
    }];
}

- (void)gotoUserInfo:(UITapGestureRecognizer *)tap{
    if (US.isLogIn) {
        UserInfoViewController *userinfoView = [[UserInfoViewController alloc]init];
        if ([self.pageMode isEqualToString:@"sharp"]) {
            NSLog(@"%@",self.sharpInfo.sharpUserId);
            userinfoView.user_id = self.sharpInfo.sharpUserId;
            [self.navigationController pushViewController:userinfoView animated:YES];
            
        }
        else
        {
            NSLog(@"%@",self.viewInfo.view_userid);
            userinfoView.user_id = self.viewInfo.view_userid;
            [self.navigationController pushViewController:userinfoView animated:YES];
        }
    }
    else
    {
        [self gotLoginViewController];
        
    }
}

#pragma mark - 点击菜单
- (void)naviMore:(UIButton *)sender{
    //显示更多菜单
    if (naviShow == NO) {
        self.nmview.alpha = 1.0;
        naviShow = YES;
    }
    else
    {
        self.nmview.alpha = 0.0;
        naviShow = NO;
    }
    
}

#pragma mark - 浮窗的代理方法
- (void)didSelectedWithIndexPath:(UITableViewCell *)cell
{
    if ([cell.textLabel.text isEqualToString:@"复制链接"]) {
        NSLog(@"%@",cell.textLabel.text);
    }
    else if ([cell.textLabel.text isEqualToString:@"收藏"]){
        if (US.isLogIn == NO) {
            [self gotLoginViewController];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"btn_col_pre"];
            cell.textLabel.text = @"取消收藏";
            [self addCollection];
        }
    }
    else if ([cell.textLabel.text isEqualToString:@"取消收藏"]){
        if (US.isLogIn == NO) {
            [self gotLoginViewController];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"btn_col"];
            cell.textLabel.text = @"收藏";
            [self clearCollection];
        }
    }
    else if ([cell.textLabel.text isEqualToString:@"字体大小"]){
        
        self.nmview.alpha = 0.0;
        self.sfview.alpha = 1.0;
        self.sfview.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-64);
        
    }
    else if ([cell.textLabel.text isEqualToString:@"日间模式"]){
        //读取用户设置
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefault objectForKey:@"daynight"];
        if ([daynight isEqualToString:@"yes"]) {
            [self.daynightmodel night];
            daynight = @"no";
            [userdefault setValue:daynight forKey:@"daynight"];
            [userdefault synchronize];
            
            [self.webview evaluateJavaScript:@"nightMode()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //
            }];
        }
        self.nmview.alpha = 0.0;
        naviShow = NO;
        
    }
    else if([cell.textLabel.text isEqualToString:@"夜间模式"])
    {
        //读取用户设置
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *daynight = [userdefault objectForKey:@"daynight"];
        [self.daynightmodel day];
        daynight = @"yes";
        [userdefault setValue:daynight forKey:@"daynight"];
        [userdefault synchronize];
        
        [self.webview evaluateJavaScript:@"nightMode()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //
        }];
    }
    else
    {
        //举报
        self.nmview.alpha = 0.0;
        naviShow = NO;
        if (US.isLogIn == NO) {
            //跳转到登录页面
            LoginViewController *login = [[LoginViewController alloc] init];
            login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
            [self.navigationController pushViewController:login animated:YES];
        }
        else
        {
            FeedbackViewController *feedback =  [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FeedbackView"];
            [self.navigationController pushViewController:feedback animated:YES];
            
        }
    }
}

#pragma mark - 点击收藏取消收藏
- (void)addCollection{
    if (US.isLogIn) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"添加收藏";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dic ;
        if ([self.pageMode isEqualToString:@"sharp"]) {
            dic = @{@"userid":US.userId,
                    @"module_id":@2,
                    @"item_id":self.sharp_id};
        }
        else
        {
            dic = @{@"userid":US.userId,
                    @"module_id":@3,
                    @"item_id":self.view_id};
        }
        
        
        [manager POST:API_AddCollection parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                hud.labelText = @"收藏成功";
                [hud hide:YES afterDelay:0.2];
                
            } else {
                hud.labelText = @"收藏失败";
                [hud hide:YES afterDelay:0.2];
            }
        }];
    }
}

- (void)clearCollection{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"取消收藏";
    
    
    NSMutableArray *IDArr = [NSMutableArray array];
    
    
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *para ;
    if ([self.pageMode isEqualToString:@"sharp"]) {
        [IDArr addObject:self.sharp_id];
        para = @{@"authenticationStr":US.userId,
                   @"encryptedStr":self.encryptedStr,
                   @"delete_ids":IDArr,
                   @"module_id":@"2",
                   @"userid":US.userId};
    }
    else
    {
       [IDArr addObject:self.view_id];
       para = @{@"authenticationStr":US.userId,
                @"encryptedStr":self.encryptedStr,
                @"delete_ids":IDArr,
                @"module_id":@"3",
                @"userid":US.userId};
        
    }
    [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"取消成功";
            [hud hide:YES afterDelay:0.2];
        } else {
            hud.labelText = @"取消失败";
            [hud hide:YES afterDelay:0.2];
        }
    }];
}

#pragma mark - 更改字体的浮窗
- (void)clickSure:(UIButton *)sender
{
    self.sfview.alpha = 0.0;
    self.nmview.alpha = 0.0;
    naviShow = NO;
    
    NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",self.fontsize];
    [self.webview evaluateJavaScript:jsZiti completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //
    }];
    
    __weak DetailPageViewController *wself = self;
    [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = self.webview.frame;
        frame.size.height = documentHeight + 15/*显示不全*/;
        self.webview.frame = frame;
        websize = frame.size;
        
        [self.tagList setFrame:CGRectMake(0, 75+titlesize.height+10 + frame.size.height, kScreenWidth, 10+self.tagList.frame.size.height+10)];
        
        [self updateWithTableView];
        
        DetailTableViewController *childTab = self.childViewControllers[0];
        wself.scrollview.contentSize = CGSizeMake(kScreenWidth, 75+titlesize.height+10 + frame.size.height + 10+self.tagList.frame.size.height+10 + childTab.tableView.contentSize.height);
        //停止加载样式
        wself.hudload.labelText = @"加载完成";
        [wself.hudload hide:YES afterDelay:0.1];
        
    }];
}

- (void)clickCancel:(UIButton *)sender
{
    self.sfview.alpha = 0.0;
    self.nmview.alpha = 0.0;
    naviShow = NO;
}

- (void)SelectFontWithIndexPath:(NSInteger)indexPath
{
    self.fontsize = self.sizeArr[indexPath];
}
#pragma mark - addAttention
- (void)addAttention{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"关注中";
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/addAttention"];
    NSDictionary *dic;
    if ([self.pageMode isEqualToString:@"sharp"]) {
        dic = @{
                @"My_user_id":US.userId,
                @"user_id":self.sharpInfo.sharpUserId,
                };
    }
    else
    {
        dic = @{
                @"My_user_id":US.userId,
                @"user_id":self.viewInfo.view_userid,
                };
    }
    
    [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"已关注";
            [hud hide:YES afterDelay:0.1];
        }
        else
        {
//            hud.labelText = @"已关注";
            [hud hide:YES afterDelay:1];
        }
    }];
}

#pragma mark - cancelAttention
- (void)cancelAttention{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"取消关注";
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSString *urlString = [NSString stringWithFormat:@"index.php/Blog/cancelAttention"];
    NSDictionary *dic;
    if ([self.pageMode isEqualToString:@"sharp"]) {
        dic = @{
                @"My_user_id":US.userId,
                @"user_id":self.sharpInfo.sharpUserId,
                };
    }
    else
    {
        dic = @{
                @"My_user_id":US.userId,
                @"user_id":self.viewInfo.view_userid,
                };
    }
    [manager POST:urlString parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            hud.labelText = @"已取消";
            [hud hide:YES afterDelay:0.1];
        }
        else
        {
//            hud.labelText = data[@"msg"];
            [hud hide:YES afterDelay:1];
        }
    }];
}

#pragma mark - 标签代理方法
- (void)ClickTags:(UIButton *)sender
{
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.searchTags = sender.titleLabel.text;
    searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - childTabDelegate
- (void)didSelectCellforPid:(NSString *)pid andNickName:(NSString *)nick
{
    [self.backcommentview.commentview becomeFirstResponder];
    self.backcommentview.commentview.placeholder = [NSString stringWithFormat:@"回复 %@:",nick];
    self.pid = pid;
}

- (void)reply:(FloorView *)sender
{
    [self.backcommentview.commentview becomeFirstResponder];
    self.backcommentview.commentview.placeholder = [NSString stringWithFormat:@"回复 %@:",sender.nicknameLab.text];
    self.pid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!US.isLogIn) {
        [self gotLoginViewController];
        return NO;
    }
    return YES;
}

- (void)gotLoginViewController
{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:login animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendCommentWithText:textField.text];

    return YES;
}

- (void)didfinishReload
{
    DetailTableViewController *childTab = self.childViewControllers[0];
    childTab.tableView.frame = CGRectMake(0, 75+titlesize.height+10 + websize.height + 10+self.tagList.frame.size.height+10, kScreenWidth, childTab.tableView.contentSize.height);
    self.scrollview.contentSize = CGSizeMake(kScreenWidth, 75+titlesize.height+10 + self.webview.frame.size.height + 10+self.tagList.frame.size.height+10 + childTab.tableView.contentSize.height);
    
    [self.scrollview.mj_header endRefreshing];
    [self.scrollview.mj_footer endRefreshing];
}

- (void)sendCommentWithText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    if ([self.pageMode isEqualToString:@"sharp"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"发表新评论";
        
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        NSDictionary *dic = @{@"id":self.sharp_id,@"userid":US.userId,@"sharpcomment":text,@"authenticationStr":US.userId,@"encryptedStr":self.encryptedStr};
        
        [manager POST:API_AddSharpComment parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                hud.labelText = @"评论成功";
                [hud hide:YES afterDelay:0.2];
                self.backcommentview.commentview.text = @"";
                //请求评论数据
                DetailTableViewController *childTab = self.childViewControllers[0];
                [childTab requestCommentDataWithPage:self.page];  //请求
                //滑动到评论
                [self.backcommentview.backComment setImage:[UIImage imageNamed:@"nav_zt"] forState:UIControlStateNormal];
                [self.scrollview setContentOffset:CGPointMake(0, 75+titlesize.height+10+websize.height+10+self.tagList.frame.size.height+10) animated:YES];
                
            } else {
                hud.labelText = @"评论失败";
                [hud hide:YES afterDelay:0.2];
            }
        }];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"发表评论";
        
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        NSDictionary *para = @{@"comment_content":text,
                               @"user_id":US.userId,
                               @"view_id":self.view_id,
                               @"comment_pid":self.pid};
        
        [manager POST:API_AddViewCommont parameters:para completion:^(id data, NSError *error){
            if (!error) {
                hud.labelText = @"评论成功";
                [hud hide:YES afterDelay:0.2];
                self.backcommentview.commentview.text = @"";
                //请求评论数据
                DetailTableViewController *childTab = self.childViewControllers[0];
                [childTab requestWithCommentDataWithTimeHot];  //请求
                //滑动到评论
                [self.backcommentview.backComment setImage:[UIImage imageNamed:@"nav_zt"] forState:UIControlStateNormal];
                [self.scrollview setContentOffset:CGPointMake(0, 75+titlesize.height+10+websize.height+10+self.tagList.frame.size.height+10) animated:YES];

            } else {
                hud.labelText = @"评论失败";
                [hud hide:YES afterDelay:0.1f];
            }
        }];
    }
    
}

#pragma mark - Action
- (void)clickComments:(UIButton *)sender{
    if (self.scrollview.contentOffset.y > self.webview.frame.size.height-400) {
        [self.backcommentview.backComment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        //回到顶部
        [self.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    else
    {
        //滑动到评论
        [self.backcommentview.backComment setImage:[UIImage imageNamed:@"nav_zt"] forState:UIControlStateNormal];
        [self.scrollview setContentOffset:CGPointMake(0, 75+titlesize.height+10+websize.height+10+self.tagList.frame.size.height+10) animated:YES];

    }
}

- (void)clickShare:(UIButton *)sender{
    //释放键盘第一响应
    [self.backcommentview.commentview resignFirstResponder];
    //1、创建分享参数
    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if ([self.pageMode isEqualToString:@"sharp"]) {
        [shareParams SSDKSetupShareParamsByText:self.sharpInfo.sharpDesc
                                         images:@[self.sharpInfo.sharpThumbnail]
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/Sharp/show/sid/%@",self.sharp_id]]
                                          title:self.sharpInfo.sharpTitle
                                           type:SSDKContentTypeAuto];
    }
    else
    {
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:@[self.viewInfo.userinfo_facesmall]
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/View/%@",self.viewInfo.view_id]]
                                          title:self.viewInfo.view_title
                                           type:SSDKContentTypeAuto];
    }
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
                           [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                           [self presentViewController:alert animated:YES completion:nil];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享失败" preferredStyle:UIAlertControllerStyleAlert];
                           [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                           [self presentViewController:alert animated:YES completion:nil];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.backcommentview.commentview resignFirstResponder];
    self.nmview.alpha = 0.0;
    if (self.scrollview.contentOffset.y > self.webview.frame.size.height-400) {
        
        [self.backcommentview.backComment setImage:[UIImage imageNamed:@"nav_zt"] forState:UIControlStateNormal];
    }
    else
    {
        [self.backcommentview.backComment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    }
}

#pragma mark - viewWill
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        [self.daynightmodel day];
    }
    else
    {
        [self.daynightmodel night];
    }
    [userdefault addObserver:self forKeyPath:@"daynight" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //移除观察者模式
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault removeObserver:self forKeyPath:@"daynight"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听daynight
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"daynight"]) {
        self.view.backgroundColor = self.daynightmodel.navigationColor;
        self.scrollview.backgroundColor = self.daynightmodel.backColor;
        [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
        [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
        
        self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
        
        self.titleView.usernickname.textColor = self.daynightmodel.textColor;
        self.titleView.addtime.textColor = self.daynightmodel.titleColor;
        self.titleView.titleLabel.textColor = self.daynightmodel.textColor;
        self.titleView.backgroundColor = self.daynightmodel.navigationColor;
        
        self.backcommentview.backgroundColor = self.daynightmodel.backColor;
        self.backcommentview.commentview.backgroundColor = self.daynightmodel.inputColor;
        self.backcommentview.commentview.textColor = self.daynightmodel.textColor;
        self.backcommentview.commentview.layer.borderColor = self.daynightmodel.lineColor.CGColor;
        
        [UINavigationBar appearance].barTintColor = self.daynightmodel.navigationColor;   // 设置导航条背景颜色
        [UINavigationBar appearance].translucent = NO;
        [UINavigationBar appearance].tintColor = self.daynightmodel.navigationColor;    // 设置左右按钮，文字和图片颜色
        // 设置导航条标题字体和颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName:self.daynightmodel.titleColor, NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
        [[UINavigationBar appearance] setTitleTextAttributes:dict];
        
        // 设置导航条左右按钮字体和颜色
        NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
        
        [self.nmview.tableview reloadData];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        DetailTableViewController *childTab = self.childViewControllers[0];
        [childTab.tableView setFrame:CGRectMake(0, 75+titlesize.height+10 + websize.height + 10+self.tagList.frame.size.height+10, kScreenWidth, childTab.tableView.contentSize.height)];
        
        self.scrollview.contentSize = CGSizeMake(kScreenWidth, 75+titlesize.height+10 + websize.height + 10+self.tagList.frame.size.height+10 + childTab.tableView.contentSize.height);
    }
    
}

- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}

//当键盘出现时计算键盘的高度大小，用于输入框显示
- (void)keyboardWasShown:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    //kbSize为键盘尺寸
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    [self beginMoveUpAnimation:kbSize.height];
    
}

//当键盘隐藏时
- (void)keyboardWillBeHidden{
    
    self.backcommentview.transform = CGAffineTransformIdentity;
    self.backcommentview.commentview.placeholder = @"自古评论出人才，快来发表评论吧";
}

- (void)beginMoveUpAnimation:(CGFloat )height{
    self.backcommentview.transform = CGAffineTransformMakeTranslation(0, -height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
