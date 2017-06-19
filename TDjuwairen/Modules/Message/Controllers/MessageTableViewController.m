//
//  MessageTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/16.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "MessageTableViewController.h"
#import "MessageListTableViewCell.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "UIViewController+Loading.h"

@interface MessageTableViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MessageTableViewController

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
    
    UINib *nib = [UINib nibWithNibName:@"MessageListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MessageListTableViewCellID"];
    
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.rowHeight = 90;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshActions)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
    
    [self showLoadingAnimationInCenter:CGPointMake(kScreenWidth/2, self.tableView.bounds.size.height/2)];
    
    [self refreshActions];
}

- (void)clearPressed:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清空列表" message:@"\n清空列表消息将永久删除，确认清空？\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self sendClearRequest];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
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
    NSDictionary *dict = @{@"page":@(aPage)};
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma GET:API_MessageGetList parameters:dict completion:^(id data, NSError *error){
        
        [self removeLoadingAnimation];
        
        if (!error) {
            NSArray *dataArray = data[@"msg_list"];
            
            if (dataArray.count > 0) {
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:dataArray.count];

                for (NSDictionary *d in dataArray) {
                    MessageListModel *model = [[MessageListModel alloc] initWithDictionary:d];
                    [list addObject:model];
                }
                
                if (weakSelf.page == 1) {
                    weakSelf.items = [NSMutableArray arrayWithArray:list];
                } else {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
                    [array addObjectsFromArray:list];
                    weakSelf.items = array;
                }
            }
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.page++;
            [weakSelf.tableView reloadData];
            
            weakSelf.navigationItem.rightBarButtonItem.enabled = weakSelf.items.count?YES:NO;
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        }
    }];
    
}

- (void)sendClearRequest {
    __weak typeof(self)weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"清空";
    
    NetworkManager *ma = [[NetworkManager alloc] init];
    [ma POST:API_MessageClear parameters:nil completion:^(id data, NSError *error){
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
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCellID"];
    
    // Configure the cell...
    MessageListModel *model = self.items[indexPath.row];
    [cell setupMessageModel:model];
    
    return cell;
}

#pragma mark - UITableVeiw Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除消息?" message:@"\n删除消息，将不在列表中显示\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self cancelEditWithIndexPath:indexPath];
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self deleteWithIndexPath:indexPath];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelEditWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)deleteWithIndexPath:(NSIndexPath *)indexPath {
    
    MessageListModel *model = self.items[indexPath.row];
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    NSDictionary *dict = @{@"record_id":model.recordId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"删除消息";
    [manager POST:API_MessageDelete parameters:dict completion:^(id data, NSError *error){
        if (!error) {
            hud.labelText = @"删除功能";
            [hud hide:YES afterDelay:0.3];
            [self deleteSuccessedWithIndexPath:indexPath];
        } else {
            hud.labelText = @"删除失败";
            [hud hide:YES afterDelay:0.8];
        }
        
    }];
}

- (void)deleteSuccessedWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array removeObjectAtIndex:indexPath.row];
    self.items = array;
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

@end