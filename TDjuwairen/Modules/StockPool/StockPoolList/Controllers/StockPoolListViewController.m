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
#import "StockPoolSubscibeController.h"
#import "StockPoolSettingCalendarController.h"
#import "StockPoolSettingDataModel.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UILabel+TDLabel.h"

#define StockPoolExpireCellID @"StockPoolExpireCellID"
#define StockPoolListNormalCellID @"StockPoolListNormalCellID"


@interface StockPoolListViewController ()<UITableViewDelegate, UITableViewDataSource, StockPoolListToolViewDelegate,StockPoolSettingCalendarControllerDelegate,StockPoolExpireCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StockPoolListToolView *toolView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) StockPoolSettingDataModel *listDataModel;
@property (nonatomic, copy) NSString *searchMonthStr;
@property (nonatomic, strong) UIView *emptyView;
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
    [self configEmptyViewUI];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsMonth = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    self.searchMonthStr = [NSString stringWithFormat:@"%ld%ld%ld",componentsMonth.year,componentsMonth.month,componentsMonth.day];
    
    [self refreshActions];
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
    StockPoolSettingCalendarController *calendarVC = [[StockPoolSettingCalendarController alloc] init];
    calendarVC.delegate = self;
    [self.navigationController pushViewController:calendarVC animated:YES];
    
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
    StockPoolSubscibeController *subscibeVC = [[StockPoolSubscibeController alloc] init];
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
    NSDictionary *dict = @{@"master_id":US.userId,
                           @"date":self.searchMonthStr,
                           @"page":@(self.page)};
    [manager GET:API_StockPoolGetRecordList parameters:dict completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            
            NSMutableArray *arrM1 = nil;
            NSMutableArray *arrM2 = nil;
            StockPoolSettingDataModel *newDateListModel = [[StockPoolSettingDataModel alloc] initWithDict:data];
            
            if (self.page == 1) {
                arrM1 = [NSMutableArray array];
                arrM2 = [NSMutableArray array];
                self.listDataModel = [[StockPoolSettingDataModel alloc] init];
                self.listDataModel.expire_time = newDateListModel.expire_time;
                self.listDataModel.expire_index = newDateListModel.expire_index;
                
            }else {
                arrM1 = [NSMutableArray arrayWithArray:self.listDataModel.currentArr];
                arrM2 = [NSMutableArray arrayWithArray:self.listDataModel.expireArr];
                self.page ++;
            }
            
            
            
            for (StockPoolSettingListModel *listModel in newDateListModel.list) {
                if ([listModel.record_time integerValue] <= [newDateListModel.expire_time integerValue]) {
                    /// 过期
                    listModel.recordExpired = YES;
                    [arrM2 addObject:listModel];
                }else {
                    
                    listModel.recordExpired = NO;
                    [arrM1 addObject:listModel];
                }
            }
            
            
            self.listDataModel.currentArr = [NSArray arrayWithArray:[arrM1 mutableCopy]];
            self.listDataModel.expireArr = [NSArray arrayWithArray:[arrM1 mutableCopy]];
            
            
            NSMutableArray *arrM = [NSMutableArray array];
            if (arrM1.count > 0) {
                
                [arrM addObjectsFromArray:arrM1];
                
            }
            if ([newDateListModel.expire_index isEqual:@(1)]) {
                StockPoolSettingListModel *expireModel = [[StockPoolSettingListModel alloc] init];
                expireModel.record_time = newDateListModel.expire_time;
                expireModel.recordExpiredIndexCell = YES;
                [arrM addObject:expireModel];
            }
            
            if (arrM2.count > 0) {
                [arrM addObjectsFromArray:arrM2];
            }
            
            self.listDataModel.list = [NSArray arrayWithArray:[arrM mutableCopy]];
            
            
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (self.listDataModel.list.count > 0) {
            self.emptyView.hidden = YES;
        }else {
            
            self.emptyView.hidden = NO;
        }
        
    }];
}


#pragma mark - StockPoolSettingCalendarControllerDelegate
- (void)chooseDateBack:(StockPoolSettingCalendarController *)vc dateStr:(NSString *)str {
    self.page = 1;
    self.searchMonthStr = str;
    [self queryStockPoolList];
    
}

#pragma mark - StockPoolExpireCellDelegate 续费
- (void)addMoney:(StockPoolExpireCell *)vc listModel:(StockPoolSettingListModel *)listModel {
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listDataModel.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolSettingListModel *model = self.listDataModel.list[indexPath.section];
    if (model.recordExpiredIndexCell == YES) {
        StockPoolExpireCell *expireCell = [tableView dequeueReusableCellWithIdentifier:StockPoolExpireCellID];
        expireCell.delegate = self;
        expireCell.listModel = model;
        return expireCell;
        
    }else {
        StockPoolListCell *cell = [tableView dequeueReusableCellWithIdentifier:StockPoolListNormalCellID];
        cell.listModel = model;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolSettingListModel *model = self.listDataModel.list[indexPath.section];
    if (model.recordExpiredIndexCell == YES) {
        
        return 57;
    }else {
        
        return 160;
    }
    
}


@end
