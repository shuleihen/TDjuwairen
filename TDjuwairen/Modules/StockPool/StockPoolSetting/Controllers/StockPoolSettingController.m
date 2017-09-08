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
#import "StockPoolPriceModel.h"
#import "StockPoolFreeSettingViewController.h"
#import "SettingHandler.h"


#define kStockPoolSettingCellID @"kStockPoolSettingCellID"


@interface StockPoolSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (copy, nonatomic) NSString *introduceStr;
@property (nonatomic, strong) StockPoolPriceModel *priceModel;

@end

@implementation StockPoolSettingController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = TDViewBackgrouondColor;
        _tableView.separatorColor = TDSeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44.0f;
        _tableView.tableFooterView = [UIView new];
        
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = TDViewBackgrouondColor;
    [self.view addSubview:self.tableView];
    
    self.introduceStr = @"";
    
    [self loadStockPoolIntroductMessage];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadStockPoolPriceType];
}


- (void)loadStockPoolIntroductMessage {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    __weak typeof(self)wSelf = self;
    [manager GET:API_StockPoolGetDesc parameters:nil completion:^(id data, NSError *error) {
        
        if (!error) {
            wSelf.introduceStr = data[@"desc"];
            [wSelf.tableView reloadData];
        }
    }];
}

- (void)loadStockPoolPriceType {
    NetworkManager *manager = [[NetworkManager alloc] init];
    
    [manager GET:API_StockPoolGetPrice parameters:nil completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            if (data != nil) {
                self.priceModel = [[StockPoolPriceModel alloc] initWithDict:data];
                [self.tableView reloadData];
            }
        }
    }];
}


#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockPoolSettingCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StockPoolSettingCellID"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = TDTitleTextColor;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.textColor = TDDetailTextColor;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"股票池介绍";
        cell.detailTextLabel.text = self.introduceStr;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"收费方式";
        if (self.priceModel.isFree) {
            cell.detailTextLabel.text = @"免费";
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@把钥匙/月",self.priceModel.key_num];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:@"icon_arrow.png"];
        cell.accessoryView = imageView;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AliveCommentViewController *editVC = [[AliveCommentViewController alloc] init];
        editVC.vcType = CommentVCStockPoolSettingType;
        __weak typeof(self)weakSelf = self;
        editVC.commentBlock = ^(){
            [SettingHandler addSettingStockPoolDesc];
            [[NSNotificationCenter defaultCenter] postNotificationName:kStockPoolDescSettingNotification object:nil];
            [weakSelf loadStockPoolIntroductMessage];
        };
        [self.navigationController pushViewController:editVC animated:YES];
    } else if (indexPath.section == 1) {
    
        StockPoolFreeSettingViewController *chagerVC = [[StockPoolFreeSettingViewController alloc] init];
        chagerVC.priceModel = self.priceModel;
        [self.navigationController pushViewController:chagerVC animated:YES];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerV = [[UIView alloc] init];
        footerV.backgroundColor = [UIColor clearColor];
        return footerV;
    } else {
        UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        footerV.backgroundColor = [UIColor clearColor];
        
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, kScreenWidth-24, 35)];
        desLabel.textColor = TDDetailTextColor;
        desLabel.font = [UIFont systemFontOfSize:13.0];
        desLabel.numberOfLines = 0;
        desLabel.text = @"例：1把钥匙/月，支付1把钥匙即可查阅我的所有股票池记录，有效期：一个月";
        [footerV addSubview:desLabel];
        
        return footerV;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else if (section == 1){
        return 45;
    }
    
    return 0;
}

@end
