//
//  StockPoolListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolListViewController.h"
#import "NetworkManager.h"
#import "StockPoolListCell.h"
#import "StockPoolListToolView.h"
#import "LoginStateManager.h"
#import "StockPoolSettingController.h"


@interface StockPoolListViewController ()<UITableViewDelegate, UITableViewDataSource, StockPoolListToolViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StockPoolListToolView *toolView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *items;
@end

@implementation StockPoolListViewController


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 160.0f;
        
        UINib *nib = [UINib nibWithNibName:@"StockPoolListCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"StockPoolListCellID"];
    }
    
    return _tableView;
}

- (StockPoolListToolView *)toolView {
    if (!_toolView) {
        _toolView = [[StockPoolListToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    }
    return _toolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TDViewBackgrouondColor;
    
    [self setupNavigation];
    
//    if ([US.userId isEqualToString:self.userId]) {
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        [self.view addSubview:self.tableView];
        self.toolView.frame = CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50);
        [self.view addSubview:self.toolView];
//    } else {
//        [self.view addSubview:self.tableView];
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupNavigation {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    label.text = @"股票池";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"nav_backwhite.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"nav_calendar.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(calendarPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 sizeToFit];
    UIBarButtonItem *master = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"nav_share.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 sizeToFit];
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 15;
    self.navigationItem.rightBarButtonItems = @[message,spacer,master];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calendarPressed:(id)sender {
    
}

- (void)sharePressed:(id)sender {
    
}

#pragma mark - StockPoolListToolViewDelegate
- (void)settingPressed:(id)sender {
    StockPoolSettingController *settingVC = [[StockPoolSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)draftPressed:(id)sender {
    
}

- (void)publishPressed:(id)sender {
    
}

- (void)attentionPressed:(id)sender {
    
}

- (void)refreshActions {
    self.page = 1;
    [self queryStockPoolListWithPage:self.page];
}

- (void)loadMoreActions{
    [self queryStockPoolListWithPage:self.page];
}

- (void)queryStockPoolListWithPage:(NSInteger)page {
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;//[self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockPoolListCellID"];
    cell.progressView.progress = 0.7f;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
@end
