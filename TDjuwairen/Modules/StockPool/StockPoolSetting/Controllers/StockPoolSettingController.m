//
//  StockPoolSettingController.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "StockPoolSettingController.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "StockPoolSettingCell.h"
#import "AliveCommentViewController.h"
#import "NetworkManager.h"
#import "StockPoolChargeTypeController.h"


#define kStockPoolSettingCellID @"kStockPoolSettingCellID"

@interface StockPoolSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArr;
@property (copy, nonatomic) NSString *introduceStr;
@property (copy, nonatomic) NSString *billingTypeStr;
@property (assign, nonatomic) BOOL isBilling;

@end

@implementation StockPoolSettingController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44.0f;
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefesh)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActions)];
        
    }
    
    return _tableView;
}
- (NSArray *)titleArr {
    
    if (_titleArr == nil) {
        _titleArr = [NSArray arrayWithObjects:@"股票池设置",@"免费查看股票池",@"收费方式",nil];
    }
    return _titleArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = TDViewBackgrouondColor;
    [self.view addSubview:self.tableView];
    self.introduceStr = @"";
    self.billingTypeStr = @"";
    self.isBilling = YES;
    [self loadStockPoolIntroductMessage];
    [self loadStockPoolPriceType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma - 加载数据
/** 刷新 */
- (void)onRefesh {
    self.billingTypeStr = @"1把钥匙／3天";
    [self.tableView reloadData];
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.tableView.header endRefreshing];
}

/** 加载更多 */
- (void)loadMoreActions {
    
}

/** 加载股票池简介 */
- (void)loadStockPoolIntroductMessage {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    __weak typeof(self)wSelf = self;
    [manager GET:API_StockPoolGetDesc parameters:nil completion:^(id data, NSError *error) {
        
        if (!error) {
            self.introduceStr = data[@"desc"];
            [self.tableView beginUpdates];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
            
        }
        
    }];

}


/** 加载股票池收费方式 */
- (void)loadStockPoolPriceType {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    [manager GET:API_StockPoolGetPrice parameters:nil completion:^(id data, NSError *error) {
        
        if (!error) {
            self.isBilling = data[@"pool_is_free"];
            self.billingTypeStr = data[@"pool_set_tip"];
            [self.tableView reloadData];
        }
        
    }];
    
}




#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isBilling == YES? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockPoolSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kStockPoolSettingCellID];
    if (cell == nil) {
        cell = [[StockPoolSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStockPoolSettingCellID];
    }
    if (indexPath.section == 0) {
        cell.sDescTextView.text = self.introduceStr;
    }else if (indexPath.section == 1) {
        cell.sSwitch.hidden = NO;
        cell.sSwitch.on = !self.isBilling;
    }else if (indexPath.section == 2) {
        cell.billingLabel.text = self.billingTypeStr;
    }else {
        cell.sDescTextView.text = @"";
        cell.billingLabel.text = @"";
        cell.sSwitch.hidden = YES;
        
    }
    cell.sTitleLabel.text = self.titleArr[indexPath.section];
    __weak typeof(self)weakSelf = self;
    cell.changeBillingBlock = ^() {
        weakSelf.isBilling = !weakSelf.isBilling;
        [weakSelf.tableView reloadData];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AliveCommentViewController *editVC = [[AliveCommentViewController alloc] init];
        editVC.vcType = CommentVCStockPoolSettingType;
        __weak typeof(self)weakSelf = self;
        editVC.commentBlock = ^(){
            [weakSelf loadStockPoolIntroductMessage];
            
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }else if (indexPath.section == 2) {
    
        StockPoolChargeTypeController *chagerVC = [[StockPoolChargeTypeController alloc] init];
        [self.navigationController pushViewController:chagerVC animated:YES];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = [UIColor clearColor];
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = TDDetailTextColor;
    desLabel.font = [UIFont systemFontOfSize:13.0];
    desLabel.numberOfLines = 0;
    desLabel.hidden = section != 2;
    [footerV addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerV).mas_offset(15);
        make.right.equalTo(footerV).mas_offset(-15);
        make.top.bottom.equalTo(footerV);
    }];
    
    if (section == 1) {
        desLabel.text = @"不允许其他用户查看我的股票池";
    }else if (section == 2) {
        desLabel.text = @"他人支付1把钥匙即可查阅我的所有股票池记录\n有效期：3天（不含购买当天）";
        
    }else {
        [desLabel removeFromSuperview];
    }
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [StockPoolSettingCell loadStockPoolSettingCellHeight:self.introduceStr];
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 45;
    }else {
        return 10;
    }
}





@end
