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
#import "DCPathButton.h"
#import "AlivePublishViewController.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "NotificationDef.h"
#import "LoginState.h"
#import "LoginManager.h"
#import "YXSearchButton.h"
#import "PublishViewViewController.h"
#import "YXTitleCustomView.h"
#import "HexColors.h"
#import "AliveSearchAllTypeViewController.h"
#import "YXUnread.h"
#import "NetworkManager.h"
#import "MessageTableViewController.h"

@interface AliveMainListViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, DCPathButtonDelegate>
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentControllers;
@property (nonatomic, strong) YXUnread *unread;
@property (nonatomic, strong) DCPathButton *publishBtn;
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
        
        AliveListViewController *two = [[AliveListViewController alloc] init];
        two.listType = kAliveListAttention;
        
        AliveListViewController *three = [[AliveListViewController alloc] init];
        three.listType = kAliveListViewpoint;
        
        AliveListViewController *four = [[AliveListViewController alloc] init];
        four.listType = kAliveListVideo;
        
        AliveListViewController *five = [[AliveListViewController alloc] init];
        five.listType = kAlvieListPost;
        
        _contentControllers = @[one,two,three,four,five];
    }
    
    return _contentControllers;
}

- (DCPathButton *)publishBtn {
    if (!_publishBtn) {
        DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"alive_publish_normal.png"]
                                                             highlightedImage:[UIImage imageNamed:@"alive_publish_pressed.png"]];
        dcPathButton.delegate = self;
        
        // Configure item buttons
        //
        
        DCPathItemButton *itemButton_0 = [[DCPathItemButton alloc] initWithTitle:@"观点"
                                                                 backgroundImage:[UIImage imageNamed:@"alive_publish_small.png"]
                                                      backgroundHighlightedImage:[UIImage imageNamed:@"alive_publish_small.png"]];
        
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc] initWithTitle:@"贴单"
                                                                 backgroundImage:[UIImage imageNamed:@"alive_publish_small.png"]
                                                      backgroundHighlightedImage:[UIImage imageNamed:@"alive_publish_small.png"]];
        
        DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc] initWithTitle:@"话题"
                                                                 backgroundImage:[UIImage imageNamed:@"alive_publish_small.png"]
                                                      backgroundHighlightedImage:[UIImage imageNamed:@"alive_publish_small.png"]];
        
        // Add the item button into the center button
        //
        [dcPathButton addPathItems:@[itemButton_0,
                                     itemButton_1,
                                     itemButton_2
                                     ]];
        
        dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopLeft;
        
        // Change the bloom radius, default is 105.0f
        //
        dcPathButton.bloomRadius = 90.0f;
        dcPathButton.bloomAngel = 90.0f;
        
        // Change the DCButton's center
        //
        dcPathButton.dcButtonCenter = CGPointMake(kScreenWidth - 26 - dcPathButton.frame.size.width/2, kScreenHeight -64 - 90);
        
        // Setting the DCButton appearance
        //
        dcPathButton.allowSounds = YES;
        dcPathButton.allowCenterButtonRotation = YES;
        
        dcPathButton.bottomViewColor = [UIColor grayColor];
        
        _publishBtn = dcPathButton;
    }
    
    return _publishBtn;
}

- (YXUnread *)unread {
    if (!_unread) {
        _unread = [[YXUnread alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    }
    
    return _unread;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSegmentControl];

    self.pageViewController.view.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-44);
    [self.view addSubview:self.pageViewController.view];
    
    [self.view addSubview:self.publishBtn];
    
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"关注",@"观点",@"视频",@"推单"]];
    segmented.tintColor = [UIColor whiteColor];
    segmented.layer.cornerRadius = 0.0f;
    segmented.layer.borderWidth = 1.0f;
    segmented.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [segmented addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#666666"]}
                             forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371E2"]}
                             forState:UIControlStateHighlighted];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#3371E2"]}
                             forState:UIControlStateSelected];
    
    segmented.frame = CGRectMake(0, 0, 300, 44-TDPixel);
    [segmented setBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:normal forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 44-TDPixel, kScreenWidth, TDPixel)];
    sep.backgroundColor = TDSeparatorColor;
    [view addSubview:sep];
    
    [view addSubview:segmented];
    
    [self.view addSubview:view];
    
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
    
    // 视频模块不显示 + 按钮
    self.publishBtn.hidden = (index == kAliveListVideo);
    
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

#pragma mark - DCPathButtonDelegate
- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    
    if (itemButtonIndex == 0) {
        //跳转到发布页面
        PublishViewViewController *publishview = [[PublishViewViewController alloc] init];
        publishview.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publishview animated:YES];
    }else {
        
        AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.publishType = (itemButtonIndex == 1)?kAlivePublishPosts:kAlivePublishNormal;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
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
