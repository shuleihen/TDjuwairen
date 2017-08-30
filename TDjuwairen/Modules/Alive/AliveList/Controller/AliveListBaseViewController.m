//
//  AliveListBaseViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListBaseViewController.h"
#import "MJRefresh.h"
#import "UIViewController+Refresh.h"

@interface AliveListBaseViewController ()

@end

@implementation AliveListBaseViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
        
        [self addHeaderRefreshWithScroll:_tableView action:@selector(refreshActions)];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)refreshActions {
    NSAssert(NO, @"需要子类实现");
}

- (void)loadMoreActions {
    NSAssert(NO, @"需要子类实现");
}
@end
