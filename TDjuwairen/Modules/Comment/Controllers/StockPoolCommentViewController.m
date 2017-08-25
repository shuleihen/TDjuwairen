//
//  StockPoolCommentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolCommentViewController.h"
#import "TDStockPoolCommentTableViewDelegate.h"

@interface StockPoolCommentViewController ()
@property (nonatomic, strong) TDCommentTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation StockPoolCommentViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    TDStockPoolCommentTableViewDelegate *model = [[TDStockPoolCommentTableViewDelegate alloc] initWithTableView:self.tableView controller:self];
    model.masterId = self.masterId;
    self.tableViewDelegate = model;
    [self.tableViewDelegate refreshData];
}

@end
