//
//  AliveMainListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMainListViewController.h"
#import "AliveListViewController.h"
#import "UIImage+Color.h"
#import "AliveMasterListViewController.h"
#import "AlivePublishViewController.h"
#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "NotificationDef.h"
#import "LoginStateManager.h"
#import "LoginManager.h"
#import "YXSearchButton.h"
#import "PublishViewViewController.h"
#import "YXTitleCustomView.h"
#import "HexColors.h"
#import "AliveSearchAllTypeViewController.h"
#import "YXUnread.h"
#import "NetworkManager.h"
#import "MessageTableViewController.h"
#import "AliveListStockPoolViewController.h"

@interface AliveMainListViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentControllers;
@property (nonatomic, strong) YXUnread *unread;
@end

@implementation AliveMainListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]  forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        [self addChildViewController:_pageViewController];
    }
    return _pageViewController;
}

- (NSArray *)contentControllers {
    if (!_contentControllers) {
        AliveListViewController *one = [[AliveListViewController alloc] init];
        one.listType = kAliveListRecommend;
        one.mainlistType = self.mainListType;
        
        AliveListViewController *two = [[AliveListViewController alloc] init];
        two.listType = kAliveListAttention;
        two.mainlistType = self.mainListType;
        
        AliveListViewController *three = [[AliveListViewController alloc] init];
        three.listType = kAliveListViewpoint;
        three.mainlistType = self.mainListType;
        
        AliveListViewController *four = [[AliveListViewController alloc] init];
        four.listType = kAliveListVideo;
        four.mainlistType = self.mainListType;
        
        AliveListViewController *five = [[AliveListViewController alloc] init];
        five.listType = kAlvieListPost;
        five.mainlistType = self.mainListType;
        
        AliveListStockPoolViewController *six = [[AliveListStockPoolViewController alloc] init];
        six.listType = kAliveListStockPool;
        six.mainlistType = self.mainListType;
        
        AliveListViewController *sen = [[AliveListViewController alloc] init];
        sen.listType = kAlvieListHot;
        sen.mainlistType = self.mainListType;
        
        AliveListViewController *eight = [[AliveListViewController alloc] init];
        eight.listType = kAliveListStockHolder;
        eight.mainlistType = self.mainListType;
        
        if (self.mainListType == kMainListRecommend) {
            _contentControllers = @[one,eight,six,three,four,five,sen];
        } else {
            _contentControllers = @[two,eight,six,three,four,five,sen];
        }
    }
    
    return _contentControllers;
}

- (YXUnread *)unread {
    if (!_unread) {
        _unread = [[YXUnread alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    }
    
    return _unread;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSegmentControl];

    self.pageViewController.view.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-44);
    [self.view addSubview:self.pageViewController.view];
    
    if (US.isLogIn) {
        [self reloadView];
    } else {
        // 等待LoginManager 执行完成
        [self performSelector:@selector(reloadView) withObject:nil afterDelay:0.8];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStateChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getUnreadMessageCount];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setupSegmentControl {
    
    CGFloat itemW = 75;
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    scroolView.backgroundColor = [UIColor whiteColor];
    scroolView.contentSize = CGSizeMake(itemW*7, 44);
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(itemW, 28) withColor:[UIColor whiteColor]];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(itemW, 28) withColor:[UIColor whiteColor]];
    
    NSArray *tites = tites = @[@"全部",@"股东大会",@"股票池",@"观点",@"视频",@"推单",@"热点"];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:tites];
    segmented.tintColor = [UIColor whiteColor];
    segmented.layer.cornerRadius = 0.0f;
    segmented.layer.borderWidth = 1.0f;
    segmented.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [segmented addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f weight:UIFontWeightSemibold], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                             forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f weight:UIFontWeightSemibold], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371E2"]}
                             forState:UIControlStateHighlighted];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f weight:UIFontWeightSemibold], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371E2"]}
                             forState:UIControlStateSelected];
    
    segmented.frame = CGRectMake(0, 0, tites.count * itemW, 44-TDPixel);
    [segmented setBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:normal forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 44-TDPixel, kScreenWidth, TDPixel)];
    sep.backgroundColor = TDSeparatorColor;
    [scroolView addSubview:sep];
    
    [scroolView addSubview:segmented];
    
    [self.view addSubview:scroolView];
    
    self.segmentControl = segmented;
}

- (void)setupNavigationBar {
    
    YXTitleCustomView *customView = [[YXTitleCustomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    // 搜索
    YXSearchButton *search = [[YXSearchButton alloc] init];
    search.backgroundColor = [UIColor whiteColor];
    [search setTitle:@"搜索关键字" forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    search.frame = CGRectMake(12, 7, kScreenWidth-12-88, 30);
    [customView addSubview:search];
    
    UIButton *aliveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-78, 7, 30, 30)];
    [aliveBtn setImage:[UIImage imageNamed:@"nav_anchor.png"] forState:UIControlStateNormal];
    [aliveBtn addTarget:self action:@selector(anchorPressed:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:aliveBtn];
    
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-30-12, 7, 30, 30)];
    [messageBtn setImage:[UIImage imageNamed:@"nav_message.png"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:messageBtn];
    
    self.navigationItem.titleView = customView;
    
    self.unread.center = CGPointMake(23, 5);
    [messageBtn addSubview:self.unread];
}

- (void)segmentValueChanged:(UISegmentedControl *)segment {
    NSInteger index = segment.selectedSegmentIndex;
    
    if (index>=0 && index<self.contentControllers.count) {
        AliveListViewController *vc = self.contentControllers[index];
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){
        }];
    }
}

- (void)anchorPressed:(id)sender {
    
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = kAliveMasterList;
    [aliveMasterListVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

/// 消息列表
- (void)messagePressed:(id)sender {
    MessageTableViewController *vc = [[MessageTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchPressed:(id)sender {
    AliveSearchAllTypeViewController *searchVC = [[AliveSearchAllTypeViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)loginStatusChanged:(id)sender {
    self.contentControllers = nil;
    
    self.segmentControl.selectedSegmentIndex = 0;
    [self segmentValueChanged:self.segmentControl];
}

- (void)reloadView {
    self.segmentControl.selectedSegmentIndex = 0;
    [self segmentValueChanged:self.segmentControl];
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
    }
}


#pragma mark -
- (void)getUnreadMessageCount {
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_MessageGetUnread parameters:@{} completion:^(id data, NSError *error) {
        
        if (!error && data) {
            NSInteger count = [data[@"msg_count"] integerValue];
            self.unread.count = count;
        } else {
            
        }
    }];
}

@end
