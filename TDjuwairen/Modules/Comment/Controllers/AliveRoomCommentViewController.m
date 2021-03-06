//
//  StockPoolCommentViewController.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/22.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomCommentViewController.h"
#import "TDStockPoolCommentTableViewDelegate.h"
#import "UIViewController+NoData.h"
#import "AliveCommentViewController.h"


@interface AliveRoomCommentViewController ()
@property (nonatomic, strong) TDCommentTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat contentViewH;
@end


@implementation AliveRoomCommentViewController

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    UIView *headerV = [[UIView alloc] init];
    headerV.frame = CGRectMake(0, 0, kScreenWidth, 55);
    headerV.layer.borderWidth = 1;
    headerV.layer.borderColor = TDSeparatorColor.CGColor;
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, kScreenWidth-24, 35)];
    [btn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, kScreenWidth-24, 35)];
    lable.textColor = TDDetailTextColor;
    lable.font = [UIFont systemFontOfSize:14.0f];
    lable.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f8f8f8"];
    lable.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"#DFDFDF"].CGColor;
    lable.layer.borderWidth = 1;
    lable.text = @"  留个言吧…";
    
    [headerV addSubview:lable];
    [headerV addSubview:btn];
    self.tableView.tableHeaderView = headerV;
    
    
    [self setupNoDataFrame:CGRectMake(0, 55, kScreenWidth, 200) Image:[UIImage imageNamed:@"no_result.png"] message:@"还没有任何动态哦~"];
    
    __weak typeof(self)weakSelf = self;
    TDStockPoolCommentTableViewDelegate *model = [[TDStockPoolCommentTableViewDelegate alloc] initWithTableView:self.tableView controller:self];
    model.commentType = kCommentAliveRoom;
    model.reloadBlock = ^(CGFloat tableViewH, BOOL noData) {
        [weakSelf showNoDataView:noData];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(commentListLoadComplete)]) {
            weakSelf.contentViewH = tableViewH+55;
            weakSelf.tableView.frame = CGRectMake(0, weakSelf.tableView.frame.origin.y, kScreenWidth, weakSelf.contentViewH);
            [weakSelf.delegate commentListLoadComplete];
        }
    };
    model.masterId = self.masterId;
    self.tableViewDelegate = model;
    [self.tableViewDelegate refreshData];
}

#pragma mark - commentBtnClick
- (void)commentBtnClick:(UIButton *)sender {
    AliveCommentViewController *messageBoard = [[AliveCommentViewController alloc] init];
    messageBoard.vcType = CommentVCPublishMessageBoard;
    messageBoard.alive_ID = self.masterId;
    [self.navigationController pushViewController:messageBoard animated:YES];

}

- (CGFloat)contentViewControllerHeight {
    return self.contentViewH;
}


- (void)onRefesh {
    [self.tableViewDelegate refreshData];
}

- (void)loadMore {
    [self.tableViewDelegate loadMoreData];
}

@end
