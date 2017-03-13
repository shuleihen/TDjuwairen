//
//  AliveMessageListViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveMessageListViewController.h"
#import "AliveMessageListCell.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface AliveMessageListViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger page;
@end

@implementation AliveMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"消息列表";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearPressed:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSBackgroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#333333"]}
                         forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSBackgroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#999999"]}
                         forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    
    UINib *nib = [UINib nibWithNibName:@"AliveMessageListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AliveMessageListCellID"];
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.rowHeight = 90;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    
    [self refreshActions];
}

- (void)clearPressed:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"" message:@"清空后不可在查看，确定清空吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendClearRequest];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
    NSDictionary *dict = @{@"page":@"1"};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_AliveGetRoomNotify parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            NSArray *dataArray = data;
            
            if (dataArray.count > 0) {
                NSMutableArray *list = nil;
                
                if (weakSelf.page == 1) {
                    list = [NSMutableArray arrayWithCapacity:[dataArray count]];
                } else {
                    list = [NSMutableArray arrayWithArray:self.items];
                }
                
                for (NSDictionary *d in dataArray) {
                    AliveMessageModel *model = [[AliveMessageModel alloc] initWithDictionary:d];
                    [list addObject:model];
                }
                weakSelf.items = [NSMutableArray arrayWithArray:list];
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

- (void)sendClearRequest {
    __weak typeof(self)weakSelf = self;
    NSDictionary *dict = @{@"page":@(self.page)};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"清空";
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_AliveClearRoomNotify parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            
            weakSelf.items = nil;
            [weakSelf.tableView reloadData];
            
            hud.labelText = @"清空成功";
            [hud hide:YES];
        } else {
            [weakSelf.tableView reloadData];
            hud.labelText = error.localizedDescription?:@"清空失败";
            [hud hide:YES afterDelay:0.6];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AliveMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliveMessageListCellID"];
    
    // Configure the cell...
    AliveMessageModel *model = self.items[indexPath.row];
    [cell setupMessageModel:model];
    
    return cell;
}


@end
