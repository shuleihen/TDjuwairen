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
#import "SurveyListModel.h"
#import "LoginState.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "NotificationDef.h"
#import "YXSearchButton.h"
#import "SearchViewController.h"
#import "VideoDetailViewController.h"
#import "LoginViewController.h"
#import "HexColors.h"
#import "MJRefresh.h"
#import "StockDetailViewController.h"
#import "WelcomeView.h"
#import "TDNavigationController.h"
#import "UIButton+Align.h"
#import "HMSegmentedControl.h"
#import "SurveyContentListController.h"
#import "GradeListViewController.h"
#import "ApplySurveyViewController.h"
#import "SubscriptionViewController.h"
#import "SurveySubjectModel.h"
#import "NotificationDef.h"
#import "UIViewController+Refresh.h"
#import "UIImage+Resize.h"
#import "SelectedSurveySubjectViewController.h"
#import "ActualQuotationViewController.h"
#import "YXTitleCustomView.h"
#import "TDAdvertModel.h"
#import "TDWebViewHandler.h"
#import "SurveyDeepTableViewController.h"
#import "TDADHandler.h"

// 广告栏高度
#define kBannerHeiht 160
#define kButtonViewHeight 76
#define kSegmentHeight 34
#define kSegmentItemWidth  70
#define kUserAttenSegmentTag    @"154"

@interface SurveyListViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, SurveyContentListDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *bannerLinks;

@property (nonatomic, strong) WelcomeView *welcomeView;
@property (nonatomic, strong) UIView *segmentContentView;
@property (nonatomic, strong) UIScrollView *segmentContentScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;

@property (nonatomic, strong) NSMutableArray *contentControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *subjectItems;
@end

@implementation SurveyListViewController

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kBannerHeiht);
        __weak SurveyListViewController *wself = self;
        
        UIImage *image = [[UIImage imageNamed:@"bannerPlaceholder.png"] resize:CGSizeMake(kScreenWidth, kBannerHeiht)];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:wself placeholderImage:image];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.pageControlDotSize = CGSizeMake(7, 7);
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _cycleScrollView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5];
        _cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:12.0f];
        _cycleScrollView.titleLabelTextColor = [UIColor whiteColor];
    }
    return _cycleScrollView;
}

- (UIView *)tableViewHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerHeiht+kButtonViewHeight+10)];
    view.backgroundColor = TDViewBackgrouondColor;
    
    [view addSubview:self.cycleScrollView];
    
    UIView *buttonContain = [[UIView alloc] initWithFrame:CGRectMake(0, kBannerHeiht, kScreenHeight, kButtonViewHeight)];
    buttonContain.backgroundColor = [UIColor whiteColor];
    [view addSubview:buttonContain];
    
    NSArray *titles = @[@"黄金会员",@"评级排行",@"实盘开户",@"深度调研"];
    NSArray *images = @[@"fun_vip.png",@"fun_ranking.png",@"fun_account.png",@"fun_investigation.png"];
    NSArray *selectors = @[@"vipCenterPressed:",@"gradePressed:",@"morePressed:",@"surveyPressed:"];
    
    int i=0;
    CGFloat w = kScreenWidth/4;
    for (NSString *title in titles) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*w, 0, w, kButtonViewHeight)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#010101"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#010101"] forState:UIControlStateHighlighted];
        
        UIImage *image = [UIImage imageNamed:images[i]];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        
        SEL action = NSSelectorFromString(selectors[i]);
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [buttonContain addSubview:btn];
        
        [btn align:BAVerticalImage withSpacing:7.0f];
        i++;
    }

    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, kBannerHeiht+kButtonViewHeight-TDPixel, kScreenWidth, TDPixel)];
    sep.backgroundColor = TDSeparatorColor;
    [view addSubview:sep];
    
    return view;
}

- (UIView *)segmentContentView {
    if (!_segmentContentView) {
        _segmentContentView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth+2, kSegmentHeight)];
        _segmentContentView.backgroundColor = [UIColor whiteColor];
        _segmentContentView.layer.borderColor = TDSeparatorColor.CGColor;
        _segmentContentView.layer.borderWidth = TDPixel;
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-12-20, 7, 20, 20)];
        [addBtn setImage:[UIImage imageNamed:@"add_guanzhu.png"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(selectedSubjectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentContentView addSubview:addBtn];
        
        [_segmentContentView addSubview:self.segmentContentScrollView];
    }
    
    return _segmentContentView;
}

- (UIScrollView *)segmentContentScrollView {
    if (!_segmentContentScrollView) {
        _segmentContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-12-20-10, kSegmentHeight)];
        _segmentContentScrollView.showsHorizontalScrollIndicator = NO;
        
        [_segmentContentScrollView addSubview:self.segmentControl];
    }
    return _segmentContentScrollView;
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] init];
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.titleTextAttributes =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f weight:UIFontWeightLight],
                                               NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#666666"]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium],
                                                        NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#3371E2"]};
        _segmentControl.selectionIndicatorHeight = 3.0f;
        _segmentControl.selectionIndicatorColor = [UIColor hx_colorWithHexRGBAString:@"#3371E2"];
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionalStockChangedNotifi:) name:kAddOptionalStockSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectChangedNotifi:) name:kSubjectChangedNotification object:nil];
    
    [self setupNavigationBar];
    [self setupTableView];
    [self refreshAction];
}


#pragma mark - UIScroll
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat headerHeight = kBannerHeiht+kButtonViewHeight+10;
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y > headerHeight) {
            
            CGRect newFrame = CGRectMake(0, offset.y, self.view.frame.size.width, kSegmentHeight);
            self.segmentContentView.frame = newFrame;
            
        } else {
            CGRect newFrame = CGRectMake(0, headerHeight, self.view.frame.size.width, kSegmentHeight);
            self.segmentContentView.frame = newFrame;
        }
    }
}

#pragma mark - Setup
- (void)setupNavigationBar {
    
    YXTitleCustomView *customView = [[YXTitleCustomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    YXSearchButton *search = [[YXSearchButton alloc] init];
    search.frame = CGRectMake(12, 7, kScreenWidth-24, 30);
    search.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#eeeeee"];
    [search addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [customView addSubview:search];
    
    self.navigationItem.titleView = customView;
}

- (void)setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    
    // 表头
    self.tableView.tableHeaderView = [self tableViewHeaderView];

    // 表尾
    self.tableView.tableFooterView = self.pageViewController.view;
    
    // 自定义悬浮segment
    self.segmentContentView.frame = CGRectMake(0, kBannerHeiht+kButtonViewHeight+10, kScreenWidth, kSegmentHeight);
    [self.tableView addSubview:self.segmentContentView];
    
    //添加监听，动态观察tableview的contentOffset的改变
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    // header 刷新控件
    [self addHeaderRefreshWithScroll:self.tableView action:@selector(refreshAction)];

    // footer 刷新控件
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)setupWithSubjectArray:(NSArray *)subjectArray {
    
    NSMutableArray *segmentTitles = [NSMutableArray arrayWithCapacity:[subjectArray count]];
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[subjectArray count]];
    NSInteger index = 0,i = 0;
    
    for (SurveySubjectModel *model in subjectArray) {
        [segmentTitles addObject:model.subjectTitle];
        
        SurveyContentListController *vc = [[SurveyContentListController alloc] init];
        vc.subjectId = model.subjectId;
        vc.subjectTitle = model.subjectTitle;
        vc.rootController = self;
        vc.delegate = self;
        [controllers addObject:vc];
        
        if ([model.subjectId isEqualToString:kSurveyListRecommendTag]) {
            // 默认选择推荐
            index = i;
        }
        i++;
    }
    
    self.contentControllers = controllers;
    [self setupSegmentWithTitles:segmentTitles withIndex:index];
}

- (void)setupSegmentWithTitles:(NSArray *)titles withIndex:(NSInteger)index{
    CGFloat w = [titles count]*kSegmentItemWidth;
    self.segmentControl.sectionTitles = titles;
    self.segmentControl.frame = CGRectMake(1, 0, w, kSegmentHeight);
    self.segmentContentScrollView.contentSize = CGSizeMake(w, kSegmentHeight);
    
    if ([titles count]) {
        self.segmentControl.selectedSegmentIndex = index;
        [self segmentPressed:self.segmentControl];
    }
}

- (void)setupUserAvatar {
    if (US.isLogIn) {
        UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
        [btn sd_setImageWithURL:[NSURL URLWithString:US.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nav_avatar.png"] options:SDWebImageRefreshCached];
    } else {
        UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
        [btn setImage:[UIImage imageNamed:@"nav_avatar.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (void)searchPressed:(id)sender {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)subscribePressed:(id)sender {

    SubscriptionViewController *vc = [[SubscriptionViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)surveyPressed:(id)sender {

    SurveyDeepTableViewController *vc = [[SurveyDeepTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gradePressed:(id)sender {
    GradeListViewController *vc = [[GradeListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 实盘开户
- (void)morePressed:(id)sender {
    ActualQuotationViewController *vc = [[ActualQuotationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)vipCenterPressed:(id)sender {
    if (US.isLogIn == NO) {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:login animated:YES];
        
    }else {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"unique_str"];
        NSString *url = [NSString stringWithFormat:@"%@%@?unique_str=%@",API_HOST,API_UserVipCenter,accessToken];
        [TDWebViewHandler openURL:url inNav:self.navigationController];
    }
}

- (void)segmentPressed:(HMSegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    __weak SurveyListViewController *wself = self;
    SurveyContentListController *vc = self.contentControllers[index];
    
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){
        [wself reloadTableView];
    }];
}

- (void)selectedSubjectPressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    SelectedSurveySubjectViewController *vc = [[SelectedSurveySubjectViewController alloc] init];
    vc.selectedArray = self.subjectItems;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.selectedBlock = ^(NSArray *array){
    
    };
}

- (void)loginStatusChangedNotifi:(NSNotification *)notifi {
    
    [self querySurveySubject];
}

- (void)optionalStockChangedNotifi:(NSNotification *)notifi {
    for (SurveyContentListController *vc in self.contentControllers) {
        if ([vc.subjectId isEqualToString:kUserAttenSegmentTag]) {
            [vc refreshData];
        }
    }
}

- (void)subjectChangedNotifi:(NSNotification *)notifi {
    NSArray *subjects = notifi.object;

    self.subjectItems = subjects;
    
    [self setupWithSubjectArray:self.subjectItems];
}


- (void)refreshAction {
    [self getBanners];
    [self querySurveySubject];
}

- (void)loadMoreAction {
    [[self currentContentViewController] loadMoreData];
}

- (void)getBanners {
    NetworkManager *manager = [[NetworkManager alloc] initWithBaseUrl:API_HOST];
    [manager GET:API_IndexSurveyBanner parameters:nil completion:^(id data, NSError *error) {
        if (!error) {
            NSArray *banners = data;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:banners.count];
            NSMutableArray *titles = [NSMutableArray arrayWithCapacity:banners.count];
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:banners.count];
            for (NSDictionary *dict in banners) {
                TDAdvertModel *model = [[TDAdvertModel alloc] initWithDictionary:dict];
                [array addObject:model];
                [titles addObject:model.adTitle];
                [urls addObject:model.adImageUrl];
            }
            
            self.bannerLinks = array;
            
            self.cycleScrollView.titlesGroup = titles;
            self.cycleScrollView.imageURLStringsGroup = urls;
        } else {
            
        }
    }];
}

- (void)querySurveySubject {
    __weak SurveyListViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveyAttenSubject parameters:nil completion:^(id data, NSError *error) {
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

- (void)reloadTableView {
    CGFloat contentHeight = [[self currentContentViewController] contentHeight];
    CGFloat minHeight = kScreenHeight - 64-kBannerHeiht-kButtonViewHeight-10-50;
    CGFloat height = MAX(contentHeight, minHeight);
    self.pageViewController.view.frame = CGRectMake(0, 0, kScreenWidth, height);
    // iOS10以下需要添加以下
    self.tableView.tableFooterView = self.pageViewController.view;
    
    [self.tableView reloadData];
}

- (BOOL)checkIsLogin {
    if (US.isLogIn) {
        return YES;
    }
    
    LoginViewController *login = [[LoginViewController alloc] init];
    login.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
    return NO;
}

#pragma mark - SurveyContentListDelegate

- (void)contentListLoadComplete {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }

    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    [self endHeaderRefresh];
    
    [self reloadTableView];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //跳转到详情页
    TDAdvertModel *model = self.bannerLinks[index];
    [TDADHandler pushWithAdModel:model inNav:self.navigationController];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSegmentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyListContentCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SurveyListContentCellID"];
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
        
        CGFloat offx = kSegmentItemWidth*index;
        [self.segmentContentScrollView scrollRectToVisible:CGRectMake(offx, 0, kSegmentItemWidth, kSegmentHeight) animated:YES];
        
        [self reloadTableView];
    }
}

@end
