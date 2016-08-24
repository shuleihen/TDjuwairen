//
//  SharpDetailsViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "SharpDetailsViewController.h"
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
#import "LoginViewController.h"
#import "CollectionViewController.h"
#import "UIdaynightModel.h"
#import "NaviMoreView.h"
#import "SelectFontView.h"
#import "SearchViewController.h"
#import "FeedbackViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

//测试
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "MJRefresh.h"
#import <WebKit/WebKit.h>
#import "SharpModel.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "UIStoryboard+MainStoryboard.h"
#import "HexColors.h"
#import "YXFont.h"

@interface SharpDetailsViewController ()<WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIWebViewDelegate,BackCommentViewDelegate,NaviMoreViewDelegate,SelectFontViewDelegate,SharpTagsDelegate>
{
    CGSize titlesize;
    CGSize commentsize;
    CGSize originalsize;
    
    NSString *encryptedStr;
    UIView *bgView;    //点击放大图片背景
    
    UILabel *label;
    UIButton *button;
    UIView *view;
    NSTimer *myTimer;
    BOOL firstClickComment;
    
    BOOL naviShow;
    BOOL fontShow;
    NSString *fontsize;
}

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NaviMoreView *nmview;
@property (nonatomic,strong) SelectFontView *sfview;
@property (nonatomic,strong) NSArray *sizeArr;
@property (nonatomic,strong) UIWebView *webview;
@property (nonatomic) BOOL scalesPageToFit;
/* 评论条 */
@property (nonatomic,strong) BackCommentView *backcommentview;

@property (nonatomic,strong) NSMutableArray *commentsDataArray;
@property (nonatomic,strong) NSArray *sharpTagsArray;

@property (nonatomic,strong) SharpTags *tagList;

/* 点击放大图片 */
@property (nonatomic,strong) UIImageView *imgView;
/* 文章中的所有图片 */
@property (nonatomic,strong) NSMutableArray *imageViews;

@property (nonatomic, strong) SharpModel *sharpInfo;
@property (nonatomic,strong) UIdaynightModel *daynightmodel;
@property (nonatomic, assign) int page;
@property (nonatomic,strong) MBProgressHUD *hubload;

@property (nonatomic,assign) int comentheight;
@end

@implementation SharpDetailsViewController
- (NaviMoreView *)nmview{
    if (!_nmview) {
//        _nmview = [[NaviMoreView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kScreenHeight/16*5)];
        NSString *str ;
        if (!self.sharpInfo.sharpIsCollect) {
            str = @"yes";
        }
        else
        {
            str = @"no";
        }
        _nmview = [[NaviMoreView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kScreenHeight/16*5) withString:str];
        
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

- (void)dealloc
{
    [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize"];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault removeObserver:self forKeyPath:@"daynight"];
//    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sizeArr = @[@"120%",@"110%",@"100%",@"90%"];
    naviShow = NO;
    fontShow = NO;
    fontsize = @"100%";
    self.comentheight = 0;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.commentsDataArray = [NSMutableArray array];
    self.sharpTagsArray = [NSMutableArray array];

    self.page = 1;
    self.daynightmodel = [UIdaynightModel sharedInstance];
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
    
    [self setupUICommon];

    [self refreshAction];
    //收起键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)viewTapped:(UIButton *)sender{
    [self.view endEditing:YES];
    self.nmview.alpha = 0.0;
}

- (void)setupWithNavigation{

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (US.isLogIn) {
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
    [self setupWithNavigation];
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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = self.daynightmodel.backColor;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableview];
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)setupCommentView
{
    self.backcommentview = [[BackCommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50)];
    self.backcommentview.delegate = self;
    self.backcommentview.backgroundColor = self.daynightmodel.backColor;
    self.backcommentview.commentview.backgroundColor = self.daynightmodel.inputColor;
    self.backcommentview.commentview.textColor = self.daynightmodel.textColor;
    self.backcommentview.commentview.layer.borderColor = self.daynightmodel.lineColor.CGColor;
    self.backcommentview.commentview.delegate = self;
    
    [self.view addSubview:self.backcommentview];
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
    
    if ([keyPath isEqualToString:@"daynight"]) {
        self.view.backgroundColor = self.daynightmodel.navigationColor;
        self.tableview.backgroundColor = self.daynightmodel.backColor;
        [self.navigationController.navigationBar setBackgroundColor:self.daynightmodel.navigationColor];
        [self.navigationController.navigationBar setBarTintColor:self.daynightmodel.navigationColor];
        
        self.tabBarController.tabBar.barTintColor = self.daynightmodel.navigationColor;
        
        self.backcommentview.backgroundColor = self.daynightmodel.backColor;
        self.backcommentview.commentview.backgroundColor = self.daynightmodel.inputColor;
        self.backcommentview.commentview.textColor = self.daynightmodel.textColor;
        self.backcommentview.commentview.layer.borderColor = self.daynightmodel.lineColor.CGColor;
        
        [self.nmview.tableview reloadData];
        [self.tableview reloadData];
    }
}

#pragma mark Request Data
- (void)refreshAction {
    //数据表页数为1
    self.page = 1;
    [self requestDataWithUrl];
    [self requestCommentDataWithPage:self.page];
}

- (void)loadMoreAction {
    [self requestCommentDataWithPage:(self.page + 1)];
}


- (void)requestCommentDataWithPage:(int)currentPage
{
    NSString *string = [NSString stringWithFormat:@"index.php/Sharp/getSharpComnment/id/%@/page/%d",self.sharp_id,currentPage];
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:string parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *d in data) {
                CommentsModel *model = [CommentsModel getInstanceWithDictionary:d];
                [array addObject:model];
            }
            
            if (currentPage == 1) {
                self.commentsDataArray = array;
            } else {
                [self.commentsDataArray addObjectsFromArray:array];
            }
            
            self.page = currentPage;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableview.mj_footer endRefreshing];
        } else {
           [self.tableview.mj_footer endRefreshing];
        }
    }];
}

- (void)requestDataWithUrl{
    
    self.hubload = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hubload.labelText = @"加载中...";
    
    NSString *url;
    if (US.isLogIn) {
        url = [NSString stringWithFormat:@"index.php/Sharp/show/id/%@/userid/%@",self.sharp_id,US.userId];
        
    }
    else
    {
        url = [NSString stringWithFormat:@"index.php/Sharp/show/id/%@",self.sharp_id];
        
    }
    
    __weak SharpDetailsViewController *wself = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:url parameters:nil completion:^(id data, NSError *error){
        if (!error) {
            wself.hubload.labelText = @"加载完成";
            [wself.hubload hide:YES afterDelay:0.1];
            [wself.tableview.mj_header endRefreshing];
            
            wself.sharpInfo = [SharpModel sharpWithDictionary:data];
            self.sharpTagsArray = wself.sharpInfo.sharpTags;
            [wself relaodCommentNumber];
            [wself.tableview reloadData];
            
            //测试替换iframe标签宽高
            NSString *s = @"iframe";
            if ([self.sharpInfo.sharpContent rangeOfString:s].location != NSNotFound) {
                //
                NSString *oldiframe = @"height=\"500\" width=\"600\"";
                NSString *newIframe = @"height=\"250\" width=\"100%\"";
                self.sharpInfo.sharpContent = [self.sharpInfo.sharpContent stringByReplacingOccurrencesOfString:oldiframe withString:newIframe];
            }
            // iOS webkit preload 没有预加载视频导致视频背景为白色，使用autoplay替换
//            self.sharpInfo.sharpContent = [self.sharpInfo.sharpContent stringByReplacingOccurrencesOfString:@"preload" withString:@"autoplay"];
            
            
            [wself.webview loadHTMLString:self.sharpInfo.sharpContent baseURL:nil];
            
        } else {
            wself.hubload.labelText = @"加载失败";
            [wself.hubload hide:YES afterDelay:0.1];
            [wself.tableview.mj_header endRefreshing];
        }
    }];
}

- (void)relaodCommentNumber
{
    if (self.sharpInfo.sharpCommentNumbers > 0) {
        NSString *text;
        if (self.sharpInfo.sharpCommentNumbers >999) {
            text = @"999+";
        }else
        {
            text = [NSString stringWithFormat:@"%d",self.sharpInfo.sharpCommentNumbers];
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
            return 75+titlesize.height+10;
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
        else
        {
            if (self.commentsDataArray.count == 0) {
                return kScreenHeight-64-44;
            }
            else
            {
                if (indexPath.row == self.commentsDataArray.count) {
                    if (kScreenHeight-(10+15+5+12+10+commentsize.height+10)*(self.commentsDataArray.count) > 10+15+5+12+10+commentsize.height+10) {
                        return kScreenHeight-(10+15+5+12+10+commentsize.height+10)*(self.commentsDataArray.count);
                    }
                }
                /* 设置高度自适应 */
                return 10+15+5+12+10+commentsize.height+10;
            }
        }
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
            NSString *text = self.sharpInfo.sharpTitle;
            UIFont *font = [UIFont systemFontOfSize:20];
            titleCell.titleLabel.font = font;
            titleCell.titleLabel.numberOfLines = 0;
            titlesize = CGSizeMake(kScreenWidth-30, 20000.0f);
            titlesize = [text calculateSize:titlesize font:font];
            titleCell.titleLabel.text = text;
            [titleCell.titleLabel setFrame:CGRectMake(15, 75, kScreenWidth-30, titlesize.height)];
            
            NSString *custime = [NSString prettyDateWithReference:self.sharpInfo.sharpWtime];
            titleCell.usernickname.text = self.sharpInfo.sharpUserName;
            titleCell.addtime.text = custime;
            [titleCell.userheadImage sd_setImageWithURL:[NSURL URLWithString:self.sharpInfo.sharpUserIcon]];
            
            titleCell.usernickname.textColor = self.daynightmodel.textColor;
            titleCell.addtime.textColor = self.daynightmodel.titleColor;
            titleCell.titleLabel.textColor = self.daynightmodel.textColor;
            titleCell.backgroundColor = self.daynightmodel.navigationColor;
            
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
            if (!self.sharpInfo.sharpIsCollect) {
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
            cell.backgroundColor = self.daynightmodel.navigationColor;
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
            self.tagList.delegate = self;
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
            cell.backgroundColor = self.daynightmodel.navigationColor;
            return cell;
        }
        else if (indexPath.row == 4){
            NSString *identifier = @"isoriginal";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *text;
            if (self.sharpInfo.sharpIsOriginal) {
                if (self.sharpInfo.sharpTypeId == 1) {
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
            cell.backgroundColor = self.daynightmodel.navigationColor;
            return cell;
        }
        else
        {
            NSString *identifier = @"spacecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            /* cell的选中样式为无色 */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = self.daynightmodel.backColor;
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
            cell.backgroundColor = self.daynightmodel.navigationColor;
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
                
                cell.textLabel.textColor = self.daynightmodel.textColor;
                cell.backgroundColor = self.daynightmodel.navigationColor;
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
                NSString *text = model.sharpcomment;
                cell.commentsLabel.text = text;
                UIFont *font = [UIFont systemFontOfSize:15];
                cell.commentsLabel.font = font;
                commentsize = CGSizeMake(kScreenWidth-55-15, 20000.0f);
                commentsize = [text calculateSize:commentsize font:font];
                [cell.commentsLabel setFrame:CGRectMake(15+30+10, 10+15+5+12+10, kScreenWidth-55-15, commentsize.height)];
                
                cell.nicknameLabel.textColor = self.daynightmodel.textColor;
                cell.timeLabel.textColor = self.daynightmodel.titleColor;
                cell.commentsLabel.textColor = self.daynightmodel.textColor;
                /* cell的选中样式为无色 */
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = self.daynightmodel.navigationColor;
                return cell;
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.backcommentview.commentview resignFirstResponder];
    self.nmview.alpha = 0.0;
    if (self.tableview.contentOffset.y > self.webview.frame.size.height-400) {
        
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"nav_zt.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    }
}

#pragma mark - 标签代理方法
- (void)ClickTags:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.searchTags = sender.titleLabel.text;
    searchView.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:searchView animated:YES];
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
    } else if ([strRequest hasPrefix:@"http://player.youku.com"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *daynight = [userdefault objectForKey:@"daynight"];
    if ([daynight isEqualToString:@"yes"]) {
        NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#5B5B5B'";
        
        NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='white';\
        var pNode=document.getElementsByTagName('p');\
        for(var i=0;i<pNode.length;i++){\
        pNode[i].style.backgroundColor='white';\
        }";
        
        [self.webview stringByEvaluatingJavaScriptFromString:textcolor];
        [self.webview stringByEvaluatingJavaScriptFromString:backcolor];
    }
    else
    {
        NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#CCCCCC'";
        
        NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='#222222';\
        var pNode=document.getElementsByTagName('p');\
        for(var i=0;i<pNode.length;i++){\
        pNode[i].style.backgroundColor='#222222';\
        }";
        
        [self.webview stringByEvaluatingJavaScriptFromString:textcolor];
        [self.webview stringByEvaluatingJavaScriptFromString:backcolor];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([strRequest isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else if ([strRequest hasPrefix:@"http://player.youku.com"]) {
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
    if (!US.isLogIn) {
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
    LoginViewController *login = [[LoginViewController alloc] init];
    login.hidesBottomBarWhenPushed = YES;//跳转时隐藏tabbar
    [self.navigationController pushViewController:login animated:YES];
}

- (void)sendCommentWithText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发表新评论";
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dic = @{@"id":self.sharp_id,@"userid":US.userId,@"sharpcomment":text,@"authenticationStr":US.userId,@"encryptedStr":encryptedStr};
    
    [manager POST:API_AddSharpComment parameters:dic completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"评论成功";
            [hud hide:YES afterDelay:0.2];
            
            //请求评论数据
            [self requestCommentDataWithPage:1];
            
            self.backcommentview.commentview.text = @"";
            
            //滑动到评论
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.tableview reloadData];
        } else {
            
            hud.labelText = @"评论失败";
            [hud hide:YES afterDelay:0.2];
        }
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
    
    if (US.isLogIn) {
        if (!self.sharpInfo.sharpIsCollect) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"添加收藏";

            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dic = @{@"userid":US.userId,@"module_id":@2,@"item_id":self.sharp_id};
            
            [manager POST:API_AddCollection parameters:dic completion:^(id data, NSError *error){
                if (!error) {
                    hud.labelText = @"收藏成功";
                    [hud hide:YES afterDelay:0.2];
                    
                    self.sharpInfo.sharpIsCollect = true;
                    [sender setBackgroundImage:[UIImage imageNamed:@"收藏成功.png"] forState:UIControlStateNormal];
                } else {
                    hud.labelText = @"收藏失败";
                    [hud hide:YES afterDelay:0.2];
                }
            }];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"取消收藏";
            
            NSMutableArray *sharpID = [NSMutableArray array];
            [sharpID addObject:self.sharp_id];
            
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *para = @{@"authenticationStr":US.userId,
                                   @"encryptedStr":encryptedStr,
                                   @"delete_ids":sharpID,
                                   @"module_id":@"2",
                                   @"userid":US.userId};
            
            [manager POST:API_DelCollection parameters:para completion:^(id data, NSError *error){
                if (!error) {
                    self.sharpInfo.sharpIsCollect = false;
                    [sender setBackgroundImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
                    
                    hud.labelText = @"取消成功";
                    [hud hide:YES afterDelay:0.2];
                } else {
                    hud.labelText = @"取消失败";
                    [hud hide:YES afterDelay:0.2];
                }
            }];
        }
    }
    else
    {
        [self gotLoginViewController];
    }
}

- (void)clickComments:(UIButton *)sender{
    
    if (self.tableview.contentOffset.y > self.webview.frame.size.height-400) {
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        //回到顶部
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableview scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    else
    {
        //滑动到评论
        [self.backcommentview.ClickComment setBackgroundImage:[UIImage imageNamed:@"nav_zt.png"] forState:UIControlStateNormal];
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
}

- (void)clickShare:(UIButton *)sender{
    //释放键盘第一响应
    [self.backcommentview.commentview resignFirstResponder];
    //1、创建分享参数
    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.sharpInfo.sharpDesc
                                     images:@[self.sharpInfo.sharpThumbnail]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.juwairen.net/Sharp/show/sid/%@",self.sharp_id]]
                                      title:self.sharpInfo.sharpTitle
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
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary*para=@{@"validatestring":US.userId};
    
    [manager POST:API_GetApiValidate parameters:para completion:^(id data, NSError *error){
        if (!error) {
            NSDictionary*dic = data;
            encryptedStr = dic[@"str"];
        } else {
            
        }
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
    
    self.backcommentview.transform = CGAffineTransformIdentity;
    self.tableview.transform = CGAffineTransformIdentity;
}

- (void)beginMoveUpAnimation:(CGFloat )height{
    self.backcommentview.transform = CGAffineTransformMakeTranslation(0, -height);
    self.tableview.transform = CGAffineTransformMakeTranslation(0, -height);
}

#pragma mark - 浮窗的代理方法
- (void)didSelectedWithIndexPath:(UITableViewCell *)cell
{
    if ([cell.textLabel.text isEqualToString:@"复制链接"]) {
        NSLog(@"%@",cell.textLabel.text);
    }
    else if ([cell.textLabel.text isEqualToString:@"收藏"]){
        cell.imageView.image = [UIImage imageNamed:@"btn_col_pre"];
        cell.textLabel.text = @"取消收藏";
        [self addCollection];
    }
    else if ([cell.textLabel.text isEqualToString:@"取消收藏"]){
        cell.imageView.image = [UIImage imageNamed:@"btn_col"];
        cell.textLabel.text = @"收藏";
        [self clearCollection];
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
            
            [UINavigationBar appearance].barTintColor = self.daynightmodel.navigationColor;   // 设置导航条背景颜色
            [UINavigationBar appearance].translucent = NO;
            [UINavigationBar appearance].tintColor = self.daynightmodel.navigationColor;    // 设置左右按钮，文字和图片颜色
            // 设置导航条标题字体和颜色
            NSDictionary *dict = @{NSForegroundColorAttributeName:self.daynightmodel.titleColor, NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
            [[UINavigationBar appearance] setTitleTextAttributes:dict];
            
            // 设置导航条左右按钮字体和颜色
            NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
            [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
            
            NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#CCCCCC'";
            
            NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='#222222';\
            var pNode=document.getElementsByTagName('p');\
            for(var i=0;i<pNode.length;i++){\
            pNode[i].style.backgroundColor='#222222';\
            }";
            
            [self.webview stringByEvaluatingJavaScriptFromString:textcolor];
            [self.webview stringByEvaluatingJavaScriptFromString:backcolor];
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
        
        [UINavigationBar appearance].barTintColor = self.daynightmodel.navigationColor;   // 设置导航条背景颜色
        [UINavigationBar appearance].translucent = NO;
        [UINavigationBar appearance].tintColor = self.daynightmodel.navigationColor;    // 设置左右按钮，文字和图片颜色
        // 设置导航条标题字体和颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName:self.daynightmodel.titleColor, NSFontAttributeName:[YXFont mediumFontSize:17.0f]};
        [[UINavigationBar appearance] setTitleTextAttributes:dict];
        
        // 设置导航条左右按钮字体和颜色
        NSDictionary *barItemDict = @{NSForegroundColorAttributeName:[HXColor hx_colorWithHexRGBAString:@"#1b69b1"], NSFontAttributeName:[YXFont lightFontSize:16.0f]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:barItemDict forState:UIControlStateNormal];
        
        NSString *textcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#5B5B5B'";
        
        NSString *backcolor = @"document.getElementsByTagName('body')[0].style.background='white';\
        var pNode=document.getElementsByTagName('p');\
        for(var i=0;i<pNode.length;i++){\
        pNode[i].style.backgroundColor='white';\
        }";
        
        [self.webview stringByEvaluatingJavaScriptFromString:textcolor];
        [self.webview stringByEvaluatingJavaScriptFromString:backcolor];
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
        NetworkManager *manager = [[NetworkManager alloc] init];
        NSDictionary *dic = @{@"userid":US.userId,
                              @"module_id":@2,
                              @"item_id":self.sharp_id};
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"添加收藏";
        
        [manager POST:API_AddCollection parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                hud.labelText = @"收藏成功";
                [hud hide:YES afterDelay:0.2];
                self.sharpInfo.sharpIsCollect = true;
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
    [IDArr addObject:self.sharp_id];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *para = @{@"authenticationStr":US.userId,
                           @"encryptedStr":encryptedStr,
                           @"delete_ids":IDArr,
                           @"module_id":@"2",
                           @"userid":US.userId};
    
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
    
    NSString *jsZiti = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",fontsize];
    [self.webview stringByEvaluatingJavaScriptFromString:jsZiti];
    
}

- (void)clickCancel:(UIButton *)sender
{
    self.sfview.alpha = 0.0;
    self.nmview.alpha = 0.0;
    naviShow = NO;
}

- (void)SelectFontWithIndexPath:(NSInteger)indexPath
{
    fontsize = self.sizeArr[indexPath];
}

@end
