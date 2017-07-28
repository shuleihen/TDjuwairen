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
#import "LoginStateManager.h"
#import "MBProgressHUD.h"
#import "AliveRoomViewController.h"
#import "AliveMasterListTabelViewDelegate.h"

@interface AliveNoAttentionTableViewController ()
@property (strong, nonatomic) NSMutableArray *item;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) AliveMasterListTabelViewDelegate *tableViewDelegate;
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

- (AliveMasterListTabelViewDelegate *)tableViewDelegate {
    if (!_tableViewDelegate) {
        _tableViewDelegate = [[AliveMasterListTabelViewDelegate alloc] initWithTableView:self.tableView withViewController:self];
        _tableViewDelegate.listType = kAliveAttentionList;
    }
    return _tableViewDelegate;
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
            weakSelf.tableViewDelegate.itemList = weakSelf.item;
        } else {
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
