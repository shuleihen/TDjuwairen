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
#import "ViewPointViewController.h"
#import "VideoViewController.h"
#import "PublishViewViewController.h"
#import "YXTitleCustomView.h"
#import "HexColors.h"
#import "AliveSearchAllTypeViewController.h"

@interface AliveMainListViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, DCPathButtonDelegate>
@property (nonatomic, assign) AliveListType listType;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentControllers;

@property (nonatomic, strong) DCPathButton *publishBtn;
@end

@implementation AliveMainListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        
        
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                           forKey: UIPageViewControllerOptionSpineLocationKey];
        
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
        one.listType = AliveRecommend;
        
        AliveListViewController *two = [[AliveListViewController alloc] init];
        two.listType = AliveAttention;
        
        //        AliveListViewController *three = [[AliveListViewController alloc] init];
        //        three.listType = AliveALL;
        
        ViewPointViewController *pointVC = [[ViewPointViewController alloc] init];
        
        VideoViewController *videoVC = [[VideoViewController alloc] init];
        
        
        _contentControllers = @[one,two,pointVC,videoVC];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSegmentControl];
    
    self.listType = AliveRecommend;
    
    self.pageViewController.view.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-44);
    [self.view addSubview:self.pageViewController.view];
    
    self.segmentControl.selectedSegmentIndex = (self.listType == AliveRecommend)?0:1;
    [self segmentValueChanged:self.segmentControl];
    
    [self.view addSubview:self.publishBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStateChangedNotification object:nil];
    
    [LoginManager getAuthKey];
    [LoginManager checkLogin];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [UIImage imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)setupSegmentControl {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"关注",@"观点",@"视频"]];
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
    
    segmented.frame = CGRectMake(0, 0, 240, 44-TDPixel);
    [segmented setBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
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
    aliveMasterListVC.listType = AliveMasterList;
    [aliveMasterListVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

/// 消息列表
- (void)messagePressed:(id)sender {
    UIViewController *messageListVC = [[UIViewController alloc] init];
    messageListVC.title = @"消息列表";
    messageListVC.view.backgroundColor = [UIColor whiteColor];
    [messageListVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:messageListVC animated:YES];
}


- (void)loginStatusChanged:(id)sender {
    
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    if (index >=0 && index<=self.contentControllers.count) {
        AliveListViewController *vc = self.contentControllers[index];
        [vc refreshActions];
    }
    
    /*
     if (self.contentControllers.count) {
     AliveListViewController *vc = self.contentControllers.firstObject;
     [vc refreshActions];
     }
     
     if (!US.isLogIn && (self.listType == AliveAttention)) {
     self.listType = AliveRecommend;
     self.segmentControl.selectedSegmentIndex = (self.listType == AliveRecommend)?0:1;
     [self segmentValueChanged:self.segmentControl];
     }
     */
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
        vc.publishType = (itemButtonIndex == 0)?kAlivePublishPosts:kAlivePublishNormal;
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

#pragma mark - 搜索点击事件
- (void)searchPressed:(id)sender {
    AliveSearchAllTypeViewController *searchVC = [[AliveSearchAllTypeViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}



@end
