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

@interface AliveMainListViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, assign) AliveListType listType;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentControllers;
@end

@implementation AliveMainListViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self.view addSubview:self.pageViewController.view];
    
    self.listType = AliveAttention;
    
    self.segmentControl.selectedSegmentIndex = self.listType;
    [self segmentValueChanged:self.segmentControl];
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
