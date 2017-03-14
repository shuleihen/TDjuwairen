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
#import "AliveMessageListViewController.h"
#import "LoginState.h"


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
    
    self.tableViewDelegate = [[AliveListTableViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    
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

- (void)queryAliveListWithType:(AliveRoomLiveType)listType withPage:(NSInteger)page {
    __weak AliveRoomLiveViewController *wself = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"master_id":self.masterId,@"tag":@(listType),@"page":@(self.currentPage)};

    [manager GET:API_AliveGetRoomLiveList parameters:dict completion:^(id data, NSError *error){
        
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
            
            [wself reloadTableView];
            
            if (scrollToTop) {
                [wself.tableView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, 1) animated:YES];
            }
            
            if (wself.delegate && [self.delegate respondsToSelector:@selector(contentListLoadComplete)]) {
                [wself.delegate contentListLoadComplete];
            }
            
        } else {
            
        }
        
    }];
}

- (void)reloadTableView {
    
    [self.tableViewDelegate reloadWithArray:self.aliveList];
    
    CGFloat height = [self contentHeight];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, height);
}
@end