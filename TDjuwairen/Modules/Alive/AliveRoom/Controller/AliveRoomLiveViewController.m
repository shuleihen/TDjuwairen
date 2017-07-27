//
//  AliveRoomLiveViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomLiveViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "AliveListModel.h"
#import "MJRefresh.h"
#import "UIImage+Color.h"
#import "AliveMasterListViewController.h"
#import "AliveListTableViewDelegate.h"
#import "AlivePublishViewController.h"
#import "AliveEditMasterViewController.h"
#import "LoginState.h"
#import "UIViewController+Loading.h"
#import "UIViewController+NoData.h"

@interface AliveRoomLiveViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;
@property (nonatomic, strong) AliveListTableViewDelegate *tableViewDelegate;
@end

@implementation AliveRoomLiveViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [self setupNoDataImage:[UIImage imageNamed:@"no_result.png"] message:@"还没有任何动态哦~"];
    
    __weak AliveRoomLiveViewController *wself = self;
    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    self.tableViewDelegate.avatarPressedEnabled = NO;
    self.tableViewDelegate.reloadView = ^{
        [wself reloadTableView];
    };
    
    self.currentPage = 1;    
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (CGFloat)contentHeight {
    return [self.tableViewDelegate contentHeight];
}

- (void)refreshAction {
    self.currentPage = 1;
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)loadMoreAction {
    [self queryAliveListWithType:self.listType withPage:self.currentPage];
}

- (void)queryAliveListWithType:(AliveRoomListType)listType withPage:(NSInteger)page {
    __weak AliveRoomLiveViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"master_id":self.masterId,@"tag":@(listType),@"page":@(self.currentPage)};

    UIActivityIndicatorView *hud = [self showActivityIndicatorInView:self.view withCenter:CGPointMake(kScreenWidth/2, 40)];
    [hud startAnimating];
    
    [manager GET:API_AliveGetRoomLiveList parameters:dict completion:^(id data, NSError *error){
        
        [hud stopAnimating];
        
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
                    
                    [wself.tableView reloadData];
                    [wself showNoDataView:(wself.aliveList.count == 0)];
                    
                    [wself reloadTableView];
                    
                    if (scrollToTop) {
                        [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
                    }
                });
                
            });
            
        } else {
            
        }
        
    }];
}

- (void)reloadTableView {

    CGFloat height = [self contentHeight];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentListLoadComplete)]) {
        [self.delegate contentListLoadComplete];
    }
}
@end
