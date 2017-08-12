//
//  StockPoolSubscibeTableViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSubscibeTableViewController.h"
#import "StockPoolSubscibeCell.h"
#import "MJRefresh.h"
#import "NetworkManager.h"

#define kStockPoolSubscribeCurrentCellID @"kStockPoolSubscribeCurrentCellID"

@interface StockPoolSubscibeTableViewController ()
@property (nonatomic, assign) NSInteger currentPageIndex;

@end

@implementation StockPoolSubscibeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.rowHeight = 100;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.currentPageIndex = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefesh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma - 加载数据
/** 刷新 */
- (void)onRefesh {
    self.currentPageIndex = 1;
    
    
    [self loadStockPoolSubscribeData];
}

/** 加载更多 */
- (void)loadMoreActions {
    [self loadStockPoolSubscribeData];
}


- (void)loadStockPoolSubscribeData {
    
    
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    __weak typeof(self)wSelf = self;
    [manager GET:API_StockPoolGetDesc parameters:nil completion:^(id data, NSError *error) {
        
        if (!error) {
            
            
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView.header endRefreshing];
            
            [self.tableView reloadData];
        }
        
    }];
    
}



#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolSubscibeCell *cell = [tableView dequeueReusableCellWithIdentifier:kStockPoolSubscribeCurrentCellID];
    if (cell == nil) {
        cell = [[StockPoolSubscibeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStockPoolSubscribeCurrentCellID];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}


@end
