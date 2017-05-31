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
#import "UIViewController+Loading.h"
#import "DYRefresh.h"
#import "UIViewController+Refresh.h"

@interface AliveListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;
@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@end

@implementation AliveListViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;

        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    [self.view addSubview:self.tableView];
    
    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    self.tableViewDelegate.listType = self.listType;
    
    [self showLoadingAnimationInCenter:CGPointMake(kScreenWidth/2, self.tableView.bounds.size.height/2)];
    
    [self addHeaderRefreshWithScroll:self.tableView action:@selector(refreshActions)];
    
    [self refreshActions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attendChange:) name:KnotifierGoAddAttend object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
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
    NSString *api = @"";
    NSDictionary *dict = @{};
    
    switch (self.listType) {
        case kAliveListAttention:
        case kAliveListRecommend:
            api = API_AliveGetRoomList;
            dict = @{@"tag" :@(listType),@"page" :@(page)};
            break;
        case kAliveListViewpoint:
            api = API_AliveViewpointList;
            dict = @{@"page" :@(page)};
            break;
        case kAliveListVideo:
            api = API_AliveVideoList;
            dict = @{@"page" :@(page)};
            break;
        default:
            break;
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
            [wself.tableViewDelegate setupAliveListArray:wself.aliveList];
            [wself.tableView reloadData];
        } else {
            if (wself.tableView.mj_footer.isRefreshing) {
                [wself.tableView.mj_footer endRefreshing];
            }
            
            [wself endHeaderRefresh];
            [wself removeLoadingAnimation];
        }
    }];
}

#pragma mark - 关注状态改变通知
- (void)attendChange:(NSNotification *)noti {
    NSString *masterId = noti.userInfo[@"masterID"];
    AliveType listType = [noti.userInfo[@"listType"] integerValue];
    NSString *addAttend = noti.userInfo[@"addAttend"];
    
    if (listType == self.listType && self.listType == AliveRecommend) {
        return;
    }
    
    if (self.listType == AliveAttention && [addAttend isEqualToString:@"1"]) {
        //
        [self refreshActions];
    }else if (self.listType == AliveAttention && [addAttend isEqualToString:@"0"]) {
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
        
    }else if (self.listType == AliveRecommend) {
    
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
