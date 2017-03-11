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
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (strong, nonatomic)  NSArray *aliveArr;



@end

@implementation AliveMasterListViewController

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
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
    
    switch (self.listType) {
        case AliveMasterList:
            self.title = @"播主";
            break;
        case AliveAttentionList:
            self.title = @"关注";
            break;
        case  AliveFansList:
            self.title = @"粉丝";
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.tableView];
    
    self.aliveArr = [NSArray array];
    [self refreshActions];
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
        case AliveMasterList:
            dict = @{@"page":@(self.page)};
            url = API_AliveGetMasterList;
            break;
        case AliveAttentionList:
            dict = @{@"master_id": self.masterId,@"page":@(self.page)};
            url = API_AliveGetAttenList;
            break;
        case  AliveFansList:
            dict = @{@"master_id": self.masterId,@"page":@(self.page)};
            url = API_AliveGetFansList;
            break;
        default:
            break;
    }
    
    [ma GET:url  parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                
                if (weakSelf.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:self.aliveArr];
                }
                
                for (NSDictionary *d in dataArray) {
                    AliveMasterModel *model = [[AliveMasterModel alloc] initWithDictionary:d];
                    [list addObject:model];
                }
                weakSelf.aliveArr = [NSMutableArray arrayWithArray:list];
            }
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.page++;
            [weakSelf.tableView reloadData];
            
            
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
    AliveMasterModel *model = self.aliveArr[indexPath.row];
    cell.aliveModel = model;
    __weak typeof(self)weakSelf = self;
    
    cell.attentedBlock = ^(){
        if (model.masterId.length <= 0) {
            return ;
        }
        
        NSString *str = API_AliveAddAttention;
        if (model.isAtten == YES) {
            // 取消关注
            str = API_AliveDelAttention;
        }
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"提交中...";
        
        NetworkManager *manager = [[NetworkManager alloc] init];
        
        [manager POST:str parameters:@{@"user_id":model.masterId} completion:^(id data, NSError *error){
         
            if (!error) {
                
                if (data && [data[@"status"] integerValue] == 1) {
                    
                    model.isAtten = !model.isAtten;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [hud hide:YES afterDelay:0.2];
                }
            } else {
                hud.labelText = error.localizedDescription?:@"提交失败";
                [hud hide:YES afterDelay:0.4];
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
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithRoomMasterId:model.masterId];
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

@end
