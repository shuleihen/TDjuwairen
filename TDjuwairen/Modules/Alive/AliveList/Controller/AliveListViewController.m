//
//  AliveListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "AliveListModel.h"
#import "MJRefresh.h"
#import "AliveMasterListViewController.h"
#import "AliveListTableViewDelegate.h"
#import "AlivePublishViewController.h"
#import "AliveEditMasterViewController.h"
#import "AliveMessageListViewController.h"
#import "LoginState.h"
#import "ZFCWaveActivityIndicatorView.h"
#import "SSColorfulRefresh.h"

@interface AliveListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;
@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong) ZFCWaveActivityIndicatorView *waveActivityIndicator;
@property (nonatomic, strong) SSColorfulRefresh *refresh;
@end

@implementation AliveListViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    }
    
    return _tableView;
}

- (SSColorfulRefresh *)refresh {
    if (!_refresh) {
        NSArray *colors= @[];
        _refresh = [[SSColorfulRefresh alloc] initWithScrollView:self.tableView colors:@[]];
    }
    return _refresh;
}

- (ZFCWaveActivityIndicatorView *)waveActivityIndicator {
    if (!_waveActivityIndicator) {
        _waveActivityIndicator = [[ZFCWaveActivityIndicatorView alloc] init];
        _waveActivityIndicator.center = CGPointMake(kScreenWidth*2.5, 200);
    }
    return _waveActivityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    
    [self refreshActions];
}


#pragma mark - Action

- (void)refreshActions {
    self.currentPage = 1;
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)loadMoreActions{
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)queryAliveListWithType:(AliveListType)listType withPage:(NSInteger)page {
    __weak AliveListViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"tag" :@(listType),@"page" :@(page)};
    
    [self.view addSubview:self.waveActivityIndicator];
    [self.waveActivityIndicator startAnimating];
    
    [manager GET:API_AliveGetRoomList parameters:dict completion:^(id data, NSError *error){
        
        if (wself.tableView.mj_header.isRefreshing) {
            [wself.tableView.mj_header endRefreshing];
        }
        
        if (wself.tableView.mj_footer.isRefreshing) {
            [wself.tableView.mj_footer endRefreshing];
        }
        
        [self.waveActivityIndicator stopAnimating];
        [self.waveActivityIndicator removeFromSuperview];
        
        if (!error) {
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
            
            [wself.tableViewDelegate reloadWithArray:wself.aliveList];
            
            if (scrollToTop) {
                [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
            }
            
        } else if (error.code == kErrorNoLogin){
            wself.aliveList = nil;
            [wself.tableViewDelegate reloadWithArray:wself.aliveList];
        }
        
    }];
}


@end
