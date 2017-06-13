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
#import "AliveMasterListTableViewCell.h"
#import "AliveMasterModel.h"
#import "LoginState.h"
#import "MBProgressHUD.h"
#import "AliveRoomViewController.h"

@interface AliveMasterListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger page;
@property (strong, nonatomic) NSMutableArray *aliveArr;
@property (strong, nonatomic) UIViewController *vc;

@end


@implementation AliveMasterListViewController

- (instancetype)initWithDianZanVC:(UIViewController *)vc aliveId:(NSString *)aliveId  aliveType:(AliveType)aliveType viewControllerType:(AliveMasterListType)listType {
    
    if (self = [super init]) {
        self.vc = vc;
        self.listType = listType;
        self.masterId = aliveId;
        self.aliveType = aliveType;
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    [self refreshActions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddLick:) name:KnotifierGoAddLike object:nil];
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
            dict = @{@"alive_id": self.masterId,@"alive_type":@(self.aliveType)};
            url = API_AliveGetRoomLike;
        }
            break;
        case kAliveShareList:
        {
            self.page = 1;
            dict = @{@"alive_id": self.masterId,@"alive_type":@(self.aliveType)};
            url = API_AlvieGetRoomShare;
        }
            break;
        default:
            break;
    }
    
    
    [ma GET:url  parameters:dict completion:^(id data, NSError *error){
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
            [weakSelf.tableView reloadData];
            
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.aliveArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AliveMasterListTableViewCell *cell = [AliveMasterListTableViewCell loadAliveMasterListTableViewCell:tableView];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    AliveMasterModel *model = self.aliveArr[indexPath.row];
    cell.aliveModel = model;
    
    if (self.listType == kAliveDianZanList) {
        cell.introLabel.hidden = YES;
    }else {
        cell.introLabel.hidden = NO;
        
    }
    
    __weak typeof(self)weakSelf = self;
#pragma mark - 关注／取消关注操作
    cell.attentedBlock = ^(){
        if (!US.isLogIn) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        
        if (model.masterId.length <= 0) {
            return ;
        }
        
        NSString *str = API_AliveAddAttention;
        if (model.isAtten == YES) {
            // 取消关注
            str = API_AliveDelAttention;
        }
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        
        [manager POST:str parameters:@{@"user_id":model.masterId} completion:^(id data, NSError *error){
            
            if (!error) {
                
                if (data && [data[@"status"] integerValue] == 1) {
                    
                    model.isAtten = !model.isAtten;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
            } else {
            }
            
        }];
        
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AliveMasterModel *model = self.aliveArr[indexPath.row];
    if (model.masterId.length <= 0) {
        return;
    }
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:model.masterId];
    
    if (self.listType == kAliveDianZanList || self.listType == kAliveShareList) {
        [self.vc.navigationController pushViewController:vc animated:YES];
    }else {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == kAliveDianZanList) {
        
        return 74;
    }else {
        
        return 100;
    }
    
}


@end
