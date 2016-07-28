//
//  SharpDetailsViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "SharpDetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BackCommentView.h"
#import "NSString+TimeInfo.h"
#import "NSString+Ext.h"

#import "LoginState.h"
#import "TitlesTableViewCell.h"
#import "AddCollectionTableViewCell.h"
#import "ShowTableViewCell.h"
#import "CommentsModel.h"
#import "SharpTags.h"
#import "LoginTableViewController.h"
#import "CollectionViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

//测试
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
/* loading */
#import "FSSyncSpinner.h"
#import "MJRefresh.h"
#import <WebKit/WebKit.h>

#import "MBProgressHUD.h"

@interface SharpDetailsViewController ()<WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIWebViewDelegate>
{
    int page;
    
    CGSize commentsize;
    CGSize originalsize;
    
    NSString *typeid;
    NSString *encryptedStr;
    NSString *title;
    NSString *nickname;
    NSString *facesmall;
    NSString *time;
    NSString *iscollect;
    NSString *isoriginal;   //是否原创0是1不是
    NSString *commentNum;
    NSString *desc;
    NSString *sharpimg;
    UIView *bgView;    //点击放大图片背景
    
    UILabel *label;
    UIButton *button;
    UIView *view;
    NSTimer *myTimer;
    BOOL firstClickComment;
    
}

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIWebView *webview;
//@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic) BOOL scalesPageToFit;
/* 评论条 */
@property (nonatomic,strong) BackCommentView *backcommentview;
/* 加载页 */
@property (nonatomic,strong) UIView *loadingBackView;
/* 设置加载控件 */
@property (nonatomic,strong) FSSyncSpinner *indicator;
/* 设置加载图片 */
@property (nonatomic,strong) UIImageView *loadingImgView;
@property (nonatomic,strong) UILabel *loading1;
@property (nonatomic,strong) UILabel *loading2;

@property (nonatomic,strong) NSMutableArray *commentsDataArray;
@property (nonatomic,strong) NSArray *sharpTagsArray;

@property (nonatomic,strong) SharpTags *tagList;

@property (nonatomic,strong) LoginState *loginstate;

/* 点击放大图片 */
@property (nonatomic,strong) UIImageView *imgView;
/* 文章中的所有图片 */
@property (nonatomic,strong) NSMutableArray *imageViews;

@end

@implementation SharpDetailsViewController

- (void)dealloc
{
    [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupWithNavigation];
    [self setupUICommon];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.commentsDataArray = [NSMutableArray array];
    self.sharpTagsArray = [NSMutableArray array];
    self.loginstate = [LoginState addInstance];
    page = 1;
    
    [self refreshAction];
}

- (void)setupWithNavigation{
    [self.navigationController.navigationBar setHidden:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;    //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方
    //设置navigation背景色
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"nav_night_more@3x.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(naviMore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    if (self.loginstate.isLogIn) {
        //进行身份验证
        [self requestAuthentication];
    }
    [self registerForKeyboardNotifications];
    firstClickComment = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view endEditing:YES];
}


#pragma mark UICommon
- (void)setupUICommon
{
    [self setupWebView];
    [self setupTableView];
    [self setupCommentView];
    [self setupStatusBar];
}

- (void)setupWebView
{
//    self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    self.webview.UIDelegate = self;
//    self.webview.navigationDelegate = self;
//    self.webview.scrollView.scrollEnabled = NO;
//    self.webview.scrollView.bounces = NO;
    
    self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.webview.delegate = self;
    self.webview.scrollView.scrollEnabled = NO;
    
    [self.webview.scrollView addObserver:self
                              forKeyPath:@"contentSize"
                                 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                 context:nil];
}

- (void)setupTableView
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-70) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableview];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)setupCommentView
{
    self.backcommentview = [[BackCommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    [self.backcommentview.backback addTarget:self action:@selector(clickGOBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.backcommentview.backButton addTarget:self action:@selector(clickGOBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backcommentview.backComment addTarget:self action:@selector(clickComments:) forControlEvents:UIControlEventTouchUpInside];
    [self.backcommentview.ClickComment addTarget:self action:@selector(clickComments:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backcommentview.backShare addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.backcommentview.ClickShare addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backcommentview.commentview.delegate = self;
    
    [self.view addSubview:self.backcommentview];
}

- (void)setupStatusBar
{
    UIView *status = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    status.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:status];
}

- (void)stopLoadView
{
    //停止加载样式
    [_indicator finish];
    self.loadingImgView.alpha = 0.0;
    [self.loadingImgView removeFromSuperview];
    self.loading1.alpha = 0.0;
    [self.loading1 removeFromSuperview];
    self.loading2.alpha = 0.0;
    [self.loading2 removeFromSuperview];
    self.loadingBackView.alpha = 0.0;
    [self.loadingBackView removeFromSuperview];
}

#pragma mark Observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize oldSize = [change[NSKeyValueChangeOldKey] CGSizeValue];
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        if (oldSize.height == contentSize.height) {
            return;
        }
        
        self.webview.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
        [self.tableview reloadData];
    }
}

#pragma mark Request Data
- (void)refreshAction {
    //数据表页数为1
    page = 1;
    [self requestDataWithUrl];
    [self requestDataWithComments];
}

- (void)loadMoreAction {
     page++;
    //继续请求
    [self requestDataWithComments];
}


- (void)requestDataWithComments{
    
    NSString *string = [NSString stringWithFormat:@"%@getSharpComnment/id/%@/page/%d",kAPI_Sharp,self.sharp_id,page];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (page == 1) {
            [self.commentsDataArray removeAllObjects];
        }
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *d in arr) {
                /* 转模型 */
                CommentsModel *model = [CommentsModel getInstanceWithDictionary:d];
                [self.commentsDataArray addObject:model];
            }
        }
        else
        {
            NSLog(@"没有更多了");
        }
        
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
        [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview.mj_footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableview.mj_footer endRefreshing];
        NSLog(@"请求失败");
    }];
}

- (void)requestDataWithUrl{
    self.loadingBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.loadingBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingBackView];
    
    self.loadingImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-kScreenWidth/4)/2+10, kScreenHeight/736*298, kScreenWidth/4, kScreenWidth/10)];
    self.loadingImgView.image = [UIImage imageNamed:@"loadingLogo.png"];
    [self.loadingBackView addSubview:self.loadingImgView];
    
    self.loading1 = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight/2-5, kScreenWidth, 20)];
    self.loading1.text = @"投资看公司";
    self.loading1.font = [UIFont systemFontOfSize:16];
    self.loading1.textColor = [UIColor lightGrayColor];
    self.loading1.textAlignment = NSTextAlignmentCenter;
    [self.loadingBackView addSubview:self.loading1];
    
    self.loading2 = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight/2+20, kScreenWidth, 20)];
    self.loading2.text = @"分享有价值的信息";
    self.loading2.font = [UIFont systemFontOfSize:16];
    self.loading2.textColor = [UIColor lightGrayColor];
    self.loading2.textAlignment = NSTextAlignmentCenter;
    [self.loadingBackView addSubview:self.loading2];
    
    self.indicator = [[FSSyncSpinner alloc]initWithFrame:CGRectMake(-30, 0, 30, 30)];
    [self.loadingImgView addSubview:self.indicator];
    [self.indicator startAnimating];
    NSString *url;
    if (self.loginstate.isLogIn) {
        url = [NSString stringWithFormat:@"%@show/id/%@/userid/%@",kAPI_Sharp,self.sharp_id,self.loginstate.userId];
        
    }
    else
    {
        url = [NSString stringWithFormat:@"%@show/id/%@",kAPI_Sharp,self.sharp_id];
        
    }
    
    __weak SharpDetailsViewController *wself = self;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        FIXME: 后面改成对象，不要定义这么变量
        NSDictionary *data = responseObject[@"data"];
        self.sharpTagsArray = data[@"tags"];
        NSString *string = data[@"sharp_content"];
        typeid = data[@"sharp_typeid"];
        title = data[@"sharp_title"];
        desc = data[@"sharp_desc"];
        nickname = data[@"user_nickname"];
        facesmall = data[@"userinfo_facesmall"];
        time = data[@"sharp_wtime"];
        commentNum = data[@"sharpcommentNumbers"];
        iscollect = data[@"sharp_iscollect"];
        isoriginal = data[@"sharp_isoriginal"];
        sharpimg = data[@"sharp_pic280"];
        
        if ([commentNum intValue] > 0) {
            NSString *text;
            if ([commentNum intValue] >999) {
                text = @"999+";
            }else
            {
                text = [NSString stringWithFormat:@"%@",commentNum];
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
        
        // iOS webkit preload 没有预加载视频导致视频背景为白色，使用autoplay替换
//        string = [string stringByReplacingOccurrencesOfString:@"preload" withString:@"preload=\"load\""];
        
        [self stopLoadView];
        [wself.tableview.mj_header endRefreshing];
        [self.tableview reloadData];
        
        [self.webview loadHTMLString:string baseURL:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self stopLoadView];
        [wself.tableview.mj_header endRefreshing];
    }];
}


#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    else
    {
        /* 判断评论数组中是否有数据 */
        if (self.commentsDataArray.count == 0) {
            //没有
            return 2;
        }
        else
        {
            return self.commentsDataArray.count + 1;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 130;
        }
        else if(indexPath.row == 1){
            return self.webview.frame.size.height;
        }
        else if (indexPath.row == 2){
            return 80;
        }
        else if (indexPath.row == 3)
        {
            /* 这里是标签栏的高度 */
            //也要做自适应
            return 10+self.tagList.frame.size.height+10;
        }
        else if(indexPath.row == 4){
            return 15+originalsize.height+15;
        }
        else
        {
            return 20;
        }
    }
    else
    {
        if (indexPath.row == 0) {
            return 44;
        }
        /* 设置高度自适应 */
        return 10+15+5+12+10+commentsize.height+10;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TitlesTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            if (titleCell == nil) {
                titleCell = [[TitlesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            }
            titleCell.titleLabel.text = title;
            NSString *custime = [NSString prettyDateWithReference:time];
            titleCell.usernickname.text = nickname;
            titleCell.addtime.text = custime;
            [titleCell.userheadImage sd_setImageWithURL:[NSURL URLWithString:facesmall]];
            return titleCell;
        }
        else if(indexPath.row == 1){
            NSString *identifier = @"webcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                if (self.webview) {
                    [cell.contentView addSubview:self.webview];
                }
            }
            
            // 判断webview 是否添加到cell 上
            if (!self.webview.superview) {
                [cell.contentView addSubview:self.webview];
            }
            
            return cell;
        }
        else if (indexPath.row == 2){
            AddCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addcollectioncell"];
            if (cell == nil) {
                cell = [[AddCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addcollectioncell"];
            }
            if ([iscollect intValue] == 0) {
                [cell.addCollection setBackgroundImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.addCollection setBackgroundImage:[UIImage imageNamed:@"收藏成功.png"] forState:UIControlStateNormal];
            }
//            cell.contentView.backgroundColor = [UIColor redColor];
            [cell.addCollection addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
            //设置三秒内不可重复点击
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
        else if(indexPath.row == 3){
            /* 这里是文章标签 */
            NSString *identifier = @"tagscell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor clearColor];
            [self.tagList removeFromSuperview];
            self.tagList = [[SharpTags alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 1)];
            self.tagList.signalTagColor = [UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0];
            self.tagList.BGColor = [UIColor clearColor];
            
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
            [cell addSubview:self.tagList];
            
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 4){
            NSString *identifier = @"isoriginal";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *text;
            if ([isoriginal isEqualToString:@"1"]) {
                if ([typeid isEqualToString:@"1"]) {
                    text = @"该篇调研文章是实地调查取材，仅供用户阅读，版权归局外人网站所有，不得擅自以其他媒体等公共形式流传，违者需赔偿我方版权损失， 我方并将保留法律诉讼的权利。";
                }
                else
                {
                    text = @"文章原创，禁止恶意转载，转载请注明出处和作者!";
                }
            }
            else
            {
                text = @" 本文文章内容从互联网转载，最终版权归原作者所有。";
            }
            

            UIFont *font = [UIFont systemFontOfSize:16];
            cell.textLabel.font = font;
            cell.textLabel.numberOfLines = 0;
            originalsize = CGSizeMake(kScreenWidth-16, 20000.0f);
            originalsize = [text calculateSize:originalsize font:font];
            cell.textLabel.text = text;
            cell.textLabel.textColor = [UIColor colorWithRed:56/255.0 green:115/255.0 blue:178/255.0 alpha:1.0];
            [cell.textLabel setFrame:CGRectMake(8, 15, kScreenWidth-16, originalsize.height)];
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSString *identifier = @"spacecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    /* 这里是·列表展示 */
    else
    {
        if (indexPath.row == 0) {
            NSString *identifier = @"aboutcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"相关评论";
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            /* 当前没有评论时 */
            if (self.commentsDataArray.count == 0) {
                NSString *identifier = @"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.textLabel.text = @"当前文章还没有评论";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                /* cell的选中样式为无色 */
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
                if (cell == nil) {
                    cell = [[ShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showcell"];
                }
                CommentsModel *model = self.commentsDataArray[indexPath.row-1];
                
                [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.user_headImg]];
                cell.nicknameLabel.text = model.user_nickName;
                
                NSString *currenttime = [NSString prettyDateWithReference:model.commentTime];
                cell.timeLabel.text = currenttime;
                NSString *text = model.comment;
                cell.commentsLabel.text = text;
                UIFont *font = [UIFont systemFontOfSize:15];
                cell.commentsLabel.font = font;
                commentsize = CGSizeMake(kScreenWidth-55-15, 20000.0f);
                commentsize = [text calculateSize:commentsize font:font];
                [cell.commentsLabel setFrame:CGRectMake(15+30+10, 10+15+5+12+10, kScreenWidth-55-15, commentsize.height)];
                
                return cell;
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.backcommentview.commentview resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *strRequest = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([strRequest isEqualToString:@"about:blank"]) {
        return YES;
    } else if([strRequest hasPrefix:@"http://player.youku.com"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([strRequest isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else if([strRequest hasPrefix:@"http://player.youku.com"]){
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;{
    [self.tableview reloadData];
    NSLog(@"页面加载失败");
}


#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.loginstate.isLogIn) {
        [self gotLoginViewController];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendCommentWithText:textField.text];
    return YES;
}

- (void)gotLoginViewController
{
    LoginTableViewController *loginview = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:loginview animated:YES];
}

- (void)sendCommentWithText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    
    
    NSString *string = [NSString stringWithFormat:@"%@addSharpComnment",kAPI_Sharp];
    NSDictionary *dic = @{@"id":self.sharp_id,@"userid":self.loginstate.userId,@"sharpcomment":text,@"authenticationStr":self.loginstate.userId,@"encryptedStr":encryptedStr};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发表新评论";
    
    __weak SharpDetailsViewController *wself = self;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"]  isEqualToString:@"200"]) {
            hud.labelText = @"评论成功";
            [hud hide:YES afterDelay:0.2];
            
            //请求评论数据
            [wself requestDataWithComments];
            
            //滑动到评论
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [wself.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else {
            hud.labelText = @"评论失败";
            [hud hide:YES afterDelay:0.2];
        }
        
        wself.backcommentview.commentview.text = @"";
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = @"评论失败";
        [hud hide:YES afterDelay:0.2];
        NSLog(@"请求失败");
    }];
}

#pragma mark - Action
- (void)clickAdd:(UIButton *)sender{
    //点击之后三秒内不可再次点击
    [sender setEnabled:NO];
    int64_t delayInSeconds = 2.0 * 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setEnabled:YES];
    });
    
    if (self.loginstate.isLogIn) {
        if ([iscollect intValue] == 0) {
            
            
            NSString *string = @"http://appapi.juwairen.net/index.php/Collection/addCollect";
            NSDictionary *dic = @{@"userid":self.loginstate.userId,@"module_id":@2,@"item_id":self.sharp_id};

            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"添加收藏";

            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"code"] isEqualToString:@"200"]) {
                    //收藏成功 弹出提示框
                    hud.labelText = @"收藏成功";
                    [hud hide:YES afterDelay:0.2];
                    
                    iscollect = @"1";
                    [sender setBackgroundImage:[UIImage imageNamed:@"收藏成功.png"] forState:UIControlStateNormal];
                } else {
                    hud.labelText = @"收藏失败";
                    [hud hide:YES afterDelay:0.2];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                hud.labelText = @"收藏失败";
                [hud hide:YES afterDelay:0.2];
                NSLog(@"请求失败");
            }];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"取消收藏";
            
            NSMutableArray *sharpID = [NSMutableArray array];
            [sharpID addObject:self.sharp_id];
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer=[AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSString*url=[NSString stringWithFormat:@"http://appapi.juwairen.net/index.php/Collection/delCollect"];
            NSDictionary *para = @{@"authenticationStr":self.loginstate.userId,
                                   @"encryptedStr":encryptedStr,
                                   @"delete_ids":sharpID,
                                   @"module_id":@"2",
                                   @"userid":self.loginstate.userId};
            [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString*code=[responseObject objectForKey:@"code"];
                if ([code isEqualToString:@"200"]) {
                    iscollect = @"0";
                    [sender setBackgroundImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
                 
                    hud.labelText = @"取消成功";
                    [hud hide:YES afterDelay:0.2];
                }
                else {
                    hud.labelText = @"取消失败";
                    [hud hide:YES afterDelay:0.2];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                hud.labelText = @"取消失败";
                [hud hide:YES afterDelay:0.2];
                NSLog(@"请求失败");
            }];
        }
    }
    else
    {
        [self gotLoginViewController];
    }
}

- (void)clickGOBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickComments:(UIButton *)sender{
    
    //滑动到评论
    
    if (firstClickComment) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
        firstClickComment = NO;
    }
    else
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)clickShare:(UIButton *)sender{
    //释放键盘第一响应
    [self.backcommentview.commentview resignFirstResponder];
    //1、创建分享参数
    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:@[sharpimg]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/Sharp/show/sid/%@",self.sharp_id]]
                                      title:title
                                       type:SSDKContentTypeAuto];
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

#pragma mark-身份验证
-(void)requestAuthentication
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"http://appapi.juwairen.net/Public/getapivalidate/"];
    NSDictionary *para = @{@"validatestring":self.loginstate.userId};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*code = [responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary*dic = responseObject[@"data"];
            encryptedStr = dic[@"str"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

#pragma mark Keyboard
- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification{
    //当键盘出现时计算键盘的高度大小，用于输入框显示
    NSDictionary *info = [aNotification userInfo];
    //kbSize为键盘尺寸
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    [self beginMoveUpAnimation:kbSize.height];
}

- (void)keyboardWillBeHidden{
    [UIView animateWithDuration:0.1 animations:^{
        self.backcommentview.transform = CGAffineTransformIdentity;
        self.tableview.transform = CGAffineTransformIdentity;
    }];
}

- (void)beginMoveUpAnimation:(CGFloat )height{
    [UIView animateWithDuration:0.1 animations:^{
        self.backcommentview.transform = CGAffineTransformMakeTranslation(0, -height);
        self.tableview.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

@end
