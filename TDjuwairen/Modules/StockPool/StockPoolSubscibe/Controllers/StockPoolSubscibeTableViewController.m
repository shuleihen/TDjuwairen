//
//  StockPoolSubscibeTableViewController.m
//  TDjuwairen
//
//  Created by deng shu on 2017/8/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSubscibeTableViewController.h"
#import "StockPoolSubscibeCell.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "StockPoolSubscibeModel.h"
#import "AliveRoomViewController.h"

#define kStockPoolSubscribeCellID @"kStockPoolSubscribeCellID"

@interface StockPoolSubscibeTableViewController ()<StockPoolSubscibeCellDelegate>
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation StockPoolSubscibeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.currentPageIndex = 1;
    self.dataArr = [NSArray array];
    
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.rowHeight = 100;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefesh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    
    [self loadStockPoolSubscribeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma - 加载数据
/** 刷新 */
- (void)onRefesh {
    self.currentPageIndex = 1;
    
    
    [self loadStockPoolSubscribeData];
}

/** 加载更多 */
- (void)loadMoreActions {
    [self loadStockPoolSubscribeData];
}


- (void)loadStockPoolSubscribeData {
    /**
     master_id	int	股票池所属用户ID	是
     type	int	0表示订阅中的用户列表，1表示过期的用户列表	是
     page	int	当前页码啊，从1开始
     */
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *pDict = @{@"master_id":US.userId,@"type":@(self.type),@"page":[NSString stringWithFormat:@"%ld",self.currentPageIndex]};
    
    [manager GET:API_StockPoolGetSubscribeUser parameters:pDict completion:^(id data, NSError *error) {
        
        if (!error) {
            
            NSMutableArray *arrM = nil;
            if (self.currentPageIndex == 1) {
                arrM = [NSMutableArray array];
            }else {
                
                arrM = [NSMutableArray arrayWithArray:self.dataArr];
            }
            
            NSArray *tempArr = data;
            if (tempArr.count > 0) {
                for (NSDictionary *dict in tempArr) {
                    StockPoolSubscibeModel *model = [[StockPoolSubscibeModel alloc] initWithDict:dict];
                    [arrM addObject:model];
                }
            }
            
            
            self.currentPageIndex ++;
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView.header endRefreshing];
            
            [self.tableView reloadData];
        }
        
    }];
    
}



#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolSubscibeCell *cell = [tableView dequeueReusableCellWithIdentifier:kStockPoolSubscribeCellID];
    if (cell == nil) {
        cell = [[StockPoolSubscibeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStockPoolSubscribeCellID];
    }
    cell.delegate = self;
    cell.historyCell = self.type == kStockPoolSubscibeVCHistoryType;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    StockPoolSubscibeModel *model = self.dataArr[indexPath.row];
    if (model.user_id.length <= 0) {
        return;
    }
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:model.user_id];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}


#pragma mark - StockPoolSubscibeCellDelegate 
- (void)attentionAction:(StockPoolSubscibeCell *)cell subscibeModel:(StockPoolSubscibeModel *)model {

    if (!US.isLogIn) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
   
    if (model.user_id.length <= 0) {
        return ;
    }
    __weak typeof(self)weakSelf = self;
    NSString *str = API_AliveAddAttention;
    if (model.has_atten) {
        // 取消关注
        str = API_AliveDelAttention;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    //    cell.attentBtn.isLoading = YES;
    
    [manager POST:str parameters:@{@"user_id":model.user_id} completion:^(id data, NSError *error){
        
        if (!error) {
            
            if (data && [data[@"status"] integerValue] == 1) {
                
                model.has_atten = !model.has_atten;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        } else {
        }
        
    }];
    
}

@end
