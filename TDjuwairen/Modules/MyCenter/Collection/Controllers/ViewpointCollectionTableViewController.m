//
//  ViewpointCollectionTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "ViewpointCollectionTableViewController.h"
#import "AliveListTableViewDelegate.h"
#import "UIViewController+Loading.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "AliveListModel.h"
#import "UIViewController+NoData.h"

@interface ViewpointCollectionTableViewController ()
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;
@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@end

@implementation ViewpointCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    AliveListTableViewDelegate *delegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    delegate.listType = kAliveListViewpoint;
    delegate.canEdit = YES;
    self.tableViewDelegate = delegate;
    
    [self showLoadingAnimationInCenter:CGPointMake(kScreenWidth/2, self.tableView.bounds.size.height/2)];
    
    [self setupNoDataImage:[UIImage imageNamed:@"no_result.png"] message:@"您还没有过收藏"];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self refreshActions];
}

- (void)refreshActions {
    self.currentPage = 1;
    [self queryAliveListWithType:kAliveListViewpoint withPage:self.currentPage];
}

- (void)loadMoreActions{
    [self queryAliveListWithType:kAliveListViewpoint withPage:self.currentPage];
}

- (void)queryAliveListWithType:(AliveListType)listType withPage:(NSInteger)page {
    __weak ViewpointCollectionTableViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"tag": @(0),@"page": @(page)};
    
    [manager GET:API_GetCollectionList parameters:dict completion:^(id data, NSError *error){
        
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
                        AliveListModel *model = [[AliveListModel alloc] initWithDictionary:d];
                        [list addObject:model];
                        
                    }
                    
                    wself.aliveList = [NSArray arrayWithArray:list];
                    
                    wself.currentPage++;
                } else {
                    if (wself.currentPage == 1) {
                        wself.aliveList = nil;
                    }
                }
                
                [wself.tableViewDelegate setupAliveListArray:wself.aliveList];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (wself.tableView.mj_footer.isRefreshing) {
                        [wself.tableView.mj_footer endRefreshing];
                    }
                    
                    [wself removeLoadingAnimation];
                    
                    [wself.tableView reloadData];
                    [wself showNoDataView:(wself.aliveList.count == 0)];
                    
                    if (scrollToTop) {
                        [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
                    }
                });
                
            });
            
        } else if (error.code == kErrorNoLogin){
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself removeLoadingAnimation];
            
            
            wself.aliveList = nil;
            [wself.tableViewDelegate setupAliveListArray:wself.aliveList];
            [wself.tableView reloadData];
        } else {
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself removeLoadingAnimation];
        }
    }];
}

@end
