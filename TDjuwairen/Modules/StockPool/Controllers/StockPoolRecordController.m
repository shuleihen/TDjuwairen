//
//  StockPoolRecordController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolRecordController.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UIViewController+Refresh.h"
#import "StockPoolRecordNormalCell.h"

#define kStockPoolRecordCellID    @"kStockPoolRecordCellID"

@interface StockPoolRecordController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIView *settingView;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation StockPoolRecordController
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"股票池";
    self.view.backgroundColor = TDViewBackgrouondColor;
    [self configNavigationBar];
    /// 加载tableView
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)configNavigationBar {
    // 设置title和返回按钮颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *image = [[UIImage imageNamed:@"nav_backwhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    // 设置右侧按钮（日历、分享）
    UIImage *calendarImage = [[UIImage imageNamed:@"ico_calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *calendarBarBtn = [[UIBarButtonItem alloc] initWithImage:calendarImage style:UIBarButtonItemStylePlain target:self action:@selector(calendarBarBtnClick)];
    UIImage *shareImage = [[UIImage imageNamed:@"ico_share.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(shareBarBtnClick)];
    self.navigationItem.rightBarButtonItems = @[shareBarBtn,calendarBarBtn];
    
    
}


#pragma - action
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 日历按钮点击事件 */
- (void)calendarBarBtnClick {
    
    
}

/** 分享按钮点击事件 */
- (void)shareBarBtnClick {
    
    
}

#pragma - 加载数据
/** 刷新 */
- (void)onRefresh {
    self.currentPage = 0;
    [self loadStockPoolRecordData];
    
}

/** 加载更多 */
- (void)loadMoreActions {
    [self loadStockPoolRecordData];
    
}

/** 网络请求数据 */
- (void)loadStockPoolRecordData {
    
    //    __weak AliveListViewController *wself = self;
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self endHeaderRefresh];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StockPoolRecordNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:kStockPoolRecordCellID];
    if (cell == nil) {
        cell = [[StockPoolRecordNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStockPoolRecordCellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TDLineColor;
    [footerV addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(63.5);
        make.top.equalTo(footerV.mas_top);
        make.width.mas_equalTo(1);
        make.height.equalTo(footerV);
    }];
    
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 159;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat footerH = (tableView.bounds.size.height-tableView.contentSize.height);
    return footerH < 0 ? 0 : footerH;
}

@end
