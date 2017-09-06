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
#import "MBProgressHUD+Custom.h"
#import "NotificationDef.h"
#import "SettingHandler.h"
#import "StockPoolListIntroModel.h"
#import "AlivePublishViewController.h"

#define StockPoolExpireCellID @"StockPoolExpireCellID"
#define StockPoolListNormalCellID @"StockPoolListNormalCellID"


@interface StockPoolListViewController ()<UITableViewDelegate, UITableViewDataSource, StockPoolListToolViewDelegate,StockPoolSettingCalendarControllerDelegate,StockPoolExpireCellDelegate,StockUnlockManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StockPoolListToolView *toolView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) StockPoolListDataModel *listDataModel;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) StockUnlockManager *unlockManager;
@property (nonatomic, strong) UIBarButtonItem *shareBtn;
@property (nonatomic, strong) UIBarButtonItem *spacer;
@property (nonatomic, strong) UIBarButtonItem *calendarBtn;
@property (nonatomic, assign) NSInteger searchTimeInterval;
@property (nonatomic, strong) StockPoolListIntroModel *introlModel;

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
    
    self.items = [NSMutableArray arrayWithCapacity:10];
    
    self.searchTimeInterval = [[NSDate date] timeIntervalSince1970] + 24*60*60;
    
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
    
    [self queyStockPoolIntro];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stockPoolRecordChangedNotifi:) name:kStockPoolRecordChangedSuccessed object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kStockPoolRecordChangedSuccessed object:nil];
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

- (void)setupEmpty:(BOOL)empty {
    self.emptyView.hidden = !empty;
}

- (void)setupNaviRightButton  {
    if (self.introlModel == nil) {
        return;
    }
    
    if (self.introlModel.firstRecordDay.length) {
        self.navigationItem.rightBarButtonItems = @[self.shareBtn,self.spacer,self.calendarBtn];
    } else {
        self.navigationItem.rightBarButtonItems = @[self.shareBtn];
    }
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

    
    NSString *title = [NSString stringWithFormat:@"%@的股票池",US.userName];
    NSString *detail = self.introlModel.intro?:@"无简介";
    
    AlivePublishModel *publishModel = [[AlivePublishModel alloc] init];
    publishModel.forwardId = self.userId;
    publishModel.image = nil;
    publishModel.title = title;
    publishModel.detail = detail;
    
    AlivePublishType publishType = kAlivePublishStockPool;

    
    __weak typeof(self)weakSelf = self;

    [ShareHandler shareWithTitle:title
                          detail:detail
                           image:nil
                             url:self.introlModel.shareURL
                   selectedBlock:^(NSInteger index){
           if (index == 0) {
               // 转发
               AlivePublishViewController *vc = [[AlivePublishViewController alloc] initWithStyle:UITableViewStyleGrouped];
               vc.hidesBottomBarWhenPushed = YES;
               
               vc.publishType = publishType;
               vc.publishModel = publishModel;
               [weakSelf.navigationController pushViewController:vc animated:YES];
           }
    }  shareState:nil];
    
}


- (BOOL)isNeedUnlockWithStockPoolListCellModel:(StockPoolListCellModel *)cellModel {
    if (!self.introlModel || !cellModel) {
        return YES;
    }
    
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    
    if (self.introlModel.isMaster) {
        return NO;
    }
    
    if (self.introlModel.isSubscribed == NO) {
        // 未订阅
        return YES;
    } else {
        // 订阅
        if (self.introlModel.isFree) {
            // 免费
            return NO;
        } else if (self.introlModel.isFree == NO && self.introlModel.expireTime > nowTime) {
            // 未过期
            return NO;
        }
    }
    
    return [cellModel.record_time longLongValue] > self.introlModel.expireTime;
}

- (void)insertExpireTimeCellWithArray:(NSMutableArray *)array {
    if (!self.introlModel ||
        self.introlModel.isMaster ||
        self.introlModel.isFree) {
        return;
    }
    
    // 只有订阅过期的才会插入过期提示
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    if (self.introlModel.isSubscribed && (self.introlModel.expireTime < nowTime)) {
        int i=0;
        for (StockPoolListCellModel *cellModel in array) {
            if (cellModel.isExpireCell) {
                return;
            } else {
                if (self.introlModel.expireTime > [cellModel.record_time longLongValue]) {

                    StockPoolListCellModel *model = [[StockPoolListCellModel alloc] init];
                    model.isExpireCell = YES;
                    model.record_time = [NSNumber numberWithInteger:self.introlModel.expireTime];
                    [self.items insertObject:model atIndex:i];
                    return;
                }
            }
            i++;
        }
    }
    
}

#pragma mark - Notifi
- (void)stockPoolRecordChangedNotifi:(NSNotification *)notifi {
    NSInteger type = [notifi.object integerValue];
    if (type == 1) {
        [self.toolView hidTipImageView];
        [SettingHandler addStockPoolRecord];
    }
    
    [self.items removeAllObjects];
    self.searchTimeInterval = [[NSDate date] timeIntervalSince1970] + 24*60*60;
    [self queryStockPoolListWithDirect:NO withTimeInterval:self.searchTimeInterval];
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
    StockPoolListCellModel *first = self.items.firstObject;
    self.searchTimeInterval = [first.record_time integerValue];
    [self queryStockPoolListWithDirect:YES withTimeInterval:self.searchTimeInterval];
}

- (void)loadMoreActions{
    StockPoolListCellModel *last = self.items.lastObject;
    self.searchTimeInterval = [last.record_time integerValue];
    [self queryStockPoolListWithDirect:NO withTimeInterval:self.searchTimeInterval];
}

- (void)queryStockPoolListWithDirect:(BOOL)isUp withTimeInterval:(NSInteger)timeInterval {

    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"master_id":SafeValue(self.userId),
                           @"direct": isUp?@"1":@"0",
                           @"time": @(timeInterval)};
    
    [manager GET:API_StockPoolGetRecordList parameters:dict completion:^(NSDictionary *data, NSError *error) {
        
        
        if (!error && [data isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *marray = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary *dict in data) {
                StockPoolListCellModel *cellModel = [[StockPoolListCellModel alloc] initWithDict:dict];
                [marray addObject:cellModel];
            }
            
            if (isUp) {
                [self.items insertObjects:marray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, marray.count)]];
            } else {
                [self.items addObjectsFromArray:marray];
            }
        }
        
        if ( self.items.count && self.introlModel.expireTime) {
            // 插入过期线
            [self insertExpireTimeCellWithArray:self.items];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
        [self setupEmpty:(self.items.count==0)];
    }];
}

- (void)queyStockPoolIntro {

    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"master_id":SafeValue(self.userId)};
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-64);
    hud.hidesWhenStopped = YES;
    
    [self.view addSubview:hud];
    [hud startAnimating];
    
    [manager GET:API_StockPoolGetShowStockPool parameters:dict completion:^(NSDictionary *data, NSError *error) {
        [hud stopAnimating];
        
        if (!error && data) {
            self.introlModel = [[StockPoolListIntroModel alloc] initWithDictionary:data];
            
            [self queryStockPoolListWithDirect:NO withTimeInterval:self.searchTimeInterval];
        }
        
        [self setupNaviRightButton];
    }];
}



#pragma mark - StockPoolSettingCalendarControllerDelegate
- (void)chooseDateBack:(StockPoolSettingCalendarController *)vc date:(NSDate *)date {
    [self.items removeAllObjects];
    
    NSInteger time = [date timeIntervalSince1970] + 24*60*60;
    [self queryStockPoolListWithDirect:NO withTimeInterval:time];
}

#pragma mark - StockUnlockManagerDelegate
- (void)unlockManager:(StockUnlockManager *)manager withMasterId:(NSString *)masterId {
    // 订阅以后过期时间：订阅的当天的第二天00：00 开始 +设 置的股票池时间，这里只要保证大于列表数据的添加时间就可以
    
    self.introlModel.expireTime = [[NSDate new] timeIntervalSince1970] + 24*60*60;
    self.introlModel.isSubscribed = YES;
    
    for (StockPoolListCellModel *cellModel in self.items) {
        if (cellModel.isExpireCell) {
            [self.items removeObject:cellModel];
            break;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - StockPoolExpireCellDelegate
- (void)addMoney:(StockPoolExpireCell *)cell cellModel:(StockPoolListCellModel *)cellModel {
    
    [self.unlockManager unlockStockPool:self.userId withController:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolListCellModel *model = self.items[indexPath.section];
    
    if (model.isExpireCell) {
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
    
    StockPoolListCellModel *model = self.items[indexPath.section];
    if (model.isExpireCell) {
        return;
    }
    
    if ([self isNeedUnlockWithStockPoolListCellModel:model] == NO) {
        StockPoolDetailViewController *vc = [[StockPoolDetailViewController alloc] init];
        vc.recordId = model.record_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self.unlockManager unlockStockPool:self.userId withController:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolListCellModel *model = self.items[indexPath.section];
    if (model.isExpireCell) {
        return 57;
    }else {
        return 160;
    }
}


@end
