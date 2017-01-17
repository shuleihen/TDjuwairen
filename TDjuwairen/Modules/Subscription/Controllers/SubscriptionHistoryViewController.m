//
//  SubscriptionHistoryViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "SubscriptionHistoryViewController.h"
#import "SubscriptionModel.h"
#import "SubscriptionHistoryListCell.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "LoginState.h"

@interface SubscriptionHistoryViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SubscriptionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"往期购买";
    
    UINib *nib = [UINib nibWithNibName:@"SubscriptionHistoryListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SubscriptionHistoryListCellID"];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = 132.0f;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    
    [self refreshAction];
}

- (void)refreshAction {
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreAction {
    [self getSurveyWithPage:self.page];
}


- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak SubscriptionHistoryViewController *wself = self;
    
    NSDictionary *dict = dict = @{@"page" : @(pageA),@"user_id" : US.userId};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SubscriptionHistory parameters:dict completion:^(id data, NSError *error){
        
        if ([wself.tableView.mj_header isRefreshing]) {
            [wself.tableView.mj_header endRefreshing];
        }
        
        if ([wself.tableView.mj_footer isRefreshing]) {
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (!error && data) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *dict in data) {
                SubscriptionModel *model = [[SubscriptionModel alloc] initWithDict:dict];
                [array addObject:model];
            }
            
            if (pageA == 1) {
                wself.items = array;
            } else {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.items];
                [tempArray addObjectsFromArray:array];
                wself.items = tempArray;
            }
            [wself.tableView reloadData];
            wself.page ++;
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscriptionHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscriptionHistoryListCellID"];
    
    SubscriptionModel *model = self.items[indexPath.section];
    [cell setupSubscriptionModel:model];
    
    return cell;
}

@end
