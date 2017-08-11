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

@interface AliveListRootViewController ()
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@end

@implementation AliveListRootViewController

- (UITabBarController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.tabBar.hidden = YES;
        
        AliveMainListViewController *one = [[AliveMainListViewController alloc] init];
        one.mainListType = kMainListRecommend;
        
        AliveMainListViewController *two = [[AliveMainListViewController alloc] init];
        two.mainListType = kMainListAttention;
        _tabBarController.viewControllers = @[one,two];
    }
    return _tabBarController;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        view.backgroundColor = [UIColor whiteColor];
        
//        UIImage *normal = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
//        UIImage *pressed = [UIImage imageWithSize:CGSizeMake(60, 28) withColor:[UIColor whiteColor]];
        
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"关注"]];
        _segmentControl.tintColor = [UIColor clearColor];
        
        [_segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightRegular]}
                                 forState:UIControlStateNormal];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightMedium], NSForegroundColorAttributeName: [UIColor whiteColor]}
                                 forState:UIControlStateHighlighted];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightMedium], NSForegroundColorAttributeName: [UIColor whiteColor]}
                                 forState:UIControlStateSelected];
        
        _segmentControl.frame = CGRectMake(0, 0, 120, 44);
//        [_segmentControl setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [_segmentControl setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        [_segmentControl setBackgroundImage:nil forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//        [_segmentControl setBackgroundImage:nil forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        UIImage *dividerImage = [UIImage imageWithSize:CGSizeMake(1, 3) withColor:[UIColor whiteColor] withCornerWidth:1.5];
        [_segmentControl setDividerImage:dividerImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    return _segmentControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
    self.tabBarController.selectedIndex = 0;
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
    self.tabBarController.selectedIndex = sender.selectedIndex;
}
@end
