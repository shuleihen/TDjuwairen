//
//  GradeListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/1/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "GradeListViewController.h"
#import "GradeListModel.h"
#import "GradeListCell.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "GradeDetailViewController.h"
#import "StockDetailViewController.h"

@interface GradeListViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *items;
@end

@implementation GradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"评级排行";
    
    UINib *nib = [UINib nibWithNibName:@"GradeListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StockAssessedCellID"];
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self refreshData];
}

- (void)testData {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (int i=1; i<10; i++) {
        GradeListModel *one = [[GradeListModel alloc] init];
        one.sortNumber = i;
        one.stockName = @"万润股份（002643）";
        one.stockId = @"002643";
        one.grade = 75.0f;
        one.type = (i/2)?1:2;
        [array addObject:one];
    }
    
    
    self.items = array;
    [self.tableView reloadData];
}

- (void)refreshData {
    self.page = 1;
    [self getSurveyWithPage:self.page];
}

- (void)loadMoreData {
    [self getSurveyWithPage:self.page];
}


- (void)getSurveyWithPage:(NSInteger)pageA {
    __weak GradeListViewController *wself = self;
    NSDictionary *dict = @{@"page" : @(pageA)};
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_SurveyGradeList parameters:dict completion:^(id data, NSError *error){
        if ([wself.tableView.mj_header isRefreshing]) {
            [wself.tableView.mj_header endRefreshing];
        }
        
        if ([wself.tableView.mj_footer isRefreshing]) {
            [wself.tableView.mj_footer endRefreshing];
        }
        
        if (!error && data) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[data count]];
            for (NSDictionary *dict in data) {
                GradeListModel *model = [[GradeListModel alloc] initWithDict:dict];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockAssessedCellID"];
    
    GradeListModel *model = self.items[indexPath.row];
    [cell setupGradeListModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GradeListModel *model = self.items[indexPath.row];
    
    StockDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SurveyDetail" bundle:nil] instantiateInitialViewController];
    vc.stockId = model.stockId;
    [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
}
@end
