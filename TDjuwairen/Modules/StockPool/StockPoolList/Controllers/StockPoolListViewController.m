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
#import "StockPoolExpireCell.h"
#import "StockPoolListToolView.h"
#import "LoginStateManager.h"
#import "StockPoolSettingController.h"
#import "SPSubscribedUserListViewController.h"
#import "StockPoolSettingCalendarController.h"
#import "StockPoolDetailViewController.h"
#import "StockPoolListDataModel.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UILabel+TDLabel.h"
#import "StockPoolAddAndEditViewController.h"
#import "TDNavigationController.h"
#import "StockPoolDraftTableViewController.h"
#import "StockUnlockManager.h"
#import "ShareHandler.h"
#import "AlivePublishViewController.h"
#import "MBProgressHUD+Custom.h"

#define StockPoolExpireCellID @"StockPoolExpireCellID"
#define StockPoolListNormalCellID @"StockPoolListNormalCellID"


@interface StockPoolListViewController ()<UITableViewDelegate, UITableViewDataSource, StockPoolListToolViewDelegate,StockPoolSettingCalendarControllerDelegate,StockPoolExpireCellDelegate,
StockUnlockManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StockPoolListToolView *toolView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) StockPoolListDataModel *listDataModel;
@property (nonatomic, copy) NSString *searchMonthStr;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@property (nonatomic, strong) UIBarButtonItem *shareBtn;
@property (nonatomic, strong) UIBarButtonItem *spacer;
@property (nonatomic, strong) UIBarButtonItem *calendarBtn;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *stockPoolIntro;
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
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
        
        UINib *nib = [UINib nibWithNibName:@"StockPoolListCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:StockPoolListNormalCellID];
        UINib *nib2 = [UINib nibWithNibName:@"StockPoolExpireCell" bundle:nil];
        [_tableView registerNib:nib2 forCellReuseIdentifier:StockPoolExpireCellID];
    }
    
    return _tableView;
}

- (StockPoolListToolView *)toolView {
    if (!_toolView) {
        _toolView = [[StockPoolListToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _toolView.delegate = self;
    }
    return _toolView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDViewBackgrouondColor;
    
    [self setupNavigation];
    
    self.unlockManager = [[StockUnlockManager alloc] init];
    self.unlockManager.delegate = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    self.searchMonthStr = [formatter stringFromDate:[NSDate new]];
    
    if ([US.userId isEqualToString:self.userId]) {
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        [self.view addSubview:self.tableView];
        self.toolView.frame = CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50);
        [self.view addSubview:self.toolView];
    } else {
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        [self.view addSubview:self.tableView];
    }
    
    [self configEmptyViewUI];
    
    [self loadShowStockPoolData];
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
    self.calendarBtn = master;
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"nav_share.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 sizeToFit];
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.shareBtn = message;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 15;
    self.spacer = spacer;
}

- (void)configEmptyViewUI {
    
    self.emptyView = [[UIView alloc] init];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-50);
    }];
    
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_nothing"]];
    [self.emptyView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView.mas_centerX);
        make.centerY.equalTo(self.emptyView.mas_centerY).mas_offset(-30);
        
    }];
    
    UILabel *label = [[UILabel alloc] initWithTitle:@"展示个人投资风采，开启赚取钥匙之旅" textColor:TDDetailTextColor fontSize:14.0 textAlignment:NSTextAlignmentCenter];
    if (![US.userId isEqualToString:self.userId]) {
        label.text = @"该用户很懒，没有发布股票记录";
    }
    label.numberOfLines = 0;
    [self.emptyView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(imgV.mas_bottom).mas_offset(19);
    }];
    
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calendarPressed:(id)sender {
    if (self.userId.length <= 0) {
        return;
    }
    StockPoolSettingCalendarController *calendarVC = [[StockPoolSettingCalendarController alloc] init];
    calendarVC.userID = self.userId;
    calendarVC.delegate = self;
    [self.navigationController pushViewController:calendarVC animated:YES];
    
}

- (void)sharePressed:(id)sender {
    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }

    __weak typeof(self)weakSelf = self;

    [ShareHandler shareWithTitle:[NSString stringWithFormat:@"%@的股票池",US.userName]
                          detail:self.stockPoolIntro?:@"无简介"
                           image:nil url:self.shareURL selectedBlock:^(NSInteger index){
        if (index == 0) {
            // 直播分享
            NetworkManager *manager = [[NetworkManager alloc] init];
            NSDictionary *dict = @{@"item_id":SafeValue(self.userId),
                                   @"item_type": @(0)};
            
            [manager POST:API_StockPoolShare parameters:dict completion:^(NSDictionary *data, NSError *error) {
                if (!error) {
                    [MBProgressHUD showHUDAddedTo:weakSelf.view message:@"分享功能"];
                } else {
                    [MBProgressHUD showHUDAddedTo:weakSelf.view message:@"分享失败"];
                }
            }];
        }
    }  shareState:nil];
    
}

#pragma mark - StockPoolListToolViewDelegate
- (void)settingPressed:(id)sender {
    StockPoolSettingController *settingVC = [[StockPoolSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)draftPressed:(id)sender {
    StockPoolDraftTableViewController *vc = [[StockPoolDraftTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)publishPressed:(id)sender {
    StockPoolAddAndEditViewController *vc = [[StockPoolAddAndEditViewController alloc] init];
    
    TDNavigationController *editNav = [[TDNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:editNav animated:YES completion:nil];
}

- (void)attentionPressed:(id)sender {
    SPSubscribedUserListViewController *subscibeVC = [[SPSubscribedUserListViewController alloc] init];
    [self.navigationController pushViewController:subscibeVC animated:YES];
}

- (void)refreshActions {
    self.page = 1;
    [self queryStockPoolList];
}

- (void)loadMoreActions{
    [self queryStockPoolList];
}

- (void)queryStockPoolList {
    /** 获取制定月份下的所有有记录的日期 */
    NetworkManager *manager = [[NetworkManager alloc] init];
    /**
     master_id	int	股票池所属用户ID	是
     date	string	日期	是	20170805 月份、日期为两位数字
     page	int	当前页码，从1开始	是
     */
    NSDictionary *dict = @{@"master_id":SafeValue(self.userId),
                           @"date":self.searchMonthStr,
                           @"page":@(self.page)};
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-64);
    hud.hidesWhenStopped = YES;
    
    if (self.page == 1) {
        [self.view addSubview:hud];
        [hud startAnimating];
    }
    
    [manager GET:API_StockPoolGetRecordList parameters:dict completion:^(NSDictionary *data, NSError *error) {
        
        if (self.page == 1) {
            [hud stopAnimating];
        }
        
        if (!error) {
            if (data != nil) {
                /// 过期数组
                NSMutableArray *arrM1 = nil;
                /// 未过期数组
                NSMutableArray *arrM2 = nil;
                StockPoolListDataModel *newDateListModel = [[StockPoolListDataModel alloc] initWithDict:data];
                
                if (self.page == 1) {
                    arrM1 = [NSMutableArray array];
                    arrM2 = [NSMutableArray array];
                    self.listDataModel = [[StockPoolListDataModel alloc] init];
                    self.listDataModel.expire_time = newDateListModel.expire_time;
                    self.listDataModel.expire_index = newDateListModel.expire_index;
                    
                }else {
                    arrM1 = [NSMutableArray arrayWithArray:self.listDataModel.currentArr];
                    arrM2 = [NSMutableArray arrayWithArray:self.listDataModel.expireArr];
                    self.page ++;
                }
                
                
                
                for (StockPoolListCellModel *cellModel in newDateListModel.list) {
                    if ([cellModel.record_time integerValue] <= [newDateListModel.expire_time integerValue]) {
                        /// 过期
                        cellModel.recordExpired = YES;
                        [arrM2 addObject:cellModel];
                    }else {
                        
                        cellModel.recordExpired = NO;
                        [arrM1 addObject:cellModel];
                    }
                }
                
                
                self.listDataModel.currentArr = [NSArray arrayWithArray:[arrM1 mutableCopy]];
                self.listDataModel.expireArr = [NSArray arrayWithArray:[arrM1 mutableCopy]];
                
                
                NSMutableArray *arrM = [NSMutableArray array];
                if (arrM2.count > 0) {
                    [arrM addObjectsFromArray:arrM2];
                }
                
                if ([newDateListModel.expire_index isEqual:@(1)]) {
                    StockPoolListCellModel *expireModel = [[StockPoolListCellModel alloc] init];
                    expireModel.record_time = newDateListModel.expire_time;
                    expireModel.recordExpiredIndexCell = YES;
                    [arrM addObject:expireModel];
                }
                
                
                
                if (arrM1.count > 0) {
                    
                    [arrM addObjectsFromArray:arrM1];
                    
                }
                self.listDataModel.list = [NSArray arrayWithArray:[arrM mutableCopy]];
                
                
                
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
        
        [self setNaviRightButton:NO];
        
    }];
}

- (void)loadShowStockPoolData {
    /** 股票池记录列表 的头部信息 */
    NetworkManager *manager = [[NetworkManager alloc] init];
    /**
     master_id	int	股票池用户ID	是
     */
    NSDictionary *dict = @{@"master_id":SafeValue(self.userId)};
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-64);
    hud.hidesWhenStopped = YES;
    
    if (self.page == 1) {
        [self.view addSubview:hud];
        [hud startAnimating];
    }
    
    [manager GET:API_StockPoolGetShowStockPool parameters:dict completion:^(NSDictionary *data, NSError *error) {
        [hud stopAnimating];
        if (!error) {
            if (data != nil) {
                self.shareURL = data[@"share_url"];
                self.searchMonthStr = data[@"record_first_day"];
                self.stockPoolIntro = data[@"pool_desc"];
                if (self.searchMonthStr.length <= 0) {
                    [self setNaviRightButton:YES];
                }else {
                    [self refreshActions];
                }
            }
        }
        
    }];
}



- (void)setNaviRightButton:(BOOL)hiddenAll {
    if (hiddenAll == YES) {
        self.navigationItem.rightBarButtonItems = nil;
        self.emptyView.hidden = NO;
        return;
    }
    if (self.listDataModel.list.count <= 0) {
        self.navigationItem.rightBarButtonItems = @[self.calendarBtn];
        self.emptyView.hidden = NO;
        
        
    }else {
        
        self.emptyView.hidden = YES;
        self.navigationItem.rightBarButtonItems = @[self.shareBtn,self.spacer,self.calendarBtn];
        
    }
}


#pragma mark - StockPoolSettingCalendarControllerDelegate
- (void)chooseDateBack:(StockPoolSettingCalendarController *)vc dateStr:(NSString *)str {
    self.page = 1;
    self.searchMonthStr = str;
    [self queryStockPoolList];
    
}

#pragma mark - StockUnlockManagerDelegate
- (void)unlockManager:(StockUnlockManager *)manager withMasterId:(NSString *)masterId {
    [self refreshActions];
}

#pragma mark - StockPoolExpireCellDelegate 续费
- (void)addMoney:(StockPoolExpireCell *)cell cellModel:(StockPoolListCellModel *)cellModel {
    
    [self.unlockManager unlockStockPool:self.userId withController:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listDataModel.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolListCellModel *model = self.listDataModel.list[indexPath.section];
    if (model.recordExpiredIndexCell == YES) {
        StockPoolExpireCell *expireCell = [tableView dequeueReusableCellWithIdentifier:StockPoolExpireCellID];
        expireCell.delegate = self;
        expireCell.cellModel = model;
        return expireCell;
        
    }else {
        StockPoolListCell *cell = [tableView dequeueReusableCellWithIdentifier:StockPoolListNormalCellID];
        cell.cellModel = model;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StockPoolListCellModel *model = self.listDataModel.list[indexPath.section];
    if (model.recordExpiredIndexCell == NO) {
        StockPoolDetailViewController *vc = [[StockPoolDetailViewController alloc] init];
        vc.recordId = model.record_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolListCellModel *model = self.listDataModel.list[indexPath.section];
    if (model.recordExpiredIndexCell == YES) {
        
        return 57;
    }else {
        
        return 160;
    }
    
}


@end
