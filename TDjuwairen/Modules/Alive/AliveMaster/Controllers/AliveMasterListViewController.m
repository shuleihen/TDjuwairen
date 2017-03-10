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
    
    self.title = @"播主";
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
    
    [ma GET:API_AliveGetMasterList  parameters:@{@"page":@(self.page)} completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
           
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
//
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
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}

@end
