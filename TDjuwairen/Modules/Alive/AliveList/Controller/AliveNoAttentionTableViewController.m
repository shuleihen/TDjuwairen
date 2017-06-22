//
//  AliveNoAttentionTableViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveNoAttentionTableViewController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "AliveMasterListTableViewCell.h"
#import "AliveMasterModel.h"
#import "LoginState.h"
#import "MBProgressHUD.h"
#import "AliveRoomViewController.h"

@interface AliveNoAttentionTableViewController ()
@property (strong, nonatomic) NSMutableArray *item;
@property (strong, nonatomic) UIView *headerView;
@end

@implementation AliveNoAttentionTableViewController

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 212)];
        _headerView.backgroundColor = TDViewBackgrouondColor;
        
        UIImage *image = [UIImage imageNamed:@"view_nothing.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-image.size.width)/2, 37, image.size.width, image.size.height)];
        imageView.image = image;
        [_headerView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+16, kScreenWidth, 16)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"#999999"];
        label.text = @"没有任何动态，关注下其他伙伴吧~";
        [_headerView addSubview:label];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(label.frame)+48, kScreenWidth-54, 1)];
        sep.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#979797"];
        [_headerView addSubview:sep];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, CGRectGetMaxY(label.frame)+40, 80, 18)];
        label2.font = [UIFont systemFontOfSize:16];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor hx_colorWithHexRGBAString:@"#666666"];
        label2.text = @"推荐关注";
        label2.backgroundColor = TDViewBackgrouondColor;
        [_headerView addSubview:label2];
    }
    
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 100;
    self.tableView.separatorColor = TDSeparatorColor;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = TDViewBackgrouondColor;
    
    [self requestData];
}


- (void)requestData {
    
    __weak typeof(self)weakSelf = self;
    NetworkManager *ma = [[NetworkManager alloc] init];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64)/2);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    [ma GET:API_AliveGetActivityMaster parameters:nil completion:^(id data, NSError *error){
        
        [indicator stopAnimating];
        
        if (!error) {
            NSArray *dataArray = data;
            
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:[dataArray count]];
            
            for (NSDictionary *d in dataArray) {
                AliveMasterModel *model = [[AliveMasterModel alloc] initWithDictionary:d];
                [list addObject:model];
            }

            weakSelf.item = list;
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            [weakSelf.tableView reloadData];
        } else {
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            [weakSelf.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AliveMasterListTableViewCell *cell = [AliveMasterListTableViewCell loadAliveMasterListTableViewCell:tableView];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    AliveMasterModel *model = self.item[indexPath.row];
    cell.aliveModel = model;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AliveMasterModel *model = self.item[indexPath.row];
    if (model.masterId.length <= 0) {
        return;
    }
    
    AliveRoomViewController *vc = [[AliveRoomViewController alloc] initWithMasterId:model.masterId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
