//
//  AliveMasterListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMasterListViewController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "AliveMasterListTabelViewDelegate.h"
#import "AliveMasterModel.h"

@interface AliveMasterListViewController ()

@property (nonatomic, assign) NSInteger page;
@property (strong, nonatomic) NSMutableArray *aliveArr;
@property (nonatomic, strong) AliveMasterListTabelViewDelegate *tableViewDelegate;
@end


@implementation AliveMasterListViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    switch (self.listType) {
        case kAliveMasterList:
            self.title = @"播主";
            break;
        case kAliveAttentionList:
            self.title = @"关注";
            break;
        case kAliveFansList:
            self.title = @"粉丝";
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.tableView];
    
    self.aliveArr = [NSMutableArray array];
    
    self.tableViewDelegate = [[AliveMasterListTabelViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
    self.tableViewDelegate.listType = self.listType;
    
    [self refreshActions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddLick:) name:kAddLikeNotification object:nil];
}

- (void)refreshAddLick:(NSNotification *)noti{
    
    if ([noti.userInfo[@"notiType"] isEqualToString:@"dianzan"] && self.listType == kAliveDianZanList) {
         [self requestDataWithPage:1];
    }else if ([noti.userInfo[@"notiType"] isEqualToString:@"fenxiang"] && self.listType == kAliveShareList) {
    
        [self requestDataWithPage:1];
    }
}

- (void)refreshActions{
    self.page = 1;
    [self requestDataWithPage:self.page];
}

- (void)loadMoreActions{
    [self requestDataWithPage:self.page];
}

- (void)requestDataWithPage:(NSInteger)aPage{
    
    __weak typeof(self)weakSelf = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NSDictionary *dict = nil;
    NSString *url = nil;
    
    switch (self.listType) {
        case kAliveMasterList:
            dict = @{@"page":@(aPage)};
            url = API_AliveGetMasterList;
            break;
        case kAliveAttentionList:
            dict = @{@"master_id": self.masterId,@"page":@(aPage)};
            url = API_AliveGetAttenList;
            break;
        case  kAliveFansList:
            dict = @{@"master_id": self.masterId,@"page":@(aPage)};
            url = API_AliveGetFansList;
            break;
        case kAliveDianZanList:
        {
            self.page = 1;
            dict = @{@"alive_id": self.aliveId,@"alive_type":@(self.aliveType)};
            url = API_AliveGetRoomLike;
        }
            break;
        case kAliveShareList:
        {
            self.page = 1;
            dict = @{@"alive_id": self.aliveId,@"alive_type":@(self.aliveType)};
            url = API_AlvieGetRoomShare;
        }
            break;
        default:
            break;
    }
    
    
    [ma GET:url  parameters:dict completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            NSArray *dataArray = data;
            
            NSMutableArray *list = nil;
            
            if (aPage == 1) {
                if ([self.aliveArr respondsToSelector:@selector(removeAllObjects)]) {
                    [self.aliveArr removeAllObjects];
                }
                list = [NSMutableArray arrayWithCapacity:[dataArray count]];
            } else {
                list = [NSMutableArray arrayWithArray:self.aliveArr];
            }
            
            for (NSDictionary *d in dataArray) {
                AliveMasterModel *model = [[AliveMasterModel alloc] initWithDictionary:d];
                [list addObject:model];
            }
            weakSelf.aliveArr = [NSMutableArray arrayWithArray:list];
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.page++;
            weakSelf.tableViewDelegate.itemList = weakSelf.aliveArr;
            
            if (weakSelf.listType == kAliveDianZanList || weakSelf.listType == kAliveShareList) {
                if (weakSelf.dataBlock) {
                    weakSelf.dataBlock(weakSelf.aliveArr.count);
                }
            }
            
            
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
