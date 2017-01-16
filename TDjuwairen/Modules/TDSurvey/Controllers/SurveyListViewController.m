//
//  SurveyListViewController.m
//  TDjuwairen
//
//  Created by 团大 on 16/10/17.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyListViewController.h"
#import "SurveryStockListCell.h"
#import "NetworkManager.h"
#import "StockManager.h"
#import "SurveyModel.h"
#import "LoginState.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "SurDetailViewController.h"
#import "NotificationDef.h"
#import "YXTitleButton.h"
#import "SearchViewController.h"
#import "DetailPageViewController.h"
#import "PushMessageViewController.h"
#import "LoginViewController.h"
#import "HexColors.h"
#import "MJRefresh.h"
#import "SurveyDetailViewController.h"
#import "WelcomeView.h"
#import "PersonalCenterViewController.h"
#import "TDNavigationController.h"
#import "UIButton+Align.h"
#import "HMSegmentedControl.h"
#import "SurveyContentListController.h"
#import "GradeListViewController.h"
#import "ApplySurveyViewController.h"
#import "SubscriptionViewController.h"
#import "SurveySubjectModel.h"

// 广告栏高度
#define kBannerHeiht 160
#define kButtonViewHeight 76
#define kSegmentHeight 34

@interface SurveyListViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, SurveyContentListDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *bannerLinks;

@property (nonatomic, strong) WelcomeView *welcomeView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) NSMutableArray *contentControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *subjectItems;
@end

@implementation SurveyListViewController

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kBannerHeiht);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"bannerPlaceholder.png"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _cycleScrollView;
}

- (UIView *)tableViewHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerHeiht+kButtonViewHeight+10)];
    view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    [view addSubview:self.cycleScrollView];
    
    UIView *buttonContain = [[UIView alloc] initWithFrame:CGRectMake(0, kBannerHeiht, kScreenHeight, kButtonViewHeight)];
    buttonContain.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    [view addSubview:buttonContain];
    
    NSArray *titles = @[@"周刊订阅",@"特约调研",@"评级排行",@"敬请期待"];
    NSArray *images = @[@"fun_weekly.png",@"fun_investigation.png",@"fun_ranking.png",@"fun_more.png"];
    NSArray *selectors = @[@"subscribePressed:",@"surveyPressed:",@"gradePressed:",@"morePressed:"];
    
    int i=0;
    CGFloat w = kScreenWidth/4;
    for (NSString *title in titles) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*w, 0, w, kButtonViewHeight)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        [btn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [btn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateHighlighted];
        
        UIImage *image = [UIImage imageNamed:images[i]];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        
        SEL action = NSSelectorFromString(selectors[i]);
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [buttonContain addSubview:btn];
        
        [btn align:BAVerticalImage withSpacing:8.0f];
        i++;
    }

    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, kBannerHeiht+75.5, kScreenWidth, 0.5)];
    sep.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [view addSubview:sep];
    
    return view;
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] init];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.titleTextAttributes =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                               NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#666666"]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                                        NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#3371e2"]};
        _segmentControl.selectionIndicatorHeight = 3.0f;
        _segmentControl.selectionIndicatorColor = [UIColor hx_colorWithHexRGBAString:@"#3371e2"];
//        _segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, -5, 0, -5);
        [_segmentControl addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                           forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
    }
    return _pageViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTableView];
    
    [self getBanners];
    [self querySurveySubject];
    [self requestToLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (US.isLogIn) {
        UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
        [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
    } else {
        UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
        [btn setImage:[UIImage imageNamed:@"nav_unLoginAvatar.png"] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Setup
- (void)setupNavigationBar {
    UIButton *avatarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarBtn.imageView.layer.cornerRadius = 15.0f;
    avatarBtn.imageView.clipsToBounds = YES;
    [avatarBtn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav_unLoginAvatar.png"]];
    [avatarBtn addTarget:self action:@selector(avatarPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:avatarBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    // 通知
    UIImage *rightImage = [[UIImage imageNamed:@"news_read.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(notificationPressed:)];
    self.navigationItem.rightBarButtonItem = right;
    
    // 搜索
    YXTitleButton *search = [[YXTitleButton alloc] init];
    [search addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = search;
}

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self tableViewHeaderView];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)setupWithSubjectArray:(NSArray *)subjectArray {
    
    NSMutableArray *segmentTitles = [NSMutableArray arrayWithCapacity:[subjectArray count]];
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[subjectArray count]];
    
    for (SurveySubjectModel *model in subjectArray) {
        [segmentTitles addObject:model.subjectTitle];
        
        SurveyContentListController *vc = [[SurveyContentListController alloc] init];
        vc.tag = model.subjectId;
        vc.subjectTitle = model.subjectTitle;
        vc.rootController = self;
        vc.delegate = self;
        [controllers addObject:vc];
    }
    
    self.contentControllers = controllers;
    [self setupSegmentWithTitles:segmentTitles];
}

- (void)setupSegmentWithTitles:(NSArray *)titles {
    CGFloat w = [titles count]*70;
    self.segmentControl.sectionTitles = titles;
    self.segmentControl.frame = CGRectMake(0, 0, w, kSegmentHeight);
    
    if ([titles count]) {
        self.segmentControl.selectedSegmentIndex = 0;
        [self segmentPressed:self.segmentControl];
    }
}

#pragma mark - Action 
- (void)updateAvatar:(NSNotification *)notif {
    UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
    [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
}

- (void)avatarPressed:(id)sender {
    PersonalCenterViewController *vc = [[PersonalCenterViewController alloc] init];
    TDNavigationController *nav = [[TDNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)notificationPressed:(id)sender {
    if (US.isLogIn==NO) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        PushMessageViewController *messagePush = [[PushMessageViewController alloc]init];
        messagePush.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messagePush animated:YES];
    }
}

- (void)searchPressed:(id)sender {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)subscribePressed:(id)sender {
    SubscriptionViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"SubscriptionViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)surveyPressed:(id)sender {
    ApplySurveyViewController *vc = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplySurveyViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gradePressed:(id)sender {
    GradeListViewController *vc = [[GradeListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)morePressed:(id)sender {
    
}

- (void)segmentPressed:(HMSegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    __weak SurveyListViewController *wself = self;
    SurveyContentListController *vc = self.contentControllers[index];
    
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){
        [wself.tableView reloadData];
    }];
}

- (void)refreshAction {
    [self getBanners];
    [self querySurveySubject];
//    [[self currentContentViewController] refreshData];
}

- (void)loadMoreAction {
    [[self currentContentViewController] loadMoreData];
}

- (void)getBanners {
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    NSDictionary *dic = @{@"version":@"2.0"};
    [manager POST:API_GetBanner parameters:dic completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *dataArr = data;
            NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[data count]];
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:[data count]];
            NSMutableArray *links = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *d in dataArr) {
                [urls addObject:d[@"ad_imgurl"]];
                [titles addObject:d[@"ad_title"]];
                [links addObject:d[@"ad_link"]];
            }
            
            self.bannerLinks = links;
            self.cycleScrollView.titlesGroup = titles;
            self.cycleScrollView.imageURLStringsGroup = urls;
        } else {
            
        }
    }];
}

- (void)querySurveySubject {
    __weak SurveyListViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveySubject parameters:nil completion:^(id data, NSError *error) {
        if (!error && data) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *dict in data) {
                SurveySubjectModel *model = [[SurveySubjectModel alloc] initWithDict:dict];
                [array addObject:model];
            }
            
            wself.subjectItems = array;
        } else {
            
        }
        
        [wself setupWithSubjectArray:wself.subjectItems];
    }];
}

- (SurveyContentListController *)currentContentViewController {
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    if (index >= 0 && index < [self.contentControllers count]) {
        return self.contentControllers[index];
    } else {
        return nil;
    }
}

#pragma mark - SurveyContentListDelegate
- (void)contentListLoadComplete {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }

    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    [self.tableView reloadData];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //跳转到详情页
    NSString *s = self.bannerLinks[index];
    NSArray *arr = [s componentsSeparatedByString:@"/"];

    if ([arr[0] isEqualToString:@"Survey"]) {
        
        NSString *code = [[arr lastObject] substringWithRange:NSMakeRange(0, 1)];

        NSString *companyCode ;
        if ([code isEqualToString:@"6"]) {
            companyCode = [NSString stringWithFormat:@"sh%@",[arr lastObject]];
        }
        else
        {
            companyCode = [NSString stringWithFormat:@"sz%@",[arr lastObject]];
        }
        
        SurveyDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
        vc.stockId = companyCode;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([arr[0] isEqualToString:@"Sharp"]){
        DetailPageViewController *DetailView = [[DetailPageViewController alloc]init];
        DetailView.sharp_id = [arr lastObject];
        DetailView.pageMode = @"sharp";
        DetailView.hidesBottomBarWhenPushed = YES;
        
        if (US.isLogIn) {     //为登录状态
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dic = @{@"userid":US.userId,
                                  @"module_id":@2,
                                  @"item_id":[arr lastObject]};
            
            [manager POST:API_AddBrowseHistory parameters:dic completion:^(id data, NSError *error){
                if (!error) {
                    
                } else {
                    
                }
            }];
        }
        
        [self.navigationController pushViewController:DetailView animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSegmentHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSegmentHeight)];
    view.dk_backgroundColorPicker = DKColorPickerWithKey(CONTENTBG);
    
    [view addSubview:self.segmentControl];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    top.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [view addSubview:top];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, kSegmentHeight-0.5, kScreenWidth, 1)];
    bottom.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [view addSubview:bottom];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [[self currentContentViewController] contentHeight];
    CGFloat minHeight = kScreenHeight - 64-kBannerHeiht-kButtonViewHeight-10-50;
    return MAX(height, minHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyListContentCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SurveyListContentCellID"];
        [cell.contentView addSubview:self.pageViewController.view];
    }
    
    return cell;
}


#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger before = index - 1;
    
    if (before < 0) {
        return nil;
    } else {
        return self.contentControllers[before];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    NSInteger after = index + 1;
    
    if (after >= [self.contentControllers count]) {
        return nil;
    } else {
        return self.contentControllers[after];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    if (!finished) {
        return;
    }
    
    UIViewController *currentVc = [pageViewController.viewControllers firstObject];
    NSInteger index = [self.contentControllers indexOfObject:currentVc];
    
    if (index != self.segmentControl.selectedSegmentIndex) {
        self.segmentControl.selectedSegmentIndex = index;
        [self.tableView reloadData];
    }
}

#pragma mark - 保持登录
- (void)requestToLogin{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *loginStyle = [user objectForKey:@"loginStyle"];
    NSLog(@"loginStyle is :---%lu",(unsigned long)loginStyle.length);

    if (loginStyle.length > 0) {          //如果有登陆状态
        self.welcomeView = [[WelcomeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.welcomeView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //删除
            [self.welcomeView removeFromSuperview];
        });
    }
    
    if ([loginStyle isEqualToString:@"QQlogin"]) {
        NSString *openid = [user objectForKey:@"openid"];
        NSDictionary *dic = @{@"openid":openid};
        
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        [manager POST:API_CheckQQLogin parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                NSDictionary *dic = data;
                US.userId=dic[@"user_id"];
                US.userName=dic[@"user_name"];
                US.nickName=dic[@"user_nickname"];
                US.userPhone=dic[@"userinfo_phone"];
                US.headImage=dic[@"userinfo_facesmall"];
                US.company=dic[@"userinfo_company"];
                US.post=dic[@"userinfo_occupation"];
                US.personal=dic[@"userinfo_info"];
                
                US.isLogIn=YES;
                
                UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
                [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
                NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
                [self.welcomeView.welHead sd_setImageWithURL:[NSURL URLWithString:bigface]];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
            }
        }];
    }
    else if ([loginStyle isEqualToString:@"WXlogin"]){
        NSString *unionid = [user objectForKey:@"unionid"];
        NSDictionary *dic = @{@"unionid":unionid};
        
        NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
        [manager POST:API_CheckWeixinLogin parameters:dic completion:^(id data, NSError *error){
            if (!error) {
                NSDictionary *dic = data;
                US.userId=dic[@"user_id"];
                US.userName=dic[@"user_name"];
                US.nickName=dic[@"user_nickname"];
                US.userPhone=dic[@"userinfo_phone"];
                US.headImage=dic[@"userinfo_facesmall"];
                US.company=dic[@"userinfo_company"];
                US.post=dic[@"userinfo_occupation"];
                US.personal=dic[@"userinfo_info"];
                
                US.isLogIn=YES;
                
                UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
                [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
                NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
                [self.welcomeView.welHead sd_setImageWithURL:[NSURL URLWithString:bigface]];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
            }
        }];
    }
    else if([loginStyle isEqualToString:@"normal"])
    {
        NSString *account = [user objectForKey:@"account"];
        NSString *password = [user objectForKey:@"password"];
        if (account != nil ) {
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary*paras=@{@"account":account,
                                 @"password":password};
            
            [manager POST:API_Login parameters:paras completion:^(id data, NSError *error){
                if (!error) {
                    NSDictionary *dic = data;
                    US.userId=dic[@"user_id"];
                    US.userName=dic[@"user_name"];
                    US.nickName=dic[@"user_nickname"];
                    US.userPhone=dic[@"userinfo_phone"];
                    US.headImage=dic[@"userinfo_facesmall"];
                    US.company=dic[@"userinfo_company"];
                    US.post=dic[@"userinfo_occupation"];
                    US.personal=dic[@"userinfo_info"];
                    
                    US.isLogIn=YES;
                    
                    UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
                    [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal];
                    NSString *bigface = [US.headImage stringByReplacingOccurrencesOfString:@"_70." withString:@"_200."];
                    [self.welcomeView.welHead sd_setImageWithURL:[NSURL URLWithString:bigface]];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    
                }
            }];
        }
    }
    
}
@end
