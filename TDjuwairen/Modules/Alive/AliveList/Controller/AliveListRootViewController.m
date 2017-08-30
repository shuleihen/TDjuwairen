//
//  AliveListRootViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListRootViewController.h"
#import "MessageTableViewController.h"
#import "AliveSearchAllTypeViewController.h"
#import "AliveMasterListViewController.h"
#import "AliveMainListViewController.h"
#import "UIImage+Create.h"
#import "UIImage+Color.h"
#import "TDSegmentedControl.h"
#import "StockPoolListViewController.h"

@interface AliveListRootViewController ()<UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentControllers;
@end

@implementation AliveListRootViewController

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
        AliveMainListViewController *one = [[AliveMainListViewController alloc] init];
        one.mainListType = kMainListRecommend;
        
        AliveMainListViewController *two = [[AliveMainListViewController alloc] init];
        two.mainListType = kMainListAttention;
        
        _contentControllers = @[one,two];
    }
    
    return _contentControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    
    [self.view addSubview:self.pageViewController.view];
}

- (void)setupNavigationBar {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"nav_search.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"nav_anchor.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(anchorPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 sizeToFit];
    UIBarButtonItem *master = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"nav_message.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(messagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 sizeToFit];
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 15;
    self.navigationItem.rightBarButtonItems = @[message,spacer,master];
    
    TDSegmentedControl *segmentControl = [[TDSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 120, 44) witItems:@[@"推荐",@"关注"]];
    [segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
    
    [self segmentValueChanged:segmentControl];
}

#pragma mark - Action

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

- (void)anchorPressed:(id)sender {
    AliveMasterListViewController *aliveMasterListVC = [[AliveMasterListViewController alloc] init];
    aliveMasterListVC.listType = kAliveMasterList;
    [aliveMasterListVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:aliveMasterListVC animated:YES];
}

- (void)segmentValueChanged:(TDSegmentedControl *)sender {

    NSInteger index = sender.selectedIndex;
    
    if (index>=0 && index<self.contentControllers.count) {
        UIViewController *vc = self.contentControllers[index];
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finish){
        }];
    }
}
@end
