//
//  SPSubscribedUserListViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/20.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SPSubscribedUserListViewController.h"
#import "LoginStateManager.h"
#import "NSString+Ext.h"
#import "NetworkManager.h"
#import "UIImage+Color.h"
#import "AliveListTableViewCell.h"
#import "ViewpointCollectionTableViewController.h"
#import "StockPoolSubscibeTableViewController.h"

#import "StockCollectionTableViewController.h"


@interface SPSubscribedUserListViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentControllers;
@end

@implementation SPSubscribedUserListViewController

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]  forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.dataSource = nil;
        _pageViewController.delegate = self;
        
        
        [self addChildViewController:_pageViewController];
    }
    return _pageViewController;
}

- (NSArray *)contentControllers {
    if (!_contentControllers) {
        StockPoolSubscibeTableViewController *one = [[StockPoolSubscibeTableViewController alloc] initWithStyle:UITableViewStylePlain];
        one.type = kStockPoolSubscibeVCCurrentType;
        
        StockPoolSubscibeTableViewController *two = [[StockPoolSubscibeTableViewController alloc] initWithStyle:UITableViewStylePlain];
        two.type = kStockPoolSubscibeVCHistoryType;
        _contentControllers = @[one,two];
    }
    
    return _contentControllers;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.title = @"订阅用户";
    
    [self setupSegment];
    
    self.pageViewController.view.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-44);
    [self.view addSubview:self.pageViewController.view];
    
    self.segmentControl.selectedSegmentIndex = 0;
    [self segmentValueChanged:self.segmentControl];
}

- (void)setupSegment{
    
    UIImage *normal = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    UIImage *pressed = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"订阅中",@"已到期"]];
    segmented.tintColor = [UIColor whiteColor];
    segmented.layer.cornerRadius = 0.0f;
    segmented.layer.borderWidth = 1.0f;
    segmented.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [segmented addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: TDDetailTextColor}
                             forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: TDThemeColor}
                             forState:UIControlStateHighlighted];
    [segmented setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: TDThemeColor}
                             forState:UIControlStateSelected];
    segmented.frame = CGRectMake(0, 0, kScreenWidth, 44-TDPixel);
    [segmented setBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:pressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmented setBackgroundImage:normal forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [segmented setSelectedSegmentIndex:0];
    [self.view addSubview:segmented];
    
    self.segmentControl = segmented;
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

#pragma mark - 按钮点击事件
- (void)segmentValueChanged:(UISegmentedControl *)segment {
    NSInteger index = segment.selectedSegmentIndex;
    
    if (index>=0 && index<self.contentControllers.count) {
        UIViewController *vc = self.contentControllers[index];
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){
        }];
    }
}



@end
