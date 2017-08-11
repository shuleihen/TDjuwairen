//
//  AliveListStockPoolViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListStockPoolViewController.h"
#import "AliveListStockPoolTableViewCell.h"
#import "NetworkManager.h"
#import "AliveListStockPoolModel.h"
#import "MJRefresh.h"
#import "UIViewController+Refresh.h"
#import "UIViewController+Loading.h"

@interface AliveListStockPoolViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AliveListStockPoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150.0f;
    
    UINib *nib = [UINib nibWithNibName:@"AliveListStockPoolTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveListStockPoolTableViewCellID"];
    
    [self showLoadingAnimationInCenter:CGPointMake(kScreenWidth/2, self.tableView.bounds.size.height/2)];
    
    [self refreshActions];
}

- (void)refreshActions {
    self.currentPage = 1;
    [self queryStockPoolListWithPage:self.currentPage];
}

- (void)loadMoreActions {
    [self queryStockPoolListWithPage:self.currentPage];
}

- (void)queryStockPoolListWithPage:(NSInteger)page {
    __weak typeof(self)wself = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    [ma GET:API_StockPoolGetList parameters:@{@"page": @(page)} completion:^(id data, NSError *error){
        
        if (!error) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *dataArray = data;
                BOOL scrollToTop = NO;
                
                if (dataArray.count > 0) {
                    NSMutableArray *list = nil;
                    if (wself.currentPage == 1) {
                        list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                        scrollToTop = YES;
                    } else {
                        list = [NSMutableArray arrayWithArray:wself.aliveList];
                    }
                    
                    for (NSDictionary *d in dataArray) {
                        AliveListStockPoolModel *model = [[AliveListStockPoolModel alloc] initWithDictionary:d];
                        [list addObject:model];
                        
                    }
                    
                    wself.aliveList = [NSArray arrayWithArray:list];
                    
                    wself.currentPage++;
                } else {
                    if (wself.currentPage == 1) {
                        wself.aliveList = nil;
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (wself.tableView.mj_footer.isRefreshing) {
                        [wself.tableView.mj_footer endRefreshing];
                    }
                    
                    [wself endHeaderRefreshWithDataCount:dataArray.count];
                    [wself removeLoadingAnimation];
                    
                    [wself.tableView reloadData];
                    
                    
                    if (scrollToTop) {
                        [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
                    }
                });
                
            });
            
        } else if (error.code == kErrorNoLogin){
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself endHeaderRefresh];
            [wself removeLoadingAnimation];
            
            
            wself.aliveList = nil;
            [wself.tableView reloadData];
        } else if (error.code == kErrorLoginout) {
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself endHeaderRefresh];
            [wself removeLoadingAnimation];
        } else {
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself endHeaderRefresh];
            [wself removeLoadingAnimation];
        }
    }];
}

#pragma mark - UITableView Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.aliveList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveListStockPoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveListStockPoolTableViewCellID"];
    AliveListStockPoolModel *model = self.aliveList[indexPath.row];
    [cell setupAliveStockPool:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
@end
