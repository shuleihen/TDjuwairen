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
        one.listType = AliveAttention;
        
        AliveListViewController *two = [[AliveListViewController alloc] init];
        two.listType = AliveRecommend;
        
        AliveListViewController *three = [[AliveListViewController alloc] init];
        three.listType = AliveALL;
        
        _contentControllers = @[one,two,three];
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
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc] initWithTitle:@"贴单"
                                                                 backgroundImage:[UIImage imageNamed:@"alive_publish_small.png"]
                                                      backgroundHighlightedImage:[UIImage imageNamed:@"alive_publish_small.png"]];
        
        DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc] initWithTitle:@"话题"
                                                                 backgroundImage:[UIImage imageNamed:@"alive_publish_small.png"]
                                                      backgroundHighlightedImage:[UIImage imageNamed:@"alive_publish_small.png"]];
        
        // Add the item button into the center button
        //
        [dcPathButton addPathItems:@[itemButton_1,
                                     itemButton_2
                                     ]];
        
        dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopLeft;
        
        // Change the bloom radius, default is 105.0f
        //
        dcPathButton.bloomRadius = 90.0f;
        dcPathButton.bloomAngel = 60.0f;
        
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
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self.view addSubview:self.pageViewController.view];
    
    if (US.isLogIn) {
        self.listType = AliveAttention;
    } else {
        self.listType = AliveRecommend;
    }
    
    self.segmentControl.selectedSegmentIndex = self.listType;
    [self segmentValueChanged:self.segmentControl];
    
    [self.view addSubview:self.publishBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStateChangedNotification object:nil];
}

- (void)setupNavigationBar {
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(45, 28) withColor:[UIColor whiteColor]];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(45, 28) withColor:TDThemeColor];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"关注",@"推荐",@"全部"]];
    segmented.layer.cornerRadius = 0.0f;
    segmented.layer.borderWidth = 1.0f;
    segmented.layer.borderColor = TDThemeColor.CGColor;
    
    [segmented addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: TDThemeColor}
                             forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                             forState:UIControlStateHighlighted];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}
                             forState:UIControlStateSelected];
    
    segmented.frame = CGRectMake(0, 0, 135, 28);
    [segmented setBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = segmented;
    self.segmentControl = segmented;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [rightBtn setTitleColor:TDThemeColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"播主" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(anchorPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
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

- (void)loginStatusChanged:(id)sender {
    if (self.contentControllers.count) {
        AliveListViewController *vc = self.contentControllers.firstObject;
        [vc refreshActions];
    }
    
    if (!US.isLogIn && (self.listType == AliveAttention)) {
        self.listType = AliveRecommend;
        self.segmentControl.selectedSegmentIndex = self.listType;
        [self segmentValueChanged:self.segmentControl];
    }
}

#pragma mark - DCPathButtonDelegate
- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.publishType = (itemButtonIndex == 0)?kAlivePublishPosts:kAlivePublishNormal;
    [self.navigationController pushViewController:vc animated:YES];
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

@end
