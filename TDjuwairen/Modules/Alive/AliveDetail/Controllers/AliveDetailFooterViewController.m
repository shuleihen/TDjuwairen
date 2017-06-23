//
//  AliveDetailFooterViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveDetailFooterViewController.h"
#import "AliveMasterListViewController.h"
#import "AlivePingLunViewController.h"
#import "AliveDetailSegmentView.h"

#define kAliveDetailSegmentHeight 34

@interface AliveDetailFooterViewController ()<AliveDetailSegmentViewDelegate>
@property (nonatomic, strong) NSArray *contentControllers;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) AliveDetailSegmentView *segmentView;
@end

@implementation AliveDetailFooterViewController

- (id)initWithAliveId:(NSString *)aliveId aliveType:(AliveType)aliveType {
    if (self = [super init]) {
        self.aliveID = aliveId;
        self.aliveType = aliveType;
    }
    return self;
}

- (NSArray *)contentControllers {
    if (!_contentControllers) {
        
        AlivePingLunViewController *one = [[AlivePingLunViewController alloc] init];
        one.aliveID = self.aliveID;
        one.aliveType = self.aliveType;
//        one.superVC = self;
        
        AliveMasterListViewController *two = [[AliveMasterListViewController alloc] init];
        two.masterId = self.masterId;
        two.aliveId = self.aliveID;
        two.aliveType = self.aliveType;
        two.listType = kAliveDianZanList;
        
        AliveMasterListViewController *three = [[AliveMasterListViewController alloc] init];
        three.masterId = self.masterId;
        three.aliveId = self.aliveID;
        three.aliveType = self.aliveType;
        three.listType = kAliveShareList;
        
        _contentControllers = @[one,two,three];
    }
    
    return _contentControllers;
}

- (UITabBarController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.viewControllers = self.contentControllers;
        _tabBarController.tabBar.hidden = YES;
    }
    
    return _tabBarController;
}

- (AliveDetailSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[AliveDetailSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kAliveDetailSegmentHeight)];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.segmentView];
    
    self.tabBarController.view.frame = CGRectMake(0, kAliveDetailSegmentHeight, kScreenWidth, CGRectGetHeight(self.view.bounds)-kAliveDetailSegmentHeight);
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
}


- (void)didSelectedWithIndex:(NSInteger)selectedIndex {

    self.tabBarController.selectedIndex = selectedIndex;
}

@end
