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
#import "LoginStateManager.h"
#import "ZFCWaveActivityIndicatorView.h"
#import "UIViewController+Loading.h"
#import "DYRefresh.h"
#import "UIViewController+Refresh.h"
#import "AliveNoAttentionTableViewController.h"

@interface AliveListViewController ()

@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong) AliveNoAttentionTableViewController *noAttentionController;
@end

@implementation AliveListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AliveListTableViewDelegate *delegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    delegate.listType = self.listType;
    self.tableViewDelegate = delegate;
    
//    [self refreshActions];
    [self beginRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attendChange:) name:kAddAttenNotification object:nil];
}


#pragma mark - Action

- (void)refreshActions {
    self.currentPage = 1;
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)loadMoreActions {
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)queryAliveListWithType:(AliveListType)listType withPage:(NSInteger)page {
    __weak AliveListViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSString *api = @"";
    NSDictionary *dict = @{};
    
    switch (self.listType) {
        case kAliveListAttention:
            api = API_AliveGetAttenAliveList;
            break;
        case kAliveListRecommend:
            api = API_AliveGetRecAliveList;
            break;
        case kAliveListViewpoint:
            api = API_ViewGetList;
            break;
        case kAliveListVideo:
            api = API_VideoGetList;
            break;
        case kAlvieListPost:
            api = API_AliveGetPostAliveList;
            break;
        case kAlvieListHot:
            api = API_AliveGetHotAliveList;
            break;
        case kAliveListStockHolder:
            api = API_AliveGetStockHolderList;
            break;
        default:
            NSAssert(NO, @"直播列表不支持当前类型");
            break;
    }
    
    if (self.mainlistType == kMainListAttention) {
        dict = @{@"page" :@(page),@"is_atten": @"1"};
    } else {
        dict = @{@"page" :@(page)};
    }
    
    [manager GET:api parameters:dict completion:^(id data, NSError *error){
    
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
                    
                    [wself endHeaderRefresh];
                    
                    [wself.tableView reloadData];
                    
                    if (wself.listType == kAliveListAttention) {
                        [wself showNoAttetionControllerView:(wself.aliveList.count==0)];
                    }
                    
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
            
            wself.aliveList = nil;
            [wself.tableViewDelegate setupAliveListArray:wself.aliveList];
            [wself.tableView reloadData];
        } else if (error.code == kErrorLoginout) {
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself endHeaderRefresh];
            
            [self showNoAttetionControllerView:YES];
        } else {
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself endHeaderRefresh];
        }
    }];
}

- (void)showNoAttetionControllerView:(BOOL)show {
    if (show) {
        if (!self.noAttentionController) {
            self.noAttentionController = [[AliveNoAttentionTableViewController alloc] initWithStyle:UITableViewStylePlain];
            self.tableView.tableHeaderView = self.noAttentionController.view;
            [self addChildViewController:self.noAttentionController];
            
             self.tableView.mj_footer = nil;
        }        
    } else {
        if (self.noAttentionController) {
            self.tableView.tableHeaderView = nil;
            self.noAttentionController = nil;
            
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
        }
    }
}

#pragma mark - 关注状态改变通知
- (void)attendChange:(NSNotification *)noti {
    NSString *masterId = noti.userInfo[@"masterID"];
    AliveType listType = [noti.userInfo[@"listType"] integerValue];
    NSString *addAttend = noti.userInfo[@"addAttend"];
    
    if (listType == self.listType && self.listType == kAliveListRecommend) {
        return;
    }
    
    if (self.listType == kAliveListAttention && [addAttend isEqualToString:@"1"]) {
        //
        [self refreshActions];
    }else if (self.listType == kAliveListAttention && [addAttend isEqualToString:@"0"]) {
        // 关注列表
        
        NSMutableArray *tempArrM = [NSMutableArray array];
        for (AliveListModel *listModel in self.aliveList) {
            
            if (![listModel.masterId isEqualToString:masterId]) {
                [tempArrM addObject:listModel];
            }
        }
        
        if (tempArrM.count <= 0) {
             [self refreshActions];
        }else {
        
            self.aliveList = tempArrM;
        }
        
    }else if (self.listType == kAliveListRecommend || self.listType == kAliveListViewpoint) {
    
        for (AliveListModel *listModel in self.aliveList) {
            if ([listModel.masterId isEqualToString:masterId]) {
                listModel.isAttend = !listModel.isAttend;
            }
        }
    }
    
    [self.tableViewDelegate setupAliveListArray:self.aliveList];
    [self.tableView reloadData];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
