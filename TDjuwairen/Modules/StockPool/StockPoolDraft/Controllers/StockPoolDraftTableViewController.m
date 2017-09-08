//
//  StockPoolDraftTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/17.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolDraftTableViewController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "StockPoolAddAndEditViewController.h"
#import "TDNavigationController.h"

@interface StockPoolDraftTableViewController ()
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) NSInteger page;
@end

@implementation StockPoolDraftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"草稿箱";
    self.view.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 63.0f;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.page = 1;
    [self getDratWithPage:self.page];
}

- (void)loadMoreAction {
    [self getDratWithPage:self.page];
}

- (void)getDratWithPage:(NSInteger)pageA {
    __weak StockPoolDraftTableViewController *wself = self;
    
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    hud.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    hud.hidesWhenStopped = YES;
    
    if (pageA == 1) {
        [self.navigationController.view addSubview:hud];
        [hud startAnimating];
    }
    
    NSDictionary *dict = @{@"page" : @(pageA)};
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager GET:API_StockPoolGetDraftList parameters:dict completion:^(id data, NSError *error){
        
        if (pageA == 1) {
            [hud stopAnimating];
            self.tableView.tableHeaderView.hidden = NO;
        }
        
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                wself.list = dataArray;
                wself.page++;
            }
        }
        
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPDraftCellID"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SPDraftCellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
        cell.textLabel.textColor = TDTitleTextColor;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.textColor = TDDetailTextColor;
    }
    
    NSDictionary *dict = self.list[indexPath.row];
    cell.textLabel.text = dict[@"record_desc"]?:@"(无内容)";
    cell.detailTextLabel.text = dict[@"record_date"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.list[indexPath.row];
    NSString *recordId = dict[@"record_id"];
    
    StockPoolAddAndEditViewController *vc = [[StockPoolAddAndEditViewController alloc] init];
    vc.recordId = recordId;
    
    TDNavigationController *editNav = [[TDNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:editNav animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self deleteWithIndexPath:indexPath];
}

- (void)deleteWithIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.list[indexPath.row];
    NSString *recordId = dict[@"record_id"];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"删除草稿";
    
    [manager POST:API_StockPoolDeleteRecord parameters:@{@"record_id":recordId} completion:^(id data, NSError *error){
        if (!error) {
            [hud hideAnimated:YES];
            [self deleteSuccessedWithIndexPath:indexPath];
        } else {
            hud.label.text = @"删除失败";
            [hud hideAnimated:YES afterDelay:0.8];
        }
    }];
}

- (void)deleteSuccessedWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.list];
    [array removeObjectAtIndex:indexPath.row];
    self.list = array;
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

@end
